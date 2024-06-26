*&---------------------------------------------------------------------*
*& Include          YE03_EX008F02 : 2번째 객체용 서브루틴
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_2_0100
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT_2_0100 .

  CREATE OBJECT GO_CON_BOT
    EXPORTING
      CONTAINER_NAME = GC_CUSTOM_CONTAINER_NAME_BOT " Name of the Screen CustCtrl Name to Link Container To (CCON2)
    EXCEPTIONS
      OTHERS         = 1.

  IF SY-SUBRC <> 0.
    MESSAGE E020. " Container 생성 중 오류가 발생했습니다.
  ENDIF.

  CREATE OBJECT GO_SPLIT_BOT
    EXPORTING
      PARENT  = GO_CON_BOT " Parent Container
      ROWS    = 1          " Number of Rows to be displayed
      COLUMNS = 2          " Number of Columns to be Displayed
    EXCEPTIONS
      OTHERS  = 1.

  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
      WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  GO_SPLIT_BOT->SET_COLUMN_WIDTH(
    EXPORTING
      ID                = 1                 " Column ID
      WIDTH             = 17                " NPlWidth
  ).

  GO_CON_BOT_TREE = GO_SPLIT_BOT->GET_CONTAINER( ROW = 1 COLUMN = 1 ).
  GO_CON_BOT_GRID = GO_SPLIT_BOT->GET_CONTAINER( ROW = 1 COLUMN = 2 ).



  PERFORM CREATE_OBJECT_2_TREE.
  PERFORM CREATE_OBJECT_2_ALV.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_2_TREE
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT_2_TREE .

  CREATE OBJECT GO_SIMPLE_TREE2
    EXPORTING
      PARENT              = GO_CON_BOT_TREE " Parent Container
      NODE_SELECTION_MODE = CL_GUI_SIMPLE_TREE=>NODE_SEL_MODE_SINGLE
    EXCEPTIONS
      OTHERS              = 1.

  IF SY-SUBRC <> 0.
    MESSAGE E021. " TREE 객체 생성 중 오류가 발생했습니다.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_2_ALV
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT_2_ALV .

  CREATE OBJECT GO_ALV_GRID_BOT
    EXPORTING
      I_PARENT = GO_CON_BOT_GRID " Parent Container
    EXCEPTIONS
      OTHERS   = 1.

  IF SY-SUBRC <> 0.
    MESSAGE E021. " ALV 객체 생성 중 오류가 발생했습니다.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_NODE_0100_2
*&---------------------------------------------------------------------*
FORM CREATE_NODE_0100_2 .

  " NODE를 아래와 같은 구성으로 만듦
  " 회사코드 1
  "  ㄴ 플랜트명 2
  "     ㄴ 년도 3
  "       ㄴ 자재명 4
  SORT GT_HEADER2 BY PDPDAT BUKRS WERKS MATNR.

  DATA LV_NODE_KEY_SUPER  TYPE N LENGTH 6.
  DATA LT_NODE_KEY_LEVEL  LIKE TABLE OF GV_NODE_KEY2.
  DATA LV_BUTXT TYPE C LENGTH 25.

  GV_NODE_KEY2 += 1.
  CLEAR GS_NODE2.
  GS_NODE2-RELATKEY = SPACE. " 가장 최상위의 노드는 항상 공백이여야 한다.
  GS_NODE2-NODE_KEY = LV_NODE_KEY_SUPER = GV_NODE_KEY2.
  GS_NODE2-ISFOLDER = ABAP_ON.
  GS_NODE2-TEXT     = '생산년도/회사코드/플랜트/자재명'.
  GS_NODE2-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
  APPEND GS_NODE2 TO GT_NODE2.

*  " 1레벨 생성
  INSERT LV_NODE_KEY_SUPER INTO LT_NODE_KEY_LEVEL INDEX 1.

  CLEAR GS_NODE_INFO2.
  GS_NODE_INFO2-PDPDAT = SPACE.
  GS_NODE_INFO2-BUKRS = SPACE.
  GS_NODE_INFO2-WERKS = SPACE.
  GS_NODE_INFO2-MATNR = SPACE.
  GS_NODE_INFO2-NODE_KEY = GV_NODE_KEY2.
  APPEND GS_NODE_INFO2 TO GT_NODE_INFO2.
*
  LOOP AT GT_HEADER2 INTO GS_HEADER2.
    AT NEW PDPDAT. " AT NEW 는 GT_HEADER에서 첫번째 필드부터 BUKRS 필드까지의 값을 기준으로
      " 이전 데이터과 비교해서 신규 데이터일 경우에만 작동한다.

      " 폴더 노드 추가
      GV_NODE_KEY2 += 1.
      CLEAR GS_NODE2.
      GS_NODE2-RELATKEY = LV_NODE_KEY_SUPER.
      GS_NODE2-NODE_KEY = LV_NODE_KEY_SUPER = GV_NODE_KEY2.
      GS_NODE2-ISFOLDER = ABAP_ON.
      GS_NODE2-TEXT     = |{ GS_HEADER2-PDPDAT }년 생산계획|.
      GS_NODE2-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
      APPEND GS_NODE2 TO GT_NODE2.
*
      " 2레벨 생성
      INSERT LV_NODE_KEY_SUPER INTO LT_NODE_KEY_LEVEL INDEX 1.

      CLEAR GS_NODE_INFO2.
      GS_NODE_INFO2-PDPDAT = GS_HEADER2-PDPDAT.
      GS_NODE_INFO2-BUKRS  = SPACE.
      GS_NODE_INFO2-WERKS  = SPACE.
      GS_NODE_INFO2-MATNR  = SPACE.
      GS_NODE_INFO2-NODE_KEY = GV_NODE_KEY2.
      APPEND GS_NODE_INFO2 TO GT_NODE_INFO2.

    ENDAT.

    AT NEW BUKRS.

      SELECT SINGLE BUTXT
        FROM ZEA_FIT000
        INTO LV_BUTXT
        WHERE BUKRS EQ GS_HEADER2-BUKRS.

      " 폴더 노드 추가
      GV_NODE_KEY2 += 1.
      CLEAR GS_NODE2.
      GS_NODE2-RELATKEY = LV_NODE_KEY_SUPER.
      GS_NODE2-NODE_KEY = LV_NODE_KEY_SUPER = GV_NODE_KEY2.
      GS_NODE2-ISFOLDER = ABAP_ON.
      GS_NODE2-TEXT     = |{ GS_HEADER2-BUKRS } - { LV_BUTXT }|.
      GS_NODE2-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
      APPEND GS_NODE2 TO GT_NODE2.

      " 2레벨 생성
      INSERT LV_NODE_KEY_SUPER INTO LT_NODE_KEY_LEVEL INDEX 1.


      CLEAR GS_NODE_INFO2.
      GS_NODE_INFO2-PDPDAT = GS_HEADER2-PDPDAT.
      GS_NODE_INFO2-BUKRS = GS_HEADER2-BUKRS.
      GS_NODE_INFO2-WERKS = SPACE.
      GS_NODE_INFO2-MATNR = SPACE.
      GS_NODE_INFO2-NODE_KEY = GV_NODE_KEY2.
      APPEND GS_NODE_INFO2 TO GT_NODE_INFO2.

    ENDAT.

*    ON CHANGE OF GS_HEADER2-WERKS.
    AT NEW PNAME1.

      " 폴더 노드 추가
      GV_NODE_KEY2 += 1.
      CLEAR GS_NODE2.
      GS_NODE2-RELATKEY = LV_NODE_KEY_SUPER.
      GS_NODE2-NODE_KEY = LV_NODE_KEY_SUPER = GV_NODE_KEY2.
      GS_NODE2-ISFOLDER = ABAP_ON.
      GS_NODE2-TEXT     = |{ GS_HEADER2-WERKS } : { GS_HEADER2-PNAME1 } |.
      GS_NODE2-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
      APPEND GS_NODE2 TO GT_NODE2.

      " 4레벨 생성
      INSERT LV_NODE_KEY_SUPER INTO LT_NODE_KEY_LEVEL INDEX 1.


      CLEAR GS_NODE_INFO2.
      GS_NODE_INFO2-PDPDAT = GS_HEADER2-PDPDAT.
      GS_NODE_INFO2-BUKRS = GS_HEADER2-BUKRS.
      GS_NODE_INFO2-WERKS = GS_HEADER2-WERKS.
      GS_NODE_INFO2-MATNR = SPACE.
      GS_NODE_INFO2-NODE_KEY = GV_NODE_KEY2.
      APPEND GS_NODE_INFO2 TO GT_NODE_INFO2.

*    ENDON.
    ENDAT.

    IF GS_HEADER2-MATNR IS NOT INITIAL.
      GV_NODE_KEY2 += 1.

      CLEAR GS_NODE2.
      " 2레벨 노드를 상위노드로 지정
      GS_NODE2-RELATKEY = LV_NODE_KEY_SUPER.
      GS_NODE2-NODE_KEY = GV_NODE_KEY2.
      GS_NODE2-ISFOLDER = ABAP_OFF.
      GS_NODE2-N_IMAGE  =  ICON_CAR.  " 자동차 모양 아이콘
      GS_NODE2-TEXT     = |{ GS_HEADER2-MATNR } - { GS_HEADER2-MAKTX } |.
      GS_NODE2-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
      APPEND GS_NODE2 TO GT_NODE2.

      CLEAR GS_NODE_INFO2.
      GS_NODE_INFO2-PDPDAT = GS_HEADER2-PDPDAT.
      GS_NODE_INFO2-BUKRS = GS_HEADER2-BUKRS.
      GS_NODE_INFO2-WERKS = GS_HEADER2-WERKS.
      GS_NODE_INFO2-MATNR = GS_HEADER2-MATNR.
      GS_NODE_INFO2-NODE_KEY = GV_NODE_KEY2.
      APPEND GS_NODE_INFO2 TO GT_NODE_INFO2.
    ELSE.
      " 자재코드가 없는 경우
    ENDIF.

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

    AT END OF PDPDAT.

      " 2레벨 제거 및 1레벨의 상위노드 정보 조회
      DELETE LT_NODE_KEY_LEVEL INDEX 1.
      READ TABLE LT_NODE_KEY_LEVEL INTO LV_NODE_KEY_SUPER INDEX 1.

    ENDAT.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form EXPAND_ROOT_NODE_2_0100
*&---------------------------------------------------------------------*
FORM EXPAND_ROOT_NODE_2_0100 .

  GO_SIMPLE_TREE2->EXPAND_ROOT_NODES(
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
*& Form SET_TREE_EVENT_2_0100
*&---------------------------------------------------------------------*
FORM SET_TREE_EVENT_2_0100 .

  DATA LT_EVENT TYPE CNTL_SIMPLE_EVENTS.
  DATA LS_EVENT LIKE LINE OF LT_EVENT.

  CLEAR LS_EVENT.
  LS_EVENT-APPL_EVENT = ABAP_ON.
  LS_EVENT-EVENTID    = CL_GUI_SIMPLE_TREE=>EVENTID_NODE_DOUBLE_CLICK.
  APPEND LS_EVENT TO LT_EVENT.

  CALL METHOD GO_SIMPLE_TREE2->SET_REGISTERED_EVENTS
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

  SET HANDLER LCL_EVENT_HANDLER=>ON_NODE_DOUBLE_CLICK2 FOR GO_SIMPLE_TREE2.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_LAYOUT_2_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_LAYOUT_2_0100 .

  CLEAR GS_LAYOUT2.

  GS_LAYOUT2-ZEBRA = ABAP_ON.
  GS_LAYOUT2-CWIDTH_OPT = 'A'. " Always
  GS_LAYOUT2-SEL_MODE = 'D'.
  GS_LAYOUT2-GRID_TITLE = TEXT-T02.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FIELDCAT_2_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_FIELDCAT_2_0100 .

  PERFORM GET_FIELDCAT_2_0100 USING  GT_DISPLAY2
                                     GT_FIELDCAT2.

  PERFORM SET_FIELDCAT_2_0100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_FIELDCAT_2_0100
*&---------------------------------------------------------------------*
FORM GET_FIELDCAT_2_0100  USING PT_DISPLAY  TYPE STANDARD TABLE
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
*& Form SET_FIELDCAT_2_0100
*&---------------------------------------------------------------------*
FORM SET_FIELDCAT_2_0100 .

  LOOP AT GT_FIELDCAT2 INTO GS_FIELDCAT2.
    CASE GS_FIELDCAT2-FIELDNAME.
      WHEN 'PLANID'
        OR 'PLANINDEX'.
        GS_FIELDCAT2-KEY = ABAP_ON.
        GS_FIELDCAT2-JUST = 'C'.
      WHEN 'WERKS'
        OR 'PNAME1'
        OR 'MATNR'
        OR 'MAKTX'
        OR 'BOMID'.
        GS_FIELDCAT2-EMPHASIZE = 'C500'.
        GS_FIELDCAT2-JUST = 'C'.
      WHEN 'PLANQTY1'
        OR 'PLANQTY2'  OR 'PLANQTY3'
        OR 'PLANQTY4'  OR 'PLANQTY5'
        OR 'PLANQTY6'  OR 'PLANQTY7'
        OR 'PLANQTY8'  OR 'PLANQTY9'
        OR 'PLANQTY10' OR 'PLANQTY11'
        OR 'PLANQTY12'.
        GS_FIELDCAT2-QFIELDNAME = 'MEINS'.
      WHEN 'TOTAL'.
        GS_FIELDCAT2-COLTEXT    = '총 생산량'.
        GS_FIELDCAT2-QFIELDNAME = 'MEINS'.
        GS_FIELDCAT2-EMPHASIZE  = 'C300'.
      WHEN 'LOEKZ'.
        GS_FIELDCAT2-COLTEXT    = '삭제 여부'.
        GS_FIELDCAT2-JUST = 'C'.
      WHEN 'PDPDAT'.
        GS_FIELDCAT2-COLTEXT    = '생산연도'.
        GS_FIELDCAT2-JUST = 'C'.
      WHEN 'STATUS'.
        GS_FIELDCAT2-COLTEXT    = '삭제여부'.
        GS_FIELDCAT2-JUST = 'C'.
*      WHEN 'LIGHT'.
*        GS_FIELDCAT2-NO_OUT = ABAP_ON.
    ENDCASE.
    MODIFY GT_FIELDCAT2 FROM GS_FIELDCAT2.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_EVENT_2_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_EVENT_2_0100 .

  SET HANDLER LCL_EVENT_HANDLER=>ON_TOOLBAR2 FOR GO_ALV_GRID_BOT.
  SET HANDLER LCL_EVENT_HANDLER=>ON_USER_COMMAND FOR GO_ALV_GRID_BOT.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_2_0100
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV_2_0100 .

  GS_VARIANT-REPORT = SY-REPID.
  GS_VARIANT-HANDLE = 'H'.
  GV_SAVE = 'A'.
  GS_VARIANT-HANDLE = '0002'. " 프로그램 내 ALV 구별자

  GO_ALV_GRID_BOT->SET_TABLE_FOR_FIRST_DISPLAY(
    EXPORTING
      IS_VARIANT                    = GS_VARIANT  " Layout
      I_SAVE                        = GV_SAVE     " Save Layout
      IS_LAYOUT                     = GS_LAYOUT2   " Layout
    CHANGING
      IT_OUTTAB                     = GT_DISPLAY2  " Output Table
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


ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_NODE_DOUBLE_CLICK2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> NODE_KEY
*&      --> SENDER
*&---------------------------------------------------------------------*
FORM HANDLE_NODE_DOUBLE_CLICK2  USING PV_NODE_KEY TYPE MTREESNODE-NODE_KEY
                                      PV_SENDER   TYPE REF TO CL_GUI_SIMPLE_TREE.

  IF GO_ALV_GRID_BOT IS INITIAL.
    " 출력할 ALV가 없습니다.
    MESSAGE S000 DISPLAY LIKE 'E' WITH TEXT-E01.
    EXIT.
  ENDIF.

  READ TABLE GT_NODE_INFO2 INTO GS_NODE_INFO2
                           WITH KEY NODE_KEY = PV_NODE_KEY
                                    BINARY SEARCH.

  CHECK SY-SUBRC EQ 0.

  RANGES: R_PDPDAT      FOR GS_NODE_INFO2-PDPDAT,
          R_BUKRS       FOR GS_NODE_INFO2-BUKRS,
          R_WERKS       FOR GS_NODE_INFO2-WERKS,
          R_MATNR       FOR GS_NODE_INFO2-MATNR.

  IF GS_NODE_INFO2-PDPDAT IS NOT INITIAL.
    R_PDPDAT-SIGN = 'I'.
    R_PDPDAT-OPTION = 'EQ'.
    R_PDPDAT-LOW = GS_NODE_INFO2-PDPDAT.
    APPEND R_PDPDAT.
  ENDIF.

  IF GS_NODE_INFO2-BUKRS IS NOT INITIAL.
    R_BUKRS-SIGN = 'I'.
    R_BUKRS-OPTION = 'EQ'.
    R_BUKRS-LOW = GS_NODE_INFO2-BUKRS.
    APPEND R_BUKRS.
  ENDIF.

  IF GS_NODE_INFO2-WERKS IS NOT INITIAL.
    R_WERKS-SIGN = 'I'.
    R_WERKS-OPTION = 'EQ'.
    R_WERKS-LOW = GS_NODE_INFO2-WERKS.
    APPEND R_WERKS.
  ENDIF.

  IF GS_NODE_INFO2-MATNR IS NOT INITIAL.
    R_MATNR-SIGN = 'I'.
    R_MATNR-OPTION = 'EQ'.
    R_MATNR-LOW = GS_NODE_INFO2-MATNR.
    APPEND R_MATNR.
  ENDIF.


  SELECT FROM ZEA_PPT010  AS A
         JOIN ZEA_T001W   AS B ON B~WERKS EQ A~WERKS
         JOIN ZEA_MMT020  AS C ON C~MATNR EQ A~MATNR
                              AND C~SPRAS EQ @SY-LANGU
         JOIN ZEA_PLAF    AS D ON D~PLANID EQ A~PLANID
       FIELDS A~PLANID, A~PLANINDEX, D~PDPDAT, A~WERKS, B~PNAME1, A~MATNR, C~MAKTX,
              A~BOMID, A~PLANQTY1, A~PLANQTY2, A~PLANQTY3, A~PLANQTY4, A~PLANQTY5,
              A~PLANQTY6, A~PLANQTY7, A~PLANQTY8, A~PLANQTY9, A~PLANQTY10, A~PLANQTY11,
              A~PLANQTY12, A~MEINS, A~LOEKZ
        WHERE  B~BUKRS    IN @R_BUKRS
          AND  A~WERKS    IN @R_WERKS
          AND  D~PDPDAT   IN @R_PDPDAT
          AND  A~MATNR    IN @R_MATNR
*          AND  A~MATNR    EQ '10000'
         INTO CORRESPONDING FIELDS OF TABLE @GT_DISPLAY2.

  SORT GT_DISPLAY2 BY PLANID MATNR PLANINDEX.

  LOOP AT GT_DISPLAY2 INTO GS_DISPLAY2.
    GS_DISPLAY2-TOTAL =  GS_DISPLAY2-PLANQTY1  +
                        GS_DISPLAY2-PLANQTY2  +
                        GS_DISPLAY2-PLANQTY3  +
                        GS_DISPLAY2-PLANQTY4  +
                        GS_DISPLAY2-PLANQTY5  +
                        GS_DISPLAY2-PLANQTY6  +
                        GS_DISPLAY2-PLANQTY7  +
                        GS_DISPLAY2-PLANQTY8  +
                        GS_DISPLAY2-PLANQTY9  +
                        GS_DISPLAY2-PLANQTY10 +
                        GS_DISPLAY2-PLANQTY11 +
                        GS_DISPLAY2-PLANQTY12.

    IF GS_DISPLAY2-LOEKZ EQ 'X'.
      GS_DISPLAY2-STATUS = ICON_LED_RED.
      GS_DISPLAY2-LIGHT = 1.
    ELSE.
      GS_DISPLAY2-STATUS = ICON_LED_GREEN.
      GS_DISPLAY2-LIGHT = 2.
    ENDIF.

    MODIFY GT_DISPLAY2 FROM GS_DISPLAY2.
  ENDLOOP.

  GO_ALV_GRID_BOT->REFRESH_TABLE_DISPLAY(
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
*& Form EDIT_ALV_FIELDCAT_2_0100
*&---------------------------------------------------------------------*
FORM EDIT_ALV_FIELDCAT_2_0100 .

*  DATA LV_YEAR TYPE C LENGTH 4.
*
*  CLEAR LV_YEAR.
*  CONCATENATE 'YEAR' ZEA_PLAF-PDPDAT INTO LV_YEAR.
*
*  DELETE GT_FIELDCAT2 INDEX 4.
*
*  CLEAR GS_FIELDCAT2.
*  GS_FIELDCAT2-REF_TABLE = 'ZEA_PLAF'.
*  GS_FIELDCAT2-FIELDNAME = LV_YEAR.  " 생산년도
*  APPEND GS_FIELDCAT2 TO GT_FIELDCAT2.
*
*  GO_ALV_GRID_BOT->SET_FRONTEND_FIELDCATALOG( GT_FIELDCAT2 ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CALC_MPS : 생산계획 계산
*&---------------------------------------------------------------------*
FORM CALC_MPS .

*  IF ZEA_PLAF-PDPDAT IS INITIAL OR ZEA_MMT010-MATNR IS INITIAL.
*    MESSAGE E000 WITH '생산년도 또는 자재코드를 입력해주세요'.
*    LEAVE TO SCREEN 0.
*  ELSE.
  CLEAR ZEA_SDT030.

  ZEA_PPT010-WERKS = '10000'.
  ZEA_T001W-PNAME1 = 'CDC'.
  ZEA_PLAF-PDPDAT  = ZEA_PLAF-PDPDAT.
  ZEA_SDT030-MEINS = 'PKG'.
*  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MOVE_DATA_TO_0110
*&---------------------------------------------------------------------*
FORM MOVE_DATA_TO_0110 .

  ZEA_PLAF-PDPDAT = GS_NODE_INFO-SP_YEAR.
  ZEA_PLAF-WERKS = '10000'.
  ZEA_T001W-PNAME1 = 'CDC'.
  ZEA_PLAF-ERNAM = SY-UNAME.
  ZEA_PLAF-ERDAT = SY-DATUM.
  ZEA_PLAF-ERZET = SY-UZEIT.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MMT020_F4_HELP
*&---------------------------------------------------------------------*
FORM MMT020_F4_HELP .

  DATA: LT_RETURN_TAB TYPE DDSHRETVAL OCCURS 0,
        LS_RETURN_TAB LIKE LINE OF LT_RETURN_TAB.

  DATA: LT_DSELC TYPE DSELC OCCURS 0,
        LS_DSELC LIKE LINE OF LT_DSELC.

  DATA: LS_VALUE  TYPE SEAHLPRES,
        LT_VALUE  TYPE TABLE OF SEAHLPRES,
        LS_FIELD  TYPE DFIES,
        LT_FIELDS TYPE TABLE OF DFIES.

  DATA: BEGIN OF LT020_MATNR OCCURS 0,
          MATNR TYPE ZEA_MMT010-MATNR,
          MAKTX TYPE ZEA_MMT020-MAKTX,
        END OF LT020_MATNR.

  DATA: LT_MAP TYPE TABLE OF DSELC WITH HEADER LINE.

  CLEAR : LT020_MATNR, LT020_MATNR[],
           LT_VALUE, LT_VALUE[],
           LT_FIELDS, LT_FIELDS[].

  SELECT MATNR MAKTX
    INTO TABLE LT020_MATNR
    FROM ZEA_MMT020 AS A
    WHERE A~MATNR LIKE '30%'
    AND SPRAS EQ SY-LANGU.

  SORT LT020_MATNR BY MATNR.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      RETFIELD        = 'MATNR'           " Name of return field in FIELD_TAB
      DYNPPROG        = SY-REPID          " Current program
      DYNPNR          = SY-DYNNR          " Screen number
*     DYNPROFIELD     = 'ZEA_MMT010-MATNR'
      WINDOW_TITLE    = '자재코드-자재명'        " Title for the hit list
      VALUE_ORG       = 'S'               " Value return: C: cell by cell, S: structured
    TABLES
*     FIELD_TAB       = LT_FIELDS[]
      VALUE_TAB       = LT020_MATNR[]                 " Table of values: entries cell by cell
      RETURN_TAB      = LT_RETURN_TAB[]
*     DYNPFLD_MAPPING = LT_MAP
    EXCEPTIONS
      PARAMETER_ERROR = 1                " Incorrect parameter
      NO_VALUES_FOUND = 2                " No values found
      OTHERS          = 3.

  IF SY-SUBRC EQ 0.
    READ TABLE LT_RETURN_TAB INTO LS_RETURN_TAB INDEX 1.
    IF SY-SUBRC EQ 0.
      ZEA_MMT010-MATNR = LS_RETURN_TAB-FIELDVAL.

      READ TABLE LT020_MATNR WITH KEY MATNR = ZEA_MMT010-MATNR BINARY SEARCH.
      IF SY-SUBRC EQ 0.
        ZEA_MMT010-MATNR        = LT020_MATNR-MATNR.
        ZEA_MMT020-MAKTX        = LT020_MATNR-MAKTX.
*        ZEA_MMT010-STPRS        = LT_MATNR-STPRS.
*        ZEA_SDT090-NETPR        = LT_MATNR-STPRS * 4.
*        ZEA_MMT010-WAERS        = LT_MATNR-WAERS.

        LEAVE SCREEN.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form INIT_DATA_0120
*&---------------------------------------------------------------------*
FORM INIT_DATA_0120 .

  DATA: LT_SDT030 TYPE TABLE OF ZEA_SDT030,
        LS_SDT030 LIKE LINE OF LT_SDT030.
*        LT_PPT010 TYPE TABLE OF ZEA_PPT010,
*        LS_PPT010 LIKE LINE OF LT_PPT010,
*        LT_PLAF   TYPE TABLE OF ZEA_PLAF,
*        LS_PLAF   LIKE LINE OF LT_PLAF.

  " 생산계획 헤더 + 아이템
  DATA: BEGIN OF LS_DATA,
          PLANID    TYPE ZEA_PLAF-PLANID,
          WERKS     TYPE ZEA_PLAF-WERKS,
          SAPNR     TYPE ZEA_PLAF-SAPNR,
          PDPDAT    TYPE ZEA_PLAF-PDPDAT,
          PLANINDEX TYPE ZEA_PPT010-PLANINDEX,
          BOMID     TYPE ZEA_PPT010-BOMID,
          MATNR     TYPE ZEA_PPT010-MATNR,
          PLANQTY1  TYPE ZEA_PPT010-PLANQTY1,
          PLANQTY2  TYPE ZEA_PPT010-PLANQTY2,
          PLANQTY3  TYPE ZEA_PPT010-PLANQTY3,
          PLANQTY4  TYPE ZEA_PPT010-PLANQTY4,
          PLANQTY5  TYPE ZEA_PPT010-PLANQTY5,
          PLANQTY6  TYPE ZEA_PPT010-PLANQTY6,
          PLANQTY7  TYPE ZEA_PPT010-PLANQTY7,
          PLANQTY8  TYPE ZEA_PPT010-PLANQTY8,
          PLANQTY9  TYPE ZEA_PPT010-PLANQTY9,
          PLANQTY10 TYPE ZEA_PPT010-PLANQTY10,
          PLANQTY11 TYPE ZEA_PPT010-PLANQTY11,
          PLANQTY12 TYPE ZEA_PPT010-PLANQTY12,
          MEINS     TYPE ZEA_PPT010-MEINS,
          LOEKZ     TYPE ZEA_PPT010-LOEKZ,
        END OF LS_DATA,
        LT_DATA LIKE TABLE OF LS_DATA.


*-- 생산계획 기본 값을 구하기 위해 아래와 같은 로직 수행
  SELECT FROM ZEA_SDT030
       FIELDS SPQTY1, SPQTY2, SPQTY3, SPQTY4, SPQTY5,
              SPQTY6, SPQTY7, SPQTY8, SPQTY9, SPQTY10,
              SPQTY11, SPQTY12, SP_YEAR, WERKS, MATNR
        WHERE MATNR EQ @ZEA_MMT010-MATNR
          AND SP_YEAR EQ @ZEA_PLAF-PDPDAT
        INTO CORRESPONDING FIELDS OF TABLE @LT_SDT030.

*  CLEAR ZEA_SDT030.

  LOOP AT LT_SDT030 INTO LS_SDT030.

    ZEA_SDT030-SPQTY1 = ZEA_SDT030-SPQTY1 + LS_SDT030-SPQTY1.
    ZEA_SDT030-SPQTY2 = ZEA_SDT030-SPQTY2 + LS_SDT030-SPQTY2.
    ZEA_SDT030-SPQTY3 = ZEA_SDT030-SPQTY3 + LS_SDT030-SPQTY3.
    ZEA_SDT030-SPQTY4 = ZEA_SDT030-SPQTY4 + LS_SDT030-SPQTY4.
    ZEA_SDT030-SPQTY5 = ZEA_SDT030-SPQTY5 + LS_SDT030-SPQTY5.
    ZEA_SDT030-SPQTY6 = ZEA_SDT030-SPQTY6 + LS_SDT030-SPQTY6.
    ZEA_SDT030-SPQTY7 = ZEA_SDT030-SPQTY7 + LS_SDT030-SPQTY7.
    ZEA_SDT030-SPQTY8 = ZEA_SDT030-SPQTY8 + LS_SDT030-SPQTY8.
    ZEA_SDT030-SPQTY9 = ZEA_SDT030-SPQTY9 + LS_SDT030-SPQTY9.
    ZEA_SDT030-SPQTY10 = ZEA_SDT030-SPQTY10 + LS_SDT030-SPQTY10.
    ZEA_SDT030-SPQTY11 = ZEA_SDT030-SPQTY11 + LS_SDT030-SPQTY11.
    ZEA_SDT030-SPQTY12 = ZEA_SDT030-SPQTY12 + LS_SDT030-SPQTY12.

  ENDLOOP.

  DATA: LV_PLANQTY1  TYPE P DECIMALS 3,
        LV_PLANQTY2  TYPE P DECIMALS 3,
        LV_PLANQTY3  TYPE P DECIMALS 3,
        LV_PLANQTY4  TYPE P DECIMALS 3,
        LV_PLANQTY5  TYPE P DECIMALS 3,
        LV_PLANQTY6  TYPE P DECIMALS 3,
        LV_PLANQTY7  TYPE P DECIMALS 3,
        LV_PLANQTY8  TYPE P DECIMALS 3,
        LV_PLANQTY9  TYPE P DECIMALS 3,
        LV_PLANQTY10 TYPE P DECIMALS 3,
        LV_PLANQTY11 TYPE P DECIMALS 3,
        LV_PLANQTY12 TYPE P DECIMALS 3.

  " 생산계획 기본값을 110%로 산정하여 미리 계산해놓음
  LV_PLANQTY1 = ( ZEA_SDT030-SPQTY1  * 10 ) / 100 + ZEA_SDT030-SPQTY1 .
  S0120-PLANQTY1 = TRUNC( LV_PLANQTY1 ).

  LV_PLANQTY2 = ( ZEA_SDT030-SPQTY2  * 10 ) / 100 + ZEA_SDT030-SPQTY2 .
  S0120-PLANQTY2 = TRUNC( LV_PLANQTY2 ).

  LV_PLANQTY3 = ( ZEA_SDT030-SPQTY3  * 10 ) / 100 + ZEA_SDT030-SPQTY3 .
  S0120-PLANQTY3 = TRUNC( LV_PLANQTY3 ).

  LV_PLANQTY4 = ( ZEA_SDT030-SPQTY4  * 10 ) / 100 + ZEA_SDT030-SPQTY4 .
  S0120-PLANQTY4 = TRUNC( LV_PLANQTY4 ).

  LV_PLANQTY5 = ( ZEA_SDT030-SPQTY5  * 10 ) / 100 + ZEA_SDT030-SPQTY5 .
  S0120-PLANQTY5 = TRUNC( LV_PLANQTY5 ).

  LV_PLANQTY6 = ( ZEA_SDT030-SPQTY6  * 10 ) / 100 + ZEA_SDT030-SPQTY6 .
  S0120-PLANQTY6 = TRUNC( LV_PLANQTY6 ).

  LV_PLANQTY7 = ( ZEA_SDT030-SPQTY7  * 10 ) / 100 + ZEA_SDT030-SPQTY7 .
  S0120-PLANQTY7 = TRUNC( LV_PLANQTY7 ).

  LV_PLANQTY8 = ( ZEA_SDT030-SPQTY8  * 10 ) / 100 + ZEA_SDT030-SPQTY8 .
  S0120-PLANQTY8 = TRUNC( LV_PLANQTY8 ).

  LV_PLANQTY9 = ( ZEA_SDT030-SPQTY9  * 10 ) / 100 + ZEA_SDT030-SPQTY9 .
  S0120-PLANQTY9 = TRUNC( LV_PLANQTY9 ).

  LV_PLANQTY10 = ( ZEA_SDT030-SPQTY10 * 10 ) / 100 + ZEA_SDT030-SPQTY10.
  S0120-PLANQTY10 = TRUNC( LV_PLANQTY10 ).

  LV_PLANQTY11 = ( ZEA_SDT030-SPQTY11 * 10 ) / 100 + ZEA_SDT030-SPQTY11.
  S0120-PLANQTY11 = TRUNC( LV_PLANQTY11 ).

  LV_PLANQTY12 = ( ZEA_SDT030-SPQTY12 * 10 ) / 100 + ZEA_SDT030-SPQTY12.
  S0120-PLANQTY12 = TRUNC( LV_PLANQTY12 ).

*-- 기본 디폴트 값은 판매계획 * 110%.
  " 하지만 선택한 자재, 플랜트, 생산년도를 만족하는 생산계획이 이미 존재하면,
  " 이전 생산계획의 값을 인풋 값으로 이전시킨다.
  SELECT FROM ZEA_PPT010 AS A
         JOIN ZEA_PLAF   AS B
           ON B~PLANID EQ A~PLANID
       FIELDS *
        WHERE A~MATNR  EQ @ZEA_MMT010-MATNR
          AND B~PDPDAT EQ @ZEA_PLAF-PDPDAT
          AND A~WERKS  EQ '10000'
          AND A~LOEKZ  NE 'X'
        ORDER BY A~PLANID DESCENDING
          INTO CORRESPONDING FIELDS OF TABLE @LT_DATA.

  READ TABLE LT_DATA INTO LS_DATA INDEX 1.

  IF LS_DATA-PLANQTY1 NE '0'.
    S0120-PLANQTY1 = LS_DATA-PLANQTY1.
    IF SY-DATUM+4(2) LE 1.
      S0120-1MONTH = ABAP_ON.
    ENDIF.
  ENDIF.
  IF ZEA_SDT030-SPQTY1 NE '0'.
    IF SY-DATUM+4(2) LE 1 .
      S0120-1MONTH = ABAP_ON.
    ENDIF.
  ENDIF.

  IF LS_DATA-PLANQTY2 NE '0'.
    S0120-PLANQTY2 = LS_DATA-PLANQTY2.
    IF SY-DATUM+4(2) LE 2.
      S0120-2MONTH = ABAP_ON.
    ENDIF.
  ENDIF.
  IF ZEA_SDT030-SPQTY2 NE '0'.
    IF SY-DATUM+4(2) LE 2 .
      S0120-2MONTH = ABAP_ON.
    ENDIF.
  ENDIF.

  IF LS_DATA-PLANQTY3 NE '0'.
    S0120-PLANQTY3 = LS_DATA-PLANQTY3.
    IF SY-DATUM+4(2) LE 3.
      S0120-3MONTH = ABAP_ON.
    ENDIF.
  ENDIF.
  IF ZEA_SDT030-SPQTY3 NE '0'.
    IF SY-DATUM+4(2) LE 3 .
      S0120-3MONTH = ABAP_ON.
    ENDIF.
  ENDIF.

  IF LS_DATA-PLANQTY4 NE '0'.
    S0120-PLANQTY4 = LS_DATA-PLANQTY4.
    IF SY-DATUM+4(2) LE 4.
      S0120-4MONTH = ABAP_ON.
    ENDIF.
  ENDIF.
  IF ZEA_SDT030-SPQTY4 NE '0'.
    IF SY-DATUM+4(2) LE 4 .
      S0120-4MONTH = ABAP_ON.
    ENDIF.
  ENDIF.


  IF LS_DATA-PLANQTY5 NE '0'.
    S0120-PLANQTY5 = LS_DATA-PLANQTY5.
    IF SY-DATUM+4(2) LE 5 .
      S0120-5MONTH = ABAP_ON.
    ENDIF.
  ENDIF.
  IF ZEA_SDT030-SPQTY5 NE '0'.
    IF SY-DATUM+4(2) LE 5 .
      S0120-5MONTH = ABAP_ON.
    ENDIF.
  ENDIF.

  IF LS_DATA-PLANQTY6 NE '0'.
    S0120-PLANQTY6 = LS_DATA-PLANQTY6.
    IF SY-DATUM+4(2) LE 6.
      S0120-6MONTH = ABAP_ON.
    ENDIF.
  ENDIF.
  IF ZEA_SDT030-SPQTY6 NE '0'.
    IF SY-DATUM+4(2) LE 6 .
      S0120-6MONTH = ABAP_ON.
    ENDIF.
  ENDIF.

  IF LS_DATA-PLANQTY7 NE '0'.
    S0120-PLANQTY7 = LS_DATA-PLANQTY7.
    IF SY-DATUM+4(2) LE 7.
      S0120-7MONTH = ABAP_ON.
    ENDIF.
  ENDIF.
  IF ZEA_SDT030-SPQTY7 NE '0'.
    IF SY-DATUM+4(2) LE 7.
      S0120-7MONTH = ABAP_ON.
    ENDIF.
  ENDIF.

  IF LS_DATA-PLANQTY8 NE '0'.
    S0120-PLANQTY8 = LS_DATA-PLANQTY8.
    IF SY-DATUM+4(2) LE 8.
      S0120-8MONTH = ABAP_ON.
    ENDIF.
  ENDIF.
  IF ZEA_SDT030-SPQTY8 NE '0'.
    IF SY-DATUM+4(2) LE 8.
      S0120-8MONTH = ABAP_ON.
    ENDIF.
  ENDIF.


  IF LS_DATA-PLANQTY9 NE '0'.
    S0120-PLANQTY9 = LS_DATA-PLANQTY9.
    IF SY-DATUM+4(2) LE 9.
      S0120-9MONTH = ABAP_ON.
    ENDIF.
  ENDIF.
  IF ZEA_SDT030-SPQTY9 NE '0'.
    IF SY-DATUM+4(2) LE 9.
      S0120-9MONTH = ABAP_ON.
    ENDIF.
  ENDIF.

  IF LS_DATA-PLANQTY10 NE '0'.
    S0120-PLANQTY10 = LS_DATA-PLANQTY10.
    IF SY-DATUM+4(2) LE 10.
      S0120-10MONTH = ABAP_ON.
    ENDIF.
  ENDIF.
  IF ZEA_SDT030-SPQTY10 NE '0'.
    IF SY-DATUM+4(2) LE 10.
      S0120-10MONTH = ABAP_ON.
    ENDIF.
  ENDIF.

  IF LS_DATA-PLANQTY11 NE '0'.
    S0120-PLANQTY11 = LS_DATA-PLANQTY11.
    IF SY-DATUM+4(2) LE 11.
      S0120-11MONTH = ABAP_ON.
    ENDIF.
  ENDIF.
  IF ZEA_SDT030-SPQTY11 NE '0'.
    IF SY-DATUM+4(2) LE 11.
      S0120-11MONTH = ABAP_ON.
    ENDIF.
  ENDIF.

  IF LS_DATA-PLANQTY12 NE '0'.
    S0120-PLANQTY12 = LS_DATA-PLANQTY12.
    IF SY-DATUM+4(2) LE 12.
      S0120-12MONTH = ABAP_ON.
    ENDIF.
  ENDIF.
  IF ZEA_SDT030-SPQTY12 NE '0'.
    IF SY-DATUM+4(2) LE 12.
      S0120-12MONTH = ABAP_ON.
    ENDIF.
  ENDIF.

  ZEA_PLAF-PDPLI = |{ ZEA_PLAF-PDPDAT }년도 { ZEA_T001W-PNAME1 } { ZEA_MMT020-MAKTX } 생산계획|.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHECK_DATA_0120
*&---------------------------------------------------------------------*
FORM CHECK_DATA_0120 .

*-- 판매계획의 수량이 0이면 해당 월의 입력창을 잠금.
  " 판매계획에 값이 있으면 입력창을 열어둠.
  " 판매계획에 값이 없으면 입력창이 잠겨있음
  " 생산계획에 0이 아닌 값이 있으면 열어둠.
  " 즉, 판매계획은 0이지만 생산계획이 이전에 만들어놓은 계획이 존재하여
*  " 인풋값에 값이 들어가 있으면 열어버림
  " 단 입력 날짜 기준 전 달이면 체크 표시를 할 수없게 잠금 (미구현)

*  IF ZEA_

  LOOP AT SCREEN.
    CASE SCREEN-NAME.
      WHEN 'S0120-PLANQTY1'.
        IF ZEA_SDT030-SPQTY1 IS NOT INITIAL OR S0120-PLANQTY1 NE '0'.
          SCREEN-INPUT = 1.
        ELSE.
          SCREEN-INPUT = 0.
        ENDIF.
      WHEN 'S0120-PLANQTY2'.
        IF ZEA_SDT030-SPQTY2 IS NOT INITIAL OR S0120-PLANQTY2 NE '0'.
          SCREEN-INPUT = 1.
        ELSE.
          SCREEN-INPUT = 0.
        ENDIF.
      WHEN 'S0120-PLANQTY3'.
        IF ZEA_SDT030-SPQTY3 IS NOT INITIAL OR S0120-PLANQTY3 NE '0'.
          SCREEN-INPUT = 1.
        ELSE.
          SCREEN-INPUT = 0.
        ENDIF.
      WHEN 'S0120-PLANQTY4'.
        IF ZEA_SDT030-SPQTY4 IS NOT INITIAL OR S0120-PLANQTY4 NE '0'.
          SCREEN-INPUT = 1.
        ELSE.
          SCREEN-INPUT = 0.
        ENDIF.
      WHEN 'S0120-PLANQTY5'.
        IF ZEA_SDT030-SPQTY5 IS NOT INITIAL OR S0120-PLANQTY5 NE '0'.
          SCREEN-INPUT = 1.
        ELSE.
          SCREEN-INPUT = 0.
        ENDIF.
      WHEN 'S0120-PLANQTY6'.
        IF ZEA_SDT030-SPQTY6 IS NOT INITIAL OR S0120-PLANQTY6 NE '0'.
          SCREEN-INPUT = 1.
        ELSE.
          SCREEN-INPUT = 0.
        ENDIF.
      WHEN 'S0120-PLANQTY7'.
        IF ZEA_SDT030-SPQTY7 IS NOT INITIAL OR S0120-PLANQTY7 NE '0'.
          SCREEN-INPUT = 1.
        ELSE.
          SCREEN-INPUT = 0.
        ENDIF.
      WHEN 'S0120-PLANQTY8'.
        IF ZEA_SDT030-SPQTY8 IS NOT INITIAL OR S0120-PLANQTY8 NE '0'.
          SCREEN-INPUT = 1.
        ELSE.
          SCREEN-INPUT = 0.
        ENDIF.
      WHEN 'S0120-PLANQTY9'.
        IF ZEA_SDT030-SPQTY9 IS NOT INITIAL OR S0120-PLANQTY9 NE '0'.
          SCREEN-INPUT = 1.
        ELSE.
          SCREEN-INPUT = 0.
        ENDIF.
      WHEN 'S0120-PLANQTY10'.
        IF ZEA_SDT030-SPQTY10 IS NOT INITIAL OR S0120-PLANQTY10 NE '0'.
          SCREEN-INPUT = 1.
        ELSE.
          SCREEN-INPUT = 0.
        ENDIF.
      WHEN 'S0120-PLANQTY11'.
        IF ZEA_SDT030-SPQTY11 IS NOT INITIAL OR S0120-PLANQTY11 NE '0'.
          SCREEN-INPUT = 1.
        ELSE.
          SCREEN-INPUT = 0.
        ENDIF.
      WHEN 'S0120-PLANQTY12'.
        IF ZEA_SDT030-SPQTY12 IS NOT INITIAL OR S0120-PLANQTY12 NE '0'.
          SCREEN-INPUT = 1.
        ELSE.
          SCREEN-INPUT = 0.
        ENDIF.
    ENDCASE.
    MODIFY SCREEN.
  ENDLOOP.

****-- 만약 입력하는 날짜 기준으로 전 월을 못수정하게 입력값과 체크박스를 막음
*  LOOP AT SCREEN.
*    CASE SCREEN-NAME.
*      WHEN 'S0120-1MONTH'.
*        IF SY-DATUM+4(2) > 1.
*          SCREEN-INPUT = 0.
*        ELSE.
*          SCREEN-INPUT = 1.
*        ENDIF.
*      WHEN 'S0120-2MONTH'.
*        IF SY-DATUM+4(2) > 2.
*          SCREEN-INPUT = 0.
*        ELSE.
*          SCREEN-INPUT = 1.
*        ENDIF.
*      WHEN 'S0120-3MONTH'.
*        IF SY-DATUM+4(2) > 3.
*          SCREEN-INPUT = 0.
*        ELSE.
*          SCREEN-INPUT = 1.
*        ENDIF.
*      WHEN 'S0120-4MONTH'.
*        IF SY-DATUM+4(2) > 4.
*          SCREEN-INPUT = 0.
*        ELSE.
*          SCREEN-INPUT = 1.
*        ENDIF.
*      WHEN 'S0120-5MONTH'.
*        IF SY-DATUM+4(2) > 5.
*          SCREEN-INPUT = 0.
*        ELSE.
*          SCREEN-INPUT = 1.
*        ENDIF.
*      WHEN 'S0120-6MONTH'.
*        IF SY-DATUM+4(2) > 6.
*          SCREEN-INPUT = 0.
*        ELSE.
*          SCREEN-INPUT = 1.
*        ENDIF.
*      WHEN 'S0120-7MONTH'.
*        IF SY-DATUM+4(2) > 7.
*          SCREEN-INPUT = 0.
*        ELSE.
*          SCREEN-INPUT = 1.
*        ENDIF.
*      WHEN 'S0120-8MONTH'.
*        IF SY-DATUM+4(2) > 8.
*          SCREEN-INPUT = 0.
*        ELSE.
*          SCREEN-INPUT = 1.
*        ENDIF.
*      WHEN 'S0120-9MONTH'.
*        IF SY-DATUM+4(2) > 9.
*          SCREEN-INPUT = 0.
*        ELSE.
*          SCREEN-INPUT = 1.
*        ENDIF.
*      WHEN 'S0120-10MONTH'.
*        IF SY-DATUM+4(2) > 10.
*          SCREEN-INPUT = 0.
*        ELSE.
*          SCREEN-INPUT = 1.
*        ENDIF.
*      WHEN 'S0120-11MONTH'.
*        IF SY-DATUM+4(2) > 11.
*          SCREEN-INPUT = 0.
*        ELSE.
*          SCREEN-INPUT = 1.
*        ENDIF.
*      WHEN 'S0120-12MONTH'.
*        IF SY-DATUM+4(2) > 12.
*          SCREEN-INPUT = 0.
*        ELSE.
*          SCREEN-INPUT = 1.
*        ENDIF.
*    ENDCASE.
*    MODIFY SCREEN.
*  ENDLOOP.


****-- 만약 입력하는 날짜 기준으로 전 월을 못수정하게 입력값과 체크박스를 막음
***  LOOP AT SCREEN.
***    CASE SCREEN-NAME.
***      WHEN 'S0120-1MONTH'.
***        IF SY-DATUM+4(2) < 1.
***          SCREEN-INPUT = 0.
***          LOOP AT SCREEN.
***            CASE SCREEN-NAME.
***              WHEN 'S0120-PLANQTY1'.
***                SCREEN-INPUT = 0.
***            ENDCASE.
***            MODIFY SCREEN.
***          ENDLOOP.
***        ENDIF.
***
***
***      WHEN 'S0120-2MONTH'.
***        IF SY-DATUM+4(2) < 2.
***          SCREEN-INPUT = 0.
***          LOOP AT SCREEN.
***            CASE SCREEN-NAME.
***              WHEN 'S0120-PLANQTY2'.
***                SCREEN-INPUT = 0.
***            ENDCASE.
***            MODIFY SCREEN.
***          ENDLOOP.
***        ENDIF.
***
***      WHEN 'S0120-3MONTH'.
***        IF SY-DATUM+4(2) < 3.
***          SCREEN-INPUT = 0.
***          LOOP AT SCREEN.
***            CASE SCREEN-NAME.
***              WHEN 'S0120-PLANQTY3'.
***                SCREEN-INPUT = 0.
***            ENDCASE.
***            MODIFY SCREEN.
***          ENDLOOP.
***        ENDIF.
***
***      WHEN 'S0120-4MONTH'.
***        IF SY-DATUM+4(2) < 4.
***          SCREEN-INPUT = 0.
***          LOOP AT SCREEN.
***            CASE SCREEN-NAME.
***              WHEN 'S0120-PLANQTY4'.
***                SCREEN-INPUT = 0.
***            ENDCASE.
***            MODIFY SCREEN.
***          ENDLOOP.
***        ENDIF.
***
***      WHEN 'S0120-5MONTH'.
***        IF SY-DATUM+4(2) < 5.
***          SCREEN-INPUT = 0.
***          LOOP AT SCREEN.
***            CASE SCREEN-NAME.
***              WHEN 'S0120-PLANQTY5'.
***                SCREEN-INPUT = 0.
***            ENDCASE.
***            MODIFY SCREEN.
***          ENDLOOP.
***        ENDIF.
***
***      WHEN 'S0120-6MONTH'.
***        IF SY-DATUM+4(2) < 6.
***          SCREEN-INPUT = 0.
***          LOOP AT SCREEN.
***            CASE SCREEN-NAME.
***              WHEN 'S0120-PLANQTY6'.
***                SCREEN-INPUT = 0.
***            ENDCASE.
***            MODIFY SCREEN.
***          ENDLOOP.
***        ENDIF.
***
***      WHEN 'S0120-7MONTH'.
***        IF SY-DATUM+4(2) < 7.
***          SCREEN-INPUT = 0.
***          LOOP AT SCREEN.
***            CASE SCREEN-NAME.
***              WHEN 'S0120-PLANQTY7'.
***                SCREEN-INPUT = 0.
***            ENDCASE.
***            MODIFY SCREEN.
***          ENDLOOP.
***        ENDIF.
***
***      WHEN 'S0120-8MONTH'.
***        IF SY-DATUM+4(2) < 8.
***          SCREEN-INPUT = 0.
***          LOOP AT SCREEN.
***            CASE SCREEN-NAME.
***              WHEN 'S0120-PLANQTY8'.
***                SCREEN-INPUT = 0.
***            ENDCASE.
***            MODIFY SCREEN.
***          ENDLOOP.
***        ENDIF.
***
***      WHEN 'S0120-9MONTH'.
***        IF SY-DATUM+4(2) < 9.
***          SCREEN-INPUT = 0.
***          LOOP AT SCREEN.
***            CASE SCREEN-NAME.
***              WHEN 'S0120-PLANQTY9'.
***                SCREEN-INPUT = 0.
***            ENDCASE.
***            MODIFY SCREEN.
***          ENDLOOP.
***        ENDIF.
***
***      WHEN 'S0120-10MONTH'.
***        IF SY-DATUM+4(2) < 10.
***          SCREEN-INPUT = 0.
***          LOOP AT SCREEN.
***            CASE SCREEN-NAME.
***              WHEN 'S0120-PLANQTY10'.
***                SCREEN-INPUT = 0.
***            ENDCASE.
***            MODIFY SCREEN.
***          ENDLOOP.
***        ENDIF.
***
***      WHEN 'S0120-11MONTH'.
***        IF SY-DATUM+4(2) < 11.
***          SCREEN-INPUT = 0.
***          LOOP AT SCREEN.
***            CASE SCREEN-NAME.
***              WHEN 'S0120-PLANQTY11'.
***                SCREEN-INPUT = 0.
***            ENDCASE.
***            MODIFY SCREEN.
***          ENDLOOP.
***        ENDIF.
***
***      WHEN 'S0120-12MONTH'.
***        IF SY-DATUM+4(2) < 12.
***          SCREEN-INPUT = 0.
***          LOOP AT SCREEN.
***            CASE SCREEN-NAME.
***              WHEN 'S0120-PLANQTY12'.
***                SCREEN-INPUT = 0.
***            ENDCASE.
***            MODIFY SCREEN.
***          ENDLOOP.
***        ENDIF.
***    ENDCASE.
***    MODIFY SCREEN.
***  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form OPEN_INPUT
*&---------------------------------------------------------------------*
FORM OPEN_INPUT .

*-- 판매계획의 수량이 0이면 해당 월의 입력창을 잠금.
  " 판매계획에 값이 있으면 입력창을 열어둠.
  " 판매계획에 값이 없으면 입력창이 잠겨있음
  " 생산계획에 0이 아닌 값이 있으면 열어둠.
  " 즉, 판매계획은 0이지만 생산계획이 이전에 만들어놓은 계획이 존재하여
  " 인풋값에 값이 들어가 있으면 열어버림
  " 잠겨있는 입력창도 체크 표시를 하면 열게 함
  " 단 입력 날짜 기준 전 달이면 체크 표시를 할 수없게 잠금 (미구현)

  LOOP AT SCREEN.
    CASE SCREEN-NAME.


      WHEN 'S0120-PLANQTY1' OR 'S0120-1MONTH'.
        IF ZEA_SDT030-SPQTY1 EQ 0 AND S0120-PLANQTY1 EQ 0
          OR SY-DATUM+4(2) GT 1.
          SCREEN-INPUT = 0.
        ELSE.
          SCREEN-INPUT = 1.
        ENDIF.
      WHEN 'S0120-PLANQTY2' OR 'S0120-2MONTH'.
        IF ZEA_SDT030-SPQTY2 EQ 0 AND S0120-PLANQTY2 EQ 0
          OR SY-DATUM+4(2) GT 2.
          SCREEN-INPUT = 0.
        ELSE.
          SCREEN-INPUT = 1.
        ENDIF.
      WHEN 'S0120-PLANQTY3' OR 'S0120-3MONTH'.
        IF ZEA_SDT030-SPQTY3 EQ 0 AND S0120-PLANQTY3 EQ 0
          OR SY-DATUM+4(2) GT 3.
          SCREEN-INPUT = 0.
        ELSE.
          SCREEN-INPUT = 1.
        ENDIF.
      WHEN 'S0120-PLANQTY4' OR 'S0120-4MONTH'.
        IF ZEA_SDT030-SPQTY4 EQ 0 AND S0120-PLANQTY4 EQ 0
          OR SY-DATUM+4(2) GT 4.
          SCREEN-INPUT = 0.
        ELSE.
          SCREEN-INPUT = 1.
        ENDIF.
      WHEN 'S0120-PLANQTY5' OR 'S0120-5MONTH'.
        IF ZEA_SDT030-SPQTY5 EQ 0 AND S0120-PLANQTY5 EQ 0
          OR SY-DATUM+4(2) GT 5.
          SCREEN-INPUT = 0.
        ELSE.
          SCREEN-INPUT = 1.
        ENDIF.
      WHEN 'S0120-PLANQTY6' OR 'S0120-6MONTH'.
        IF ZEA_SDT030-SPQTY6 EQ 0 AND S0120-PLANQTY6 EQ 0
          OR SY-DATUM+4(2) GT 6.
          SCREEN-INPUT = 0.
        ELSE.
          SCREEN-INPUT = 1.
        ENDIF.
      WHEN 'S0120-PLANQTY7' OR 'S0120-7MONTH'..
        IF ZEA_SDT030-SPQTY7 EQ 0 AND S0120-PLANQTY7 EQ 0
          OR SY-DATUM+4(2) GT 7.
          SCREEN-INPUT = 0.
        ELSE.
          SCREEN-INPUT = 1.
        ENDIF.
      WHEN 'S0120-PLANQTY8' OR 'S0120-8MONTH'.
        IF ZEA_SDT030-SPQTY8 EQ 0 AND S0120-PLANQTY8 EQ 0
          OR SY-DATUM+4(2) GT 8.
          SCREEN-INPUT = 0.
        ELSE.
          SCREEN-INPUT = 1.
        ENDIF.
      WHEN 'S0120-PLANQTY9' OR 'S0120-9MONTH'.
        IF ZEA_SDT030-SPQTY9 EQ 0 AND S0120-PLANQTY9 EQ 0
          OR SY-DATUM+4(2) GT 9.
          SCREEN-INPUT = 0.
        ELSE.
          SCREEN-INPUT = 1.
        ENDIF.
      WHEN 'S0120-PLANQTY10' OR 'S0120-10MONTH'.
        IF ZEA_SDT030-SPQTY10 EQ 0 AND S0120-PLANQTY10 EQ 0
          OR SY-DATUM+4(2) GT 10.
          SCREEN-INPUT = 0.
        ELSE.
          SCREEN-INPUT = 1.
        ENDIF.
      WHEN 'S0120-PLANQTY11' OR 'S0120-11MONTH'.
        IF ZEA_SDT030-SPQTY11 EQ 0 AND S0120-PLANQTY11 EQ 0
          OR SY-DATUM+4(2) GT 11.
          SCREEN-INPUT = 0.
        ELSE.
          SCREEN-INPUT = 1.
        ENDIF.
      WHEN 'S0120-PLANQTY12' OR 'S0120-12MONTH'.
        IF ZEA_SDT030-SPQTY12 EQ 0 AND S0120-PLANQTY12 EQ 0
          OR SY-DATUM+4(2) GT 12.
          SCREEN-INPUT = 0.
        ELSE.
          SCREEN-INPUT = 1.
        ENDIF.
    ENDCASE.
    MODIFY SCREEN.
  ENDLOOP.


* 체크박스를 클릭하면 잠겨있던 인풋 값이 열림.
  FIELD-SYMBOLS <FS>.

  DATA LV_CHECK TYPE C.

  LOOP AT SCREEN.
    CASE SCREEN-NAME+7(3).
      WHEN 'MON' OR '0MO' OR '1MO' OR '2MO'.
*        ASSIGN COMPONENT SCREEN-NAME+6 OF STRUCTURE S0110 TO <FS>.
*        IF SY-SUBRC EQ 0.
*          LV_CHECK = <FS>.
*          UNASSIGN <FS>.
*        ENDIF.

        ASSIGN (SCREEN-NAME) TO <FS>.
        IF <FS> IS ASSIGNED.
          GV_CHECK = <FS>.
          UNASSIGN <FS>.
        ENDIF.

      WHEN 'LAN'.
        IF GV_CHECK EQ ABAP_ON.
          SCREEN-INPUT = 1.
          MODIFY SCREEN.
        ELSE.

        ENDIF.
    ENDCASE.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SAVE_DATA
*&---------------------------------------------------------------------*
FORM SAVE_DATA_CREATE_NUMBER .

  DATA LV_SUBRC TYPE I.
  DATA LV_COUNT TYPE I.

  DATA: LS_PLAF   TYPE ZEA_PLAF,    " 생산계획 Header
        LS_PPT010 TYPE ZEA_PPT010,  " 생산계획 Item
        LV_PLANID TYPE ZEA_PLAF-PLANID, " 생산계획 ID
        LV_BOMID  TYPE ZEA_STKO-BOMID.

  " 한개라도 선택되어 있다면
  CHECK S0120-1MONTH  EQ ABAP_ON
     OR S0120-2MONTH  EQ ABAP_ON
     OR S0120-3MONTH  EQ ABAP_ON
     OR S0120-4MONTH  EQ ABAP_ON
     OR S0120-5MONTH  EQ ABAP_ON
     OR S0120-6MONTH  EQ ABAP_ON
     OR S0120-7MONTH  EQ ABAP_ON
     OR S0120-8MONTH  EQ ABAP_ON
     OR S0120-9MONTH  EQ ABAP_ON
     OR S0120-10MONTH EQ ABAP_ON
     OR S0120-11MONTH EQ ABAP_ON
     OR S0120-12MONTH EQ ABAP_ON.


  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      NR_RANGE_NR             = '01'                 " Number range number
      OBJECT                  = 'ZEA_PLANID'         " Name of number range object
    IMPORTING
      NUMBER                  = ZEA_PLAF-PLANID      " free number
    EXCEPTIONS
      INTERVAL_NOT_FOUND      = 1                " Interval not found
      NUMBER_RANGE_NOT_INTERN = 2                " Number range is not internal
      OBJECT_NOT_FOUND        = 3                " Object not defined in TNRO
      QUANTITY_IS_0           = 4                " Number of numbers requested must be > 0
      QUANTITY_IS_NOT_1       = 5                " Number of numbers requested must be 1
      INTERVAL_OVERFLOW       = 6                " Interval used up. Change not possible.
      BUFFER_OVERFLOW         = 7                " Buffer is full
      OTHERS                  = 8.

  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
      WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  ZEA_PLAF-PLANID(2) = 'PP'.
  ZEA_PLAF-PLANID+2(2) = SY-DATUM+2(2).
  ZEA_PPT010-PLANID = ZEA_PLAF-PLANID.


  SELECT SINGLE BOMID
    FROM ZEA_STKO
    WHERE MATNR EQ @ZEA_MMT010-MATNR
    INTO @LV_BOMID.

*-- 아이템 INSERT
  " 각 월의 생산계획이 체크되어 있을 경우
  IF S0120-1MONTH EQ ABAP_ON.
    LS_PPT010-PLANQTY1 = S0120-PLANQTY1.
  ENDIF.
  IF S0120-2MONTH EQ ABAP_ON.
    LS_PPT010-PLANQTY2 = S0120-PLANQTY2.
  ENDIF.
  IF S0120-3MONTH EQ ABAP_ON.
    LS_PPT010-PLANQTY3 = S0120-PLANQTY3.
  ENDIF.
  IF S0120-3MONTH EQ ABAP_ON.
    LS_PPT010-PLANQTY3 = S0120-PLANQTY3.
  ENDIF.
  IF S0120-4MONTH EQ ABAP_ON.
    LS_PPT010-PLANQTY4 = S0120-PLANQTY4.
  ENDIF.
  IF S0120-5MONTH EQ ABAP_ON.
    LS_PPT010-PLANQTY5 = S0120-PLANQTY5.
  ENDIF.
  IF S0120-6MONTH EQ ABAP_ON.
    LS_PPT010-PLANQTY6 = S0120-PLANQTY6.
  ENDIF.
  IF S0120-7MONTH EQ ABAP_ON.
    LS_PPT010-PLANQTY7 = S0120-PLANQTY7.
  ENDIF.
  IF S0120-8MONTH EQ ABAP_ON.
    LS_PPT010-PLANQTY8 = S0120-PLANQTY8.
  ENDIF.
  IF S0120-9MONTH EQ ABAP_ON.
    LS_PPT010-PLANQTY9 = S0120-PLANQTY9.
  ENDIF.
  IF S0120-10MONTH EQ ABAP_ON.
    LS_PPT010-PLANQTY10 = S0120-PLANQTY10.
  ENDIF.
  IF S0120-11MONTH EQ ABAP_ON.
    LS_PPT010-PLANQTY11 = S0120-PLANQTY11.
  ENDIF.
  IF S0120-12MONTH EQ ABAP_ON.
    LS_PPT010-PLANQTY12 = S0120-PLANQTY12.
  ENDIF.

  LS_PPT010-PLANID    = ZEA_PLAF-PLANID.  " 생산계획 ID
  LS_PPT010-PLANINDEX = '10'.             " 생산계획 INDEX
  LS_PPT010-BOMID     = LV_BOMID.         " BOM ID
  LS_PPT010-MATNR     = ZEA_MMT010-MATNR. " 자재명
  LS_PPT010-WERKS     = ZEA_PPT010-WERKS. " 플랜트 ID
  LS_PPT010-MEINS     = ZEA_SDT030-MEINS. " 단위
  LS_PPT010-LOEKZ     = ''.               " 삭제 플래그
  LS_PPT010-ERNAM     = SY-UNAME.
  LS_PPT010-ERDAT     = SY-DATUM.
  LS_PPT010-ERZET     = SY-UZEIT.
  INSERT ZEA_PPT010 FROM LS_PPT010.

  IF SY-SUBRC NE 0.
*    LV_SUBRC = 4.
    ROLLBACK WORK.
    MESSAGE E000 WITH '생산계획 생성을 실패하였습니다.'.
    EXIT.
  ENDIF.

  ZEA_PPT010-PLANINDEX = LS_PPT010-PLANINDEX. " 10

*-- 헤더 INSERT
  LS_PLAF-PLANID      = ZEA_PLAF-PLANID.  " 생산계획 ID
  LS_PLAF-WERKS       = ZEA_PPT010-WERKS. " 플랜트 ID
*  LS_SAPNR            = ****             " 판매계획 (보류)
  LS_PLAF-PDPDAT      = ZEA_PLAF-PDPDAT.  " 생산계획 년도
  LS_PLAF-PDPLI       = ZEA_PLAF-PDPLI.   " 생산계획 내역
  LS_PLAF-LOEKZ       = ''.               " 삭제플래그
  LS_PLAF-ERNAM     = SY-UNAME.
  LS_PLAF-ERDAT     = SY-DATUM.
  LS_PLAF-ERZET     = SY-UZEIT.
  INSERT ZEA_PLAF FROM LS_PLAF.



  IF SY-SUBRC NE 0.
*    LV_SUBRC = 4.
    ROLLBACK WORK.
    MESSAGE E000 WITH '생산계획 생성을 실패하였습니다.'.
    EXIT.
  ENDIF.

  MESSAGE S078 WITH LS_PPT010-PLANID LS_PPT010-PLANINDEX.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHCEK_CREATE_NUMBER : 채번 유무를 검증하기 위한 로직
*&---------------------------------------------------------------------*
FORM CHCEK_CREATE_NUMBER .

  DATA LV_COUNT TYPE I.
  CLEAR GS_CHECK.
  REFRESH GT_CHECK.

  " 이미 생성된 생산계획인지 확인하기 위해 GT_CHECK Itab에
  " 생산계획 년도, 자재코드, 플랜트id 를 조건으로 걸어 검색한 결과를 넣음
  " 만약 GT_CHECK에 값이 존재하면 채번을 하지않고, 값이 존재하지 않으면 채번을 함
  SELECT *
    FROM ZEA_PLAF AS A
    JOIN ZEA_PPT010 AS B
      ON B~PLANID EQ A~PLANID
    INTO CORRESPONDING FIELDS OF TABLE GT_CHECK
   WHERE A~PDPDAT EQ ZEA_PLAF-PDPDAT
     AND B~MATNR  EQ ZEA_MMT010-MATNR
     AND B~WERKS  EQ ZEA_PPT010-WERKS.

  " 값이 존재하면 GV_LINES는 0이 아니며, 값이 존재하지 않으면 GV_LINES = 0
  DESCRIBE TABLE GT_CHECK LINES GV_LINES.


*--------------------------------------------------------------------*
  IF GV_LINES EQ 0.
    PERFORM SAVE_DATA_CREATE_NUMBER . " 채번 + 인덱스 10
  ELSE.

    " 생산계획에서 생산계획 ID를 가져오기 위함
    READ TABLE GT_CHECK INTO GS_CHECK
                        WITH KEY PDPDAT = ZEA_PLAF-PDPDAT
                                 MATNR = ZEA_MMT010-MATNR
                                 WERKS = '10000'.
*                                 LOEKZ = ''.

    " 채번 하지않고 인덱스만 증가
    IF SY-SUBRC EQ 0.
      " 동일한 출고일자, 플랜트가 있음 => 해당 출고 문서의 인덱스 추가
      PERFORM SAVE_DATA_NOT_CREATE_NUMBER USING GS_CHECK-PLANID.

    ENDIF.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form SAVE_DATA_NOT_CREATE_NUMBER
*&---------------------------------------------------------------------*
FORM SAVE_DATA_NOT_CREATE_NUMBER USING PV_PLANID TYPE ZEA_PLAF-PLANID.

  DATA: LS_PLAF   TYPE ZEA_PLAF,    " 생산계획 Header
        LS_PPT010 TYPE ZEA_PPT010,  " 생산계획 Item
        LV_PLANID TYPE ZEA_PLAF-PLANID, " 생산계획 ID
        LV_BOMID  TYPE ZEA_STKO-BOMID.

  " 한개라도 선택되어 있다면
  CHECK S0120-1MONTH  EQ ABAP_ON
     OR S0120-2MONTH  EQ ABAP_ON
     OR S0120-3MONTH  EQ ABAP_ON
     OR S0120-4MONTH  EQ ABAP_ON
     OR S0120-5MONTH  EQ ABAP_ON
     OR S0120-6MONTH  EQ ABAP_ON
     OR S0120-7MONTH  EQ ABAP_ON
     OR S0120-8MONTH  EQ ABAP_ON
     OR S0120-9MONTH  EQ ABAP_ON
     OR S0120-10MONTH EQ ABAP_ON
     OR S0120-11MONTH EQ ABAP_ON
     OR S0120-12MONTH EQ ABAP_ON.

  SELECT MAX( PLANINDEX )
  FROM ZEA_PPT010
  INTO ZEA_PPT010-PLANINDEX
  WHERE PLANID EQ PV_PLANID.

  SELECT SINGLE BOMID
    FROM ZEA_STKO
    WHERE MATNR EQ @ZEA_MMT010-MATNR
    INTO @LV_BOMID.

  ZEA_PPT010-PLANID = PV_PLANID.


*-- 아이템 INSERT
  " 각 월의 생산계획이 체크되어 있을 경우
  IF S0120-1MONTH EQ ABAP_ON.
    LS_PPT010-PLANQTY1 = S0120-PLANQTY1.
  ENDIF.
  IF S0120-2MONTH EQ ABAP_ON.
    LS_PPT010-PLANQTY2 = S0120-PLANQTY2.
  ENDIF.
  IF S0120-3MONTH EQ ABAP_ON.
    LS_PPT010-PLANQTY3 = S0120-PLANQTY3.
  ENDIF.
  IF S0120-3MONTH EQ ABAP_ON.
    LS_PPT010-PLANQTY3 = S0120-PLANQTY3.
  ENDIF.
  IF S0120-4MONTH EQ ABAP_ON.
    LS_PPT010-PLANQTY4 = S0120-PLANQTY4.
  ENDIF.
  IF S0120-5MONTH EQ ABAP_ON.
    LS_PPT010-PLANQTY5 = S0120-PLANQTY5.
  ENDIF.
  IF S0120-6MONTH EQ ABAP_ON.
    LS_PPT010-PLANQTY6 = S0120-PLANQTY6.
  ENDIF.
  IF S0120-7MONTH EQ ABAP_ON.
    LS_PPT010-PLANQTY7 = S0120-PLANQTY7.
  ENDIF.
  IF S0120-8MONTH EQ ABAP_ON.
    LS_PPT010-PLANQTY8 = S0120-PLANQTY8.
  ENDIF.
  IF S0120-9MONTH EQ ABAP_ON.
    LS_PPT010-PLANQTY9 = S0120-PLANQTY9.
  ENDIF.
  IF S0120-10MONTH EQ ABAP_ON.
    LS_PPT010-PLANQTY10 = S0120-PLANQTY10.
  ENDIF.
  IF S0120-11MONTH EQ ABAP_ON.
    LS_PPT010-PLANQTY11 = S0120-PLANQTY11.
  ENDIF.
  IF S0120-12MONTH EQ ABAP_ON.
    LS_PPT010-PLANQTY12 = S0120-PLANQTY12.
  ENDIF.

  LS_PPT010-PLANID    = PV_PLANID.  " 생산계획 ID
  LS_PPT010-PLANINDEX = ZEA_PPT010-PLANINDEX + 10.             " 생산계획 INDEX
  LS_PPT010-BOMID     = LV_BOMID.         " BOM ID
  LS_PPT010-MATNR     = ZEA_MMT010-MATNR. " 자재코드
  LS_PPT010-WERKS     = ZEA_PPT010-WERKS. " 플랜트 ID
  LS_PPT010-MEINS     = ZEA_SDT030-MEINS. " 단위
  LS_PPT010-LOEKZ     = ''.               " 삭제 플래그
  LS_PPT010-ERNAM     = SY-UNAME.
  LS_PPT010-ERDAT     = SY-DATUM.
  LS_PPT010-ERZET     = SY-UZEIT.
  INSERT ZEA_PPT010 FROM LS_PPT010.

  IF SY-SUBRC NE 0.
*    LV_SUBRC = 4.
    ROLLBACK WORK.
    MESSAGE E000 WITH '생산계획 생성을 실패하였습니다.'.
    EXIT.
  ENDIF.

*-- 생산계획 아이템 삭제플래그에 업데이트
  " 이전 생산계획에 대해서는 삭제 플래그에 'X' 값을 준다.
  UPDATE ZEA_PPT010 SET LOEKZ = 'X'
                        AENAM  = SY-UNAME
                        AEDAT  = SY-DATUM
                        AEZET  = SY-UZEIT
                        WHERE PLANID EQ PV_PLANID
                        AND PLANINDEX EQ ZEA_PPT010-PLANINDEX
                        AND MATNR EQ LS_PPT010-MATNR
                        AND WERKS EQ LS_PPT010-WERKS.

  COMMIT WORK AND WAIT.


  ZEA_PPT010-PLANINDEX = LS_PPT010-PLANINDEX. " 화면변수 INDEX에 값을 전달


  DATA LV_MSG TYPE STRING.

*  LV_MSG = |생산계획 번호 { LS_PPT010-PLANID } 가 생성되었습니다. INDEX는 { LS_PPT010-PLANINDEX } 입니다. |.
  MESSAGE S078 WITH LS_PPT010-PLANID LS_PPT010-PLANINDEX.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form OPEN_INPUT_TEST
*&---------------------------------------------------------------------*
FORM OPEN_INPUT_TEST .

  LOOP AT SCREEN.
    CASE SCREEN-NAME.


      WHEN 'S0120-PLANQTY1'.
        IF  SY-DATUM+4(2) GT 1.
          SCREEN-INPUT = 0.
        ELSEIF  SY-DATUM+4(2) GT 1 OR ZEA_SDT030-SPQTY1 NE 0 OR S0120-PLANQTY1 NE 0.
          IF S0120-1MONTH IS INITIAL.
            SCREEN-INPUT = 1.
          ELSE.
            SCREEN-INPUT = 0.
          ENDIF.
        ELSE.
          SCREEN-INPUT = 0.
        ENDIF.
      WHEN 'S0120-1MONTH'.
        IF SY-DATUM+4(2) GT 1.
          SCREEN-INPUT = 0.
        ELSE.
          SCREEN-INPUT = 1.
        ENDIF.


      WHEN 'S0120-PLANQTY2'.
        IF  SY-DATUM+4(2) GT 2.
          SCREEN-INPUT = 0.
        ELSEIF  SY-DATUM+4(2) GT 2 OR ZEA_SDT030-SPQTY2 NE 0 OR S0120-PLANQTY2 NE 0.
          IF S0120-2MONTH IS INITIAL.
            SCREEN-INPUT = 1.
          ELSE.
            SCREEN-INPUT = 0.
          ENDIF.
        ELSE.
          SCREEN-INPUT = 0.
        ENDIF.
      WHEN 'S0120-2MONTH'.
        IF SY-DATUM+4(2) GT 2.
          SCREEN-INPUT = 0.
        ELSE.
          SCREEN-INPUT = 1.
        ENDIF.


      WHEN 'S0120-PLANQTY3'.
        IF  SY-DATUM+4(2) GT 3.
          SCREEN-INPUT = 0.
        ELSEIF  SY-DATUM+4(2) GT 3 OR ZEA_SDT030-SPQTY3 NE 0 OR S0120-PLANQTY3 NE 0.
          IF S0120-3MONTH IS INITIAL.
            SCREEN-INPUT = 1.
          ELSE.
            SCREEN-INPUT = 0.
          ENDIF.
        ELSE.
          SCREEN-INPUT = 0.
        ENDIF.
      WHEN 'S0120-3MONTH'.
        IF SY-DATUM+4(2) GT 3.
          SCREEN-INPUT = 0.
        ELSE.
          SCREEN-INPUT = 1.
        ENDIF.


      WHEN 'S0120-PLANQTY4'.
        IF  SY-DATUM+4(2) GT 4.
          SCREEN-INPUT = 0.
        ELSEIF  SY-DATUM+4(2) GT 4 OR ZEA_SDT030-SPQTY4 NE 0 OR S0120-PLANQTY4 NE 0.
          IF S0120-4MONTH IS INITIAL.
            SCREEN-INPUT = 1.
          ELSE.
            SCREEN-INPUT = 0.
          ENDIF.
        ELSE.
          SCREEN-INPUT = 0.
        ENDIF.
      WHEN 'S0120-4MONTH'.
        IF SY-DATUM+4(2) GT 4.
          SCREEN-INPUT = 0.
        ELSE.
          SCREEN-INPUT = 1.
        ENDIF.


      WHEN 'S0120-PLANQTY5'.
        IF  SY-DATUM+4(2) GT 5.
          SCREEN-INPUT = 0.
        ELSEIF  SY-DATUM+4(2) GT 5 AND ZEA_SDT030-SPQTY5 NE 0 OR S0120-PLANQTY5 NE 0.
          IF S0120-5MONTH IS INITIAL.
            SCREEN-INPUT = 1.
          ELSE.
            SCREEN-INPUT = 0.
          ENDIF.
        ELSE.
          SCREEN-INPUT = 0.
        ENDIF.
      WHEN 'S0120-5MONTH'.
        IF SY-DATUM+4(2) GT 5.
          SCREEN-INPUT = 0.
        ELSE.
          SCREEN-INPUT = 1.
        ENDIF.


      WHEN 'S0120-PLANQTY6'.
        IF  SY-DATUM+4(2) GT 6.
          SCREEN-INPUT = 0.
        ELSEIF  SY-DATUM+4(2) GT 6 OR ZEA_SDT030-SPQTY6 NE 0 OR S0120-PLANQTY6 NE 0.
          IF S0120-6MONTH IS INITIAL.
            SCREEN-INPUT = 1.
          ELSE.
            SCREEN-INPUT = 0.
          ENDIF.
        ELSE.
          SCREEN-INPUT = 0.
        ENDIF.
      WHEN 'S0120-6MONTH'.
        IF SY-DATUM+4(2) GT 6.
          SCREEN-INPUT = 0.
        ELSE.
          SCREEN-INPUT = 1.
        ENDIF.


      WHEN 'S0120-PLANQTY7'.
        IF  SY-DATUM+4(2) GT 7.
          SCREEN-INPUT = 0.
        ELSEIF  SY-DATUM+4(2) GT 7 OR ZEA_SDT030-SPQTY7 NE 0 OR S0120-PLANQTY7 NE 0.
          IF S0120-7MONTH IS INITIAL.
            SCREEN-INPUT = 1.
          ELSE.
            SCREEN-INPUT = 0.
          ENDIF.
        ELSE.
          SCREEN-INPUT = 0.
        ENDIF.
      WHEN 'S0120-7MONTH'.
        IF SY-DATUM+4(2) GT 7.
          SCREEN-INPUT = 0.
        ELSE.
          SCREEN-INPUT = 1.
        ENDIF.


      WHEN 'S0120-PLANQTY8'.
        IF  SY-DATUM+4(2) GT 8.
          SCREEN-INPUT = 0.
        ELSEIF  SY-DATUM+4(2) GT 8 OR ZEA_SDT030-SPQTY8 NE 0 OR S0120-PLANQTY8 NE 0.
          IF S0120-8MONTH IS INITIAL.
            SCREEN-INPUT = 1.
          ELSE.
            SCREEN-INPUT = 0.
          ENDIF.
        ELSE.
          SCREEN-INPUT = 0.
        ENDIF.
      WHEN 'S0120-8MONTH'.
        IF SY-DATUM+4(2) GT 8.
          SCREEN-INPUT = 0.
        ELSE.
          SCREEN-INPUT = 1.
        ENDIF.


      WHEN 'S0120-PLANQTY9'.
        IF  SY-DATUM+4(2) GT 9.
          SCREEN-INPUT = 0.
        ELSEIF  SY-DATUM+4(2) GT 9 OR ZEA_SDT030-SPQTY9 NE 0 OR S0120-PLANQTY9 NE 0.
          IF S0120-9MONTH IS INITIAL.
            SCREEN-INPUT = 1.
          ELSE.
            SCREEN-INPUT = 0.
          ENDIF.
        ELSE.
          SCREEN-INPUT = 0.
        ENDIF.
      WHEN 'S0120-9MONTH'.
        IF SY-DATUM+4(2) GT 9.
          SCREEN-INPUT = 0.
        ELSE.
          SCREEN-INPUT = 1.
        ENDIF.


      WHEN 'S0120-PLANQTY10'.
        IF  SY-DATUM+4(2) GT 10.
          SCREEN-INPUT = 0.
        ELSEIF  SY-DATUM+4(2) GT 10 OR ZEA_SDT030-SPQTY10 NE 0 OR S0120-PLANQTY10 NE 0.
          IF S0120-10MONTH IS INITIAL.
            SCREEN-INPUT = 1.
          ELSE.
            SCREEN-INPUT = 0.
          ENDIF.
        ELSE.
          SCREEN-INPUT = 0.
        ENDIF.
      WHEN 'S0120-10MONTH'.
        IF SY-DATUM+4(2) GT 10.
          SCREEN-INPUT = 0.
        ELSE.
          SCREEN-INPUT = 1.
        ENDIF.


      WHEN 'S0120-PLANQTY11'.
        IF  SY-DATUM+4(2) GT 11.
          SCREEN-INPUT = 0.
        ELSEIF  SY-DATUM+4(2) GT 11 OR ZEA_SDT030-SPQTY11 NE 0 OR S0120-PLANQTY11 NE 0.
          IF S0120-11MONTH IS INITIAL.
            SCREEN-INPUT = 1.
          ELSE.
            SCREEN-INPUT = 0.
          ENDIF.
        ELSE.
          SCREEN-INPUT = 0.
        ENDIF.
      WHEN 'S0120-11MONTH'.
        IF SY-DATUM+4(2) GT 11.
          SCREEN-INPUT = 0.
        ELSE.
          SCREEN-INPUT = 1.
        ENDIF.


      WHEN 'S0120-PLANQTY12'.
        IF  SY-DATUM+4(2) GT 12.
          SCREEN-INPUT = 0.
        ELSEIF  SY-DATUM+4(2) GT 12 OR ZEA_SDT030-SPQTY12 NE 0 OR S0120-PLANQTY12 NE 0.
          IF S0120-12MONTH IS INITIAL.
            SCREEN-INPUT = 1.
          ELSE.
            SCREEN-INPUT = 0.
          ENDIF.
        ELSE.
          SCREEN-INPUT = 0.
        ENDIF.
      WHEN 'S0120-12MONTH'.
        IF SY-DATUM+4(2) GT 12.
          SCREEN-INPUT = 0.
        ELSE.
          SCREEN-INPUT = 1.
        ENDIF.


    ENDCASE.
    MODIFY SCREEN.
  ENDLOOP.


* 체크박스를 클릭하면 잠겨있던 인풋 값이 열림.
  FIELD-SYMBOLS <FS>.

  DATA LV_CHECK TYPE C.

  LOOP AT SCREEN.
    CASE SCREEN-NAME+7(3).
      WHEN 'MON' OR '0MO' OR '1MO' OR '2MO'.
*        ASSIGN COMPONENT SCREEN-NAME+6 OF STRUCTURE S0110 TO <FS>.
*        IF SY-SUBRC EQ 0.
*          LV_CHECK = <FS>.
*          UNASSIGN <FS>.
*        ENDIF.

        ASSIGN (SCREEN-NAME) TO <FS>.
        IF <FS> IS ASSIGNED.
          GV_CHECK = <FS>.
          UNASSIGN <FS>.
        ENDIF.

      WHEN 'LAN'.
        IF GV_CHECK EQ ABAP_ON.
          SCREEN-INPUT = 1.
          MODIFY SCREEN.
        ELSE.

        ENDIF.
    ENDCASE.
  ENDLOOP.

ENDFORM.
