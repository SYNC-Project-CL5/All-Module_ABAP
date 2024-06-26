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
*& Form CREATE_NODE_0100
*&---------------------------------------------------------------------*
FORM CREATE_NODE_0100 .


  SORT GT_HEADER BY GJAHR DESCENDING
                    WERKS MATTYPE MATNR.

  DATA LV_NODE_KEY        TYPE N LENGTH 6.
  DATA LV_NODE_KEY_SUPER  TYPE N LENGTH 6.
  DATA LT_NODE_KEY_LEVEL  LIKE TABLE OF LV_NODE_KEY.

  LV_NODE_KEY += 1.
  CLEAR GS_NODE.
  GS_NODE-RELATKEY = SPACE. " 가장 최상위의 노드는 항상 공백이여야 한다.
  GS_NODE-NODE_KEY = LV_NODE_KEY_SUPER = LV_NODE_KEY.
  GS_NODE-ISFOLDER = ABAP_ON.
  GS_NODE-TEXT     = '회계 연도'.
  GS_NODE-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
  APPEND GS_NODE TO GT_NODE.

  " 1레벨 생성
  INSERT LV_NODE_KEY_SUPER INTO LT_NODE_KEY_LEVEL INDEX 1.

  CLEAR GS_NODE_INFO.
*  GS_NODE_INFO-GJAHR = SPACE.
*  GS_NODE_INFO-WERKS = SPACE.
*  GS_NODE_INFO-MATTYPE = SPACE.
*  GS_NODE_INFO-MATNR = SPACE.
  GS_NODE_INFO-NODE_KEY = LV_NODE_KEY.
  APPEND GS_NODE_INFO TO GT_NODE_INFO.

  LOOP AT GT_HEADER INTO GS_HEADER.

*--------------------------------------------------------------------*
    AT NEW GJAHR.
*--------------------------------------------------------------------*
      " 폴더 노드 추가
      LV_NODE_KEY += 1.
      CLEAR GS_NODE.
      GS_NODE-RELATKEY = LV_NODE_KEY_SUPER.
      GS_NODE-NODE_KEY = LV_NODE_KEY_SUPER = LV_NODE_KEY.
      GS_NODE-ISFOLDER = ABAP_ON.
      GS_NODE-TEXT     = |{ GS_HEADER-GJAHR }|.
      GS_NODE-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
      APPEND GS_NODE TO GT_NODE.

      " 2레벨 생성
      INSERT LV_NODE_KEY_SUPER INTO LT_NODE_KEY_LEVEL INDEX 1.

      CLEAR GS_NODE_INFO.
      GS_NODE_INFO-GJAHR = GS_HEADER-GJAHR.
      GS_NODE_INFO-WERKS = SPACE.
      GS_NODE_INFO-MATTYPE = SPACE.
      GS_NODE_INFO-MATNR = SPACE.
      GS_NODE_INFO-NODE_KEY = LV_NODE_KEY.
      APPEND GS_NODE_INFO TO GT_NODE_INFO.

    ENDAT.


*--------------------------------------------------------------------*
    AT NEW PNAME1.
*--------------------------------------------------------------------*

      IF GS_HEADER-WERKS IS NOT INITIAL.
        LV_NODE_KEY += 1.

        CLEAR GS_NODE.
        " 2레벨 노드를 상위노드로 지정
        GS_NODE-RELATKEY = LV_NODE_KEY_SUPER.
        GS_NODE-NODE_KEY = LV_NODE_KEY_SUPER = LV_NODE_KEY."LV_NODE_KEY.
        GS_NODE-ISFOLDER = ABAP_ON.
        GS_NODE-TEXT     = |{ GS_HEADER-WERKS } - { GS_HEADER-PNAME1 }|.
        GS_NODE-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
        APPEND GS_NODE TO GT_NODE.

        " 3레벨 생성
        INSERT LV_NODE_KEY_SUPER INTO LT_NODE_KEY_LEVEL INDEX 1.

        CLEAR GS_NODE_INFO.
        GS_NODE_INFO-GJAHR = GS_HEADER-GJAHR.
        GS_NODE_INFO-WERKS = GS_HEADER-WERKS."SPACE.
        GS_NODE_INFO-MATTYPE = SPACE.
        GS_NODE_INFO-MATNR = SPACE.
        GS_NODE_INFO-NODE_KEY = LV_NODE_KEY.
        APPEND GS_NODE_INFO TO GT_NODE_INFO.
      ENDIF.

    ENDAT.


*--------------------------------------------------------------------*
    AT NEW MATTYPE.
*--------------------------------------------------------------------*

      IF GS_HEADER-MATTYPE IS NOT INITIAL.
        LV_NODE_KEY += 1.      " LV_NODE_KEY 4이고 LV_NODE_KEY_SUPER = 1

        CLEAR GS_NODE.
        " 3레벨 노드를 상위노드로 지정
        GS_NODE-RELATKEY = LV_NODE_KEY_SUPER.
        GS_NODE-NODE_KEY = LV_NODE_KEY_SUPER = LV_NODE_KEY.
        GS_NODE-ISFOLDER = ABAP_ON.
        GS_NODE-TEXT     = |{ GS_HEADER-MATTYPE }|.
        GS_NODE-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
        APPEND GS_NODE TO GT_NODE.

        " 4레벨 생성
        INSERT LV_NODE_KEY_SUPER INTO LT_NODE_KEY_LEVEL INDEX 1.

        CLEAR GS_NODE_INFO.
        GS_NODE_INFO-GJAHR   = GS_HEADER-GJAHR.
        GS_NODE_INFO-WERKS   = GS_HEADER-WERKS.
        GS_NODE_INFO-MATTYPE = GS_HEADER-MATTYPE.
        GS_NODE_INFO-MATNR   = SPACE.
        GS_NODE_INFO-NODE_KEY = LV_NODE_KEY.
        APPEND GS_NODE_INFO TO GT_NODE_INFO.
      ENDIF.

    ENDAT.


*--------------------------------------------------------------------*
* 자재코드 마지막 최하위 노드
*--------------------------------------------------------------------*
    IF GS_HEADER-MATNR IS NOT INITIAL.
      LV_NODE_KEY += 1.      " LV_NODE_KEY 4이고 LV_NODE_KEY_SUPER = 1

      CLEAR GS_NODE.
      " 3레벨 노드를 상위노드로 지정
      GS_NODE-RELATKEY = LV_NODE_KEY_SUPER.
      GS_NODE-NODE_KEY = LV_NODE_KEY.
*        GS_NODE-NODE_KEY = LV_NODE_KEY_SUPER = LV_NODE_KEY.
*        GS_NODE-ISFOLDER = ABAP_ON.
      GS_NODE-ISFOLDER = ABAP_OFF.
      GS_NODE-TEXT     = |{ GS_HEADER-MATNR } { GS_HEADER-MAKTX }|.
      GS_NODE-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
      APPEND GS_NODE TO GT_NODE.

*        " 4레벨 생성
*        INSERT LV_NODE_KEY_SUPER INTO LT_NODE_KEY_LEVEL INDEX 1.

      CLEAR GS_NODE_INFO.
      GS_NODE_INFO-GJAHR   = GS_HEADER-GJAHR.
      GS_NODE_INFO-WERKS   = GS_HEADER-WERKS.
      GS_NODE_INFO-MATTYPE = GS_HEADER-MATTYPE.
      GS_NODE_INFO-MATNR   = GS_HEADER-MATNR.
      GS_NODE_INFO-NODE_KEY = LV_NODE_KEY.
      APPEND GS_NODE_INFO TO GT_NODE_INFO.
    ENDIF.
*--------------------------------------------------------------------*


    AT END OF MATTYPE.
      " 4레벨 제거 및 3레벨의 상위노드 정보 조회
      DELETE LT_NODE_KEY_LEVEL INDEX 1.
      READ TABLE LT_NODE_KEY_LEVEL INTO LV_NODE_KEY_SUPER INDEX 1.
    ENDAT.

    AT END OF PNAME1.
      " 3레벨 제거 및 2레벨의 상위노드 정보 조회
      DELETE LT_NODE_KEY_LEVEL INDEX 1.
      READ TABLE LT_NODE_KEY_LEVEL INTO LV_NODE_KEY_SUPER INDEX 1.
    ENDAT.

    AT END OF GJAHR.
      " 2레벨 제거 및 1레벨의 상위노드 정보 조회
      DELETE LT_NODE_KEY_LEVEL INDEX 1.
      READ TABLE LT_NODE_KEY_LEVEL INTO LV_NODE_KEY_SUPER INDEX 1.
    ENDAT.

  ENDLOOP.


  CALL METHOD GO_SIMPLE_TREE->ADD_NODES
    EXPORTING
      TABLE_STRUCTURE_NAME           = 'MTREESNODE'     " Name of Structure of Node Table
      NODE_TABLE                     = GT_NODE          " Node table
    EXCEPTIONS
      ERROR_IN_NODE_TABLE            = 1                " Node Table Contains Errors
      FAILED                         = 2                " General error
      DP_ERROR                       = 3                " Error in Data Provider
      TABLE_STRUCTURE_NAME_NOT_FOUND = 4                " Unable to Find Structure in Dictionary
      OTHERS                         = 5.
  IF SY-SUBRC <> 0.
    MESSAGE E025. " TREE NODE 생성 중 오류가 발생했습니다.
  ENDIF.



  GO_SIMPLE_TREE->EXPAND_ROOT_NODES(
    EXPORTING
*      LEVEL_COUNT         =                  " Number of Levels to be Expanded
      EXPAND_SUBTREE      = 'X'                 " 'X': Expand all Subsequent Nodes
*    EXCEPTIONS
*      FAILED              = 1                " General Error
*      ILLEGAL_LEVEL_COUNT = 2                " LEVEL_COUNT Must Be GE 0
*      CNTL_SYSTEM_ERROR   = 3                " "
*      OTHERS              = 4
  ).
  IF SY-SUBRC <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_DATA
*&---------------------------------------------------------------------*
FORM SELECT_DATA .

  REFRESH GT_HEADER.

  SELECT FROM ZEA_MMT090 AS A
         JOIN ZEA_MMT100 AS B
           ON A~GJAHR EQ B~GJAHR
          AND A~MBLNR EQ B~MBLNR
         JOIN ZEA_MMT010 AS C
           ON C~MATNR EQ B~MATNR
        LEFT JOIN ZEA_T001W AS D
           ON D~WERKS EQ B~PLANTFR
         LEFT JOIN ZEA_MMT020 AS E
           ON E~MATNR EQ C~MATNR
          AND E~SPRAS EQ @SY-LANGU
  FIELDS DISTINCT A~GJAHR, B~PLANTFR,D~PNAME1, C~MATTYPE, B~MATNR, E~MAKTX
   WHERE B~PLANTFR IS NOT INITIAL
    INTO TABLE @GT_HEADER.


  SELECT FROM ZEA_MMT090 AS A
         JOIN ZEA_MMT100 AS B
           ON A~GJAHR EQ B~GJAHR
          AND A~MBLNR EQ B~MBLNR
         JOIN ZEA_MMT010 AS C
           ON C~MATNR EQ B~MATNR
        LEFT JOIN ZEA_T001W AS D
           ON D~WERKS EQ B~PLANTTO
         LEFT JOIN ZEA_MMT020 AS E
           ON E~MATNR EQ C~MATNR
          AND E~SPRAS EQ @SY-LANGU
  FIELDS DISTINCT A~GJAHR, B~PLANTTO,D~PNAME1, C~MATTYPE, B~MATNR, E~MAKTX
   WHERE B~PLANTTO IS NOT INITIAL
  APPENDING TABLE @GT_HEADER.

  SORT GT_HEADER BY GJAHR WERKS MATTYPE MATNR.
  DELETE ADJACENT DUPLICATES FROM GT_HEADER COMPARING GJAHR WERKS MATTYPE MATNR.

*SELECT A~GJAHR, A~WERKS,D~PNAME1, C~MATTYPE, B~MATNR, E~MAKTX
*  FROM ZEA_MMT090 AS A LEFT JOIN ZEA_MMT100 AS B
*           ON A~GJAHR EQ B~GJAHR
*          AND A~MBLNR EQ B~MBLNR
*         JOIN ZEA_MMT010 AS C
*           ON C~MATNR EQ B~MATNR
*         JOIN ZEA_T001W AS D
*           ON D~WERKS EQ A~WERKS
*         JOIN ZEA_MMT020 AS E
*           ON E~MATNR EQ C~MATNR
*          AND E~SPRAS EQ @SY-LANGU
*  INTO TABLE @GT_HEADER.

*    WHERE B~GJAHR EQ @ZEA_MMT090-GJAHR
*      AND A~WERKS EQ @ZEA_MMT090-WERKS
*      AND D~PNAME1 EQ @ZEA_T001W-PNAME1
*      AND C~MATTYPE EQ @ZEA_MMT010-MATTYPE
*      AND E~MATNR EQ @ZEA_MMT100-MATNR
*      AND E~MAKTX  EQ @ZEA_MMT020-MAKTX

*    WHERE B~GJAHR EQ @GS_HEADER-GJAHR
*      AND A~WERKS EQ @GS_HEADER-WERKS
*      AND D~PNAME1 EQ @GS_HEADER-PNAME1
*      AND C~MATTYPE EQ @GS_HEADER-MATTYPE
*      AND E~MATNR EQ @GS_HEADER-MATNR
*      AND E~MAKTX  EQ @GS_HEADER-MAKTX

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

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_LAYOUT_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_ALV_LAYOUT_0100 .

  CLEAR GS_LAYOUT.

  GS_LAYOUT-ZEBRA = ABAP_ON.
  GS_LAYOUT-CWIDTH_OPT = 'A'.
  GS_LAYOUT-SEL_MODE = 'D'.
  GS_LAYOUT-GRID_TITLE = TEXT-T01.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FIELDCAT_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_ALV_FIELDCAT_0100 .

  PERFORM GET_FIELDCAT_0100 USING GT_DISPLAY
                                  GT_FIELDCAT.

  PERFORM SET_FIELDCAT_0100.

  PERFORM DISPLAY_ALV_0100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_FIELDCAT_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_DISPLAY
*&      --> GT_FIELDCAT
*&---------------------------------------------------------------------*
FORM GET_FIELDCAT_0100  USING    PT_DISPLAY  TYPE STANDARD TABLE
                                 PT_FIELDCAT TYPE LVC_T_FCAT.

  TRY.
      CALL METHOD CL_SALV_TABLE=>FACTORY
        IMPORTING
          R_SALV_TABLE = DATA(LO_SALV_TABLE)
        CHANGING
          T_TABLE      = PT_DISPLAY.

      DATA(LO_COLUMNS) = LO_SALV_TABLE->GET_COLUMNS( ).
      DATA(LO_AGGREGATIONS) = LO_SALV_TABLE->GET_AGGREGATIONS( ).

      PT_FIELDCAT = CL_SALV_CONTROLLER_METADATA=>GET_LVC_FIELDCATALOG(
                      R_COLUMNS      = LO_COLUMNS
                      R_AGGREGATIONS = LO_AGGREGATIONS ).
    CATCH CX_SALV_MSG.
  ENDTRY.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_FIELDCAT_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_FIELDCAT_0100 .

  LOOP AT GT_FIELDCAT INTO GS_FIELDCAT.

    CASE GS_FIELDCAT-FIELDNAME.

      WHEN 'MBLNR'
        OR 'GJAHR'
        OR 'MBGNO'.
        GS_FIELDCAT-KEY = ABAP_ON.
        GS_FIELDCAT-JUST = 'C'.


      WHEN 'GJAHR'
       OR 'WERKS'
       OR 'PNAME1'
       OR 'MATTYPE'
       OR 'MATNR'
       OR 'BUDAT'
       OR 'MAKTX'
       OR 'MBLNR'
       OR 'MBGNO'
       OR 'BWART'.
        GS_FIELDCAT-JUST = 'C'.
      WHEN 'PLANTFR'.
        GS_FIELDCAT-EMPHASIZE = 'C500'.
      WHEN 'PLANTTO'.
        GS_FIELDCAT-EMPHASIZE = 'C310'.
      WHEN 'LGORTFR'.
        GS_FIELDCAT-EMPHASIZE = 'C500'.
      WHEN 'LGORTTO'.
        GS_FIELDCAT-EMPHASIZE = '310'.
      WHEN 'DMBTR'.
        GS_FIELDCAT-CFIELDNAME = 'WAERS1'.
      WHEN 'WRBTR'.
        GS_FIELDCAT-CFIELDNAME = 'WAERS2'.
      WHEN 'MENGE'.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
      WHEN 'VENCODE'
        OR 'CUSCODE'.
        GS_FIELDCAT-JUST = 'C'.

    ENDCASE.

    MODIFY GT_FIELDCAT FROM GS_FIELDCAT.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_0100
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV_0100 .

  GS_VARIANT-REPORT = SY-REPID.
  GS_VARIANT-HANDLE = 'H'.
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
ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_NODE_DOUBLE_CLICK
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> NODE_KEY
*&      --> SENDER
*&---------------------------------------------------------------------*
FORM HANDLE_NODE_DOUBLE_CLICK  USING PV_NODE_KEY TYPE MTREESNODE-NODE_KEY
                                     PV_SENDER   TYPE REF TO CL_GUI_SIMPLE_TREE.

  IF GO_ALV_GRID IS INITIAL.

    MESSAGE S000 DISPLAY LIKE 'E' WITH TEXT-E01.
    EXIT.
  ENDIF.

  READ TABLE GT_NODE_INFO INTO GS_NODE_INFO
                          WITH KEY NODE_KEY = PV_NODE_KEY
                                            BINARY SEARCH.

  CHECK SY-SUBRC EQ 0.

  RANGES: R_GJAHR   FOR GS_NODE_INFO-GJAHR,
          R_WERKS   FOR GS_NODE_INFO-WERKS,
          R_MATTYPE FOR GS_NODE_INFO-MATTYPE,
          R_MATNR   FOR GS_NODE_INFO-MATNR.

  IF GS_NODE_INFO-GJAHR IS NOT INITIAL.
    R_GJAHR-SIGN = 'I'.
    R_GJAHR-OPTION = 'EQ'.
    R_GJAHR-LOW = GS_NODE_INFO-GJAHR.
    APPEND R_GJAHR.
  ENDIF.

  IF GS_NODE_INFO-WERKS IS NOT INITIAL.
    R_WERKS-SIGN = 'I'.
    R_WERKS-OPTION = 'EQ'.
    R_WERKS-LOW = GS_NODE_INFO-WERKS.
    APPEND R_WERKS.
  ENDIF.

  IF GS_NODE_INFO-MATTYPE IS NOT INITIAL.
    R_MATTYPE-SIGN = 'I'.
    R_MATTYPE-OPTION = 'EQ'.
    R_MATTYPE-LOW = GS_NODE_INFO-MATTYPE.
    APPEND R_MATTYPE.
  ENDIF.

  IF GS_NODE_INFO-MATNR IS NOT INITIAL.
    R_MATNR-SIGN = 'I'.
    R_MATNR-OPTION = 'EQ'.
    R_MATNR-LOW = GS_NODE_INFO-MATNR.
    APPEND R_MATNR.
  ENDIF.




  SELECT FROM ZEA_MMT090 AS A
        LEFT JOIN ZEA_MMT100 AS B ON B~MBLNR EQ A~MBLNR
        LEFT JOIN ZEA_T001W  AS C ON C~WERKS EQ A~WERKS
        LEFT JOIN ZEA_MMT010 AS D ON D~MATNR EQ B~MATNR
        LEFT JOIN ZEA_MMT020 AS E ON E~MATNR EQ B~MATNR
                             AND E~SPRAS EQ @SY-LANGU

    FIELDS *
    WHERE A~GJAHR   IN @R_GJAHR
      AND B~MATNR   IN @R_MATNR
      AND C~WERKS   IN @R_WERKS
      AND D~MATTYPE IN @R_MATTYPE
     INTO CORRESPONDING FIELDS OF TABLE @GT_DISPLAY.

  SORT GT_DISPLAY BY GJAHR MBLNR MATNR.

  GO_ALV_GRID->REFRESH_TABLE_DISPLAY(
    EXCEPTIONS
      FINISHED       = 1                " Display was Ended (by Export)
      OTHERS         = 2 ).
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
      WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_EVENT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_EVENT_0100 .
  SET HANDLER LCL_EVENT_HANDLER=>ON_NODE_DOUBLE_CLICK FOR GO_SIMPLE_TREE.
ENDFORM.
