FUNCTION ZEA_FI_PP.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_MATNR) TYPE  ZEA_MATNR
*"     REFERENCE(IV_FNPD) TYPE  ZEA_FNPD
*"     REFERENCE(IV_AUFNR) TYPE  ZEA_AUFNR
*"     REFERENCE(IV_PDBAN) TYPE  ZEA_PDBAN
*"     REFERENCE(IV_TSDAT) TYPE  ZEA_TSDAT
*"  EXPORTING
*"     REFERENCE(EV_BELNR) TYPE  ZEA_BELNR
*"----------------------------------------------------------------------
*   [생성일자 : 2024-04-21]  [생성자 : 이세영]
*   [함수설명]
*   생산품 검수 완료 단계 시 호출하여 SA유형의 전표를 발생
*   [40] 완제품 계정(CDC Plant) - (MM-완제품 단가)  *  (생산실적-FNPD)
*   [50] 원자재 계정            - (대차평균의 원리에 따라 SAME AMOUNT)
*"----------------------------------------------------------------------
*                        Set Value For Variant
*"----------------------------------------------------------------------
  CLEAR: GS_BKPF, GS_BSEG.
  REFRESH: GT_BKPF, GT_BSEG.

* -- 0. [FI] 전표번호 채번
  PERFORM NR_ZEA_BELNR CHANGING GV_BELNR_NUMBER.  " 전표번호 채번


* -- 1. [MM] 자재명 Select
  DATA LV_MAKTX TYPE ZEA_MMT020-MAKTX.    "자재명Text-자재명 보관변수

  SELECT SINGLE * FROM ZEA_MMT020   INTO ZEA_MMT020
                            WHERE MATNR EQ IV_MATNR.
  LV_MAKTX = ZEA_MMT020-MAKTX.

* -- 2. [MM] 완제품 원가 -SELECT
  " ZEA_MMT010 : [MM] 자재마스터 테이블
  " STPRS : [MM] 원가
  " Data Eelemt : ZEA_COST

  DATA LV_COST TYPE ZEA_MMT010-STPRS.               "자재마스터-원가

  SELECT SINGLE * FROM ZEA_MMT010   INTO ZEA_MMT010
                            WHERE MATNR EQ IV_MATNR.

  LV_COST = ZEA_MMT010-STPRS.                      "보관 변수에 원가 저장

* --4) 차변 Amount 계산
  DATA LV_AMOUNT TYPE ZEA_BSEG-DMBTR.
  LV_AMOUNT =  IV_FNPD * LV_COST.                  "분개에 사용될 AMOUNT 계산
*----------------------------------------------------------------------
*                            IMPORTING
*----------------------------------------------------------------------
* -- 0. MM => FI 전표발생 CHECK ---------------------------------------*

*  CHECK IV_MBLNR IS NOT INITIAL. " 자재문서 번호가 존재하는지 CHECK.

  " [MM] 생산 이후 입고처리 자재문서 유형 확인 필요
  "   그리고, 이를 PP에서 CALL하는 경우 자재문서 번호를 찾기 위해서
  "   PP가 생산 실적을 기록함과 동시에 + MM의 자재 문서 발행 함수를 CALL 해야 함.
  "   그리고, MM함수에서 채번된 자재입고 문서의 '자재문서 번호(PK)'를
  "   받아와서 확인해야 한다.
  "   MM 자재 문서 작업과 독립적으로 이루진다고 처리하면 해당 과정을
  "   간단하게 생략할 수 있다.
*  IF IV_VGART EQ ' '.
*  ENDIF.

* -- 1. FI 전표 헤더 생성 ---------------------------------------------*

  GS_BKPF-BUKRS = '1000'.
  GS_BKPF-BELNR = GV_BELNR_NUMBER.
  GS_BKPF-GJAHR = '2024'.
  GS_BKPF-BLART = 'WE'.        " 매입전표
  GS_BKPF-BLDAT = IV_TSDAT.    " [PP] 생산검수일자 => [FI] 헤더 - 증빙일자
  GS_BKPF-BUDAT = SY-DATUM.    " [FI] 헤더-전기일자
  GS_BKPF-BLTXT = '[PP] 생산전표' && '( 자재명 : ' && LV_MAKTX && ')'.
  GS_BKPF-XBLNR = IV_AUFNR.     " [PP] 생산오더ID  => [FI] 헤더 - 참조문서

  " 생성 관련 정보
  GS_BKPF-ERDAT = SY-DATUM. " 생성일자를 오늘로
  GS_BKPF-ERZET = SY-UZEIT. " 생성시간을 현재 시간으로
  GS_BKPF-ERNAM = 'ACA5-17'. " 생성자를 현재 로그인한 사용자ID

*-- SAVE ZEA_BKPF(전표헤더)
  IF SY-SUBRC EQ 0 .
    INSERT  ZEA_BKPF FROM GS_BKPF.
    MODIFY ZEA_BKPF FROM   ZEA_BKPF.
  ENDIF.

* -- 2. FI 전표 아이템 생성--------------------------------------------*
* -- 2-1. [40] 완제품 계정(CDC Plant) - (MM-완제품 단가)  *  (생산실적-FNPD)

  DO 4 TIMES.
    GS_BSEG-ITNUM = SY-INDEX. " Item 번호

    CASE GS_BSEG-ITNUM.
      WHEN 1.
        GS_BSEG-BUKRS = '1000'.
        GS_BSEG-BELNR = GV_BELNR_NUMBER.
        GS_BSEG-GJAHR = '2024'.
        GS_BSEG-BSCHL = '40'.                  " [FI] 전기키
        GS_BSEG-SAKNR = '100660'.              " [FI] G/L계정 (Recon) = CDC(제품)
        GS_BSEG-GLTXT = '제품 (Plant :CDC )'.  " [FI] G/L계정명

        GS_BSEG-DMBTR   = LV_AMOUNT.   " [MM] 완제품 단가*최종생산량
        GS_BSEG-D_WAERS = 'KRW'.       " [FI] 통화코드

        GS_BSEG-WRBTR   = LV_AMOUNT.   " [MM] 완제품 단가*최종생산량
        GS_BSEG-W_WAERS = 'KRW'.       " [FI] 통화코드


        GS_BSEG-MATNR   = IV_MATNR.    " [FI] 아이템 - 자재코드
        GS_BSEG-WERKS   = '10000'.     " [FI] 아이템 - 플랜트ID = (CDC)

        APPEND GS_BSEG TO GT_BSEG.

* -- 2-2.  [50] 원자재 계정 - (대차평균의 원리에 따라 SAME AMOUNT)
      WHEN 2.
        GS_BSEG-BUKRS = '1000'.
        GS_BSEG-BELNR = GV_BELNR_NUMBER.
        GS_BSEG-GJAHR = '2024'.
        GS_BSEG-BSCHL = '50'.                        " [FI] 전기키
        GS_BSEG-SAKNR = '512000'.                    " [FI] G/L계정 (원재료:비용계정)
        GS_BSEG-GLTXT = '매출원가(원재료)'.          " [FI] G/L계정명

        GS_BSEG-DMBTR   = LV_AMOUNT + ( IV_PDBAN * LV_COST ) .    " [MM] 금액 = SUM(원재료값) = 완제품 원가
        GS_BSEG-D_WAERS = 'KRW'.         " [FI] 통화코드

        GS_BSEG-WRBTR   = LV_AMOUNT + ( IV_PDBAN * LV_COST ) .    " [MM] 완제품 단가*최종생산량
        GS_BSEG-W_WAERS = 'KRW'.         " [FI] 통화코드

        GS_BSEG-MATNR   = IV_MATNR.      " [FI] 아이템 - 자재코드
        GS_BSEG-WERKS   = '10000'.       " [FI] 아이템 - 플랜트ID = (CDC)

        APPEND GS_BSEG TO GT_BSEG.

        WHEN 3.
           IF IV_PDBAN NE 0.
          GS_BSEG-BUKRS = '1000'.
          GS_BSEG-BELNR = GV_BELNR_NUMBER.
          GS_BSEG-GJAHR = '2024'.
          GS_BSEG-BSCHL = '40'.                " [FI] 전기키
          GS_BSEG-SAKNR = '513010'.            " [FI] G/L계정 (원재료:비용계정)
          GS_BSEG-GLTXT = '폐기비용'.          " [FI] G/L계정명

          GS_BSEG-DMBTR   = IV_PDBAN * LV_COST .    " [MM] 금액 = SUM(원재료값) = 완제품 원가
          GS_BSEG-D_WAERS = 'KRW'.                  " [FI] 통화코드

          GS_BSEG-WRBTR   = IV_PDBAN * LV_COST .   " [MM] 완제품 단가*최종생산량
          GS_BSEG-W_WAERS = 'KRW'.                 " [FI] 통화코드

          GS_BSEG-MATNR   = IV_MATNR.           " [FI] 아이템 - 자재코드
          GS_BSEG-WERKS   = '10000'.            " [FI] 아이템 - 플랜트ID = (CDC)

          APPEND GS_BSEG TO GT_BSEG.
           ENDIF.

    ENDCASE.
  ENDDO.
*----------------------------------------------------------------------
*                  SAVE TO ZEA_BKPF / ZEA_BSEG
*----------------------------------------------------------------------
  MODIFY ZEA_BSEG FROM TABLE GT_BSEG.

  MESSAGE GV_BELNR_NUMBER && '번 전표가 생성되었습니다. ' TYPE 'S'.

  COMMIT WORK AND WAIT.
*----------------------------------------------------------------------
*                          EXPORTING
*----------------------------------------------------------------------
*                        << FI => PP >>
  "Reference 번호로 사용하기 위한 전표 번호 Export
  EV_BELNR = GV_BELNR_NUMBER.  "전표번호 Exporting

ENDFUNCTION.
