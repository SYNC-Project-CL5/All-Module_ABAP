*&---------------------------------------------------------------------*
*& Include          ZEA_TR_TEM_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM GET_DATA .

  " Internal Table의 내용을 전부 비워둠
  REFRESH GT_DATA[].

* --B/S 계정 (자산)
  SELECT
    B~GJAHR   " 회계연도
    B~SAKNR   " G/L계정 (Recon)
    B~GLTXT   " G/L계정명
    SUM( B~DMBTR ) AS DMBTR "  통화금액 합계
    SUM( B~EATAX ) AS EATAX " 세금 합계
  INTO CORRESPONDING FIELDS OF TABLE GT_DATA
  FROM ZEA_BKPF AS A        " A: 전표 헤더
 INNER JOIN ZEA_BSEG AS B   " B: 전표 아이템
    ON A~BUKRS EQ B~BUKRS
   AND A~BELNR EQ B~BELNR
   AND A~GJAHR EQ B~GJAHR
 INNER JOIN ZEA_SKB1 AS C   " C: G/L계정마스터
    ON C~BUKRS EQ A~BUKRS
   AND C~SAKNR EQ B~SAKNR
   AND C~GLTXT EQ B~GLTXT
   AND C~XBILK EQ 'X'        " G/L코드 Type - 'X': 대차대조 / '' : 손익계산
    WHERE C~SAKNR IN R_SAKNR_1
  GROUP BY B~GJAHR B~SAKNR B~GLTXT.


  IF SY-SUBRC NE 0.
    MESSAGE S000 WITH 'Data not found'.
    LEAVE LIST-PROCESSING.
  ENDIF.
*
*  APPEND LINES OF GT_DATA TO GT_DATA2.
*  APPEND LINES OF GT_DATA TO GT_DATA3.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_TREE_FCAT .

  GS_LAYOUT-ZEBRA      = 'X'.
  GS_LAYOUT-CWIDTH_OPT = 'A'.
  GS_LAYOUT-SEL_MODE   = 'D'.

**  PERFORM SET_FCAT USING :
*** 계정과목 추가 필요
**  'X'  '계정번호'    ' '   'ZEA_BSEG'     'SAKNR',
**  ' '  '계정명'      ' '   'ZEA_BSEG'     'GLTXT',
**  ' '  'S/H'         ' '    'ZEA_TBSL'     'INDI_CD',
**  ' '  'AMOUNT'      ' '   'ZEA_BSEG'   'DMBTR',
**  ' '  'Tax'         ' '   'ZEA_BSEG'   'EATAX',
**  ' '  'CURRENCY'    ' '   'ZEA_BSEG'   'D_WAERS',
**  ' '  'PLANETYPE'   ' '   'SFLIGHT'   'PLANETYPE'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat
*&---------------------------------------------------------------------*
FORM SET_FCAT TABLES PT_FCAT STRUCTURE LVC_S_FCAT
              USING PV_KEY
                    PV_FIELD
                    PV_TEXT
                    PV_REF_TABLE
                    PV_REF_FIELD.

  CLEAR PT_FCAT.
  PT_FCAT-KEY       = PV_KEY.
  PT_FCAT-FIELDNAME = PV_FIELD.
  PT_FCAT-COLTEXT   = PV_TEXT.
  PT_FCAT-REF_TABLE = PV_REF_TABLE.
  PT_FCAT-REF_FIELD = PV_REF_FIELD.

  CASE PV_FIELD.
    WHEN 'DMBTR'.
      PT_FCAT-CFIELDNAME = 'D_WAERS'.
*
*    WHEN 'PLANQTY2'.
*      PT_FCAT-QFIELDNAME = 'MEINS'.

  ENDCASE.

  APPEND PT_FCAT.
  CLEAR  PT_FCAT.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_object
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT_1.

*----- 자산 Container
  CREATE OBJECT GCL_CONTAINER
    EXPORTING
      SIDE      = GCL_CONTAINER->DOCK_AT_LEFT
      EXTENSION = 1000.

  CREATE OBJECT GCL_TREE
    EXPORTING
      I_PARENT         = GCL_CONTAINER
*     I_NODE_SELECTION_MODE = CL_GUI_COLUMN_TREE=>NODE_SEL_MODE_MULTIPLE
*     I_NODE_SELECTION_MODE = CL_GUI_COLUMN_TREE=>ALIGN_AT_LEFT
      I_ITEM_SELECTION = 'X'
      I_NO_HTML_HEADER = 'X'
      I_NO_TOOLBAR     = SPACE.

  GS_VARIANT-REPORT = SY-REPID.
  GS_VARIANT-HANDLE = '1'.

  CALL METHOD GCL_TREE->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
      I_SAVE          = 'A'
      IS_LAYOUT       = GS_LAYOUT
      IS_VARIANT      = GS_VARIANT
    CHANGING
      IT_OUTTAB       = GT_DATA
      IT_SORT         = GT_SORT
      IT_FIELDCATALOG = GT_FCAT.

  CALL METHOD GCL_TREE->EXPAND_TREE
    EXPORTING
      I_LEVEL = 1.

  CALL METHOD GCL_TREE->COLUMN_OPTIMIZE
    EXPORTING
      I_START_COLUMN = GCL_TREE->C_HIERARCHY_COLUMN_NAME
      I_END_COLUMN   = GCL_TREE->C_HIERARCHY_COLUMN_NAME.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_sort
*&---------------------------------------------------------------------*
FORM SET_SORT TABLES PT_SORT STRUCTURE LVC_S_SORT.

  REFRESH PT_SORT.

*&---Make Tree of 자산-------------------------------------------------*
  "1. 계정과목 폴더
  GS_SORT-SPOS = 1.
  GS_SORT-FIELDNAME = 'LEVEL0_TEXT'.
  GS_SORT-SELTEXT = '계정과목'.
  GS_SORT-UP        = 'X'.
  GS_SORT-SUBTOT    = 'X'.

  APPEND GS_SORT TO PT_SORT.
  CLEAR  GS_SORT.
*
  "2. 계정번호
  GS_SORT-SPOS = 2.
  GS_SORT-FIELDNAME = 'SAKNR'.
  GS_SORT-UP        = 'X'.
  GS_SORT-SUBTOT    = 'X'.

  APPEND GS_SORT TO PT_SORT.
  CLEAR  GS_SORT.

  "3. 금액
  GS_SORT-SPOS = 3.
  GS_SORT-FIELDNAME = 'DMBTR'.
  GS_SORT-UP        = 'X'.
  GS_SORT-SUBTOT    = 'X'.

  APPEND GS_SORT TO PT_SORT.
  CLEAR  GS_SORT.

  "3. 통화코드
  GS_SORT-SPOS = 4.
  GS_SORT-FIELDNAME = 'D_WAERS'.
  GS_SORT-UP        = 'X'.
  GS_SORT-SUBTOT    = 'X'.

  APPEND GS_SORT TO PT_SORT.
  CLEAR  GS_SORT.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_FIELD_CATALOG
*&---------------------------------------------------------------------*
FORM SET_FIELD_CATALOG  USING    PT_TAB TYPE STANDARD TABLE
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
*& Form MAKE_FILED_CATALOG
*&---------------------------------------------------------------------*
FORM MAKE_FILED_CATALOG .

  GS_LAYOUT-ZEBRA      = 'X'.
  GS_LAYOUT-CWIDTH_OPT = 'A'.
  GS_LAYOUT-SEL_MODE   = 'D'.

  REFRESH GT_FCAT.
  PERFORM SET_FCAT
   TABLES GT_FCAT
     USING :
   'X'   'LEVEL0_TEXT'  '계정과목1'   ' '   ' ',
   'X'   'SAKNR'        '계정번호'   'ZEA_SKB1'   'SAKNR',
   ' '   'DMBTR'         ' '          'ZEA_BSEG'   'DMBTR',
   ' '   'D_WAERS'       ' '          'ZEA_BSEG'   'D_WAERS'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT2
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT2 .

*----- 부채 Container
  CREATE OBJECT GCL_CONTAINER_2
    EXPORTING
      REPID                       = SY-REPID
      DYNNR                       = SY-DYNNR
      SIDE                        = CL_GUI_DOCKING_CONTAINER=>DOCK_AT_RIGHT
      EXTENSION                   = 1000
    EXCEPTIONS
      CNTL_ERROR                  = 1
      CNTL_SYSTEM_ERROR           = 2
      CREATE_ERROR                = 3
      LIFETIME_ERROR              = 4
      LIFETIME_DYNPRO_DYNPRO_LINK = 5
      OTHERS                      = 6.
  IF SY-SUBRC <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FIELDCAT2_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_FIELDCAT2_0100 .

*
*  PERFORM GET_FIELDCAT_0100     USING     GT_DATA2
*                                CHANGING  GT_FCAT.

  PERFORM MAKE_FIELDCAT2_0100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM GET_FIELDCAT_0100  USING    PT_TAB TYPE STANDARD TABLE
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

  GS_LAYOUT-ZEBRA      = 'X'.
  GS_LAYOUT-CWIDTH_OPT = 'A'.
  GS_LAYOUT-SEL_MODE   = 'D'.


*  PERFORM SET_FCAT USING :
*   'X'   'LEVEL0_TEXT'  '계정과목'   ' '   ' ',
*   'X'   'SAKNR'        '계정번호'   'ZEA_SKB1'   'SAKNR',
*   ' '   'DMBTR'         ' '          'ZEA_BSEG'   'DMBTR',
*   ' '   'D_WAERS'       ' '          'ZEA_BSEG'   'D_WAERS'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV2_0100
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV2_0100 .


  CALL METHOD GCL_TREE->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
      I_SAVE          = 'A'
      IS_LAYOUT       = GS_LAYOUT
      IS_VARIANT      = GS_VARIANT
    CHANGING
      IT_OUTTAB       = GT_DATA
      IT_SORT         = GT_SORT
      IT_FIELDCATALOG = GT_FCAT.

  CALL METHOD GCL_TREE->EXPAND_TREE
    EXPORTING
      I_LEVEL = 1.

  CALL METHOD GCL_TREE->COLUMN_OPTIMIZE
    EXPORTING
      I_START_COLUMN = GCL_TREE->C_HIERARCHY_COLUMN_NAME
      I_END_COLUMN   = GCL_TREE->C_HIERARCHY_COLUMN_NAME.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_LAYOUT2_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_LAYOUT2_0100 .

  CLEAR GS_LAYOUT.
  CLEAR GS_VARIANT.
  CLEAR GV_SAVE.

  GS_VARIANT-REPORT = SY-REPID.
  GV_SAVE = 'A'.   " '' : Layout 저장불가

*  " 'U' : 저장한 사용자만 사용가능
*  " 'X' : Layout을 저장하면 모든 사용자가 사용 가능
*  " 'A' : Layout을 저장할 때 'U'/'X' 선택 가능
*
  GS_LAYOUT-CWIDTH_OPT = 'X'.
  GS_LAYOUT-ZEBRA      = ABAP_ON.
  GS_LAYOUT-SEL_MODE   = 'B'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_EVENT2_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_EVENT2_0100 .


ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_DATA2
*&---------------------------------------------------------------------*
FORM GET_DATA2 .

  " Internal Table의 내용을 전부 비워둠
  REFRESH GT_DATA2[].

* --B/S 계정 (자본)
  SELECT
    B~GJAHR   " 회계연도
    B~SAKNR   " G/L계정 (Recon)
    B~GLTXT   " G/L계정명
    SUM( B~DMBTR ) AS DMBTR "  통화금액 합계
    SUM( B~EATAX ) AS EATAX " 세금 합계
  INTO CORRESPONDING FIELDS OF TABLE GT_DATA2
  FROM ZEA_BKPF AS A        " A: 전표 헤더
 INNER JOIN ZEA_BSEG AS B   " B: 전표 아이템
    ON A~BUKRS EQ B~BUKRS
   AND A~BELNR EQ B~BELNR
   AND A~GJAHR EQ B~GJAHR
 INNER JOIN ZEA_SKB1 AS C   " C: G/L계정마스터
    ON C~BUKRS EQ A~BUKRS
   AND C~SAKNR EQ B~SAKNR
   AND C~GLTXT EQ B~GLTXT
   AND C~XBILK EQ 'X'        " G/L코드 Type - 'X': 대차대조 / '' : 손익계산
        WHERE C~SAKNR IN R_SAKNR_2
    GROUP BY B~GJAHR B~SAKNR B~GLTXT.


  IF SY-SUBRC NE 0.
    MESSAGE S000 WITH 'Data not found - GT_DATA2 '.
    LEAVE LIST-PROCESSING.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_DATA3
*&---------------------------------------------------------------------*
FORM GET_DATA3 .

  " Internal Table의 내용을 전부 비워둠
  REFRESH GT_DATA3[].

* --B/S 계정 (자본)
  SELECT
    B~GJAHR   " 회계연도
    B~SAKNR   " G/L계정 (Recon)
    B~GLTXT   " G/L계정명
    SUM( B~DMBTR ) AS DMBTR "  통화금액 합계
    SUM( B~EATAX ) AS EATAX " 세금 합계
  INTO CORRESPONDING FIELDS OF TABLE GT_DATA3
  FROM ZEA_BKPF AS A        " A: 전표 헤더
 INNER JOIN ZEA_BSEG AS B   " B: 전표 아이템
    ON A~BUKRS EQ B~BUKRS
   AND A~BELNR EQ B~BELNR
   AND A~GJAHR EQ B~GJAHR
 INNER JOIN ZEA_SKB1 AS C   " C: G/L계정마스터
    ON C~BUKRS EQ A~BUKRS
   AND C~SAKNR EQ B~SAKNR
   AND C~GLTXT EQ B~GLTXT
   AND C~XBILK EQ 'X'        " G/L코드 Type - 'X': 대차대조 / '' : 손익계산
            WHERE C~SAKNR IN R_SAKNR_3
    GROUP BY B~GJAHR B~SAKNR B~GLTXT.


  IF SY-SUBRC NE 0.
    MESSAGE S000 WITH 'Data not found - GT_DATA3 '.
    LEAVE LIST-PROCESSING.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_1
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT_2 .

**-- Create Container (부채)
*
*  CREATE OBJECT GCL_CONTAINER_2
*    EXPORTING
*      CONTAINER_NAME = 'CCON1'.        " Name of the Screen CustCtrl Name to Link Container To
*
**-- Create Tree (부채)
*  CREATE OBJECT GO_ALV_TREE_1
*    EXPORTING
*      PARENT              = GO_CONTAINER_1                     " Parent Container
*      NODE_SELECTION_MODE = CL_GUI_COLUMN_TREE=>NODE_SEL_MODE_SINGLE. " Nodes: Single or Multiple Selection
**      ITEM_SELECTION      = 'X'                                      " Can Individual Items be Selected?
**      NO_TOOLBAR          = 'X'                                      " NO_TOOLBAR
**      NO_HTML_HEADER      = 'X'.                                   " NO_HTML_HEADER
*

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_FIELDCAT_1.
*
  PERFORM MAKE_FIELDCAT_1.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GT_FCAT
*&---------------------------------------------------------------------*
FORM GT_FCAT  USING  PT_TAB TYPE STANDARD TABLE
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
*& Form MAKE_FIELDCAT_1
*&---------------------------------------------------------------------*
FORM MAKE_FIELDCAT_1 .

  GS_LAYOUT-ZEBRA      = 'X'.
  GS_LAYOUT-CWIDTH_OPT = 'A'.
  GS_LAYOUT-SEL_MODE   = 'D'.


*  PERFORM SET_FCAT USING :
*   'X'   'LEVEL0_TEXT'  '계정과목'   ' '   ' ',
*   'X'   'SAKNR'        '계정번호'   'ZEA_SKB1'   'SAKNR',
*   ' '   'DMBTR'         ' '          'ZEA_BSEG'   'DMBTR',
*   ' '   'D_WAERS'       ' '          'ZEA_BSEG'   'D_WAERS'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_LAYOUT_1
*&---------------------------------------------------------------------*
FORM SET_ALV_LAYOUT_1 .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_EVENT_1
*&---------------------------------------------------------------------*
FORM SET_ALV_EVENT_1 .
* CLEAR GS_LAYOUT.
*  CLEAR GS_VARIANT.
*  CLEAR GV_SAVE.
*
*  GS_VARIANT-REPORT = SY-REPID.
**  GS_VARIANT-VARIANT = PA_LAYO.
*  GV_SAVE = 'A'.   " '' : Layout 저장불가
*  " 'U' : 저장한 사용자만 사용가능
*  " 'X' : Layout을 저장하면 모든 사용자가 사용 가능
*  " 'A' : Layout을 저장할 때 'U'/'X' 선택 가능
*
*  GS_LAYOUT-CWIDTH_OPT = ABAP_ON.
*  GS_LAYOUT-ZEBRA      = ABAP_ON.
*  GS_LAYOUT-SEL_MODE   = 'D'.
**    GS_LAYOUT-SEL_MODE = 'A'.
*  " A: 다중 행, 다중 열 선택, 선택 박스 생성
*  " (셀 단위, 전체 선택도 가능)
**    GS_LAYOUT-SEL_MODE = 'B'. " B : 단일 행, 다중 열 선택, 기본 값
*  " 기본값으로 해도 Ctrl + y로 강제로 드래그 할 수는 있음
**    GS_LAYOUT-SEL_MODE = 'C'. " C : 다중 행, 다중 열 선택, 줄 단위 선택
*
**  GS_LAYOUT-GRID_TITLE = TEXT-T10.          " ALV TITLE TEXT
**  GS_LAYOUT-INFO_FNAME = 'COLOR'.           " 행 색상
**  GS_LAYOUT-EXCP_FNAME = 'LIGHT'.           " 신호등
**  GS_LAYOUT-EXCP_LED = ABAP_ON.             " 신호등 모양 변경
**  GS_LAYOUT-CTAB_FNAME = 'IT_FIELD_COLORS'. " 셀 별 색상
**  GS_LAYOUT-STYLEFNAME  = 'STYLE'.          " 스타일
ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_1
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV_1 .


ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_HIERARCHY_1
*&---------------------------------------------------------------------*
FORM MAKE_HIERARCHY_1 .

  GS_HIERARCHY_HEADER-HEADING = '계정과목'.
  GS_HIERARCHY_HEADER-TOOLTIP = '계정과목 폴더'.
  GS_HIERARCHY_HEADER-WIDTH_PIX = ' '.
  GS_HIERARCHY_HEADER-WIDTH = 30.

****&---Set Node of 부채-------------------------------------------------*
*
*  DATA L_GL_TYP TYPE C.
*  L_GL_TYP = ZEA_SKB1-SAKNR(2).
*
*  CASE L_GL_TYP.
**    WHEN '10'.
**      GV_KEY_2 = 1. " '유동자산'.
**
**    WHEN '11'.
**      GV_KEY_2 = 2. " '비유동자산'.
*
*    WHEN '21'.
*      GV_KEY_2 = 3. " '유동부채'.
**
**    WHEN '22'.
**      GV_KEY_2 = 4. " '비유동부채'.
**
**    WHEN '31'.
**      GV_KEY_2 = 5. " '자본금'.
**
**    WHEN '33'.
**      GV_KEY_2 = 6. " '기타 자본금'.
**
**    WHEN '35'.
**      GV_KEY_2 = 7. " '이익잉여금'.
*
*  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_2
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT_RIGHT .

*----- Right 컨테이너 생성(부채/자본)용

  CREATE OBJECT GCL_CONTAINER_2
    EXPORTING
      SIDE                        = CL_GUI_DOCKING_CONTAINER=>DOCK_AT_RIGHT
      EXTENSION                   = 1000
    EXCEPTIONS
      CNTL_ERROR                  = 1
      CNTL_SYSTEM_ERROR           = 2
      CREATE_ERROR                = 3
      LIFETIME_ERROR              = 4
      LIFETIME_DYNPRO_DYNPRO_LINK = 5
      OTHERS                      = 6.
  IF SY-SUBRC <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_HIERARCHY_1
*&---------------------------------------------------------------------*
FORM Build_node_table. " USING T_NODE LIKE MTREESNODE.

**--- Node 추가
*  DATA : LS_SKB1 LIKE ZEA_SKB1,
*         LT_SKB1 LIKE TABLE OF ZEA_SKB1.
*
*  DATA : NODE LIKE MTREESNODE.
*
*  CLEAR NODE.
*  NODE-NODE_KEY = 'Root'.
*  NODE-ISFOLDER = 'X'.      "폴더
**  NODE-TEXT = '부채'.
*  NODE-TEXT = 'SAKNR'.
*  APPEND NODE TO GT_NODES.
*
*  CLEAR NODE.
*  NODE-NODE_KEY = 'Child1'.
*  NODE-RELATKEY = 'Root'.
*  NODE-ISFOLDER = 'X'.
**  NODE-TEXT = '유동부채'.
*  NODE-TEXT = 'BELNR'.
*  NODE-EXPANDER = 'X'.
*  APPEND NODE TO GT_NODES.
*
*  CLEAR NODE.
*  NODE-NODE_KEY = 'Child1'.
*  NODE-RELATKEY = 'Root'.
*  NODE-ISFOLDER = 'X'.
**  NODE-TEXT = '비부채'.
*  NODE-TEXT = 'GLTXT'.
**  NODE-EXPANDER = ' '.
*  NODE-EXPANDER = 'X'.
*  APPEND NODE TO GT_NODES.
*
*
*  CALL METHOD GO_ALV_TREE_1->ADD_NODES
*    EXPORTING
*      TABLE_STRUCTURE_NAME = 'ZEA_BSEG'      " Name of Structure of Node Table
*      NODE_TABLE           = GT_NODES.       " Node table

**********************************************************************
******  DATA: LV_DEBT_TYPE_KEY TYPE LVC_NKEY,
******        LV_SAKNR_KEY     TYPE LVC_NKEY.
******
******  " 부채 계정코드 텍스트만 가져와서 LT_NODE에 넣는다.
******  SELECT SAKNR, GLTXT
******    FROM ZEA_SKB1
******   WHERE SAKNR LIKE '2%'
******   INTO CORRESPONDING FIELDS OF TABLE @GT_NODE.
******
******
******  LOOP AT GT_NODE INTO GS_NODE.
******    " 21~ 유동 22~ 비유동으로 폴더 만드려고
******    PERFORM ADD_DEBT_TYPE USING GS_NODE-SAKNR
******                                ' '
******                          CHANGING LV_DEBT_TYPE_KEY.
******
******  ENDLOOP.
**********************************************************************



*  CALL METHOD GO_ALV_TREE_1->ADD_NODE
*    EXPORTING
*      I_RELAT_NODE_KEY = GV_KEY_2        " Node Already in Tree Hierarchy
*      I_RELATIONSHIP   = CL_GUI_COLUMN_TREE=>RELAT_FIRST_CHILD   " How to Insert Node
**     IS_OUTTAB_LINE   =                  " Attributes of Inserted Node
**     IS_NODE_LAYOUT   =                  " Node Layout
**     IT_ITEM_LAYOUT   =                  " Item Layout
*      I_NODE_TEXT      = G_NODE_TEXT_1.    " Hierarchy Node Text
**    IMPORTING
**      E_NEW_NODE_KEY       =                  " Key of New Node Key
**    EXCEPTIONS
**      RELAT_NODE_NOT_FOUND = 1                " Relat Node Key not Found
**      NODE_NOT_FOUND       = 2                " Node not Found
**      OTHERS               = 3.

*--- 가공해서 NODE 텍스트를 만든다고 함.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form ADD_DEBT_TYPE
*&---------------------------------------------------------------------*
***FORM ADD_DEBT_TYPE USING P_SAKNR      TYPE ZEA_SKB1-SAKNR
***                         P_RELATE_KEY TYPE LVC_NKEY
***                   CHANGING P_NODE_KEY TYPE LVC_NKEY.
***
*** DATA: L_NODE_TEXT TYPE LVC_VALUE,
***       LS_NODE LIKE LINE OF GT_NODE.
***
***
***
***
***   CALL METHOD GO_ALV_TREE_1->ADD_NODE
***     EXPORTING
***       I_RELAT_NODE_KEY     = P_RELATE_KEY                 " Node Already in Tree Hierarchy
***       I_RELATIONSHIP       = CL_GUI_COLUMN_TREE=>RELAT_LAST_CHILD                 " How to Insert Node
***       IS_OUTTAB_LINE       = LS_NODE                 " Attributes of Inserted Node
****       IS_NODE_LAYOUT       =                  " Node Layout
****       IT_ITEM_LAYOUT       =                  " Item Layout
***       I_NODE_TEXT          = L_NODE_TEXT                 " Hierarchy Node Text
***     IMPORTING
***       E_NEW_NODE_KEY       = P_NODE_KEY.                 " Key of New Node Key
***
***ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH_TREE_DEBT
*&---------------------------------------------------------------------*
FORM REFRESH_TREE_DEBT .
*  DATA : L_SCROLL TYPE LVC_S_STBL.
*  L_Scroll-COL = 'X'.
*  L_Scroll-ROW = 'X'.
*  CALL METHOD GO

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_EVENT_TREE_1
*&---------------------------------------------------------------------*
FORM SET_EVENT_TREE_1 .
*
* event-envtid = CL_GUI_SIMPLE_TREE=>EVENTID_NODE_DOUBLE_CLICK.
** EVENTS-appl_event = 'X'. "procsee PAI if event occurs
* APPEND EVENT TO EVENTS.
*
*  CALL METHOD GO_ALV_TREE_1->SET_REGISTERED_EVENTS
*    EXPORTING
*      EVENTS                    =   events      " Event Table
*    EXCEPTIONS
*      CNTL_ERROR                = 1                " cntl_error
*      CNTL_SYSTEM_ERROR         = 2                " cntl_system_error
*      ILLEGAL_EVENT_COMBINATION = 3 .               " ILLEGAL_EVENT_COMBINATION


ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_SPLIT
*&---------------------------------------------------------------------*
FORM CREATE_SPLIT .

*&---------------------------------------------------------------------*
*&      Split 생성
*&---------------------------------------------------------------------*
  CREATE OBJECT GO_SPLIT
    EXPORTING
      PARENT            = GCL_CONTAINER_2
      ROWS              = 2      " 몇 개의 행으로 나눌 것인지.
      COLUMNS           = 1      " 몇 개의 열로 나눌 것인지.
    EXCEPTIONS
      CNTL_ERROR        = 1
      CNTL_SYSTEM_ERROR = 2
      OTHERS            = 3.
  IF SY-SUBRC <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

*&---------------------------------------------------------------------*
*&      Split Container에 Container 올리기
*&---------------------------------------------------------------------*

  CALL METHOD GO_SPLIT->GET_CONTAINER
*    첫번째 행의 첫번째 열을 go_top과 연결하겠다는 구문
    EXPORTING
      ROW       = 1
      COLUMN    = 1
    RECEIVING
      CONTAINER = GO_TOP. " go_dock2

  CALL METHOD GO_SPLIT->GET_CONTAINER
*    2번쨰 row의 첫번째 열을 GO_BOT과 연결하겠다는 구문
    EXPORTING
      ROW       = 2
      COLUMN    = 1
    RECEIVING
      CONTAINER = GO_BOT.

*&---------------------------------------------------------------------*
*&       Container 높이 설정
*&---------------------------------------------------------------------*

*row 높이 설정. (하나의 컨테이너의 높이를 맞추면, 저절로 아래 높이 설정)
  CALL METHOD GO_SPLIT->SET_ROW_HEIGHT
    EXPORTING
      ID                = 1
      HEIGHT            = 70 " %로 옴.
    EXCEPTIONS
      CNTL_ERROR        = 1
      CNTL_SYSTEM_ERROR = 2
      OTHERS            = 3.
  IF SY-SUBRC <> 0.
*   Implement suitable error handling here
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_TREE
*&---------------------------------------------------------------------*
FORM CREATE_TREE .

*&---------------------------------------------------------------------*
*&      1. GCL_TREE_2 (부채 트리 -> GO_TOP과 연결)
*&---------------------------------------------------------------------*
*-- Tree 생성 후 top에 붙이기
  CREATE OBJECT GCL_TREE_2     "부채 Tree 생성
    EXPORTING
      I_PARENT              = GO_TOP
      I_NODE_SELECTION_MODE = CL_GUI_COLUMN_TREE=>NODE_SEL_MODE_MULTIPLE
      I_ITEM_SELECTION      = 'X'
      I_NO_HTML_HEADER      = 'X'
      I_NO_TOOLBAR          = SPACE.

  GS_VARIANT-REPORT = SY-REPID.


*&---------------------------------------------------------------------*
*&      2. GCL_TREE_3 (자본 트리 -> GO_BOT과 연결)
*&---------------------------------------------------------------------*
*-- Tree 생성 후 Bottom 에 붙이기
  CREATE OBJECT GCL_TREE_3
    EXPORTING
      I_PARENT         = GO_BOT
      I_NODE_SELECTION_MODE = CL_GUI_COLUMN_TREE=>NODE_SEL_MODE_MULTIPLE
      I_ITEM_SELECTION = 'X'
      I_NO_HTML_HEADER = 'X'
      I_NO_TOOLBAR     = SPACE.

  GS_VARIANT-REPORT = SY-REPID.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_TREE
*&---------------------------------------------------------------------*
FORM DISPLAY_TREE .

*&---------------------------------------------------------------------*
*&      1. GCL_TREE_2 (부채 트리/GO_TOP)
*&---------------------------------------------------------------------*
*-- Display 하여 확인하기

REFRESH GT_SORT.

  GS_VARIANT-REPORT = SY-REPID.
  GS_VARIANT-HANDLE = '2'.

  CALL METHOD GCL_TREE_2->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
      I_SAVE           = 'A'
      I_STRUCTURE_NAME = 'ZEA_BSEG'
      IS_LAYOUT       = GS_LAYOUT
      IS_VARIANT      = GS_VARIANT
    CHANGING
      IT_OUTTAB       = GT_DATA2     "부채 인터널 테이블과 연결
      IT_SORT         = GT_SORT2
      IT_FIELDCATALOG = GT_FCAT2.



*-- Tree 옵션 적용
  CALL METHOD GCL_TREE_2->EXPAND_TREE
    EXPORTING
      I_LEVEL = 1.

*  CALL METHOD GCL_TREE_2->COLUMN_OPTIMIZE
*    EXPORTING
*      I_START_COLUMN = GCL_TREE_2->C_HIERARCHY_COLUMN_NAME
*      I_END_COLUMN   = GCL_TREE_2->C_HIERARCHY_COLUMN_NAME.

*&---------------------------------------------------------------------*
*&      2. GCL_TREE_3 (자본 트리/GO_BOT)
*&---------------------------------------------------------------------*


  GS_VARIANT-REPORT = SY-REPID.
  GS_VARIANT-HANDLE = '3'.

*-- Display 하여 확인하기
  CALL METHOD GCL_TREE_3->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
      I_SAVE          = 'A'
      IS_LAYOUT       = GS_LAYOUT
      I_STRUCTURE_NAME = 'ZEA_BSEG'
      IS_VARIANT      = GS_VARIANT   "핸들로 구별
    CHANGING
      IT_OUTTAB       = GT_DATA3
      IT_SORT         = GT_SORT3
      IT_FIELDCATALOG = GT_FCAT3.


*-- Tree 옵션 적용
  CALL METHOD GCL_TREE_3->EXPAND_TREE
    EXPORTING
      I_LEVEL = 1.

*  CALL METHOD GCL_TREE_3->COLUMN_OPTIMIZE
*    EXPORTING
*      I_START_COLUMN = GCL_TREE_3->C_HIERARCHY_COLUMN_NAME
*      I_END_COLUMN   = GCL_TREE_3->C_HIERARCHY_COLUMN_NAME.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_FACT_2
*&---------------------------------------------------------------------*
FORM SET_FACT_2 .

  GS_LAYOUT-ZEBRA      = 'X'.
  GS_LAYOUT-CWIDTH_OPT = 'A'.
  GS_LAYOUT-SEL_MODE   = 'D'.

  REFRESH GT_FCAT2.
  REFRESH GT_FCAT3.
*
  PERFORM SET_FCAT
  TABLES GT_FCAT2
  USING :
   'X'   'LEVEL0_TEXT'  '계정과목'   ' '   ' ',
   'X'   'SAKNR'        '계정번호'   'ZEA_SKB1'   'SAKNR',
   ' '   'DMBTR'         ' '          'ZEA_BSEG'   'DMBTR',
   ' '   'D_WAERS'       ' '          'ZEA_BSEG'   'D_WAERS'.

  PERFORM SET_FCAT
  TABLES GT_FCAT3
  USING :
   'X'   'LEVEL0_TEXT'  '계정과목'   ' '   ' ',
   'X'   'SAKNR'        '계정번호'   'ZEA_SKB1'   'SAKNR',
   ' '   'DMBTR'         ' '          'ZEA_BSEG'   'DMBTR',
   ' '   'D_WAERS'       ' '          'ZEA_BSEG'   'D_WAERS'.


ENDFORM.
