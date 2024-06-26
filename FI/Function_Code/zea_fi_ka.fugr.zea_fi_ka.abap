FUNCTION ZEA_FI_KA .
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IS_HEAD) TYPE  ZEA_MMT160
*"  EXPORTING
*"     REFERENCE(EV_BELNR) TYPE  ZEA_BKPF-BELNR
*"----------------------------------------------------------------------
*----------------------------------------------------------------------
*             MM 송장 검증 > 구매 입고에 대한 FI 문서 자동발생
*----------------------------------------------------------------------
*** 준비사항
*----------------------------------------------------------------------
* 1. ZEA_MM_MMFG 함수에서 Exporting 테이블을 적어줘야한다. (총 금액이 있는 헤더만 사용할듯 : ZEA_MMT160)
* 2. 전표번호를 Exporting 값에 적어두었다. (EV_BELNR)
*----------------------------------------------------------------------
  "" [MM] STATUS 값은 'Y', 'N' 로 꼭 필요합니다.
  "" [MM] IV_ZLSCHYN. " 지급여부필드? => MM 에서 어떻게 표시를 하는지 확인이 필요합니다.
  ""      => 'X' 표시를 한다면? 자동으로 반제전표가 생겨야 하는 것인지.
  "" [MM] ZEA_MMT160 (HEADER) 와 ZEA_MMT170 (ITEM) 현재 아이템의 금액이 헤더에 총금액과 불일치합니다.
*"----------------------------------------------------------------------
  CLEAR: GS_BKPF, GS_BSEG.
  REFRESH: GT_BKPF, GT_BSEG.

  CALL FUNCTION 'ZEA_BELNR_NR'
    IMPORTING
      EV_NUMBER = GV_BELNR_NUMBER. " 전표번호 채번

*----------------------------------------------------------------------
*                            IMPORTING
*----------------------------------------------------------------------
*  IS_HEAD : 헤더 / IT_ITEM : 아이템

* -- 1. MM => FI 전표발생 CHECK ---------------------------------------*
*  CHECK IS_HEAD-STATUS EQ 'Y'. " [MM] 처리상태 - 'Y' 일때, 아래 전표생성 로직이 실행됨

* -- 2. FI 전표 헤더 생성 ---------------------------------------------*

  GS_BKPF-BUKRS = '1000'.
  GS_BKPF-BELNR = GV_BELNR_NUMBER.
  GS_BKPF-GJAHR = '2024'.
  GS_BKPF-BLART = 'KA'.           " [FI] 매입전표
  GS_BKPF-BLDAT = IS_HEAD-BLDAT.  " [MM] 증빙일자 => [FI] 헤더 - 증빙일자
  GS_BKPF-BUDAT = SY-DATUM.       " [MM] 증빙일자 => [FI] 헤더 - 전기일자
  GS_BKPF-BLTXT = '[MM] 송장전표' && ' (벤더사:' && IS_HEAD-VENCODE && ' )'.
  GS_BKPF-XBLNR = IS_HEAD-BELNR.  " [MM] 송장번호 => [FI] 헤더 - 참조문서
  " 송장검증 헤더의 송장번호는 BELNR 필드를 사용함.
  GS_BKPF-ERNAM = 'ACA5-08'.
  GS_BKPF-ERDAT = SY-DATUM.
  GS_BKPF-ERZET = SY-UZEIT.

* -- 3. FI 전표 아이템 생성 -------------------------------------------*

* 1) 환율 계산
  SELECT * FROM ZEA_TCURR INTO TABLE GT_TCURR
      WHERE TCURR EQ IS_HEAD-WAERS
        AND GDATU <= IS_HEAD-BLDAT
    ORDER BY GDATU DESCENDING.
  READ TABLE GT_TCURR INTO GS_TCURR INDEX 1.

* -- 금액 변환 [BAPI]
    " 값이 * 100 증가하여 BAPI 삽입함.
    CALL FUNCTION 'BAPI_CURRENCY_CONV_TO_INTERNAL'
      EXPORTING
        AMOUNT_EXTERNAL      = IS_HEAD-TOTCOST
        CURRENCY             = IS_HEAD-WAERS
        MAX_NUMBER_OF_DIGITS = 23  "출력할 금액필드의 자릿수"
      IMPORTING
        AMOUNT_INTERNAL      = LV_TOTCOST.

  IF GS_TCURR-UKURS NE 0.
*    GV_COVT_AMOUNT = IS_HEAD-TOTCOST * GS_TCURR-UKURS. " KRW 환산금액 = 외환금액(총합) * 환율
    "원본
*    GV_COVT_AMOUNT = LV_TOTCOST * GS_TCURR-UKURS.       " KRW 환산금액 = 외환금액(총합) * 환율
    " 0513 - 이세영 고쳐봄 ...
    GV_COVT_AMOUNT = LV_TOTCOST * GS_TCURR-UKURS / 100 .       " KRW 환산금액 = 외환금액(총합) * 환율
    " 0513 - 이세영 다시 원복
*    GV_COVT_AMOUNT = LV_TOTCOST * GS_TCURR-UKURS  .       " KRW 환산금액 = 외환금액(총합) * 환율
    " 0513 - 이세영 _ 금액에 나누기 100배 되어 나와서 다시 함.
*    GV_COVT_AMOUNT = LV_TOTCOST * GS_TCURR-UKURS * 100 .       " KRW 환산금액 = 외환금액(총합) * 환율
    " 0513 - 이세영 _ 원복시키기
*    GV_COVT_AMOUNT = LV_TOTCOST * GS_TCURR-UKURS  .       " KRW 환산금액 = 외환금액(총합) * 환율


  ELSE.
    MESSAGE '통화금액과 통화코드를 확인해주세요' TYPE 'E' DISPLAY LIKE 'I'.
  ENDIF.


* 2) BP 코드 조회
  SELECT SINGLE SAKNR FROM ZEA_SKB1 INTO LV_SAKNR
    WHERE BPCODE EQ IS_HEAD-VENCODE.

  IF SY-SUBRC EQ 0.
    GV_RECON = LV_SAKNR.
  ENDIF.

* 2) 아이템 생성
  DO 2 TIMES.
    GS_BSEG-ITNUM = SY-INDEX. " Item 번호

    CASE GS_BSEG-ITNUM.
      WHEN 1.
        GS_BSEG-BUKRS = '1000'.
        GS_BSEG-BELNR = GV_BELNR_NUMBER.
        GS_BSEG-GJAHR = SY-DATUM+0(4).
        GS_BSEG-BSCHL = '40'.               " [FI] 전기키 = 차변
        GS_BSEG-SAKNR = '100110'.           " [FI] G/L계정 : 원재료
        GS_BSEG-GLTXT = '[MM] 원재료 매입'. " [FI] G/L계정명
        GS_BSEG-BPCODE = IS_HEAD-VENCODE.   " [FI] BP코드
        GS_BSEG-WERKS = '10000'.            " [FI] 플랜트 : CDC

        " [MM] 통화코드
        CASE IS_HEAD-WAERS.
          WHEN 'KRW'.
            GS_BSEG-DMBTR   = IS_HEAD-TOTCOST. " [MM] 총매입금액
            GS_BSEG-D_WAERS = IS_HEAD-WAERS.   " [MM] KRW
            GS_BSEG-WRBTR   = IS_HEAD-TOTCOST.
            GS_BSEG-W_WAERS = IS_HEAD-WAERS.

          WHEN OTHERS.
            GS_BSEG-DMBTR   = IS_HEAD-TOTCOST.    " [MM] 지급금액 = USD-> KRW 환산금액
            GS_BSEG-D_WAERS = IS_HEAD-WAERS.
            GS_BSEG-WRBTR   = GV_COVT_AMOUNT .  " [MM] 총매입금액 (KRW)
            GS_BSEG-W_WAERS = 'KRW'.
        ENDCASE.
        APPEND GS_BSEG TO GT_BSEG.

      WHEN 2.
        GS_BSEG-BUKRS = '1000'.
        GS_BSEG-BELNR = GV_BELNR_NUMBER.
        GS_BSEG-GJAHR = SY-DATUM+0(4).
        GS_BSEG-BSCHL = '31'.               " [FI] 전기키 = 송장
        GS_BSEG-SAKNR = GV_RECON.           " [FI] G/L계정 (Recon) - VENDER CODE에 일치하는 계정
        GS_BSEG-GLTXT = '(A/P:' && IS_HEAD-VENCODE && ')'. " [FI] G/L계정명
        GS_BSEG-BPCODE = IS_HEAD-VENCODE.   " [FI] BP코드
        GS_BSEG-WERKS = '10000'.            " [FI] 플랜트 : CDC

        " [MM] 통화코드
        CASE IS_HEAD-WAERS.
          WHEN 'KRW'.
            GS_BSEG-DMBTR   = IS_HEAD-TOTCOST. " [MM] 총매입금액
            GS_BSEG-D_WAERS = IS_HEAD-WAERS.   " [MM] KRW
            GS_BSEG-WRBTR   = IS_HEAD-TOTCOST.
            GS_BSEG-W_WAERS = IS_HEAD-WAERS.

          WHEN OTHERS.
            GS_BSEG-DMBTR   = IS_HEAD-TOTCOST.    " [MM] 지급금액 = USD-> KRW 환산금액
            GS_BSEG-D_WAERS = IS_HEAD-WAERS.
            GS_BSEG-WRBTR   = GV_COVT_AMOUNT .  " [MM] 총매입금액 (KRW)
            GS_BSEG-W_WAERS = 'KRW'.
        ENDCASE.
        APPEND GS_BSEG TO GT_BSEG.
    ENDCASE.
  ENDDO.
*----------------------------------------------------------------------
*                  SAVE TO ZEA_BKPF / ZEA_BSEG
*----------------------------------------------------------------------
  INSERT  ZEA_BKPF FROM GS_BKPF.
  INSERT  ZEA_BSEG FROM TABLE GT_BSEG.

  IF SY-SUBRC EQ 0.
    COMMIT WORK AND WAIT.
    MESSAGE GV_BELNR_NUMBER && '번 전표가 생성되었습니다. ' TYPE 'S'.
  ENDIF.

*----------------------------------------------------------------------
*                          EXPORTING
*----------------------------------------------------------------------
*                        << FI => MM >>
  EV_BELNR =  GV_BELNR_NUMBER. "전표번호 Exporting
ENDFUNCTION.
