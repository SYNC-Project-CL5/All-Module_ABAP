*&---------------------------------------------------------------------*
*& Include         ZEA_MM070_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form INITIALIZATION
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM INITIALIZATION .

  CLEAR: GT_DISP1, GT_DISP1[].
  CLEAR: GT_DISP2, GT_DISP2[].
*  CLEAR: GT_DISP3, GT_DISP3[].

ENDFORM.
*&---------------------------------------------------------------------*
*& Form START_OF_SELECTION
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM START_OF_SELECTION .

  PERFORM REFRESH_RTN.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form END_OF_SELECTION
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM END_OF_SELECTION .

  CALL SCREEN 0100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHANGE_RTN
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CHANGE_RTN.

  DATA : LV_RETURN TYPE C.
  DATA : LT_SVAL   TYPE STANDARD TABLE OF SVAL.

  LT_SVAL
  = VALUE #( (  TABNAME   = 'ZEA_MMT140'
                FIELDNAME = 'PONUM'
                FIELD_ATTR = '01'     ) ).

  CALL FUNCTION 'POPUP_GET_VALUES'
    EXPORTING
      POPUP_TITLE     = '구매오더 조회조건'
      START_COLUMN    = 15
      START_ROW       = 5
    IMPORTING
      RETURNCODE      = LV_RETURN
    TABLES
      FIELDS          = LT_SVAL
    EXCEPTIONS
      ERROR_IN_FIELDS = 1
      OTHERS          = 2.
  IF LV_RETURN EQ 'A'.
    MESSAGE '취소되었습니다.' TYPE 'S'.
    EXIT.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_RTN
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DISPLAY_RTN.

  DATA : LT_ROWS TYPE LVC_T_ROW.
  DATA : LS_ROWS TYPE LVC_S_ROW.

  CALL METHOD GO_GRID1->GET_SELECTED_ROWS
  IMPORTING ET_INDEX_ROWS = LT_ROWS.
  IF LT_ROWS[] IS INITIAL.
     MESSAGE '조회할 ROW를 선택하세요.' TYPE 'I' DISPLAY LIKE 'E'.
     EXIT.
  ENDIF.

  DATA(LV_CNT) = LINES( LT_ROWS ).
  IF LV_CNT > 1.
     MESSAGE '1건만 조회 가능합니다.' TYPE 'I' DISPLAY LIKE 'E'.
     EXIT.
  ENDIF.

***  CALL SCREEN 0110 STARTING AT 10  3
***                   ENDING   AT 111 35.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_TOOLBAR2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_OBJECT
*&      --> E_INTERACTIVE
*&---------------------------------------------------------------------*
FORM HANDLE_TOOLBAR2  USING P_OBJECT TYPE REF TO
                                    CL_ALV_EVENT_TOOLBAR_SET
                          P_INTERACTIVE TYPE CHAR1.

  DATA : LS_TOOLBAR TYPE STB_BUTTON.
  CLEAR LS_TOOLBAR.
  LS_TOOLBAR-BUTN_TYPE = 3.
  APPEND LS_TOOLBAR TO P_OBJECT->MT_TOOLBAR.

  CLEAR LS_TOOLBAR.
  LS_TOOLBAR-FUNCTION  = 'CREATE2'.
  LS_TOOLBAR-ICON      = ICON_GENERATE.
  LS_TOOLBAR-QUICKINFO = 'MRP 구매오더 생성'.
  LS_TOOLBAR-TEXT      = 'MRP 구매오더 생성'.
  LS_TOOLBAR-DISABLED  = ''.
  APPEND LS_TOOLBAR TO P_OBJECT->MT_TOOLBAR.

  DATA:LV_CNT_1 TYPE N LENGTH 3.
  DATA:LV_CNT_2 TYPE N LENGTH 3.
  DATA:LV_CNT_3 TYPE N LENGTH 3.
  LOOP AT GT_DISP2.
    IF GT_DISP2-ICON EQ '@0V@'.     ADD 1 TO LV_CNT_1.
    ELSEIF GT_DISP2-ICON EQ '@0W@'. ADD 1 TO LV_CNT_2.
    ELSEIF GT_DISP2-ICON EQ SPACE.  ADD 1 TO LV_CNT_3.
    ENDIF.
  ENDLOOP.

  CLEAR LS_TOOLBAR.
  LS_TOOLBAR-FUNCTION  = '1'.
  LS_TOOLBAR-ICON      = ICON_CHECKED.
  LS_TOOLBAR-QUICKINFO = '생성'.
  LS_TOOLBAR-TEXT      = |생성:{ LV_CNT_1 }|.
  LS_TOOLBAR-DISABLED  = ''.
  APPEND LS_TOOLBAR TO P_OBJECT->MT_TOOLBAR.

  CLEAR LS_TOOLBAR.
  LS_TOOLBAR-FUNCTION  = '2'.
  LS_TOOLBAR-ICON      = ICON_DUMMY.
  LS_TOOLBAR-QUICKINFO = '제외'.
  LS_TOOLBAR-TEXT      = |제외:{ LV_CNT_2 }|.
  LS_TOOLBAR-DISABLED  = ''.
  APPEND LS_TOOLBAR TO P_OBJECT->MT_TOOLBAR.

  CLEAR LS_TOOLBAR.
  LS_TOOLBAR-FUNCTION  = '3'.
  LS_TOOLBAR-ICON      = ' '.
  LS_TOOLBAR-QUICKINFO = '마생성'.
  LS_TOOLBAR-TEXT      = |미생성:{ LV_CNT_3 }|.
  LS_TOOLBAR-DISABLED  = ''.
  APPEND LS_TOOLBAR TO P_OBJECT->MT_TOOLBAR.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_USER_COMMAND2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_UCOMM
*&---------------------------------------------------------------------*
FORM HANDLE_USER_COMMAND2 USING C_UCOMM.

  CASE C_UCOMM.
    WHEN 'CREATE2'.
      PERFORM CREATE2_RTN.
  ENDCASE.
  CLEAR: C_UCOMM.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE2_RTN
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CREATE2_RTN .

  DATA : LT_ROWS TYPE LVC_T_ROW.
  DATA : LS_ROWS TYPE LVC_S_ROW.

  CALL METHOD GO_GRID2->GET_SELECTED_ROWS
  IMPORTING ET_INDEX_ROWS = LT_ROWS.
  IF LT_ROWS[] IS INITIAL.
     MESSAGE '항목을 선택하세요.' TYPE 'I' DISPLAY LIKE 'E'.
     EXIT.
  ENDIF.

  DATA:  LV_COL TYPE SY-CUCOL.
  DATA:  LV_ROW TYPE SY-CUROW.
  DATA : LV_ANSWER TYPE C.
  CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
    EXPORTING
      DEFAULTOPTION  = 'N'
      TEXTLINE1      = '생성하시겠습니까?'
      TEXTLINE2      = '(구매오더 문서번호는 자동 채번됩니다.)'
      TITEL          = '생성 팝업'
      CANCEL_DISPLAY = ' '
      START_COLUMN   = 120
      START_ROW	     = 5
    IMPORTING
      ANSWER         = LV_ANSWER.
  IF LV_ANSWER NE 'J'.
    MESSAGE '취소되었습니다.' TYPE 'S'.
    EXIT.
  ENDIF.

  LOOP AT LT_ROWS INTO LS_ROWS.
    READ TABLE GT_DISP2 INDEX LS_ROWS-INDEX.
    CHECK SY-SUBRC EQ 0.
    IF GT_DISP2-ICON IS NOT INITIAL.
      MESSAGE '이미 생성된 데이터입니다.' TYPE 'I' DISPLAY LIKE 'E'.
      EXIT.
    ENDIF.
  ENDLOOP.
  CHECK SY-MSGTY NE 'E'.

  LOOP AT LT_ROWS INTO LS_ROWS.
    READ TABLE GT_DISP2 INDEX LS_ROWS-INDEX.
    CHECK SY-SUBRC EQ 0.
    DATA(LV_TABIX) = SY-TABIX.
    GT_DISP2-SELECTED = 'X'."선택된 ROW 표시
    MODIFY GT_DISP2 INDEX LV_TABIX.
  ENDLOOP.

 "가공을 위해 임시 테이블 사용
  DATA(LT_TAB) = GT_DISP2[].
  SORT LT_TAB BY BANFN SELECTED.

 "Header와 Item이 존재하기에 선택된 하나의 PR번호만 남긴다.
 "(모두 선택하지 않아도 자동 생성 되도록)
 "PR ITEM이 여러건인 경우 어느 ROW를 선택할지 모름)
  DELETE ADJACENT DUPLICATES FROM LT_TAB COMPARING BANFN SELECTED.
  DELETE LT_TAB WHERE SELECTED NE 'X'. "선택하지 않은 PR번호 삭제

  CLEAR: GT_DISP2.
  GT_DISP2-SELECTED = SPACE.
  MODIFY GT_DISP2 TRANSPORTING SELECTED
                  WHERE SELECTED IS NOT INITIAL.

  DATA : LT_PO_H  LIKE ZEA_MMT140 OCCURS 0 WITH HEADER LINE.
  DATA : LT_PO_I  LIKE ZEA_MMT150 OCCURS 0 WITH HEADER LINE.
  DATA : LV_PONUM LIKE ZEA_MMT140-PONUM.
  DATA : LV_CNT   TYPE  N.
  DATA : LV_ERR   TYPE  C.

 "선택된 ROW의 PR들만 처리
  LOOP  AT  LT_TAB  INTO  DATA(LS_TAB).

       "ALV GRID에서 1개이상 선택된 PR은 모두 처리
        LOOP  AT  GT_DISP2 WHERE BANFN EQ LS_TAB-BANFN.

              LV_TABIX = SY-TABIX.
              LV_CNT   = LV_CNT + 1.

              ON CHANGE OF GT_DISP2-BANFN.
                PERFORM PURCHASE_ORDER_NUMBER
                CHANGING LV_PONUM."PO번호 채번

                CLEAR: LT_PO_H, LT_PO_I.
                PERFORM MAKE_PO_HEAD_DATA1 TABLES LT_PO_H
                                           USING GT_DISP2
                                                 LV_PONUM
                                           CHANGING LV_ERR.
              ENDON.

              PERFORM MAKE_PO_ITEM_DATA1 TABLES LT_PO_I
                                         USING GT_DISP2
                                               LV_PONUM
                                         CHANGING LV_ERR.

              GT_DISP2-ICON = '@0V@'.
              MODIFY GT_DISP2 INDEX LV_TABIX.

        ENDLOOP.

  ENDLOOP.

  DATA: LV_CNT1 TYPE N LENGTH 5.
  DATA: LV_CNT2 TYPE N LENGTH 5.
  DATA: LV_MSG TYPE STRING.

  IF LT_PO_H[] IS NOT INITIAL.
    DESCRIBE TABLE LT_PO_H LINES LV_CNT1.
    INSERT ZEA_MMT140 FROM TABLE LT_PO_H.
    IF SY-SUBRC NE 0.
      ROLLBACK WORK.
    ELSE.
      COMMIT WORK.
    ENDIF.
    CONCATENATE '구매오더 생성완료.' '(헤더:' LV_CNT1 INTO LV_MSG.
  ENDIF.

  IF LT_PO_I[] IS NOT INITIAL.
    DESCRIBE TABLE LT_PO_I LINES LV_CNT2.
    INSERT ZEA_MMT150 FROM TABLE LT_PO_I.
    IF SY-SUBRC NE 0.
      ROLLBACK WORK.
    ELSE.
      COMMIT WORK.
    ENDIF.
    CONCATENATE LV_MSG '아이템:' LV_CNT2 ')' INTO LV_MSG.
  ENDIF.

  IF LV_MSG IS NOT INITIAL.
    MESSAGE LV_MSG TYPE 'I' DISPLAY LIKE 'S'.
    PERFORM REFRESH_RTN.
  ENDIF.

  PERFORM REFRESH_TABLE_DISPLAY.
  CALL METHOD CL_GUI_CFW=>FLUSH.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_TOOLBAR3
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_OBJECT
*&      --> E_INTERACTIVE
*&---------------------------------------------------------------------*
FORM HANDLE_TOOLBAR3  USING P_OBJECT TYPE REF TO
                                    CL_ALV_EVENT_TOOLBAR_SET
                          P_INTERACTIVE TYPE CHAR1.

  DATA : LS_TOOLBAR TYPE STB_BUTTON.
  CLEAR LS_TOOLBAR.
  LS_TOOLBAR-BUTN_TYPE = 3.
  APPEND LS_TOOLBAR TO P_OBJECT->MT_TOOLBAR.

  CLEAR LS_TOOLBAR.
  LS_TOOLBAR-FUNCTION  = 'CREATE3'.
  LS_TOOLBAR-ICON      = ICON_GENERATE.
  LS_TOOLBAR-QUICKINFO = '원재료 구매오더 생성'.
  LS_TOOLBAR-TEXT      = '원재료 구매오더 생성'.
  LS_TOOLBAR-DISABLED  = ''.
  APPEND LS_TOOLBAR TO P_OBJECT->MT_TOOLBAR.

  DATA:LV_CNT_1 TYPE N LENGTH 3.
  DATA:LV_CNT_2 TYPE N LENGTH 3.
  DATA:LV_CNT_3 TYPE N LENGTH 3.
  LOOP AT GT_DISP3.
    CASE GT_DISP3-LIGHT.
      WHEN 3. ADD 1 TO LV_CNT_1.
      WHEN 2. ADD 1 TO LV_CNT_2.
      WHEN 1. ADD 1 TO LV_CNT_3.
    ENDCASE.
  ENDLOOP.

  CLEAR LS_TOOLBAR.
  LS_TOOLBAR-FUNCTION  = '1'.
  LS_TOOLBAR-ICON      = ICON_LED_GREEN.
  LS_TOOLBAR-QUICKINFO = ''.
  LS_TOOLBAR-TEXT      = |안전:{ LV_CNT_1 }|.
  LS_TOOLBAR-DISABLED  = ''.
  APPEND LS_TOOLBAR TO P_OBJECT->MT_TOOLBAR.

  CLEAR LS_TOOLBAR.
  LS_TOOLBAR-FUNCTION  = '2'.
  LS_TOOLBAR-ICON      = ICON_LED_YELLOW.
  LS_TOOLBAR-QUICKINFO = '주의'.
  LS_TOOLBAR-TEXT      = |주의:{ LV_CNT_2 }|.
  LS_TOOLBAR-DISABLED  = ''.
  APPEND LS_TOOLBAR TO P_OBJECT->MT_TOOLBAR.

  CLEAR LS_TOOLBAR.
  LS_TOOLBAR-FUNCTION  = '3'.
  LS_TOOLBAR-ICON      = ICON_LED_RED.
  LS_TOOLBAR-QUICKINFO = '위험'.
  LS_TOOLBAR-TEXT      = |위험:{ LV_CNT_3 }|.
  LS_TOOLBAR-DISABLED  = ''.
  APPEND LS_TOOLBAR TO P_OBJECT->MT_TOOLBAR.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_USER_COMMAND3
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_UCOMM
*&---------------------------------------------------------------------*
FORM HANDLE_USER_COMMAND3 USING C_UCOMM.

  CASE C_UCOMM.
    WHEN 'CREATE3'.
      PERFORM CREATE3_RTN.
  ENDCASE.
  CLEAR: C_UCOMM.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form PURCHASE_ORDER_NUMBER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LV_PONUM
*&---------------------------------------------------------------------*
FORM PURCHASE_ORDER_NUMBER  CHANGING PV_PONUM.

  DATA : NR_RANGE_NR  LIKE  INRI-NRRANGENR.
  DATA : OBJECT       LIKE  INRI-OBJECT.
  DATA : QUANTITY     LIKE  INRI-QUANTITY.
  DATA : LV_NUM       TYPE  I.

  CLEAR: NR_RANGE_NR, OBJECT, QUANTITY.
  NR_RANGE_NR = '06'.
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
    PV_PONUM = LV_NUM.
    CONDENSE PV_PONUM NO-GAPS."공백제거
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_PO_ITEM_DATA1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LT_PO_H
*&      --> LT_PO_I
*&      --> GT_DISP2
*&      --> LV_PONUM
*&      <-- LV_ERR
*&---------------------------------------------------------------------*
FORM MAKE_PO_ITEM_DATA1 TABLES PT_ITEM STRUCTURE ZEA_MMT150
                        USING PS_STR STRUCTURE GT_DISP2
                              PV_EBELN
                        CHANGING C_ERR.
* Item
  PT_ITEM-PONUM   = PV_EBELN.
  PT_ITEM-EBELP   = PT_ITEM-EBELP + 10. "품목번호
  PT_ITEM-MATNR   = PS_STR-MATNR.       "자재코드
  PT_ITEM-CALQTY  = PS_STR-MENGE.       "오더 수량
  PT_ITEM-MEINS   = PS_STR-MEINS.       "오더 단위
  PT_ITEM-BANFN   = PS_STR-BANFN.       "구매요청번호
  PT_ITEM-INFO_NO = PS_STR-INFO_NO.     "정보레코드
  PT_ITEM-WERKS   = PS_STR-WERKS.       "플랜트
  PT_ITEM-SCODE   = PS_STR-LGORT.       "저장위치

 "정보레코드 단가 SELECT
  SELECT SINGLE MATCOST, WAERS1
    INTO @DATA(LS_050)
    FROM ZEA_MMT050
    WHERE INFO_NO EQ @PT_ITEM-INFO_NO.
  PT_ITEM-DMBTR = LS_050-MATCOST * PT_ITEM-CALQTY. "총 금액
  PT_ITEM-WAERS = LS_050-WAERS1.

  PT_ITEM-ERDAT = SY-DATUM.
  PT_ITEM-ERZET = SY-UZEIT.
  PT_ITEM-ERNAM = SY-UNAME.
***  PT_ITEM-AEDAT = SY-DATUM.
***  PT_ITEM-AEZET = SY-UZEIT.
***  PT_ITEM-AENAM = SY-UNAME.
  APPEND PT_ITEM.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_PO_HEAD_DATA1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LT_PO_H
*&      --> GT_DISP2
*&      --> LV_PONUM
*&      <-- LV_ERR
*&---------------------------------------------------------------------*
FORM MAKE_PO_HEAD_DATA1 TABLES PT_HEAD STRUCTURE ZEA_MMT140
                        USING PS_STR STRUCTURE GT_DISP2
                              PV_EBELN
                        CHANGING C_ERR.

* Header
  PT_HEAD-PONUM    = PV_EBELN.    "구매오더 문서번호
  PT_HEAD-BUKRS    = '1000'.
  PT_HEAD-BANFN    = PS_STR-BANFN."구매요청번호
  PT_HEAD-ARIVDATE = SY-DATUM + 5.
  PT_HEAD-WERKS    = '10000'.
  PT_HEAD-POTEXT   = 'MRP 원자재 구매오더'.

  PT_HEAD-ERDAT = SY-DATUM.
  PT_HEAD-ERZET = SY-UZEIT.
  PT_HEAD-ERNAM = SY-UNAME.
**  PT_HEAD-AEDAT = SY-DATUM.
**  PT_HEAD-AEZET = SY-UZEIT.
**  PT_HEAD-AENAM = SY-UNAME.
  APPEND PT_HEAD.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH_RTN
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM REFRESH_RTN .


*----------------------------------------------------------------------
*                             구매오더
*----------------------------------------------------------------------
  DATA: LV_CHECK TYPE C.

  CLEAR: GT_DISP1[].
  SELECT * INTO TABLE @DATA(LT_140)
           FROM ZEA_MMT140.
  IF SY-SUBRC NE 0.
  ENDIF.
  SELECT * INTO TABLE @DATA(LT_150)
           FROM ZEA_MMT150
                FOR ALL ENTRIES IN @LT_140
           WHERE PONUM EQ @LT_140-PONUM.
  SORT LT_150 BY PONUM.


  LOOP AT LT_140 INTO DATA(LS_140).
    CLEAR: GT_DISP1.
    MOVE-CORRESPONDING LS_140 TO GT_DISP1.

   "헤더 PONUM과 같은 ITEM 을 처리한다.
    LOOP AT LT_150 INTO DATA(LS_150) WHERE PONUM EQ LS_140-PONUM.
      MOVE-CORRESPONDING LS_150 TO GT_DISP1.

      PERFORM CHECK_PURCHASE_ORDER_HISTORY USING GT_DISP1
                                           CHANGING LV_CHECK.
      CASE LV_CHECK.
        WHEN 'X'.   "미결
          GT_DISP1-ICON = ICON_REJECT.
        WHEN OTHERS."완결
          GT_DISP1-ICON = ICON_ALLOW.
      ENDCASE.
      CLEAR: LV_CHECK.

      APPEND GT_DISP1.
    ENDLOOP.
  ENDLOOP.
  SORT GT_DISP1 BY BANFN.


*----------------------------------------------------------------------
*                             구매요청
*----------------------------------------------------------------------
  CLEAR: GT_DISP2[].
  SELECT * INTO CORRESPONDING FIELDS OF TABLE GT_DISP2
           FROM ZEA_MMT130.

* 구매요청 icon
  DATA : LV_TABIX LIKE SY-TABIX.
  LOOP AT GT_DISP2.
    LV_TABIX = SY-TABIX.
   "PO가 생성되었는지 확인 후 아이콘 처리
    READ TABLE GT_DISP1 WITH KEY BANFN = GT_DISP2-BANFN
                                 BINARY SEARCH.
    IF SY-SUBRC EQ 0.
      GT_DISP2-ICON = '@0V@'."생성된 PR 아이콘 처리
      MODIFY GT_DISP2 INDEX LV_TABIX.
    ENDIF.
  ENDLOOP.
  SORT GT_DISP2 BY BANFN.


*----------------------------------------------------------------------
*                             재고 현황
*----------------------------------------------------------------------
  DATA : LV_PERCENT TYPE P DECIMALS 2.

  SELECT A~MATNR,
         B~MAKTX
    INTO TABLE @DATA(LT_MATNR)
    FROM ZEA_MMT010 AS A
    JOIN ZEA_MMT020 AS B
                       ON A~MATNR EQ B~MATNR
    WHERE A~MATTYPE EQ '원자재'
    AND   B~SPRAS   EQ @SY-LANGU
    ORDER BY A~MATNR.
  IF LT_MATNR[] IS INITIAL.
***    MESSAGE 'Error'
  ELSE.
    SELECT *
      INTO CORRESPONDING FIELDS OF TABLE @GT_DISP3
      FROM ZEA_MMT190
           FOR ALL ENTRIES IN @LT_MATNR
      WHERE MATNR EQ @LT_MATNR-MATNR.
    LOOP AT GT_DISP3.
      LV_TABIX = SY-TABIX.
      READ TABLE LT_MATNR INTO DATA(LS_MATNR)
      WITH KEY MATNR = GT_DISP3-MATNR BINARY SEARCH.
      IF SY-SUBRC EQ 0.
        GT_DISP3-MAKTX = LS_MATNR-MAKTX.
      ENDIF.

      IF GT_DISP3-SAFSTK IS NOT INITIAL.
        LV_PERCENT = ( GT_DISP3-CALQTY / GT_DISP3-SAFSTK ) * 100.
        IF LV_PERCENT > 150.
          GT_DISP3-LIGHT = 3."초록
        ELSEIF LV_PERCENT < 110.
          GT_DISP3-LIGHT = 1."빨강
        ELSE.
          GT_DISP3-LIGHT = 2."노랑
        ENDIF.
        GT_DISP3-LV_PERCENT = LV_PERCENT && '%'.
      ENDIF.

      MODIFY GT_DISP3 INDEX LV_TABIX.
    ENDLOOP.
    SORT GT_DISP3 BY LIGHT MATNR.
  ENDIF.


*----------------------------------------------------------------------
*                             Message
*----------------------------------------------------------------------
  IF OK_CODE NE SPACE.
    MESSAGE '새고고침 완료.' TYPE 'S'.
  ELSE.
    MESSAGE '조회되었습니다.' TYPE 'S'.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_TOOLBAR1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_OBJECT
*&      --> E_INTERACTIVE
*&---------------------------------------------------------------------*
FORM HANDLE_TOOLBAR1 USING P_OBJECT TYPE REF TO
                                    CL_ALV_EVENT_TOOLBAR_SET
                           P_INTERACTIVE TYPE CHAR1.

  DATA : LS_TOOLBAR TYPE STB_BUTTON.
  CLEAR LS_TOOLBAR.
  LS_TOOLBAR-BUTN_TYPE = 3.
  APPEND LS_TOOLBAR TO P_OBJECT->MT_TOOLBAR.

  DATA: LV_CNT_1 TYPE I.
  DATA: LV_CNT_2 TYPE I.
  LOOP AT GT_DISP1.
    CASE GT_DISP1-ICON.
      WHEN ICON_ALLOW.  ADD 1 TO LV_CNT_1.
      WHEN ICON_REJECT. ADD 1 TO LV_CNT_2.
    ENDCASE.
  ENDLOOP.

  CLEAR LS_TOOLBAR.
  LS_TOOLBAR-FUNCTION  = '1'.
  LS_TOOLBAR-ICON      = ICON_ALLOW.
  LS_TOOLBAR-QUICKINFO = '완결'.
  LS_TOOLBAR-TEXT      = '완결:' && LV_CNT_1.
  LS_TOOLBAR-DISABLED  = ''.
  APPEND LS_TOOLBAR TO P_OBJECT->MT_TOOLBAR.

  CLEAR LS_TOOLBAR.
  LS_TOOLBAR-FUNCTION  = '2'.
  LS_TOOLBAR-ICON      = ICON_REJECT.
  LS_TOOLBAR-QUICKINFO = '미결'.
  LS_TOOLBAR-TEXT      = '미결:' && LV_CNT_2.
  LS_TOOLBAR-DISABLED  = ''.
  APPEND LS_TOOLBAR TO P_OBJECT->MT_TOOLBAR.

  CLEAR LS_TOOLBAR.
  LS_TOOLBAR-FUNCTION  = 'CREATE'.
  LS_TOOLBAR-ICON      = ICON_GENERATE.
  LS_TOOLBAR-QUICKINFO = 'GR입고 자재문서생성'.
  LS_TOOLBAR-TEXT      = 'GR입고 자재문서생성'.
  LS_TOOLBAR-DISABLED  = ''.
  APPEND LS_TOOLBAR TO P_OBJECT->MT_TOOLBAR.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_USER_COMMAND1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_UCOMM
*&---------------------------------------------------------------------*
FORM HANDLE_USER_COMMAND1  USING    C_UCOMM.

  CASE C_UCOMM.
    WHEN 'CREATE'.
      PERFORM CREATE_RTN.
      PERFORM REFRESH_TABLE_DISPLAY.
  ENDCASE.
  CLEAR: C_UCOMM.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_RTN
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CREATE_RTN.

  DATA : LT_ROWS TYPE LVC_T_ROW.
  DATA : LS_ROWS TYPE LVC_S_ROW.

  CALL METHOD GO_GRID1->GET_SELECTED_ROWS
  IMPORTING ET_INDEX_ROWS = LT_ROWS.
  IF LT_ROWS[] IS INITIAL.
     MESSAGE '항목을 선택하세요.' TYPE 'I' DISPLAY LIKE 'E'.
     EXIT.
  ENDIF.

  DATA:  LV_COL TYPE SY-CUCOL.
  DATA:  LV_ROW TYPE SY-CUROW.
  DATA : LV_ANSWER TYPE C.
  CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
    EXPORTING
      DEFAULTOPTION  = 'N'
      TEXTLINE1      = '생성하시겠습니까?'
      TEXTLINE2      = '(자재문서번호는 자동 채번됩니다.)'
      TITEL          = '자재문서 팝업'
      CANCEL_DISPLAY = ' '
      START_COLUMN   = 20
      START_ROW	     = 5
    IMPORTING
      ANSWER         = LV_ANSWER.
  IF LV_ANSWER NE 'J'.
    MESSAGE '취소되었습니다.' TYPE 'S'.
    EXIT.
  ENDIF.

  LOOP AT LT_ROWS INTO LS_ROWS.
    READ TABLE GT_DISP1 INDEX LS_ROWS-INDEX.
    CHECK SY-SUBRC EQ 0.
    DATA(LV_TABIX) = SY-TABIX.
    GT_DISP1-SELECTED = 'X'.
    MODIFY GT_DISP1 INDEX LV_TABIX.
  ENDLOOP.

  DATA: LV_PONUM  TYPE  ZEA_MMT140-PONUM.
  DATA: LV_MBLNR  TYPE  ZEA_MMT090-MBLNR.
  DATA: LV_RETURN TYPE  CHAR1.

 "동일 PO 여러 건 선택할 경우 중복 제거
  DATA: LT_TAB LIKE GT_DISP1 OCCURS 0 WITH HEADER LINE.
  LT_TAB[] = GT_DISP1[].
  SORT LT_TAB BY PONUM SELECTED.
  DELETE ADJACENT DUPLICATES FROM LT_TAB COMPARING PONUM SELECTED.

 "자재문서 생성
  LOOP AT LT_TAB WHERE SELECTED EQ 'X'.
    LV_TABIX = SY-TABIX.
    LV_PONUM = LT_TAB-PONUM.
    CALL FUNCTION 'ZEA_MM_MMFG'
      EXPORTING
        IV_PONUM  = LV_PONUM  "구매오더번호
      IMPORTING
        EV_MBLNR  = LV_MBLNR  "자재문서 번호
        EV_RETURN = LV_RETURN.
  ENDLOOP.

  MESSAGE '자재문서가 생성되었습니다.' TYPE 'I' DISPLAY LIKE 'S'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_HOTSPOT_CLICK1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_ROW_ID
*&      --> E_COLUMN_ID
*&      --> ES_ROW_NO
*&---------------------------------------------------------------------*
FORM HANDLE_HOTSPOT_CLICK1 USING PS_ROW_ID    TYPE  LVC_S_ROW
                                 PS_COLUMN_ID TYPE  LVC_S_COL
                                 PS_ROW_NO    TYPE  LVC_S_ROID.

  CHECK PS_COLUMN_ID-FIELDNAME EQ 'PONUM'.

  PERFORM MAKE_PONUM_HISTORY_DATA TABLES GT_DISP1
                                  USING PS_ROW_ID.

  CALL SCREEN 0110 STARTING AT 7   7
                   ENDING   AT 181 22.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_PONUM_HISTORY_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM MAKE_PONUM_HISTORY_DATA TABLES PT_TAB STRUCTURE GT_DISP1
                             USING PS_ROW_ID TYPE LVC_S_ROW.

  READ TABLE PT_TAB INDEX PS_ROW_ID-INDEX.
  CHECK SY-SUBRC EQ 0.

  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE @GT_DISP4
    FROM ZEA_MMT100
    WHERE PONUM EQ @PT_TAB-PONUM
    ORDER BY MBGNO.
  CLEAR: GT_DISP4.
  GT_DISP4-TEXT = 'WE'.
  MODIFY GT_DISP4 TRANSPORTING TEXT
                  WHERE TEXT IS INITIAL.

  DATA : LV_AMT TYPE CHAR30.
  SELECT *
    INTO TABLE @DATA(LT_170)
    FROM ZEA_MMT170
    WHERE PONUM EQ @PT_TAB-PONUM
    ORDER BY BELNR,
             BUZEI.
  LOOP AT LT_170 INTO DATA(LS_170).
    GT_DISP4-GJAHR  = LS_170-GJAHR.
    GT_DISP4-MBLNR  = LS_170-BELNR.
    GT_DISP4-MBGNO  = LS_170-BUZEI.
    GT_DISP4-MATNR  = LS_170-MATNR.
    GT_DISP4-PONUM  = LS_170-PONUM.
    GT_DISP4-MENGE  = LS_170-MENGE.
    GT_DISP4-MEINS  = LS_170-MEINS.
    GT_DISP4-DMBTR  = LS_170-WRBTR.
    GT_DISP4-WAERS1 = LS_170-WAERS.
    GT_DISP4-TEXT   = 'RE-L'.
    IF LS_170-ZLSCHYN IS NOT INITIAL.
      GT_DISP4-ZLSCHYN = ICON_OKAY.
    ELSE.
      CLEAR: GT_DISP4-ZLSCHYN.
    ENDIF.
    APPEND GT_DISP4.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_SORT3
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GT_SORT3
*&---------------------------------------------------------------------*
FORM SET_SORT3  CHANGING P_GT_SORT3.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_GRID_EVENT_RECEIVER3
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_GRID_EVENT_RECEIVER3 .

  CREATE OBJECT LCL_EVENT_RECEIVER.

  SET HANDLER:
  LCL_EVENT_RECEIVER->HANDLE_TOOLBAR3      FOR GO_GRID3,
  LCL_EVENT_RECEIVER->HANDLE_USER_COMMAND3 FOR GO_GRID3.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE3_RTN
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CREATE3_RTN .

  DATA : LT_ROWS TYPE LVC_T_ROW.
  DATA : LS_ROWS TYPE LVC_S_ROW.

  CALL METHOD GO_GRID3->GET_SELECTED_ROWS
  IMPORTING ET_INDEX_ROWS = LT_ROWS.
  IF LT_ROWS[] IS INITIAL.
     MESSAGE '항목을 선택하세요.' TYPE 'I' DISPLAY LIKE 'E'.
     EXIT.
  ENDIF.

  DATA:  LV_COL TYPE SY-CUCOL.
  DATA:  LV_ROW TYPE SY-CUROW.
  DATA : LV_ANSWER TYPE C.
  CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
    EXPORTING
      DEFAULTOPTION  = 'N'
      TEXTLINE1      = '생성하시겠습니까?'
      TEXTLINE2      = '(구매오더 문서번호는 자동 채번됩니다.)'
      TITEL          = '생성 팝업'
      CANCEL_DISPLAY = ' '
      START_COLUMN   = 120
      START_ROW	     = 20
    IMPORTING
      ANSWER         = LV_ANSWER.
  IF LV_ANSWER NE 'J'.
    MESSAGE '취소되었습니다.' TYPE 'S'.
    EXIT.
  ENDIF.

  LOOP AT LT_ROWS INTO LS_ROWS.
    READ TABLE GT_DISP3 INDEX LS_ROWS-INDEX.
    CHECK SY-SUBRC EQ 0.
    DATA(LV_TABIX) = SY-TABIX.
    GT_DISP3-SELECTED = 'X'.
    MODIFY GT_DISP3 INDEX LV_TABIX.
  ENDLOOP.

  READ TABLE GT_DISP3 WITH KEY LIGHT    = 3
                               SELECTED = 'X'.
  IF SY-SUBRC EQ 0.
    CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
      EXPORTING
        DEFAULTOPTION  = 'N'
        TEXTLINE1      = '재고가 충분한 자재가 포함되어 있습니다.'
        TEXTLINE2      = '그래도 주문하시겠습니까?'
        TITEL          = '생성 팝업'
        CANCEL_DISPLAY = ' '
        START_COLUMN   = 120
        START_ROW	     = 20
      IMPORTING
        ANSWER         = LV_ANSWER.
    IF LV_ANSWER NE 'J'.
      MESSAGE '취소되었습니다.' TYPE 'S'.
      EXIT.
    ENDIF.
  ENDIF.

  DATA : LT_PO_H  LIKE ZEA_MMT140 OCCURS 0 WITH HEADER LINE.
  DATA : LT_PO_I  LIKE ZEA_MMT150 OCCURS 0 WITH HEADER LINE.
  DATA : LV_PONUM LIKE ZEA_MMT140-PONUM.
  DATA : LV_CNT   TYPE  N.
  DATA : LV_ERR   TYPE  C.

 "선택된 ROW의 PR들만 처리
  LOOP  AT  GT_DISP3 WHERE SELECTED EQ 'X'.
        LV_TABIX = SY-TABIX.

        IF LV_PONUM IS INITIAL.
          PERFORM PURCHASE_ORDER_NUMBER CHANGING LV_PONUM."PO번호 채번

          CLEAR: LT_PO_H[], LT_PO_I[].
          PERFORM MAKE_PO_HEAD_DATA2 TABLES LT_PO_H
                                     USING GT_DISP3
                                           LV_PONUM
                                     CHANGING LV_ERR.
        ENDIF.

        PERFORM MAKE_PO_ITEM_DATA2 TABLES LT_PO_I
                                   USING GT_DISP3
                                         LV_PONUM
                                   CHANGING LV_ERR.

        GT_DISP3-LIGHT = 3.
        MODIFY GT_DISP3 INDEX LV_TABIX.

  ENDLOOP.
  IF LT_PO_I[] IS INITIAL.
    MESSAGE '재고가 부족한 원재료가 없습니다.' TYPE 'I' DISPLAY LIKE 'E'.
    EXIT.
  ENDIF.

  DATA: LV_CNT1 TYPE N LENGTH 5.
  DATA: LV_CNT2 TYPE N LENGTH 5.
  DATA: LV_MSG TYPE STRING.

  IF LT_PO_H[] IS NOT INITIAL.
    DESCRIBE TABLE LT_PO_H LINES LV_CNT1.
    INSERT ZEA_MMT140 FROM TABLE LT_PO_H.
    IF SY-SUBRC NE 0.
      ROLLBACK WORK.
    ENDIF.
    CONCATENATE '생성 완료.' '(헤더:' LV_CNT1 INTO LV_MSG.
  ENDIF.

  IF LT_PO_I[] IS NOT INITIAL.
    DESCRIBE TABLE LT_PO_I LINES LV_CNT2.
    INSERT ZEA_MMT150 FROM TABLE LT_PO_I.
    IF SY-SUBRC NE 0.
      ROLLBACK WORK.
    ENDIF.
    CONCATENATE LV_MSG '아이템:' LV_CNT2 ')' INTO LV_MSG.
  ENDIF.

  IF LV_MSG IS NOT INITIAL.
    MESSAGE LV_MSG TYPE 'I' DISPLAY LIKE 'S'.
    PERFORM REFRESH_RTN.
  ENDIF.

  PERFORM REFRESH_TABLE_DISPLAY.
  CALL METHOD CL_GUI_CFW=>FLUSH.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_PO_HEAD_DATA2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LT_PO_H
*&      --> GT_DISP3
*&      --> LV_PONUM
*&      <-- LV_ERR
*&---------------------------------------------------------------------*
FORM MAKE_PO_HEAD_DATA2 TABLES PT_HEAD STRUCTURE ZEA_MMT140
                        USING PS_STR STRUCTURE GT_DISP3
                              PV_EBELN
                        CHANGING C_ERR.

* Header
  PT_HEAD-PONUM = PV_EBELN. "구매오더 문서번호
  PT_HEAD-BUKRS = '1000'.
  PT_HEAD-ARIVDATE = SY-DATUM + 7.
  PT_HEAD-WERKS  = '10000'.
  PT_HEAD-POTEXT = '안전재고 원자재 구매오더'.

  PT_HEAD-ERDAT = SY-DATUM.
  PT_HEAD-ERZET = SY-UZEIT.
  PT_HEAD-ERNAM = SY-UNAME.
**  PT_HEAD-AEDAT = SY-DATUM.
**  PT_HEAD-AEZET = SY-UZEIT.
**  PT_HEAD-AENAM = SY-UNAME.
  APPEND PT_HEAD.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_PO_ITEM_DATA2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LT_PO_I
*&      --> GT_DISP3
*&      --> LV_PONUM
*&      <-- LV_ERR
*&---------------------------------------------------------------------*
FORM MAKE_PO_ITEM_DATA2 TABLES PT_ITEM STRUCTURE ZEA_MMT150
                        USING PS_STR STRUCTURE GT_DISP3
                              PV_EBELN
                        CHANGING C_ERR.
* Item
  PT_ITEM-PONUM   = PV_EBELN.
  PT_ITEM-EBELP   = PT_ITEM-EBELP + 10. "품목번호
  PT_ITEM-MATNR   = PS_STR-MATNR.       "자재코드

  PERFORM GET_RAW_MATERIALS_PO_AMOUNT USING PS_STR
                                      CHANGING PT_ITEM-CALQTY.

  PT_ITEM-MEINS   = PS_STR-MEINS.       "오더 단위

 "정보레코드
  SELECT SINGLE INFO_NO, MATCOST, WAERS1, WERKS
    INTO @DATA(LS_050)
    FROM ZEA_MMT050
    WHERE MATNR EQ @PT_ITEM-MATNR
    AND   LOEKZ EQ @SPACE.
  PT_ITEM-INFO_NO = LS_050-INFO_NO."정보레코드
  PT_ITEM-DMBTR = LS_050-MATCOST * PT_ITEM-CALQTY. "총 금액
  PT_ITEM-WAERS = LS_050-WAERS1. "통화
  PT_ITEM-WERKS = LS_050-WERKS.  "플랜트

  SELECT SINGLE WERKS,
                SCODE
    INTO @DATA(LS_MMT060)
    FROM ZEA_MMT060
    WHERE WERKS EQ @LS_050-WERKS.
  PT_ITEM-SCODE   = LS_MMT060-SCODE. "저장위치

  PT_ITEM-ERDAT = SY-DATUM.
  PT_ITEM-ERZET = SY-UZEIT.
  PT_ITEM-ERNAM = SY-UNAME.
***  PT_ITEM-AEDAT = SY-DATUM.
***  PT_ITEM-AEZET = SY-UZEIT.
***  PT_ITEM-AENAM = SY-UNAME.

  IF PT_ITEM-CALQTY EQ 0.
    EXIT."구매오더 수량이 0으로 잡히면 빠져나감.
  ENDIF.
  APPEND PT_ITEM.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHECK_PURCHASE_ORDER_HISTORY
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_DISP1
*&      <-- DATA(LV_CHK)
*&---------------------------------------------------------------------*
FORM CHECK_PURCHASE_ORDER_HISTORY  USING    PT_TAB STRUCTURE GT_DISP1
                                   CHANGING PV_CHK.

*------------------------------------------------
*           품목별 구매오더이력 Check
*               자재문서, 송장문서
*------------------------------------------------
  SELECT SINGLE *
    INTO @DATA(LS_MMT100)
    FROM ZEA_MMT100
    WHERE PONUM EQ @PT_TAB-PONUM
    AND   MATNR EQ @PT_TAB-MATNR.
  IF SY-SUBRC NE 0.
     PV_CHK = 'X'."미결
  ENDIF.

  SELECT SINGLE B~*
    INTO @DATA(LS_ITEM)
    FROM ZEA_MMT160 AS A
    JOIN ZEA_MMT170 AS B
                       ON  A~BELNR EQ B~BELNR
                       AND A~GJAHR EQ B~GJAHR
    WHERE B~PONUM EQ @PT_TAB-PONUM
    AND   B~EBELP EQ @PT_TAB-EBELP.
  IF SY-SUBRC NE 0.
     PV_CHK = 'X'."미결
  ELSE.
     IF LS_ITEM-ZLSCHYN IS INITIAL.
        PV_CHK = 'X'."미결
     ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_TOOLBAR4
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_OBJECT
*&      --> E_INTERACTIVE
*&---------------------------------------------------------------------*
FORM HANDLE_TOOLBAR4  USING P_OBJECT TYPE REF TO
                                    CL_ALV_EVENT_TOOLBAR_SET
                          P_INTERACTIVE TYPE CHAR1.

  DATA : LS_TOOLBAR TYPE STB_BUTTON.
  CLEAR LS_TOOLBAR.
  LS_TOOLBAR-BUTN_TYPE = 3.
  APPEND LS_TOOLBAR TO P_OBJECT->MT_TOOLBAR.

  DATA: LV_CNT1 TYPE N LENGTH 3.
  DATA: LV_CNT2 TYPE N LENGTH 3.
  LOOP AT GT_DISP4.
    IF GT_DISP4-BWART IS NOT INITIAL.
      ADD 1 TO LV_CNT1.
    ELSE.
      ADD 1 TO LV_CNT2.
    ENDIF.
  ENDLOOP.

  CLEAR LS_TOOLBAR.
  LS_TOOLBAR-FUNCTION  = '1'.
  LS_TOOLBAR-ICON      = ICON_PROTOCOL.
  LS_TOOLBAR-QUICKINFO = '자재문서'.
  LS_TOOLBAR-TEXT      = '자재문서:' && LV_CNT1.
  LS_TOOLBAR-DISABLED  = ''.
  APPEND LS_TOOLBAR TO P_OBJECT->MT_TOOLBAR.

  CLEAR LS_TOOLBAR.
  LS_TOOLBAR-FUNCTION  = '2'.
  LS_TOOLBAR-ICON      = ICON_ORDER.
  LS_TOOLBAR-QUICKINFO = '송장문서'.
  LS_TOOLBAR-TEXT      = '송장문서:' && LV_CNT2.
  LS_TOOLBAR-DISABLED  = ''.
  APPEND LS_TOOLBAR TO P_OBJECT->MT_TOOLBAR.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_RAW_MATERIALS_PO_AMOUNT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PS_STR
*&      <-- PT_ITEM_CALQTY
*&---------------------------------------------------------------------*
FORM GET_RAW_MATERIALS_PO_AMOUNT  USING    PS_STR STRUCTURE GT_DISP3
                                  CHANGING PV_AMT.

  "200% 기준 남은 퍼센트
  DATA: FIRST  TYPE STRING,
        SECOND TYPE STRING.
  SPLIT PS_STR-LV_PERCENT AT '%' INTO: FIRST
                                       SECOND.

  DATA : LV_200     TYPE STRING VALUE '200'.
  DATA : LV_PERCENT TYPE STRING.
  LV_PERCENT = LV_200 - FIRST.

 "1% 수량
  DATA: LV_AMT LIKE GT_DISP3-CALQTY.
  LV_AMT = GT_DISP3-CALQTY / LV_PERCENT.

 "총 구매수량
  PV_AMT = LV_PERCENT * LV_AMT.

  CALL FUNCTION 'FIMA_NUMERICAL_VALUE_ROUND'
  EXPORTING I_RTYPE      = '+'
            I_RUNIT      = '1'
            I_VALUE      = PV_AMT
  IMPORTING E_VALUE_RND  = PV_AMT.

ENDFORM.
