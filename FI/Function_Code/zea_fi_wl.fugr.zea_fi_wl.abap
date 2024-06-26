FUNCTION ZEA_FI_WL.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IS_HEAD) TYPE  ZEA_MMT090
*"     REFERENCE(IT_ITEM) TYPE  ZEA_MMY100
*"  EXPORTING
*"     REFERENCE(EV_BELNR) TYPE  ZEA_BSEG-BELNR
*"----------------------------------------------------------------------
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IS_HEAD) TYPE  ZEA_MMT090
*"     REFERENCE(IT_ITEM) TYPE  ZEA_MMY100
*"  EXPORTING
*"     REFERENCE(EV_BELNR) TYPE  ZEA_BSEG-BELNR
*----------------------------------------------------------------------
*           MM 자재 문서 >  자재 이동에 대한 FI 문서 자동발생
*"----------------------------------------------------------------------
* [이동유형 정리]
  " [SD] 출하 플랜트에 대한 정보를 레콘계정을 변수로 넣는다. ----- > 완료 ( 601 )
  " [MM] 입출고 플랜트에 대한 정보를 레콘계정으로 변수를 넣는다. --> 완료 ( 311 )
  " [PP] CDC RDC 플랜트에 대한 정보를 레콘계정으로 변수를 넣는다. -> 완료 ( 131 )

* [테스트 진행이력]
  " 1. 2024.04.30 : SD ( 완료-성공 ) / MM ( PP-개발중 ) / PP ( PP-개발중 )
  " 2. 2024.05.04 : SD ( 아이템의 모든 데이터를 SUM 값 하는 오류 확인하여 수정중 )
  " 3. 2024.05.07 : SD ( 수정사항 반영완료 )
*"----------------------------------------------------------------------
  CLEAR: GS_BKPF, GS_BSEG.
  REFRESH: GT_BKPF, GT_BSEG.

* -- 전표번호 채번
  CALL FUNCTION 'ZEA_BELNR_NR'
    IMPORTING
      EV_NUMBER = GV_BELNR_NUMBER.
*----------------------------------------------------------------------
*                            SELECT DATA
*----------------------------------------------------------------------
* 헤더 : IS_HEAD / 아이템 : IT_ITEM
  IV_MBLNR = IS_HEAD-MBLNR .  " 자재문서 번호
  IV_BUDAT = IS_HEAD-BUDAT.   " 전기일자(자재문서 이동 발생일)

  LOOP AT IT_ITEM INTO GS_MMT100 WHERE MBLNR EQ IV_MBLNR.
*    GV_TOTAL   =  GV_TOTAL + GS_MMT100-DMBTR. " [MM] ITEM - 자재 총 금액
    IV_BWART   =  GS_MMT100-BWART.            " [MM] ITEM - 이동유형
    IV_PLANTFR =  GS_MMT100-PLANTFR.          " [MM] ITEM - 시작정보(플랜트)
    IV_PLANTTO =  GS_MMT100-PLANTTO.          " [MM] ITEM - 도착정보(플랜트)
    IV_DMBTR   =  GS_MMT100-DMBTR.            " [MM] ITEM - 통화금액 ( 총 통화금액 )
    IV_WAERS1  =  GS_MMT100-WAERS1.           " [MM] ITEM - 통화코드
    IV_VENCODE =  GS_MMT100-VENCODE.          " [MM] ITEM - 벤더코드
    IV_CUSCODE =  GS_MMT100-CUSCODE.          " [MM] ITEM - 고객코드
  ENDLOOP.

*----------------------------------------------------------------------
*                            IMPORTING
*----------------------------------------------------------------------
* -- 1. MM => FI 전표발생 CHECK ---------------------------------------*
*  CHECK GS_MMT090-MBLNR IS NOT INITIAL. " 자재문서 번호가 존재하는지 CHECK.

* -- 2. FI 전표 헤더 생성 ---------------------------------------------*

  " 데이터 생성
  GS_BKPF-BUKRS = '1000'.
  GS_BKPF-BELNR = GV_BELNR_NUMBER.
  GS_BKPF-GJAHR = SY-DATUM+0(4).
  GS_BKPF-BLART = 'WL'. " 자재이동
  GS_BKPF-BLDAT = IV_BUDAT.    " [MM] 전기일자 => [FI] 헤더 - 증빙일자
  GS_BKPF-BUDAT = IV_BUDAT.    " [MM] 증빙일자 => [FI] 헤더 - 전기일자
  GS_BKPF-ERNAM = 'ACA5-08'. " 생성자 이름
  GS_BKPF-ERDAT = SY-DATUM.  " 생성일
  GS_BKPF-ERZET = SY-UZEIT.  " 입력시간

  IF IV_VENCODE IS NOT INITIAL.
    GS_BKPF-BLTXT = '[MM] 자재이동' && ' (벤더사:' && IV_VENCODE && ' )'.
  ELSEIF IV_CUSCODE IS NOT INITIAL.
    GS_BKPF-BLTXT = '[MM] 자재이동' && ' (고객사:' && IV_CUSCODE && ' )'.
  ELSE.
    GS_BKPF-BLTXT = '[MM] 자재이동' && ' (직영점:' && IV_PLANTFR && ' -> 직영점: ' && IV_PLANTTO && ' )'.
  ENDIF.
  GS_BKPF-XBLNR = IV_MBLNR.     " [MM] 자재문서 번호 => [FI] 헤더 - 참조문서


* -- 3. FI 전표 아이템 생성 -------------------------------------------*
* -- 금액 변환 [BAPI]
*  CASE IV_WAERS1.
*    WHEN 'KRW'.
*      CALL FUNCTION 'BAPI_CURRENCY_CONV_TO_INTERNAL'
*        EXPORTING
*          AMOUNT_EXTERNAL      = IV_DMBTR
*          CURRENCY             = IV_WAERS1
*          MAX_NUMBER_OF_DIGITS = 23  "출력할 금액필드의 자릿수"
*        IMPORTING
*          AMOUNT_INTERNAL      = LV_AFTER_AMT.
*
*  ENDCASE.


  CASE IV_BWART. " [MM] 이동유형
* -- CASE1. 내부 이동 (생산창고 10000 -> 보관창고 10001 ) -------------*
*    WHEN '131'. " 생산창고[PP] : 내부이동 ( 생산창고 -> 보관창고 )
*    (131 번 유형은 사용하지 않음)
*
** --  Item Number 생성
*      DO 2 TIMES.
*        GS_BSEG-ITNUM = SY-INDEX. " Item 번호
*
** --  Item Number 에 따른 전표 생성
*        CASE GS_BSEG-ITNUM.
*          WHEN 1.
*
*            CLEAR: GV_RECON.
*            " 도착정보 플랜트의 제품 계정 코드 (S) - 보관창고
*            PERFORM GV_RECON USING GS_MMT100-PLANTFR
*                             CHANGING GV_RECON.
*
*            GS_BSEG-BUKRS = '1000'.
*            GS_BSEG-BELNR = GV_BELNR_NUMBER."[FI] 전표번호 (자동채번)
*            GS_BSEG-GJAHR = '2024'.
*            GS_BSEG-BSCHL = '40'.          " [FI] 전기키
*            GS_BSEG-SAKNR = GV_RECON.      " [FI] G/L계정 (Recon)
*            GS_BSEG-GLTXT = '[PP] 자재이동' && ' (Plant:' && IV_PLANTTO && ')'. " [FI] G/L계정명
*
*            GS_BSEG-DMBTR   = IV_DMBTR.     " [MM] 금액 => 도착정보(보관 Plant)의 총 금액
*            GS_BSEG-D_WAERS = IV_WAERS1.    " [MM] 통화코드
*            GS_BSEG-WRBTR   = IV_DMBTR.     " [MM] 금액
*            GS_BSEG-W_WAERS = IV_WAERS1.    " [MM] 통화코드
*            GS_BSEG-MATNR   = IV_MATNR.     " [MM] 자재코드 => [FI] 아이템 - 자재코드
*            GS_BSEG-WERKS   = IV_PLANTTO.   " [MM] 보관 플랜트ID(도착) => [FI] 아이템 - 플랜트ID
*
*            APPEND GS_BSEG TO GT_BSEG.
*
*          WHEN 2.
*
*            CLEAR: GV_RECON.
*            " 시작정보 플랜트의 제품 계정 코드 (H) - 생산창고
*            PERFORM GV_RECON USING GS_MMT100-PLANTFR
*                             CHANGING GV_RECON.
*
*            GS_BSEG-BUKRS = '1000'.
*            GS_BSEG-BELNR = GV_BELNR_NUMBER.
*            GS_BSEG-GJAHR = '2024'.
*            GS_BSEG-BSCHL = '50'.          " [FI] 전기키
*            GS_BSEG-SAKNR = GV_RECON.      " [FI] G/L계정 (Recon)
*            GS_BSEG-GLTXT = '[PP] 자재이동' && ' (Plant:' && IV_PLANTFR && ')'. " [FI] G/L계정명
*
*            GS_BSEG-DMBTR   = IV_DMBTR.     " [MM] 금액 => 출발정보(생산 Plant)의 금액
*            GS_BSEG-D_WAERS = IV_WAERS1.    " [MM] 통화코드
*            GS_BSEG-WRBTR   = IV_DMBTR.     " [MM] 금액
*            GS_BSEG-W_WAERS = IV_WAERS1.    " [MM] 통화코드
*            GS_BSEG-MATNR   = IV_MATNR.     " [MM] 자재코드 => [FI] 아이템 - 자재코드
*            GS_BSEG-WERKS   = IV_PLANTFR.   " [MM] 생산 플랜트ID(출고) => [FI] 아이템 - 플랜트ID
*
*            APPEND GS_BSEG TO GT_BSEG.
*        ENDCASE.
*
*      ENDDO.


* -- CASE2. 내부 이동 (A Plant -> B Plant [직영점] )-------------------*
    WHEN '311'. " 재고이전[MM] : 내부이동 ( 보관창고 <-> 보관창고)

* --  Item Number 생성
      DO 2 TIMES.
        GS_BSEG-ITNUM = SY-INDEX. " Item 번호

* --  Item Number 에 따른 전표 생성
        CASE GS_BSEG-ITNUM.
          WHEN 1.

            CLEAR: GV_RECON.
            " 출발정보 플랜트의 제품 계정 코드 (S)
            PERFORM GV_RECON USING GS_MMT100-PLANTTO
                             CHANGING GV_RECON.

            GS_BSEG-BUKRS = '1000'.
            GS_BSEG-BELNR = GV_BELNR_NUMBER.
            GS_BSEG-GJAHR = '2024'.
            GS_BSEG-BSCHL = '40'.          " [FI] 전기키
            GS_BSEG-SAKNR = GV_RECON.      " [FI] G/L계정 (Recon)
            GS_BSEG-GLTXT = '[MM] 제품' && ' (Plant:' && IV_PLANTTO && ')'. " [FI] G/L계정명

*     -- 자재 이동 시, 자재원가 차이 발생하지 않는다고 가정.
*     -- 따라서 출고 시 -> 입고 시 자산의 금액은 동일하다.
            GS_BSEG-DMBTR   = IV_DMBTR.     " [MM] 금액 => 도착정보(B Plant)의 금액
            GS_BSEG-D_WAERS = IV_WAERS1.    " [MM] 통화코드
            GS_BSEG-WRBTR   = IV_DMBTR.     " [MM] 금액
            GS_BSEG-W_WAERS = IV_WAERS1.    " [MM] 통화코드
            GS_BSEG-MATNR   = IV_MATNR.     " [MM] 자재코드 => [FI] 아이템 - 자재코드
            GS_BSEG-BPCODE  = IV_PLANTTO.   " [MM] BPCODE
            GS_BSEG-WERKS   = IV_PLANTTO.   " [MM] B 플랜트ID(도착) => [FI] 아이템 - 플랜트ID

            APPEND GS_BSEG TO GT_BSEG.

          WHEN 2.
            CLEAR: GV_RECON.
            " 출발정보 플랜트의 제품 계정 코드 (H)
            PERFORM GV_RECON USING GS_MMT100-PLANTFR
                             CHANGING GV_RECON.

            GS_BSEG-BUKRS = '1000'.
            GS_BSEG-BELNR = GV_BELNR_NUMBER.
            GS_BSEG-GJAHR = '2024'.
            GS_BSEG-BSCHL = '50'.          " [FI] 전기키
            GS_BSEG-SAKNR = GV_RECON.      " [FI] G/L계정 (Recon)
            GS_BSEG-GLTXT = '[MM] 제품' && ' (Plant:' && IV_PLANTFR && ')'. " [FI] G/L계정명

            GS_BSEG-DMBTR   = IV_DMBTR.     " [MM] 금액 => 출발정보(A Plant)의 금액
            GS_BSEG-D_WAERS = IV_WAERS1.    " [MM] 통화코드
            GS_BSEG-WRBTR   = IV_DMBTR.     " [MM] 금액
            GS_BSEG-W_WAERS = IV_WAERS1.    " [MM] 통화코드
            GS_BSEG-MATNR   = IV_MATNR.     " [MM] 자재코드 => [FI] 아이템 - 자재코드
            GS_BSEG-BPCODE  = IV_PLANTFR.   " [MM] BPCODE
            GS_BSEG-WERKS   = IV_PLANTFR.   " [MM] A 플랜트ID(출고)  => [FI] 아이템 - 플랜트ID

            APPEND GS_BSEG TO GT_BSEG.
        ENDCASE.

      ENDDO.




* -- CASE3. 외부 이동 ( 납품- WL 발생시점: 본사 => 거래처 )------------*
    WHEN '601'. " 완제품 출고[SD] : 외부이동 (도매)
      CLEAR: GV_RECON.
      " 출발정보 플랜트의 제품 계정 코드
      PERFORM GV_RECON USING GS_MMT100-PLANTFR
                       CHANGING GV_RECON.

* --  Item Number 생성
      DO 2 TIMES.
        GS_BSEG-ITNUM = SY-INDEX. " Item 번호

* --  Item Number 에 따른 전표 생성
        CASE GS_BSEG-ITNUM.
          WHEN 1.
            GS_BSEG-BUKRS = '1000'.
            GS_BSEG-BELNR = GV_BELNR_NUMBER.
            GS_BSEG-GJAHR = '2024'.
            GS_BSEG-BSCHL = '40'.        " [FI] 전기키
            GS_BSEG-SAKNR = '510040'.    " [FI] G/L계정 (Recon) = 매출원가
            GS_BSEG-GLTXT = '매출원가'.  " [FI] G/L계정명

            GS_BSEG-DMBTR   = IV_DMBTR.     " [MM] 금액
            GS_BSEG-D_WAERS = IV_WAERS1.    " [MM] 통화코드
            GS_BSEG-WRBTR   = IV_DMBTR.     " [MM] 금액 ( 모든 ITEM 의 총 금액 )
            GS_BSEG-W_WAERS = IV_WAERS1.    " [MM] 통화코드
*            GS_BSEG-MATNR   = IV_MATNR.    " [MM] 자재코드 => [FI] 아이템 - 자재코드 ( 자재코드가 여러 개인 경우가 있기에 생략함 )
            GS_BSEG-WERKS   = '10000'.      " [MM] 플랜트ID => 매출원가가 발생하는 플랜트ID = 본사

            APPEND GS_BSEG TO GT_BSEG.

          WHEN 2.
            GS_BSEG-BUKRS = '1000'.
            GS_BSEG-BELNR = GV_BELNR_NUMBER.
            GS_BSEG-GJAHR = '2024'.
            GS_BSEG-BSCHL = '50'.          " [FI] 전기키
            GS_BSEG-SAKNR = GV_RECON.      " [FI] G/L계정 (Recon)
            GS_BSEG-GLTXT = '[SD] 제품' && ' (Plant:' && IV_PLANTFR && ')'. " [FI] G/L계정명

            GS_BSEG-DMBTR   = IV_DMBTR.     " [MM] 금액
            GS_BSEG-D_WAERS = IV_WAERS1.    " [MM] 통화코드
            GS_BSEG-WRBTR   = IV_DMBTR.     " [MM] 금액
            GS_BSEG-W_WAERS = IV_WAERS1.    " [MM] 통화코드
*            GS_BSEG-MATNR   = IV_MATNR.    " [MM] 자재코드 => [FI] 아이템 - 자재코드 ( 자재코드가 여러 개인 경우가 있기에 생략함 )
            GS_BSEG-WERKS   = IV_PLANTFR.   " [MM] 플랜트ID => 출고가 발생하는 플랜트

            APPEND GS_BSEG TO GT_BSEG.
        ENDCASE.

      ENDDO.
*    WHEN . " 입고 ( 벤더 => 송장검증으로 대체 )

  ENDCASE.


*----------------------------------------------------------------------
*                  SAVE TO ZEA_BKPF / ZEA_BSEG
*----------------------------------------------------------------------
  INSERT  ZEA_BKPF FROM GS_BKPF.
  INSERT  ZEA_BSEG FROM TABLE GT_BSEG.


  IF SY-SUBRC EQ 0.
    COMMIT WORK AND WAIT.
*    MESSAGE GV_BELNR_NUMBER && '번 전표가 생성되었습니다. ' TYPE 'S'.
  ENDIF.

*----------------------------------------------------------------------
*                          EXPORTING
*----------------------------------------------------------------------
*                        << FI => MM >>
  EV_BELNR =  GV_BELNR_NUMBER. "전표번호 Exporting

ENDFUNCTION.
