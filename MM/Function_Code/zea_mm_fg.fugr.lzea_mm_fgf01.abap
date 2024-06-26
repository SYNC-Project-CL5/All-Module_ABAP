*----------------------------------------------------------------------*
***INCLUDE LZEA_MM_FGF01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form NUMR
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM NUMR.

  DATA : NR_RANGE_NR  LIKE  INRI-NRRANGENR.
  DATA : OBJECT       LIKE  INRI-OBJECT.
  DATA : QUANTITY     LIKE  INRI-QUANTITY.
  DATA : GV_NUM       TYPE  I.

  CLEAR: NR_RANGE_NR, OBJECT, QUANTITY.
  NR_RANGE_NR = '07'.
  OBJECT      = 'ZEA_MMNR'.
  QUANTITY    = 1.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      NR_RANGE_NR             = NR_RANGE_NR
      OBJECT                  = OBJECT
      QUANTITY                = QUANTITY
    IMPORTING
      NUMBER                  = ZEA_MMT100-MBLNR
    EXCEPTIONS
      INTERVAL_NOT_FOUND      = 1
      NUMBER_RANGE_NOT_INTERN = 2
      OBJECT_NOT_FOUND        = 3
      QUANTITY_IS_0           = 4
      QUANTITY_IS_NOT_1       = 5
      INTERVAL_OVERFLOW       = 6
      BUFFER_OVERFLOW         = 7
      OTHERS                  = 8.

***** Case 1 (Old Syntax)
*  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
*  EXPORTING INPUT  = ZEA_MMT010-MATNR
*  IMPORTING OUTPUT = ZEA_MMT010-MATNR.

***** Case 2 (New Syntax)
  ZEA_MMT100-MBLNR = |{ ZEA_MMT100-MBLNR ALPHA = OUT  }|.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_MBLNR_HEADER_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM MAKE_MBLNR_HEADER_DATA TABLES PT_090 STRUCTURE GT_MMT090
                            USING PS_STR STRUCTURE GS_MMT140
                            CHANGING PV_MBLNR.

  DATA : NR_RANGE_NR  LIKE  INRI-NRRANGENR.
  DATA : OBJECT       LIKE  INRI-OBJECT.
  DATA : QUANTITY     LIKE  INRI-QUANTITY.
  DATA : GV_NUM       TYPE  I.

  CLEAR: NR_RANGE_NR, OBJECT, QUANTITY.
  NR_RANGE_NR = '07'.
  OBJECT      = 'ZEA_MMNR'.
  QUANTITY    = 1.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      NR_RANGE_NR             = NR_RANGE_NR
      OBJECT                  = OBJECT
      QUANTITY                = QUANTITY
    IMPORTING
      NUMBER                  = PV_MBLNR
    EXCEPTIONS
      INTERVAL_NOT_FOUND      = 1
      NUMBER_RANGE_NOT_INTERN = 2
      OBJECT_NOT_FOUND        = 3
      QUANTITY_IS_0           = 4
      QUANTITY_IS_NOT_1       = 5
      INTERVAL_OVERFLOW       = 6
      BUFFER_OVERFLOW         = 7
      OTHERS                  = 8.

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
    EXPORTING
      INPUT  = PV_MBLNR
    IMPORTING
      OUTPUT = PV_MBLNR.

  CLEAR: PT_090.
  PT_090-MBLNR = PV_MBLNR.         "자재문서번호
  PT_090-GJAHR = SY-DATUM(4).      "회계연도
  PT_090-WERKS = '10000'."PS_STR-WERKS.     "플랜트
  PT_090-BUDAT = PS_STR-ARIVDATE.  "전기일 = PO 입고예정일
  PT_090-ERNAM = SY-UNAME.
  PT_090-ERDAT = SY-DATUM.
  PT_090-ERZET = SY-UZEIT.
  APPEND PT_090.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_MBLNR_ITEM_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM MAKE_MBLNR_ITEM_DATA TABLES PT_150 STRUCTURE GT_MMT100
                          USING PS_STR STRUCTURE GS_MMT150
                                PV_MBLNR.

  CLEAR: PT_150.
  PT_150-MBLNR   = PV_MBLNR.        "채번된 자재문서 번호
  PT_150-GJAHR   = SY-DATUM(4).     "회계연도
  PT_150-MBGNO   = PS_STR-EBELP.    "자재문서 품목번호
  PT_150-MATNR   = PS_STR-MATNR.    "자재코드
  PT_150-PONUM   = PS_STR-PONUM.    "구매오더번호
  PT_150-BWART   = '101'.           "이동유형

  PT_150-PLANTTO = '10000'.    "도착정보(플랜트)
*  SELECT SINGLE *
*    INTO @DATA(LV_SCODE)
*    FROM ZEA_MMT060
*    WHERE WERKS EQ @PT_150-PLANTTO.
  PT_150-LGORTTO = 'SL01'.        "저장위치(도착)

  PT_150-DMBTR   = PS_STR-DMBTR.    "통화금액(KRW)
  PT_150-WAERS1  = PS_STR-WAERS.    "통화코드
  PT_150-MENGE   = PS_STR-CALQTY.   "수량
  PT_150-MEINS   = PS_STR-MEINS.    "단위
  PT_150-GRUND   = '원자재 입고'.      "자재 이동사유

  SELECT SINGLE VENCODE
    INTO @DATA(LV_VENCODE)
    FROM ZEA_MMT050
    WHERE INFO_NO EQ @PS_STR-INFO_NO.
  PT_150-VENCODE = LV_VENCODE.      "[BP] 벤더코드
  PT_150-ERNAM = SY-UNAME.
  PT_150-ERDAT = SY-DATUM.
  PT_150-ERZET = SY-UZEIT.

  APPEND PT_150.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_MBLNR_HEADER_DATA_SD
*&---------------------------------------------------------------------*
FORM MAKE_MBLNR_HEADER_DATA_SD  TABLES   PT_090 STRUCTURE GT_MMT090
                                USING PS_STR STRUCTURE GS_SDT060
                                CHANGING PV_MBLNR.

  DATA : NR_RANGE_NR  LIKE  INRI-NRRANGENR.
  DATA : OBJECT       LIKE  INRI-OBJECT.
  DATA : QUANTITY     LIKE  INRI-QUANTITY.
  DATA : GV_NUM       TYPE  I.

  CLEAR: NR_RANGE_NR, OBJECT, QUANTITY.
  NR_RANGE_NR = '07'.
  OBJECT      = 'ZEA_MMNR'.
  QUANTITY    = 1.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      NR_RANGE_NR             = NR_RANGE_NR
      OBJECT                  = OBJECT
      QUANTITY                = QUANTITY
    IMPORTING
      NUMBER                  = PV_MBLNR
    EXCEPTIONS
      INTERVAL_NOT_FOUND      = 1
      NUMBER_RANGE_NOT_INTERN = 2
      OBJECT_NOT_FOUND        = 3
      QUANTITY_IS_0           = 4
      QUANTITY_IS_NOT_1       = 5
      INTERVAL_OVERFLOW       = 6
      BUFFER_OVERFLOW         = 7
      OTHERS                  = 8.


  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
    EXPORTING
      INPUT  = PV_MBLNR
    IMPORTING
      OUTPUT = PV_MBLNR.

  CLEAR: PT_090.
  PT_090-MBLNR = PV_MBLNR.      "자재문서번호
  PT_090-GJAHR = SY-DATUM(4).   "회계연도
  PT_090-WERKS = PS_STR-WERKS.  "플랜트
  PT_090-BUDAT = PS_STR-REDAT.  "전기일
  PT_090-ERNAM = SY-UNAME.
  PT_090-ERDAT = SY-DATUM.
  PT_090-ERZET = SY-UZEIT.
  APPEND PT_090.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_MBLNR_ITEM_DATA_SD
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_MMT100
*&      --> GS_SDT110
*&      --> ZEA_MMT090_MBLNR
*&---------------------------------------------------------------------*
FORM MAKE_MBLNR_ITEM_DATA_SD  TABLES   PT_110 STRUCTURE GT_MMT100
                              USING    PS_STR STRUCTURE GS_SDT110
                                        PV_MBLNR.
  CLEAR: PT_110.
  PT_110-MBLNR   = PV_MBLNR.            "채번된 자재문서 번호
  PT_110-GJAHR   = SY-DATUM(4).         "회계연도
  PT_110-MBGNO   = PS_STR-POSNR.        "자재문서 품목번호
  SELECT SINGLE CHARG
    FROM ZEA_MMT070 AS A
    WHERE A~MATNR = @PS_STR-MATNR
    INTO @DATA(LV_CHARG).
  PT_110-CHARG   = LV_CHARG.
  PT_110-MATNR   = PS_STR-MATNR.        "자재코드
  PT_110-SBELNR   = PS_STR-SBELNR.
  PT_110-BWART   = '601'.               "이동유형
  PT_110-PLANTFR = PS_STR-WERKS.        "도착정보(플랜트)

  SELECT SINGLE SCODE
    FROM ZEA_MMT060 AS A
    WHERE A~WERKS EQ @PS_STR-WERKS
    INTO @DATA(LV_SCODE).
  PT_110-LGORTFR = LV_SCODE.            "저장위치(도착)

  SELECT SINGLE STPRS
   FROM ZEA_MMT010
   INTO @DATA(LV_STPRS)
  WHERE MATNR EQ @PT_110-MATNR.
  PT_110-MENGE   = PS_STR-AUQUA.               "수량
  PT_110-MEINS   = PS_STR-MEINS.               "단위
  PT_110-DMBTR   = LV_STPRS * PS_STR-AUQUA.    "통화금액(KRW)
  PT_110-WAERS1  = 'KRW'.    "통화코드

  PT_110-GRUND   = '완제품 출고'.               "자재 이동사유
  SELECT SINGLE VENCODE
  INTO @DATA(LV_VENCODE)
  FROM ZEA_MMT050
  WHERE WERKS EQ @PS_STR-WERKS.
  PT_110-VENCODE = LV_VENCODE.                 "[BP] 벤더코드

  SELECT SINGLE CUSCODE
  INTO @DATA(LV_CUSCODE)
  FROM ZEA_KNA1
 WHERE CUSCODE EQ @PS_STR-CUSCODE.
  PT_110-CUSCODE = LV_CUSCODE.
  PT_110-ERNAM = SY-UNAME.
  PT_110-ERDAT = SY-DATUM.
  PT_110-ERZET = SY-UZEIT.
  APPEND PT_110.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_MBLNR_HEADER_DATA_PP
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_MMT090
*&      --> GS_AUFK
*&      <-- ZEA_MMT090_MBLNR
*&---------------------------------------------------------------------*
FORM MAKE_MBLNR_HEADER_DATA_PP  TABLES   PT_090 STRUCTURE GT_MMT090
                                USING    PS_STR STRUCTURE GS_AUFK
                                CHANGING PV_MBLNR.
  DATA : NR_RANGE_NR  LIKE  INRI-NRRANGENR.
  DATA : OBJECT       LIKE  INRI-OBJECT.
  DATA : QUANTITY     LIKE  INRI-QUANTITY.
  DATA : GV_NUM       TYPE  I.

  CLEAR: NR_RANGE_NR, OBJECT, QUANTITY.
  NR_RANGE_NR = '07'.
  OBJECT      = 'ZEA_MMNR'.
  QUANTITY    = 1.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      NR_RANGE_NR             = NR_RANGE_NR
      OBJECT                  = OBJECT
      QUANTITY                = QUANTITY
    IMPORTING
      NUMBER                  = PV_MBLNR
    EXCEPTIONS
      INTERVAL_NOT_FOUND      = 1
      NUMBER_RANGE_NOT_INTERN = 2
      OBJECT_NOT_FOUND        = 3
      QUANTITY_IS_0           = 4
      QUANTITY_IS_NOT_1       = 5
      INTERVAL_OVERFLOW       = 6
      BUFFER_OVERFLOW         = 7
      OTHERS                  = 8.


  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
    EXPORTING
      INPUT  = PV_MBLNR
    IMPORTING
      OUTPUT = PV_MBLNR.


  CLEAR: PT_090.
  PT_090-MBLNR = PV_MBLNR.      "자재문서번호
  PT_090-GJAHR = SY-DATUM(4).   "회계연도
  PT_090-WERKS = PS_STR-WERKS.  "플랜트
  PT_090-BUDAT = SY-DATUM.  "전기일
  PT_090-ERNAM = SY-UNAME.
  PT_090-ERDAT = SY-DATUM.
  PT_090-ERZET = SY-UZEIT.
  APPEND PT_090.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_MBLNR_ITEM_DATA_PP
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_MMT100
*&      --> GS_PPT020
*&      --> ZEA_MMT090_MBLNR
*&---------------------------------------------------------------------*
FORM MAKE_MBLNR_ITEM_DATA_PP  TABLES   PT_020 STRUCTURE GT_MMT100
                                       IT_ITEM STRUCTURE ZEA_MMT190 "추가?
                              USING    PS_STR STRUCTURE GS_PPT020
                                       PV_MBLNR.



  DATA: GS_MMT190 TYPE ZEA_MMT190.

*  BREAK-POINT.
  "
  LOOP AT IT_ITEM . "                         "
    PT_020-MATNR = IT_ITEM-MATNR.                              "
    PT_020-MBLNR = PV_MBLNR.
    PT_020-GJAHR = SY-DATUM(4).
    PT_020-MBGNO = SY-TABIX."PS_STR-ORDIDX.
    "PT_020-MATNR = ZEA_MMT100."PS_STR-MATNR.
    PT_020-AUFNR = PS_STR-AUFNR.
    PT_020-BWART = '261'.

    PT_020-PLANTFR = IT_ITEM-WERKS.
    PT_020-PLANTTO = IT_ITEM-WERKS.

    PT_020-LGORTFR = IT_ITEM-SCODE.
    PT_020-LGORTTO = IT_ITEM-SCODE.
*    PT_020-MENGE = PS_STR-RQTY.
    PT_020-MENGE = IT_ITEM-CALQTY.
    PT_020-MEINS = IT_ITEM-MEINS.
    SELECT SINGLE STPRS
  FROM ZEA_MMT010
  INTO @DATA(LV_STPRS)
  WHERE MATNR EQ @IT_ITEM-MATNR."@GS_DATA-MATNR.
    PT_020-DMBTR = LV_STPRS * IT_ITEM-CALQTY * 100.
    PT_020-GRUND = '원자재 투입'.
    PT_020-ERNAM = SY-UNAME.
    PT_020-ERDAT = SY-DATUM.
    PT_020-ERZET = SY-UZEIT.

    APPEND PT_020.
    CLEAR PT_020 .
  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_MBLNR_DATA_TFR
*&---------------------------------------------------------------------*
FORM MAKE_MBLNR_DATA_TFR .


  DATA : NR_RANGE_NR  LIKE  INRI-NRRANGENR.
  DATA : OBJECT       LIKE  INRI-OBJECT.
  DATA : QUANTITY     LIKE  INRI-QUANTITY.
  DATA : GV_NUM       TYPE  I.

  CLEAR: NR_RANGE_NR, OBJECT, QUANTITY.
  NR_RANGE_NR = '07'.
  OBJECT      = 'ZEA_MMNR'.
  QUANTITY    = 1.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      NR_RANGE_NR             = NR_RANGE_NR
      OBJECT                  = OBJECT
      QUANTITY                = QUANTITY
    IMPORTING
      NUMBER                  = GS_MMT090 "PV_MBLNR
    EXCEPTIONS
      INTERVAL_NOT_FOUND      = 1
      NUMBER_RANGE_NOT_INTERN = 2
      OBJECT_NOT_FOUND        = 3
      QUANTITY_IS_0           = 4
      QUANTITY_IS_NOT_1       = 5
      INTERVAL_OVERFLOW       = 6
      BUFFER_OVERFLOW         = 7
      OTHERS                  = 8.


  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
    EXPORTING
      INPUT  = GS_MMT090 "PV_MBLNR
    IMPORTING
      OUTPUT = GS_MMT090. "PV_MBLNR.

*  CLEAR: GT_MMT090.
  GT_MMT090-MBLNR = GS_MMT090."PV_MBLNR.      "자재문서번호
  GT_MMT090-GJAHR = SY-DATUM(4).   "회계연도
  GT_MMT090-WERKS = "GT_MMT190-WERKS.  "플랜트
  GT_MMT090-BUDAT = SY-DATUM(8).  "전기일
  APPEND GT_MMT090.

ENDFORM.
