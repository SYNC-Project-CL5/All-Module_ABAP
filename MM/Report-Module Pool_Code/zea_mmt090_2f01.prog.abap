*&---------------------------------------------------------------------*
*& Include          ZEA_CHECK_MTF01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form SELECT_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SELECT_DATA .

  REFRESH GT_HEADER.

  " 노드 구성 요소 조회
  SELECT FROM ZEA_MMT190 AS A
    JOIN ZEA_MMT020 AS B
      ON B~MATNR EQ A~MATNR
    JOIN ZEA_MMT010 AS C
      ON C~MATNR EQ A~MATNR
    JOIN ZEA_T001W AS D
      ON D~WERKS EQ A~WERKS
  FIELDS D~BUKRS, C~MATTYPE, A~MATNR, B~MAKTX
         INTO CORRESPONDING FIELDS OF TABLE @GT_HEADER.


  REFRESH GT_HEADER_2.

  SELECT FROM ZEA_MMT190 AS A
    LEFT JOIN ZEA_T001W AS B
      ON A~WERKS EQ B~WERKS
    JOIN ZEA_MMT060 AS C
      ON C~WERKS EQ A~WERKS
    FIELDS A~WERKS, B~PNAME1, C~SCODE, C~STYPE
    INTO CORRESPONDING FIELDS OF TABLE @GT_HEADER_2.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DISPLAY_DATA .
  DESCRIBE TABLE GT_DISPLAY LINES GV_LINES.

  IF GT_DISPLAY IS INITIAL.
    MESSAGE S013 DISPLAY LIKE 'W'.
  ELSE.
    MESSAGE S006 WITH GV_LINES.
  ENDIF.

  CALL SCREEN 0100.
ENDFORM.
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
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CREATE_NODE_0100 .

  " NODE를 아래와 같은 구성으로 만듦
  " 출발국가 1
  "  ㄴ 출발도시 2
  "       ㄴ 항공사 3
  "             ㄴ 항공편 4

  GT_HEADER[] = CORRESPONDING #( GT_HEADER ).
  DELETE GT_HEADER WHERE BUKRS IS INITIAL.

  SORT GT_HEADER BY BUKRS MATTYPE MATNR MAKTX.

  DATA LV_NODE_KEY_SUPER  TYPE N LENGTH 6.
  DATA LT_NODE_KEY_LEVEL  LIKE TABLE OF GV_NODE_KEY.

  GV_NODE_KEY += 1.
  CLEAR GS_NODE.
  GS_NODE-RELATKEY = SPACE. " 가장 최상위의 노드는 항상 공백이여야 한다.
  GS_NODE-NODE_KEY = LV_NODE_KEY_SUPER = GV_NODE_KEY.
  GS_NODE-ISFOLDER = ABAP_ON.
  GS_NODE-TEXT     = '회사코드/자재유형/자재-자재명'.
  GS_NODE-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
  APPEND GS_NODE TO GT_NODE.

  " 1레벨 생성
  INSERT LV_NODE_KEY_SUPER INTO LT_NODE_KEY_LEVEL INDEX 1.

  CLEAR GS_NODE_INFO.
  GS_NODE_INFO-BUKRS = SPACE.
  GS_NODE_INFO-MATTYPE = SPACE.
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
      GS_NODE_INFO-MATTYPE = SPACE.
      GS_NODE_INFO-MATNR = SPACE.
      GS_NODE_INFO-NODE_KEY = GV_NODE_KEY.
      APPEND GS_NODE_INFO TO GT_NODE_INFO.

    ENDAT.

    AT NEW MATTYPE.

      " 폴더 노드 추가
      GV_NODE_KEY += 1.
      CLEAR GS_NODE.
      GS_NODE-RELATKEY = LV_NODE_KEY_SUPER.
      GS_NODE-NODE_KEY = LV_NODE_KEY_SUPER = GV_NODE_KEY.
      GS_NODE-ISFOLDER = ABAP_ON.
      GS_NODE-TEXT     = |{ GS_HEADER-MATTYPE }|.
      GS_NODE-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
      APPEND GS_NODE TO GT_NODE.

      " 2레벨 생성
      INSERT LV_NODE_KEY_SUPER INTO LT_NODE_KEY_LEVEL INDEX 1.


      CLEAR GS_NODE_INFO.
      GS_NODE_INFO-BUKRS = GS_HEADER-BUKRS.
      GS_NODE_INFO-MATTYPE = GS_HEADER-MATTYPE.
      GS_NODE_INFO-MATNR = SPACE.
      GS_NODE_INFO-NODE_KEY = GV_NODE_KEY.
      APPEND GS_NODE_INFO TO GT_NODE_INFO.

    ENDAT.

    AT NEW MAKTX.

      " 폴더 노드 추가
      GV_NODE_KEY += 1.
      CLEAR GS_NODE.
      GS_NODE-RELATKEY = LV_NODE_KEY_SUPER.
      GS_NODE-NODE_KEY = GV_NODE_KEY.
      GS_NODE-ISFOLDER = ABAP_OFF.
      GS_NODE-N_IMAGE  = ICON_CAR.
      GS_NODE-TEXT     = |{ GS_HEADER-MATNR } - { GS_HEADER-MAKTX }|.
      GS_NODE-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
      APPEND GS_NODE TO GT_NODE.

      " 2레벨 생성
      INSERT LV_NODE_KEY_SUPER INTO LT_NODE_KEY_LEVEL INDEX 1.


      CLEAR GS_NODE_INFO.
      GS_NODE_INFO-BUKRS = GS_HEADER-BUKRS.
      GS_NODE_INFO-MATTYPE = GS_HEADER-MATTYPE.
      GS_NODE_INFO-MATNR = GS_HEADER-MATNR.
      GS_NODE_INFO-NODE_KEY = GV_NODE_KEY.
      APPEND GS_NODE_INFO TO GT_NODE_INFO.

    ENDAT.



    AT END OF MAKTX.

      " 2레벨 제거 및 1레벨의 상위노드 정보 조회
      DELETE LT_NODE_KEY_LEVEL INDEX 1.
      READ TABLE LT_NODE_KEY_LEVEL INTO LV_NODE_KEY_SUPER INDEX 1.

    ENDAT.

    AT END OF MATTYPE.

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
*& Form ADD_NODE
*&---------------------------------------------------------------------*
FORM ADD_NODE .

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
*& Form HANDLE_DOUBLE_CLICK
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_ROW
*&      --> E_COLUMN
*&      --> SENDER
*&---------------------------------------------------------------------*
FORM HANDLE_DOUBLE_CLICK   USING PS_ROW    TYPE LVC_S_ROW
                                PS_COLUMN TYPE LVC_S_COL
                                PO_SENDER TYPE REF TO CL_GUI_ALV_GRID.

  DATA LT_INDEX_ROWS TYPE LVC_T_ROW.
  DATA LS_INDEX_ROW LIKE LINE OF LT_INDEX_ROWS.



  CALL METHOD GO_ALV_GRID->GET_SELECTED_ROWS
*  CALL METHOD PO_SENDER->GET_SELECTED_ROWS
    IMPORTING
      ET_INDEX_ROWS = LT_INDEX_ROWS.

  IF LT_INDEX_ROWS[] IS INITIAL.
    " TEXT-M01: 라인을 선택하세요.
    MESSAGE S000 DISPLAY LIKE 'W' WITH '라인을 선택하세요'.
  ELSE.

    LOOP AT LT_INDEX_ROWS INTO LS_INDEX_ROW WHERE ROWTYPE IS INITIAL.

      READ TABLE GT_DISPLAY INTO GS_DISPLAY INDEX LS_INDEX_ROW-INDEX.

      PERFORM PIC_URL.

    ENDLOOP.
  ENDIF.

  PERFORM REFRESH_PIC.


  CLEAR GV_PNAME1.
  CLEAR GV_SNAME.
  CLEAR GV_MAKTX.
  CLEAR GV_CALQTY.
  CLEAR GV_MEINS.

  GV_PNAME1  = GS_DISPLAY-PNAME1. " 플랜트명
  GV_SNAME   = GS_DISPLAY-SNAME.  " 저장위치명
  GV_MAKTX   = GS_DISPLAY-MAKTX.  " 자재명
  GV_CALQTY  = GS_DISPLAY-CALQTY. " 수량
  GV_MEINS   = GS_DISPLAY-MEINS.  " 단위

  LEAVE TO SCREEN 100.

*  GO_ALV_GRID->REFRESH_TABLE_DISPLAY(
*EXCEPTIONS
*  FINISHED       = 1                " Display was Ended (by Export)
*  OTHERS         = 2
*).
*  IF SY-SUBRC <> 0.
*    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*      WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*    ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_NODE_DOUBLE_CLICK
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

  RANGES: R_BUKRS   FOR GS_NODE_INFO-BUKRS,
          R_MATTYPE FOR GS_NODE_INFO-MATTYPE,
          R_MATNR   FOR GS_NODE_INFO-MATNR,
          R_SCODE   FOR GS_NODE_INFO-SCODE,
          R_WERKS   FOR GS_NODE_INFO-WERKS.


  IF GS_NODE_INFO-BUKRS IS NOT INITIAL.
    R_BUKRS = 'I'.
    R_BUKRS-OPTION = 'EQ'.
    R_BUKRS-LOW = GS_NODE_INFO-BUKRS.
    APPEND R_BUKRS.
  ENDIF.

  IF GS_NODE_INFO-MATTYPE IS NOT INITIAL.
    R_MATTYPE = 'I'.
    R_MATTYPE-OPTION = 'EQ'.
    R_MATTYPE-LOW = GS_NODE_INFO-MATTYPE.
    APPEND R_MATTYPE.
  ENDIF.

  IF GS_NODE_INFO-MATNR IS NOT INITIAL.
    R_MATNR = 'I'.
    R_MATNR-OPTION = 'EQ'.
    R_MATNR-LOW = GS_NODE_INFO-MATNR.
    APPEND R_MATNR.
  ENDIF.

  SELECT FROM ZEA_MMT190  AS A
         JOIN ZEA_MMT020  AS B ON B~MATNR EQ A~MATNR
         LEFT JOIN ZEA_T001W   AS C ON C~WERKS EQ A~WERKS
         JOIN ZEA_MMT010  AS D ON D~MATNR EQ A~MATNR
         JOIN ZEA_MMT060 AS E ON E~WERKS EQ A~WERKS

       FIELDS C~BUKRS, A~MATNR, C~WERKS, A~SCODE, A~CALQTY, A~MEINS,
              A~WEIGHT, A~MEINS2, A~SAFSTK, A~MEINS3, B~MAKTX,
              C~PNAME1, E~SNAME
        WHERE C~BUKRS       IN @R_BUKRS
          AND D~MATTYPE     IN @R_MATTYPE
          AND A~MATNR       IN @R_MATNR
       INTO CORRESPONDING FIELDS OF TABLE @GT_DISPLAY.

  " 안전재고
  DATA LV_RATIO TYPE P DECIMALS 2.
  LOOP AT GT_DISPLAY INTO GS_DISPLAY.

    IF GS_DISPLAY-SAFSTK <= 0.

      GS_DISPLAY-STATUS = ICON_CANCEL. " 빨간색 LED 아이콘
      " 수정된 데이터를 테이블에 반영
      MODIFY GT_DISPLAY FROM GS_DISPLAY TRANSPORTING STATUS.
    ENDIF.

*   안전재고 대비 현재 재고의 비율 계산
    IF GS_DISPLAY-SAFSTK > 0.
      LV_RATIO = ( GS_DISPLAY-CALQTY / GS_DISPLAY-SAFSTK ) * 100.
    ELSE.
      CONTINUE.  " 안전재고가 0이면 계산을 건너뜁니다.
    ENDIF.

    IF LV_RATIO < 110.

      GS_DISPLAY-STATUS = ICON_LED_RED. " 빨간색 LED 아이콘
    ELSEIF LV_RATIO >= 110 AND LV_RATIO <= 150.
      GS_DISPLAY-STATUS = ICON_LED_YELLOW. " 노란색 LED 아이콘
    ELSEIF LV_RATIO > 150.
      GS_DISPLAY-STATUS = ICON_LED_GREEN. " 초록색 LED 아이콘
    ENDIF.

    " 수정된 데이터를 테이블에 반영
    MODIFY GT_DISPLAY FROM GS_DISPLAY TRANSPORTING STATUS.





  ENDLOOP.

  SORT GT_DISPLAY BY MATNR.
*
  CLEAR GS_DISPLAY.                                       "Z
  READ TABLE GT_DISPLAY INTO GS_DISPLAY INDEX 1.        "z

  IF R_MATNR IS NOT INITIAL.

    GV_PNAME1  = GS_DISPLAY-PNAME1. " 플랜트명
    GV_SNAME   = GS_DISPLAY-SNAME.  " 저장위치명
    GV_MAKTX   = GS_DISPLAY-MAKTX.  " 자재명
    GV_CALQTY  = GS_DISPLAY-CALQTY. " 수량
    GV_MEINS   = GS_DISPLAY-MEINS.  " 단위
*    GV_WEIGHT  = GS_DISPLAY-WEIGHT.  " 무게
*    GV_MEINS2  = GS_DISPLAY-MEINS2.  " 단위

  ELSEIF R_SCODE IS NOT INITIAL AND R_MATNR IS INITIAL.
    CLEAR GV_PNAME1.
    CLEAR GV_SNAME.
    CLEAR GV_MAKTX.
    CLEAR GV_CALQTY.
    CLEAR GV_MEINS.
    GV_PNAME1  = GS_DISPLAY-PNAME1. " 플랜트명
    GV_SNAME   = GS_DISPLAY-SNAME.  " 저장위치명

  ELSEIF R_WERKS IS NOT INITIAL AND R_SCODE IS INITIAL AND R_MATNR IS INITIAL.
    CLEAR GV_PNAME1.
    CLEAR GV_SNAME.
    CLEAR GV_MAKTX.
    CLEAR GV_CALQTY.
    CLEAR GV_MEINS.
    GV_PNAME1  = GS_DISPLAY-PNAME1. " 플랜트명
  ELSEIF R_WERKS IS INITIAL AND R_SCODE IS INITIAL AND R_MATNR IS INITIAL.
    CLEAR GV_PNAME1.
    CLEAR GV_SNAME.
    CLEAR GV_MAKTX.
    CLEAR GV_CALQTY.
    CLEAR GV_MEINS.
  ENDIF.

  PERFORM PIC_URL.
  PERFORM REFRESH_PIC.

  GO_ALV_GRID->REFRESH_TABLE_DISPLAY(
EXCEPTIONS
  FINISHED       = 1                " Display was Ended (by Export)
  OTHERS         = 2
).
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
      WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.







*
*    IF GO_ALV_GRID IS INITIAL.
*    MESSAGE S000 DISPLAY LIKE 'E' WITH TEXT-E01.
*    EXIT.
*  ENDIF.
*
*
*  READ TABLE GT_NODE_INFO_2 INTO GS_NODE_INFO_2
*                          WITH KEY NODE_KEY = PV_NODE_KEY
*                                   BINARY SEARCH.
*
*  CHECK SY-SUBRC EQ 0.
*
*
*
*
*  IF GS_NODE_INFO_2-WERKS IS NOT INITIAL.
*    R_WERKS = 'I'.
*    R_WERKS-OPTION = 'EQ'.
*    R_WERKS-LOW = GS_NODE_INFO_2-WERKS.
*    APPEND R_WERKS.
*  ENDIF.
*
*  IF GS_NODE_INFO_2-SCODE IS NOT INITIAL.
*    R_SCODE = 'I'.
*    R_SCODE-OPTION = 'EQ'.
*    R_SCODE-LOW = GS_NODE_INFO_2-SCODE.
*    APPEND R_SCODE.
*  ENDIF.
*
*
*  SELECT FROM ZEA_MMT190 AS A
*    LEFT JOIN ZEA_T001W AS B
*      ON A~WERKS EQ B~WERKS
*    JOIN ZEA_MMT060 AS C
*      ON C~WERKS EQ A~WERKS
*    FIELDS *
*    WHERE A~WERKS IN @R_WERKS
*      AND C~SCODE IN @R_SCODE
*    INTO CORRESPONDING FIELDS OF TABLE @GT_DISPLAY.
*
**  SELECT FROM ZEA_MMT190 AS A
**    LEFT JOIN ZEA_T001W AS B
**      ON A~WERKS EQ B~WERKS
**    JOIN ZEA_MMT060 AS C
**      ON C~WERKS EQ A~WERKS
**    FIELDS A~WERKS, B~PNAME1, C~SCODE, C~STYPE
**    INTO CORRESPONDING FIELDS OF TABLE @GT_HEADER_2.
*
*
*  SORT GT_DISPLAY BY WERKS.
*
*  CLEAR GS_DISPLAY.
*  READ TABLE GT_DISPLAY INTO GS_DISPLAY INDEX 1.
*
*
*  GO_ALV_GRID->REFRESH_TABLE_DISPLAY(
*EXCEPTIONS
*  FINISHED       = 1                " Display was Ended (by Export)
*  OTHERS         = 2
*).
*  IF SY-SUBRC <> 0.
*    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*      WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  ENDIF.




ENDFORM.
*&---------------------------------------------------------------------*
*& Form EXPAND_ROOT_NODE_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
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
  GS_LAYOUT-SEL_MODE = 'B'.

  GS_LAYOUT-NO_ROWINS = ABAP_ON.
  GS_LAYOUT-NO_ROWMOVE = ABAP_ON.

  GS_LAYOUT-CTAB_FNAME = 'CELL_COLOR'.
  GS_LAYOUT-INFO_FNAME = 'ROWCOLOR'.
  GS_LAYOUT-STYLEFNAME = 'STYLE'.
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

  PERFORM GET_FIELDCAT_0100   USING    GT_DISPLAY
                              CHANGING GT_FIELDCAT.

  PERFORM MAKE_FIELDCAT_0100.

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
*& Form MAKE_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM MAKE_FIELDCAT_0100 .

  LOOP AT GT_FIELDCAT INTO GS_FIELDCAT.

    CASE GS_FIELDCAT-FIELDNAME.

      WHEN 'STATUS'.
        GS_FIELDCAT-COLTEXT = '안전재고'.
        GS_FIELDCAT-JUST = 'C'.

      WHEN 'MATNR' OR 'WERKS'.
*        GS_FIELDCAT-HOTSPOT = ABAP_ON.
        GS_FIELDCAT-KEY = ABAP_ON.
        GS_FIELDCAT-JUST = 'C'.

      WHEN 'CALQTY'.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.

      WHEN 'WEIGHT'.
        GS_FIELDCAT-CFIELDNAME = 'MEINS2'.

      WHEN 'SAFSTK'.
        GS_FIELDCAT-NO_OUT = ABAP_ON.
      WHEN 'MEINS3'.
        GS_FIELDCAT-NO_OUT = ABAP_ON.

      WHEN   'SCODE' OR 'PNAME1'.
        GS_FIELDCAT-JUST = 'C'.
      WHEN 'SAFSTK'.
        GS_FIELDCAT-NO_OUT = 'X'.

      WHEN OTHERS.

    ENDCASE.
    MODIFY GT_FIELDCAT FROM GS_FIELDCAT.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_EVENT_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_ALV_EVENT_0100 .
*  SET HANDLER LCL_EVENT_HANDLER=>ON_HOTSPOT_CLICK FOR GO_ALV_GRID.
  SET HANDLER LCL_EVENT_HANDLER=>ON_DOUBLE_CLICK FOR GO_ALV_GRID.
  SET HANDLER LCL_EVENT_HANDLER=>ON_TOOLBAR FOR GO_ALV_GRID.
  SET HANDLER LCL_EVENT_HANDLER=>ON_USER_COMMAND  FOR GO_ALV_GRID.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV_0100 .

  CLEAR GS_VARIANT.
  GS_VARIANT-REPORT = SY-REPID.
  GS_VARIANT-HANDLE = '0001'. " 프로그램 내 ALV 구별자

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
*& Form CREATE_NODE_0100_2
*&---------------------------------------------------------------------*
FORM CREATE_NODE_0100_2 .

  "NODE를 아래와 같이 구성
  " 회사코드
  " ㄴ 플랜트/직영점
  "    ㄴ 플랜트 직영점 줄줄



*          SELECT FROM ZEA_MMT190 AS A
*    JOIN ZEA_T001W AS B
*      ON B~WERKS EQ A~WERKS
*    JOIN ZEA_MMT060 AS C
*      ON C~WERKS EQ A~WERKS
*  FIELDS A~WERKS, B~PNAME1, C~SCODE, C~STYPE
*         INTO CORRESPONDING FIELDS OF TABLE @GT_HEADER_2.

  GT_HEADER_2[] = CORRESPONDING #( GT_HEADER ).
  DELETE GT_HEADER_2 WHERE PNAME1 IS INITIAL.

  SORT GT_HEADER_2 BY WERKS.

  DATA LV_NODE_KEY_SUPER  TYPE N LENGTH 6.
  DATA LT_NODE_KEY_LEVEL  LIKE TABLE OF GV_NODE_KEY.

  GV_NODE_KEY += 1.
  CLEAR GS_NODE.
  GS_NODE-RELATKEY = SPACE. " 가장 최상위의 노드는 항상 공백이여야 한다.
  GS_NODE-NODE_KEY = LV_NODE_KEY_SUPER = GV_NODE_KEY.
  GS_NODE-ISFOLDER = ABAP_ON.
  GS_NODE-TEXT     = '플랜트&직영점'.
  GS_NODE-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
  APPEND GS_NODE TO GT_NODE.

  " 1레벨 생성
  INSERT LV_NODE_KEY_SUPER INTO LT_NODE_KEY_LEVEL INDEX 1.

  CLEAR GS_NODE_INFO.
  GS_NODE_INFO-WERKS = SPACE.
  GS_NODE_INFO-SCODE = SPACE.
  GS_NODE_INFO-NODE_KEY = GV_NODE_KEY.
  APPEND GS_NODE_INFO_2 TO GT_NODE_INFO_2.

  LOOP AT GT_HEADER_2 INTO GS_HEADER_2.
    AT NEW PNAME1.

      GV_NODE_KEY += 1.
      CLEAR GS_NODE.
      GS_NODE-RELATKEY = LV_NODE_KEY_SUPER.
      GS_NODE-NODE_KEY = LV_NODE_KEY_SUPER = GV_NODE_KEY.
      GS_NODE-ISFOLDER = ABAP_ON.
      GS_NODE-TEXT     = |{ GS_HEADER_2-WERKS } - { GS_HEADER_2-PNAME1 }|.
      GS_NODE-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
      APPEND GS_NODE TO GT_NODE.

      INSERT LV_NODE_KEY_SUPER INTO LT_NODE_KEY_LEVEL INDEX 1.


      CLEAR GS_NODE_INFO.
      GS_NODE_INFO_2-WERKS = GS_HEADER_2-WERKS.
      GS_NODE_INFO_2-SCODE = SPACE."LS_HEADER-SCODE.
      GS_NODE_INFO_2-NODE_KEY = GV_NODE_KEY.
      APPEND GS_NODE_INFO_2 TO GT_NODE_INFO.

    ENDAT.

*    AT NEW STYPE.
*      GV_NODE_KEY += 1.
*      CLEAR GS_NODE.
*      " 2레벨 노드를 상위노드로 지정
*      GS_NODE-RELATKEY = LV_NODE_KEY_SUPER.
*      GS_NODE-NODE_KEY = LV_NODE_KEY_SUPER = GV_NODE_KEY.
*      GS_NODE-ISFOLDER = ABAP_ON.
*      GS_NODE-TEXT     = |{ LS_HEADER-SCODE }-{ LS_HEADER-STYPE }|.
*      GS_NODE-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
*      APPEND GS_NODE TO GT_NODE.
*
*      CLEAR GS_NODE_INFO.
*      GS_NODE_INFO-WERKS = LS_HEADER-WERKS.
*      GS_NODE_INFO-SCODE = SPACE."LS_HEADER-SCODE.
*      GS_NODE_INFO-NODE_KEY = GV_NODE_KEY.
*      APPEND GS_NODE_INFO TO GT_NODE_INFO.
*    ENDAT.
    AT NEW STYPE.
      IF GS_HEADER_2-SCODE IS NOT INITIAL.
        GV_NODE_KEY += 1.
        CLEAR GS_NODE.
        " 2레벨 노드를 상위노드로 지정
        GS_NODE-RELATKEY = LV_NODE_KEY_SUPER.
        GS_NODE-NODE_KEY = GV_NODE_KEY.
        GS_NODE-ISFOLDER = ABAP_OFF.
        GS_NODE-N_IMAGE  = ICON_TRANSPORT_POINT.
        GS_NODE-TEXT     = |{ GS_HEADER_2-SCODE }-{ GS_HEADER_2-STYPE }|.
        GS_NODE-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
        APPEND GS_NODE TO GT_NODE.

        CLEAR GS_NODE_INFO.
        GS_NODE_INFO_2-WERKS = GS_HEADER_2-WERKS.
        GS_NODE_INFO_2-SCODE = GS_HEADER_2-SCODE.
        GS_NODE_INFO_2-NODE_KEY = GV_NODE_KEY.
        APPEND GS_NODE_INFO_2 TO GT_NODE_INFO.

      ENDIF.
    ENDAT.

    AT END OF PNAME1.
      " 2레벨 제거 및 1레벨의 상위노드 정보 조회
      DELETE LT_NODE_KEY_LEVEL INDEX 1.
      READ TABLE LT_NODE_KEY_LEVEL INTO LV_NODE_KEY_SUPER INDEX 1.

    ENDAT.



  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT2_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
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
*& Form SET_DOCUMENT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GCL_DOCUMENT
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
         LCL_COL14 TYPE REF TO CL_DD_AREA.

  DATA : LV_TEXT TYPE SDYDO_TEXT_ELEMENT.

  PCL_DOCUMENT->INITIALIZE_DOCUMENT(
*    EXPORTING
*      FIRST_TIME       =                  " Internal Use
*      STYLE            =                  " Adjusting to the Style of a Particular GUI Environment
*      BACKGROUND_COLOR =                  " Color ID
*      BDS_STYLESHEET   =                  " Stylesheet Stored in BDS
*      NO_MARGINS       =                  " Document Generated Without Free Margins
  ).


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
      NO_OF_COLUMNS               = 4
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
      WIDTH  = '250'
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
      WIDTH  = '250'
    IMPORTING
      COLUMN = LCL_COL6.

  CALL METHOD LCL_TABLE->ADD_COLUMN
    EXPORTING
      WIDTH  = '5'
    IMPORTING
      COLUMN = LCL_COL7.
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
*--------------------------------------------------------------------*
  CALL METHOD LCL_TABLE->NEW_ROW.

  CALL METHOD LCL_COL1->ADD_ICON
    EXPORTING
      SAP_ICON = 'ICON_MATERIAL'.

  LV_TEXT = '자재명 :'.
  CALL METHOD LCL_COL2->ADD_TEXT
    EXPORTING
      TEXT         = LV_TEXT
      SAP_EMPHASIS = CL_DD_AREA=>STRONG
      SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND.

  LV_TEXT = GV_MAKTX.
  CALL METHOD LCL_COL3->ADD_TEXT
    EXPORTING
      TEXT         = LV_TEXT
      SAP_EMPHASIS = CL_DD_AREA=>STRONG
      SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND.

  CALL METHOD LCL_COL4->ADD_ICON
    EXPORTING
      SAP_ICON = 'ICON_STOCK'.

  LV_TEXT = '재고량 :'.
  CALL METHOD LCL_COL5->ADD_TEXT
    EXPORTING
      TEXT         = LV_TEXT
      SAP_EMPHASIS = CL_DD_AREA=>STRONG
      SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND.

  LV_TEXT = GV_CALQTY.
  CALL METHOD LCL_COL6->ADD_TEXT
    EXPORTING
      TEXT         = LV_TEXT
      SAP_EMPHASIS = CL_DD_AREA=>STRONG
      SAP_COLOR    = CL_DD_AREA=>LIST_GROUP_INT.

  LV_TEXT = GV_MEINS.
  CALL METHOD LCL_COL7->ADD_TEXT
    EXPORTING
      TEXT         = LV_TEXT
      SAP_EMPHASIS = CL_DD_AREA=>STRONG
      SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND.




*--------------------------------------------------------------------*
  CALL METHOD LCL_TABLE->NEW_ROW.
  CALL METHOD LCL_TABLE->NEW_ROW.

  CALL METHOD PCL_DOCUMENT->ADD_TEXT
    EXPORTING
      TEXT         = '안전재고 기준_(110%)'
      SAP_FONTSIZE = CL_DD_DOCUMENT=>LARGE
      SAP_EMPHASIS = CL_DD_AREA=>STRONG
      SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INV.

  CALL METHOD PCL_DOCUMENT->ADD_TABLE
    EXPORTING
      NO_OF_COLUMNS               = 4
      CELL_BACKGROUND_TRANSPARENT = 'X'
      WITH_HEADING                = SPACE
      BORDER                      = '0'
    IMPORTING
      TABLE                       = LCL_TABLE.

  CALL METHOD LCL_TABLE->ADD_COLUMN
    EXPORTING
      WIDTH  = '10'
    IMPORTING
      COLUMN = LCL_COL8.

  CALL METHOD LCL_TABLE->ADD_COLUMN
    EXPORTING
      WIDTH  = '50'
    IMPORTING
      COLUMN = LCL_COL9.



  CALL METHOD LCL_TABLE->ADD_COLUMN
    EXPORTING
      WIDTH  = '10'
    IMPORTING
      COLUMN = LCL_COL10.

  CALL METHOD LCL_TABLE->ADD_COLUMN
    EXPORTING
      WIDTH  = '50'
    IMPORTING
      COLUMN = LCL_COL11.

  CALL METHOD LCL_TABLE->ADD_COLUMN
    EXPORTING
      WIDTH  = '10'
    IMPORTING
      COLUMN = LCL_COL12.

  CALL METHOD LCL_TABLE->ADD_COLUMN
    EXPORTING
      WIDTH  = '50'
    IMPORTING
      COLUMN = LCL_COL13.

  CALL METHOD LCL_TABLE->ADD_COLUMN
    EXPORTING
      WIDTH  = '50'
    IMPORTING
      COLUMN = LCL_COL14.



  CALL METHOD LCL_COL8->ADD_ICON
    EXPORTING
      SAP_ICON = 'ICON_LED_GREEN'.

  LV_TEXT = '안전재고 양호 -> 150% 초과'.
  CALL METHOD LCL_COL9->ADD_TEXT
    EXPORTING
      TEXT         = LV_TEXT
      SAP_EMPHASIS = CL_DD_AREA=>STRONG
      SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND.

  CALL METHOD LCL_TABLE->NEW_ROW.

  CALL METHOD LCL_COL8->ADD_ICON
    EXPORTING
      SAP_ICON = 'ICON_LED_YELLOW'.

  LV_TEXT = '안전재고 체크 요망 -> 110~150% 사이'.
  CALL METHOD LCL_COL9->ADD_TEXT
    EXPORTING
      TEXT         = LV_TEXT
      SAP_EMPHASIS = CL_DD_AREA=>STRONG
      SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND.

  CALL METHOD LCL_TABLE->NEW_ROW.
  CALL METHOD LCL_COL8->ADD_ICON
    EXPORTING
      SAP_ICON = 'ICON_LED_RED'.

  LV_TEXT = '안전재고 부족 -> 110%미만'.
  CALL METHOD LCL_COL9->ADD_TEXT
    EXPORTING
      TEXT         = LV_TEXT
      SAP_EMPHASIS = CL_DD_AREA=>STRONG
      SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND.

  CALL METHOD LCL_TABLE->NEW_ROW.
  CALL METHOD LCL_COL8->ADD_ICON
    EXPORTING
      SAP_ICON = 'ICON_CANCEL'.

  LV_TEXT = '안전재고 오류'.
  CALL METHOD LCL_COL9->ADD_TEXT
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
*& Form MAKE_DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM MAKE_DISPLAY_DATA .

*  REFRESH GT_DISPLAY.
*
*  LOOP AT GT_DATA INTO GS_DATA.
*
*    CLEAR GS_DISPLAY.
*
*    MOVE-CORRESPONDING GS_DATA TO GS_DISPLAY.
*
**신규 필드------------------------------------------------------------*
*
*    IF GS_DISPLAY-MATNR = '20000003'.
*
*      GS_DISPLAY-STATUS = ICON_LED_YELLOW. " LED 등
*
**    ELSEIF GS_DISPLAY-MATTYPE = '반제품'.
**
**      GS_DISPLAY-STATUS = ICON_LED_GREEN. " LED 등
**
**    ELSEIF GS_DISPLAY-MATTYPE = '완제품'.
**      GS_DISPLAY-STATUS = ICON_BUSINAV_PROC_EXIST. " LED 등
*    ENDIF.
*
*
*
**--------------------------------------------------------------------*
*    APPEND GS_DISPLAY TO GT_DISPLAY.
*
*  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GS_DISPLAY_1
*&---------------------------------------------------------------------*
FORM GS_DISPLAY_1 .
*  IF GS_DISPLAY-MAKTX = '천연 고무'.

  CLEAR : GT_WWWTAB.
  SELECT SINGLE *
    INTO GT_WWWTAB
    FROM WWWPARAMS
   WHERE RELID  =  'MI'
     AND OBJID  =  'ZTIRE_1'.


  CALL METHOD PIC1->SET_DISPLAY_MODE
    EXPORTING
      DISPLAY_MODE = CL_GUI_PICTURE=>DISPLAY_MODE_STRETCH.

*    CALL FUNCTION 'DP_PUBLISH_WWW_URL'
*      EXPORTING
*        OBJID    = GT_WWWTAB-OBJID
*        LIFETIME = 'T'
*      IMPORTING
*        URL      = URL
*      EXCEPTIONS
*        OTHERS   = 1.
*
*
*    IF SY-SUBRC = 0.
*      CALL METHOD PIC1->LOAD_PICTURE_FROM_URL_ASYNC
*        EXPORTING
*          URL = URL.
*    ENDIF.
*  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form GS_DISPLAY_2
*&---------------------------------------------------------------------*
FORM GS_DISPLAY_2 .
*  IF GS_DISPLAY-MAKTX = '합성 고무'.

  CLEAR : GT_WWWTAB.
  SELECT SINGLE *
    INTO GT_WWWTAB
    FROM WWWPARAMS
   WHERE RELID  =  'MI'
     AND OBJID  =  'ZTIRE_2'.



  CALL METHOD PIC1->SET_DISPLAY_MODE
    EXPORTING
      DISPLAY_MODE = CL_GUI_PICTURE=>DISPLAY_MODE_STRETCH.

*    CALL FUNCTION 'DP_PUBLISH_WWW_URL'
*      EXPORTING
*        OBJID    = GT_WWWTAB-OBJID
*        LIFETIME = 'T'
*      IMPORTING
*        URL      = URL
*      EXCEPTIONS
*        OTHERS   = 1.
*
*
*    IF SY-SUBRC = 0.
*      CALL METHOD PIC1->LOAD_PICTURE_FROM_URL_ASYNC
*        EXPORTING
*          URL = URL.
*    ENDIF.
*  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_PIC1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT_PIC1 .
  CREATE OBJECT CONTAINER3
    EXPORTING
      CONTAINER_NAME = 'CCON3'.


  CREATE OBJECT PIC1
    EXPORTING
      PARENT = CONTAINER3.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH_PIC
*&---------------------------------------------------------------------*
FORM REFRESH_PIC .
*  CLEAR URL.
  CALL FUNCTION 'DP_PUBLISH_WWW_URL'
    EXPORTING
      OBJID    = GT_WWWTAB-OBJID
      LIFETIME = 'T'
    IMPORTING
      URL      = URL
    EXCEPTIONS
      OTHERS   = 1.

  IF SY-SUBRC = 0.
    CALL METHOD PIC1->LOAD_PICTURE_FROM_URL_ASYNC
      EXPORTING
        URL = URL.
*  ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form PIC_URL
*&---------------------------------------------------------------------*
FORM PIC_URL .
  IF GS_DISPLAY-MAKTX = '천연 고무'.
    PERFORM GS_DISPLAY_1.
  ELSEIF GS_DISPLAY-MAKTX = '합성 고무'.
    PERFORM GS_DISPLAY_2.
  ELSEIF GS_DISPLAY-MAKTX = '친환경 섬유'.
    PERFORM GS_DISPLAY_3.
  ELSEIF GS_DISPLAY-MAKTX = '카본 블랙'.
    PERFORM GS_DISPLAY_4.
  ELSEIF GS_DISPLAY-MAKTX = '실리카'.
    PERFORM GS_DISPLAY_5.
  ELSEIF GS_DISPLAY-MAKTX = '노화 방지제'.
    PERFORM GS_DISPLAY_6.
  ELSEIF GS_DISPLAY-MAKTX = '가류제'.
    PERFORM GS_DISPLAY_7.
  ELSEIF GS_DISPLAY-MAKTX = '스틸 와이어'.
    PERFORM GS_DISPLAY_8.
  ELSEIF GS_DISPLAY-MAKTX = '유황'.
    PERFORM GS_DISPLAY_10.
  ELSEIF GS_DISPLAY-MAKTX = '스테아르산'.
    PERFORM GS_DISPLAY_11.
  ELSEIF GS_DISPLAY-MAKTX = '패브릭 코드'.
    PERFORM GS_DISPLAY_12.
  ELSEIF GS_DISPLAY-MAKTX = '스틸코드'.
    PERFORM GS_DISPLAY_13.
  ELSEIF GS_DISPLAY-MAKTX = '컴파운드'.
    PERFORM GS_DISPLAY_14.
  ELSEIF GS_DISPLAY-MAKTX = '트레드'
    OR GS_DISPLAY-MAKTX = '벨트'
    OR GS_DISPLAY-MAKTX = '사이드윌'
    OR GS_DISPLAY-MAKTX ='카카스'
    OR GS_DISPLAY-MAKTX = '비드'.
    PERFORM GS_DISPLAY_15.
  ELSEIF GS_DISPLAY-MAKTX = '가솔린(사계절 타이어) 18인치'
    OR GS_DISPLAY-MAKTX = '가솔린(사계절 타이어) 19인치'
    OR GS_DISPLAY-MAKTX = '가솔린(사계절 타이어) 20인치'.
    PERFORM GS_DISPLAY_20.
  ELSEIF GS_DISPLAY-MAKTX = '전기차(사계절 타이어) 18인치'
     OR GS_DISPLAY-MAKTX = '전기차(사계절 타이어) 19인치'
     OR GS_DISPLAY-MAKTX = '가솔린(사계절 타이어) 20인치'.
    PERFORM GS_DISPLAY_21.
  ELSEIF GS_DISPLAY-MAKTX = '가솔린(윈터 타이어) 18인치'
     OR GS_DISPLAY-MAKTX = '가솔린(윈터 타이어) 19인치'
     OR GS_DISPLAY-MAKTX = '가솔린(윈터 타이어) 20인치'
     OR GS_DISPLAY-MAKTX = '전기차(사계절 타이어) 18인치'
     OR GS_DISPLAY-MAKTX = '전기차(사계절 타이어) 19인치'
     OR GS_DISPLAY-MAKTX = '전기차(사계절 타이어) 20인치'.
    PERFORM GS_DISPLAY_22.
  ELSEIF GS_DISPLAY-MAKTX = '가솔린(사계절 타이어) 19인치 프리미엄'
     OR GS_DISPLAY-MAKTX = '가솔린(사계절 타이어) 20인치 프리미엄'
     OR GS_DISPLAY-MAKTX = '가솔린(사계절 타이어) 21인치 프리미엄'.
    PERFORM GS_DISPLAY_23.
  ELSEIF GS_DISPLAY-MAKTX = '전기차(사계절 타이어) 18인치 프리미엄'
 OR GS_DISPLAY-MAKTX = '전기차(사계절 타이어) 19인치 프리미엄'
 OR GS_DISPLAY-MAKTX = '전기차(사계절 타이어) 20인치 프리미엄'.
    PERFORM GS_DISPLAY_24.
  ELSEIF GS_DISPLAY-MAKTX = '가솔린(윈터 타이어) 19인치 프리미엄'
    OR GS_DISPLAY-MAKTX = '가솔린(윈터 타이어) 20인치 프리미엄'
     OR GS_DISPLAY-MAKTX = '가솔린(윈터 타이어) 21인치 프리미엄'.
    PERFORM GS_DISPLAY_25.
  ELSEIF GS_DISPLAY-MAKTX = '전기차(윈터 타이어) 19인치 프리미엄'
 OR GS_DISPLAY-MAKTX = '전기차(윈터 타이어) 20인치 프리미엄'
 OR GS_DISPLAY-MAKTX = '전기차(윈터 타이어) 21인치 프리미엄'.
    PERFORM GS_DISPLAY_26.
  ELSEIF GS_DISPLAY-MAKTX = '가솔린용 그린 타이어'
 OR GS_DISPLAY-MAKTX = '전기차용 그린 타이어'.
    PERFORM GS_DISPLAY_27.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GS_DISPLAY_3
*&---------------------------------------------------------------------*
FORM GS_DISPLAY_3 .
  CLEAR : GT_WWWTAB.
  SELECT SINGLE *
    INTO GT_WWWTAB
    FROM WWWPARAMS
   WHERE RELID  =  'MI'
     AND OBJID  =  'ZTIRE_3'.

  CALL METHOD PIC1->SET_DISPLAY_MODE
    EXPORTING
      DISPLAY_MODE = CL_GUI_PICTURE=>DISPLAY_MODE_STRETCH.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GS_DISPLAY_4
*&---------------------------------------------------------------------*
FORM GS_DISPLAY_4 .
  CLEAR : GT_WWWTAB.
  SELECT SINGLE *
    INTO GT_WWWTAB
    FROM WWWPARAMS
   WHERE RELID  =  'MI'
     AND OBJID  =  'ZTIRE_4'.

  CALL METHOD PIC1->SET_DISPLAY_MODE
    EXPORTING
      DISPLAY_MODE = CL_GUI_PICTURE=>DISPLAY_MODE_STRETCH.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GS_DISPLAY_5
*&---------------------------------------------------------------------*
FORM GS_DISPLAY_5 .
  CLEAR : GT_WWWTAB.
  SELECT SINGLE *
    INTO GT_WWWTAB
    FROM WWWPARAMS
   WHERE RELID  =  'MI'
     AND OBJID  =  'ZTIRE_5'.

  CALL METHOD PIC1->SET_DISPLAY_MODE
    EXPORTING
      DISPLAY_MODE = CL_GUI_PICTURE=>DISPLAY_MODE_STRETCH.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GS_DISPLAY_6
*&---------------------------------------------------------------------*
FORM GS_DISPLAY_6 .
  CLEAR : GT_WWWTAB.
  SELECT SINGLE *
    INTO GT_WWWTAB
    FROM WWWPARAMS
   WHERE RELID  =  'MI'
     AND OBJID  =  'ZTIRE_6'.

  CALL METHOD PIC1->SET_DISPLAY_MODE
    EXPORTING
      DISPLAY_MODE = CL_GUI_PICTURE=>DISPLAY_MODE_STRETCH.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GS_DISPLAY_7
*&---------------------------------------------------------------------*
FORM GS_DISPLAY_7 .
  CLEAR : GT_WWWTAB.
  SELECT SINGLE *
    INTO GT_WWWTAB
    FROM WWWPARAMS
   WHERE RELID  =  'MI'
     AND OBJID  =  'ZTIRE_7'.

  CALL METHOD PIC1->SET_DISPLAY_MODE
    EXPORTING
      DISPLAY_MODE = CL_GUI_PICTURE=>DISPLAY_MODE_STRETCH.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GS_DISPLAY_8
*&---------------------------------------------------------------------*
FORM GS_DISPLAY_8 .
  CLEAR : GT_WWWTAB.
  SELECT SINGLE *
    INTO GT_WWWTAB
    FROM WWWPARAMS
   WHERE RELID  =  'MI'
     AND OBJID  =  'ZTIRE_8'.

  CALL METHOD PIC1->SET_DISPLAY_MODE
    EXPORTING
      DISPLAY_MODE = CL_GUI_PICTURE=>DISPLAY_MODE_STRETCH.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GS_DISPLAY_10
*&---------------------------------------------------------------------*
FORM GS_DISPLAY_10 .
  CLEAR : GT_WWWTAB.
  SELECT SINGLE *
    INTO GT_WWWTAB
    FROM WWWPARAMS
   WHERE RELID  =  'MI'
     AND OBJID  =  'ZTIRE_10'.

  CALL METHOD PIC1->SET_DISPLAY_MODE
    EXPORTING
      DISPLAY_MODE = CL_GUI_PICTURE=>DISPLAY_MODE_STRETCH.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GS_DISPLAY_11
*&---------------------------------------------------------------------*
FORM GS_DISPLAY_11 .
  CLEAR : GT_WWWTAB.
  SELECT SINGLE *
    INTO GT_WWWTAB
    FROM WWWPARAMS
   WHERE RELID  =  'MI'
     AND OBJID  =  'ZTIRE_11'.

  CALL METHOD PIC1->SET_DISPLAY_MODE
    EXPORTING
      DISPLAY_MODE = CL_GUI_PICTURE=>DISPLAY_MODE_STRETCH.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GS_DISPLAY_12
*&---------------------------------------------------------------------*
FORM GS_DISPLAY_12 .
  CLEAR : GT_WWWTAB.
  SELECT SINGLE *
    INTO GT_WWWTAB
    FROM WWWPARAMS
   WHERE RELID  =  'MI'
     AND OBJID  =  'ZTIRE_12'.

  CALL METHOD PIC1->SET_DISPLAY_MODE
    EXPORTING
      DISPLAY_MODE = CL_GUI_PICTURE=>DISPLAY_MODE_STRETCH.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GS_DISPLAY_13
*&---------------------------------------------------------------------*
FORM GS_DISPLAY_13 .
  CLEAR : GT_WWWTAB.
  SELECT SINGLE *
    INTO GT_WWWTAB
    FROM WWWPARAMS
   WHERE RELID  =  'MI'
     AND OBJID  =  'ZTIRE_13'.

  CALL METHOD PIC1->SET_DISPLAY_MODE
    EXPORTING
      DISPLAY_MODE = CL_GUI_PICTURE=>DISPLAY_MODE_STRETCH.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GS_DISPLAY_14
*&---------------------------------------------------------------------*
FORM GS_DISPLAY_14 .
  CLEAR : GT_WWWTAB.
  SELECT SINGLE *
    INTO GT_WWWTAB
    FROM WWWPARAMS
   WHERE RELID  =  'MI'
     AND OBJID  =  'ZTIRE_9'.

  CALL METHOD PIC1->SET_DISPLAY_MODE
    EXPORTING
      DISPLAY_MODE = CL_GUI_PICTURE=>DISPLAY_MODE_STRETCH.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GS_DISPLAY_15
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM GS_DISPLAY_15 .
  CLEAR : GT_WWWTAB.
  SELECT SINGLE *
    INTO GT_WWWTAB
    FROM WWWPARAMS
   WHERE RELID  =  'MI'
     AND OBJID  =  'ZTIRE_15'.

  CALL METHOD PIC1->SET_DISPLAY_MODE
    EXPORTING
      DISPLAY_MODE = CL_GUI_PICTURE=>DISPLAY_MODE_STRETCH.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GS_DISPLAY_20
*&---------------------------------------------------------------------*
FORM GS_DISPLAY_20 .
  CLEAR : GT_WWWTAB.
  SELECT SINGLE *
    INTO GT_WWWTAB
    FROM WWWPARAMS
   WHERE RELID  =  'MI'
     AND OBJID  =  'ZTIRE_20'.

  CALL METHOD PIC1->SET_DISPLAY_MODE
    EXPORTING
      DISPLAY_MODE = CL_GUI_PICTURE=>DISPLAY_MODE_STRETCH.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GS_DISPLAY_21
*&---------------------------------------------------------------------*
FORM GS_DISPLAY_21 .
  CLEAR : GT_WWWTAB.
  SELECT SINGLE *
    INTO GT_WWWTAB
    FROM WWWPARAMS
   WHERE RELID  =  'MI'
     AND OBJID  =  'ZTIRE_21'.

  CALL METHOD PIC1->SET_DISPLAY_MODE
    EXPORTING
      DISPLAY_MODE = CL_GUI_PICTURE=>DISPLAY_MODE_STRETCH.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GS_DISPLAY_22
*&---------------------------------------------------------------------*
FORM GS_DISPLAY_22 .
  CLEAR : GT_WWWTAB.
  SELECT SINGLE *
    INTO GT_WWWTAB
    FROM WWWPARAMS
   WHERE RELID  =  'MI'
     AND OBJID  =  'ZTIRE_22'.

  CALL METHOD PIC1->SET_DISPLAY_MODE
    EXPORTING
      DISPLAY_MODE = CL_GUI_PICTURE=>DISPLAY_MODE_STRETCH.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GS_DISPLAY_23
*&---------------------------------------------------------------------*
FORM GS_DISPLAY_23 .
  CLEAR : GT_WWWTAB.
  SELECT SINGLE *
    INTO GT_WWWTAB
    FROM WWWPARAMS
   WHERE RELID  =  'MI'
     AND OBJID  =  'ZTIRE_23'.

  CALL METHOD PIC1->SET_DISPLAY_MODE
    EXPORTING
      DISPLAY_MODE = CL_GUI_PICTURE=>DISPLAY_MODE_STRETCH.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GS_DISPLAY_24
*&---------------------------------------------------------------------*
FORM GS_DISPLAY_24 .
  CLEAR : GT_WWWTAB.
  SELECT SINGLE *
    INTO GT_WWWTAB
    FROM WWWPARAMS
   WHERE RELID  =  'MI'
     AND OBJID  =  'ZTIRE_24'.

  CALL METHOD PIC1->SET_DISPLAY_MODE
    EXPORTING
      DISPLAY_MODE = CL_GUI_PICTURE=>DISPLAY_MODE_STRETCH.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GS_DISPLAY_25
*&---------------------------------------------------------------------*
FORM GS_DISPLAY_25 .
  CLEAR : GT_WWWTAB.
  SELECT SINGLE *
    INTO GT_WWWTAB
    FROM WWWPARAMS
   WHERE RELID  =  'MI'
     AND OBJID  =  'ZTIRE_25'.

  CALL METHOD PIC1->SET_DISPLAY_MODE
    EXPORTING
      DISPLAY_MODE = CL_GUI_PICTURE=>DISPLAY_MODE_STRETCH.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GS_DISPLAY_26
*&---------------------------------------------------------------------*
FORM GS_DISPLAY_26 .
  CLEAR : GT_WWWTAB.
  SELECT SINGLE *
    INTO GT_WWWTAB
    FROM WWWPARAMS
   WHERE RELID  =  'MI'
     AND OBJID  =  'ZTIRE_26'.

  CALL METHOD PIC1->SET_DISPLAY_MODE
    EXPORTING
      DISPLAY_MODE = CL_GUI_PICTURE=>DISPLAY_MODE_STRETCH.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GS_DISPLAY_27
*&---------------------------------------------------------------------*
FORM GS_DISPLAY_27 .
  CLEAR : GT_WWWTAB.
  SELECT SINGLE *
    INTO GT_WWWTAB
    FROM WWWPARAMS
   WHERE RELID  =  'MI'
     AND OBJID  =  'ZTIRE_27'.

  CALL METHOD PIC1->SET_DISPLAY_MODE
    EXPORTING
      DISPLAY_MODE = CL_GUI_PICTURE=>DISPLAY_MODE_STRETCH.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLER_TOOLBAR
*&---------------------------------------------------------------------*
FORM HANDLER_TOOLBAR
  USING PO_OBJECT TYPE REF TO CL_ALV_EVENT_TOOLBAR_SET
        PO_SENDER TYPE REF TO CL_GUI_ALV_GRID.

  DATA LS_TOOLBAR LIKE LINE OF PO_OBJECT->MT_TOOLBAR.

  DATA: LV_DANGER TYPE I.

  CASE PO_SENDER.
    WHEN GO_ALV_GRID.
* 구분자 =>> |
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 3. " 구분자
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

      LOOP AT  GT_DISPLAY INTO GS_DISPLAY.

*        CASE GS_DISPLAY-STATUS.
*          WHEN LED_ICON_RED.
*            ADD 1 TO LV_DANGER.
*        ENDCASE.
      ENDLOOP.

*      CLEAR LS_TOOLBAR.
**      LS_TOOLBAR-BUTN_TYPE = 0.
*      LS_TOOLBAR-FUNCTION = GC_DANGER.
*      LS_TOOLBAR-TEXT = TEXT-L01.
*      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

      CLEAR LS_TOOLBAR.
*      LS_TOOLBAR-BUTN_TYPE = 0.
      LS_TOOLBAR-FUNCTION = 'GO'.
      LS_TOOLBAR-TEXT = |부족 원자재오더 / 오더|."TEXT-L02.
*      ls_TOOLBAR-ICON = .
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.
  ENDCASE.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_USER_COMMAND
*&---------------------------------------------------------------------*
FORM HANDLE_USER_COMMAND  USING PV_UCOMM TYPE SY-UCOMM
                                PO_SENDER  TYPE REF TO CL_GUI_ALV_GRID.

  CASE PV_UCOMM.
    WHEN PV_UCOMM.
*      CASE GC_DANGER.
*        WHEN GC_DANGER.
*          CALL SCREEN 0110 STARTING AT 50 5.
      CASE 'GO'.
    WHEN 'GO'.
      SUBMIT ZEA_MM070 AND RETURN.
      ENDCASE.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_CCON110_DATA
*&---------------------------------------------------------------------*
FORM SELECT_CCON110_DATA .




  RANGES: R_BUKRS   FOR GS_NODE_INFO-BUKRS,
           R_MATTYPE FOR GS_NODE_INFO-MATTYPE,
           R_MATNR   FOR GS_NODE_INFO-MATNR,
           R_SCODE   FOR GS_NODE_INFO-SCODE,
           R_WERKS   FOR GS_NODE_INFO-WERKS.


  IF GS_NODE_INFO-BUKRS IS NOT INITIAL.
    R_BUKRS = 'I'.
    R_BUKRS-OPTION = 'EQ'.
    R_BUKRS-LOW = GS_NODE_INFO-BUKRS.
    APPEND R_BUKRS.
  ENDIF.

  IF GS_NODE_INFO-MATTYPE IS NOT INITIAL.
    R_MATTYPE = 'I'.
    R_MATTYPE-OPTION = 'EQ'.
    R_MATTYPE-LOW = GS_NODE_INFO-MATTYPE.
    APPEND R_MATTYPE.
  ENDIF.

  IF GS_NODE_INFO-MATNR IS NOT INITIAL.
    R_MATNR = 'I'.
    R_MATNR-OPTION = 'EQ'.
    R_MATNR-LOW = GS_NODE_INFO-MATNR.
    APPEND R_MATNR.
  ENDIF.




  SELECT FROM ZEA_MMT190  AS A
         JOIN ZEA_MMT020  AS B ON B~MATNR EQ A~MATNR
         LEFT JOIN ZEA_T001W   AS C ON C~WERKS EQ A~WERKS
         JOIN ZEA_MMT010  AS D ON D~MATNR EQ A~MATNR
         JOIN ZEA_MMT060 AS E ON E~WERKS EQ A~WERKS

       FIELDS C~BUKRS, A~MATNR, C~WERKS, A~SCODE, A~CALQTY, A~MEINS,
              A~WEIGHT, A~MEINS2, A~SAFSTK, A~MEINS3, B~MAKTX,
              C~PNAME1, E~SNAME
        WHERE C~BUKRS       IN @R_BUKRS
          AND D~MATTYPE     IN @R_MATTYPE
          AND A~MATNR       IN @R_MATNR
       INTO CORRESPONDING FIELDS OF TABLE @GT_DISPLAY3.











*
**SELECT FROM ZEA_MMT190 AS A
**       JOIN ZEA_MMT020 AS B ON B~MATNR = A~MATNR
**       LEFT JOIN ZEA_T001W AS C ON C~WERKS = A~WERKS
**       JOIN ZEA_MMT010 AS D ON D~MATNR = A~MATNR
**       JOIN ZEA_MMT060 AS E ON E~WERKS = A~WERKS
**  FIELDS C~BUKRS, A~MATNR, C~WERKS, A~SCODE, A~CALQTY, A~MEINS,
**         A~WEIGHT, A~MEINS2, A~SAFSTK, A~MEINS3, B~MAKTX,
**         C~PNAME1, E~SNAME
**  WHERE C~BUKRS       IN @R_BUKRS
**    AND D~MATTYPE     IN @R_MATTYPE
**    AND A~MATNR       IN @R_MATNR
**    AND A~SAFSTK      > 0
**    "AND ( A~CALQTY / A~SAFSTK ) * 100 <= 150
**  INTO CORRESPONDING FIELDS OF TABLE @GT_DISPLAY.
*
*
*
*
*
*DATA: lS_display LIKE GS_DISPLAY,
*      LT_DISPLAY LIKE TABLE OF LS_DISPLAY.
*  SELECT FROM ZEA_MMT190  AS A
*         JOIN ZEA_MMT020  AS B ON B~MATNR EQ A~MATNR
*         LEFT JOIN ZEA_T001W   AS C ON C~WERKS EQ A~WERKS
*         JOIN ZEA_MMT010  AS D ON D~MATNR EQ A~MATNR
*         JOIN ZEA_MMT060 AS E ON E~WERKS EQ A~WERKS
*
*       FIELDS C~BUKRS, A~MATNR, C~WERKS, A~SCODE, A~CALQTY, A~MEINS,
*              A~WEIGHT, A~MEINS2, A~SAFSTK, A~MEINS3, B~MAKTX,
*              C~PNAME1, E~SNAME
*        WHERE C~BUKRS       IN @R_BUKRS
*          AND D~MATTYPE     IN @R_MATTYPE
*          AND A~MATNR       IN @R_MATNR
*          AND A~SAFSTK > 0
*
*   INTO CORRESPONDING FIELDS OF TABLE @lt_display.














ENDFORM.
*&---------------------------------------------------------------------*
*& Form MODIFY_DISPLAY_0110
*&---------------------------------------------------------------------*
FORM MODIFY_DISPLAY_0110 .

  LOOP AT GT_DISPLAY3 INTO GS_DISPLAY3.

*    CLEAR GS_DISPLAY5.

*    MOVE-CORRESPONDING GS_DISPLAY5 TO GS_DISPLAY5.

*신규 필드------------------------------------------------------------*





    DATA LV_RATIO TYPE P DECIMALS 2.
    LOOP AT GT_DISPLAY3 INTO GS_DISPLAY3.

      IF GS_DISPLAY3-SAFSTK <= 0.

        GS_DISPLAY3-STATUS = ICON_CANCEL. " 빨간색 LED 아이콘
        " 수정된 데이터를 테이블에 반영
        MODIFY GT_DISPLAY3 FROM GS_DISPLAY3 TRANSPORTING STATUS.
      ENDIF.

*   안전재고 대비 현재 재고의 비율 계산
      IF GS_DISPLAY-SAFSTK > 0.
        LV_RATIO = ( GS_DISPLAY-CALQTY / GS_DISPLAY-SAFSTK ) * 100.
      ELSE.
        CONTINUE.  " 안전재고가 0이면 계산을 건너뜁니다.
      ENDIF.

      IF LV_RATIO < 110.

        GS_DISPLAY-STATUS = ICON_LED_RED. " 빨간색 LED 아이콘
      ELSEIF LV_RATIO >= 110 AND LV_RATIO <= 150.
        GS_DISPLAY-STATUS = ICON_LED_YELLOW. " 노란색 LED 아이콘
      ELSEIF LV_RATIO > 150.
        GS_DISPLAY-STATUS = ICON_LED_GREEN. " 초록색 LED 아이콘
      ENDIF.

      " 수정된 데이터를 테이블에 반영
      MODIFY GT_DISPLAY3 FROM GS_DISPLAY3 TRANSPORTING STATUS.
    ENDLOOP.

*--------------------------------------------------------------------*
    MODIFY GT_DISPLAY3 FROM GS_DISPLAY3.

  ENDLOOP.

  DESCRIBE TABLE GT_DISPLAY3 LINES GV_LINES.

  IF GT_DISPLAY3 IS INITIAL.
    MESSAGE S013 DISPLAY LIKE 'W'.
  ELSE.
*    MESSAGE S006 WITH GV_LINES.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_0110
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT_0110 .
  CREATE OBJECT GO_CONTAINER_4
    EXPORTING
      CONTAINER_NAME = 'CCON110'
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
*& Form DISPLAY_ALV_0110
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV_0110 .
  CLEAR GS_VARIANT.
  GS_VARIANT-REPORT = SY-REPID.
  GS_VARIANT-HANDLE = '0001'. " 프로그램 내 ALV 구별자

  GV_SAVE = 'A'. " 개인용/공용 모두 생성 가능하도록 설정

  CALL METHOD GO_ALV_GRID_3->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
*     I_STRUCTURE_NAME              =                  " Internal Output Table Structure Name
      IS_VARIANT                    = GS_VARIANT                 " Layout
      I_SAVE                        = GV_SAVE               " Save Layout
      IS_LAYOUT                     = GS_LAYOUT                " Layout
    CHANGING
      IT_OUTTAB                     = GT_DISPLAY3                " Output Table
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
*& Form SET_ALV_FIELDCAT_0110
*&---------------------------------------------------------------------*
FORM SET_ALV_FIELDCAT_0110 .
  PERFORM GET_FIELDCAT    USING    GT_DISPLAY3
                          CHANGING GT_FIELDCAT3.

  PERFORM MAKE_FIELDCAT_0300.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_FIELDCAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_DISPLAY3
*&      <-- GT_FIELDCAT3
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
*& Form MAKE_FIELDCAT_0300
*&---------------------------------------------------------------------*
FORM MAKE_FIELDCAT_0300 .
  LOOP AT GT_FIELDCAT4 INTO GS_FIELDCAT4.

    CASE GS_FIELDCAT4-FIELDNAME.

      WHEN 'STATUS'.
        GS_FIELDCAT4-COLTEXT = '안전재고'.
        GS_FIELDCAT4-JUST = 'C'.

      WHEN 'MATNR' OR 'WERKS'.
*        GS_FIELDCAT-HOTSPOT = ABAP_ON.
        GS_FIELDCAT4-KEY = ABAP_ON.
        GS_FIELDCAT4-JUST = 'C'.

      WHEN 'CALQTY'.
        GS_FIELDCAT4-QFIELDNAME = 'MEINS'.

      WHEN 'WEIGHT'.
        GS_FIELDCAT4-CFIELDNAME = 'MEINS2'.

      WHEN 'SAFSTK'.
        GS_FIELDCAT4-NO_OUT = ABAP_ON.
      WHEN 'MEINS3'.
        GS_FIELDCAT4-NO_OUT = ABAP_ON.

      WHEN   'SCODE' OR 'PNAME1'.
        GS_FIELDCAT4-JUST = 'C'.
      WHEN 'SAFSTK'.
        GS_FIELDCAT4-NO_OUT = 'X'.

      WHEN OTHERS.

    ENDCASE.
    MODIFY GT_FIELDCAT4 FROM GS_FIELDCAT4.

  ENDLOOP.
ENDFORM.
