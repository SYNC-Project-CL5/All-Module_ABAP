*&---------------------------------------------------------------------*
*& Include          ZEA_GW_TES_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_0100
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT_0100 .

  PERFORM CREATE_OBJECT_TREE.
  PERFORM CREATE_OBJECT_ALV.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_FIELDCAT_0100 .

  PERFORM GET_FIELDCAT_0100   USING    GT_DISPLAY
                              CHANGING GT_FIELDCAT.

  PERFORM MAKE_FIELDCAT_0100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_FIELDCAT_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_DISPLAY
*&      <-- GT_FIELDCAT
*&---------------------------------------------------------------------*
FORM GET_FIELDCAT_0100  USING PT_DISPLAY  TYPE STANDARD TABLE
                              PT_FIELDCAT TYPE LVC_T_FCAT.
  TRY.
      CALL METHOD CL_SALV_TABLE=>FACTORY
        IMPORTING
          R_SALV_TABLE = DATA(LO_SALV_TABLE)           " Basis Class Simple ALV Tables
        CHANGING
          T_TABLE      = PT_DISPLAY.

      DATA(LO_COLUMNS) = LO_SALV_TABLE->GET_COLUMNS( ).
      DATA(LO_AGGREGATIONS) = LO_SALV_TABLE->GET_AGGREGATIONS( ).

      PT_FIELDCAT = CL_SALV_CONTROLLER_METADATA=>GET_LVC_FIELDCATALOG(
        R_COLUMNS = LO_COLUMNS
        R_AGGREGATIONS = LO_AGGREGATIONS ).


    CATCH CX_SALV_MSG. " ALV: General Error Class with Message
  ENDTRY.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM MAKE_FIELDCAT_0100 .

  LOOP AT GT_FIELDCAT INTO GS_FIELDCAT.

    CASE GS_FIELDCAT-FIELDNAME.

      WHEN 'MATNR' OR 'WERKS'.
        GS_FIELDCAT-HOTSPOT = ABAP_ON.
        GS_FIELDCAT-KEY = ABAP_ON.
        GS_FIELDCAT-JUST = 'C'.

      WHEN 'SCODE'.
        GS_FIELDCAT-KEY = ABAP_ON.
        GS_FIELDCAT-JUST = 'C'.

      WHEN 'MAKTX' OR 'PNAME1' OR 'SNAME'.
        GS_FIELDCAT-EMPHASIZE = 'C500'.
        GS_FIELDCAT-JUST = 'C'.

      WHEN 'CALQTY'.
        GS_FIELDCAT-EMPHASIZE = 'C300'.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.

      WHEN 'WEIGHT'.
        GS_FIELDCAT-EMPHASIZE = 'C300'.
        GS_FIELDCAT-QFIELDNAME = 'MEINS2'.

*      WHEN 'SUM_VALUE'.
*        GS_FIELDCAT-CFIELDNAME = 'WAERS'.

      WHEN  'PNAME1' OR 'SCODE' OR 'SNAME'.
        GS_FIELDCAT-JUST = 'C'.

      WHEN OTHERS.

    ENDCASE.
    MODIFY GT_FIELDCAT FROM GS_FIELDCAT.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_LAYOUT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_LAYOUT_0100 .

  CLEAR GS_LAYOUT.

  GS_LAYOUT-ZEBRA = ABAP_ON.
  GS_LAYOUT-CWIDTH_OPT = 'A'.
  GS_LAYOUT-SEL_MODE = 'B'.

  GS_LAYOUT-NO_ROWINS = ABAP_ON.
  GS_LAYOUT-NO_ROWMOVE = ABAP_ON.

  GS_LAYOUT-CTAB_FNAME = 'CELL_COLOR'.
  GS_LAYOUT-INFO_FNAME = 'ROWCOLOR'.
  GS_LAYOUT-STYLEFNAME = 'STYLE'.

  GS_LAYOUT-GRID_TITLE = TEXT-L02. " Search Result

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_EVENT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_EVENT_0100 .

  SET HANDLER LCL_EVENT_HANDLER=>ON_HOTSPOT_CLICK FOR GO_ALV_GRID.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_0100
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV_0100 .

  CLEAR GS_VARIANT.
  GS_VARIANT-REPORT = SY-REPID.
  GS_VARIANT-HANDLE = '0002'. " 프로그램 내 ALV 구별자

  GV_SAVE = 'A'. " 개인용/공용 모두 생성 가능하도록 설정

  GO_ALV_GRID->SET_TABLE_FOR_FIRST_DISPLAY(
    EXPORTING
      IS_VARIANT                    = GS_VARIANT  " Layout
      I_SAVE                        = GV_SAVE     " Save Layout
      IS_LAYOUT                     = GS_LAYOUT   " Layout
    CHANGING
      IT_OUTTAB                     = GT_DISPLAY  " Output Table
      IT_FIELDCATALOG               = GT_FIELDCAT " Field Catalog
    EXCEPTIONS
      INVALID_PARAMETER_COMBINATION = 1 " Wrong Parameter
      PROGRAM_ERROR                 = 2 " Program Errors
      TOO_MANY_LINES                = 3 " Too many Rows in Ready for Input Grid
      OTHERS                        = 4
  ).

  IF SY-SUBRC <> 0.
    MESSAGE 'ALV에 데이터를 설정하는 과정 중 오류가 발생했습니다.' TYPE 'E'.
  ENDIF.

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

  IF SY-SUBRC <> 0.
    MESSAGE E020.
  ENDIF.

  CREATE OBJECT GCL_DOCUMENT
    EXPORTING
      STYLE            = 'ALV_TO_HTML'
      BACKGROUND_COLOR = 1
      NO_MARGINS       = SPACE.

  IF SY-SUBRC NE 0.
    MESSAGE E021.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FIELDCAT2_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_FIELDCAT2_0100 .

  PERFORM GET_FIELDCAT2    USING    GT_DISPLAY2
                           CHANGING GT_FIELDCAT2.

  PERFORM MAKE_FIELDCAT2_0100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_FIELDCAT2
*&---------------------------------------------------------------------*
FORM GET_FIELDCAT2  USING PT_TAB TYPE STANDARD TABLE
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

*    CASE GS_FIELDCAT2-FIELDNAME.
*
*      WHEN 'STATUS'.
*        GS_FIELDCAT3-COL_POS = 0.
*        GS_FIELDCAT3-COLTEXT = '공정불량율'.
*        GS_FIELDCAT3-JUST    = 'C'.
*
*      WHEN 'BOMID'.
*        GS_FIELDCAT3-NO_OUT  = ABAP_ON.
*
*      WHEN 'PDQUAN' OR 'PDBAN' OR 'FNPD'.
*        GS_FIELDCAT3-QFIELDNAME = 'MEINS'.
**
*    ENDCASE.
**
*    MODIFY GT_FIELDCAT2 FROM GS_FIELDCAT2.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV2_0100
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV2_0100 .

  CLEAR GS_VARIANT.
  GS_VARIANT-REPORT = SY-REPID.
  GS_VARIANT-HANDLE = '0001'. " 프로그램 내 ALV 구별자

  GV_SAVE = 'A'. " 개인용/공용 모두 생성 가능하도록 설정

  CALL METHOD GO_ALV_GRID_2->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
*     I_STRUCTURE_NAME              = 'ZEA_SDT050'                 " Internal Output Table Structure Name
      IS_VARIANT                    = GS_VARIANT                 " Layout
      I_SAVE                        = GV_SAVE               " Save Layout
      IS_LAYOUT                     = GS_LAYOUT                " Layout
    CHANGING
      IT_OUTTAB                     = GT_DISPLAY2                 " Output Table
      IT_FIELDCATALOG               = GT_FIELDCAT2                 " Field Catalog
*     IT_SORT                       =                  " Sort Criteria
*     IT_FILTER                     =                  " Filter Criteria
    EXCEPTIONS
      INVALID_PARAMETER_COMBINATION = 1                " Wrong Parameter
      PROGRAM_ERROR                 = 2                " Program Errors
      TOO_MANY_LINES                = 3                " Too many Rows in Ready for Input Grid
      OTHERS                        = 4.
  IF SY-SUBRC <> 0.
    " ALV Grid 에 데이터를 전달하는 중 오류가 발생했습니다.
    MESSAGE E023.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT3_0100
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT3_0100 .

  CREATE OBJECT GO_CONTAINER_3
    EXPORTING
      CONTAINER_NAME = 'CCON3'
    EXCEPTIONS
      OTHERS         = 1.

  IF SY-SUBRC <> 0.
    MESSAGE E020.
  ENDIF.

  CREATE OBJECT GO_ALV_GRID_3
    EXPORTING
      I_PARENT = GO_CONTAINER_3
    EXCEPTIONS
      OTHERS   = 1.

  IF SY-SUBRC NE 0.
    MESSAGE E021.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FIELDCAT3_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_FIELDCAT3_0100 .

  PERFORM GET_FIELDCAT3    USING    GT_DISPLAY3
                           CHANGING GT_FIELDCAT3.

  PERFORM MAKE_FIELDCAT3_0100.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_FIELDCAT3
*&---------------------------------------------------------------------*
FORM GET_FIELDCAT3     USING PT_TAB TYPE STANDARD TABLE
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
*& Form MAKE_FIELDCAT3_0100
*&---------------------------------------------------------------------*
FORM MAKE_FIELDCAT3_0100 .

  LOOP AT GT_FIELDCAT3 INTO GS_FIELDCAT3.

    CASE GS_FIELDCAT3-FIELDNAME.

      WHEN 'MATNR' OR 'WERKS'.
        GS_FIELDCAT3-JUST    = 'C'.
        GS_FIELDCAT3-KEY     = ABAP_ON.

      WHEN 'CHARG'.
        GS_FIELDCAT3-JUST    = 'C'.
        GS_FIELDCAT3-KEY     = ABAP_ON.
        GS_FIELDCAT3-COL_POS = 0.

      WHEN 'SCODE' OR 'LVORM' OR 'PNAME1'.
        GS_FIELDCAT3-JUST    = 'C'.
        GS_FIELDCAT3-EMPHASIZE = 'C500'.

      WHEN 'CALQTY' OR 'REMQTY'.
        GS_FIELDCAT3-EMPHASIZE = 'C300'.
        GS_FIELDCAT3-QFIELDNAME = 'MEINS'.

      WHEN 'LVORM'.
        GS_FIELDCAT3-COLTEXT = '삭제플래그'.


    ENDCASE.

    MODIFY GT_FIELDCAT3 FROM GS_FIELDCAT3.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV3_0100
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV3_0100 .

  CLEAR GS_VARIANT.
  GS_VARIANT-REPORT = SY-REPID.
  GS_VARIANT-HANDLE = '0004'. " 프로그램 내 ALV 구별자

  GV_SAVE = 'A'. " 개인용/공용 모두 생성 가능하도록 설정

  CALL METHOD GO_ALV_GRID_3->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
*     I_STRUCTURE_NAME              = 'ZEA_SDT050'                 " Internal Output Table Structure Name
      IS_VARIANT                    = GS_VARIANT                 " Layout
      I_SAVE                        = GV_SAVE               " Save Layout
      IS_LAYOUT                     = GS_LAYOUT                " Layout
    CHANGING
      IT_OUTTAB                     = GT_DISPLAY3                 " Output Table
      IT_FIELDCATALOG               = GT_FIELDCAT3                 " Field Catalog
*     IT_SORT                       =                  " Sort Criteria
*     IT_FILTER                     =                  " Filter Criteria
    EXCEPTIONS
      INVALID_PARAMETER_COMBINATION = 1                " Wrong Parameter
      PROGRAM_ERROR                 = 2                " Program Errors
      TOO_MANY_LINES                = 3                " Too many Rows in Ready for Input Grid
      OTHERS                        = 4.
  IF SY-SUBRC <> 0.
    " ALV Grid 에 데이터를 전달하는 중 오류가 발생했습니다.
    MESSAGE E023.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH_ALV_0100_GRID_2_3
*&---------------------------------------------------------------------*
FORM REFRESH_ALV_0100_GRID_2_3 .

  DATA LS_STABLE TYPE LVC_S_STBL.
  LS_STABLE-ROW = ABAP_ON.
  LS_STABLE-COL = ABAP_ON.

  CALL METHOD GO_ALV_GRID_1->REFRESH_TABLE_DISPLAY
    EXPORTING
      IS_STABLE = LS_STABLE  " With Stable Rows/Columns
*     I_SOFT_REFRESH =           " Without Sort, Filter, etc.
    EXCEPTIONS
      FINISHED  = 1                " Display was Ended (by Export)
      OTHERS    = 2.

  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
      WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  CALL METHOD GO_ALV_GRID_2->REFRESH_TABLE_DISPLAY
    EXPORTING
      IS_STABLE = LS_STABLE  " With Stable Rows/Columns
*     I_SOFT_REFRESH =           " Without Sort, Filter, etc.
    EXCEPTIONS
      FINISHED  = 1                " Display was Ended (by Export)
      OTHERS    = 2.

  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
      WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& For Screen 0300.
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_0300
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT_0300 .

  CREATE OBJECT GO_CONTAINER_4
    EXPORTING
      CONTAINER_NAME = 'CCON4'
    EXCEPTIONS
      OTHERS         = 1.

  IF SY-SUBRC <> 0.
    MESSAGE E020.
  ENDIF.

  CREATE OBJECT GO_ALV_GRID_4
    EXPORTING
      I_PARENT = GO_CONTAINER_4
    EXCEPTIONS
      OTHERS   = 1.

  IF SY-SUBRC NE 0.
    MESSAGE E021.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FIELDCAT_0300
*&---------------------------------------------------------------------*
FORM SET_ALV_FIELDCAT_0300 .

  PERFORM GET_FIELDCAT    USING    GT_DISPLAY5
                          CHANGING GT_FIELDCAT4.

  PERFORM MAKE_FIELDCAT_0300.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_FIELDCAT
*&---------------------------------------------------------------------*
FORM GET_FIELDCAT  USING PT_TAB TYPE STANDARD TABLE
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
*& Form MAKE_FIELDCAT_0110
*&---------------------------------------------------------------------*
FORM MAKE_FIELDCAT_0300 .

  LOOP AT GT_FIELDCAT4 INTO GS_FIELDCAT4.

    CASE GS_FIELDCAT4-FIELDNAME.

      WHEN 'CHARG'.
        GS_FIELDCAT4-COL_POS = 1.
        GS_FIELDCAT4-KEY = ABAP_ON.
        GS_FIELDCAT4-HOTSPOT = ABAP_ON.
        GS_FIELDCAT4-JUST = 'C'.

      WHEN 'MATNR'.
        GS_FIELDCAT4-KEY = ABAP_ON.
        GS_FIELDCAT4-JUST = 'C'.

      WHEN 'WERKS'.
        GS_FIELDCAT4-JUST = 'C'.

      WHEN 'CALQTY' OR 'REMQTY'.
        GS_FIELDCAT4-QFIELDNAME = 'MEINS'.
        GS_FIELDCAT4-EMPHASIZE = 'C300'.

      WHEN 'ICON'.
        GS_FIELDCAT4-COLTEXT = '상태'.
        GS_FIELDCAT4-COL_POS = 0.
        GS_FIELDCAT4-JUST = 'C'.

      WHEN 'SCODE' OR 'LVORM'.
        GS_FIELDCAT4-JUST = 'C'.

      WHEN OTHERS.

    ENDCASE.
    MODIFY GT_FIELDCAT4 FROM GS_FIELDCAT4.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_LAYOUT_0300
*&---------------------------------------------------------------------*
FORM SET_ALV_LAYOUT_0300 .

  CLEAR GS_LAYOUT.

  GS_LAYOUT-ZEBRA = ABAP_ON.
  GS_LAYOUT-CWIDTH_OPT = 'A'.
  GS_LAYOUT-SEL_MODE = 'B'.

  GS_LAYOUT-NO_ROWINS = ABAP_ON.
  GS_LAYOUT-NO_ROWMOVE = ABAP_ON.

  GS_LAYOUT-CTAB_FNAME = 'CELL_COLOR'.
  GS_LAYOUT-INFO_FNAME = 'ROWCOLOR'.
  GS_LAYOUT-STYLEFNAME = 'STYLE'.

  GS_LAYOUT-GRID_TITLE = TEXT-L01. " Search Result
*  GS_LAYOUT-SMALLTITLE = ABAP_ON.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_0300
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV_0300 .

  CLEAR GS_VARIANT.
  GS_VARIANT-REPORT = SY-REPID.
  GS_VARIANT-HANDLE = '0001'. " 프로그램 내 ALV 구별자

  GV_SAVE = 'A'. " 개인용/공용 모두 생성 가능하도록 설정

  CALL METHOD GO_ALV_GRID_4->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
*     I_STRUCTURE_NAME              = 'ZEA_SDT050'                 " Internal Output Table Structure Name
      IS_VARIANT                    = GS_VARIANT                 " Layout
      I_SAVE                        = GV_SAVE               " Save Layout
      IS_LAYOUT                     = GS_LAYOUT                " Layout
    CHANGING
      IT_OUTTAB                     = GT_DISPLAY5                " Output Table
      IT_FIELDCATALOG               = GT_FIELDCAT4                 " Field Catalog
*     IT_SORT                       =                  " Sort Criteria
*     IT_FILTER                     =                  " Filter Criteria
    EXCEPTIONS
      INVALID_PARAMETER_COMBINATION = 1                " Wrong Parameter
      PROGRAM_ERROR                 = 2                " Program Errors
      TOO_MANY_LINES                = 3                " Too many Rows in Ready for Input Grid
      OTHERS                        = 4.
  IF SY-SUBRC <> 0.
    " ALV Grid 에 데이터를 전달하는 중 오류가 발생했습니다.
    MESSAGE E023.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH_ALV_0300
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM REFRESH_ALV_0300  USING PO_ALV_GRID_4 TYPE REF TO CL_GUI_ALV_GRID.


  CHECK PO_ALV_GRID_4 IS BOUND.

  DATA LS_STABLE TYPE LVC_S_STBL.

  LS_STABLE-ROW = ABAP_ON.
  LS_STABLE-COL = ABAP_ON.

  PO_ALV_GRID_4->REFRESH_TABLE_DISPLAY(
    EXPORTING
      IS_STABLE      = LS_STABLE  " With Stable Rows/Columns
      I_SOFT_REFRESH = ABAP_OFF   " Without Sort, Filter, etc.
    EXCEPTIONS
      FINISHED       = 1          " Display was Ended (by Export)
      OTHERS         = 2
  ).
  IF SY-SUBRC <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF..

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_NODE_0100
*&---------------------------------------------------------------------*
FORM CREATE_NODE_0100 .

  " NODE를 아래와 같은 구성으로 만듦
  " 출발국가 1
  "  ㄴ 출발도시 2
  "       ㄴ 항공사 3
  "             ㄴ 항공편 4

  GT_HEADER[] = CORRESPONDING #( GT_HEADER ).
  DELETE GT_HEADER WHERE BUKRS IS INITIAL.

  SORT GT_HEADER BY BUKRS WERKS SCODE MATNR.

  DATA LV_NODE_KEY_SUPER  TYPE N LENGTH 6.
  DATA LT_NODE_KEY_LEVEL  LIKE TABLE OF GV_NODE_KEY.

  GV_NODE_KEY += 1.
  CLEAR GS_NODE.
  GS_NODE-RELATKEY = SPACE. " 가장 최상위의 노드는 항상 공백이여야 한다.
  GS_NODE-NODE_KEY = LV_NODE_KEY_SUPER = GV_NODE_KEY.
  GS_NODE-ISFOLDER = ABAP_ON.
  GS_NODE-TEXT     = '회사코드/플랜트/저장위치/자재명'.
  GS_NODE-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
  APPEND GS_NODE TO GT_NODE.

  " 1레벨 생성
  INSERT LV_NODE_KEY_SUPER INTO LT_NODE_KEY_LEVEL INDEX 1.

  CLEAR GS_NODE_INFO.
  GS_NODE_INFO-BUKRS = SPACE.
  GS_NODE_INFO-WERKS = SPACE.
  GS_NODE_INFO-SCODE = SPACE.
  GS_NODE_INFO-MATNR = SPACE.
  GS_NODE_INFO-NODE_KEY = GV_NODE_KEY.
  APPEND GS_NODE_INFO TO GT_NODE_INFO.

  LOOP AT GT_HEADER INTO GS_HEADER.
    AT NEW BUKRS.

      " 폴더 노드 추가
      GV_NODE_KEY += 1.
      CLEAR GS_NODE.
      GS_NODE-RELATKEY = LV_NODE_KEY_SUPER.
      GS_NODE-NODE_KEY = LV_NODE_KEY_SUPER = GV_NODE_KEY.
      GS_NODE-ISFOLDER = ABAP_ON.
      GS_NODE-TEXT     = |{ GS_HEADER-BUKRS }|.
      GS_NODE-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
      APPEND GS_NODE TO GT_NODE.

      " 2레벨 생성
      INSERT LV_NODE_KEY_SUPER INTO LT_NODE_KEY_LEVEL INDEX 1.


      CLEAR GS_NODE_INFO.
      GS_NODE_INFO-BUKRS = GS_HEADER-BUKRS.
      GS_NODE_INFO-WERKS = SPACE.
      GS_NODE_INFO-SCODE = SPACE.
      GS_NODE_INFO-MATNR = SPACE.
      GS_NODE_INFO-NODE_KEY = GV_NODE_KEY.
      APPEND GS_NODE_INFO TO GT_NODE_INFO.

    ENDAT.

    AT NEW PNAME1.

      " 폴더 노드 추가
      GV_NODE_KEY += 1.
      CLEAR GS_NODE.
      GS_NODE-RELATKEY = LV_NODE_KEY_SUPER.
      GS_NODE-NODE_KEY = LV_NODE_KEY_SUPER = GV_NODE_KEY.
      GS_NODE-ISFOLDER = ABAP_ON.
      GS_NODE-TEXT     = |{ GS_HEADER-WERKS } : { GS_HEADER-PNAME1 }|.
      GS_NODE-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
      APPEND GS_NODE TO GT_NODE.

      " 2레벨 생성
      INSERT LV_NODE_KEY_SUPER INTO LT_NODE_KEY_LEVEL INDEX 1.


      CLEAR GS_NODE_INFO.
      GS_NODE_INFO-BUKRS = GS_HEADER-BUKRS.
      GS_NODE_INFO-WERKS = GS_HEADER-WERKS.
      GS_NODE_INFO-SCODE = SPACE.
      GS_NODE_INFO-MATNR = SPACE.
      GS_NODE_INFO-NODE_KEY = GV_NODE_KEY.
      APPEND GS_NODE_INFO TO GT_NODE_INFO.

    ENDAT.

    AT NEW SNAME.

      " 폴더 노드 추가
      GV_NODE_KEY += 1.
      CLEAR GS_NODE.
      GS_NODE-RELATKEY = LV_NODE_KEY_SUPER.
      GS_NODE-NODE_KEY = LV_NODE_KEY_SUPER = GV_NODE_KEY.
      GS_NODE-ISFOLDER = ABAP_ON.
      GS_NODE-TEXT     = |{ GS_HEADER-SCODE } : { GS_HEADER-SNAME }|.
      GS_NODE-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
      APPEND GS_NODE TO GT_NODE.

      " 2레벨 생성
      INSERT LV_NODE_KEY_SUPER INTO LT_NODE_KEY_LEVEL INDEX 1.


      CLEAR GS_NODE_INFO.
      GS_NODE_INFO-BUKRS = GS_HEADER-BUKRS.
      GS_NODE_INFO-WERKS = GS_HEADER-WERKS.
      GS_NODE_INFO-SCODE = GS_HEADER-SCODE.
      GS_NODE_INFO-MATNR = SPACE.
      GS_NODE_INFO-NODE_KEY = GV_NODE_KEY.
      APPEND GS_NODE_INFO TO GT_NODE_INFO.

    ENDAT.

    IF GS_HEADER-MATNR IS NOT INITIAL.
      GV_NODE_KEY += 1.

      CLEAR GS_NODE.
      " 2레벨 노드를 상위노드로 지정
      GS_NODE-RELATKEY = LV_NODE_KEY_SUPER.
      GS_NODE-NODE_KEY = GV_NODE_KEY.
      GS_NODE-ISFOLDER = ABAP_OFF.
*      GS_NODE-N_IMAGE  = ICON_FLIGHT.  " 비행기 모양의 아이콘
      GS_NODE-TEXT     = |{ GS_HEADER-MATNR } : { GS_HEADER-MAKTX }|.
      GS_NODE-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
      APPEND GS_NODE TO GT_NODE.

      CLEAR GS_NODE_INFO.
      GS_NODE_INFO-BUKRS = GS_HEADER-BUKRS.
      GS_NODE_INFO-WERKS = GS_HEADER-WERKS.
      GS_NODE_INFO-SCODE = GS_HEADER-SCODE.
      GS_NODE_INFO-MATNR = GS_HEADER-MATNR.
      GS_NODE_INFO-NODE_KEY = GV_NODE_KEY.
      APPEND GS_NODE_INFO TO GT_NODE_INFO.
    ELSE.
      " 자재명이 없을 경우
    ENDIF.

    AT END OF SNAME.

      " 2레벨 제거 및 1레벨의 상위노드 정보 조회
      DELETE LT_NODE_KEY_LEVEL INDEX 1.
      READ TABLE LT_NODE_KEY_LEVEL INTO LV_NODE_KEY_SUPER INDEX 1.

    ENDAT.

    AT END OF PNAME1.

      " 2레벨 제거 및 1레벨의 상위노드 정보 조회
      DELETE LT_NODE_KEY_LEVEL INDEX 1.
      READ TABLE LT_NODE_KEY_LEVEL INTO LV_NODE_KEY_SUPER INDEX 1.


    ENDAT.


    AT END OF BUKRS.

      " 2레벨 제거 및 1레벨의 상위노드 정보 조회
      DELETE LT_NODE_KEY_LEVEL INDEX 1.
      READ TABLE LT_NODE_KEY_LEVEL INTO LV_NODE_KEY_SUPER INDEX 1.

    ENDAT.

  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form EXPAND_ROOT_NODE_0100
*&---------------------------------------------------------------------*
FORM EXPAND_ROOT_NODE_0100 .

  GO_SIMPLE_TREE->EXPAND_ROOT_NODES(
*    EXPORTING
*      LEVEL_COUNT         =                  " Number of Levels to be Expanded
*      EXPAND_SUBTREE      =                  " 'X': Expand all Subsequent Nodes
*    EXCEPTIONS
*      FAILED              = 1                " General Error
*      ILLEGAL_LEVEL_COUNT = 2                " LEVEL_COUNT Must Be GE 0
*      CNTL_SYSTEM_ERROR   = 3                " "
*      OTHERS              = 4
  ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_TREE_EVENT_0100
*&---------------------------------------------------------------------*
FORM SET_TREE_EVENT_0100 .


  DATA LT_EVENT TYPE CNTL_SIMPLE_EVENTS.
  DATA LS_EVENT LIKE LINE OF LT_EVENT.

  CLEAR LS_EVENT.
  LS_EVENT-APPL_EVENT = ABAP_ON.
  LS_EVENT-EVENTID    = CL_GUI_SIMPLE_TREE=>EVENTID_NODE_DOUBLE_CLICK.
  APPEND LS_EVENT TO LT_EVENT.

  CALL METHOD GO_SIMPLE_TREE->SET_REGISTERED_EVENTS
    EXPORTING
      EVENTS = LT_EVENT " Event Table
*    EXCEPTIONS
*     CNTL_ERROR                = 1                " cntl_error
*     CNTL_SYSTEM_ERROR         = 2                " cntl_system_error
*     ILLEGAL_EVENT_COMBINATION = 3                " ILLEGAL_EVENT_COMBINATION
*     OTHERS = 4
    .
  IF SY-SUBRC <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  SET HANDLER LCL_EVENT_HANDLER=>ON_NODE_DOUBLE_CLICK FOR GO_SIMPLE_TREE.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_TREE
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT_TREE .

  CREATE OBJECT GO_DOCKING_CONTAINER
    EXPORTING
      SIDE      = CL_GUI_DOCKING_CONTAINER=>DOCK_AT_LEFT     " Side to Which Control is Docked
      EXTENSION = 300               " Control Extension
    EXCEPTIONS
      OTHERS    = 1.

  IF SY-SUBRC <> 0.
    MESSAGE E020. " Container 생성 중 오류가 발생했습니다.
  ENDIF.

  CREATE OBJECT GO_SIMPLE_TREE
    EXPORTING
      PARENT              = GO_DOCKING_CONTAINER " Parent Container
      NODE_SELECTION_MODE = CL_GUI_SIMPLE_TREE=>NODE_SEL_MODE_SINGLE
    EXCEPTIONS
      OTHERS              = 1.

  IF SY-SUBRC <> 0.
    MESSAGE E021. " TREE 객체 생성 중 오류가 발생했습니다.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_ALV
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT_ALV .

  CREATE OBJECT GO_CUSTOM_CONTAINER
    EXPORTING
      CONTAINER_NAME = GC_CUSTOM_CONTAINER_NAME " Name of the Screen CustCtrl Name to Link Container To
    EXCEPTIONS
      OTHERS         = 1.

  IF SY-SUBRC <> 0.
    MESSAGE E020. " Container 생성 중 오류가 발생했습니다.
  ENDIF.

  CREATE OBJECT GO_ALV_GRID
    EXPORTING
      I_PARENT = GO_CUSTOM_CONTAINER " Parent Container
    EXCEPTIONS
      OTHERS   = 1.

  IF SY-SUBRC <> 0.
    MESSAGE E021. " ALV 객체 생성 중 오류가 발생했습니다.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_DOCUMENT
*&---------------------------------------------------------------------*
FORM SET_DOCUMENT  USING PCL_DOCUMENT TYPE REF TO CL_DD_DOCUMENT.

  DATA : LCL_TABLE TYPE REF TO CL_DD_TABLE_ELEMENT,
         LCL_COL1  TYPE REF TO CL_DD_AREA,
         LCL_COL2  TYPE REF TO CL_DD_AREA,
         LCL_COL3  TYPE REF TO CL_DD_AREA,
         LCL_COL4  TYPE REF TO CL_DD_AREA,
         LCL_COL5  TYPE REF TO CL_DD_AREA,
         LCL_COL6  TYPE REF TO CL_DD_AREA,
         LCL_COL7  TYPE REF TO CL_DD_AREA,
         LCL_COL8  TYPE REF TO CL_DD_AREA,
         LCL_COL9  TYPE REF TO CL_DD_AREA,
         LCL_COL10 TYPE REF TO CL_DD_AREA,
         LCL_COL11 TYPE REF TO CL_DD_AREA,
         LCL_COL12 TYPE REF TO CL_DD_AREA,
         LCL_COL13 TYPE REF TO CL_DD_AREA,
         LCL_COL14 TYPE REF TO CL_DD_AREA,
         LCL_COL15 TYPE REF TO CL_DD_AREA,
         LCL_COL16 TYPE REF TO CL_DD_AREA,
         LCL_COL17 TYPE REF TO CL_DD_AREA.

  DATA : LV_TEXT TYPE SDYDO_TEXT_ELEMENT.

  PCL_DOCUMENT->INITIALIZE_DOCUMENT(
*    EXPORTING
*      FIRST_TIME       =                  " Internal Use
*      STYLE            =                  " Adjusting to the Style of a Particular GUI Environment
*      BACKGROUND_COLOR =                  " Color ID
*      BDS_STYLESHEET   =                  " Stylesheet Stored in BDS
*      NO_MARGINS       =                  " Document Generated Without Free Margins
  ).

*&---------------------------------------------------------------------*
  CALL METHOD PCL_DOCUMENT->ADD_TEXT
    EXPORTING
      TEXT         = '재고상태 조회'
      SAP_FONTSIZE = CL_DD_DOCUMENT=>LARGE
      SAP_EMPHASIS = CL_DD_AREA=>STRONG
      SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INV.

  CALL METHOD PCL_DOCUMENT->NEW_LINE.
  CALL METHOD PCL_DOCUMENT->NEW_LINE.

  CALL METHOD PCL_DOCUMENT->ADD_TABLE
    EXPORTING
      NO_OF_COLUMNS               = 17
      CELL_BACKGROUND_TRANSPARENT = 'X'
      WITH_HEADING                = SPACE
      BORDER                      = '0'
    IMPORTING
      TABLE                       = LCL_TABLE.

  CALL METHOD LCL_TABLE->ADD_COLUMN
    EXPORTING
      WIDTH  = '5'
    IMPORTING
      COLUMN = LCL_COL1.

  CALL METHOD LCL_TABLE->ADD_COLUMN
    EXPORTING
      WIDTH  = '50'
    IMPORTING
      COLUMN = LCL_COL2.

  CALL METHOD LCL_TABLE->ADD_COLUMN
    EXPORTING
      WIDTH  = '150'
    IMPORTING
      COLUMN = LCL_COL3.

  CALL METHOD LCL_TABLE->ADD_COLUMN
    EXPORTING
      WIDTH  = '5'
    IMPORTING
      COLUMN = LCL_COL4.

  CALL METHOD LCL_TABLE->ADD_COLUMN
    EXPORTING
      WIDTH  = '50'
    IMPORTING
      COLUMN = LCL_COL5.

  CALL METHOD LCL_TABLE->ADD_COLUMN
    EXPORTING
      WIDTH  = '200'
    IMPORTING
      COLUMN = LCL_COL6.

  CALL METHOD LCL_TABLE->ADD_COLUMN
    EXPORTING
      WIDTH  = '5'
    IMPORTING
      COLUMN = LCL_COL7.

  CALL METHOD LCL_TABLE->ADD_COLUMN
    EXPORTING
      WIDTH  = '50'
    IMPORTING
      COLUMN = LCL_COL8.

  CALL METHOD LCL_TABLE->ADD_COLUMN
    EXPORTING
      WIDTH  = '250'
    IMPORTING
      COLUMN = LCL_COL9.

  CALL METHOD LCL_TABLE->ADD_COLUMN
    EXPORTING
      WIDTH  = '5'
    IMPORTING
      COLUMN = LCL_COL10.

  CALL METHOD LCL_TABLE->ADD_COLUMN
    EXPORTING
      WIDTH  = '50'
    IMPORTING
      COLUMN = LCL_COL11.

  CALL METHOD LCL_TABLE->ADD_COLUMN
    EXPORTING
      WIDTH  = '70'
    IMPORTING
      COLUMN = LCL_COL12.

  CALL METHOD LCL_TABLE->ADD_COLUMN
    EXPORTING
      WIDTH  = '50'
    IMPORTING
      COLUMN = LCL_COL13.

  CALL METHOD LCL_TABLE->ADD_COLUMN
    EXPORTING
      WIDTH  = '5'
    IMPORTING
      COLUMN = LCL_COL14.

  CALL METHOD LCL_TABLE->ADD_COLUMN
    EXPORTING
      WIDTH  = '50'
    IMPORTING
      COLUMN = LCL_COL15.

  CALL METHOD LCL_TABLE->ADD_COLUMN
    EXPORTING
      WIDTH  = '70'
    IMPORTING
      COLUMN = LCL_COL16.

  CALL METHOD LCL_TABLE->ADD_COLUMN
    EXPORTING
      WIDTH  = '5'
    IMPORTING
      COLUMN = LCL_COL17.
*&---------------------------------------------------------------------*
  LV_TEXT = ICON_PLANT.
  CALL METHOD LCL_COL1->ADD_ICON
    EXPORTING
      SAP_ICON = 'ICON_PLANT '.

  LV_TEXT = '플랜트명 :  '.
  CALL METHOD LCL_COL2->ADD_TEXT
    EXPORTING
      TEXT         = LV_TEXT
      SAP_EMPHASIS = CL_DD_AREA=>STRONG
*     sap_fontsize = cl_dd_area=>list_heading_int
      SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND.

  LV_TEXT = GV_PNAME1.
  CALL METHOD LCL_COL3->ADD_TEXT
    EXPORTING
      TEXT         = LV_TEXT
      SAP_EMPHASIS = CL_DD_AREA=>STRONG
      SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND.

  CALL METHOD LCL_COL4->ADD_ICON
    EXPORTING
      SAP_ICON = 'ICON_STORE_LOCATION'.

  LV_TEXT = '저장창고 :  '.
  CALL METHOD LCL_COL5->ADD_TEXT
    EXPORTING
      TEXT         = LV_TEXT
      SAP_EMPHASIS = CL_DD_AREA=>STRONG
      SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND.

  LV_TEXT = GV_SNAME.
  CALL METHOD LCL_COL6->ADD_TEXT
    EXPORTING
      TEXT         = LV_TEXT
      SAP_EMPHASIS = CL_DD_AREA=>STRONG
      SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND.
**--------------------------------------------------------------------*
*  CALL METHOD LCL_TABLE->NEW_ROW.

  CALL METHOD LCL_COL7->ADD_ICON
    EXPORTING
      SAP_ICON = 'ICON_MATERIAL'.

  LV_TEXT = '자재명 :'.
  CALL METHOD LCL_COL8->ADD_TEXT
    EXPORTING
      TEXT         = LV_TEXT
      SAP_EMPHASIS = CL_DD_AREA=>STRONG
      SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND.

  LV_TEXT = GV_MAKTX.
  CALL METHOD LCL_COL9->ADD_TEXT
    EXPORTING
      TEXT         = LV_TEXT
      SAP_EMPHASIS = CL_DD_AREA=>STRONG
      SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND.

  CALL METHOD LCL_COL10->ADD_ICON
    EXPORTING
      SAP_ICON = 'ICON_STOCK'.

  LV_TEXT = '재고량 :'.
  CALL METHOD LCL_COL11->ADD_TEXT
    EXPORTING
      TEXT         = LV_TEXT
      SAP_EMPHASIS = CL_DD_AREA=>STRONG
      SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND.

  LV_TEXT = GV_CALQTY.
  WRITE GV_CALQTY TO LV_TEXT UNIT 'PKG'.
  CALL METHOD LCL_COL12->ADD_TEXT
    EXPORTING
      TEXT         = LV_TEXT
      SAP_EMPHASIS = CL_DD_AREA=>STRONG
      SAP_COLOR    = CL_DD_AREA=>LIST_GROUP_INT.

  LV_TEXT = 'PKG'.
  CALL METHOD LCL_COL13->ADD_TEXT
    EXPORTING
      TEXT         = LV_TEXT
      SAP_EMPHASIS = CL_DD_AREA=>STRONG
      SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND.

  CALL METHOD LCL_COL14->ADD_ICON
    EXPORTING
      SAP_ICON = 'ICON_STOCK'.

  LV_TEXT = '재고량 :'.
  CALL METHOD LCL_COL15->ADD_TEXT
    EXPORTING
      TEXT         = LV_TEXT
      SAP_EMPHASIS = CL_DD_AREA=>STRONG
      SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND.

*  LV_TEXT = |{ GV_WEIGHT NUMBER = USER }|.

  LV_TEXT = GV_WEIGHT.
  WRITE GV_WEIGHT TO LV_TEXT UNIT 'EA'.
  CALL METHOD LCL_COL16->ADD_TEXT
    EXPORTING
      TEXT         = LV_TEXT
      SAP_EMPHASIS = CL_DD_AREA=>STRONG
      SAP_COLOR    = CL_DD_AREA=>LIST_GROUP_INT.

  LV_TEXT = 'EA'.
  CALL METHOD LCL_COL17->ADD_TEXT
    EXPORTING
      TEXT         = LV_TEXT
      SAP_EMPHASIS = CL_DD_AREA=>STRONG
      SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND.

  CALL METHOD PCL_DOCUMENT->MERGE_DOCUMENT.

  CALL METHOD PCL_DOCUMENT->DISPLAY_DOCUMENT
    EXPORTING
      REUSE_CONTROL      = ABAP_ON           " HTML Control Reused
*     REUSE_REGISTRATION = ABAP_ON           " Event Registration Reused
*     CONTAINER          =                  " Name of Container (New Container Object Generated)
      PARENT             = GO_CONTAINER_2
    EXCEPTIONS
      HTML_DISPLAY_ERROR = 1.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_EVENT_0300
*&---------------------------------------------------------------------*
FORM SET_ALV_EVENT_0300 .
  SET HANDLER:
   LCL_EVENT_HANDLER=>ON_DOUBLE_CLICK FOR GO_ALV_GRID_4, " TOP ALV에게만 반응
   LCL_EVENT_HANDLER=>ON_USER_COMMAND FOR GO_ALV_GRID_4, " TOP ALV에게만 반응
   LCL_EVENT_HANDLER=>ON_TOOLBAR FOR GO_ALV_GRID_4. " TOP ALV에게만 반응

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MOVE_INFO
*&---------------------------------------------------------------------*
FORM MOVE_INFO .
  S0100-UNIT = 'PKG'.
*  ZEA_MMT190-ERZET = SY-UZEIT.
**  ZEA_MMT190-ERDAT = SY-DATUM.
  ZEA_MMT190-ERNAM = SY-UNAME.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_DATA_070
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_MMT070_MATNR
*&      --> LS_MMT070_WERKS
*&      --> LS_MMT070_SCODE
*&      --> LS_MMT070_CHARG
*&---------------------------------------------------------------------*
FORM SELECT_DATA_070  USING    PS_MMT070_MATNR
                               PS_MMT070_WERKS
                               PS_MMT070_SCODE.

  REFRESH GT_DISPLAY5.

  SELECT FROM ZEA_MMT070
     FIELDS *
      WHERE MATNR EQ @PS_MMT070_MATNR
        AND WERKS EQ @PS_MMT070_WERKS
        AND SCODE EQ @PS_MMT070_SCODE
       INTO CORRESPONDING FIELDS OF TABLE @GT_DISPLAY5.

ENDFORM.
