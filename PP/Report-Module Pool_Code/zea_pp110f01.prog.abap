*&---------------------------------------------------------------------*
*& Include          YE00_EX007F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_0100
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT_0100 .

  CREATE OBJECT GO_CON_TOP
    EXPORTING
      CONTAINER_NAME = GC_CUSTOM_CONTAINER_NAME_TOP " Name of the Screen CustCtrl Name to Link Container To
    EXCEPTIONS
      OTHERS         = 1.

  IF SY-SUBRC <> 0.
    MESSAGE E020. " Container 생성 중 오류가 발생했습니다.
  ENDIF.

  CREATE OBJECT GO_SPLIT_TOP
    EXPORTING
      PARENT  = GO_CON_TOP " Parent Container
      ROWS    = 1          " Number of Rows to be displayed
      COLUMNS = 2          " Number of Columns to be Displayed
    EXCEPTIONS
      OTHERS  = 1.

  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
      WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  GO_SPLIT_TOP->SET_COLUMN_WIDTH(
    EXPORTING
      ID                = 1                 " Column ID
      WIDTH             = 17                " NPlWidth
  ).

  GO_CON_TOP_TREE = GO_SPLIT_TOP->GET_CONTAINER( ROW = 1 COLUMN = 1 ).
  GO_CON_TOP_GRID = GO_SPLIT_TOP->GET_CONTAINER( ROW = 1 COLUMN = 2 ).


  PERFORM CREATE_OBJECT_TREE.
  PERFORM CREATE_OBJECT_ALV.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_TREE
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT_TREE .

  CREATE OBJECT GO_SIMPLE_TREE
    EXPORTING
      PARENT              = GO_CON_TOP_TREE " Parent Container
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

  CREATE OBJECT GO_ALV_GRID_TOP
    EXPORTING
      I_PARENT = GO_CON_TOP_GRID " Parent Container
    EXCEPTIONS
      OTHERS   = 1.

  IF SY-SUBRC <> 0.
    MESSAGE E021. " ALV 객체 생성 중 오류가 발생했습니다.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_DATA
*&---------------------------------------------------------------------*
FORM SELECT_DATA .

*-- 판매계획
  REFRESH GT_HEADER.

  SELECT FROM ZEA_SDT030 AS A
*         JOIN ZEA_SDT020 AS B
*           ON B~SAPNR EQ A~SAPNR
*          AND B~SP_YEAR EQ A~SP_YEAR
         JOIN ZEA_T001W AS C
           ON C~WERKS EQ A~WERKS
*          AND C~WERKS EQ B~WERKS
         JOIN ZEA_MMT020 AS D
           ON D~MATNR EQ A~MATNR
          AND SPRAS EQ @SY-LANGU
  FIELDS A~SP_YEAR, C~BUKRS, C~WERKS, C~PNAME1, D~MATNR, D~MAKTX
    INTO CORRESPONDING FIELDS OF TABLE @GT_HEADER.

*-- 생산계획
  REFRESH GT_HEADER2.

  SELECT FROM ZEA_PLAF AS A
         JOIN ZEA_PPT010 AS B ON B~PLANID EQ A~PLANID
         JOIN ZEA_T001W  AS C ON C~WERKS EQ A~WERKS
         JOIN ZEA_MMT020 AS D ON D~MATNR EQ B~MATNR
                        AND D~SPRAS EQ @SY-LANGU
       FIELDS  A~PDPDAT,
               C~BUKRS,
               A~WERKS,
               C~PNAME1,
               B~MATNR,
               D~MAKTX
    WHERE B~WERKS EQ '10000'
      AND B~LOEKZ NE 'X'
       INTO TABLE @GT_HEADER2.

*  SELECT FROM ZEA_PLAF AS A
*         LEFT JOIN ZEA_T001W  AS B ON  B~WERKS  EQ A~WERKS
*         LEFT JOIN ZEA_PPT010 AS C ON  C~PLANID EQ A~PLANID
*         JOIN ZEA_MMT020 AS D ON  D~MATNR  EQ C~MATNR
*                              AND D~SPRAS  EQ @SY-LANGU
*    FIELDS  A~PDPDAT,
*            B~BUKRS,
*            B~WERKS,
*            B~PNAME1,
*            C~MATNR,
*            D~MAKTX
*    WHERE B~WERKS EQ '10000'
*      AND B~LOEKZ NE 'X'
*       INTO TABLE @GT_HEADER2.

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
FORM HANDLE_NODE_DOUBLE_CLICK  USING PV_NODE_KEY TYPE MTREESNODE-NODE_KEY
                                     PV_SENDER   TYPE REF TO CL_GUI_SIMPLE_TREE.

  IF GO_ALV_GRID_TOP IS INITIAL.
    " 출력할 ALV가 없습니다.
    MESSAGE S000 DISPLAY LIKE 'E' WITH TEXT-E01.
    EXIT.
  ENDIF.

  READ TABLE GT_NODE_INFO INTO GS_NODE_INFO
                          WITH KEY NODE_KEY = PV_NODE_KEY
                                   BINARY SEARCH.

  CHECK SY-SUBRC EQ 0.

  RANGES: R_SP_YEAR FOR GS_NODE_INFO-SP_YEAR,
          R_BUKRS FOR GS_NODE_INFO-BUKRS,
          R_WERKS FOR GS_NODE_INFO-WERKS,
          R_MATNR FOR GS_NODE_INFO-MATNR.

  IF GS_NODE_INFO-SP_YEAR IS NOT INITIAL.
    R_SP_YEAR-SIGN = 'I'.
    R_SP_YEAR-OPTION = 'EQ'.
    R_SP_YEAR-LOW = GS_NODE_INFO-SP_YEAR.
    APPEND R_SP_YEAR.
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


  SELECT FROM ZEA_T001W   AS A
*         LEFT OUTER JOIN ZEA_SDT030  AS B    ON B~WERKS EQ A~WERKS
         JOIN ZEA_SDT030  AS B    ON B~WERKS EQ A~WERKS
                    JOIN ZEA_MMT020  AS C    ON C~MATNR EQ B~MATNR
       FIELDS *
        WHERE B~SP_YEAR   IN @R_SP_YEAR
          AND A~BUKRS     IN @R_BUKRS
          AND A~WERKS     IN @R_WERKS
          AND C~MATNR     IN @R_MATNR
         INTO CORRESPONDING FIELDS OF TABLE @GT_DISPLAY.


*  SELECT FROM ZEA_SDT030  AS A
**           JOIN ZEA_SDT020  AS B    ON B~SAPNR EQ A~SAPNR
**                                   AND B~SP_YEAR EQ A~SP_YEAR
*         JOIN ZEA_T001W   AS C    ON C~WERKS EQ A~WERKS
**                                   AND C~WERKS EQ B~WERKS
*         JOIN ZEA_MMT020  AS D    ON D~MATNR EQ A~MATNR
*
*       FIELDS *
*        WHERE A~SP_YEAR   IN @R_SP_YEAR
*          AND C~BUKRS     IN @R_BUKRS
*          AND C~WERKS     IN @R_WERKS
*          AND D~MATNR     IN @R_MATNR
*         INTO CORRESPONDING FIELDS OF TABLE @GT_DISPLAY.


  SORT GT_DISPLAY BY MATNR.

*  LOOP AT GT_DISPLAY INTO GS_DISPLAY.
*
*    GS_DISPLAY-SEATSMAX_T = GS_DISPLAY-SEATSMAX + GS_DISPLAY-SEATSMAX_B + GS_DISPLAY-SEATSMAX_F.
*    GS_DISPLAY-SEATSOCC_T = GS_DISPLAY-SEATSOCC + GS_DISPLAY-SEATSOCC_B + GS_DISPLAY-SEATSOCC_F.
*    GS_DISPLAY-SEATSFRE_T = GS_DISPLAY-SEATSMAX_T - GS_DISPLAY-SEATSOCC_T.
*    MODIFY GT_DISPLAY FROM GS_DISPLAY.
*
*  ENDLOOP.

  GO_ALV_GRID_TOP->REFRESH_TABLE_DISPLAY(
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

  GS_LAYOUT-ZEBRA = ABAP_ON.
  GS_LAYOUT-CWIDTH_OPT = 'A'. " Always
  GS_LAYOUT-SEL_MODE = 'D'.
  GS_LAYOUT-GRID_TITLE = TEXT-T01.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_FIELDCAT_0100 .

  PERFORM GET_FIELDCAT_0100 USING  GT_DISPLAY
                                   GT_FIELDCAT.

  PERFORM SET_FIELDCAT_0100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_EVENT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_EVENT_0100 .

  SET HANDLER LCL_EVENT_HANDLER=>ON_TOOLBAR FOR GO_ALV_GRID_TOP.
  SET HANDLER LCL_EVENT_HANDLER=>ON_USER_COMMAND FOR GO_ALV_GRID_TOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_0100
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV_0100 .

  GS_VARIANT-REPORT = SY-REPID.
  GS_VARIANT-HANDLE = 'H'.
  GV_SAVE = 'A'.
  GS_VARIANT-HANDLE = '0001'. " 프로그램 내 ALV 구별자

  GO_ALV_GRID_TOP->SET_TABLE_FOR_FIRST_DISPLAY(
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
      WHEN 'SAPNR'
        OR 'SP_YEAR'.
        GS_FIELDCAT-KEY = ABAP_ON.
        GS_FIELDCAT-JUST = 'C'.
      WHEN 'WERKS'
        OR 'PNAME1'
        OR 'MATNR'
        OR 'MAKTX'.
        GS_FIELDCAT-EMPHASIZE = 'C500'.
        GS_FIELDCAT-JUST = 'C'.
      WHEN 'BUKRS'.
        GS_FIELDCAT-JUST = 'C'.
      WHEN 'SAPQU'.
        GS_FIELDCAT-EMPHASIZE = 'C300'.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
      WHEN 'TOTREV'.
        GS_FIELDCAT-EMPHASIZE = 'C310'.
        GS_FIELDCAT-CFIELDNAME = 'WAERS'.
      WHEN 'SPQTY1' OR 'SPQTY2'  OR 'SPQTY3'  OR 'SPQTY4'
        OR 'SPQTY5' OR 'SPQTY6'  OR 'SPQTY7'  OR 'SPQTY8'
        OR 'SPQTY9' OR 'SPQTY10' OR 'SPQTY11' OR 'SPQTY12'.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
*      WHEN 'SEATSMAX_T'
*        OR 'SEATSOCC_T'
*        OR 'SEATSFRE_T'.
*
*        GS_FIELDCAT-COLTEXT = 'Total.' && GS_FIELDCAT-SCRTEXT_S.
*        IF GS_FIELDCAT-FIELDNAME EQ 'SEATSFRE_T'.
*          GS_FIELDCAT-COLTEXT = 'Total.Free'.
*        ENDIF.
*        GS_FIELDCAT-EMPHASIZE = 'C300'.
    ENDCASE.
    MODIFY GT_FIELDCAT FROM GS_FIELDCAT.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_NODE_0100_2
*&---------------------------------------------------------------------*
FORM CREATE_NODE_0100 .

  " NODE를 아래와 같은 구성으로 만듦
  " 판매년도
  "  ㄴ 회사코드
  "       ㄴ 플랜ID : 플랜트명
  "             ㄴ 자재ID : 자재명

  SORT GT_HEADER BY SP_YEAR BUKRS WERKS MATNR.
  DATA: LV_NODE_KEY_SUPER TYPE N LENGTH 6,
        LT_NODE_KEY_LEVEL LIKE TABLE OF GV_NODE_KEY.
  DATA LV_BUTXT TYPE C LENGTH 25.

  GV_NODE_KEY += 1.
  CLEAR GS_NODE.
  GS_NODE-RELATKEY = SPACE. " 가장 최상위의 노드는 항상 공백이여야 한다.
  GS_NODE-NODE_KEY = LV_NODE_KEY_SUPER = GV_NODE_KEY.
  GS_NODE-ISFOLDER = ABAP_ON.
  GS_NODE-TEXT     = '판매년도/회사코드/플랜트명/자재명'.
  GS_NODE-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
  APPEND GS_NODE TO GT_NODE.

  " 1레벨 생성
  INSERT LV_NODE_KEY_SUPER INTO LT_NODE_KEY_LEVEL INDEX 1.

  CLEAR GS_NODE_INFO.
  GS_NODE_INFO-SP_YEAR = SPACE.
  GS_NODE_INFO-BUKRS = SPACE.
  GS_NODE_INFO-WERKS = SPACE.
  GS_NODE_INFO-MATNR = SPACE.
  GS_NODE_INFO-NODE_KEY = GV_NODE_KEY.
  APPEND GS_NODE_INFO TO GT_NODE_INFO.

  LOOP AT GT_HEADER INTO GS_HEADER.
    AT NEW SP_YEAR.

      " 폴더 노드 추가
      GV_NODE_KEY += 1.
      CLEAR GS_NODE.
      GS_NODE-RELATKEY = LV_NODE_KEY_SUPER.
      GS_NODE-NODE_KEY = LV_NODE_KEY_SUPER = GV_NODE_KEY.
      GS_NODE-ISFOLDER = ABAP_ON.
      GS_NODE-TEXT     = |{ GS_HEADER-SP_YEAR }년 판매계획|.
      GS_NODE-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
      APPEND GS_NODE TO GT_NODE.

      " 2레벨 생성
      INSERT LV_NODE_KEY_SUPER INTO LT_NODE_KEY_LEVEL INDEX 1.


      CLEAR GS_NODE_INFO.
      GS_NODE_INFO-SP_YEAR = GS_HEADER-SP_YEAR.
      GS_NODE_INFO-BUKRS   = SPACE.
      GS_NODE_INFO-WERKS   = SPACE.
      GS_NODE_INFO-MATNR   = SPACE.
      GS_NODE_INFO-NODE_KEY = GV_NODE_KEY.
      APPEND GS_NODE_INFO TO GT_NODE_INFO.

    ENDAT.

    SELECT SINGLE BUTXT
      FROM ZEA_FIT000
      INTO LV_BUTXT
      WHERE BUKRS EQ GS_HEADER-BUKRS.

    AT NEW BUKRS.

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
      GS_NODE_INFO-SP_YEAR = GS_HEADER-SP_YEAR.
      GS_NODE_INFO-BUKRS   = GS_HEADER-BUKRS.
      GS_NODE_INFO-WERKS   = SPACE.
      GS_NODE_INFO-MATNR   = SPACE.
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
      GS_NODE_INFO-SP_YEAR = GS_HEADER-SP_YEAR.
      GS_NODE_INFO-BUKRS   = GS_HEADER-BUKRS.
      GS_NODE_INFO-WERKS   = GS_HEADER-WERKS.
      GS_NODE_INFO-MATNR   = SPACE.
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
      GS_NODE-N_IMAGE  = ICON_CAR.  " 자동차 모양의 아이콘
      GS_NODE-TEXT     = |{ GS_HEADER-MATNR } : { GS_HEADER-MAKTX }|.
      GS_NODE-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
      APPEND GS_NODE TO GT_NODE.

      CLEAR GS_NODE_INFO.
      GS_NODE_INFO-SP_YEAR = GS_HEADER-SP_YEAR.
      GS_NODE_INFO-BUKRS   = GS_HEADER-BUKRS.
      GS_NODE_INFO-WERKS   = GS_HEADER-WERKS.
      GS_NODE_INFO-MATNR   = GS_HEADER-MATNR.
      GS_NODE_INFO-NODE_KEY = GV_NODE_KEY.
      APPEND GS_NODE_INFO TO GT_NODE_INFO.
    ELSE.
      " 항공편이 없는 경우
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


    AT END OF SP_YEAR.

      " 2레벨 제거 및 1레벨의 상위노드 정보 조회
      DELETE LT_NODE_KEY_LEVEL INDEX 1.
      READ TABLE LT_NODE_KEY_LEVEL INTO LV_NODE_KEY_SUPER INDEX 1.

    ENDAT.

  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLER_TOOLBAR
*&---------------------------------------------------------------------*
FORM HANDLER_TOOLBAR    USING PO_OBJECT TYPE REF TO CL_ALV_EVENT_TOOLBAR_SET
                              PO_SENDER TYPE REF TO CL_GUI_ALV_GRID.

  " Internal Table PO_OBJECT->MT_TOOLBAR 를 위한 작업공간
  " PO_OBJECT->MT_TOOLBAR >>> 클래스의 Attribute ( Public , Instance )
  DATA LS_TOOLBAR LIKE LINE OF PO_OBJECT->MT_TOOLBAR.

  CASE PO_SENDER.
    WHEN GO_ALV_GRID_TOP.

* 구분자 =>> |
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 3. " 구분자
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼추가 =>> 생산계획 생성
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-FUNCTION = GC_CALC_MPS.
      LS_TOOLBAR-TEXT = TEXT-L01.
      LS_TOOLBAR-ICON = ICON_INTENSIFY.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.
  ENDCASE.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_USER_COMMAND
*&---------------------------------------------------------------------*
FORM HANDLE_USER_COMMAND  USING PV_UCOMM TYPE SY-UCOMM
                               PO_SENDER  TYPE REF TO CL_GUI_ALV_GRID.

*  CALL METHOD GO_ALV_GRID_TOP->CHECK_CHANGED_DATA.

  CASE PO_SENDER.
    WHEN GO_ALV_GRID_TOP. "PO_SENDER 가 GO_ALV_GRID_TOP 일 때
      CASE PV_UCOMM.  " 선택한 버튼 (PV_UCOMM은 SY-UCOMM 타입)
        WHEN GC_CALC_MPS.
          IF GS_NODE_INFO-SP_YEAR LT SY-DATUM(4) AND GS_NODE_INFO-BUKRS EQ 1000 AND GS_NODE_INFO-WERKS EQ SPACE.
            MESSAGE S000 DISPLAY LIKE 'W' WITH '올해 이전의 판매계획은 생산계획으로 수립할 수 없습니다.'.

          ELSEIF GS_NODE_INFO-BUKRS EQ 1000 AND GS_NODE_INFO-WERKS EQ SPACE.

            PERFORM MOVE_DATA_TO_0110.
            CALL SCREEN 0110 STARTING AT 70 2.
            PERFORM REFRESH_ALV_0100.

          ELSEIF GS_NODE_INFO-SP_YEAR GE SY-DATUM(4) AND GS_NODE_INFO-BUKRS EQ SPACE.

            PERFORM MOVE_DATA_TO_0110.
            CALL SCREEN 0110 STARTING AT 70 2.
            PERFORM REFRESH_ALV_0100.

          ELSEIF GS_NODE_INFO-SP_YEAR LT SY-DATUM(4) AND GS_NODE_INFO-BUKRS EQ SPACE.
            MESSAGE S000 DISPLAY LIKE 'W' WITH '올해 이전의 판매계획은 생산계획으로 수립할 수 없습니다.'.
          ELSE.
            MESSAGE S076 DISPLAY LIKE 'W'. " 생산계획은 1000번 회사코드에서만 수립할 수 있습니다.
            EXIT.
          ENDIF.

      ENDCASE.

    WHEN GO_ALV_GRID_BOT. "PO_SENDER 가 GO_ALV_GRID_TOP 일 때
      CASE PV_UCOMM.  " 선택한 버튼 (PV_UCOMM은 SY-UCOMM 타입)

        WHEN GC_NO_FILTER.
          PERFORM NO_FILTER.

        WHEN GC_NO_USE_MPS.
          PERFORM NO_USE_MPS_FILTER.

        WHEN GC_USE_MPS.
          PERFORM USE_MPS_FILTER.

      ENDCASE.
  ENDCASE.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH_ALV_0100 : GRID, GRID2 같이 Refresh
*&---------------------------------------------------------------------*
FORM REFRESH_ALV_0100 .

  DATA LS_STABLE TYPE LVC_S_STBL.
  LS_STABLE-ROW = ABAP_ON.
  LS_STABLE-COL = ABAP_ON.

  CALL METHOD GO_ALV_GRID_TOP->REFRESH_TABLE_DISPLAY
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

  CALL METHOD GO_ALV_GRID_BOT->REFRESH_TABLE_DISPLAY
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
*& Form NO_FILTER
*&---------------------------------------------------------------------*
FORM NO_FILTER .

  REFRESH GT_FILTER.

  PERFORM SET_ALV_FILTER.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FILTER
*&---------------------------------------------------------------------*
FORM SET_ALV_FILTER .

  " ALV에 Filter 정보를 적용하는 과정
  CALL METHOD GO_ALV_GRID_BOT->SET_FILTER_CRITERIA
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
  CALL METHOD GO_ALV_GRID_BOT->REFRESH_TABLE_DISPLAY
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
*& Form NO_USE_MPS_FILTER
*&---------------------------------------------------------------------*
FORM NO_USE_MPS_FILTER .

  REFRESH GT_FILTER.

  CLEAR GS_FILTER.
  GS_FILTER-FIELDNAME = 'LIGHT'.
  GS_FILTER-SIGN      = 'I'.
  GS_FILTER-OPTION    = 'EQ'.
  GS_FILTER-LOW       = '1'.
  APPEND GS_FILTER TO GT_FILTER.

  PERFORM SET_ALV_FILTER.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form USE_MPS_FILTER
*&---------------------------------------------------------------------*
FORM USE_MPS_FILTER .

  REFRESH GT_FILTER.

  CLEAR GS_FILTER.
  GS_FILTER-FIELDNAME = 'LIGHT'.
  GS_FILTER-SIGN      = 'I'.
  GS_FILTER-OPTION    = 'EQ'.
  GS_FILTER-LOW       = '2'.
  APPEND GS_FILTER TO GT_FILTER.

  PERFORM SET_ALV_FILTER.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLER_TOOLBAR2
*&---------------------------------------------------------------------*
FORM HANDLER_TOOLBAR2  USING PO_OBJECT TYPE REF TO CL_ALV_EVENT_TOOLBAR_SET
                              PO_SENDER TYPE REF TO CL_GUI_ALV_GRID.

  DATA LS_TOOLBAR2 LIKE LINE OF PO_OBJECT->MT_TOOLBAR.

  CASE PO_SENDER.

    WHEN GO_ALV_GRID_BOT.

      DATA LV_TOTAL TYPE I.
      DATA LV_GREEN TYPE I.
      DATA LV_RED TYPE I.

      DESCRIBE TABLE GT_DISPLAY2.

      LOOP AT GT_DISPLAY2 INTO GS_DISPLAY2.
        ADD 1 TO LV_TOTAL.

        CASE GS_DISPLAY2-LIGHT.
          WHEN '1'. ADD 1 TO LV_RED.
          WHEN '2'. ADD 1 TO LV_GREEN.
        ENDCASE.

      ENDLOOP.

* 구분자 =>> |
      CLEAR LS_TOOLBAR2.
      LS_TOOLBAR2-BUTN_TYPE = 3. " 구분자
      APPEND LS_TOOLBAR2 TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 전체
      CLEAR LS_TOOLBAR2.
      LS_TOOLBAR2-FUNCTION = GC_NO_FILTER.
      LS_TOOLBAR2-TEXT = | 전체조회 : { SY-TFILL } |.
      LS_TOOLBAR2-ICON = ICON_SEARCH.
      APPEND LS_TOOLBAR2 TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 삭제 X
      CLEAR LS_TOOLBAR2.
      LS_TOOLBAR2-FUNCTION = GC_USE_MPS.
      LS_TOOLBAR2-ICON = ICON_LED_GREEN.
      LS_TOOLBAR2-TEXT = | 사용중 : { LV_GREEN }  |.
      APPEND LS_TOOLBAR2 TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 삭제 O
      CLEAR LS_TOOLBAR2.
      LS_TOOLBAR2-FUNCTION = GC_NO_USE_MPS.
      LS_TOOLBAR2-ICON = ICON_LED_RED.
      LS_TOOLBAR2-TEXT = | 미사용 : { LV_RED }  |.
      APPEND LS_TOOLBAR2 TO PO_OBJECT->MT_TOOLBAR.



  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM DISPLAY_DATA .

  CHECK SY-UNAME EQ 'ACA5-03'
   OR SY-UNAME EQ 'ACA5-07'
   OR SY-UNAME EQ 'ACA5-08'
   OR SY-UNAME EQ 'ACA5-10'
   OR SY-UNAME EQ 'ACA5-12'
   OR SY-UNAME EQ 'ACA5-15'
   OR SY-UNAME EQ 'ACA5-17'
   OR SY-UNAME EQ 'ACA5-23'
   OR SY-UNAME EQ 'ACA-05'
   OR SY-UNAME EQ 'aca5-09'.

ENDFORM.
