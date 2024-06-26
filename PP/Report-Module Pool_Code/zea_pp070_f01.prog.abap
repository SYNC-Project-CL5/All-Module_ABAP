*&---------------------------------------------------------------------*
*& Include          YE00_EX007F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_0100
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT_0100 .

  PERFORM CREATE_OBJECT_TREE.
  PERFORM CREATE_OBJECT_ALV.

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

  " 생산계획 데이터
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

  " BOM 계산 데이터
  CREATE OBJECT GO_CUSTOM_CONTAINER2
    EXPORTING
      CONTAINER_NAME = GC_CUSTOM_CONTAINER_NAME2 " Name of the Screen CustCtrl Name to Link Container To
    EXCEPTIONS
      OTHERS         = 1.

  IF SY-SUBRC <> 0.
    MESSAGE E020. " Container 생성 중 오류가 발생했습니다.
  ENDIF.

  CREATE OBJECT GO_SPLIT
    EXPORTING
      PARENT  = GO_CUSTOM_CONTAINER2       " Parent Container
      ROWS    = 1                  " Number of Rows to be displayed
      COLUMNS = 2                  " Number of Columns to be Displayed
    EXCEPTIONS
      OTHERS  = 1.

  IF SY-SUBRC <> 0.
    MESSAGE '분리 컨테이너 생성에 실패했습니다.' TYPE 'E'.
  ENDIF.

  " CLASSIC 한 메소드 호출 방법
  CALL METHOD GO_SPLIT->GET_CONTAINER
    EXPORTING
      ROW       = 1 " Row
      COLUMN    = 1 " Column
    RECEIVING
      CONTAINER = GO_CON_LEFT. " Container

  CALL METHOD GO_SPLIT->GET_CONTAINER
    EXPORTING
      ROW       = 1 " Row
      COLUMN    = 2 " Column
    RECEIVING
      CONTAINER = GO_CON_RIGHT. " Container

  " 신문법 중 하나
  GO_CON_LEFT = GO_SPLIT->GET_CONTAINER( ROW = 1 COLUMN = 1 ).
  GO_CON_RIGHT = GO_SPLIT->GET_CONTAINER( ROW = 1 COLUMN = 2 ).


  " TOP 컨테이너에 ALV를 생성
  CREATE OBJECT GO_ALV_GRID_LEFT
    EXPORTING
      I_PARENT = GO_CON_LEFT " Parent Container
    EXCEPTIONS
      OTHERS   = 1.

  IF SY-SUBRC NE 0.
    MESSAGE 'TOP ALV 생성에 실패했습니다.' TYPE 'E'.
  ENDIF.

  " BOT 컨테이너에 ALV를 생성
  CREATE OBJECT GO_ALV_GRID_RIGHT
    EXPORTING
      I_PARENT = GO_CON_RIGHT
    EXCEPTIONS
      OTHERS   = 1.
  IF SY-SUBRC NE 0.
    MESSAGE 'BOT ALV 생성에 실패했습니다.' TYPE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_NODE_0100
*&---------------------------------------------------------------------*
FORM CREATE_NODE_0100 .

  " NODE를 아래와 같은 구성으로 만듦
  " 회사코드 1
  "  ㄴ 플랜트명 2
  "     ㄴ 년도 3
  "       ㄴ 자재명 4
  SORT GT_HEADER BY PDPDAT BUKRS WERKS MATNR.

  DATA LV_NODE_KEY_SUPER  TYPE N LENGTH 6.
  DATA LT_NODE_KEY_LEVEL  LIKE TABLE OF GV_NODE_KEY.
  DATA LV_BUTXT TYPE C LENGTH 25.

  GV_NODE_KEY += 1.
  CLEAR GS_NODE.
  GS_NODE-RELATKEY = SPACE. " 가장 최상위의 노드는 항상 공백이여야 한다.
  GS_NODE-NODE_KEY = LV_NODE_KEY_SUPER = GV_NODE_KEY.
  GS_NODE-ISFOLDER = ABAP_ON.
  GS_NODE-TEXT     = '생산년도/회사코드/플랜트/자재'.
  GS_NODE-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
  APPEND GS_NODE TO GT_NODE.

*  " 1레벨 생성
  INSERT LV_NODE_KEY_SUPER INTO LT_NODE_KEY_LEVEL INDEX 1.

  CLEAR GS_NODE_INFO.
  GS_NODE_INFO-PDPDAT = SPACE.
  GS_NODE_INFO-BUKRS = SPACE.
  GS_NODE_INFO-WERKS = SPACE.
  GS_NODE_INFO-MATNR = SPACE.
  GS_NODE_INFO-NODE_KEY = GV_NODE_KEY.
  APPEND GS_NODE_INFO TO GT_NODE_INFO.
*
  LOOP AT GT_HEADER INTO GS_HEADER.
    AT NEW PDPDAT. " AT NEW 는 GT_HEADER에서 첫번째 필드부터 BUKRS 필드까지의 값을 기준으로
      " 이전 데이터과 비교해서 신규 데이터일 경우에만 작동한다.

      " 폴더 노드 추가
      GV_NODE_KEY += 1.
      CLEAR GS_NODE.
      GS_NODE-RELATKEY = LV_NODE_KEY_SUPER.
      GS_NODE-NODE_KEY = LV_NODE_KEY_SUPER = GV_NODE_KEY.
      GS_NODE-ISFOLDER = ABAP_ON.
      GS_NODE-TEXT     = |{ GS_HEADER-PDPDAT }년 생산계획|.
      GS_NODE-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
      APPEND GS_NODE TO GT_NODE.
*
      " 2레벨 생성
      INSERT LV_NODE_KEY_SUPER INTO LT_NODE_KEY_LEVEL INDEX 1.

      CLEAR GS_NODE_INFO.
      GS_NODE_INFO-PDPDAT = GS_HEADER-PDPDAT.
      GS_NODE_INFO-BUKRS  = SPACE.
      GS_NODE_INFO-WERKS  = SPACE.
      GS_NODE_INFO-MATNR  = SPACE.
      GS_NODE_INFO-NODE_KEY = GV_NODE_KEY.
      APPEND GS_NODE_INFO TO GT_NODE_INFO.

    ENDAT.

    AT NEW BUKRS.

      SELECT SINGLE BUTXT
        FROM ZEA_FIT000
        INTO LV_BUTXT
        WHERE BUKRS EQ GS_HEADER-BUKRS.

      " 폴더 노드 추가
      GV_NODE_KEY += 1.
      CLEAR GS_NODE.
      GS_NODE-RELATKEY = LV_NODE_KEY_SUPER.
      GS_NODE-NODE_KEY = LV_NODE_KEY_SUPER = GV_NODE_KEY.
      GS_NODE-ISFOLDER = ABAP_ON.
      GS_NODE-TEXT     = |{ GS_HEADER-BUKRS } - { LV_BUTXT }|.
      GS_NODE-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
      APPEND GS_NODE TO GT_NODE.

      " 2레벨 생성
      INSERT LV_NODE_KEY_SUPER INTO LT_NODE_KEY_LEVEL INDEX 1.


      CLEAR GS_NODE_INFO.
      GS_NODE_INFO-PDPDAT = GS_HEADER-PDPDAT.
      GS_NODE_INFO-BUKRS = GS_HEADER-BUKRS.
      GS_NODE_INFO-WERKS = SPACE.
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
      GS_NODE-TEXT     = |{ GS_HEADER-WERKS } - { GS_HEADER-PNAME1 }|.
      GS_NODE-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
      APPEND GS_NODE TO GT_NODE.

      " 4레벨 생성
      INSERT LV_NODE_KEY_SUPER INTO LT_NODE_KEY_LEVEL INDEX 1.


      CLEAR GS_NODE_INFO.
      GS_NODE_INFO-PDPDAT = GS_HEADER-PDPDAT.
      GS_NODE_INFO-BUKRS = GS_HEADER-BUKRS.
      GS_NODE_INFO-WERKS = GS_HEADER-WERKS.
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
      GS_NODE-N_IMAGE  =  ICON_CAR.  " 자동차 모양 아이콘
      GS_NODE-TEXT     = |{ GS_HEADER-MATNR } - { GS_HEADER-MAKTX } |.
      GS_NODE-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
      APPEND GS_NODE TO GT_NODE.

      CLEAR GS_NODE_INFO.
      GS_NODE_INFO-PDPDAT = GS_HEADER-PDPDAT.
      GS_NODE_INFO-BUKRS = GS_HEADER-BUKRS.
      GS_NODE_INFO-WERKS = GS_HEADER-WERKS.
      GS_NODE_INFO-MATNR = GS_HEADER-MATNR.
      GS_NODE_INFO-NODE_KEY = GV_NODE_KEY.
      APPEND GS_NODE_INFO TO GT_NODE_INFO.
    ELSE.
      " 자재코드가 없는 경우
    ENDIF.

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

    AT END OF PDPDAT.

      " 2레벨 제거 및 1레벨의 상위노드 정보 조회
      DELETE LT_NODE_KEY_LEVEL INDEX 1.
      READ TABLE LT_NODE_KEY_LEVEL INTO LV_NODE_KEY_SUPER INDEX 1.

    ENDAT.

  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_DATA
*&---------------------------------------------------------------------*
FORM SELECT_DATA .

  REFRESH GT_HEADER.

  SELECT FROM ZEA_PLAF AS A
                                 LEFT JOIN ZEA_T001W  AS B ON  B~WERKS  EQ A~WERKS
                                 LEFT JOIN ZEA_PPT010 AS C ON  C~PLANID EQ A~PLANID
                                      JOIN ZEA_MMT020 AS D ON  D~MATNR  EQ C~MATNR
                                                           AND D~SPRAS  EQ @SY-LANGU
    FIELDS  A~PDPDAT,
            B~BUKRS,
            B~WERKS,
*            B~WERKS,
            B~PNAME1,
            C~MATNR,
            D~MAKTX
    WHERE C~WERKS EQ '10000'
      AND C~LOEKZ NE 'X'
       INTO TABLE @GT_HEADER.

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
*& Form HANDLE_NODE_DOUBLE_CLICK
*&---------------------------------------------------------------------*
FORM  HANDLE_NODE_DOUBLE_CLICK  USING PV_NODE_KEY TYPE MTREESNODE-NODE_KEY
                                     PV_SENDER   TYPE REF TO CL_GUI_SIMPLE_TREE.

  IF GO_ALV_GRID IS INITIAL.
    " 출력할 ALV가 없습니다.
    MESSAGE S000 DISPLAY LIKE 'E' WITH TEXT-E01.
    EXIT.
  ENDIF.

  READ TABLE GT_NODE_INFO INTO GS_NODE_INFO
                          WITH KEY NODE_KEY = PV_NODE_KEY
                                   BINARY SEARCH.

  CHECK SY-SUBRC EQ 0.

  RANGES: R_PDPDAT      FOR GS_NODE_INFO-PDPDAT,
          R_BUKRS       FOR GS_NODE_INFO-BUKRS,
          R_WERKS       FOR GS_NODE_INFO-WERKS,
          R_MATNR       FOR GS_NODE_INFO-MATNR.

  IF GS_NODE_INFO-PDPDAT IS NOT INITIAL.
    R_PDPDAT-SIGN = 'I'.
    R_PDPDAT-OPTION = 'EQ'.
    R_PDPDAT-LOW = GS_NODE_INFO-PDPDAT.
    APPEND R_PDPDAT.
  ENDIF.

  IF GS_NODE_INFO-BUKRS IS NOT INITIAL.
    R_BUKRS-SIGN = 'I'.
    R_BUKRS-OPTION = 'EQ'.
    R_BUKRS-LOW = GS_NODE_INFO-BUKRS.
    APPEND R_BUKRS.
  ENDIF.

  IF GS_NODE_INFO-WERKS IS NOT INITIAL.
    R_WERKS-SIGN = 'I'.
    R_WERKS-OPTION = 'EQ'.
    R_WERKS-LOW = GS_NODE_INFO-WERKS.
    APPEND R_WERKS.
  ENDIF.

  IF GS_NODE_INFO-MATNR IS NOT INITIAL.
    R_MATNR-SIGN = 'I'.
    R_MATNR-OPTION = 'EQ'.
    R_MATNR-LOW = GS_NODE_INFO-MATNR.
    APPEND R_MATNR.
  ENDIF.

  SELECT FROM ZEA_PPT010  AS A
         JOIN ZEA_T001W   AS B ON B~WERKS EQ A~WERKS
         JOIN ZEA_MMT020  AS C ON C~MATNR EQ A~MATNR
                              AND C~SPRAS EQ @SY-LANGU
         JOIN ZEA_PLAF    AS D ON D~PLANID EQ A~PLANID
       FIELDS *
        WHERE  B~BUKRS    IN @R_BUKRS
          AND  A~WERKS    IN @R_WERKS
          AND  D~PDPDAT   IN @R_PDPDAT
          AND  A~MATNR    IN @R_MATNR
          AND  A~LOEKZ    EQ @SPACE
         INTO CORRESPONDING FIELDS OF TABLE @GT_DISPLAY.

  LOOP AT GT_DISPLAY INTO GS_DISPLAY.
    GS_DISPLAY-TOTAL =  GS_DISPLAY-PLANQTY1  +
                        GS_DISPLAY-PLANQTY2  +
                        GS_DISPLAY-PLANQTY3  +
                        GS_DISPLAY-PLANQTY4  +
                        GS_DISPLAY-PLANQTY5  +
                        GS_DISPLAY-PLANQTY6  +
                        GS_DISPLAY-PLANQTY7  +
                        GS_DISPLAY-PLANQTY8  +
                        GS_DISPLAY-PLANQTY9  +
                        GS_DISPLAY-PLANQTY10 +
                        GS_DISPLAY-PLANQTY11 +
                        GS_DISPLAY-PLANQTY12.

    MODIFY GT_DISPLAY FROM GS_DISPLAY.
  ENDLOOP.

  GO_ALV_GRID->REFRESH_TABLE_DISPLAY(
    EXCEPTIONS
      FINISHED       = 1                " Display was Ended (by Export)
      OTHERS         = 2
  ).
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
      WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_LAYOUT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_LAYOUT_0100 .

  CLEAR GS_LAYOUT.
  CLEAR GS_LAYOUT2.
  CLEAR GS_LAYOUT3.

  GS_LAYOUT-ZEBRA = ABAP_ON.
  GS_LAYOUT-CWIDTH_OPT = 'A'. " Always
  GS_LAYOUT-SEL_MODE = 'D'.

  GS_LAYOUT2-ZEBRA = ABAP_ON.
  GS_LAYOUT2-CWIDTH_OPT = 'A'. " Always
  GS_LAYOUT2-SEL_MODE = 'D'.
  GS_LAYOUT2-INFO_FNAME = 'COLOR'.           " 행 색상

  GS_LAYOUT3-ZEBRA = ABAP_ON.
  GS_LAYOUT3-CWIDTH_OPT = 'A'. " Always
  GS_LAYOUT3-SEL_MODE = 'D'.
  GS_LAYOUT3-CTAB_FNAME = 'IT_FIELD_COLORS'.           " 행 색상
  GS_LAYOUT3-STYLEFNAME  = 'STYLE'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_FIELDCAT_0100 .

  PERFORM GET_FIELDCAT_0100 USING  GT_DISPLAY
                                   GT_FIELDCAT.

  PERFORM GET_FIELDCAT_0100 USING GT_STKO_DISPLAY
                                  GT_FIELDCAT2.

  PERFORM GET_FIELDCAT_0100 USING GT_STPO_DISPLAY
                                  GT_FIELDCAT3.

  PERFORM SET_FIELDCAT_0100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_EVENT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_EVENT_0100 .
  SET HANDLER LCL_EVENT_HANDLER=>ON_TOOLBAR FOR GO_ALV_GRID.
  SET HANDLER LCL_EVENT_HANDLER=>ON_USER_COMMAND FOR GO_ALV_GRID.
  SET HANDLER LCL_EVENT_HANDLER=>ON_DOUBLE_CLICK FOR GO_ALV_GRID.
  SET HANDLER LCL_EVENT_HANDLER=>ON_HOTSPOT_CLICK FOR GO_ALV_GRID.

  SET HANDLER LCL_EVENT_HANDLER=>ON_TOOLBAR FOR GO_ALV_GRID_LEFT.
  SET HANDLER LCL_EVENT_HANDLER=>ON_USER_COMMAND FOR GO_ALV_GRID_LEFT.
  SET HANDLER LCL_EVENT_HANDLER=>ON_DOUBLE_CLICK FOR GO_ALV_GRID_LEFT.
  SET HANDLER LCL_EVENT_HANDLER=>ON_HOTSPOT_CLICK FOR GO_ALV_GRID_LEFT.

  SET HANDLER LCL_EVENT_HANDLER=>ON_TOOLBAR FOR GO_ALV_GRID_RIGHT.
  SET HANDLER LCL_EVENT_HANDLER=>ON_USER_COMMAND FOR GO_ALV_GRID_RIGHT.
  SET HANDLER LCL_EVENT_HANDLER=>ON_DOUBLE_CLICK FOR GO_ALV_GRID_RIGHT.
  SET HANDLER LCL_EVENT_HANDLER=>ON_HOTSPOT_CLICK FOR GO_ALV_GRID_RIGHT.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_0100
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV_0100 .

  GS_VARIANT-REPORT = SY-REPID.
  GS_VARIANT-HANDLE = '1'.
  GV_SAVE = 'A'.

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
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
      WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  GS_VARIANT-HANDLE = '2'.
  GS_LAYOUT2-GRID_TITLE = TEXT-T01.

  GO_ALV_GRID_LEFT->SET_TABLE_FOR_FIRST_DISPLAY(
    EXPORTING
      IS_VARIANT                    = GS_VARIANT  " Layout
      I_SAVE                        = GV_SAVE     " Save Layout
      IS_LAYOUT                     = GS_LAYOUT2   " Layout
    CHANGING
      IT_OUTTAB                     = GT_STKO_DISPLAY  " Output Table
      IT_FIELDCATALOG               = GT_FIELDCAT2 " Field Catalog
    EXCEPTIONS
      INVALID_PARAMETER_COMBINATION = 1 " Wrong Parameter
      PROGRAM_ERROR                 = 2 " Program Errors
      TOO_MANY_LINES                = 3 " Too many Rows in Ready for Input Grid
      OTHERS                        = 4
  ).
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
      WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  GS_VARIANT-HANDLE = '3'.
  GS_LAYOUT3-GRID_TITLE = TEXT-T02.

  GO_ALV_GRID_RIGHT->SET_TABLE_FOR_FIRST_DISPLAY(
    EXPORTING
      IS_VARIANT                    = GS_VARIANT  " Layout
      I_SAVE                        = GV_SAVE     " Save Layout
      IS_LAYOUT                     = GS_LAYOUT3   " Layout
    CHANGING
      IT_OUTTAB                     = GT_STPO_DISPLAY  " Output Table
      IT_FIELDCATALOG               = GT_FIELDCAT3 " Field Catalog
    EXCEPTIONS
      INVALID_PARAMETER_COMBINATION = 1 " Wrong Parameter
      PROGRAM_ERROR                 = 2 " Program Errors
      TOO_MANY_LINES                = 3 " Too many Rows in Ready for Input Grid
      OTHERS                        = 4
  ).
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
      WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_FIELDCAT_0100
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
*& Form SET_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM SET_FIELDCAT_0100 .

  LOOP AT GT_FIELDCAT INTO GS_FIELDCAT.
    CASE GS_FIELDCAT-FIELDNAME.
      WHEN 'BOMID'.
        GS_FIELDCAT-HOTSPOT    = ABAP_ON.
      WHEN 'PLANID'.
        GS_FIELDCAT-KEY        = ABAP_ON.
      WHEN 'PLANINDEX'.
        GS_FIELDCAT-NO_OUT     = ABAP_ON.
        GS_FIELDCAT-COLTEXT    = '인덱스'.
        GS_FIELDCAT-JUST       = 'C'.
      WHEN 'PLANQTY1'.
        GS_FIELDCAT-COLTEXT    = '1월 계획'.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
        GS_FIELDCAT-HOTSPOT    = ABAP_ON.
      WHEN 'PLANQTY2'.
        GS_FIELDCAT-COLTEXT    = '2월 계획'.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
        GS_FIELDCAT-HOTSPOT    = ABAP_ON.
      WHEN 'PLANQTY3'.
        GS_FIELDCAT-COLTEXT    = '3월 계획'.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
        GS_FIELDCAT-HOTSPOT    = ABAP_ON.
      WHEN 'PLANQTY4'.
        GS_FIELDCAT-COLTEXT    = '4월 계획'.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
        GS_FIELDCAT-HOTSPOT    = ABAP_ON.
      WHEN 'PLANQTY5'.
        GS_FIELDCAT-COLTEXT    = '5월 계획'.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
        GS_FIELDCAT-HOTSPOT    = ABAP_ON.
      WHEN 'PLANQTY6'.
        GS_FIELDCAT-COLTEXT    = '6월 계획'.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
        GS_FIELDCAT-HOTSPOT    = ABAP_ON.
      WHEN 'PLANQTY7'.
        GS_FIELDCAT-COLTEXT    = '7월 계획'.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
        GS_FIELDCAT-HOTSPOT    = ABAP_ON.
      WHEN 'PLANQTY8'.
        GS_FIELDCAT-COLTEXT    = '8월 계획'.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
        GS_FIELDCAT-HOTSPOT    = ABAP_ON.
      WHEN 'PLANQTY9'.
        GS_FIELDCAT-COLTEXT    = '9월 계획'.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
        GS_FIELDCAT-HOTSPOT    = ABAP_ON.
      WHEN 'PLANQTY10'.
        GS_FIELDCAT-COLTEXT    = '10월 계획'.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
        GS_FIELDCAT-HOTSPOT    = ABAP_ON.
      WHEN 'PLANQTY11'.
        GS_FIELDCAT-COLTEXT    = '11월 계획'.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
        GS_FIELDCAT-HOTSPOT    = ABAP_ON.
      WHEN 'PLANQTY12'.
        GS_FIELDCAT-COLTEXT    = '12월 계획'.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
        GS_FIELDCAT-HOTSPOT    = ABAP_ON.
      WHEN 'TOTAL'.
        GS_FIELDCAT-COLTEXT    = '총 생산량'.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
        GS_FIELDCAT-EMPHASIZE  = 'C300'.
      WHEN 'MEINS'.
        GS_FIELDCAT-COLTEXT = '단위'.
      WHEN 'LIGHT'.
        GS_FIELDCAT-COLTEXT = '생산오더 보유'.
    ENDCASE.

    MODIFY GT_FIELDCAT FROM GS_FIELDCAT.
  ENDLOOP.

  LOOP AT GT_FIELDCAT2 INTO GS_FIELDCAT2.
    CASE GS_FIELDCAT2-FIELDNAME.
      WHEN 'BOMID'.
        GS_FIELDCAT2-KEY      = ABAP_ON.
      WHEN 'MENGE'.
        GS_FIELDCAT2-QFIELDNAME = 'MEINS'.
      WHEN 'MEINS'.
        GS_FIELDCAT2-COLTEXT = '단위'.
      WHEN 'LOEKZ'.
        GS_FIELDCAT2-NO_OUT  = ABAP_ON.
      WHEN 'STATUS'.
        GS_FIELDCAT2-COLTEXT = 'Status'.
        GS_FIELDCAT2-ICON    = ABAP_ON.
        GS_FIELDCAT2-NO_OUT  = ABAP_ON.
      WHEN 'COLOR'.
        GS_FIELDCAT2-NO_OUT  = ABAP_ON.
      WHEN 'LIGHT'.
        GS_FIELDCAT2-NO_OUT  = ABAP_ON.
      WHEN 'MARK'.
        GS_FIELDCAT2-NO_OUT  = ABAP_ON.
    ENDCASE.

    MODIFY GT_FIELDCAT2 FROM GS_FIELDCAT2.
  ENDLOOP.

  LOOP AT GT_FIELDCAT3 INTO GS_FIELDCAT3.
    CASE GS_FIELDCAT3-FIELDNAME.
      WHEN 'BOMID'.
        GS_FIELDCAT3-KEY      = ABAP_ON.
      WHEN 'BOMINDEX'.
        GS_FIELDCAT3-KEY      = ABAP_ON.
      WHEN 'BOMID2'.
        GS_FIELDCAT3-COLTEXT  = '해당자재 BOMID'.
        GS_FIELDCAT3-HOTSPOT  = ABAP_ON.
      WHEN 'MENGE'.
        GS_FIELDCAT3-QFIELDNAME = 'MEINS'.
        GS_FIELDCAT3-DO_SUM     = 'X'.
      WHEN 'MEINS'.
        GS_FIELDCAT3-COLTEXT = '단위'.
      WHEN 'STATUS'.
        GS_FIELDCAT3-COLTEXT = 'Status'.
        GS_FIELDCAT3-ICON    = ABAP_ON.
        GS_FIELDCAT3-NO_OUT  = ABAP_ON.
      WHEN 'COLOR'.
        GS_FIELDCAT3-NO_OUT  = ABAP_ON.
      WHEN 'LIGHT'.
        GS_FIELDCAT3-NO_OUT  = ABAP_ON.
      WHEN 'MARK'.
        GS_FIELDCAT3-NO_OUT  = ABAP_ON.
    ENDCASE.

    MODIFY GT_FIELDCAT3 FROM GS_FIELDCAT3.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH_ALV_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM REFRESH_ALV_0100 .

  DATA LS_STABLE TYPE LVC_S_STBL.
  LS_STABLE-ROW = ABAP_ON.
  LS_STABLE-COL = ABAP_ON.

  CALL METHOD GO_ALV_GRID->REFRESH_TABLE_DISPLAY
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

  CALL METHOD GO_ALV_GRID_LEFT->REFRESH_TABLE_DISPLAY
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

  CALL METHOD GO_ALV_GRID_RIGHT->REFRESH_TABLE_DISPLAY
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
*& Form HANDLER_TOOLBAR
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_OBJECT
*&      --> SENDER
*&---------------------------------------------------------------------*
FORM HANDLER_TOOLBAR
  USING PO_OBJECT TYPE REF TO CL_ALV_EVENT_TOOLBAR_SET
        PO_SENDER TYPE REF TO CL_GUI_ALV_GRID.

  " Internal Table PO_OBJECT->MT_TOOLBAR 를 위한 작업공간
  " PO_OBJECT->MT_TOOLBAR >>> 클래스의 Attribute ( Public , Instance )
  DATA LS_TOOLBAR LIKE LINE OF PO_OBJECT->MT_TOOLBAR.

  CASE PO_SENDER.
    WHEN GO_ALV_GRID.

      DATA GV_MONTH TYPE C LENGTH 2.
      IF SY-DATUM+4(2) NE 12.
        GV_MONTH = SY-DATUM+4(2) + 1.
      ELSE.
        GV_MONTH = '01'.
      ENDIF.


* 구분자 =>> |
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 3. " 구분자
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼추가 =>> 자재소요량 계산
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-FUNCTION = GC_MRP_CALC.
      LS_TOOLBAR-TEXT = |익월({ SY-DATUM+0(4) }년 { GV_MONTH }월) 자재소요량 결과 생성|.
      LS_TOOLBAR-ICON = ICON_CREATE.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-FUNCTION = GC_MRP_MONTH.
      LS_TOOLBAR-TEXT = |월(열) 단위 자재소요량 계산|.
      LS_TOOLBAR-ICON = ICON_CALCULATION.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

    WHEN GO_ALV_GRID_RIGHT.

      DATA LV_TOTAL TYPE I.
      DATA LV_GREEN TYPE I.
      DATA LV_YELLOW TYPE I.

      DESCRIBE TABLE GT_STPO_DISPLAY.

      LOOP AT GT_STPO_DISPLAY INTO GS_STPO_DISPLAY.
        ADD 1 TO LV_TOTAL.

        CASE GS_STPO_DISPLAY-MATTYPE.
          WHEN '반제품'. ADD 1 TO LV_GREEN.
          WHEN '원자재'. ADD 1 TO LV_YELLOW.
        ENDCASE.
      ENDLOOP.

* 구분자 =>> |
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 3. " 구분자
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 전체
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-FUNCTION = GC_NO_FILTER.
      LS_TOOLBAR-TEXT = | 전체조회 : { SY-TFILL } |.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 승인
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-FUNCTION = GC_SEMI.
      LS_TOOLBAR-ICON = ICON_LED_GREEN.
      LS_TOOLBAR-TEXT = | 반제품 : { LV_GREEN }  |.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 대기
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-FUNCTION = GC_RAW.
      LS_TOOLBAR-ICON = ICON_LED_YELLOW.
      LS_TOOLBAR-TEXT = | 원자재 : { LV_YELLOW }  |.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 상위 BOM 조회
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-FUNCTION = GC_BACK.
      LS_TOOLBAR-ICON = ICON_BOM.
      LS_TOOLBAR-TEXT = |상위 BOM 조회|.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_USER_COMMAND
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_UCOMM
*&      --> SENDER
*&---------------------------------------------------------------------*
FORM HANDLE_USER_COMMAND  USING PV_UCOMM TYPE SY-UCOMM
                               PO_SENDER  TYPE REF TO CL_GUI_ALV_GRID.

*  CALL METHOD GO_ALV_GRID->CHECK_CHANGED_DATA.

  CASE PO_SENDER.
    WHEN GO_ALV_GRID. "PO_SENDER 가 GO_ALV_GRID 일 때
      CASE PV_UCOMM.  " 선택한 버튼 (PV_UCOMM은 SY-UCOMM 타입)
        WHEN GC_MRP_CALC.
          IF GS_NODE_INFO-WERKS NE 10000 OR GS_NODE_INFO-MATNR IS NOT INITIAL.
            MESSAGE S072 DISPLAY LIKE 'W'. " 자재소요량 계산은 10000번
            " 플랜트(생산 공장) 에서만 가능합니다.
            EXIT.
          ENDIF.

          ZEA_T001W-WERKS = GS_NODE_INFO-WERKS.

*          DATA LT_INDEX_COLUMNS TYPE LVC_T_COL.
*          DATA LS_INDEX_COLUMNS TYPE LVC_S_COL.
*
*          " 계획월 체크
*          CALL METHOD GO_ALV_GRID->GET_SELECTED_COLUMNS
*            IMPORTING
*              ET_INDEX_COLUMNS = LT_INDEX_COLUMNS. " Indexes of Selected Rows
*
*          DESCRIBE TABLE LT_INDEX_COLUMNS.
*
*          IF SY-TFILL IS INITIAL OR SY-TFILL NE 1.
*            MESSAGE S075 DISPLAY LIKE 'W'.
*            EXIT.
*          ENDIF.

*          DATA LV_CHECK.
*          DATA: GV_YEAR    TYPE NUMC4,
*                LV_LASTDAY TYPE DATS.
*
*          DO 12 TIMES.
*            READ TABLE LT_INDEX_COLUMNS INTO LS_INDEX_COLUMNS
*              WITH KEY FIELDNAME = |PLANQTY{ SY-INDEX }|.

*            GV_YEAR = GS_NODE_INFO-PDPDAT.
*
*            IF SY-SUBRC EQ 0.
*              LV_CHECK = ABAP_ON.
*              WRITE SY-INDEX TO GV_MONTH.
*              IF SY-INDEX EQ 1
*                 OR SY-INDEX EQ 2
*                 OR SY-INDEX EQ 3
*                 OR SY-INDEX EQ 4
*                 OR SY-INDEX EQ 5
*                 OR SY-INDEX EQ 6
*                 OR SY-INDEX EQ 7
*                 OR SY-INDEX EQ 8
*                 OR SY-INDEX EQ 9.
*                CONCATENATE '0' GV_MONTH INTO GV_MONTH.
*              ENDIF.
**             시작일자 종료일자 세팅
*              CONCATENATE GV_YEAR GV_MONTH '01' INTO S0110-DATEFROM.
*

          GV_YEAR = SY-DATUM+0(4) + 1.

          IF SY-DATUM+4(2) NE 12.
            GV_MONTH = SY-DATUM+4(2) + 1.
            CONCATENATE SY-DATUM+0(4) GV_MONTH '01' INTO S0110-DATEFROM.
          ELSE.
            GV_MONTH = '01'.
            CONCATENATE GV_YEAR GV_MONTH '01' INTO S0110-DATEFROM.
          ENDIF.


          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-DATEFROM
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-DATETO.
**              S0110-DATETO   =
*            ENDIF.
*          ENDDO.

*          DATA LV_DATUM TYPE NUMC4.
*          LV_DATUM = SY-DATUM+2(4).
*          LV_DATUM += 1.

*          IF LV_CHECK EQ ABAP_OFF.
*            MESSAGE S075 DISPLAY LIKE 'W'.
*            EXIT.
*          ELSEIF S0110-DATEFROM+2(4) NE LV_DATUM.
*            MESSAGE S077 DISPLAY LIKE 'W' WITH SY-DATUM+0(4) LV_DATUM+2(2). " 다음달을 선택해주세요.
*            EXIT.
*          ENDIF.

          CALL SCREEN 0110 STARTING AT 50 5.
        WHEN GC_MRP_MONTH.

          DATA LT_INDEX_COLUMNS TYPE LVC_T_COL.
          DATA LS_INDEX_COLUMNS TYPE LVC_S_COL.

          " 계산열 체크
          CALL METHOD GO_ALV_GRID->GET_SELECTED_COLUMNS
            IMPORTING
              ET_INDEX_COLUMNS = LT_INDEX_COLUMNS. " Indexes of Selected Rows

          DESCRIBE TABLE LT_INDEX_COLUMNS.

          IF SY-TFILL IS INITIAL OR SY-TFILL NE 1.
            MESSAGE S075 DISPLAY LIKE 'W'. "계산월을 한 열 선택해주세요.
            EXIT.
          ENDIF.


          DATA LV_CHECK.


          DO 12 TIMES.
            READ TABLE LT_INDEX_COLUMNS INTO LS_INDEX_COLUMNS
              WITH KEY FIELDNAME = |PLANQTY{ SY-INDEX }|.



            IF SY-SUBRC EQ 0.
              LV_CHECK = ABAP_ON.
              WRITE SY-INDEX TO GV_MONTH2.
              IF SY-INDEX EQ 1
                 OR SY-INDEX EQ 2
                 OR SY-INDEX EQ 3
                 OR SY-INDEX EQ 4
                 OR SY-INDEX EQ 5
                 OR SY-INDEX EQ 6
                 OR SY-INDEX EQ 7
                 OR SY-INDEX EQ 8
                 OR SY-INDEX EQ 9.
                CONCATENATE '0' GV_MONTH2 INTO GV_MONTH2.
              ENDIF.
            ENDIF.

          ENDDO.

          REFRESH GT_STPO.

          LOOP AT GT_DISPLAY INTO GS_DISPLAY.

            SELECT *
              APPENDING CORRESPONDING FIELDS OF TABLE GT_STPO
              FROM ZEA_STPO AS A
              JOIN ZEA_MMT020 AS B ON B~MATNR EQ A~MATNR
                                    AND B~SPRAS EQ SY-LANGU
              JOIN ZEA_MMT010 AS C ON C~MATNR EQ A~MATNR
              WHERE BOMID EQ GS_DISPLAY-BOMID.

            LOOP AT GT_STPO INTO GS_STPO WHERE MATTYPE = '반제품'.

              SELECT SINGLE BOMID FROM ZEA_STKO
               WHERE MATNR EQ @GS_STPO-MATNR
                 AND MENGE EQ @GS_STPO-MENGE
                 AND MEINS EQ @GS_STPO-MEINS
                INTO @DATA(LV_BOMID).

              SELECT *
                FROM ZEA_STKO AS A
                JOIN ZEA_STPO AS B   ON B~BOMID EQ A~BOMID
                JOIN ZEA_MMT020 AS C ON C~MATNR EQ B~MATNR
                                    AND C~SPRAS EQ SY-LANGU
                JOIN ZEA_MMT010 AS D ON D~MATNR EQ B~MATNR
                APPENDING CORRESPONDING FIELDS OF TABLE GT_STPO
                WHERE A~BOMID EQ LV_BOMID.

              DELETE GT_STPO. " 반제품인 현재 라인은 제거

            ENDLOOP.

          ENDLOOP.

          LOOP AT GT_STPO INTO GS_STPO.
            CASE LS_INDEX_COLUMNS-FIELDNAME.
              WHEN 'PLANQTY1'.
                GS_STPO-MENGE = GS_STPO-MENGE * GS_DISPLAY-PLANQTY1 * 4.
                MODIFY GT_STPO FROM GS_STPO.
              WHEN 'PLANQTY2'.
                GS_STPO-MENGE = GS_STPO-MENGE * GS_DISPLAY-PLANQTY2 * 4.
                MODIFY GT_STPO FROM GS_STPO.
              WHEN 'PLANQTY3'.
                GS_STPO-MENGE = GS_STPO-MENGE * GS_DISPLAY-PLANQTY3 * 4.
                MODIFY GT_STPO FROM GS_STPO.
              WHEN 'PLANQTY4'.
                GS_STPO-MENGE = GS_STPO-MENGE * GS_DISPLAY-PLANQTY4 * 4.
                MODIFY GT_STPO FROM GS_STPO.
              WHEN 'PLANQTY5'.
                GS_STPO-MENGE = GS_STPO-MENGE * GS_DISPLAY-PLANQTY5 * 4.
                MODIFY GT_STPO FROM GS_STPO.
              WHEN 'PLANQTY6'.
                GS_STPO-MENGE = GS_STPO-MENGE * GS_DISPLAY-PLANQTY6 * 4.
                MODIFY GT_STPO FROM GS_STPO.
              WHEN 'PLANQTY7'.
                GS_STPO-MENGE = GS_STPO-MENGE * GS_DISPLAY-PLANQTY7 * 4.
                MODIFY GT_STPO FROM GS_STPO.
              WHEN 'PLANQTY8'.
                GS_STPO-MENGE = GS_STPO-MENGE * GS_DISPLAY-PLANQTY8 * 4.
                MODIFY GT_STPO FROM GS_STPO.
              WHEN 'PLANQTY9'.
                GS_STPO-MENGE = GS_STPO-MENGE * GS_DISPLAY-PLANQTY9 * 4.
                MODIFY GT_STPO FROM GS_STPO.
              WHEN 'PLANQTY10'.
                GS_STPO-MENGE = GS_STPO-MENGE * GS_DISPLAY-PLANQTY10 * 4.
                MODIFY GT_STPO FROM GS_STPO.
              WHEN 'PLANQTY11'.
                GS_STPO-MENGE = GS_STPO-MENGE * GS_DISPLAY-PLANQTY11 * 4.
                MODIFY GT_STPO FROM GS_STPO.
              WHEN 'PLANQTY12'.
                GS_STPO-MENGE = GS_STPO-MENGE * GS_DISPLAY-PLANQTY12 * 4.
                MODIFY GT_STPO FROM GS_STPO.
              WHEN OTHERS.
                MESSAGE S000 DISPLAY LIKE 'W' WITH 'N월 계획 열을 선택해주세요'.
                LV_CHECK = ABAP_OFF.
            ENDCASE.

          ENDLOOP.

          IF LV_CHECK EQ ABAP_OFF.
            EXIT.
          ENDIF.

          REFRESH GT_COLLECT.

          LOOP AT GT_STPO INTO GS_STPO.
            MOVE-CORRESPONDING GS_STPO TO GS_COLLECT.
            COLLECT GS_COLLECT INTO GT_COLLECT.
            CLEAR GS_COLLECT.
          ENDLOOP.

          DATA LV_STOCK TYPE ZEA_MMT190-WEIGHT.

          LOOP AT GT_COLLECT INTO GS_COLLECT.

            SELECT SINGLE WEIGHT
                  FROM ZEA_MMT190
                  INTO LV_STOCK
                  WHERE MATNR EQ GS_COLLECT-MATNR.

            GS_COLLECT-STOCK = LV_STOCK.

            IF GS_COLLECT-MENGE GT LV_STOCK.
              GS_COLLECT-REQQTY = GS_COLLECT-MENGE - LV_STOCK.
            ELSE.
              GS_COLLECT-REQQTY = 0.
            ENDIF.

            MODIFY GT_COLLECT FROM GS_COLLECT.
          ENDLOOP.

          SORT GT_COLLECT BY MATNR.

          REFRESH GT_COLLECT_DISPLAY.

          MOVE-CORRESPONDING GT_COLLECT TO GT_COLLECT_DISPLAY.

          LOOP AT GT_COLLECT_DISPLAY INTO GS_COLLECT_DISPLAY.

            IF GS_COLLECT_DISPLAY-REQQTY GT 0.
              CLEAR GS_FIELD_COLOR.
              GS_FIELD_COLOR-FNAME = 'REQQTY'.
              GS_FIELD_COLOR-COLOR-COL = 6. " 빨강
              GS_FIELD_COLOR-COLOR-INT = 0.
              GS_FIELD_COLOR-COLOR-INV = 0.
              APPEND GS_FIELD_COLOR TO GS_COLLECT_DISPLAY-IT_FIELD_COLORS.
            ENDIF.
*--------------------------------------------------------------------*
            MODIFY GT_COLLECT_DISPLAY FROM GS_COLLECT_DISPLAY.

          ENDLOOP.

          CALL SCREEN 0120 STARTING AT 50 5.

      ENDCASE.

    WHEN GO_ALV_GRID_RIGHT.
      CASE PV_UCOMM.
        WHEN GC_NO_FILTER.
          PERFORM NO_FILTER.
        WHEN GC_SEMI.
          PERFORM SEMI_FILTER.
        WHEN GC_RAW.
          PERFORM RAW_FILTER.
        WHEN GC_BACK.
          PERFORM BACK_BOM.
      ENDCASE.


  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_DOUBLE_CLICK
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_ROW
*&      --> E_COLUMN
*&      --> SENDER
*&---------------------------------------------------------------------*
FORM HANDLE_DOUBLE_CLICK USING PS_ROW TYPE LVC_S_ROW
                               PS_COL     TYPE  LVC_S_COL
                               PO_SENDER  TYPE REF TO CL_GUI_ALV_GRID.

* 선택한 행이 인터널테이블에 있는 정상적인 데이터인지 체크
  CHECK PS_ROW-ROWTYPE IS INITIAL.

  CASE PO_SENDER.
    WHEN GO_ALV_GRID.





  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FILTER
*&---------------------------------------------------------------------*
FORM SET_ALV_FILTER .

  " ALV에 Filter 정보를 적용하는 과정
  CALL METHOD GO_ALV_GRID_RIGHT->SET_FILTER_CRITERIA
    EXPORTING
      IT_FILTER = GT_FILTER                " Filter Conditions
    EXCEPTIONS
      OTHERS    = 1.

  IF SY-SUBRC NE 0.
    MESSAGE E000 WITH '필터 적용에 실패하였습니다'.
  ENDIF.

  " ALV가 새로고침될 때, 현재 라인, 열을 유지할 지
  DATA LS_STABLE TYPE LVC_S_STBL.
  LS_STABLE-ROW = ABAP_ON.
  LS_STABLE-COL = ABAP_ON.

  " 적용된 Filter 기준으로 데이터를 출력
  CALL METHOD GO_ALV_GRID_RIGHT->REFRESH_TABLE_DISPLAY
    EXPORTING
      IS_STABLE = LS_STABLE                  " With Stable Rows/Columns
*     I_SOFT_REFRESH =                  " Without Sort, Filter, etc.
    EXCEPTIONS
      OTHERS    = 1.

  IF SY-SUBRC NE 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
      WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form MODIFY_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM MODIFY_DATA .

*  LOOP AT GT_HEADER INTO GS_HEADER.
*    GS_HEADER-WERKS_PROD = 10000.
*    MODIFY GT_HEADER FROM GS_HEADER.
*  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CALC_MRP
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CALC_MRP_STEP1.

  DATA: LT_STPO LIKE TABLE OF GS_STPO.

  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE LT_STPO
    FROM ZEA_STPO AS A
    JOIN ZEA_MMT020 AS B ON B~MATNR EQ A~MATNR
                          AND B~SPRAS EQ SY-LANGU
    JOIN ZEA_MMT010 AS C ON C~MATNR EQ A~MATNR
    WHERE BOMID EQ GS_DISPLAY-BOMID.

  PERFORM CAL_BOM TABLES LT_STPO.

  DATA LV_PLANQTY TYPE ZEA_PPT010-PLANQTY1.
  CASE GV_MONTH.
    WHEN '01'.
      LV_PLANQTY = GS_DISPLAY-PLANQTY1.
    WHEN '02'.
      LV_PLANQTY = GS_DISPLAY-PLANQTY2.
    WHEN '03'.
      LV_PLANQTY = GS_DISPLAY-PLANQTY3.
    WHEN '04'.
      LV_PLANQTY = GS_DISPLAY-PLANQTY4.
    WHEN '05'.
      LV_PLANQTY = GS_DISPLAY-PLANQTY5.
    WHEN '06'.
      LV_PLANQTY = GS_DISPLAY-PLANQTY6.
    WHEN '07'.
      LV_PLANQTY = GS_DISPLAY-PLANQTY7.
    WHEN '08'.
      LV_PLANQTY = GS_DISPLAY-PLANQTY8.
    WHEN '09'.
      LV_PLANQTY = GS_DISPLAY-PLANQTY9.
    WHEN '10'.
      LV_PLANQTY = GS_DISPLAY-PLANQTY10.
    WHEN '11'.
      LV_PLANQTY = GS_DISPLAY-PLANQTY11.
    WHEN '12'.
      LV_PLANQTY = GS_DISPLAY-PLANQTY12.
  ENDCASE.

  LOOP AT LT_STPO INTO GS_STPO.
    GS_STPO-MENGE = GS_STPO-MENGE * LV_PLANQTY * 4.
    MODIFY LT_STPO FROM GS_STPO.
  ENDLOOP.

  APPEND LINES OF LT_STPO TO GT_STPO.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form CALC_MRP_STEP2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CALC_MRP_STEP2 .



ENDFORM.
*&---------------------------------------------------------------------*
*& Form CAL_BOM
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LT_STPO
*&---------------------------------------------------------------------*
FORM CAL_BOM  TABLES PT_STPO LIKE GT_STPO.

  DATA: LS_STPO LIKE LINE OF PT_STPO.
  DATA: LT_STPO LIKE TABLE OF PT_STPO.

  DATA: LV_BOMID TYPE ZEA_STKO-BOMID.

  READ TABLE PT_STPO INTO LS_STPO WITH KEY MATTYPE = '반제품'.

  SELECT SINGLE BOMID
    FROM ZEA_STKO
    INTO LV_BOMID
    WHERE MATNR EQ LS_STPO-MATNR
      AND MENGE EQ LS_STPO-MENGE
      AND MEINS EQ LS_STPO-MEINS.

  REFRESH LT_STPO.

  SELECT *
  INTO CORRESPONDING FIELDS OF TABLE LT_STPO
  FROM ZEA_STPO AS A
  JOIN ZEA_MMT020 AS B ON B~MATNR EQ A~MATNR
                        AND B~SPRAS EQ SY-LANGU
  JOIN ZEA_MMT010 AS C ON C~MATNR EQ A~MATNR
  WHERE BOMID EQ LV_BOMID.

  DELETE PT_STPO WHERE BOMID EQ LS_STPO-BOMID
                   AND BOMINDEX EQ LS_STPO-BOMINDEX.

  APPEND LINES OF LT_STPO TO PT_STPO.

  READ TABLE PT_STPO WITH KEY MATTYPE = '반제품'.

  IF SY-SUBRC EQ 0.
    PERFORM CAL_BOM TABLES PT_STPO.
  ELSE.
    EXIT.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_HOTSPOT_CLICK
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_ROW_ID
*&      --> E_COLUMN_ID
*&      --> SENDER
*&---------------------------------------------------------------------*
FORM HANDLE_HOTSPOT_CLICK  USING PS_ROW_ID TYPE LVC_S_ROW
                                 PS_COLUMN_ID TYPE  LVC_S_COL
                                 PO_SENDER    TYPE REF TO CL_GUI_ALV_GRID.

* 선택한 행이 인터널테이블에 있는 정상적인 데이터인지 체크
  CHECK PS_ROW_ID-ROWTYPE IS INITIAL.

  CASE PO_SENDER.
    WHEN GO_ALV_GRID.
      READ TABLE GT_DISPLAY INTO GS_DISPLAY INDEX PS_ROW_ID-INDEX.

      CASE PS_COLUMN_ID-FIELDNAME.
        WHEN 'PLANQTY1'
          OR 'PLANQTY2'
          OR 'PLANQTY3'
          OR 'PLANQTY4'
          OR 'PLANQTY5'
          OR 'PLANQTY6'
          OR 'PLANQTY7'
          OR 'PLANQTY8'
          OR 'PLANQTY9'
          OR 'PLANQTY10'
          OR 'PLANQTY11'
          OR 'PLANQTY12'.
          PERFORM CALC_SUB_MAT USING PS_COLUMN_ID.
        WHEN 'BOMID'.
          REFRESH GT_STKO.
          REFRESH GT_STPO.

          SELECT *
            FROM ZEA_STKO AS A
            JOIN ZEA_MMT010 AS B ON B~MATNR EQ A~MATNR
            JOIN ZEA_MMT020 AS C ON C~MATNR EQ B~MATNR
                                AND C~SPRAS EQ SY-LANGU
            INTO CORRESPONDING FIELDS OF TABLE GT_STKO_DISPLAY
            WHERE A~BOMID EQ GS_DISPLAY-BOMID
              AND A~LOEKZ NE ABAP_ON.

          SELECT  *
            FROM ZEA_STPO AS A
            INNER JOIN ZEA_MMT020 AS B
            ON A~MATNR EQ B~MATNR
            AND SPRAS  EQ SY-LANGU
            INNER JOIN ZEA_MMT010 AS C
            ON C~MATNR EQ B~MATNR
            INTO CORRESPONDING FIELDS OF TABLE GT_STPO_DISPLAY
            WHERE A~BOMID EQ GS_DISPLAY-BOMID
              AND A~LOEKZ NE ABAP_ON.

          SORT GT_STPO_DISPLAY BY BOMINDEX.

          DATA LS_STYLE TYPE LVC_S_STYL.
          DATA LV_BOMID TYPE ZEA_STKO-BOMID.

          LOOP AT GT_STPO_DISPLAY INTO GS_STPO_DISPLAY.

            SELECT SINGLE BOMID
                FROM ZEA_STKO
                INTO LV_BOMID
                WHERE MATNR EQ GS_STPO_DISPLAY-MATNR
                  AND MENGE EQ GS_STPO_DISPLAY-MENGE
                  AND MEINS EQ GS_STPO_DISPLAY-MEINS.

            IF SY-SUBRC EQ 0.
              GS_STPO_DISPLAY-BOMID2 = LV_BOMID.
            ENDIF.

            IF GS_STPO_DISPLAY-MATTYPE EQ '반제품'.
              LS_STYLE-FIELDNAME = 'BOMID2'.
              LS_STYLE-STYLE        = CL_GUI_ALV_GRID=>MC_STYLE_HOTSPOT. "HOTSPOT 활성화
              INSERT LS_STYLE INTO TABLE GS_STPO_DISPLAY-STYLE.
            ELSE.
              LS_STYLE-FIELDNAME = 'BOMID2'.
              LS_STYLE-STYLE        = CL_GUI_ALV_GRID=>MC_STYLE_HOTSPOT_NO. "HOTSPOT 비활성화
              INSERT LS_STYLE INTO TABLE GS_STPO_DISPLAY-STYLE.
            ENDIF.

*--------------------------------------------------------------------*
            MODIFY GT_STPO_DISPLAY FROM GS_STPO_DISPLAY.

          ENDLOOP.

*          LOOP AT GT_STKO_DISPLAY INTO GS_STKO_DISPLAY WHERE BOMID EQ GS_DISPLAY-BOMID.
*            GS_STKO_DISPLAY-COLOR = 'C310'.
*            MODIFY GT_STKO_DISPLAY FROM GS_STKO_DISPLAY.
*          ENDLOOP.

          GS_STKO_DISPLAY-COLOR = 'C310'.
          MODIFY GT_STKO_DISPLAY FROM GS_STKO_DISPLAY TRANSPORTING COLOR
          WHERE BOMID EQ GS_DISPLAY-BOMID.

          PERFORM MODIFY_STPO_DISPLAY_DATA.

          PERFORM REFRESH_ALV_0100.
      ENDCASE.

    WHEN GO_ALV_GRID_RIGHT.
      READ TABLE GT_STPO_DISPLAY INTO GS_STPO_DISPLAY INDEX PS_ROW_ID-INDEX.

      CASE PS_COLUMN_ID-FIELDNAME.
        WHEN 'BOMID2'.

          MOVE-CORRESPONDING GT_STKO_DISPLAY TO GT_STKO_CP.
          MOVE-CORRESPONDING GT_STPO_DISPLAY TO GT_STPO_CP.

          READ TABLE GT_STKO_CP INTO GS_STKO_CP INDEX 1.

          LV_BOMID = GS_STKO_CP-BOMID.

*          REFRESH GT_STKO_DISPLAY.
          REFRESH GT_STPO_DISPLAY.

          SELECT *
            FROM ZEA_STKO AS A
            JOIN ZEA_MMT010 AS B ON B~MATNR EQ A~MATNR
            JOIN ZEA_MMT020 AS C ON C~MATNR EQ B~MATNR
                                AND C~SPRAS EQ SY-LANGU
            APPENDING CORRESPONDING FIELDS OF TABLE GT_STKO_DISPLAY
            WHERE A~BOMID EQ GS_STPO_DISPLAY-BOMID2
              AND A~LOEKZ NE ABAP_ON.

          DATA LV_LINES TYPE I.
          DESCRIBE TABLE GT_STKO_DISPLAY LINES LV_LINES.

          LOOP AT GT_STKO_DISPLAY INTO GS_STKO_DISPLAY WHERE COLOR EQ 'C310'.
            GS_STKO_DISPLAY-COLOR = SPACE.
            MODIFY GT_STKO_DISPLAY FROM GS_STKO_DISPLAY.
          ENDLOOP.

          GS_STKO_DISPLAY-COLOR = 'C310'.
          MODIFY GT_STKO_DISPLAY FROM GS_STKO_DISPLAY
          INDEX LV_LINES TRANSPORTING COLOR.
*          WHERE BOMID EQ LV_BOMID.

          SELECT  *
            FROM ZEA_STPO AS A
            INNER JOIN ZEA_MMT020 AS B
            ON A~MATNR EQ B~MATNR
            AND SPRAS  EQ SY-LANGU
            INNER JOIN ZEA_MMT010 AS C
            ON C~MATNR EQ B~MATNR
            INTO CORRESPONDING FIELDS OF TABLE GT_STPO_DISPLAY
            WHERE A~BOMID EQ GS_STPO_DISPLAY-BOMID2
              AND A~LOEKZ NE ABAP_ON.


*          LOOP AT GT_STKO_DISPLAY INTO GS_STKO_DISPLAY.
*            GS_STKO_DISPLAY-BOMID3 = LV_BOMID.
*            MODIFY GT_STKO_DISPLAY FROM GS_STKO_DISPLAY.
*          ENDLOOP.

          LOOP AT GT_STPO_DISPLAY INTO GS_STPO_DISPLAY.

            SELECT SINGLE BOMID
                FROM ZEA_STKO
                INTO LV_BOMID
                WHERE MATNR EQ GS_STPO_DISPLAY-MATNR
                  AND MENGE EQ GS_STPO_DISPLAY-MENGE
                  AND MEINS EQ GS_STPO_DISPLAY-MEINS.

            IF SY-SUBRC EQ 0.
              GS_STPO_DISPLAY-BOMID2 = LV_BOMID.
            ENDIF.

            IF GS_STPO_DISPLAY-MATTYPE EQ '반제품'.
              LS_STYLE-FIELDNAME = 'BOMID2'.
              LS_STYLE-STYLE        = CL_GUI_ALV_GRID=>MC_STYLE_HOTSPOT. "HOTSPOT 활성화
              INSERT LS_STYLE INTO TABLE GS_STPO_DISPLAY-STYLE.
            ELSE.
              LS_STYLE-FIELDNAME = 'BOMID2'.
              LS_STYLE-STYLE        = CL_GUI_ALV_GRID=>MC_STYLE_HOTSPOT_NO. "HOTSPOT 비활성화
              INSERT LS_STYLE INTO TABLE GS_STPO_DISPLAY-STYLE.
            ENDIF.

*--------------------------------------------------------------------*
            MODIFY GT_STPO_DISPLAY FROM GS_STPO_DISPLAY.

          ENDLOOP.

          PERFORM MODIFY_STPO_DISPLAY_DATA.

          PERFORM REFRESH_ALV_0100.
      ENDCASE.
  ENDCASE.





ENDFORM.
*&---------------------------------------------------------------------*
*& Form CALC_SUB_MAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CALC_SUB_MAT USING PS_COLUMN_ID TYPE LVC_S_COL.

  REFRESH GT_STPO.

  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE GT_STPO
    FROM ZEA_STPO AS A
    JOIN ZEA_MMT020 AS B ON B~MATNR EQ A~MATNR
                          AND B~SPRAS EQ SY-LANGU
    JOIN ZEA_MMT010 AS C ON C~MATNR EQ A~MATNR
    WHERE BOMID EQ GS_DISPLAY-BOMID.

  LOOP AT GT_STPO INTO GS_STPO WHERE MATTYPE = '반제품'.

    SELECT SINGLE BOMID FROM ZEA_STKO
     WHERE MATNR EQ @GS_STPO-MATNR
       AND MENGE EQ @GS_STPO-MENGE
       AND MEINS EQ @GS_STPO-MEINS
      INTO @DATA(LV_BOMID).

    SELECT *
      FROM ZEA_STKO AS A
      JOIN ZEA_STPO AS B   ON B~BOMID EQ A~BOMID
      JOIN ZEA_MMT020 AS C ON C~MATNR EQ B~MATNR
                          AND C~SPRAS EQ SY-LANGU
      JOIN ZEA_MMT010 AS D ON D~MATNR EQ B~MATNR
      APPENDING CORRESPONDING FIELDS OF TABLE GT_STPO
      WHERE A~BOMID EQ LV_BOMID.

    DELETE GT_STPO. " 반제품인 현재 라인은 제거

  ENDLOOP.

  LOOP AT GT_STPO INTO GS_STPO.
    CASE PS_COLUMN_ID-FIELDNAME.
      WHEN 'PLANQTY1'.
        GS_STPO-MENGE = GS_STPO-MENGE * GS_DISPLAY-PLANQTY1 * 4.
        MODIFY GT_STPO FROM GS_STPO.
      WHEN 'PLANQTY2'.
        GS_STPO-MENGE = GS_STPO-MENGE * GS_DISPLAY-PLANQTY2 * 4.
        MODIFY GT_STPO FROM GS_STPO.
      WHEN 'PLANQTY3'.
        GS_STPO-MENGE = GS_STPO-MENGE * GS_DISPLAY-PLANQTY3 * 4.
        MODIFY GT_STPO FROM GS_STPO.
      WHEN 'PLANQTY4'.
        GS_STPO-MENGE = GS_STPO-MENGE * GS_DISPLAY-PLANQTY4 * 4.
        MODIFY GT_STPO FROM GS_STPO.
      WHEN 'PLANQTY5'.
        GS_STPO-MENGE = GS_STPO-MENGE * GS_DISPLAY-PLANQTY5 * 4.
        MODIFY GT_STPO FROM GS_STPO.
      WHEN 'PLANQTY6'.
        GS_STPO-MENGE = GS_STPO-MENGE * GS_DISPLAY-PLANQTY6 * 4.
        MODIFY GT_STPO FROM GS_STPO.
      WHEN 'PLANQTY7'.
        GS_STPO-MENGE = GS_STPO-MENGE * GS_DISPLAY-PLANQTY7 * 4.
        MODIFY GT_STPO FROM GS_STPO.
      WHEN 'PLANQTY8'.
        GS_STPO-MENGE = GS_STPO-MENGE * GS_DISPLAY-PLANQTY8 * 4.
        MODIFY GT_STPO FROM GS_STPO.
      WHEN 'PLANQTY9'.
        GS_STPO-MENGE = GS_STPO-MENGE * GS_DISPLAY-PLANQTY9 * 4.
        MODIFY GT_STPO FROM GS_STPO.
      WHEN 'PLANQTY10'.
        GS_STPO-MENGE = GS_STPO-MENGE * GS_DISPLAY-PLANQTY10 * 4.
        MODIFY GT_STPO FROM GS_STPO.
      WHEN 'PLANQTY11'.
        GS_STPO-MENGE = GS_STPO-MENGE * GS_DISPLAY-PLANQTY11 * 4.
        MODIFY GT_STPO FROM GS_STPO.
      WHEN 'PLANQTY12'.
        GS_STPO-MENGE = GS_STPO-MENGE * GS_DISPLAY-PLANQTY12 * 4.
        MODIFY GT_STPO FROM GS_STPO.
    ENDCASE.

  ENDLOOP.

  REFRESH GT_COLLECT.

  LOOP AT GT_STPO INTO GS_STPO.
    MOVE-CORRESPONDING GS_STPO TO GS_COLLECT.
    COLLECT GS_COLLECT INTO GT_COLLECT.
    CLEAR GS_COLLECT.
  ENDLOOP.

  DATA LV_STOCK TYPE ZEA_MMT190-WEIGHT.

  LOOP AT GT_COLLECT INTO GS_COLLECT.

    SELECT SINGLE WEIGHT
          FROM ZEA_MMT190
          INTO LV_STOCK
          WHERE MATNR EQ GS_COLLECT-MATNR.

    GS_COLLECT-STOCK = LV_STOCK.

    IF GS_COLLECT-MENGE GT LV_STOCK.
      GS_COLLECT-REQQTY = GS_COLLECT-MENGE - LV_STOCK.
    ELSE.
      GS_COLLECT-REQQTY = 0.
    ENDIF.

    MODIFY GT_COLLECT FROM GS_COLLECT.
  ENDLOOP.

  SORT GT_COLLECT BY MATNR.

  MOVE-CORRESPONDING GT_COLLECT TO GT_COLLECT_DISPLAY.

  LOOP AT GT_COLLECT_DISPLAY INTO GS_COLLECT_DISPLAY.

    IF GS_COLLECT_DISPLAY-REQQTY GT 0.
      CLEAR GS_FIELD_COLOR.
      GS_FIELD_COLOR-FNAME = 'REQQTY'.
      GS_FIELD_COLOR-COLOR-COL = 6. " 빨강
      GS_FIELD_COLOR-COLOR-INT = 0.
      GS_FIELD_COLOR-COLOR-INV = 0.
      APPEND GS_FIELD_COLOR TO GS_COLLECT_DISPLAY-IT_FIELD_COLORS.
    ENDIF.
*--------------------------------------------------------------------*
    MODIFY GT_COLLECT_DISPLAY FROM GS_COLLECT_DISPLAY.

  ENDLOOP.

  CALL SCREEN 0120 STARTING AT 50 5.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MODIFY_STPO_DISPLAY_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM MODIFY_STPO_DISPLAY_DATA .


  LOOP AT GT_STPO_DISPLAY INTO GS_STPO_DISPLAY.

    CASE GS_STPO_DISPLAY-MATTYPE.
      WHEN '원자재'.
        CLEAR GS_FIELD_COLOR.
        GS_FIELD_COLOR-FNAME = 'MATTYPE'.
        GS_FIELD_COLOR-COLOR-COL = 3. " 노랑
        GS_FIELD_COLOR-COLOR-INT = 1.
        GS_FIELD_COLOR-COLOR-INV = 0.
        APPEND GS_FIELD_COLOR TO GS_STPO_DISPLAY-IT_FIELD_COLORS.
      WHEN '반제품'.
        CLEAR GS_FIELD_COLOR.
        GS_FIELD_COLOR-FNAME = 'MATTYPE'.
        GS_FIELD_COLOR-COLOR-COL = 5. " 초록
        GS_FIELD_COLOR-COLOR-INT = 0.
        GS_FIELD_COLOR-COLOR-INV = 0.
        APPEND GS_FIELD_COLOR TO GS_STPO_DISPLAY-IT_FIELD_COLORS.
    ENDCASE.

    MODIFY GT_STPO_DISPLAY FROM GS_STPO_DISPLAY.
  ENDLOOP.

  SORT GT_STPO_DISPLAY BY BOMINDEX.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form NO_FILTER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM NO_FILTER .

  REFRESH GT_FILTER.

  PERFORM SET_ALV_FILTER.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FIN_FILTER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SEMI_FILTER .

  REFRESH GT_FILTER.

  CLEAR GS_FILTER.
  GS_FILTER-FIELDNAME = 'MATTYPE'.
  GS_FILTER-SIGN      = 'I'.
  GS_FILTER-OPTION    = 'EQ'.
  GS_FILTER-LOW       = '반제품'.
  APPEND GS_FILTER TO GT_FILTER.

  PERFORM SET_ALV_FILTER.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SEMI_FILTER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM RAW_FILTER .

  REFRESH GT_FILTER.

  CLEAR GS_FILTER.
  GS_FILTER-FIELDNAME = 'MATTYPE'.
  GS_FILTER-SIGN      = 'I'.
  GS_FILTER-OPTION    = 'EQ'.
  GS_FILTER-LOW       = '원자재'.
  APPEND GS_FILTER TO GT_FILTER.

  PERFORM SET_ALV_FILTER.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form BACK_BOM
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM BACK_BOM .

  DATA LV_LINES TYPE I.

  DESCRIBE TABLE GT_STKO_DISPLAY LINES LV_LINES.

  IF LV_LINES EQ 1.
    MESSAGE I000 DISPLAY LIKE 'W' WITH '최상위 LEVEL BOM 입니다.'.
    EXIT.
  ENDIF.

  READ TABLE GT_STKO_DISPLAY INTO GS_STKO_DISPLAY INDEX LV_LINES - 1.

  DATA LV_BOMID TYPE ZEA_STKO-BOMID.

  LV_BOMID = GS_STKO_DISPLAY-BOMID.
*
*  GS_STKO_DISPLAY-LOEKZ = 'X'.
*
*  MODIFY GT_STKO_DISPLAY FROM GS_STKO_DISPLAY INDEX LV_LINES.

  DELETE GT_STKO_DISPLAY INDEX LV_LINES.

  SELECT  *
    FROM ZEA_STPO AS A
    INNER JOIN ZEA_MMT020 AS B
    ON A~MATNR EQ B~MATNR
    AND SPRAS  EQ SY-LANGU
    INNER JOIN ZEA_MMT010 AS C
    ON C~MATNR EQ B~MATNR
    INTO CORRESPONDING FIELDS OF TABLE GT_STPO_DISPLAY
    WHERE A~BOMID EQ LV_BOMID
      AND A~LOEKZ NE ABAP_ON.

  DATA LS_STYLE TYPE LVC_S_STYL.

  LOOP AT GT_STPO_DISPLAY INTO GS_STPO_DISPLAY.

    SELECT SINGLE BOMID
        FROM ZEA_STKO
        INTO LV_BOMID
        WHERE MATNR EQ GS_STPO_DISPLAY-MATNR
          AND MENGE EQ GS_STPO_DISPLAY-MENGE
          AND MEINS EQ GS_STPO_DISPLAY-MEINS.

    IF SY-SUBRC EQ 0.
      GS_STPO_DISPLAY-BOMID2 = LV_BOMID.
    ENDIF.

    IF GS_STPO_DISPLAY-MATTYPE EQ '반제품'.
      LS_STYLE-FIELDNAME = 'BOMID2'.
      LS_STYLE-STYLE        = CL_GUI_ALV_GRID=>MC_STYLE_HOTSPOT. "HOTSPOT 활성화
      INSERT LS_STYLE INTO TABLE GS_STPO_DISPLAY-STYLE.
    ELSE.
      LS_STYLE-FIELDNAME = 'BOMID2'.
      LS_STYLE-STYLE        = CL_GUI_ALV_GRID=>MC_STYLE_HOTSPOT_NO. "HOTSPOT 비활성화
      INSERT LS_STYLE INTO TABLE GS_STPO_DISPLAY-STYLE.
    ENDIF.

*--------------------------------------------------------------------*
    MODIFY GT_STPO_DISPLAY FROM GS_STPO_DISPLAY.

  ENDLOOP.

  PERFORM MODIFY_STPO_DISPLAY_DATA.

  DESCRIBE TABLE GT_STKO_DISPLAY LINES LV_LINES.

  GS_STKO_DISPLAY-COLOR = 'C310'.
  MODIFY GT_STKO_DISPLAY FROM GS_STKO_DISPLAY
  INDEX LV_LINES  TRANSPORTING COLOR .

  PERFORM REFRESH_ALV_0100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FIELDCAT_0120
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_ALV_FIELDCAT_0120 .

  PERFORM GET_FIELDCAT_0100   USING    GT_COLLECT
                           CHANGING    GT_FIELDCAT4.

  PERFORM SET_FIELDCAT_0120.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_0120
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV_0120 .

  CALL METHOD GO_ALV_GRID4->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
*     I_STRUCTURE_NAME              = ''
      IS_VARIANT                    = GS_VARIANT
      I_SAVE                        = GV_SAVE
      IS_LAYOUT                     = GS_LAYOUT4
    CHANGING
      IT_OUTTAB                     = GT_COLLECT_DISPLAY
      IT_FIELDCATALOG               = GT_FIELDCAT4
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
*& Form REFRESH_ALV_0120
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM REFRESH_ALV_0120 .

  DATA LS_STABLE TYPE LVC_S_STBL.
  LS_STABLE-ROW = ABAP_ON.
  LS_STABLE-COL = ABAP_ON.

  CALL METHOD GO_ALV_GRID4->REFRESH_TABLE_DISPLAY
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
*& Form SET_FIELDCAT_0120
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_FIELDCAT_0120 .

  LOOP AT GT_FIELDCAT4 INTO GS_FIELDCAT4.
    CASE GS_FIELDCAT4-FIELDNAME.
      WHEN 'STOCK'.
        GS_FIELDCAT4-QFIELDNAME = 'MEINS'.
      WHEN 'MENGE'.
        GS_FIELDCAT4-COLTEXT    = '자재소모량'.
        GS_FIELDCAT4-QFIELDNAME = 'MEINS'.
      WHEN 'REQQTY'.
        GS_FIELDCAT4-QFIELDNAME  = 'MEINS'.
      WHEN 'MEINS'.
        GS_FIELDCAT4-COLTEXT = '단위'.
    ENDCASE.

    MODIFY GT_FIELDCAT4 FROM GS_FIELDCAT4.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_LAYOUT_0120
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_ALV_LAYOUT_0120 .

  CLEAR GS_LAYOUT4.
  GS_VARIANT-HANDLE = '4'.
  GV_SAVE = 'A'.   " '' : Layout 저장불가

  GS_LAYOUT4-CWIDTH_OPT = 'A'.
  GS_LAYOUT4-ZEBRA      = ABAP_ON.
  GS_LAYOUT4-CTAB_FNAME = 'IT_FIELD_COLORS'. " 셀 별 색상

ENDFORM.
