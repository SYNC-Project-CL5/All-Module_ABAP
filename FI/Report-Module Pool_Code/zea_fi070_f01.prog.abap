*&---------------------------------------------------------------------*
*& Include         ZEA_OPEN_MANG_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_base_data
*&---------------------------------------------------------------------*
FORM GET_BASE_DATA .

  REFRESH GT_DATA.
  REFRESH GT_DATA2.


* 버튼에 따라서 조회되는 화면이 달라지도록 해야 함.
*-- (SELECT) Set Data Due to Radio Button


  IF
    RAD_OPEN EQ 'X'. " Open item
    PERFORM DISPLAY_OPEN.

  ELSEIF
  RAD_CLEA EQ 'X'. " Cleared item
    PERFORM DISPLAY_CLEARED.

  ELSEIF
  RAD_ALL EQ 'X'.  " All
    PERFORM DISPLAY_ALL.

  ENDIF.

*--- 검색 라인 수 Message
  PERFORM DISPLAY_LINE_MESSAGE.


ENDFORM.
*&---------------------------------------------------------------------**&---------------------------------------------------------------------*
*& Form SET_ALV_LAYOUT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_LAYOUT_0100 .

  CLEAR GS_LAYOUT.
  CLEAR GS_VARIANT.
  CLEAR GV_SAVE.

  GS_VARIANT-REPORT = SY-REPID.
  GS_VARIANT-HANDLE = 'GO_ALV_GRID'.

  GV_SAVE  = 'X'.  "      'X' : Layout을 저장하면 모든 사용자가 사용 가능
  GS_LAYOUT-SEL_MODE   = 'B'.     "하나의 벤더에 대해서만 지급처리 가능하게
  GS_LAYOUT-EXCP_FNAME  = 'STATUS'.
  GS_LAYOUT-EXCP_LED    = 'X'.
  GS_LAYOUT-SEL_MODE    = 'B'.   "ALV  Grid 의 선택 모드는 셀 단위
  GS_LAYOUT-CWIDTH_OPT  = ABAP_ON.
  GS_LAYOUT-STYLEFNAME  = 'CELL_TAB'.
  GS_LAYOUT-ZEBRA = 'X'.
  GS_LAYOUT-GRID_TITLE = '매입채무 리스트'.

  PERFORM EXCLUDE_BUTTON  USING GT_UI_FUNCTIONS.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_field_catalog
*&---------------------------------------------------------------------*
FORM SET_FIELD_CATALOG  USING   PT_TAB TYPE STANDARD TABLE
                        CHANGING PT_FCAT TYPE LVC_T_FCAT.

  DATA: LO_DREF TYPE REF TO DATA.

  CREATE DATA LO_DREF LIKE PT_TAB.
  FIELD-SYMBOLS <LT_TAB> TYPE TABLE.
  ASSIGN LO_DREF->* TO <LT_TAB>.

  TRY.
      CALL METHOD CL_SALV_TABLE=>FACTORY
        IMPORTING
          R_SALV_TABLE = DATA(LR_TABLE)
        CHANGING
          T_TABLE      = <LT_TAB>.

    CATCH CX_SALV_MSG. " ALV: General Error Class with Message
  ENDTRY.

  PT_FCAT = CL_SALV_CONTROLLER_METADATA=>GET_LVC_FIELDCATALOG(
              R_COLUMNS      = LR_TABLE->GET_COLUMNS( )
              R_AGGREGATIONS = LR_TABLE->GET_AGGREGATIONS( )
            ).


ENDFORM.
*&---------------------------------------------------------------------*
*& Form screen_change
*&---------------------------------------------------------------------*
FORM SCREEN_CHANGE .

  CHECK SY-UNAME EQ 'ACA5-03'
     OR SY-UNAME EQ 'ACA5-08'
     OR SY-UNAME EQ 'ACA5-12'
     OR SY-UNAME EQ 'ACA5-15'
     OR SY-UNAME EQ 'ACA5-17'
     OR SY-UNAME EQ 'ACA5-23'.

  DATA : LV_TABIX TYPE SY-TABIX,
         LV_ID    TYPE SY-UNAME.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_object
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT .

  CREATE OBJECT GO_TOP_CONTAINER
    EXPORTING
      REPID     = SY-CPROG
      DYNNR     = SY-DYNNR
      SIDE      = GO_TOP_CONTAINER->DOCK_AT_TOP
      EXTENSION = 43.

  CREATE OBJECT GO_CONTAINER
    EXPORTING
      REPID     = SY-REPID
      DYNNR     = SY-DYNNR
      SIDE      = GO_CONTAINER->DOCK_AT_LEFT
      EXTENSION = 3000.

  CREATE OBJECT GO_ALV_GRID
    EXPORTING
      I_PARENT = GO_CONTAINER.

*-- Create TOP-Document
  CREATE OBJECT GO_DYNDOC_ID
    EXPORTING
      STYLE = 'ALV_GRID'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form exclude_button
*&---------------------------------------------------------------------*
FORM EXCLUDE_BUTTON  USING PT_UI_FUNCTIONS TYPE UI_FUNCTIONS.

  DATA : LS_UI_FUNCTIONS TYPE UI_FUNC.

  CLEAR : PT_UI_FUNCTIONS.

  LS_UI_FUNCTIONS = CL_GUI_ALV_GRID=>MC_FC_LOC_UNDO.
  APPEND LS_UI_FUNCTIONS TO PT_UI_FUNCTIONS.
  LS_UI_FUNCTIONS = CL_GUI_ALV_GRID=>MC_FC_LOC_COPY.
  APPEND LS_UI_FUNCTIONS TO PT_UI_FUNCTIONS.
  LS_UI_FUNCTIONS = CL_GUI_ALV_GRID=>MC_FC_LOC_COPY_ROW.
  APPEND LS_UI_FUNCTIONS TO PT_UI_FUNCTIONS.
  LS_UI_FUNCTIONS = CL_GUI_ALV_GRID=>MC_FC_LOC_CUT.
  APPEND LS_UI_FUNCTIONS TO PT_UI_FUNCTIONS.
  LS_UI_FUNCTIONS = CL_GUI_ALV_GRID=>MC_FC_LOC_DELETE_ROW.
  APPEND LS_UI_FUNCTIONS TO PT_UI_FUNCTIONS.
  LS_UI_FUNCTIONS = CL_GUI_ALV_GRID=>MC_FC_LOC_INSERT_ROW.
  APPEND LS_UI_FUNCTIONS TO PT_UI_FUNCTIONS.
  LS_UI_FUNCTIONS = CL_GUI_ALV_GRID=>MC_FC_LOC_APPEND_ROW.
  APPEND LS_UI_FUNCTIONS TO PT_UI_FUNCTIONS.
  LS_UI_FUNCTIONS = CL_GUI_ALV_GRID=>MC_FC_LOC_PASTE.
  APPEND LS_UI_FUNCTIONS TO PT_UI_FUNCTIONS.
  LS_UI_FUNCTIONS = CL_GUI_ALV_GRID=>MC_FC_LOC_PASTE_NEW_ROW.
  APPEND LS_UI_FUNCTIONS TO PT_UI_FUNCTIONS.
  LS_UI_FUNCTIONS = CL_GUI_ALV_GRID=>MC_FC_REFRESH.
  APPEND LS_UI_FUNCTIONS TO PT_UI_FUNCTIONS.
  LS_UI_FUNCTIONS = CL_GUI_ALV_GRID=>MC_FC_AUF.
  APPEND LS_UI_FUNCTIONS TO PT_UI_FUNCTIONS.
  LS_UI_FUNCTIONS = CL_GUI_ALV_GRID=>MC_FC_AVERAGE.
  APPEND LS_UI_FUNCTIONS TO PT_UI_FUNCTIONS.
  LS_UI_FUNCTIONS = CL_GUI_ALV_GRID=>MC_FC_PRINT.
  APPEND LS_UI_FUNCTIONS TO PT_UI_FUNCTIONS.
  LS_UI_FUNCTIONS = CL_GUI_ALV_GRID=>MC_FC_GRAPH.
  APPEND LS_UI_FUNCTIONS TO PT_UI_FUNCTIONS.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_alv_listbox
*&---------------------------------------------------------------------*
FORM SET_ALV_LISTBOX .

  CLEAR : GT_DROP, GS_DROP.
  GS_DROP = VALUE #( HANDLE = 1
                     VALUE  = TEXT-L01 ).
  APPEND GS_DROP TO GT_DROP.

  GS_DROP = VALUE #( HANDLE = 1
                     VALUE  = TEXT-L02 ).
  APPEND GS_DROP TO GT_DROP.

  GS_DROP = VALUE #( HANDLE = 1
                     VALUE  = TEXT-L03 ).
  APPEND GS_DROP TO GT_DROP.

  CALL METHOD GO_ALV_GRID->SET_DROP_DOWN_TABLE
    EXPORTING
      IT_DROP_DOWN = GT_DROP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form register_event
*&---------------------------------------------------------------------*
FORM REGISTER_EVENT .

  CALL METHOD GO_DYNDOC_ID->INITIALIZE_DOCUMENT
    EXPORTING
      BACKGROUND_COLOR = CL_DD_AREA=>COL_TEXTAREA.

  CALL METHOD GO_ALV_GRID->LIST_PROCESSING_EVENTS
    EXPORTING
      I_EVENT_NAME = 'TOP_OF_PAGE'
      I_DYNDOC_ID  = GO_DYNDOC_ID.

*-- Set display mode when program execute
  CALL METHOD GO_ALV_GRID->SET_READY_FOR_INPUT
    EXPORTING
      I_READY_FOR_INPUT = 0.

  CALL METHOD GO_ALV_GRID->REGISTER_EDIT_EVENT
    EXPORTING
      I_EVENT_ID = CL_GUI_ALV_GRID=>MC_EVT_MODIFIED.

  CALL METHOD GO_ALV_GRID->REGISTER_EDIT_EVENT
    EXPORTING
      I_EVENT_ID = CL_GUI_ALV_GRID=>MC_EVT_ENTER.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_init_value
*&---------------------------------------------------------------------*
FORM SET_INIT_VALUE .

*-- Reserve date

  DATA : LV_DATE  TYPE SY-DATUM.

  LV_DATE = SY-DATUM.
  _LAST_day LV_DATE.

  SO_RESDT = VALUE #( SIGN    = 'I'
                      OPTION  = 'BT'
                      LOW     = SY-DATUM
                      HIGH    = LV_DATE ).
  APPEND SO_RESDT.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form handle_user_command
*&---------------------------------------------------------------------*
*&      --> E_UCOMM
*&---------------------------------------------------------------------*
FORM HANDLER_TOOLBAR
  USING PO_OBJECT TYPE REF TO CL_ALV_EVENT_TOOLBAR_SET
        PO_SENDER TYPE REF TO CL_GUI_ALV_GRID.

  " Internal Table PO_OBJECT->MT_TOOLBAR 를 위한 작업공간
  " PO_OBJECT->MT_TOOLBAR >>> 클래스의 Attribute ( Public , Instance )
  DATA LS_TOOLBAR LIKE LINE OF PO_OBJECT->MT_TOOLBAR.

*--- 버튼에 검색 라인 수 붙이기
  DATA : LV_ALL  TYPE I,
         LV_OPEN TYPE I,
         LV_CLEA TYPE I.


*---- 버튼 추가를 위한 Sender 구분(alv가 2개 이상일 경우 구분필요)
  CASE PO_SENDER.
    WHEN GO_ALV_GRID.


***********************************************************************
*                    ALV1 For Screen 0100
***********************************************************************
      LOOP AT GT_DATA INTO GS_DATA.

        CASE GS_DATA-STATUS .
          WHEN '3'.
            ADD 1 TO LV_ALL.
            ADD 1 TO LV_CLEA.

          WHEN '1'.
            ADD 1 TO LV_ALL.
            ADD 1 TO LV_OPEN.
        ENDCASE.
      ENDLOOP.

* 구분자 =>> |
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 3. " 구분자
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 만기일 기준 정렬
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 0. " DUEDATE
      LS_TOOLBAR-FUNCTION = GC_DUEDATE.
      LS_TOOLBAR-ICON = ICON_SORT_UP.
      LS_TOOLBAR-TEXT = TEXT-L05. " Sort for Due Date
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 구분자 =>> |
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 3. " 구분자
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 미결 Item 만 보기
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 0. " DISPLAY_OPEN
      LS_TOOLBAR-FUNCTION = GC_OPEN.
      LS_TOOLBAR-ICON = ICON_LED_RED.
      LS_TOOLBAR-TEXT = TEXT-L02 &&':' && LV_OPEN. "Only Open Item
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.


* 버튼 추가 =>> 반제 Item 만 보기
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 0. " DISPAY_CLEARING
      LS_TOOLBAR-FUNCTION = GC_CLEARING.
      LS_TOOLBAR-ICON = ICON_LED_GREEN.
      LS_TOOLBAR-TEXT = TEXT-L03 && ':' && LV_CLEA. "Only Clearing Item
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.


* 버튼 추가 =>> Display ALL Item
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 0. " DISPLAY_ALL
      LS_TOOLBAR-FUNCTION = GC_ALL_ITEM.
      LS_TOOLBAR-ICON = ICON_REFRESH.
      LS_TOOLBAR-TEXT = TEXT-L04  && ':' && LV_ALL. "All item
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

***********************************************************************
*                    ALV2 For Screen 0100
***********************************************************************
    WHEN GO_ALV_GRID_2.
* 구분자 =>> |
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 3. " 구분자
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 지급
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 0. " 버튼
      LS_TOOLBAR-FUNCTION = GC_PAY.
      LS_TOOLBAR-TEXT = TEXT-L04. "지급
      LS_TOOLBAR-ICON = ICON_CHANGE.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

  ENDCASE.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form event_top_of_page
*&---------------------------------------------------------------------*
FORM EVENT_TOP_OF_PAGE .

  DATA : LR_DD_TABLE TYPE REF TO CL_DD_TABLE_ELEMENT,
         COL_FIELD   TYPE REF TO CL_DD_AREA,
         COL_VALUE   TYPE REF TO CL_DD_AREA.

  DATA : LV_TEXT  TYPE SDYDO_TEXT_ELEMENT,
         LV_BUTXT TYPE T001-BUTXT.

  CALL METHOD GO_DYNDOC_ID->ADD_TABLE
    EXPORTING
      NO_OF_COLUMNS = 2
      BORDER        = '0'
    IMPORTING
      TABLE         = LR_DD_TABLE.

*-- Set column
  CALL METHOD LR_DD_TABLE->ADD_COLUMN
    IMPORTING
      COLUMN = COL_FIELD.

  CALL METHOD LR_DD_TABLE->ADD_COLUMN
    IMPORTING
      COLUMN = COL_VALUE.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form set_top_of_page
*&---------------------------------------------------------------------*
FORM SET_TOP_OF_PAGE .

* Creating html control
  IF GO_HTML_CNTRL IS INITIAL.
    CREATE OBJECT GO_HTML_CNTRL
      EXPORTING
        PARENT = GO_TOP_CONTAINER.
  ENDIF.

  CALL METHOD GO_DYNDOC_ID->MERGE_DOCUMENT.
  GO_DYNDOC_ID->HTML_CONTROL = GO_HTML_CNTRL.

* Display document
  CALL METHOD GO_DYNDOC_ID->DISPLAY_DOCUMENT
    EXPORTING
      REUSE_CONTROL      = 'X'
      PARENT             = GO_TOP_CONTAINER
    EXCEPTIONS
      HTML_DISPLAY_ERROR = 1.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALL
*&---------------------------------------------------------------------*
*& all 라디오버튼 선택 시
*&---------------------------------------------------------------------*
FORM DISPLAY_ALL.

*인터널 테이블 초기화
  CLEAR GT_DATA[].

  SELECT * INTO CORRESPONDING FIELDS OF TABLE @GT_DATA
   FROM   ZEA_BKPF AS C JOIN ZEA_BSEG AS A
    ON C~BELNR EQ A~BELNR
    JOIN ZEA_LFA1 AS B
    ON A~BPCODE EQ B~VENCODE

    WHERE A~BUKRS   IN @SO_COCO
    AND   B~VENCODE IN @SO_VENCO

    AND   C~BUDAT IN @SO_RESDT
    AND   A~BSCHL   EQ '31'
*    AND   A~AUGDT EQ 'X' OR AUGDT NE 'X'

    ORDER BY B~VENCODE ASCENDING.

  PERFORM IUNPUT_STATUS.

  PERFORM FILL_DUE_DATE.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_OPEN
*&---------------------------------------------------------------------*
* Open 버튼 선택 시
*&---------------------------------------------------------------------*
FORM DISPLAY_OPEN.

*  인터널 테이블 초기화
  CLEAR GT_DATA[].
  "중복 데이터 오류를 피하기 위해  인터널 테이블 속 데이터를 초기화함.

  SELECT * INTO CORRESPONDING FIELDS OF TABLE @GT_DATA
    FROM   ZEA_BKPF AS C JOIN ZEA_BSEG AS A
    ON C~BELNR EQ A~BELNR
    JOIN ZEA_LFA1 AS B
    ON A~BPCODE EQ B~VENCODE


   WHERE A~BUKRS   IN  @SO_COCO
   AND   B~VENCODE IN  @SO_VENCO

   AND   A~AUGDT   NE 'X'
   AND   A~BSCHL   EQ '31'

   AND   C~BUDAT   IN @OPEN_DAT
   ORDER BY B~VENCODE ASCENDING.

  PERFORM IUNPUT_STATUS.

  PERFORM FILL_DUE_DATE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form  DISPLAY_CLEARED
*&---------------------------------------------------------------------*
*& Cleared 버튼 선택 시
*&---------------------------------------------------------------------*
FORM DISPLAY_CLEARED.   "Cleared items

*  인터널 테이블 초기화
  CLEAR GT_DATA[].
  "중복 데이터 오류를 피하기 위해  인터널 테이블 속 데이터를 초기화함.

  SELECT * INTO CORRESPONDING FIELDS OF TABLE @GT_DATA
     FROM   ZEA_BKPF AS C JOIN ZEA_BSEG AS A
    ON C~BELNR EQ A~BELNR
    JOIN ZEA_LFA1 AS B
    ON A~BPCODE EQ B~VENCODE



    WHERE A~BUKRS IN  @SO_COCO
    AND   B~VENCODE IN @SO_VENCO

    AND   A~AUGDT EQ 'X'
    AND   C~BUDAT IN @SO_C_DAT
    AND   A~BSCHL   EQ '31'
    ORDER BY B~VENCODE ASCENDING.

  PERFORM IUNPUT_STATUS.

  PERFORM FILL_DUE_DATE.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_FIELDCAT_0100 .

*-- Field Catalog 동적 생성
  PERFORM SET_FIELD_CATALOG USING   GT_DATA
                            CHANGING GT_FIELDCAT.
*-- Field Catalog 수정
  PERFORM MAKE_FIELD_CATALOG.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_0100
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT_0100 .

*-- Create Container
  CREATE OBJECT GO_CONTAINER
    EXPORTING
      REPID = SY-REPID
      DYNNR = SY-DYNNR
      SIDE  = GO_CONTAINER->DOCK_AT_BOTTOM
      RATIO = 50.

  CREATE OBJECT GO_ALV_GRID
    EXPORTING
      I_PARENT      = GO_CONTAINER
      I_APPL_EVENTS = 'X'. " Register Events as Application Events

*-- Create TOP-Document
  CREATE OBJECT GO_DYNDOC_ID
    EXPORTING
      STYLE = 'ALV_GRID'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_0100
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV_0100 .

  GV_SAVE2 = 'A'.

  CALL METHOD GO_ALV_GRID->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
      I_STRUCTURE_NAME              = 'ZEA_FIT800'
      IS_VARIANT                    = GS_VARIANT
      I_SAVE                        = GV_SAVE        "A
      I_DEFAULT                     = 'X'
      IS_LAYOUT                     = GS_LAYOUT
*     IT_TOOLBAR_EXCLUDING          = GT_UI_FUNCTIONS
    CHANGING
      IT_OUTTAB                     = GT_DATA
      IT_FIELDCATALOG               = GT_FIELDCAT
*     IT_SORT                       =
*     IT_FILTER                     = GT_FILTER
    EXCEPTIONS
      INVALID_PARAMETER_COMBINATION = 1
      PROGRAM_ERROR                 = 2
      TOO_MANY_LINES                = 3
      OTHERS                        = 4.

  IF SY-SUBRC <> 0.
    " ALV Grid 에 데이터를 전달하는 중 오류가 발생했습니다.
    MESSAGE E023.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH_ALV_0100
*&---------------------------------------------------------------------*
FORM REFRESH_ALV_0100.

  GS_STABLE-ROW = ABAP_ON.
  GS_STABLE-COL = ABAP_ON.

  CALL METHOD GO_ALV_GRID->REFRESH_TABLE_DISPLAY
    EXPORTING
      IS_STABLE = GS_STABLE  " With Stable Rows/Columns
*     I_SOFT_REFRESH =           " Without Sort, Filter, etc.
    EXCEPTIONS
      FINISHED  = 1                " Display was Ended (by Export)
      OTHERS    = 2.

  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
      WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

*--- ALV-Toolbar Button 조정
  PERFORM EXCLUDE_BUTTON  USING GT_UI_FUNCTIONS.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_EVENT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_EVENT_0100 .

  SET HANDLER : LCL_EVENT_HANDLER=>ON_TOP_OF_PAGE  FOR GO_ALV_GRID,
                LCL_EVENT_HANDLER=>ON_USER_COMMAND FOR GO_ALV_GRID,
                LCL_EVENT_HANDLER=>ON_TOOLBAR FOR GO_ALV_GRID,
                LCL_EVENT_HANDLER=>ON_DOUBLE_CLICK FOR GO_ALV_GRID,
                LCL_EVENT_HANDLER=>ON_HOTSPOT_CLICK FOR GO_ALV_GRID.

ENDFORM.
*&----------------------------------------------------------------------*
*& Form HANDLE_DOUBLE_CLICK
*&---------------------------------------------------------------------*
FORM HANDLE_DOUBLE_CLICK USING PS_ROW TYPE LVC_S_ROW
                               PS_COL     TYPE  LVC_S_COL
                               PO_SENDER  TYPE REF TO CL_GUI_ALV_GRID.
* 선택한 행이 인터널테이블에 있는 정상적인 데이터인지 체크
  CHECK PS_ROW-ROWTYPE IS INITIAL.

  IF PO_SENDER EQ GO_ALV_GRID.

    CLEAR ZEA_LFA1.
    CLEAR ZEA_SKA1.
    CLEAR ZEA_BKPF.

*--- READ TABLE - 선택한 Row
    CLEAR GS_DATA.
    READ TABLE GT_DATA INTO GS_DATA INDEX PS_ROW-INDEX.

    PERFORM FILL_SCREEN_BOX.


*--- Fill GT_DATA2 - Container2
    IF GS_DATA-AUGDT NE 'X'.        "X가 아닌 것 = 반제가 되지 않음 = 미결건'을 의미.

      PERFORM FILL_SCREEN_BOX.
      PERFORM FILL_DATA2 USING PS_ROW .  "GT_DATA2

    ELSE.     "미결건이 아닌 경우, (= 즉 이미 반제된 건인 경우, GT_DATA2에 추가될 수 없음)

      PERFORM FILL_SCREEN_BOX.

      MESSAGE '이미 반제된 건 입니다.' TYPE 'S'.
      PERFORM PBO_PAI.
      EXIT.

    ENDIF.
*
**--- Fill Screen 0200. 반제 팝업(다이올로그)
*    PERFORM FILL_SCREEN_0200 CHANGING CV_BN.   "AMOUNT SUM값 넣기

  ELSEIF PO_SENDER EQ GO_ALV_GRID_2.
* 선택한 행이 인터널테이블에 있는 정상적인 데이터인지 체크
    CHECK PS_ROW-ROWTYPE IS INITIAL.

*--- READ TABLE - 선택한 Row
    CLEAR GS_DATA2.
    READ TABLE GT_DATA2 INTO GS_DATA2 INDEX PS_ROW-INDEX.
    BELNR_200 = GS_DATA2-BELNR.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_FIELD_CATALOG
*&---------------------------------------------------------------------*
FORM MAKE_FIELD_CATALOG .

  LOOP AT GT_FIELDCAT INTO GS_FIELDCAT.

    CASE GS_FIELDCAT-FIELDNAME.

      WHEN 'STATUS'.
        GS_FIELDCAT-COLTEXT = TEXT-F01.   "반제

      WHEN 'ITNUM'.
        GS_FIELDCAT-JUST      = 'C'.

      WHEN 'MANDT' OR 'DROP_DOWN_HANDLE' OR 'EATAX'.
        GS_FIELDCAT-TECH = ABAP_ON.

      WHEN 'GTEXT' OR 'CELL_TAB' OR 'AUGDT' OR 'APAY_BOOK'.
        GS_FIELDCAT-NO_OUT = ABAP_ON.

      WHEN 'ZLSCH'.
        GS_FIELDCAT-COLTEXT = TEXT-F02. "지급조건


      WHEN 'MANG'.
        GS_FIELDCAT-COLTEXT = TEXT-F03. "만기일
        GS_FIELDCAT-COL_POS = 2.

*---추가

      WHEN 'WRBTR'.
        GS_FIELDCAT-CFIELDNAME = 'W_WAERS'.         " 통화 단위 참조
        GS_FIELDCAT-COLTEXT    = '현지통화금액'.
        GS_FIELDCAT-COL_POS    = 8.

      WHEN 'W_WAERS'.
        GS_FIELDCAT-COLTEXT    = '현지통화코드'.
        GS_FIELDCAT-COL_POS    = 9.

      WHEN 'DMBTR'.
        GS_FIELDCAT-CFIELDNAME    = 'D_WERKS'.     " 통화 단위 참조
        GS_FIELDCAT-COLTEXT       = '통화금액'.
        GS_FIELDCAT-COL_POS       = 6.

      WHEN 'D_WAERS'.
        GS_FIELDCAT-COLTEXT       = '통화코드'.
        GS_FIELDCAT-COL_POS       = 7.

      WHEN 'SAKNR'.
        GS_FIELDCAT-COL_POS       = 5.

      WHEN 'MATNR'.
        GS_FIELDCAT-NO_OUT = 'X'.

      WHEN 'AUGBL' OR 'BELNR'.
        GS_FIELDCAT-HOTSPOT = ABAP_ON.
    ENDCASE.

    MODIFY GT_FIELDCAT FROM GS_FIELDCAT.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_LINE_MESSAGE
*&---------------------------------------------------------------------*
FORM DISPLAY_LINE_MESSAGE .


  DATA LV_LINES TYPE I. "라인수를 전달하기 위한 로컬 변수 선언
  DESCRIBE TABLE GT_DATA LINES LV_LINES.

  " &건의 데이터가 검색되었습니다.
  MESSAGE S004 WITH LV_LINES.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form IUNPUT_STATUS
*&---------------------------------------------------------------------*
FORM IUNPUT_STATUS .

*--- AUGDT 반제여부 필드에 따라 Setting Open Status

  LOOP AT GT_DATA INTO GS_DATA.

    IF GS_DATA-AUGDT EQ 'X'.
      GS_DATA-STATUS = '3'.
    ELSE.
      GS_DATA-STATUS = '1'.
    ENDIF.

    MODIFY GT_DATA FROM GS_DATA.
  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_USER_COMMAND
*&---------------------------------------------------------------------*
FORM HANDLE_USER_COMMAND  USING   PV_UCOMM TYPE SY-UCOMM
                                  PO_SENDER  TYPE REF TO CL_GUI_ALV_GRID.

  CASE PO_SENDER.
    WHEN GO_ALV_GRID. "PO_SENDER 가 GO_ALV_GRID 일 때

      CASE PV_UCOMM.  " 선택한 버튼 (PV_UCOMM은 SY-UCOMM 타입)

        WHEN GC_OPEN.
          PERFORM DISPLAY_OPEN_ITEM.
          PERFORM SET_ALV_FILTER.

        WHEN GC_CLEARING.
          PERFORM DISPLAY_CLEARING_ITEM.
          PERFORM SET_ALV_FILTER.

        WHEN GC_ALL_ITEM.
          PERFORM DISPLAY_ALL_ITEM.
          PERFORM SET_ALV_FILTER.

        WHEN GC_PAY_BOOK.
          PERFORM SORT_DUE_DATE.

        WHEN GC_DUEDATE.
          PERFORM SORT_DUE_DATE.
      ENDCASE.

    WHEN GO_ALV_GRID_2.
      CASE PV_UCOMM.

        WHEN GC_PAY.

          PERFORM PAY_AP_TO_VENDER.

          PERFORM SET_ALV2_FILTER2.

      ENDCASE.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALL_ITEM
*&---------------------------------------------------------------------*
FORM DISPLAY_ALL_ITEM .

  REFRESH GT_FILTER.

  CLEAR GS_FILTER.
  GS_FILTER-FIELDNAME = 'STATUS'.

  GS_FILTER-SIGN      = 'I'.
  GS_FILTER-OPTION    = 'BT'.
  GS_FILTER-LOW       = '1'.
  GS_FILTER-HIGH       = '3'.

  APPEND GS_FILTER TO GT_FILTER.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FILTER
*&---------------------------------------------------------------------*
FORM SET_ALV_FILTER .

  " ALV에 Filter 정보를 적용하는 과정
  CALL METHOD GO_ALV_GRID->SET_FILTER_CRITERIA
    EXPORTING
      IT_FILTER = GT_FILTER                " Filter Conditions
    EXCEPTIONS
      OTHERS    = 1.

  IF SY-SUBRC NE 0.
    MESSAGE E000 WITH '필터 적용에 실패하였습니다'.
  ENDIF.

  " ALV가 새로고침될 때, 현재 라인, 열을 유지할 지
*  DATA GS_STABLE TYPE LVC_S_STBL.
  GS_STABLE-ROW = ABAP_ON.
  GS_STABLE-COL = ABAP_ON.

  " 적용된 Filter 기준으로 데이터를 출력
  CALL METHOD GO_ALV_GRID->REFRESH_TABLE_DISPLAY
    EXPORTING
      IS_STABLE = GS_STABLE                  " With Stable Rows/Columns
*     I_SOFT_REFRESH =                       " Without Sort, Filter, etc.
    EXCEPTIONS
      OTHERS    = 1.

  IF SY-SUBRC NE 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
      WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_CLEARING_ITEM
*&---------------------------------------------------------------------*
FORM DISPLAY_CLEARING_ITEM .

  REFRESH GT_FILTER.

  CLEAR GS_FILTER.
  GS_FILTER-FIELDNAME = 'STATUS'.
  GS_FILTER-SIGN      = 'I'.
  GS_FILTER-OPTION    = 'EQ'.
  GS_FILTER-LOW       = '3'.
  APPEND GS_FILTER TO GT_FILTER.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_OPEN_ITEM
*&---------------------------------------------------------------------*
FORM DISPLAY_OPEN_ITEM .

  REFRESH GT_FILTER.

  CLEAR GS_FILTER.
  GS_FILTER-FIELDNAME = 'STATUS'.
  GS_FILTER-SIGN      = 'I'.
  GS_FILTER-OPTION    = 'EQ'.
  GS_FILTER-LOW       = '1'.
  APPEND GS_FILTER TO GT_FILTER.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH_AND_SET_ALV_0100
*&---------------------------------------------------------------------*
FORM REFRESH_AND_SET_ALV_0100 .

*   ALV가 새로고침될 때, 현재 라인, 열을 유지할 지

  GS_STABLE-ROW = ABAP_ON.
  GS_STABLE-COL = ABAP_ON.

  " 적용된 Filter 기준으로 데이터를 출력
  CALL METHOD GO_ALV_GRID->REFRESH_TABLE_DISPLAY
    EXPORTING
      IS_STABLE = GS_STABLE             " With Stable Rows/Columns
*     I_SOFT_REFRESH =                  " Without Sort, Filter, etc.
    EXCEPTIONS
      OTHERS    = 1.

  IF SY-SUBRC NE 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
      WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FILL_DUE_DATE
*&---------------------------------------------------------------------*
FORM FILL_DUE_DATE .

  SELECT * FROM ZEA_FIT800 INTO CORRESPONDING FIELDS OF TABLE GT_FIT800.

  LOOP AT GT_DATA INTO GS_DATA WHERE VENCODE IS NOT INITIAL.
*    CLEAR GS_FIT800.
*
*    READ TABLE GT_FIT800 INTO GS_FIT800
*    WITH KEY VENCODE = GS_DATA-VENCODE.

    CASE GS_DATA-ZLSCH.

      WHEN 'T000' OR 'T600' . "현금 지급 (당일)
        GS_DATA-MANG =  GS_DATA-BLDAT.

      WHEN 'T015' OR 'T615' . "현금 지급 (익월 15일 이내)
        GS_DATA-MANG =  GS_DATA-BLDAT + 15 .

    ENDCASE.


    MODIFY GT_DATA FROM GS_DATA  TRANSPORTING  MANG.
    "INDEX SY-TABIX.
  ENDLOOP.

**--- 화면 변수에 값이 미리 들어가 있는 것을 방지하기 위한 Clear
  CLEAR ZEA_LFA1.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SORT_DUE_DATE
*&---------------------------------------------------------------------*
FORM SORT_DUE_DATE .

*-- Sort Table
  SORT GT_DATA BY MANG. "만기일 기준 인터널 테이블 내림차순 정렬

*-- Table Refresh
  CALL METHOD GO_ALV_GRID->REFRESH_TABLE_DISPLAY
    EXPORTING
      IS_STABLE = GS_STABLE                  " With Stable Rows/Columns
    EXCEPTIONS
      OTHERS    = 1.

  IF SY-SUBRC NE 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
      WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form F4_NAME
*&---------------------------------------------------------------------*
FORM F4_NAME .

*--- 1) 서치헬프에 사용될 스트럭처 및 ITAB 선언
  TYPES : BEGIN OF  TY_DATA,
            VENCODE TYPE ZEA_LFA1-VENCODE,
            BPNAME  TYPE ZEA_SKA1-BPNAME,
          END OF TY_DATA.

  DATA : LT_DATA TYPE TABLE OF TY_DATA,
         LS_DATA TYPE TY_DATA.

  CLEAR LT_DATA.
  CLEAR LS_DATA.

*---2) SELECT문으로 ITAB에 데이터 담기
  SELECT  VENCODE BPNAME
    FROM ZEA_LFA1 AS A
    JOIN ZEA_SKA1 AS B
    ON A~VENCODE EQ B~BPCODE
    INTO CORRESPONDING FIELDS OF TABLE LT_DATA.

  IF SY-SUBRC EQ 0 .
    MESSAGE S000 WITH TEXT-M01.
  ENDIF.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      RETFIELD        = 'VENCODE'   "ITAB의 필드 중 인풋값에 넣고자 하는 필드
      DYNPPROG        = SY-REPID    " 현재 프로그램의 아이디 (이름)
      DYNPNR          = SY-DYNNR    " 스크린 넘버*에러날 시 '1000'하드코딩
      DYNPROFIELD     = 'SO_VENCO'  "더블클릭 시 인풋값에 들어갈 값.
      VALUE_ORG       = 'S'          " Value return: C: cell by cell, S: structured
    TABLES
      VALUE_TAB       = LT_DATA     " 셀렉트문 작성한 ITAB명>
*     RETURN_TAB      =
    EXCEPTIONS
      PARAMETER_ERROR = 1
      NO_VALUES_FOUND = 2
      OTHERS          = 3.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_DUE_DATE
*&---------------------------------------------------------------------*
FORM SET_DUE_DATE .

  CASE GS_DATA-ZLSCH.

    WHEN 'T000' OR 'T600'. "현금(당일 지급)
      DDATE = GS_DATA-BLDAT.

    WHEN 'T015' OR 'T615'. "현금(익월 15일 이내 지급)
      DDATE = GS_DATA-BLDAT + 15.

  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form BUTTON_LINE_COUNT
*&---------------------------------------------------------------------*
FORM BUTTON_LINE_COUNT .

  DATA LV_LINES TYPE I. "라인수를 전달하기 위한 로컬 변수 선언
  LV_LINES = 0.

  LOOP AT GT_DATA INTO GS_DATA.
    CASE GS_DATA-STATUS.
      WHEN '1'.
        LV_LINES += 1.
      WHEN '3'.
        LV_LINES += 1.
*        LV_LINES = LV_LINES + 1.
      WHEN OTHERS.
        LV_LINES += 1.
    ENDCASE.
  ENDLOOP.

  " &건의 데이터가 검색되었습니다.
  MESSAGE S004 WITH LV_LINES.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT2_0100
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT2_0100 .


  CREATE OBJECT GO_CONTAINER_2
    EXPORTING
      CONTAINER_NAME = 'CCON2'
    EXCEPTIONS
      OTHERS         = 1.

  IF SY-SUBRC NE 0.
    MESSAGE E020. " Custom Container 생성 중 오류가 발생했습니다.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  CREATE OBJECT GO_ALV_GRID_2
    EXPORTING
      I_PARENT = GO_CONTAINER_2
    EXCEPTIONS
      OTHERS   = 1.

  IF SY-SUBRC NE 0.
    MESSAGE E021. " ALV Grid 생성 중 오류가 발생했습니다.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FIELDCAT2_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_FIELDCAT2_0100 .

  PERFORM GET_FIELDCAT_0100     USING    GT_DATA2
                                CHANGING GT_FIELDCAT2.

  PERFORM MAKE_FIELDCAT2_0100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM GET_FIELDCAT_0100  USING   PT_TAB TYPE STANDARD TABLE
                       CHANGING PT_FCAT TYPE LVC_T_FCAT.

  DATA: LO_DREF TYPE REF TO DATA.

  CREATE DATA LO_DREF LIKE PT_TAB.
  FIELD-SYMBOLS <LT_TAB> TYPE TABLE.
  ASSIGN LO_DREF->* TO <LT_TAB>.

  TRY.
      CALL METHOD CL_SALV_TABLE=>FACTORY
        IMPORTING
          R_SALV_TABLE = DATA(LR_TABLE)
        CHANGING
          T_TABLE      = <LT_TAB>.

    CATCH CX_SALV_MSG. " ALV: General Error Class with Message
  ENDTRY.

  PT_FCAT = CL_SALV_CONTROLLER_METADATA=>GET_LVC_FIELDCATALOG(
              R_COLUMNS      = LR_TABLE->GET_COLUMNS( )
              R_AGGREGATIONS = LR_TABLE->GET_AGGREGATIONS( )
            ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_FIELDCAT2_0100
*&---------------------------------------------------------------------*
FORM MAKE_FIELDCAT2_0100 .

  LOOP AT GT_FIELDCAT2 INTO GS_FIELDCAT2.

    CASE GS_FIELDCAT2-FIELDNAME.

      WHEN 'STATUS'.
        GS_FIELDCAT2-COLTEXT = TEXT-F01. "지급여부
        GS_FIELDCAT2-JUST = 'C'.
        GS_FIELDCAT2-ICON = ABAP_ON.
        GS_FIELDCAT2-OUTPUTLEN = 15.
        GS_FIELDCAT2-NO_OUT = 'X'.       "어차피 미지급건만 올라가기에 NO_OUT 처리함.

      WHEN 'BELNR'.
        GS_FIELDCAT2-COLTEXT = '전표번호'.
        GS_FIELDCAT2-JUST = 'C'.
        GS_FIELDCAT2-OUTPUTLEN = 20.

      WHEN 'VENCODE'.
        GS_FIELDCAT2-COLTEXT = '공급사 코드'.
        GS_FIELDCAT2-JUST = 'C'.
        GS_FIELDCAT2-OUTPUTLEN = 15.

      WHEN 'EATAX'.
        GS_FIELDCAT2-TECH = 'X'.

*--- Amount 관련
      WHEN 'WRBTR'.
        GS_FIELDCAT2-CFIELDNAME = 'W_WAERS'.         " 통화 단위 참조
        GS_FIELDCAT2-COLTEXT    = '현지통화금액'.

      WHEN 'W_WAERS'.
        GS_FIELDCAT2-COLTEXT    = '현지통화코드'.

      WHEN 'DMBTR'.
        GS_FIELDCAT2-CFIELDNAME    = 'D_WAERS'.     " 통화 단위 참조
        GS_FIELDCAT2-COLTEXT       = '통화금액'.

      WHEN 'D_WAERS'.
        GS_FIELDCAT2-COLTEXT       = '통화코드'.

    ENDCASE.

    MODIFY GT_FIELDCAT2 FROM GS_FIELDCAT2.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_LAYOUT2_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_LAYOUT2_0100 .

  CLEAR GS_LAYOUT2.
  CLEAR GS_VARIANT2.
  CLEAR GV_SAVE2.

  GS_LAYOUT2-EXCP_FNAME  = 'STATUS'.
  GS_LAYOUT2-EXCP_LED    = 'X'.
  GV_SAVE2 = 'X'.   " '' : Layout 저장불가

  GS_VARIANT2-REPORT = SY-REPID.
  GS_VARIANT2-HANDLE = 'GO_ALV_GRID_2'.
*  " 'U' : 저장한 사용자만 사용가능
*  " 'X' : Layout을 저장하면 모든 사용자가 사용 가능
*  " 'A' : Layout을 저장할 때 'U'/'X' 선택 가능

  GS_LAYOUT2-CWIDTH_OPT = ' '.
  GS_LAYOUT2-ZEBRA      = ABAP_ON.
  GS_LAYOUT2-SEL_MODE   = 'B'.     "하나의 벤더에 대해서만 지급처리 가능하게
*  " A: 다중 행, 다중 열 선택, 선택 박스 생성
*  " (셀 단위, 전체 선택도 가능)
**    GS_LAYOUT-SEL_MODE = 'B'. " B : 단일 행, 다중 열 선택, 기본 값
*  " 기본값으로 해도 Ctrl + y로 강제로 드래그 할 수는 있음
**    GS_LAYOUT-SEL_MODE = 'C'. " C : 다중 행, 다중 열 선택, 줄 단위 선택
*
**  GS_LAYOUT-GRID_TITLE = TEXT-T10.          " ALV TITLE TEXT
*  GS_LAYOUT-INFO_FNAME = 'COLOR'.           " 행 색상
**  GS_LAYOUT-EXCP_FNAME = 'LIGHT'.           " 신호등
**  GS_LAYOUT-EXCP_LED = ABAP_ON.             " 신호등 모양 변경
**  GS_LAYOUT-CTAB_FNAME = 'IT_FIELD_COLORS'. " 셀 별 색상
*  GS_LAYOUT-STYLEFNAME  = 'STYLE'.          " 스타일

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_EVENT2_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_EVENT2_0100 .

*  SET HANDLER LCL_EVENT_HANDLER=>ON_TOOLBAR FOR GO_ALV_GRID_2.
  SET HANDLER LCL_EVENT_HANDLER=>ON_DOUBLE_CLICK FOR GO_ALV_GRID_2.
*  SET HANDLER LCL_EVENT_HANDLER=>ON_USER_COMMAND FOR GO_ALV_GRID_2.
*  SET HANDLER LCL_EVENT_HANDLER=>ON_HOTSPOT_CLICK FOR GO_ALV_GRID_2.
  SET HANDLER LCL_EVENT_HANDLER=>ON_TOP_OF_PAGE FOR GO_ALV_GRID_2.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV2_0100
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV2_0100 .

  CALL METHOD GO_ALV_GRID_2->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
*     I_STRUCTURE_NAME              = ''
      IS_VARIANT                    = GS_VARIANT2
      I_SAVE                        = GV_SAVE2
      IS_LAYOUT                     = GS_LAYOUT2
    CHANGING
      IT_OUTTAB                     = GT_DATA2
      IT_FIELDCATALOG               = GT_FIELDCAT2
*     IT_SORT                       =
*     IT_FILTER                     =
    EXCEPTIONS
      INVALID_PARAMETER_COMBINATION = 1
      PROGRAM_ERROR                 = 2
      TOO_MANY_LINES                = 3
      OTHERS                        = 4.

  IF SY-SUBRC <> 0.
    " ALV Grid 에 데이터를 전달하는 중 오류가 발생했습니다.
    MESSAGE E023.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH_ALV2_0100
*&---------------------------------------------------------------------*
FORM REFRESH_ALV2_0100 .


*--- ALV-Refresh
  GS_STABLE-ROW = ABAP_ON.
  GS_STABLE-COL = ABAP_ON.

  CALL METHOD GO_ALV_GRID_2->REFRESH_TABLE_DISPLAY
    EXPORTING
      IS_STABLE = GS_STABLE  " With Stable Rows/Columns
*     I_SOFT_REFRESH =       " Without Sort, Filter, etc.
    EXCEPTIONS
      FINISHED  = 1          " Display was Ended (by Export)
      OTHERS    = 2.

  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
      WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.


*--- ALV-Toolbar Button 조정
  PERFORM EXCLUDE_BUTTON  USING GT_UI_FUNCTIONS.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form PAY_AP_TO_VENDER
*&---------------------------------------------------------------------*
FORM PAY_AP_TO_VENDER .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV2_FILTER2
*&---------------------------------------------------------------------*
FORM SET_ALV2_FILTER2 .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form PAY
*&---------------------------------------------------------------------*
FORM PAY .

* 1. ALV2 중 라인이 1개 이상 선택되었는지 점검.
  DATA : LT_ROWS TYPE LVC_T_ROW.
  DATA : LS_ROWS TYPE LVC_S_ROW.

  CALL METHOD GO_ALV_GRID_2->GET_SELECTED_ROWS
    IMPORTING
      ET_INDEX_ROWS = LT_ROWS.
  IF LT_ROWS[] IS INITIAL.
    MESSAGE '미지급 리스트에서 Line을 한 줄 이상 선택하세요.' TYPE 'I' DISPLAY LIKE 'E'.
    EXIT.
  ENDIF.

* 2. 지급 처리 관련 - Popup 호출
  DATA : LV_ANSWER TYPE C.

  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      TITLEBAR       = '대금 지급 처리'
      TEXT_QUESTION  = '지급을 처리 하시겠습니까?'
      TEXT_BUTTON_1  = '지급'
      TEXT_BUTTON_2  = '취소'
*     DISPLAY_CANCEL_BUTTON = 'X'
      START_COLUMN   = 25
      START_ROW      = 6
    IMPORTING
      ANSWER         = LV_ANSWER
    EXCEPTIONS
      TEXT_NOT_FOUND = 1
      OTHERS         = 2.


  IF LV_ANSWER NE '1'.    " - - - - NO

*---- 취소 메세지
    MESSAGE '처리가 취소되었습니다.' TYPE 'S'.

  ELSE.

***---- 지급 처리 진행 (POPUP으로 ALV띄우기)
*-----  Bank 선택 다이올로그 = > A/P 전표 자동 발생 함수 삽입( *STATUS 변경 )

    CALL SCREEN 200 STARTING AT 50 5.

    PERFORM REFRESH_ALV2_0100.
    PERFORM REFRESH_ALV_0100.

    EXIT.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form PAY_BOOK
*&---------------------------------------------------------------------*
FORM PAY_BOOK .



ENDFORM.
*&---------------------------------------------------------------------*
*& Form FILL_STATUS_DATA2
*&---------------------------------------------------------------------*
FORM FILL_DATA2 USING PS_ROW TYPE LVC_S_ROW.

*  해당 전표가 이미 추가되어 있는지를 점검
  READ TABLE GT_DATA2 INTO GS_DATA2 WITH KEY BELNR = GS_DATA-BELNR.

  IF SY-SUBRC EQ 0.   "성공 = 이미 추가됨을 의미.
    MESSAGE '이미 미지급 리스트에 추가된 건입니다.' TYPE 'W'.
    EXIT .
  ELSE.  "실패 = 즉, GT_DATA2에는 해당 전표번호를 가진 LINE이 없음.
    "중복값 없음 = 처음 추가함을 의미.

**--- GO_ALV_GRID_2에 값 쌓기 (단 미결건만 Select 가능)
    CLEAR GS_DATA2. "사용 전 초기화
*  벤더원장-벤더코드 = 벤더테이블-벤더코드
    SELECT SINGLE * FROM ZEA_BKPF AS A JOIN ZEA_BSEG AS B
      ON A~BELNR EQ B~BELNR
      WHERE A~BELNR EQ @GS_DATA-BELNR
      AND   B~AUGDT NE 'X'
                  INTO CORRESPONDING FIELDS OF @GS_DATA2.

    APPEND GS_DATA2 TO GT_DATA2.

*---  Setting Open Status / Amount
    LOOP AT GT_DATA2 INTO GS_DATA2.
      GS_DATA2-STATUS  =  1. "미결 STATUS 값 주기
*      GS_DATA2-VENCODE = ZEA_BSEG-BPCODE.
      MODIFY GT_DATA2 FROM GS_DATA2 TRANSPORTING STATUS. "WRBTR.
    ENDLOOP.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  F4HELP  INPUT
*&---------------------------------------------------------------------*
MODULE F4HELP INPUT.


  DATA : LT_RETURN_TAB TYPE DDSHRETVAL OCCURS 0,
         LS_RETURN_TAB LIKE LINE OF LT_RETURN_TAB.

  DATA: LT_DSELC TYPE DSELC OCCURS 0,
        LS_DSELC LIKE LINE OF LT_DSELC.

  DATA: LS_VALUE  TYPE SEAHLPRES,
        LT_VALUE  TYPE TABLE OF SEAHLPRES,
        LS_FIELD  TYPE DFIES,
        LT_FIELDS TYPE TABLE OF DFIES.

*--- 서치 헬프 띄울 itab 선언
  DATA  : LT_DATA LIKE TABLE OF ZEA_BKNA,
          LS_DATA LIKE ZEA_BKNA.

  DATA: LT_MAP TYPE TABLE OF DSELC WITH HEADER LINE.

  CLEAR : LT_DATA, LT_DATA[],
        LT_VALUE, LT_VALUE[],
        LT_FIELDS, LT_FIELDS[].

  SELECT * FROM ZEA_BKNA INTO TABLE LT_DATA
    ORDER BY BANKCODE.

  CLEAR LS_FIELD.
  LS_FIELD-FIELDNAME = 'BANKCODE'.
  LS_FIELD-INTLEN = 20.
  LS_FIELD-LENG = 20.
  LS_FIELD-OUTPUTLEN = 20.
  LS_FIELD-REPTEXT = '은행코드'.
  APPEND LS_FIELD TO LT_FIELDS.

  CLEAR LS_FIELD.
  LS_FIELD-FIELDNAME = 'BPBANK'.
  LS_FIELD-INTLEN = 20.
  LS_FIELD-LENG = 20.
  LS_FIELD-OUTPUTLEN = 20.
  LS_FIELD-REPTEXT = '은행명'.
  APPEND LS_FIELD TO LT_FIELDS.

  CLEAR LS_FIELD.
  LS_FIELD-FIELDNAME = 'ACCNT'.
  LS_FIELD-INTLEN = 20.
  LS_FIELD-LENG = 20.
  LS_FIELD-OUTPUTLEN = 20.
  LS_FIELD-REPTEXT = '계좌번호'.
  APPEND LS_FIELD TO LT_FIELDS.

  CLEAR LS_FIELD.
  LS_FIELD-FIELDNAME = 'SAKNR'.
  LS_FIELD-INTLEN = 20.
  LS_FIELD-LENG = 20.
  LS_FIELD-OUTPUTLEN = 20.
  LS_FIELD-REPTEXT = 'G/L계정'.
  APPEND LS_FIELD TO LT_FIELDS.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      RETFIELD        = 'BANKCODE'           " Name of return field in FIELD_TAB
      DYNPPROG        = SY-REPID          " Current program
      DYNPNR          = SY-DYNNR          " Screen number
*     DYNPROFIELD     = 'ZEA_STKO-BOMID'
      WINDOW_TITLE    = '한국타이어 법인 예금통장'  " Title for the hit list
      VALUE_ORG       = 'S'               " Value return: C: cell by cell, S: structured
    TABLES
*     FIELD_TAB       = LT_FIELDS[]
      VALUE_TAB       = LT_DATA[]                 " Table of values: entries cell by cell
      RETURN_TAB      = LT_RETURN_TAB[]
*     DYNPFLD_MAPPING = LT_MAP
    EXCEPTIONS
      PARAMETER_ERROR = 1                " Incorrect parameter
      NO_VALUES_FOUND = 2                " No values found
      OTHERS          = 3.

  IF SY-SUBRC EQ 0.
    READ TABLE LT_RETURN_TAB INTO LS_RETURN_TAB INDEX 1.
    IF SY-SUBRC EQ 0.
      ZEA_BKNA-BANKCODE = LS_RETURN_TAB-FIELDVAL.

      READ TABLE LT_DATA INTO LS_DATA WITH KEY
      BANKCODE = ZEA_BKNA-BANKCODE BINARY SEARCH.
      IF SY-SUBRC EQ 0.
        ZEA_BKNA-BANKCODE   = LS_DATA-BANKCODE.
        ZEA_BKNA-ACCNT      =   LS_DATA-ACCNT.
        ZEA_BKNA-BPBANK     = LS_DATA-BPBANK.
        ZEA_BKNA-SAKNR      = LS_DATA-SAKNR.

        LEAVE SCREEN.
      ENDIF.
    ENDIF.
  ENDIF.


ENDMODULE.
*&---------------------------------------------------------------------*
*& Form FILL_SCREEN_0200
*&---------------------------------------------------------------------*
FORM FILL_SCREEN_0200 CHANGING CV_BN.

  SELECT SINGLE * FROM ZEA_BKPF AS A JOIN ZEA_BSEG AS B
    ON  A~BELNR EQ B~BELNR
    INTO CORRESPONDING FIELDS OF ZEA_BSEG
           WHERE A~BELNR EQ BELNR_200
           AND B~BSCHL EQ '31'.

*--- Screen 200에 값 채우기
"BP CODE
  VENCODE = GS_DATA2-BPCODE.
"BLDAT
  POST_DATE     = SY-DATUM.                  "전기일
"XBNLR
  CV_BN           = BELNR_200.       "전표번호(KA)
 ZEA_FIT800-BELNR = BELNR_200.       "전표번호(KA)

"DMBTR
  GV_AMOUNT  = ZEA_BSEG-DMBTR.              "KA전표의 AMOUNT(USD또는KRW) 를 SUM한 값.
  OPEN_AMOUNT   = GV_AMOUNT.                "총 미결액(USD또는KRW)
  ZEA_FIT800-DMBTR = ZEA_BSEG-DMBTR.
"D_WAERS
  D_WAERS3      = ZEA_BSEG-D_WAERS.
  ZEA_FIT800-D_WAERS = ZEA_BSEG-D_WAERS.

"W_WAERS
  OPEN_AMOUNT2  = ZEA_BSEG-WRBTR.           "반제 금액(KRW)을 계산함
  ZEA_FIT800-WRBTR  = ZEA_BSEG-WRBTR.       "반제 금액(KRW)을 계산함
"W_WAERS
  D_WAERS2      = ZEA_BSEG-W_WAERS.
  ZEA_FIT800-W_WAERS   = ZEA_BSEG-W_WAERS.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH_TABLE
*&---------------------------------------------------------------------*
FORM REFRESH_TABLE .

  CALL METHOD GO_ALV_GRID->REFRESH_TABLE_DISPLAY( ).

  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
      WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  CALL METHOD GO_ALV_GRID_2->REFRESH_TABLE_DISPLAY( ).

  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
      WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SEND_MAIL
*&---------------------------------------------------------------------*
FORM SEND_MAIL .

  DATA: BCS_EXCEPTION        TYPE REF TO CX_BCS,
        ERRORTEXT            TYPE STRING,
        CL_SEND_REQUEST      TYPE REF TO CL_BCS,
        CL_DOCUMENT          TYPE REF TO CL_DOCUMENT_BCS,
        CL_RECIPIENT         TYPE REF TO IF_RECIPIENT_BCS,
        T_ATTACHMENT_HEADER  TYPE SOLI_TAB,
        WA_ATTACHMENT_HEADER LIKE LINE OF T_ATTACHMENT_HEADER,
        ATTACHMENT_SUBJECT   TYPE SOOD-OBJDES,

        SOOD_BYTECOUNT       TYPE SOOD-OBJLEN,
        MAIL_TITLE           TYPE SO_OBJ_DES,
        T_MAILTEXT           TYPE SOLI_TAB,
        WA_MAILTEXT          LIKE LINE OF T_MAILTEXT,
        SEND_TO              TYPE ADR6-SMTP_ADDR,
        SENT                 TYPE ABAP_BOOL.

  WA_MAILTEXT = '[KZ] A/P Clearing : 매입 대금을 지급하였습니다.'.
  APPEND WA_MAILTEXT TO T_MAILTEXT.
  CLEAR WA_MAILTEXT.

*
*  WA_MAILTEXT = '감사합니다.'.
*  APPEND WA_MAILTEXT TO T_MAILTEXT.
*  CLEAR WA_MAILTEXT.


  MAIL_TITLE = '한국타이어앤테크놀로지(주) - 매입채무 지급' .

  TRY.
      CL_SEND_REQUEST = CL_BCS=>CREATE_PERSISTENT( ).

      CL_DOCUMENT = CL_DOCUMENT_BCS=>CREATE_DOCUMENT( I_TYPE    = 'RAW' "#EC NOTEXT
                                                      I_TEXT    = T_MAILTEXT    " 메일 글 넣기
                                                      I_SUBJECT = MAIL_TITLE ). " 메일 타이틀 넣기

      CL_SEND_REQUEST->SET_DOCUMENT( CL_DOCUMENT ).

      " --------------------수신사 TO 넣기 ----------------------

      SEND_TO = 'HankookTire_Technology@naver.com'.

      "--------------------------------------------------------

      CL_RECIPIENT = CL_CAM_ADDRESS_BCS=>CREATE_INTERNET_ADDRESS( SEND_TO ).
      CL_SEND_REQUEST->ADD_RECIPIENT( CL_RECIPIENT ).

      SENT = CL_SEND_REQUEST->SEND( I_WITH_ERROR_SCREEN = 'X' ).

      COMMIT WORK.

      IF SENT = ABAP_TRUE.

        " 성공메시지
        MESSAGE S001 WITH SEND_TO '로 발송 되었습니다.' .

      ELSE.

        " 에러메시지

      ENDIF.

    CATCH CX_BCS INTO BCS_EXCEPTION.
      ERRORTEXT = BCS_EXCEPTION->IF_MESSAGE~GET_TEXT( ).
      MESSAGE ERRORTEXT TYPE 'I'.

  ENDTRY.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHECK_LINE
*&---------------------------------------------------------------------*
FORM CHECK_LINE CHANGING   LV_VENCODE.

  DATA LT_INDEX_ROWS TYPE LVC_T_ROW.
  DATA LS_INDEX_ROW LIKE LINE OF LT_INDEX_ROWS.

  DATA: LT_SELECTED_ROWS TYPE TABLE OF I,
        LV_ROW_COUNT     TYPE I.

  CALL METHOD GO_ALV_GRID->GET_SELECTED_ROWS
    IMPORTING
      ET_INDEX_ROWS = LT_INDEX_ROWS     " Indexes of Selected Rows
*     ET_ROW_NO     =                   " Numeric IDs of Selected Rows
    .

  DATA LV_SUBRC TYPE I.
  DATA LV_COUNT TYPE I.

*--- 행 선택 점검
  IF LT_INDEX_ROWS[] IS INITIAL .
    MESSAGE '반제된 전표 1건을 선택해주세요.' TYPE 'S' DISPLAY LIKE 'W'  .
  ELSE.
*--- 1행 이상 선택한 경우
    LOOP AT LT_INDEX_ROWS INTO LS_INDEX_ROW WHERE INDEX IS NOT INITIAL .

*--- GS_DATA(ALV) 내 선택된 행의 STATUS 점검
      READ TABLE GT_DATA INTO GS_DATA INDEX LS_INDEX_ROW-INDEX.
      IF GS_DATA-STATUS EQ '1'.
        MESSAGE '[오류 : 미결건 선택] 지급처리건만 발송 가능합니다.' TYPE 'W'.
      ENDIF.
    ENDLOOP.

    DATA : LV_ANSWER TYPE C.
    DATA : LV_VEN TYPE ZEA_FIT800-VENCODE.
    LV_VEN  = GS_DATA-VENCODE.

*--- 지급통지 팝업 출력
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        TITLEBAR       = '지급 통지'
        TEXT_QUESTION  = '(공급사 :' && LV_VEN && ')'
                         && '에게 지급통지 메일을 발송하시겠습니까?'
        TEXT_BUTTON_1  = '발송'
        START_COLUMN   = 25
        START_ROW      = 6
      IMPORTING
        ANSWER         = LV_ANSWER
      EXCEPTIONS
        TEXT_NOT_FOUND = 1
        OTHERS         = 2.

    CASE LV_ANSWER.
      WHEN '1'.    " - - - - YES

        PERFORM SEND_MAIL.  "지급 통지 버튼 선택 시

        MESSAGE '공급사' &&  LV_VEN
        &&'에게 지급통지 메일을 발송하였습니다.' TYPE 'S'.
        EXIT.
    ENDCASE.

    MESSAGE '발송이 취소되었습니다.' TYPE 'S'.
    EXIT.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CALL_SOST
*&---------------------------------------------------------------------*
FORM CALL_SOST .

*        SET PARAMETER ID 'ZEA_BELNR' FIELD GS_DISPLAY2-BELNR.
  CALL TRANSACTION 'SOST'.
*             AND SKIP FIRST SCREEN.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form COVERT_KRW
*&---------------------------------------------------------------------*
FORM COVERT_KRW CHANGING P_OPEN_AMOUNT TYPE ZEA_FIT800-DMBTR
                         P_OPEN_AMOUNT2 TYPE ZEA_FIT800-WRBTR.
*
**  환율 불러와  A/P(USD)를 원화로 환산
*  " 환율 기준일 : 전기일자(IV_BUDAT) 에 해당하는 'USD' 의 환율 값을 전표에 넣어준다
*
*  SELECT SINGLE * FROM ZEA_TCURR INTO ZEA_TCURR
*     WHERE GDATU EQ  SY-DATUM " 환율 기준일(KZ유형 전표-전기일)
*     AND   TCURR EQ  'USD'.   " 통화코드   (USD=IV_WAERS)
*
*
*  " 주말의 경우 환율 값이 없기 때문에 가장 마지막 환율 값을 읽어와야 한다.
*  IF GS_TCURR-GDATU EQ '00000000'.
*
*    SELECT * FROM ZEA_TCURR INTO TABLE GT_TCURR
*      WHERE TCURR = 'USD'
*        AND GDATU <= ZEA_TCURR-GDATU   " HEADER에 입력한 환산일
*        ORDER BY GDATU DESCENDING.
*
*    READ TABLE GT_TCURR INTO GS_TCURR INDEX 1.
*    " [환산금액] 통화금액(KRW) = 현지통화금액 * 환율 / 100 을 해야 .00 이 인식되지 않고 정확한 계산 값이 들어간다.
*    ZEA_BSEG-WRBTR   = ZEA_BSEG-DMBTR * GS_TCURR-UKURS / 100.
*    ZEA_BSEG-W_WAERS = 'KRW'.
*  ENDIF.
*
*  IF GS_DATA2-D_WAERS NE 'KRW'.
*
*
*    OPEN_AMOUNT =  GS_DATA2-WRBTR * 100.
*    OPEN_AMOUNT2 = GS_DATA2-WRBTR * 100.
*
*  ELSE.
*
**      ZEA_TCURR-UKURS " 환율 기준일에 해당하는 USD의 환율을 가지고 있음.
**     환산금액(KRW) = 총 매입금액 / 환율
*    OPEN_AMOUNT2 =  OPEN_AMOUNT / ZEA_TCURR-UKURS.
*  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_HOTSPOT_CLICK
*&---------------------------------------------------------------------*
FORM HANDLE_HOTSPOT_CLICK  USING    PS_ROW_ID TYPE LVC_S_ROW
                                PS_COLUMN_ID TYPE  LVC_S_COL
                                PO_SENDER    TYPE REF TO CL_GUI_ALV_GRID.


* 선택한 행이 인터널테이블에 있는 정상적인 데이터인지 체크
  CHECK PS_ROW_ID-ROWTYPE IS INITIAL.

  READ TABLE GT_DATA INTO GS_DATA INDEX PS_ROW_ID-INDEX.

  CASE PS_COLUMN_ID-FIELDNAME.

    WHEN 'AUGBL'.
      IF GS_DATA-AUGBL IS NOT INITIAL.

        SET PARAMETER ID 'ZEA_AUGBL' FIELD GS_DATA-AUGBL.
        CALL TRANSACTION 'ZEA_GL_DIS2'.

      ELSE.
        MESSAGE '[미결건 선택 오류] 반제전표가 존재하지 않습니다.' TYPE
        'E' DISPLAY LIKE 'S'.
        EXIT.
      ENDIF.

    WHEN 'BELNR'.
      SET PARAMETER ID 'ZEA_BELNR' FIELD GS_DATA-BELNR.
      CALL TRANSACTION 'ZEA_FI020'.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form FILL_SCREEN_BOX
*&---------------------------------------------------------------------*
FORM FILL_SCREEN_BOX .

*--- Select ZEA_LFA1 (고객명 가져오기)
  SELECT SINGLE * FROM ZEA_LFA1
    WHERE VENCODE EQ @GS_DATA-VENCODE
    INTO CORRESPONDING FIELDS OF @ZEA_LFA1.

  SELECT SINGLE * FROM ZEA_SKA1 WHERE BPCODE EQ @GS_DATA-VENCODE
    INTO CORRESPONDING FIELDS OF @ZEA_SKA1.

*--- Select ZEA_FIT800
  SELECT SINGLE *
     FROM  ZEA_BKPF AS A JOIN ZEA_BSEG AS B
     ON A~BELNR EQ B~BELNR
     WHERE A~BELNR EQ @GS_DATA-BELNR
      AND  B~BSCHL EQ '31'
    INTO CORRESPONDING FIELDS OF @ZEA_BKPF.

*--- Due Date Setting / Setting Screen 0100
  PERFORM SET_DUE_DATE.
  BLDAT = GS_DATA-BLDAT.
  BUDAT = GS_DATA-BUDAT.
  XBLNR = GS_DATA-XBLNR.
  GJAHR = 2024.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form PBO_PAI
*&---------------------------------------------------------------------*
FORM PBO_PAI .

  CALL FUNCTION 'SAPGUI_SET_FUNCTIONCODE'
    EXPORTING
      FUNCTIONCODE           = 'ENTE'              " Function code
    EXCEPTIONS
      FUNCTION_NOT_SUPPORTED = 1                " Not supported on this front end platform
      OTHERS                 = 2.

  CALL METHOD CL_GUI_CFW=>SET_NEW_OK_CODE
    EXPORTING
      NEW_CODE = 'ENTER'.          " New OK_CODE
ENDFORM.
