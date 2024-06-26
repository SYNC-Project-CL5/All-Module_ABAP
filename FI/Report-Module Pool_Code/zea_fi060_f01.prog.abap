*&---------------------------------------------------------------------*
*& Include         ZEA_OPEN_MANG_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_base_data
*&---------------------------------------------------------------------*
FORM GET_BASE_DATA .

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

  GS_VARIANT = VALUE #( REPORT  = SY-REPID
                        HANDLE  = 'GRD1' ).

  CLEAR : GT_FIELDCAT, GS_FIELDCAT.

  CLEAR GS_LAYOUT.
  GS_LAYOUT-GRID_TITLE = '매출채권'.
  GS_LAYOUT-EXCP_FNAME  = 'STATUS'.
  GS_LAYOUT-EXCP_LED    = 'X'.
  GS_LAYOUT-SEL_MODE    = 'B'.        "ALV  Grid 의 선택 모드는 셀 단위
  GS_LAYOUT-CWIDTH_OPT  = ABAP_ON.
  GS_LAYOUT-STYLEFNAME  = 'CELL_TAB'.

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
      LS_TOOLBAR-TEXT = TEXT-L01. " Sort for Due Date
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

  "중복 데이터 오류를 피하기 위해  인터널 테이블 속 데이터를 초기화함.
  SELECT * INTO CORRESPONDING FIELDS OF TABLE @GT_DATA
    FROM ZEA_FIT700 AS A JOIN ZEA_KNA1 AS B
    ON A~CUSCODE EQ B~CUSCODE

    WHERE   A~BUKRS IN @SO_COCO
    AND   A~BSCHL EQ '01'
    AND     B~CUSCODE IN @SO_CSTAC
    AND      A~BUDAT IN @SO_RESDT

    ORDER BY  B~CUSCODE ASCENDING.

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
    FROM ZEA_FIT700 AS A JOIN ZEA_KNA1 AS B
    ON A~CUSCODE EQ B~CUSCODE

    WHERE   A~BUKRS IN @SO_COCO
    AND    B~CUSCODE IN @SO_CSTAC

    AND    A~AUGDT NE 'X'
    AND    A~BSCHL EQ '01'
    AND    A~BUDAT IN @OPEN_DAT

    ORDER BY  B~CUSCODE ASCENDING.

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
    FROM ZEA_FIT700 AS A JOIN ZEA_KNA1 AS B
    ON A~CUSCODE EQ B~CUSCODE


    WHERE     A~BUKRS IN @SO_COCO
    AND  B~CUSCODE IN @SO_CSTAC
    AND    A~BSCHL EQ '01'
    AND    A~AUGDT EQ 'X'
    AND    A~BUDAT IN @OPEN_DAT
    ORDER BY  B~CUSCODE ASCENDING.

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
      RATIO = 60.

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

  GV_SAVE = 'A'.

  CALL METHOD GO_ALV_GRID->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
      I_STRUCTURE_NAME              = 'ZEA_FIT700'
      IS_VARIANT                    = GS_VARIANT
      I_SAVE                        = GV_SAVE
      I_DEFAULT                     = 'X'
      IS_LAYOUT                     = GS_LAYOUT
      IT_TOOLBAR_EXCLUDING          = GT_UI_FUNCTIONS
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

  GS_STABLE = VALUE #( COL = ABAP_TRUE
                        ROW = ABAP_TRUE ).

  CALL METHOD GO_ALV_GRID->REFRESH_TABLE_DISPLAY
    EXPORTING
      IS_STABLE = GS_STABLE.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_EVENT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_EVENT_0100 .

  SET HANDLER : LCL_EVENT_HANDLER=>TOP_OF_PAGE  FOR GO_ALV_GRID,
                LCL_EVENT_HANDLER=>ON_USER_COMMAND FOR GO_ALV_GRID,
                LCL_EVENT_HANDLER=>ON_TOOLBAR FOR GO_ALV_GRID,
                LCL_EVENT_HANDLER=>DOUBLE_CLICK FOR GO_ALV_GRID,
                LCL_EVENT_HANDLER=>ON_HOTSPOT_CLICK FOR GO_ALV_GRID.

ENDFORM.
*&----------------------------------------------------------------------*
*& Form GET_DATA_BKPF
*&---------------------------------------------------------------------*
FORM GET_DATA_BKPF USING PE_COLUMN TYPE LVC_S_COL
                         PE_ROW    TYPE LVC_S_ROW.

*--- READ TABLE - 선택한 Row
  READ TABLE GT_DATA INTO GS_DATA INDEX PE_ROW-INDEX.

  BLART  = 'DA' .
  BLDAT  = GS_DATA-BLDAT.
  BUDAT  = GS_DATA-BUDAT.

*--- Select ZEA_KNA1
  SELECT SINGLE *
    FROM ZEA_KNA1
    WHERE CUSCODE EQ @GS_DATA-CUSCODE
    INTO CORRESPONDING FIELDS OF @ZEA_KNA1.

*--- Select ZEA_BKPF
  SELECT SINGLE *
    FROM ZEA_BKPF
    WHERE BELNR EQ @GS_DATA-BELNR
    INTO CORRESPONDING FIELDS OF @ZEA_BKPF.

*--- Select ZEA_FIT700
  SELECT SINGLE *
     FROM  ZEA_FIT700
     WHERE BELNR EQ @GS_DATA-BELNR
    INTO CORRESPONDING FIELDS OF @ZEA_FIT700.

*--- Due Date Setting
  PERFORM SET_DUE_DATE_DDATE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_FIELD_CATALOG
*&---------------------------------------------------------------------*
FORM  MAKE_FIELD_CATALOG .

  LOOP AT GT_FIELDCAT INTO GS_FIELDCAT.

    CASE GS_FIELDCAT-FIELDNAME.

      WHEN 'STATUS'.
        GS_FIELDCAT-COLTEXT = TEXT-F01. "STATUS

      WHEN 'ITNUM'.
        GS_FIELDCAT-JUST      = 'C'.

      WHEN 'WRBTR'.
        GS_FIELDCAT-CFIELDNAME = 'W_WAERS'.         " 통화 단위 참조
        GS_FIELDCAT-COLTEXT    = '현지통화금액'.
        GS_FIELDCAT-COL_POS    = 8.

      WHEN 'W_WERKS'.
        GS_FIELDCAT-COLTEXT    = '현지통화코드'.
        GS_FIELDCAT-COL_POS    = 9.


      WHEN 'DMBTR'.
        GS_FIELDCAT-CFIELDNAME    = 'D_WERKS'.     " 통화 단위 참조
        GS_FIELDCAT-COLTEXT       = '통화금액'.
        GS_FIELDCAT-COL_POS       = 6.

      WHEN 'D_WAERS'.
        GS_FIELDCAT-COLTEXT       = '통화코드'.
        GS_FIELDCAT-COL_POS       = 7.

      WHEN 'EATAX'.
        GS_FIELDCAT-NO_OUT = 'X'.

      WHEN 'MANDT' OR 'DROP_DOWN_HANDLE' OR 'AUGDT'.
        GS_FIELDCAT-TECH = ABAP_ON.

      WHEN 'GTEXT' OR 'CELL_TAB'.
        GS_FIELDCAT-NO_OUT = ABAP_ON.

      WHEN 'ZLSCH'.
        GS_FIELDCAT-COL_POS = 2.
        GS_FIELDCAT-COLTEXT = TEXT-F02.

      WHEN 'MANG'.
        GS_FIELDCAT-COLTEXT = TEXT-F03.

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

    IF GS_DATA-AUGDT   = 'X'.
      GS_DATA-STATUS   = 3. "반제

    ELSE.
      GS_DATA-STATUS  =  1. "미결
    ENDIF.

    MODIFY GT_DATA FROM GS_DATA TRANSPORTING STATUS.
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

        WHEN GC_DUEDATE.
          PERFORM SORT_DUE_DATE.

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

  SELECT * FROM ZEA_FIT700 INTO CORRESPONDING FIELDS OF TABLE GT_FIT700.

  LOOP AT GT_DATA INTO GS_DATA WHERE CUSCODE IS NOT INITIAL.
    CLEAR GS_FIT700.

    READ TABLE GT_FIT700 INTO GS_FIT700 WITH KEY CUSCODE = GS_DATA-CUSCODE.

    CASE GS_DATA-ZLSCH.

      WHEN 'D000'. "현금(당일)
        GS_DATA-MANG =  GS_DATA-BLDAT.

      WHEN 'D600'. "현금(당일)
        GS_DATA-MANG =  GS_DATA-BLDAT.

      WHEN 'DT30'. "현금(30일 이내)
        GS_DATA-MANG =  GS_DATA-BLDAT + 30.

      WHEN 'DT63'. "현금(30일 이내)
        GS_DATA-MANG =  GS_DATA-BLDAT + 30.

      WHEN 'DT69'.  "현금(90일 이내)
        GS_DATA-MANG =  GS_DATA-BLDAT + 90.

      WHEN 'DT90'. "현금(90일 이내)
        GS_DATA-MANG =  GS_DATA-BLDAT + 90.

    ENDCASE.

    GS_DATA-W_WAERS = 'KRW'.

    MODIFY GT_DATA FROM GS_DATA  TRANSPORTING W_WAERS MANG.
    "INDEX SY-TABIX.
  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form SORT_DUE_DATE
*&---------------------------------------------------------------------*
FORM SORT_DUE_DATE .

  SORT GT_DATA BY MANG . "내림차순 정렬

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
*& Form F4_NAME
*&---------------------------------------------------------------------*
FORM F4_NAME .

*--- 1) 서치헬프에 사용될 스트럭처 및 ITAB 선언
  TYPES : BEGIN OF  TY_DATA,
            CUSCODE TYPE ZEA_KNA1-CUSCODE,
            BPNAME  TYPE ZEA_SKA1-BPNAME,
          END OF TY_DATA.

  DATA : LT_DATA TYPE TABLE OF TY_DATA,
         LS_DATA TYPE TY_DATA.

  CLEAR LT_DATA.
  CLEAR LS_DATA.

*---2) SELECT문으로 ITAB에 데이터 담기
  SELECT  CUSCODE BPNAME
    FROM ZEA_KNA1 AS A
    JOIN ZEA_SKA1 AS B
    ON A~CUSCODE EQ B~BPCODE
    INTO CORRESPONDING FIELDS OF TABLE LT_DATA.

  IF SY-SUBRC EQ 0 .
    MESSAGE S000 WITH TEXT-M01.
  ENDIF.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      RETFIELD        = 'CUSCODE'   "ITAB의 필드 중 인풋값에 넣고자 하는 필드
      DYNPPROG        = SY-REPID    " 현재 프로그램의 아이디 (이름)
      DYNPNR          = SY-DYNNR    " 스크린 넘버*에러날 시 '1000'하드코딩
      DYNPROFIELD     = 'SO_CUSAC'  "더블클릭 시 인풋값에 들어갈 값.
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

  CASE ZEA_KNA1-ZLSCH.

    WHEN 'D000'. "현금(당일)
      GS_DATA-MANG = ZEA_BKPF-BLART.

    WHEN 'D600'. "현금(당일)
      GS_DATA-MANG = ZEA_BKPF-BLDAT .

    WHEN 'DT30'. "현금(30일 이내)
      GS_DATA-MANG = ZEA_BKPF-BLDAT + 30.

    WHEN 'DT63'. "현금(30일 이내)
      GS_DATA-MANG = ZEA_BKPF-BLDAT + 30.

    WHEN 'DT69'.  "현금(90일 이내)
      GS_DATA-MANG = ZEA_BKPF-BLDAT + 90.

    WHEN 'DT90'. "현금(90일 이내)
      GS_DATA-MANG = ZEA_BKPF-BLDAT + 90.
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
*& Form AR_PAY
*&---------------------------------------------------------------------*
FORM AR_PAY .

  PERFORM CLEARING_AR.

  PERFORM REFRESH_ALV_0100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form AR_PAY_MAIL
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
FORM AR_PAY_MAIL .

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

  WA_MAILTEXT = '[독촉장] 대금을 지불을 요청드립니다.'.
  APPEND WA_MAILTEXT TO T_MAILTEXT.
  CLEAR WA_MAILTEXT.


  MAIL_TITLE = '한국타이어앤테크놀로지(주) - 대금 지급 요청 ' .

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
*& Form CLEARING_AR
*&---------------------------------------------------------------------*
FORM CLEARING_AR .
* 1. ALV2 중 라인이 1개 이상 선택되었는지 점검.
  DATA : LT_ROWS TYPE LVC_T_ROW.
  DATA : LS_ROWS TYPE LVC_S_ROW.
  DATA : LV_BELNR TYPE ZEA_FIT700-BELNR.

  CALL METHOD GO_ALV_GRID->GET_SELECTED_ROWS
    IMPORTING
      ET_INDEX_ROWS = LT_ROWS.

  IF LT_ROWS[] IS INITIAL.
    MESSAGE 'Line을 한 줄 이상 선택하세요.' TYPE 'I' DISPLAY LIKE 'E'.
    EXIT.
  ELSE.

* 2. A/R 반제 전표 팝업 호출
    DATA : LV_RECON  TYPE ZEA_FIT700-SAKNR,    "Recon (A/R)
           LV_AMOUNT TYPE ZEA_FIT700-DMBTR,    "Pay Amount
           LV_CURKY  TYPE ZEA_FIT700-D_WAERS,  "통화코드
           LV_BANK   TYPE  ZEA_SAKNR,          "예금 계정
           LV_XBLNR  TYPE ZEA_FIT700-XBLNR,     "DA 전표번호
           EV_BELNR  TYPE ZEA_FIT700-BELNR.     "DZ 전표번호


    CLEAR LS_ROWS.
    READ TABLE LT_ROWS INTO LS_ROWS INDEX 1.

*---3 GS_DATA(ALV) 내 선택된 행 반제여부 점검
    READ TABLE GT_DATA INTO GS_DATA INDEX LS_ROWS-INDEX.

    IF GS_DATA-STATUS EQ '3'.
      MESSAGE '[오류 : 지급건 선택] 이미 반제되었습니다.' TYPE 'W'.
      EXIT.
    ELSEIF   GS_DATA-STATUS EQ '1'.
      LV_BELNR = GS_DATA-BELNR.     "LV_BELNR에 선택한 라인의 전표번호를 담아둔다.

* 2. 입금 처리 관련 - Popup 호출
      DATA : LV_ANSWER TYPE C.

      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          TITLEBAR              = '반제 처리'
          TEXT_QUESTION         = '해당 미결건을 반제 처리 하시겠습니까?'
          TEXT_BUTTON_1         = '반제'
          TEXT_BUTTON_2         = '취소'
          DISPLAY_CANCEL_BUTTON = ' '

          START_COLUMN          = 25
          START_ROW             = 6
        IMPORTING
          ANSWER                = LV_ANSWER
        EXCEPTIONS
          TEXT_NOT_FOUND        = 1
          OTHERS                = 2.

      IF LV_ANSWER NE '1'.    " - - - - NO
*       ---- 취소 메세지
        MESSAGE '반제처리가 취소되었습니다.' TYPE 'S'.
        EXIT.
      ELSE.

* 3. 반제 Pop Up 물음에 대해 yes를 선택할 시,
*--- DZ유형의 전표를 생성한다.
        SELECT  SINGLE * FROM ZEA_SKB1 INTO ZEA_SKB1
          WHERE BPCODE EQ GS_DATA-CUSCODE.
        "Recon 계정을 찾는다.

        LV_RECON =  ZEA_SKB1-SAKNR.
        LV_AMOUNT = GS_DATA-DMBTR.
        LV_CURKY = GS_DATA-D_WAERS.
        LV_BANK =  '100000' .         "현금계정
        LV_BELNR  = GS_DATA-BELNR.   "선택한 라인의 (DA)전표번호

        CALL FUNCTION 'ZEA_FI_DZ'
          EXPORTING
            IV_AR_RECON   = LV_RECON          "  A/R G/L계정 (Recon)
            IV_BUDAT      = SY-DATUM          " 전기일자
            IV_PAY_AMOUNT = LV_AMOUNT         " 지급액(KRW)
            IV_WAERS      = LV_CURKY          " 통화코드
            IV_MBLNR      = LV_BELNR          " 참조문서 (DA전표번호)
            IV_BANK_SAKNR = LV_BANK           " 현금 G/L 계정 (BANK Recon)
          IMPORTING
            EV_BELNR      = EV_BELNR.         " 전표번호

        IF SY-SUBRC EQ 0.
          MESSAGE '(전표번호 :' && EV_BELNR && ')' &&
                  '반제 처리가 완료되었습니다.' TYPE 'S'.

*--- BSEG ( 아이템 테이블 )
* DA유형 전표 - 반제여부 필드/반제번호 필드 채우기 위해 GT_BSEG에 담기
          SELECT * FROM ZEA_BSEG
           WHERE BELNR EQ @LV_BELNR
          INTO CORRESPONDING FIELDS OF TABLE @GT_BSEG.

          LOOP AT GT_BSEG INTO GS_BSEG.
            GS_BSEG-AUGDT = 'X'.
            GS_BSEG-AUGBL = EV_BELNR.
            MODIFY GT_BSEG FROM GS_BSEG.

          ENDLOOP.

          MODIFY  ZEA_BSEG FROM TABLE GT_BSEG.

*--- FIT700 ( 고객 원장 테이블 )

          SELECT * FROM ZEA_FIT700
          WHERE BELNR EQ @LV_BELNR
          INTO CORRESPONDING FIELDS OF TABLE @GT_FIT700.

          LOOP AT GT_FIT700 INTO GS_FIT700 WHERE BELNR EQ LV_BELNR  .
            GS_FIT700-AUGDT = 'X'.
            GS_FIT700-AUGBL = EV_BELNR.
            MODIFY GT_FIT700 FROM GS_FIT700.
          ENDLOOP.

          MODIFY  ZEA_FIT700 FROM TABLE GT_FIT700.

*--- GT_DATA (인터널 테이블 Refresh)

          LOOP AT GT_DATA INTO GS_DATA WHERE BELNR EQ LV_BELNR.
            GS_DATA-STATUS = '3'.
            GS_DATA-AUGBL  = EV_BELNR.
            GS_DATA-AUGDT  = 'X'.
            MODIFY  GT_DATA  FROM GS_DATA.
          ENDLOOP.

        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHECK_LINE
*&---------------------------------------------------------------------*
FORM CHECK_LINE .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHECK_ROWS_STATUS
*&---------------------------------------------------------------------*
FORM CHECK_ROWS_STATUS .
* 1. ALV2 중 라인이 1개 이상 선택되었는지 점검.
  DATA : LT_ROWS TYPE LVC_T_ROW.
  DATA : LS_ROWS TYPE LVC_S_ROW.

  CALL METHOD GO_ALV_GRID->GET_SELECTED_ROWS
    IMPORTING
      ET_INDEX_ROWS = LT_ROWS.

  IF LT_ROWS[] IS INITIAL.
    MESSAGE 'Line을 한 줄 이상 선택하세요.' TYPE 'I' DISPLAY LIKE 'E'.
    EXIT.
  ELSE.

* 2. A/R 반제 전표 팝업 호출
    DATA : LV_RECON  TYPE ZEA_FIT700-SAKNR,    "Recon (A/R)
           LV_AMOUNT TYPE ZEA_FIT700-DMBTR,    "Pay Amount
           LV_CURKY  TYPE ZEA_FIT700-D_WAERS,  "통화코드
           LV_BANK   TYPE  ZEA_SAKNR,          "예금 계정
           LV_XBLNR  TYPE ZEA_FIT700-XBLNR,     "DA 전표번호
           EV_BELNR  TYPE ZEA_FIT700-BELNR.     "DZ 전표번호


    CLEAR LS_ROWS.
    READ TABLE LT_ROWS INTO LS_ROWS INDEX 1.

*---3 GS_DATA(ALV) 내 선택된 행 반제여부 점검
    READ TABLE GT_DATA INTO GS_DATA INDEX LS_ROWS-INDEX.
    IF GS_DATA-STATUS EQ '3'.
      MESSAGE '[오류 : 반제건 선택] 이미 반제되었습니다.' TYPE 'W'.
      EXIT.
    ELSEIF   GS_DATA-STATUS EQ '1'.
      DATA : LV_ANSWER TYPE C.
      DATA : LV_CUS TYPE ZEA_FIT700-CUSCODE.
      LV_CUS  = GS_DATA-CUSCODE.

*--- 지급통지 팝업 출력
      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          TITLEBAR       = '지급 통지'
          TEXT_QUESTION  = '(고객사 :' && LV_CUS && ')'
                           && '에게 독촉장을 발송하시겠습니까?'
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

          PERFORM AR_PAY_MAIL.        "독촉장 생성

          MESSAGE '고객사' &&  LV_CUS
          &&'에게 독촉장을 발송하였습니다.' TYPE 'S'.
          EXIT.
      ENDCASE.

      MESSAGE '발송이 취소되었습니다.' TYPE 'S'.
      EXIT.
    ENDIF.
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
*& Form SET_DUE_DATE_DDATE
*&---------------------------------------------------------------------*
FORM SET_DUE_DATE_DDATE .
* 화면 Screen 100 내 DDATE 변수에 값 넣기

  DDATE = GS_DATA-MANG.

*  CASE GS_DATA-ZLSCH.
*
*    WHEN 'D000'. "현금(당일)
*      DDATE = ZEA_FIT700-BUDAT.
*
*    WHEN 'D600'. "현금(당일)
*      DDATE = ZEA_FIT700-BUDAT.
*
*    WHEN 'DT30'. "현금(30일 이내)
*      DDATE = ZEA_FIT700-BUDAT + 30.
*
*    WHEN 'DT63'. "현금(30일 이내)
*      DDATE = ZEA_FIT700-BUDAT + 30.
*
*    WHEN 'DT69'.  "현금(90일 이내)
*      DDATE = ZEA_FIT700-BUDAT + 90.
*
*    WHEN 'DT90'. "현금(90일 이내)
*      DDATE  = ZEA_FIT700-BUDAT + 90.
*  ENDCASE.
*
*
ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_HOTSPOT_CLICK
*&---------------------------------------------------------------------*
FORM HANDLE_HOTSPOT_CLICK USING PS_ROW_ID TYPE LVC_S_ROW
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
