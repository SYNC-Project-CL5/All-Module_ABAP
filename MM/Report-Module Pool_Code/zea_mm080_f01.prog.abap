*&---------------------------------------------------------------------*
*& Include          ZEA_MM080_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form INITIALIZATION
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM INITIALIZATION.

  DATA: LV_CNT TYPE I VALUE '-1'.

*  CALL FUNCTION 'RE_ADD_MONTH_TO_DATE'
*    EXPORTING
*      MONTHS  = LV_CNT
*      OLDDATE = SY-DATUM
*    IMPORTING
*      NEWDATE = S_BUDAT-LOW.
  S_BUDAT-LOW = SY-DATUM(6) && '01'.

  CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
    EXPORTING
      DAY_IN            = S_BUDAT-LOW
    IMPORTING
      LAST_DAY_OF_MONTH = S_BUDAT-HIGH
    EXCEPTIONS
      DAY_IN_NO_DATE    = 1
      OTHERS            = 2.
  APPEND S_BUDAT."입고일

 "송장 일자(월말 고정)
  P_BLDAT = S_BUDAT-HIGH.

 "회사코드
  P_BUKRS = '1000'.

 "플랜트
  CLEAR: S_WERKS.
  S_WERKS-SIGN   = 'I'.
  S_WERKS-OPTION = 'EQ'.
  S_WERKS-LOW    = '10000'. "CDC
  S_WERKS-HIGH   = SPACE.
  APPEND S_WERKS.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form AT_SELECTION_SCREEN
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM AT_SELECTION_SCREEN.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form START_OF_SELECTION
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM START_OF_SELECTION.

  CLEAR: ZEA_LFA1-VENCODE.
  ZEA_LFA1-VENCODE = P_LIFNR.
  PERFORM GET_LIFR_DATA.

  READ TABLE S_BUDAT INDEX 1.
  ZEA_MMT160-BLDAT = S_BUDAT-HIGH.

  PERFORM GET_DATA TABLES GT_DISP1 "Header
                          GT_DISP2."Item

  IF GT_DISP1[] IS INITIAL.
    MESSAGE '데이터가 없습니다,' TYPE 'S' DISPLAY LIKE 'E'.
  ELSE.
    MESSAGE '조회되었습니다.' TYPE 'S'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form END_OF_SELECTION
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM END_OF_SELECTION.

  CALL SCREEN 0100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_ALV_OBJ1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CREATE_ALV_OBJ1 .

*-----------------------------------------------*
  PERFORM SET_FIELDCAT1 CHANGING GT_FCAT1.
  PERFORM SET_LAYOUT1   CHANGING GS_LAYO1.
  PERFORM SET_SORT1     CHANGING GT_SORT1.
*-----------------------------------------------*
  PERFORM SET_GRID_FIRST_DISPLAY1.
*-----------------------------------------------*

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM GET_DATA TABLES PT_H STRUCTURE GT_DISP1
                     PT_I STRUCTURE GT_DISP2.

  CLEAR: PT_H[], PT_I[].

  DATA: LR_INFO LIKE RANGE OF ZEA_MMT050-INFO_NO WITH HEADER LINE.

* 공급업체 정보레코드
  SELECT 'I'     AS SIGN,
         'EQ'    AS OPTION,
         INFO_NO AS LOW
    INTO CORRESPONDING FIELDS OF TABLE @LR_INFO
    FROM ZEA_MMT050
    WHERE VENCODE EQ @P_LIFNR.

* 구매오더
  SELECT A~ARIVDATE,
         B~*
    INTO CORRESPONDING FIELDS OF TABLE @GT_MMT150
    FROM ZEA_MMT140 AS A
    JOIN ZEA_MMT150 AS B
                       ON A~PONUM EQ B~PONUM
    WHERE B~INFO_NO IN @LR_INFO
    AND   B~PONUM   IN @S_PONUM
    AND   B~WERKS   IN @S_WERKS
    AND   B~MATNR   IN @S_MATNR.
  IF SY-SUBRC EQ 0.
*   자재문서
    SELECT A~BUDAT,
           B~*
      INTO CORRESPONDING FIELDS OF TABLE @GT_MMT100
      FROM ZEA_MMT090 AS A
      JOIN ZEA_MMT100 AS B
                         ON A~MBLNR EQ B~MBLNR
           FOR ALL ENTRIES IN @GT_MMT150
      WHERE B~PONUM EQ @GT_MMT150-PONUM "구매오더
      AND   A~BUDAT IN @S_BUDAT.        "입고일

    DELETE GT_MMT100 WHERE VENCODE NE P_LIFNR.
    SORT GT_MMT100 BY PONUM MATNR.

*   송장문서
    SELECT B~*
      INTO TABLE @DATA(LT_170)
      FROM ZEA_MMT160 AS A
      JOIN ZEA_MMT170 AS B
                         ON  A~BELNR EQ B~BELNR
                         AND A~GJAHR EQ B~GJAHR
           FOR ALL ENTRIES IN @GT_MMT150
      WHERE B~PONUM EQ @GT_MMT150-PONUM. "구매오더
    SORT LT_170 BY PONUM MATNR.

*   정보레코드
    SELECT *
      INTO TABLE @DATA(LT_050)
      FROM ZEA_MMT050
           FOR ALL ENTRIES IN @GT_MMT150
      WHERE INFO_NO EQ @GT_MMT150-INFO_NO.
    SORT LT_050 BY INFO_NO.
  ENDIF.

 "총금액
  DATA : BEGIN OF LT_MMT160_1 OCCURS 0,
           DMBTR LIKE GT_MMT100-DMBTR,
         END OF LT_MMT160_1.
 "지급완료 금액
  DATA : BEGIN OF LT_MMT160_2 OCCURS 0,
           DMBTR LIKE GT_MMT100-DMBTR,
         END OF LT_MMT160_2.
 "미지급 금액
  DATA : BEGIN OF LT_MMT160_3 OCCURS 0,
           DMBTR LIKE GT_MMT100-DMBTR,
         END OF LT_MMT160_3.

* Make Data
  LOOP AT GT_MMT150.

    LOOP AT GT_MMT100 WHERE PONUM EQ GT_MMT150-PONUM"임시 여러건일 경우 테스트를 위해....
                      AND   MATNR EQ GT_MMT150-MATNR.

     "Header
      CLEAR: PT_H.
      PT_H-MATNR   = GT_MMT100-MATNR.
      PT_H-MENGE   = GT_MMT100-MENGE.
      PT_H-MEINS   = GT_MMT100-MEINS.
      PT_H-TOTCOST = GT_MMT100-DMBTR.
      PT_H-WAERS   = GT_MMT100-WAERS1.
      COLLECT PT_H.

     "총금액
      LT_MMT160_1-DMBTR = PT_H-TOTCOST.
      COLLECT LT_MMT160_1.

      CLEAR: PT_I.
      MOVE-CORRESPONDING GT_MMT150 TO PT_I.

      SELECT SINGLE MAKTX
        INTO @PT_I-MAKTX
        FROM ZEA_MMT020
        WHERE MATNR EQ @GT_MMT150-MATNR."자재 내역
      PT_I-MENGE = GT_MMT150-CALQTY.    "수량
      PT_I-WRBTR = GT_MMT150-DMBTR.     "구매 단가

      PT_I-GJAHR = GT_MMT100-GJAHR.
      PT_I-MBLNR = GT_MMT100-MBLNR.
      PT_I-MBGNO = GT_MMT100-MBGNO.
      PT_I-BUDAT = GT_MMT100-BUDAT.

     "이미 생성된 PO는 송장문서 Mapping
      READ TABLE LT_170 INTO DATA(LS_170)
      WITH KEY PONUM = GT_MMT150-PONUM
               MATNR = GT_MMT150-MATNR
               BINARY SEARCH.
      IF SY-SUBRC EQ 0.
        PT_I-BELNR = LS_170-BELNR.
        PT_I-ICON  = ICON_OKAY.
      ENDIF.

      IF PT_I-BELNR IS NOT INITIAL."송장 생성 데이터
        "지급완료 금액
         LT_MMT160_2-DMBTR = PT_I-WRBTR.
         COLLECT LT_MMT160_2.
      ELSE."송장 미생성 데이터
        "미지급 금액
         LT_MMT160_3-DMBTR = PT_I-WRBTR.
         COLLECT LT_MMT160_3.
      ENDIF.

      APPEND PT_I.
    ENDLOOP.

  ENDLOOP.
  SORT PT_I BY MBLNR.

  LOOP AT PT_H.
    DATA(LV_TABIX) = SY-TABIX.
    SELECT SINGLE MAKTX
      INTO @PT_H-MAKTX
      FROM ZEA_MMT020
      WHERE MATNR EQ @PT_H-MATNR."자재 내역
*****    PT_H-CHKBOX = 'X'.
    MODIFY PT_H INDEX LV_TABIX.
  ENDLOOP.

 "총금액
  READ TABLE LT_MMT160_1 INDEX 1.
  ZEA_MMT160-TOTCOST = LT_MMT160_1-DMBTR.

 "지급완료 금액
  READ TABLE LT_MMT160_2 INDEX 1.
  ZEA_MMT100-DMBTR = LT_MMT160_2-DMBTR.

 "미지급 금액
  READ TABLE LT_MMT160_3 INDEX 1.
  ZEA_MMT150-DMBTR = LT_MMT160_3-DMBTR.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_INVOICE_DATA_TRN
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM MAKE_INVOICE_DATA.

  DATA : LV_BELNR  LIKE ZEA_MMT160-BELNR.
  PERFORM INVOICE_NUMBER CHANGING LV_BELNR.

  CLEAR: GT_MMT160[].
  PERFORM MAKE_INVOICE_HEADER_DATA TABLES GT_MMT160
                                   USING LV_BELNR.

  CLEAR: GT_MMT170[].
  PERFORM MAKE_INVOICE_ITEM_DATA TABLES GT_MMT170
                                 USING LV_BELNR.

  PERFORM SAVE_INVOICE_DATA.

  DATA : LV_FI_BELNR TYPE ZEA_BKPF-BELNR.
  PERFORM MAKE_FI_DOCUMENT TABLES GT_MMT160
                           CHANGING LV_BELNR.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form INVOICE_NUMBER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LV_BELNR
*&---------------------------------------------------------------------*
FORM INVOICE_NUMBER  CHANGING C_BELNR.

  DATA : NR_RANGE_NR  LIKE  INRI-NRRANGENR.
  DATA : OBJECT       LIKE  INRI-OBJECT.
  DATA : QUANTITY     LIKE  INRI-QUANTITY.
  DATA : LV_NUM       TYPE  I.

  CLEAR: NR_RANGE_NR, OBJECT, QUANTITY.
  NR_RANGE_NR = '09'.
  OBJECT      = 'ZEA_MMNR'.
  QUANTITY    = 1.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      NR_RANGE_NR                   = NR_RANGE_NR
      OBJECT                        = OBJECT
      QUANTITY                      = QUANTITY
    IMPORTING
      NUMBER                        = LV_NUM
    EXCEPTIONS
      INTERVAL_NOT_FOUND            = 1
      NUMBER_RANGE_NOT_INTERN       = 2
      OBJECT_NOT_FOUND              = 3
      QUANTITY_IS_0                 = 4
      QUANTITY_IS_NOT_1             = 5
      INTERVAL_OVERFLOW             = 6
      BUFFER_OVERFLOW               = 7
      OTHERS                        = 8.
  IF SY-SUBRC EQ 0.
    C_BELNR = LV_NUM.
    CONDENSE C_BELNR NO-GAPS."공백제거
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SAVE_INVOICE_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SAVE_INVOICE_DATA.

  DATA: LV_CNT1 TYPE N LENGTH 5.
  DATA: LV_CNT2 TYPE N LENGTH 5.
  DATA: LV_MSG TYPE STRING.

  IF GT_MMT160[] IS NOT INITIAL.
    DESCRIBE TABLE GT_MMT160 LINES LV_CNT1.
    INSERT ZEA_MMT160 FROM TABLE GT_MMT160
    ACCEPTING DUPLICATE KEYS.
    IF SY-SUBRC NE 0.
      ROLLBACK WORK.
    ELSE.
      COMMIT WORK.
    ENDIF.
    CONCATENATE '송장문서 생성완료.' '(헤더:' LV_CNT1 INTO LV_MSG.
  ENDIF.

  IF GT_MMT170[] IS NOT INITIAL.
    DESCRIBE TABLE GT_MMT170 LINES LV_CNT2.
    INSERT ZEA_MMT170 FROM TABLE GT_MMT170
    ACCEPTING DUPLICATE KEYS.
    IF SY-SUBRC NE 0.
      ROLLBACK WORK.
    ELSE.
      COMMIT WORK.
    ENDIF.
    CONCATENATE LV_MSG '아이템:' LV_CNT2 ')' INTO LV_MSG.
  ENDIF.

  MESSAGE LV_MSG TYPE 'I' DISPLAY LIKE 'S'.

  PERFORM REFRESH_TABLE_DISPLAY.
  CALL METHOD CL_GUI_CFW=>FLUSH.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_INVOICE_HEADER_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_MMT160
*&---------------------------------------------------------------------*
FORM MAKE_INVOICE_HEADER_DATA TABLES PT_TAB STRUCTURE GT_MMT160
                              USING PV_BELNR.

  CLEAR: PT_TAB.
  PT_TAB-BELNR   = PV_BELNR.           "송장문서번호
  PT_TAB-GJAHR   = SY-DATUM(4).        "회계연도
  PT_TAB-BUKRS   = P_BUKRS.            "회사코드
  PT_TAB-BLDAT   = ZEA_MMT160-BLDAT.   "송장 전기일
  PT_TAB-VENCODE = ZEA_LFA1-VENCODE.   "송장 발행처
  PT_TAB-ZLSCH   = ZEA_LFA1-ZLSCH.     "지급조건
  PT_TAB-TOTCOST = ZEA_MMT160-TOTCOST. "총매입금액
  PT_TAB-WAERS   = ZEA_MMT160-WAERS.   "통화
  PT_TAB-BKTXT   = ZEA_MMT160-BKTXT.   "송장 헤더텍스트

***  PT_TAB-STATUS  = "처리상태
***  PT_TAB-ZLSCHYN = "지급여부
***  PT_TAB-SPGRP   = "보류사유

  PT_TAB-ERNAM = PT_TAB-AENAM = SY-UNAME.
  PT_TAB-ERDAT = PT_TAB-AEDAT = SY-DATUM.
  PT_TAB-ERZET = PT_TAB-AEZET = SY-UZEIT.
  APPEND PT_TAB.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_INVOICE_ITEM_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_MMT170
*&---------------------------------------------------------------------*
FORM MAKE_INVOICE_ITEM_DATA TABLES PT_TAB STRUCTURE GT_MMT170
                            USING PV_BELNR.

  DATA : LV_TABIX LIKE SY-TABIX.

  LOOP AT GT_DISP2 WHERE BELNR EQ SPACE.
    LV_TABIX = SY-TABIX.

    PT_TAB-BELNR = PV_BELNR.          "송장문서번호
    PT_TAB-GJAHR = SY-DATUM(4).       "회계연도
    PT_TAB-BUZEI = PT_TAB-BUZEI + 10. "송장품목번호
    PT_TAB-BUKRS = P_BUKRS.           "회사코드
    PT_TAB-PONUM = GT_DISP2-PONUM.    "구매오더번호
    PT_TAB-EBELP = GT_DISP2-EBELP.    "구매오더품목번호
    PT_TAB-MATNR = GT_DISP2-MATNR.    "자재코드
    PT_TAB-WERKS = GT_DISP2-WERKS.    "플랜트
    PT_TAB-MENGE = GT_DISP2-MENGE.    "수량
    PT_TAB-MEINS = GT_DISP2-MEINS.    "단위
    PT_TAB-WRBTR = GT_DISP2-WRBTR.    "매입단가
    PT_TAB-WAERS = GT_DISP2-WAERS.    "통화
    PT_TAB-ERNAM = PT_TAB-AENAM = SY-UNAME.
    PT_TAB-ERDAT = PT_TAB-AEDAT = SY-DATUM.
    PT_TAB-ERZET = PT_TAB-AEZET = SY-UZEIT.
    APPEND PT_TAB.

    GT_DISP2-BELNR = PV_BELNR.
    GT_DISP2-ICON  = ICON_OKAY.
    MODIFY GT_DISP2 INDEX LV_TABIX.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_FI_DOCUMENT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_MMT160
*&---------------------------------------------------------------------*
FORM MAKE_FI_DOCUMENT TABLES PT_HEAD STRUCTURE GT_MMT160
                      CHANGING C_BELNR.

  LOOP AT PT_HEAD.
    CALL FUNCTION 'ZEA_FI_KA'
    EXPORTING IS_HEAD  = PT_HEAD
    IMPORTING EV_BELNR = C_BELNR.
  ENDLOOP.

ENDFORM.
