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
      SIDE      = CL_GUI_DOCKING_CONTAINER=>DOCK_AT_TOP     " Side to Which Control is Docked
      EXTENSION = 100              " Control Extension
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
  " 항공사 이름
  "  ㄴ 항공편
  SORT GT_HEADER BY CARRID CONNID.

  DATA LV_NODE_KEY_SUPER  TYPE N LENGTH 6.
  DATA LT_NODE_KEY_LEVEL  LIKE TABLE OF GV_NODE_KEY.

  GV_NODE_KEY += 1.
  CLEAR GS_NODE.
  GS_NODE-RELATKEY = SPACE. " 가장 최상위의 노드는 항상 공백이여야 한다.
  GS_NODE-NODE_KEY = LV_NODE_KEY_SUPER = GV_NODE_KEY.
  GS_NODE-ISFOLDER = ABAP_ON.
  GS_NODE-TEXT     = '항공사/항공편 노드'.
  GS_NODE-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
  APPEND GS_NODE TO GT_NODE.

  " 1레벨 생성
  INSERT LV_NODE_KEY_SUPER INTO LT_NODE_KEY_LEVEL INDEX 1.

  CLEAR GS_NODE_INFO.
  GS_NODE_INFO-CARRID = SPACE.
  GS_NODE_INFO-CONNID = SPACE.
  GS_NODE_INFO-NODE_KEY = GV_NODE_KEY.
  APPEND GS_NODE_INFO TO GT_NODE_INFO.

  LOOP AT GT_HEADER INTO GS_HEADER.
    AT NEW CARRNAME. " AT NEW 는 GT_HEADER에서 첫번째 필드부터 CARRNAME 필드까지의 값을 기준으로
      " 이전 데이터과 비교해서 신규 데이터일 경우에만 작동한다.

      " 폴더 노드 추가
      GV_NODE_KEY += 1.
      CLEAR GS_NODE.
      GS_NODE-RELATKEY = LV_NODE_KEY_SUPER.
      GS_NODE-NODE_KEY = LV_NODE_KEY_SUPER = GV_NODE_KEY.
      GS_NODE-ISFOLDER = ABAP_ON.
      GS_NODE-TEXT     = |{ GS_HEADER-CARRID } - { GS_HEADER-CARRNAME }|.
      GS_NODE-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
      APPEND GS_NODE TO GT_NODE.

      " 2레벨 생성
      INSERT LV_NODE_KEY_SUPER INTO LT_NODE_KEY_LEVEL INDEX 1.


      CLEAR GS_NODE_INFO.
      GS_NODE_INFO-CARRID = GS_HEADER-CARRID.
      GS_NODE_INFO-CONNID = SPACE.
      GS_NODE_INFO-NODE_KEY = GV_NODE_KEY.
      APPEND GS_NODE_INFO TO GT_NODE_INFO.

    ENDAT.

    IF GS_HEADER-CONNID IS NOT INITIAL.
      GV_NODE_KEY += 1.

      CLEAR GS_NODE.
      " 2레벨 노드를 상위노드로 지정
      GS_NODE-RELATKEY = LV_NODE_KEY_SUPER.
      GS_NODE-NODE_KEY = GV_NODE_KEY.
      GS_NODE-ISFOLDER = ABAP_OFF.
      GS_NODE-N_IMAGE  = ICON_FLIGHT.  " 비행기 모양의 아이콘
      GS_NODE-TEXT     = |{ GS_HEADER-CONNID }({ GS_HEADER-COUNTRYFR } > { GS_HEADER-COUNTRYTO })|.
      GS_NODE-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
      APPEND GS_NODE TO GT_NODE.

      CLEAR GS_NODE_INFO.
      GS_NODE_INFO-CARRID = GS_HEADER-CARRID.
      GS_NODE_INFO-CONNID = GS_HEADER-CONNID.
      GS_NODE_INFO-NODE_KEY = GV_NODE_KEY.
      APPEND GS_NODE_INFO TO GT_NODE_INFO.
    ELSE.
      " 항공편이 없는 경우
    ENDIF.

    AT END OF CARRNAME.

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

  SELECT FROM SCARR AS A LEFT JOIN SPFLI AS B ON B~CARRID EQ A~CARRID
  FIELDS A~CARRID,    A~CARRNAME, B~CONNID,
         B~COUNTRYFR, B~CITYFROM, B~AIRPFROM,
         B~COUNTRYTO, B~CITYTO,   B~AIRPTO
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

  RANGES: R_CARRID FOR GS_NODE_INFO-CARRID,
          R_CONNID FOR GS_NODE_INFO-CONNID,
          R_COUNTRY FOR GS_NODE_INFO-COUNTRYFR,
          R_CITYFROM FOR GS_NODE_INFO-CITYFROM.

  IF GS_NODE_INFO-CARRID IS NOT INITIAL.
    R_CARRID-SIGN = 'I'.
    R_CARRID-OPTION = 'EQ'.
    R_CARRID-LOW = GS_NODE_INFO-CARRID.
    APPEND R_CARRID.
  ENDIF.

  IF GS_NODE_INFO-CONNID IS NOT INITIAL.
    R_CONNID-SIGN = 'I'.
    R_CONNID-OPTION = 'EQ'.
    R_CONNID-LOW = GS_NODE_INFO-CONNID.
    APPEND R_CONNID.
  ENDIF.

  IF GS_NODE_INFO-COUNTRYFR IS NOT INITIAL.
    R_COUNTRY-SIGN = 'I'.
    R_COUNTRY-OPTION = 'EQ'.
    R_COUNTRY-LOW = GS_NODE_INFO-COUNTRYFR.
    APPEND R_COUNTRY.
  ENDIF.

  IF GS_NODE_INFO-CITYFROM IS NOT INITIAL.
    R_CITYFROM-SIGN = 'I'.
    R_CITYFROM-OPTION = 'EQ'.
    R_CITYFROM-LOW = GS_NODE_INFO-CITYFROM.
    APPEND R_CITYFROM.
  ENDIF.

  SELECT FROM SCARR    AS A
         JOIN SPFLI    AS B ON B~CARRID EQ A~CARRID
         JOIN SFLIGHT  AS C ON C~CARRID EQ A~CARRID
                           AND C~CONNID EQ B~CONNID
         FIELDS *
          WHERE A~CARRID     IN @R_CARRID
            AND B~CONNID     IN @R_CONNID
            AND B~COUNTRYFR  IN @R_COUNTRY
            AND B~CITYFROM   IN @R_CITYFROM
           INTO CORRESPONDING FIELDS OF TABLE @GT_DISPLAY.

  SORT GT_DISPLAY BY CARRID CONNID FLDATE.

  LOOP AT GT_DISPLAY INTO GS_DISPLAY.

    GS_DISPLAY-SEATSMAX_T = GS_DISPLAY-SEATSMAX + GS_DISPLAY-SEATSMAX_B + GS_DISPLAY-SEATSMAX_F.
    GS_DISPLAY-SEATSOCC_T = GS_DISPLAY-SEATSOCC + GS_DISPLAY-SEATSOCC_B + GS_DISPLAY-SEATSOCC_F.
    GS_DISPLAY-SEATSFRE_T = GS_DISPLAY-SEATSMAX_T - GS_DISPLAY-SEATSOCC_T.
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
      WHEN 'CARRID'
        OR 'CONNID'
        OR 'FLDATE'.
        GS_FIELDCAT-KEY = ABAP_ON.
        GS_FIELDCAT-JUST = 'C'.
      WHEN 'CARRNAME'.
        GS_FIELDCAT-EMPHASIZE = 'C500'.
      WHEN 'PAYMENTSUM'.
        GS_FIELDCAT-EMPHASIZE = 'C310'.
        GS_FIELDCAT-CFIELDNAME = 'CURRENCY'.
      WHEN 'PRICE'.
        GS_FIELDCAT-EMPHASIZE = 'C300'.
        GS_FIELDCAT-CFIELDNAME = 'CURRENCY'.
      WHEN 'SEATSMAX_T'
        OR 'SEATSOCC_T'
        OR 'SEATSFRE_T'.

        GS_FIELDCAT-COLTEXT = 'Total.' && GS_FIELDCAT-SCRTEXT_S.
        IF GS_FIELDCAT-FIELDNAME EQ 'SEATSFRE_T'.
          GS_FIELDCAT-COLTEXT = 'Total.Free'.
        ENDIF.
        GS_FIELDCAT-EMPHASIZE = 'C300'.

      WHEN 'COUNTRYFR'
        OR 'COUNTRYTO'
        OR 'AIRPFROM'
        OR 'AIRPTO'
        OR 'CURRENCY'.
        GS_FIELDCAT-JUST = 'C'.
    ENDCASE.

    MODIFY GT_FIELDCAT FROM GS_FIELDCAT.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_NODE_0100_2
*&---------------------------------------------------------------------*
FORM CREATE_NODE_0100_2 .

  " NODE를 아래와 같은 구성으로 만듦
  " 출발국가 1
  "  ㄴ 출발도시 2
  "       ㄴ 항공사 3
  "             ㄴ 항공편 4

  DATA: BEGIN OF LS_HEADER,
          COUNTRYFR LIKE SPFLI-COUNTRYFR,
          CITYFROM  LIKE SPFLI-CITYFROM,
          CARRID    LIKE SCARR-CARRID,
          CARRNAME  LIKE SCARR-CARRNAME,
          CONNID    LIKE SPFLI-CONNID,
          AIRPFROM  LIKE SPFLI-AIRPFROM,
          COUNTRYTO LIKE SPFLI-COUNTRYTO,
          CITYTO    LIKE SPFLI-CITYTO,
          AIRPTO    LIKE SPFLI-AIRPTO,
        END OF LS_HEADER,
        LT_HEADER LIKE TABLE OF LS_HEADER.


  LT_HEADER[] = CORRESPONDING #( GT_HEADER ).
  DELETE LT_HEADER WHERE COUNTRYFR IS INITIAL.

  SORT LT_HEADER BY COUNTRYFR CITYFROM CARRID CONNID.

  DATA LV_NODE_KEY_SUPER  TYPE N LENGTH 6.
  DATA LT_NODE_KEY_LEVEL  LIKE TABLE OF GV_NODE_KEY.

  GV_NODE_KEY += 1.
  CLEAR GS_NODE.
  GS_NODE-RELATKEY = SPACE. " 가장 최상위의 노드는 항상 공백이여야 한다.
  GS_NODE-NODE_KEY = LV_NODE_KEY_SUPER = GV_NODE_KEY.
  GS_NODE-ISFOLDER = ABAP_ON.
  GS_NODE-TEXT     = '출발국가/출발도시/항공사/항공편 노드'.
  GS_NODE-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
  APPEND GS_NODE TO GT_NODE.

  " 1레벨 생성
  INSERT LV_NODE_KEY_SUPER INTO LT_NODE_KEY_LEVEL INDEX 1.

  CLEAR GS_NODE_INFO.
  GS_NODE_INFO-CARRID = SPACE.
  GS_NODE_INFO-CONNID = SPACE.
  GS_NODE_INFO-COUNTRYFR = SPACE.
  GS_NODE_INFO-CITYFROM = SPACE.
  GS_NODE_INFO-NODE_KEY = GV_NODE_KEY.
  APPEND GS_NODE_INFO TO GT_NODE_INFO.

  LOOP AT LT_HEADER INTO LS_HEADER.
    AT NEW COUNTRYFR.

      " 폴더 노드 추가
      GV_NODE_KEY += 1.
      CLEAR GS_NODE.
      GS_NODE-RELATKEY = LV_NODE_KEY_SUPER.
      GS_NODE-NODE_KEY = LV_NODE_KEY_SUPER = GV_NODE_KEY.
      GS_NODE-ISFOLDER = ABAP_ON.
      GS_NODE-TEXT     = |{ LS_HEADER-COUNTRYFR }|.
      GS_NODE-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
      APPEND GS_NODE TO GT_NODE.

      " 2레벨 생성
      INSERT LV_NODE_KEY_SUPER INTO LT_NODE_KEY_LEVEL INDEX 1.


      CLEAR GS_NODE_INFO.
      GS_NODE_INFO-CARRID = SPACE.
      GS_NODE_INFO-CONNID = SPACE.
      GS_NODE_INFO-COUNTRYFR = LS_HEADER-COUNTRYFR.
      GS_NODE_INFO-CITYFROM = SPACE.
      GS_NODE_INFO-NODE_KEY = GV_NODE_KEY.
      APPEND GS_NODE_INFO TO GT_NODE_INFO.

    ENDAT.

    AT NEW CITYFROM.

      " 폴더 노드 추가
      GV_NODE_KEY += 1.
      CLEAR GS_NODE.
      GS_NODE-RELATKEY = LV_NODE_KEY_SUPER.
      GS_NODE-NODE_KEY = LV_NODE_KEY_SUPER = GV_NODE_KEY.
      GS_NODE-ISFOLDER = ABAP_ON.
      GS_NODE-TEXT     = |{ LS_HEADER-CITYFROM }|.
      GS_NODE-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
      APPEND GS_NODE TO GT_NODE.

      " 2레벨 생성
      INSERT LV_NODE_KEY_SUPER INTO LT_NODE_KEY_LEVEL INDEX 1.


      CLEAR GS_NODE_INFO.
      GS_NODE_INFO-CARRID = SPACE.
      GS_NODE_INFO-CONNID = SPACE.
      GS_NODE_INFO-COUNTRYFR = LS_HEADER-COUNTRYFR.
      GS_NODE_INFO-CITYFROM = LS_HEADER-CITYFROM.
      GS_NODE_INFO-NODE_KEY = GV_NODE_KEY.
      APPEND GS_NODE_INFO TO GT_NODE_INFO.

    ENDAT.

    AT NEW CARRNAME.

      " 폴더 노드 추가
      GV_NODE_KEY += 1.
      CLEAR GS_NODE.
      GS_NODE-RELATKEY = LV_NODE_KEY_SUPER.
      GS_NODE-NODE_KEY = LV_NODE_KEY_SUPER = GV_NODE_KEY.
      GS_NODE-ISFOLDER = ABAP_ON.
      GS_NODE-TEXT     = |{ LS_HEADER-CARRID } { LS_HEADER-CARRNAME }|.
      GS_NODE-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
      APPEND GS_NODE TO GT_NODE.

      " 2레벨 생성
      INSERT LV_NODE_KEY_SUPER INTO LT_NODE_KEY_LEVEL INDEX 1.


      CLEAR GS_NODE_INFO.
      GS_NODE_INFO-CARRID = LS_HEADER-CARRID.
      GS_NODE_INFO-CONNID = SPACE.
      GS_NODE_INFO-COUNTRYFR = LS_HEADER-COUNTRYFR.
      GS_NODE_INFO-CITYFROM = LS_HEADER-CITYFROM.
      GS_NODE_INFO-NODE_KEY = GV_NODE_KEY.
      APPEND GS_NODE_INFO TO GT_NODE_INFO.

    ENDAT.

    IF LS_HEADER-CONNID IS NOT INITIAL.
      GV_NODE_KEY += 1.

      CLEAR GS_NODE.
      " 2레벨 노드를 상위노드로 지정
      GS_NODE-RELATKEY = LV_NODE_KEY_SUPER.
      GS_NODE-NODE_KEY = GV_NODE_KEY.
      GS_NODE-ISFOLDER = ABAP_OFF.
      GS_NODE-N_IMAGE  = ICON_FLIGHT.  " 비행기 모양의 아이콘
      GS_NODE-TEXT     = |{ LS_HEADER-CONNID }({ LS_HEADER-COUNTRYFR } > { LS_HEADER-COUNTRYTO })|.
      GS_NODE-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
      APPEND GS_NODE TO GT_NODE.

      CLEAR GS_NODE_INFO.
      GS_NODE_INFO-CARRID = LS_HEADER-CARRID.
      GS_NODE_INFO-CONNID = LS_HEADER-CONNID.
      GS_NODE_INFO-COUNTRYFR = LS_HEADER-COUNTRYFR.
      GS_NODE_INFO-CITYFROM = LS_HEADER-CITYFROM.
      GS_NODE_INFO-NODE_KEY = GV_NODE_KEY.
      APPEND GS_NODE_INFO TO GT_NODE_INFO.
    ELSE.
      " 항공편이 없는 경우
    ENDIF.

    AT END OF CARRNAME.

      " 2레벨 제거 및 1레벨의 상위노드 정보 조회
      DELETE LT_NODE_KEY_LEVEL INDEX 1.
      READ TABLE LT_NODE_KEY_LEVEL INTO LV_NODE_KEY_SUPER INDEX 1.

    ENDAT.

    AT END OF CITYFROM.

      " 2레벨 제거 및 1레벨의 상위노드 정보 조회
      DELETE LT_NODE_KEY_LEVEL INDEX 1.
      READ TABLE LT_NODE_KEY_LEVEL INTO LV_NODE_KEY_SUPER INDEX 1.


    ENDAT.


    AT END OF COUNTRYFR.

      " 2레벨 제거 및 1레벨의 상위노드 정보 조회
      DELETE LT_NODE_KEY_LEVEL INDEX 1.
      READ TABLE LT_NODE_KEY_LEVEL INTO LV_NODE_KEY_SUPER INDEX 1.

    ENDAT.

  ENDLOOP.


ENDFORM.
