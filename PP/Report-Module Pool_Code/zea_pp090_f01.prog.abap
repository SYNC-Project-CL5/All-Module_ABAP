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

  " NODE를 아래와 같은 구성으로 만듦
  " 회사코드 1
  "  ㄴ 플랜트명 2
  "     ㄴ 년도 3
  "       ㄴ 자재명 4
  SORT GT_HEADER BY BUKRS WERKS PDPDAT MATNR.

  DATA LV_NODE_KEY_SUPER  TYPE N LENGTH 6.
  DATA LT_NODE_KEY_LEVEL  LIKE TABLE OF GV_NODE_KEY.

  GV_NODE_KEY += 1.
  CLEAR GS_NODE.
  GS_NODE-RELATKEY = SPACE. " 가장 최상위의 노드는 항상 공백이여야 한다.
  GS_NODE-NODE_KEY = LV_NODE_KEY_SUPER = GV_NODE_KEY.
  GS_NODE-ISFOLDER = ABAP_ON.
  GS_NODE-TEXT     = '회사코드/플랜트/생산년도/자재'.
  GS_NODE-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
  APPEND GS_NODE TO GT_NODE.

*  " 1레벨 생성
  INSERT LV_NODE_KEY_SUPER INTO LT_NODE_KEY_LEVEL INDEX 1.

  CLEAR GS_NODE_INFO.
  GS_NODE_INFO-BUKRS = SPACE.
  GS_NODE_INFO-WERKS = SPACE.
  GS_NODE_INFO-PDPDAT = SPACE.
  GS_NODE_INFO-MATNR = SPACE.
  GS_NODE_INFO-NODE_KEY = GV_NODE_KEY.
  APPEND GS_NODE_INFO TO GT_NODE_INFO.
*
  LOOP AT GT_HEADER INTO GS_HEADER.
    AT NEW BUKRS. " AT NEW 는 GT_HEADER에서 첫번째 필드부터 BUKRS 필드까지의 값을 기준으로
      " 이전 데이터과 비교해서 신규 데이터일 경우에만 작동한다.

      " 폴더 노드 추가
      GV_NODE_KEY += 1.
      CLEAR GS_NODE.
      GS_NODE-RELATKEY = LV_NODE_KEY_SUPER.
      GS_NODE-NODE_KEY = LV_NODE_KEY_SUPER = GV_NODE_KEY.
      GS_NODE-ISFOLDER = ABAP_ON.
      GS_NODE-TEXT     = GS_HEADER-BUKRS.
      GS_NODE-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
      APPEND GS_NODE TO GT_NODE.
*
      " 2레벨 생성
      INSERT LV_NODE_KEY_SUPER INTO LT_NODE_KEY_LEVEL INDEX 1.

      CLEAR GS_NODE_INFO.
      GS_NODE_INFO-BUKRS  = GS_HEADER-BUKRS.
      GS_NODE_INFO-WERKS  = SPACE.
      GS_NODE_INFO-PDPDAT = SPACE.
      GS_NODE_INFO-MATNR  = SPACE.
      GS_NODE_INFO-NODE_KEY = GV_NODE_KEY.
      APPEND GS_NODE_INFO TO GT_NODE_INFO.

    ENDAT.

    ON CHANGE OF GS_HEADER-WERKS.

      " 폴더 노드 추가
      GV_NODE_KEY += 1.
      CLEAR GS_NODE.
      GS_NODE-RELATKEY = LV_NODE_KEY_SUPER.
      GS_NODE-NODE_KEY = LV_NODE_KEY_SUPER = GV_NODE_KEY.
      GS_NODE-ISFOLDER = ABAP_ON.
      GS_NODE-TEXT     = |{ GS_HEADER-WERKS } - { GS_HEADER-PNAME1 } |.
      GS_NODE-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
      APPEND GS_NODE TO GT_NODE.

      " 2레벨 생성
      INSERT LV_NODE_KEY_SUPER INTO LT_NODE_KEY_LEVEL INDEX 1.


      CLEAR GS_NODE_INFO.
      GS_NODE_INFO-BUKRS = GS_HEADER-BUKRS.
      GS_NODE_INFO-WERKS = GS_HEADER-WERKS.
      GS_NODE_INFO-PDPDAT = SPACE.
      GS_NODE_INFO-MATNR = SPACE.
      GS_NODE_INFO-NODE_KEY = GV_NODE_KEY.
      APPEND GS_NODE_INFO TO GT_NODE_INFO.

    ENDON.

    AT NEW PDPDAT.

      " 폴더 노드 추가
      GV_NODE_KEY += 1.
      CLEAR GS_NODE.
      GS_NODE-RELATKEY = LV_NODE_KEY_SUPER.
      GS_NODE-NODE_KEY = LV_NODE_KEY_SUPER = GV_NODE_KEY.
      GS_NODE-ISFOLDER = ABAP_ON.
      GS_NODE-TEXT     = |{ GS_HEADER-PDPDAT }년 생산계획 |.
      GS_NODE-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
      APPEND GS_NODE TO GT_NODE.

      " 2레벨 생성
      INSERT LV_NODE_KEY_SUPER INTO LT_NODE_KEY_LEVEL INDEX 1.


      CLEAR GS_NODE_INFO.
      GS_NODE_INFO-BUKRS = GS_HEADER-BUKRS.
      GS_NODE_INFO-WERKS = GS_HEADER-WERKS.
      GS_NODE_INFO-PDPDAT = GS_HEADER-PDPDAT.
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
      GS_NODE_INFO-BUKRS = GS_HEADER-BUKRS.
      GS_NODE_INFO-WERKS = GS_HEADER-WERKS.
      GS_NODE_INFO-PDPDAT = GS_HEADER-PDPDAT.
      GS_NODE_INFO-MATNR = GS_HEADER-MATNR.
      GS_NODE_INFO-NODE_KEY = GV_NODE_KEY.
      APPEND GS_NODE_INFO TO GT_NODE_INFO.
    ELSE.
      " 자재코드가 없는 경우
    ENDIF.


    AT END OF PDPDAT.

      " 2레벨 제거 및 1레벨의 상위노드 정보 조회
      DELETE LT_NODE_KEY_LEVEL INDEX 1.
      READ TABLE LT_NODE_KEY_LEVEL INTO LV_NODE_KEY_SUPER INDEX 1.

    ENDAT.

    AT END OF WERKS.

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
*& Form SELECT_DATA
*&---------------------------------------------------------------------*
FORM SELECT_DATA .

  REFRESH GT_HEADER.

* 플랜트ID, 자재코드, 생산계획번호로 조인을 걸어 GT_HEADER 에
* 회사코드, 플랜트ID, 플랜트명, 생산년도, 자재코드, 자재명 데이터를 가져온다.
  SELECT FROM ZEA_T001W AS A LEFT JOIN ZEA_PPT010 AS B ON B~WERKS EQ A~WERKS
                             LEFT JOIN ZEA_MMT020 AS C ON C~MATNR EQ B~MATNR
                                                      AND C~SPRAS EQ @SY-LANGU
                             LEFT JOIN ZEA_PLAF   AS D ON D~PLANID EQ B~PLANID
  FIELDS A~BUKRS,
         A~WERKS,
         A~PNAME1,
         D~PDPDAT,
         B~MATNR,
         C~MAKTX
    WHERE A~WERKS EQ '10000'
      AND D~PDPDAT NE @SPACE
      AND B~LOEKZ NE 'X'
    INTO CORRESPONDING FIELDS OF TABLE @GT_HEADER.

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

  IF GO_ALV_GRID IS INITIAL.
    " 출력할 ALV가 없습니다.
    MESSAGE S000 DISPLAY LIKE 'E' WITH TEXT-E01.
    EXIT.
  ENDIF.

  READ TABLE GT_NODE_INFO INTO GS_NODE_INFO
                          WITH KEY NODE_KEY = PV_NODE_KEY
                                   BINARY SEARCH.

  CHECK SY-SUBRC EQ 0.

  RANGES: R_BUKRS  FOR GS_NODE_INFO-BUKRS,
          R_WERKS  FOR GS_NODE_INFO-WERKS,
          R_PDPDAT FOR GS_NODE_INFO-PDPDAT,
          R_MATNR  FOR GS_NODE_INFO-MATNR.

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

  IF GS_NODE_INFO-PDPDAT IS NOT INITIAL.
    R_PDPDAT-SIGN = 'I'.
    R_PDPDAT-OPTION = 'EQ'.
    R_PDPDAT-LOW = GS_NODE_INFO-PDPDAT.
    APPEND R_PDPDAT.
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
          AND  A~LOEKZ    NE 'X'
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

    SELECT COUNT( * )
      FROM ZEA_AUFK
      WHERE PLANID EQ GS_DISPLAY-PLANID
        AND MATNR  EQ GS_DISPLAY-MATNR.

    IF SY-SUBRC EQ 0.
      GS_DISPLAY-LIGHT = 3.
    ELSE.
      GS_DISPLAY-LIGHT = 2.
    ENDIF.

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

  GS_LAYOUT-ZEBRA = ABAP_ON.
  GS_LAYOUT-CWIDTH_OPT = 'A'. " Always
  GS_LAYOUT-SEL_MODE = 'D'.
*  GS_LAYOUT-GRID_TITLE = TEXT-T01.
  GS_LAYOUT-EXCP_FNAME = 'LIGHT'.           " 신호등
  GS_LAYOUT-EXCP_LED = ABAP_ON.

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
  SET HANDLER LCL_EVENT_HANDLER=>ON_TOOLBAR FOR GO_ALV_GRID.
  SET HANDLER LCL_EVENT_HANDLER=>ON_USER_COMMAND FOR GO_ALV_GRID.
  SET HANDLER LCL_EVENT_HANDLER=>ON_DOUBLE_CLICK FOR GO_ALV_GRID.
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
      WHEN 'PLANID'.
        GS_FIELDCAT-KEY        = ABAP_ON.
      WHEN 'PLANINDEX'.
        GS_FIELDCAT-NO_OUT     = ABAP_ON.
        GS_FIELDCAT-COLTEXT    = '인덱스'.
        GS_FIELDCAT-JUST       = 'C'.
      WHEN 'PLANQTY1'.
        GS_FIELDCAT-COLTEXT    = '1월 계획'.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
      WHEN 'PLANQTY2'.
        GS_FIELDCAT-COLTEXT    = '2월 계획'.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
      WHEN 'PLANQTY3'.
        GS_FIELDCAT-COLTEXT    = '3월 계획'.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
      WHEN 'PLANQTY4'.
        GS_FIELDCAT-COLTEXT    = '4월 계획'.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
      WHEN 'PLANQTY5'.
        GS_FIELDCAT-COLTEXT    = '5월 계획'.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
      WHEN 'PLANQTY6'.
        GS_FIELDCAT-COLTEXT    = '6월 계획'.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
      WHEN 'PLANQTY7'.
        GS_FIELDCAT-COLTEXT    = '7월 계획'.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
      WHEN 'PLANQTY8'.
        GS_FIELDCAT-COLTEXT    = '8월 계획'.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
      WHEN 'PLANQTY9'.
        GS_FIELDCAT-COLTEXT    = '9월 계획'.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
      WHEN 'PLANQTY10'.
        GS_FIELDCAT-COLTEXT    = '10월 계획'.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
      WHEN 'PLANQTY11'.
        GS_FIELDCAT-COLTEXT    = '11월 계획'.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
      WHEN 'PLANQTY12'.
        GS_FIELDCAT-COLTEXT    = '12월 계획'.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
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

ENDFORM.
**&---------------------------------------------------------------------*
**& Form CREATE_NODE_0100_2
**&---------------------------------------------------------------------*
*FORM CREATE_NODE_0100_2 .
*
*  " NODE를 아래와 같은 구성으로 만듦
*  " 출발국가 1
*  "  ㄴ 출발도시 2
*  "       ㄴ 항공사 3
*  "             ㄴ 항공편 4
*
*  DATA: BEGIN OF LS_HEADER,
*          COUNTRYFR LIKE SPFLI-COUNTRYFR,
*          CITYFROM  LIKE SPFLI-CITYFROM,
*          CARRID    LIKE SCARR-CARRID,
*          CARRNAME  LIKE SCARR-CARRNAME,
*          CONNID    LIKE SPFLI-CONNID,
*          AIRPFROM  LIKE SPFLI-AIRPFROM,
*          COUNTRYTO LIKE SPFLI-COUNTRYTO,
*          CITYTO    LIKE SPFLI-CITYTO,
*          AIRPTO    LIKE SPFLI-AIRPTO,
*        END OF LS_HEADER,
*        LT_HEADER LIKE TABLE OF LS_HEADER.
*
*
*  LT_HEADER[] = CORRESPONDING #( GT_HEADER ).
*  DELETE LT_HEADER WHERE COUNTRYFR IS INITIAL.
*
*  SORT LT_HEADER BY COUNTRYFR CITYFROM CARRID CONNID.
*
*  DATA LV_NODE_KEY_SUPER  TYPE N LENGTH 6.
*  DATA LT_NODE_KEY_LEVEL  LIKE TABLE OF GV_NODE_KEY.
*
*  GV_NODE_KEY += 1.
*  CLEAR GS_NODE.
*  GS_NODE-RELATKEY = SPACE. " 가장 최상위의 노드는 항상 공백이여야 한다.
*  GS_NODE-NODE_KEY = LV_NODE_KEY_SUPER = GV_NODE_KEY.
*  GS_NODE-ISFOLDER = ABAP_ON.
*  GS_NODE-TEXT     = '출발국가/출발도시/항공사/항공편 노드'.
*  GS_NODE-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
*  APPEND GS_NODE TO GT_NODE.
*
*  " 1레벨 생성
*  INSERT LV_NODE_KEY_SUPER INTO LT_NODE_KEY_LEVEL INDEX 1.
*
*  CLEAR GS_NODE_INFO.
*  GS_NODE_INFO-CARRID = SPACE.
*  GS_NODE_INFO-CONNID = SPACE.
*  GS_NODE_INFO-COUNTRYFR = SPACE.
*  GS_NODE_INFO-CITYFROM = SPACE.
*  GS_NODE_INFO-NODE_KEY = GV_NODE_KEY.
*  APPEND GS_NODE_INFO TO GT_NODE_INFO.
*
*  LOOP AT LT_HEADER INTO LS_HEADER.
*    AT NEW COUNTRYFR.
*
*      " 폴더 노드 추가
*      GV_NODE_KEY += 1.
*      CLEAR GS_NODE.
*      GS_NODE-RELATKEY = LV_NODE_KEY_SUPER.
*      GS_NODE-NODE_KEY = LV_NODE_KEY_SUPER = GV_NODE_KEY.
*      GS_NODE-ISFOLDER = ABAP_ON.
*      GS_NODE-TEXT     = |{ LS_HEADER-COUNTRYFR }|.
*      GS_NODE-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
*      APPEND GS_NODE TO GT_NODE.
*
*      " 2레벨 생성
*      INSERT LV_NODE_KEY_SUPER INTO LT_NODE_KEY_LEVEL INDEX 1.
*
*
*      CLEAR GS_NODE_INFO.
*      GS_NODE_INFO-CARRID = SPACE.
*      GS_NODE_INFO-CONNID = SPACE.
*      GS_NODE_INFO-COUNTRYFR = LS_HEADER-COUNTRYFR.
*      GS_NODE_INFO-CITYFROM = SPACE.
*      GS_NODE_INFO-NODE_KEY = GV_NODE_KEY.
*      APPEND GS_NODE_INFO TO GT_NODE_INFO.
*
*    ENDAT.
*
*    AT NEW CITYFROM.
*
*      " 폴더 노드 추가
*      GV_NODE_KEY += 1.
*      CLEAR GS_NODE.
*      GS_NODE-RELATKEY = LV_NODE_KEY_SUPER.
*      GS_NODE-NODE_KEY = LV_NODE_KEY_SUPER = GV_NODE_KEY.
*      GS_NODE-ISFOLDER = ABAP_ON.
*      GS_NODE-TEXT     = |{ LS_HEADER-CITYFROM }|.
*      GS_NODE-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
*      APPEND GS_NODE TO GT_NODE.
*
*      " 2레벨 생성
*      INSERT LV_NODE_KEY_SUPER INTO LT_NODE_KEY_LEVEL INDEX 1.
*
*
*      CLEAR GS_NODE_INFO.
*      GS_NODE_INFO-CARRID = SPACE.
*      GS_NODE_INFO-CONNID = SPACE.
*      GS_NODE_INFO-COUNTRYFR = LS_HEADER-COUNTRYFR.
*      GS_NODE_INFO-CITYFROM = LS_HEADER-CITYFROM.
*      GS_NODE_INFO-NODE_KEY = GV_NODE_KEY.
*      APPEND GS_NODE_INFO TO GT_NODE_INFO.
*
*    ENDAT.
*
*    AT NEW CARRNAME.
*
*      " 폴더 노드 추가
*      GV_NODE_KEY += 1.
*      CLEAR GS_NODE.
*      GS_NODE-RELATKEY = LV_NODE_KEY_SUPER.
*      GS_NODE-NODE_KEY = LV_NODE_KEY_SUPER = GV_NODE_KEY.
*      GS_NODE-ISFOLDER = ABAP_ON.
*      GS_NODE-TEXT     = |{ LS_HEADER-CARRID } { LS_HEADER-CARRNAME }|.
*      GS_NODE-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
*      APPEND GS_NODE TO GT_NODE.
*
*      " 2레벨 생성
*      INSERT LV_NODE_KEY_SUPER INTO LT_NODE_KEY_LEVEL INDEX 1.
*
*
*      CLEAR GS_NODE_INFO.
*      GS_NODE_INFO-CARRID = LS_HEADER-CARRID.
*      GS_NODE_INFO-CONNID = SPACE.
*      GS_NODE_INFO-COUNTRYFR = LS_HEADER-COUNTRYFR.
*      GS_NODE_INFO-CITYFROM = LS_HEADER-CITYFROM.
*      GS_NODE_INFO-NODE_KEY = GV_NODE_KEY.
*      APPEND GS_NODE_INFO TO GT_NODE_INFO.
*
*    ENDAT.
*
*    IF LS_HEADER-CONNID IS NOT INITIAL.
*      GV_NODE_KEY += 1.
*
*      CLEAR GS_NODE.
*      " 2레벨 노드를 상위노드로 지정
*      GS_NODE-RELATKEY = LV_NODE_KEY_SUPER.
*      GS_NODE-NODE_KEY = GV_NODE_KEY.
*      GS_NODE-ISFOLDER = ABAP_OFF.
*      GS_NODE-N_IMAGE  = ICON_FLIGHT.  " 비행기 모양의 아이콘
*      GS_NODE-TEXT     = |{ LS_HEADER-CONNID }({ LS_HEADER-COUNTRYFR } > { LS_HEADER-COUNTRYTO })|.
*      GS_NODE-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
*      APPEND GS_NODE TO GT_NODE.
*
*      CLEAR GS_NODE_INFO.
*      GS_NODE_INFO-CARRID = LS_HEADER-CARRID.
*      GS_NODE_INFO-CONNID = LS_HEADER-CONNID.
*      GS_NODE_INFO-COUNTRYFR = LS_HEADER-COUNTRYFR.
*      GS_NODE_INFO-CITYFROM = LS_HEADER-CITYFROM.
*      GS_NODE_INFO-NODE_KEY = GV_NODE_KEY.
*      APPEND GS_NODE_INFO TO GT_NODE_INFO.
*    ELSE.
*      " 항공편이 없는 경우
*    ENDIF.
*
*    AT END OF CARRNAME.
*
*      " 2레벨 제거 및 1레벨의 상위노드 정보 조회
*      DELETE LT_NODE_KEY_LEVEL INDEX 1.
*      READ TABLE LT_NODE_KEY_LEVEL INTO LV_NODE_KEY_SUPER INDEX 1.
*
*    ENDAT.
*
*    AT END OF CITYFROM.
*
*      " 2레벨 제거 및 1레벨의 상위노드 정보 조회
*      DELETE LT_NODE_KEY_LEVEL INDEX 1.
*      READ TABLE LT_NODE_KEY_LEVEL INTO LV_NODE_KEY_SUPER INDEX 1.
*
*
*    ENDAT.
*
*
*    AT END OF COUNTRYFR.
*
*      " 2레벨 제거 및 1레벨의 상위노드 정보 조회
*      DELETE LT_NODE_KEY_LEVEL INDEX 1.
*      READ TABLE LT_NODE_KEY_LEVEL INTO LV_NODE_KEY_SUPER INDEX 1.
*
*    ENDAT.
*
*  ENDLOOP.
*
*
*ENDFORM.
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

      DATA LV_TOTAL TYPE I.
      DATA LV_GREEN TYPE I.
      DATA LV_YELLOW TYPE I.

      LOOP AT GT_DISPLAY INTO GS_DISPLAY.
        ADD 1 TO LV_TOTAL.

        CASE GS_DISPLAY-LIGHT.
          WHEN '2'. ADD 1 TO LV_YELLOW.
          WHEN '3'. ADD 1 TO LV_GREEN.
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

* 버튼 추가 =>> 생산오더 보유
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-FUNCTION = GC_EXIST.
      LS_TOOLBAR-ICON = ICON_LED_GREEN.
      LS_TOOLBAR-TEXT = | 생산오더 보유 : { LV_GREEN }  |.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 생산오더 미보유
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-FUNCTION = GC_NO_EXIST.
      LS_TOOLBAR-ICON = ICON_LED_YELLOW.
      LS_TOOLBAR-TEXT = | 생산오더 미보유 : { LV_YELLOW }  |.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 생산오더 생성
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 0.
      LS_TOOLBAR-FUNCTION = GC_CREATE.
      LS_TOOLBAR-ICON = ICON_CREATE.
      LS_TOOLBAR-TEXT = TEXT-L01. " 생산오더 생성
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
        WHEN GC_CREATE.
          PERFORM CREATE_ORDER.
        WHEN GC_NO_FILTER.
          PERFORM NO_FILTER.
        WHEN GC_EXIST.
          PERFORM FILTER_EXIST.
        WHEN GC_NO_EXIST.
          PERFORM FILTER_NO_EXIST.
      ENDCASE.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_DISPLAY_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM MAKE_DISPLAY_DATA .

  DATA LS_STYLE TYPE LVC_S_STYL.

  REFRESH GT_AUFK.
  REFRESH GT_PPT020.

  LOOP AT GT_DATA INTO GS_DATA.

    CLEAR GS_AUFK.

    MOVE-CORRESPONDING GS_DATA TO GS_AUFK.

*신규 필드------------------------------------------------------------*


*--------------------------------------------------------------------*
    APPEND GS_AUFK TO GT_AUFK.

  ENDLOOP.


  LOOP AT GT_DATA2 INTO GS_DATA2.

    CLEAR GS_PPT020.

    MOVE-CORRESPONDING GS_DATA2 TO GS_PPT020.

*신규 필드------------------------------------------------------------*


*--------------------------------------------------------------------*
    APPEND GS_PPT020 TO GT_PPT020.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_SPLIT_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT_SPLIT_0100 .

  CREATE OBJECT GO_CONTAINER
    EXPORTING
      CONTAINER_NAME = 'CCON2' " Name of the Screen CustCtrl Name to Link Container To
    EXCEPTIONS
      OTHERS         = 1.

  IF SY-SUBRC NE 0.
    MESSAGE '컨테이너 생성에 실패했습니다.' TYPE 'E'.
  ENDIF.

  CREATE OBJECT GO_SPLIT
    EXPORTING
      PARENT  = GO_CONTAINER                   " Parent Container
      ROWS    = 2                   " Number of Rows to be displayed
      COLUMNS = 1                   " Number of Columns to be Displayed
    EXCEPTIONS
      OTHERS  = 1.
  IF SY-SUBRC <> 0.
    MESSAGE '분리 컨테이너 생성에 실패했습니다.' TYPE 'E'.
  ENDIF.

  CALL METHOD GO_SPLIT->GET_CONTAINER
    EXPORTING
      ROW       = 1                " Row
      COLUMN    = 1                " Column
    RECEIVING
      CONTAINER = GO_CON_TOP.                 " Container

  CALL METHOD GO_SPLIT->GET_CONTAINER
    EXPORTING
      ROW       = 2                " Row
      COLUMN    = 1                " Column
    RECEIVING
      CONTAINER = GO_CON_BOT.                 " Container

  " 신문법 중 하나
  GO_CON_TOP = GO_SPLIT->GET_CONTAINER( ROW = 1 COLUMN = 1 ).
  GO_CON_BOT = GO_SPLIT->GET_CONTAINER( ROW = 2 COLUMN = 1 ).


  " TOP 컨테이너 ALV를 생성
  CREATE OBJECT GO_ALV_GRID_TOP
    EXPORTING
      I_PARENT = GO_CON_TOP " Parent Container
    EXCEPTIONS
      OTHERS   = 1.

  IF SY-SUBRC NE 0.
    MESSAGE 'ALV 생성에 실패했습니다.' TYPE 'E'.
  ENDIF.

  " BOT 컨테이너에 ALV를 생성
  CREATE OBJECT GO_ALV_GRID_BOT
    EXPORTING
      I_PARENT = GO_CON_BOT
    EXCEPTIONS
      OTHERS   = 1.

  IF SY-SUBRC NE 0.
    MESSAGE 'BOT ALV 생성에 실패했습니다.' TYPE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FIELDCAT_SPLIT_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_ALV_FIELDCAT_SPLIT_0100 .

  PERFORM GET_FIELDCAT_0100 USING  GT_AUFK
                                   GT_FIELDCAT2.
  PERFORM GET_FIELDCAT_0100 USING  GT_PPT020
                                   GT_FIELDCAT3.

  PERFORM SET_FIELDCAT_SPLIT_0100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_LIST_SPLIT_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_ALV_LIST_SPLIT_0100 .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_LAYOUT_SPLIT_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_ALV_LAYOUT_SPLIT_0100 .

  CLEAR GS_LAYOUT.
  CLEAR GS_VARIANT.
  CLEAR GV_SAVE.

  GS_VARIANT-REPORT = SY-REPID.
  GV_SAVE = 'A'.
  " 'A' : Layout을 저장할 때 'U'/'X' 선택 가능

  GS_LAYOUT-CWIDTH_OPT = 'A'.
  GS_LAYOUT-ZEBRA      = ABAP_ON.
  GS_LAYOUT-SEL_MODE   = 'D'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_EVENT_SPLIT_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_ALV_EVENT_SPLIT_0100 .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_SPLIT_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV_SPLIT_0100 .

  GS_VARIANT-HANDLE = '1'.

  CALL METHOD GO_ALV_GRID_TOP->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
      I_STRUCTURE_NAME = 'ZEA_AUFK'     " Internal Output Table Structure Name
      IS_VARIANT       = GS_VARIANT  " Layout
      I_SAVE           = GV_SAVE     " Save Layout
      IS_LAYOUT        = GS_LAYOUT   " Layout
    CHANGING
      IT_OUTTAB        = GT_AUFK    " Output Table
      IT_FIELDCATALOG  = GT_FIELDCAT2          " Field Catalog
    EXCEPTIONS
      OTHERS           = 1.

  IF SY-SUBRC <> 0.
    MESSAGE 'ALV에 데이터를 설정하는 과정 중 오류가 발생했습니다.' TYPE 'E'.
  ENDIF.

  GS_VARIANT-HANDLE = '2'.

  CALL METHOD GO_ALV_GRID_BOT->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
      I_STRUCTURE_NAME = 'ZEA_PPT020'     " Internal Output Table Structure Name
      IS_VARIANT       = GS_VARIANT  " Layout
      I_SAVE           = GV_SAVE     " Save Layout
      IS_LAYOUT        = GS_LAYOUT   " Layout
    CHANGING
      IT_OUTTAB        = GT_PPT020    " Output Table
      IT_FIELDCATALOG  = GT_FIELDCAT3          " Field Catalog
    EXCEPTIONS
      OTHERS           = 1.

  IF SY-SUBRC <> 0.
    MESSAGE 'ALV에 데이터를 설정하는 과정 중 오류가 발생했습니다.' TYPE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH_ALV_SPLIT_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM REFRESH_ALV_SPLIT_0100 .

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
*& Form SET_FIELDCAT_SPLIT_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_FIELDCAT_SPLIT_0100 .

  LOOP AT GT_FIELDCAT2 INTO GS_FIELDCAT2.

    CASE GS_FIELDCAT2-FIELDNAME.
      WHEN 'AUFNR'.
*        GS_FIELDCAT2-HOTSPOT = ABAP_ON.
      WHEN 'PNAME1'.
        GS_FIELDCAT2-COL_POS = 2.
      WHEN 'APPROVAL'.
        GS_FIELDCAT2-NO_OUT = ABAP_ON.
      WHEN 'REJREASON'.
        GS_FIELDCAT2-NO_OUT = ABAP_ON.
*        GS_FIELDCAT2-DRDN_HNDL = '1'.
*        GS_FIELDCAT2-DRDN_ALIAS = ABAP_ON.
*        GS_FIELDCAT2-EDIT       = ABAP_ON.
      WHEN 'MENGE'.
        GS_FIELDCAT2-QFIELDNAME = 'MEINS'.
      WHEN 'MEINS'.
        GS_FIELDCAT2-COLTEXT    = '단위'.
*      WHEN 'REJECT'.
*        GS_FIELDCAT-COL_POS = 100.
*        GS_FIELDCAT-COLTEXT = '반려사유'.
*        GS_FIELDCAT-JUST    = 'C'.
**        GS_FIELDCAT-STYLE   = CL_GUI_ALV_GRID=>MC_STYLE_BUTTON.
      WHEN 'LOEKZ'.
        GS_FIELDCAT2-NO_OUT = ABAP_ON.
      WHEN 'ERNAM'.
        GS_FIELDCAT2-NO_OUT = ABAP_ON.
      WHEN 'ERDAT'.
        GS_FIELDCAT2-NO_OUT = ABAP_ON.
      WHEN 'ERZET'.
        GS_FIELDCAT2-NO_OUT = ABAP_ON.
      WHEN 'AENAM'.
        GS_FIELDCAT2-NO_OUT = ABAP_ON.
      WHEN 'AEDAT'.
        GS_FIELDCAT2-NO_OUT = ABAP_ON.
      WHEN 'AEZET'.
        GS_FIELDCAT2-NO_OUT = ABAP_ON.
      WHEN 'STATUS'.
        GS_FIELDCAT2-COLTEXT = 'Status'.
        GS_FIELDCAT2-ICON    = ABAP_ON.
        GS_FIELDCAT2-KEY     = ABAP_OFF.
        GS_FIELDCAT2-NO_OUT  = ABAP_ON.
      WHEN 'COLOR'.
        GS_FIELDCAT2-NO_OUT  = ABAP_ON.
      WHEN 'LIGHT'.
*        GS_FIELDCAT2-COLTEXT = '승인여부'.
        GS_FIELDCAT2-NO_OUT  = ABAP_ON.
      WHEN 'MARK'.
        GS_FIELDCAT2-NO_OUT  = ABAP_ON.
    ENDCASE.

    MODIFY GT_FIELDCAT2 FROM GS_FIELDCAT2.

  ENDLOOP.

  LOOP AT GT_FIELDCAT3 INTO GS_FIELDCAT3.

    CASE GS_FIELDCAT3-FIELDNAME.
      WHEN 'ORDIDX'.
        GS_FIELDCAT3-JUST    = 'C'.
      WHEN 'LOEKZ'.
        GS_FIELDCAT3-NO_OUT = ABAP_ON.
      WHEN 'ERNAM'.
        GS_FIELDCAT3-NO_OUT = ABAP_ON.
      WHEN 'ERDAT'.
        GS_FIELDCAT3-NO_OUT = ABAP_ON.
      WHEN 'ERZET'.
        GS_FIELDCAT3-NO_OUT = ABAP_ON.
      WHEN 'AENAM'.
        GS_FIELDCAT3-NO_OUT = ABAP_ON.
      WHEN 'AEDAT'.
        GS_FIELDCAT3-NO_OUT = ABAP_ON.
      WHEN 'AEZET'.
        GS_FIELDCAT3-NO_OUT = ABAP_ON.
      WHEN 'STATUS'.
        GS_FIELDCAT3-COLTEXT = 'Status'.
        GS_FIELDCAT3-ICON    = ABAP_ON.
        GS_FIELDCAT3-KEY     = ABAP_OFF.
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
*& Form CREATE_ORDER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CREATE_ORDER .

*  DATA GT_INDEX_ROWS TYPE LVC_T_ROW.
*  DATA GS_INDEX_ROW LIKE LINE OF GT_INDEX_ROWS.

  CALL METHOD GO_ALV_GRID->GET_SELECTED_ROWS
    IMPORTING
      ET_INDEX_ROWS = GT_INDEX_ROWS     " Indexes of Selected Rows
*     ET_ROW_NO     =                  " Numeric IDs of Selected Rows
    .

  DESCRIBE TABLE GT_INDEX_ROWS.

  DATA LV_SUBRC TYPE I.
  DATA LV_COUNT TYPE I.

  IF GT_INDEX_ROWS[] IS INITIAL OR SY-TFILL NE 1.
    " TEXT-M01: 라인을 선택하세요.
    MESSAGE S000 DISPLAY LIKE 'W' WITH '한 행을 선택하세요'.

  ELSE.

    CLEAR: S0110-1MONTH,
           S0110-2MONTH,
           S0110-3MONTH,
           S0110-4MONTH,
           S0110-5MONTH,
           S0110-6MONTH,
           S0110-7MONTH,
           S0110-8MONTH,
           S0110-9MONTH,
           S0110-10MONTH,
           S0110-11MONTH,
           S0110-12MONTH.

    READ TABLE GT_INDEX_ROWS INTO GS_INDEX_ROW INDEX 1.

    CHECK GS_INDEX_ROW-ROWTYPE IS INITIAL.

    READ TABLE GT_DISPLAY INTO GS_DISPLAY INDEX GS_INDEX_ROW-INDEX.

    IF SY-SUBRC EQ 0.

      DATA: LV_WERKS  TYPE ZEA_PLAF-WERKS,
            LV_PNAME1 TYPE ZEA_T001W-PNAME1,
            LV_MAKTX  TYPE ZEA_MMT020-MAKTX.

      S0110-MATNR = GS_DISPLAY-MATNR.

      SELECT SINGLE MAKTX
        INTO LV_MAKTX
        FROM ZEA_MMT020
        WHERE MATNR EQ GS_DISPLAY-MATNR
          AND SPRAS EQ SY-LANGU.

      S0110-MAKTX = LV_MAKTX.

      S0110-BOMID = GS_DISPLAY-BOMID.

      SELECT SINGLE WERKS
        INTO LV_WERKS
        FROM ZEA_PLAF
        WHERE PLANID = GS_DISPLAY-PLANID.

      S0110-WERKS   = LV_WERKS.

      SELECT SINGLE PNAME1
        INTO LV_PNAME1
        FROM ZEA_T001W
        WHERE WERKS EQ LV_WERKS.

      S0110-PNAME1  = LV_PNAME1.

      S0110-PLANID  = GS_DISPLAY-PLANID.

      S0110-EXPQTY1 = GS_DISPLAY-PLANQTY1.
      S0110-EXPQTY2 = GS_DISPLAY-PLANQTY2.
      S0110-EXPQTY3 = GS_DISPLAY-PLANQTY3.
      S0110-EXPQTY4 = GS_DISPLAY-PLANQTY4.
      S0110-EXPQTY5 = GS_DISPLAY-PLANQTY5.
      S0110-EXPQTY6 = GS_DISPLAY-PLANQTY6.
      S0110-EXPQTY7 = GS_DISPLAY-PLANQTY7.
      S0110-EXPQTY8 = GS_DISPLAY-PLANQTY8.
      S0110-EXPQTY9 = GS_DISPLAY-PLANQTY9.
      S0110-EXPQTY10 = GS_DISPLAY-PLANQTY10.
      S0110-EXPQTY11 = GS_DISPLAY-PLANQTY11.
      S0110-EXPQTY12 = GS_DISPLAY-PLANQTY12.

      DATA: LV_YEAR    TYPE NUMC4,
            LV_LASTDAY TYPE DATS.
      LV_YEAR = SY-DATUM+0(4).

      CASE SY-DATUM+4(2).
        WHEN '1'.
          S0110-EXPSDATE1 =  SY-DATUM.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE1
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE1.
          CONCATENATE LV_YEAR '0201' INTO S0110-EXPSDATE2.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE2
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE2.
          CONCATENATE LV_YEAR '0301' INTO S0110-EXPSDATE3.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE3
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE3.
          CONCATENATE LV_YEAR '0401' INTO S0110-EXPSDATE4.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE4
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE4.
          CONCATENATE LV_YEAR '0501' INTO S0110-EXPSDATE5.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE5
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE5.
          CONCATENATE LV_YEAR '0601' INTO S0110-EXPSDATE6.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE6
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE6.
          CONCATENATE LV_YEAR '0701' INTO S0110-EXPSDATE7.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE7
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE7.
          CONCATENATE LV_YEAR '0801' INTO S0110-EXPSDATE8.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE8
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE8.
          CONCATENATE LV_YEAR '0901' INTO S0110-EXPSDATE9.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE9
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE9.
          CONCATENATE LV_YEAR '1001' INTO S0110-EXPSDATE10.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE10
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE10.
          CONCATENATE LV_YEAR '1101' INTO S0110-EXPSDATE11.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE11
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE11.
          CONCATENATE LV_YEAR '1201' INTO S0110-EXPSDATE12.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE12
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE12.
        WHEN '2'.
          CONCATENATE LV_YEAR '0101' INTO S0110-EXPSDATE1.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE1
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE1.
          S0110-EXPSDATE2 =  SY-DATUM.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE2
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE2.
          CONCATENATE LV_YEAR '0301' INTO S0110-EXPSDATE3.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE3
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE3.
          CONCATENATE LV_YEAR '0401' INTO S0110-EXPSDATE4.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE4
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE4.
          CONCATENATE LV_YEAR '0501' INTO S0110-EXPSDATE5.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE5
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE5.
          CONCATENATE LV_YEAR '0601' INTO S0110-EXPSDATE6.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE6
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE6.
          CONCATENATE LV_YEAR '0701' INTO S0110-EXPSDATE7.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE7
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE7.
          CONCATENATE LV_YEAR '0801' INTO S0110-EXPSDATE8.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE8
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE8.
          CONCATENATE LV_YEAR '0901' INTO S0110-EXPSDATE9.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE9
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE9.
          CONCATENATE LV_YEAR '1001' INTO S0110-EXPSDATE10.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE10
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE10.
          CONCATENATE LV_YEAR '1101' INTO S0110-EXPSDATE11.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE11
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE11.
          CONCATENATE LV_YEAR '1201' INTO S0110-EXPSDATE12.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE12
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE12.
        WHEN '3'.
          CONCATENATE LV_YEAR '0101' INTO S0110-EXPSDATE1.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE1
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE1.
          CONCATENATE LV_YEAR '0201' INTO S0110-EXPSDATE2.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE2
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE2.
          S0110-EXPSDATE3 =  SY-DATUM.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE3
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE3.
          CONCATENATE LV_YEAR '0401' INTO S0110-EXPSDATE4.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE4
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE4.
          CONCATENATE LV_YEAR '0501' INTO S0110-EXPSDATE5.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE5
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE5.
          CONCATENATE LV_YEAR '0601' INTO S0110-EXPSDATE6.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE6
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE6.
          CONCATENATE LV_YEAR '0701' INTO S0110-EXPSDATE7.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE7
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE7.
          CONCATENATE LV_YEAR '0801' INTO S0110-EXPSDATE8.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE8
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE8.
          CONCATENATE LV_YEAR '0901' INTO S0110-EXPSDATE9.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE9
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE9.
          CONCATENATE LV_YEAR '1001' INTO S0110-EXPSDATE10.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE10
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE10.
          CONCATENATE LV_YEAR '1101' INTO S0110-EXPSDATE11.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE11
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE11.
          CONCATENATE LV_YEAR '1201' INTO S0110-EXPSDATE12.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE12
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE12.
        WHEN '4'.
          CONCATENATE LV_YEAR '0101' INTO S0110-EXPSDATE1.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE1
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE1.
          CONCATENATE LV_YEAR '0201' INTO S0110-EXPSDATE2.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE2
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE2.
          CONCATENATE LV_YEAR '0301' INTO S0110-EXPSDATE3.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE3
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE3.
          S0110-EXPSDATE4 =  SY-DATUM.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE4
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE4.
          CONCATENATE LV_YEAR '0501' INTO S0110-EXPSDATE5.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE5
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE5.
          CONCATENATE LV_YEAR '0601' INTO S0110-EXPSDATE6.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE6
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE6.
          CONCATENATE LV_YEAR '0701' INTO S0110-EXPSDATE7.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE7
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE7.
          CONCATENATE LV_YEAR '0801' INTO S0110-EXPSDATE8.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE8
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE8.
          CONCATENATE LV_YEAR '0901' INTO S0110-EXPSDATE9.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE9
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE9.
          CONCATENATE LV_YEAR '1001' INTO S0110-EXPSDATE10.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE10
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE10.
          CONCATENATE LV_YEAR '1101' INTO S0110-EXPSDATE11.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE11
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE11.
          CONCATENATE LV_YEAR '1201' INTO S0110-EXPSDATE12.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE12
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE12.
        WHEN '5'.
          CONCATENATE LV_YEAR '0101' INTO S0110-EXPSDATE1.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE1
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE1.
          CONCATENATE LV_YEAR '0201' INTO S0110-EXPSDATE2.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE2
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE2.
          CONCATENATE LV_YEAR '0301' INTO S0110-EXPSDATE3.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE3
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE3.
          CONCATENATE LV_YEAR '0401' INTO S0110-EXPSDATE4.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE4
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE4.
          S0110-EXPSDATE5 =  SY-DATUM.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE5
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE5.
          CONCATENATE LV_YEAR '0601' INTO S0110-EXPSDATE6.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE6
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE6.
          CONCATENATE LV_YEAR '0701' INTO S0110-EXPSDATE7.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE7
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE7.
          CONCATENATE LV_YEAR '0801' INTO S0110-EXPSDATE8.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE8
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE8.
          CONCATENATE LV_YEAR '0901' INTO S0110-EXPSDATE9.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE9
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE9.
          CONCATENATE LV_YEAR '1001' INTO S0110-EXPSDATE10.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE10
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE10.
          CONCATENATE LV_YEAR '1101' INTO S0110-EXPSDATE11.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE11
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE11.
          CONCATENATE LV_YEAR '1201' INTO S0110-EXPSDATE12.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE12
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE12.
        WHEN '6'.
          CONCATENATE LV_YEAR '0101' INTO S0110-EXPSDATE1.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE1
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE1.
          CONCATENATE LV_YEAR '0201' INTO S0110-EXPSDATE2.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE2
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE2.
          CONCATENATE LV_YEAR '0301' INTO S0110-EXPSDATE3.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE3
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE3.
          CONCATENATE LV_YEAR '0401' INTO S0110-EXPSDATE4.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE4
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE4.
          CONCATENATE LV_YEAR '0501' INTO S0110-EXPSDATE5.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE5
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE5.
          S0110-EXPSDATE6 =  SY-DATUM.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE6
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE6.
          CONCATENATE LV_YEAR '0701' INTO S0110-EXPSDATE7.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE7
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE7.
          CONCATENATE LV_YEAR '0801' INTO S0110-EXPSDATE8.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE8
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE8.
          CONCATENATE LV_YEAR '0901' INTO S0110-EXPSDATE9.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE9
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE9.
          CONCATENATE LV_YEAR '1001' INTO S0110-EXPSDATE10.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE10
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE10.
          CONCATENATE LV_YEAR '1101' INTO S0110-EXPSDATE11.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE11
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE11.
          CONCATENATE LV_YEAR '1201' INTO S0110-EXPSDATE12.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE12
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE12.
        WHEN '7'.
          CONCATENATE LV_YEAR '0101' INTO S0110-EXPSDATE1.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE1
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE1.
          CONCATENATE LV_YEAR '0201' INTO S0110-EXPSDATE2.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE2
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE2.
          CONCATENATE LV_YEAR '0301' INTO S0110-EXPSDATE3.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE3
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE3.
          CONCATENATE LV_YEAR '0401' INTO S0110-EXPSDATE4.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE4
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE4.
          CONCATENATE LV_YEAR '0501' INTO S0110-EXPSDATE5.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE5
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE5.
          CONCATENATE LV_YEAR '0601' INTO S0110-EXPSDATE6.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE6
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE6.
          S0110-EXPSDATE7 =  SY-DATUM.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE7
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE7.
          CONCATENATE LV_YEAR '0801' INTO S0110-EXPSDATE8.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE8
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE8.
          CONCATENATE LV_YEAR '0901' INTO S0110-EXPSDATE9.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE9
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE9.
          CONCATENATE LV_YEAR '1001' INTO S0110-EXPSDATE10.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE10
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE10.
          CONCATENATE LV_YEAR '1101' INTO S0110-EXPSDATE11.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE11
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE11.
          CONCATENATE LV_YEAR '1201' INTO S0110-EXPSDATE12.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE12
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE12.
        WHEN '8'.
          CONCATENATE LV_YEAR '0101' INTO S0110-EXPSDATE1.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE1
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE1.
          CONCATENATE LV_YEAR '0201' INTO S0110-EXPSDATE2.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE2
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE2.
          CONCATENATE LV_YEAR '0301' INTO S0110-EXPSDATE3.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE3
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE3.
          CONCATENATE LV_YEAR '0401' INTO S0110-EXPSDATE4.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE4
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE4.
          CONCATENATE LV_YEAR '0501' INTO S0110-EXPSDATE5.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE5
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE5.
          CONCATENATE LV_YEAR '0601' INTO S0110-EXPSDATE6.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE6
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE6.
          CONCATENATE LV_YEAR '0701' INTO S0110-EXPSDATE7.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE7
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE7.
          S0110-EXPSDATE8 =  SY-DATUM.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE8
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE8.
          CONCATENATE LV_YEAR '0901' INTO S0110-EXPSDATE9.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE9
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE9.
          CONCATENATE LV_YEAR '1001' INTO S0110-EXPSDATE10.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE10
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE10.
          CONCATENATE LV_YEAR '1101' INTO S0110-EXPSDATE11.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE11
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE11.
          CONCATENATE LV_YEAR '1201' INTO S0110-EXPSDATE12.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE12
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE12.
        WHEN '9'.
          CONCATENATE LV_YEAR '0101' INTO S0110-EXPSDATE1.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE1
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE1.
          CONCATENATE LV_YEAR '0201' INTO S0110-EXPSDATE2.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE2
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE2.
          CONCATENATE LV_YEAR '0301' INTO S0110-EXPSDATE3.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE3
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE3.
          CONCATENATE LV_YEAR '0401' INTO S0110-EXPSDATE4.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE4
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE4.
          CONCATENATE LV_YEAR '0501' INTO S0110-EXPSDATE5.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE5
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE5.
          CONCATENATE LV_YEAR '0601' INTO S0110-EXPSDATE6.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE6
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE6.
          CONCATENATE LV_YEAR '0701' INTO S0110-EXPSDATE7.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE7
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE7.
          CONCATENATE LV_YEAR '0801' INTO S0110-EXPSDATE8.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE8
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE8.
          S0110-EXPSDATE9 =  SY-DATUM.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE9
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE9.
          CONCATENATE LV_YEAR '1001' INTO S0110-EXPSDATE10.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE10
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE10.
          CONCATENATE LV_YEAR '1101' INTO S0110-EXPSDATE11.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE11
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE11.
          CONCATENATE LV_YEAR '1201' INTO S0110-EXPSDATE12.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE12
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE12.
        WHEN '10'.
          CONCATENATE LV_YEAR '0101' INTO S0110-EXPSDATE1.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE1
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE1.
          CONCATENATE LV_YEAR '0201' INTO S0110-EXPSDATE2.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE2
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE2.
          CONCATENATE LV_YEAR '0301' INTO S0110-EXPSDATE3.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE3
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE3.
          CONCATENATE LV_YEAR '0401' INTO S0110-EXPSDATE4.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE4
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE4.
          CONCATENATE LV_YEAR '0501' INTO S0110-EXPSDATE5.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE5
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE5.
          CONCATENATE LV_YEAR '0601' INTO S0110-EXPSDATE6.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE6
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE6.
          CONCATENATE LV_YEAR '0701' INTO S0110-EXPSDATE7.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE7
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE7.
          CONCATENATE LV_YEAR '0801' INTO S0110-EXPSDATE8.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE8
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE8.
          CONCATENATE LV_YEAR '0901' INTO S0110-EXPSDATE9.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE9
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE9.
          S0110-EXPSDATE10 =  SY-DATUM.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE10
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE10.
          CONCATENATE LV_YEAR '1101' INTO S0110-EXPSDATE11.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE11
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE11.
          CONCATENATE LV_YEAR '1201' INTO S0110-EXPSDATE12.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE12
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE12.
        WHEN '11'.
          CONCATENATE LV_YEAR '0101' INTO S0110-EXPSDATE1.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE1
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE1.
          CONCATENATE LV_YEAR '0201' INTO S0110-EXPSDATE2.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE2
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE2.
          CONCATENATE LV_YEAR '0301' INTO S0110-EXPSDATE3.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE3
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE3.
          CONCATENATE LV_YEAR '0401' INTO S0110-EXPSDATE4.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE4
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE4.
          CONCATENATE LV_YEAR '0501' INTO S0110-EXPSDATE5.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE5
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE5.
          CONCATENATE LV_YEAR '0601' INTO S0110-EXPSDATE6.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE6
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE6.
          CONCATENATE LV_YEAR '0701' INTO S0110-EXPSDATE7.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE7
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE7.
          CONCATENATE LV_YEAR '0801' INTO S0110-EXPSDATE8.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE8
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE8.
          CONCATENATE LV_YEAR '0901' INTO S0110-EXPSDATE9.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE9
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE9.
          CONCATENATE LV_YEAR '1001' INTO S0110-EXPSDATE10.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE10
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE10.
          S0110-EXPSDATE11 =  SY-DATUM.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE11
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE11.
          CONCATENATE LV_YEAR '1201' INTO S0110-EXPSDATE12.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE12
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE12.
        WHEN '12'.
          CONCATENATE LV_YEAR '0101' INTO S0110-EXPSDATE1.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE1
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE1.
          CONCATENATE LV_YEAR '0201' INTO S0110-EXPSDATE2.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE2
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE2.
          CONCATENATE LV_YEAR '0301' INTO S0110-EXPSDATE3.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE3
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE3.
          CONCATENATE LV_YEAR '0401' INTO S0110-EXPSDATE4.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE4
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE4.
          CONCATENATE LV_YEAR '0501' INTO S0110-EXPSDATE5.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE5
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE5.
          CONCATENATE LV_YEAR '0601' INTO S0110-EXPSDATE6.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE6
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE6.
          CONCATENATE LV_YEAR '0701' INTO S0110-EXPSDATE7.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE7
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE7.
          CONCATENATE LV_YEAR '0801' INTO S0110-EXPSDATE8.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE8
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE8.
          CONCATENATE LV_YEAR '0901' INTO S0110-EXPSDATE9.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE9
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE9.
          CONCATENATE LV_YEAR '1001' INTO S0110-EXPSDATE10.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE10
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE10.
          CONCATENATE LV_YEAR '1101' INTO S0110-EXPSDATE11.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE11
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE11.
          S0110-EXPSDATE12 =  SY-DATUM.
          CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
            EXPORTING
              DAY_IN            = S0110-EXPSDATE12
            IMPORTING
              LAST_DAY_OF_MONTH = S0110-EXPEDATE12.
      ENDCASE.


      S0110-UNIT  = GS_DISPLAY-MEINS.

      CALL SCREEN 0110 STARTING AT 50 5.

    ENDIF.


  ENDIF.



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

      READ TABLE GT_DISPLAY INTO GS_DISPLAY INDEX PS_ROW-INDEX.

      IF SY-SUBRC EQ 0.
        SELECT *
          FROM ZEA_AUFK AS A
          JOIN ZEA_MMT020 AS B ON B~MATNR EQ A~MATNR
                              AND B~SPRAS EQ SY-LANGU
          JOIN ZEA_T001W  AS C ON C~WERKS EQ A~WERKS
          INTO CORRESPONDING FIELDS OF TABLE GT_AUFK
          WHERE A~PLANID EQ GS_DISPLAY-PLANID
            AND A~MATNR  EQ GS_DISPLAY-MATNR.

        SELECT *
          FROM ZEA_PPT020 AS A
          JOIN ZEA_AUFK   AS B ON B~AUFNR EQ A~AUFNR
          JOIN ZEA_MMT020 AS C ON C~MATNR EQ A~MATNR
                              AND C~SPRAS EQ SY-LANGU
          JOIN ZEA_T001W  AS D ON D~WERKS EQ A~WERKS
          INTO CORRESPONDING FIELDS OF TABLE GT_PPT020
          WHERE B~PLANID EQ GS_DISPLAY-PLANID
            AND A~MATNR  EQ GS_DISPLAY-MATNR.

        PERFORM REFRESH_ALV_SPLIT_0100.

      ENDIF.

  ENDCASE.

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
  DATA LS_STABLE TYPE LVC_S_STBL.
  LS_STABLE-ROW = ABAP_ON.
  LS_STABLE-COL = ABAP_ON.

  " 적용된 Filter 기준으로 데이터를 출력
  CALL METHOD GO_ALV_GRID->REFRESH_TABLE_DISPLAY
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
*& Form FILTER_EXIST
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FILTER_EXIST .

  REFRESH GT_FILTER.

  CLEAR GS_FILTER.
  GS_FILTER-FIELDNAME = 'LIGHT'.
  GS_FILTER-SIGN      = 'I'.
  GS_FILTER-OPTION    = 'EQ'.
  GS_FILTER-LOW       = '3'.
  APPEND GS_FILTER TO GT_FILTER.

  PERFORM SET_ALV_FILTER.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FILTER_NO_EXIST
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FILTER_NO_EXIST .

  REFRESH GT_FILTER.

  CLEAR GS_FILTER.
  GS_FILTER-FIELDNAME = 'LIGHT'.
  GS_FILTER-SIGN      = 'I'.
  GS_FILTER-OPTION    = 'EQ'.
  GS_FILTER-LOW       = '2'.
  APPEND GS_FILTER TO GT_FILTER.

  PERFORM SET_ALV_FILTER.

ENDFORM.
