*&---------------------------------------------------------------------*
*& Include          ZEA_TR_TEM_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
FORM GET_DATA .

  " Internal Table의 내용을 전부 비워둠
  REFRESH GT_DATA[].

* --B/S 계정 (자산)
  SELECT

    B~GJAHR   " 회계연도
    B~SAKNR   " G/L계정 (Recon)
    B~BPCODE  "BP CODE
    D~INDI_CD "차대변 구분자
    C~GLTXT   " G/L계정명
    SUM( B~DMBTR ) AS DMBTR "  통화금액 합계
*    SUM( B~EATAX ) AS EATAX " 세금 합계
  INTO CORRESPONDING FIELDS OF TABLE GT_DATA
  FROM ZEA_BKPF AS A        " A: 전표 헤더
 INNER JOIN ZEA_BSEG AS B   " B: 전표 아이템
    ON A~BUKRS EQ B~BUKRS
   AND A~BELNR EQ B~BELNR
   AND A~GJAHR EQ B~GJAHR
 INNER JOIN ZEA_SKB1 AS C   " C: G/L계정마스터
    ON C~BUKRS EQ A~BUKRS
   AND C~SAKNR EQ B~SAKNR
*   AND C~GLTXT EQ B~GLTXT
   AND C~XBILK EQ 'X'        " G/L코드 Type - 'X': 대차대조 / '' : 손익계산
INNER JOIN ZEA_TBSL AS D     "D : 전기키 테이블
    ON D~BSCHL EQ B~BSCHL
 INNER JOIN ZEA_SKA1 AS E   "E : BP 마스터
    ON B~BPCODE EQ E~BPCODE

  WHERE C~SAKNR IN R_SAKNR_1
  GROUP BY B~GJAHR B~SAKNR B~BPCODE D~INDI_CD C~GLTXT .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat
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
    WHEN 'T_AMOUNT'.
      PT_FCAT-CFIELDNAME = 'D_WAERS'.

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
      SIDE  = GCL_CONTAINER->DOCK_AT_LEFT
*     EXTENSION = 1000
      RATIO = 50.

  CREATE OBJECT GCL_TREE
    EXPORTING
      I_PARENT              = GCL_CONTAINER
*     I_NODE_SELECTION_MODE = CL_GUI_COLUMN_TREE=>NODE_SEL_MODE_MULTIPLE
      I_NODE_SELECTION_MODE = CL_GUI_COLUMN_TREE=>ALIGN_AT_LEFT
      I_ITEM_SELECTION      = 'X'
      I_NO_HTML_HEADER      = 'X'
      I_NO_TOOLBAR          = SPACE.

  GS_VARIANT-REPORT = SY-REPID.
  GS_VARIANT-HANDLE = '1'.

  CALL METHOD GCL_TREE->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
      I_SAVE          = 'A'
      IS_LAYOUT       = GS_LAYOUT
      IS_VARIANT      = GS_VARIANT
    CHANGING
      IT_OUTTAB       = GT_DISPLAY1
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
  GS_SORT-SPOS = 1.             "정렬순서를 지정
  GS_SORT-FIELDNAME = 'FLTXT'.  "자산 폴더
* GS_SORT-SELTEXT = '계정과목'.
  GS_SORT-UP        = 'X'.  "오름차순 정렬
  GS_SORT-SUBTOT    = 'X'.    "중간합 구하기

  APPEND GS_SORT TO PT_SORT.
  CLEAR  GS_SORT.

  GS_SORT-SPOS = 2.              "정렬순서를 지정
  GS_SORT-FIELDNAME = 'FLTXT2'.  "유동/비유동 구분
* GS_SORT-SELTEXT = '계정과목'.
  GS_SORT-DOWN        = 'X'.  "내림차순 정렬(Ex. 유동, 비유동 순)
*  GS_SORT-SUBTOT    = 'X'.    "중간합 구하기

  APPEND GS_SORT TO PT_SORT.
  CLEAR  GS_SORT.
*
  "2. 계정번호
  GS_SORT-SPOS = 3.
  GS_SORT-FIELDNAME = 'GLTXT'.  "계정코드
  GS_SORT-UP        = 'X'.
*  GS_SORT-SUBTOT    = 'X'.

  APPEND GS_SORT TO PT_SORT.
  CLEAR  GS_SORT.

  "3. 금액
  GS_SORT-SPOS = 3.
  GS_SORT-FIELDNAME = 'SAKNR'.
  GS_SORT-UP        = 'X'.
*  GS_SORT-SUBTOT    = 'X'.

  APPEND GS_SORT TO PT_SORT.
  CLEAR  GS_SORT.

  "4. 통화금액
*  GS_SORT-SPOS = 3.
*  GS_SORT-FIELDNAME = 'T_AMOUNT'.
*  GS_SORT-UP        = 'X'.
*  GS_SORT-SUBTOT    = 'X'.

*  APPEND GS_SORT TO PT_SORT.
*  CLEAR  GS_SORT.

  "5. H_AMOUNT
  "6. S_AMOUNT
  "위 필드는 보여주지 않음.
*
*  "7. D_WAERS
*  GS_SORT-SPOS = 3.
*  GS_SORT-FIELDNAME = 'D_WAERS'.
*  GS_SORT-UP        = 'X'.
*  GS_SORT-SUBTOT    = 'X'.
*
*  APPEND GS_SORT TO PT_SORT.
*  CLEAR  GS_SORT.


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
  GV_SAVE = 'A'.


  REFRESH GT_FCAT.
  PERFORM SET_FCAT
  TABLES GT_FCAT
     USING :

   ' '   'FLTXT'        '계정과목'        ' '         ' ',
   ' '   'FLTXT2'       '유동/비유동'     ' '         ' ',
   ' '   'GLTXT'        '계정명'     'ZEA_SKB1'    'GLTXT',
   ' '   'SAKNR'        'G/L계정'    'ZEA_SKB1'    'SAKNR',
   ' '   'T_AMOUNT'     'Amount'     'ZEA_BSEG'    'DMBTR',
   ' '   'D_WAERS'      '통화코드'   'ZEA_BSEG'    'D_WAERS'.

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

* --B/S 계정 (부채)
  SELECT

  B~GJAHR   " 회계연도
  B~SAKNR   " G/L계정 (Recon)
  D~INDI_CD "차대변 구분자
  C~GLTXT   " G/L계정명
  SUM( B~DMBTR ) AS DMBTR "  통화금액 합계
*  SUM( B~EATAX ) AS EATAX " 세금 합계
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
INNER JOIN ZEA_TBSL AS D     "D : 전기키 테이블
  ON D~BSCHL EQ B~BSCHL

WHERE C~SAKNR IN R_SAKNR_2   "2로 시작하는 G/L은 부채에 해당
GROUP BY B~GJAHR B~SAKNR D~INDI_CD C~GLTXT .

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
    D~INDI_CD "차대변 구분자
    C~GLTXT   " G/L계정명
    SUM( B~DMBTR ) AS DMBTR "  통화금액 합계
*    SUM( B~EATAX ) AS EATAX " 세금 합계
  INTO CORRESPONDING FIELDS OF TABLE GT_DATA3   "자본이력 테이블
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
INNER JOIN ZEA_TBSL AS D     "D : 전기키 테이블
    ON D~BSCHL EQ B~BSCHL

  WHERE C~SAKNR IN R_SAKNR_3 "3으로 시작하는 것은 자본
  GROUP BY B~GJAHR B~SAKNR D~INDI_CD C~GLTXT .
*
*  GS_DATA3-NEW_SAKNR =  '350000'.
*  GS_DATA3-T_AMOUNT = LV_INCOME.
*  APPEND  GS_DATA3 TO GT_DATA3.

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
      RATIO                       = 50
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
      HEIGHT            = 50 " %로 옴.
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
      I_NODE_SELECTION_MODE = CL_GUI_ALV_TREE_SIMPLE=>ALIGN_AT_LEFT
      I_ITEM_SELECTION      = 'X'
      I_NO_HTML_HEADER      = 'X'
      I_NO_TOOLBAR          = ' '.

  GS_VARIANT-REPORT = SY-REPID.


*&---------------------------------------------------------------------*
*&      2. GCL_TREE_3 (자본 트리 -> GO_BOT과 연결)
*&---------------------------------------------------------------------*
*-- Tree 생성 후 Bottom 에 붙이기
  CREATE OBJECT GCL_TREE_3
    EXPORTING
      I_PARENT              = GO_BOT
      I_NODE_SELECTION_MODE = CL_GUI_ALV_TREE_SIMPLE=>ALIGN_AT_LEFT
      I_ITEM_SELECTION      = 'X'
      I_NO_HTML_HEADER      = 'X'
      I_NO_TOOLBAR          = ' '.

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
      I_SAVE          = 'A'
      IS_LAYOUT       = GS_LAYOUT2
      IS_VARIANT      = GS_VARIANT
    CHANGING
      IT_OUTTAB       = GT_DISPLAY2     "부채 인터널 테이블과 연결
      IT_SORT         = GT_SORT2
      IT_FIELDCATALOG = GT_FCAT2.

*-- Tree 옵션 적용
  CALL METHOD GCL_TREE_2->EXPAND_TREE
    EXPORTING
      I_LEVEL = 1.

*-- Column 열 최적화

  CALL METHOD GCL_TREE_2->COLUMN_OPTIMIZE
    EXPORTING
      I_START_COLUMN    = GCL_TREE_2->C_HIERARCHY_COLUMN_NAME                 " First Column to Optimize
      I_END_COLUMN      = GCL_TREE_2->C_HIERARCHY_COLUMN_NAME                 " Last Column to Optimize
      I_INCLUDE_HEADING = 'X'.                                             " Include Heading

*&---------------------------------------------------------------------*
*&      2. GCL_TREE_3 (자본 트리/GO_BOT)
*&---------------------------------------------------------------------*


  GS_VARIANT-REPORT = SY-REPID.
  GS_VARIANT-HANDLE = '3'.

*-- Display 하여 확인하기
  CALL METHOD GCL_TREE_3->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
      I_SAVE          = 'A'
      IS_LAYOUT       = GS_LAYOUT3
      IS_VARIANT      = GS_VARIANT   "핸들로 구별
    CHANGING
      IT_OUTTAB       = GT_DISPLAY3  "자본 인터널 테이블
      IT_SORT         = GT_SORT3
      IT_FIELDCATALOG = GT_FCAT3.


*-- Tree 옵션 적용
  CALL METHOD GCL_TREE_3->EXPAND_TREE
    EXPORTING
      I_LEVEL = 1.


*-- Column 열 최적화

  CALL METHOD GCL_TREE_3->COLUMN_OPTIMIZE
    EXPORTING
      I_START_COLUMN    = GCL_TREE_3->C_HIERARCHY_COLUMN_NAME                 " First Column to Optimize
      I_END_COLUMN      = GCL_TREE_3->C_HIERARCHY_COLUMN_NAME                 " Last Column to Optimize
      I_INCLUDE_HEADING = 'X'.                                             " Include Heading


ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_FACT_2
*&---------------------------------------------------------------------*
FORM SET_FACT_2 .

*-- Set Layout 1,2,3
  PERFORM SET_LAYOUT.

*-- Set Field Catalog 1,2,3
  REFRESH GT_FCAT2.
  REFRESH GT_FCAT3.

  PERFORM SET_FCAT
  TABLES GT_FCAT2
  USING :

   ' '   'FLTXT'        '계정과목'        ' '         ' ',
   ' '   'FLTXT2'       '유동/비유동'     ' '         ' ',
   ' '   'GLTXT'        '계정명'     'ZEA_SKB1'    'GLTXT',
   ' '   'SAKNR'        'G/L계정'    'ZEA_SKB1'    'SAKNR',
   ' '   'T_AMOUNT'     'Amount'     'ZEA_BSEG'    'DMBTR',
   ' '   'D_WAERS'      '통화코드'   'ZEA_BSEG'    'D_WAERS'.

  PERFORM SET_FCAT
  TABLES GT_FCAT3
  USING :

   ' '   'FLTXT'        '계정과목'        ' '         ' ',
   ' '   'FLTXT2'       '유동/비유동'     ' '         ' ',
   ' '   'GLTXT'        '계정명'     'ZEA_SKB1'    'GLTXT',
   ' '   'SAKNR'        'G/L계정'    'ZEA_SKB1'    'SAKNR',
   ' '   'T_AMOUNT'     'Amount'     'ZEA_BSEG'    'DMBTR',
   ' '   'D_WAERS'      '통화코드'   'ZEA_BSEG'    'D_WAERS'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MOVE_DISPLAY
*&---------------------------------------------------------------------*
FORM MOVE_DISPLAY .

  DATA : LT_DATA  TYPE TABLE OF  TS_DISPLAY,
         LS_DATA  TYPE TS_DISPLAY,
         LV_INDEX TYPE SY-TABIX.

  REFRESH GT_DISPLAY1. "인터널 테이블 초기화
  REFRESH LT_DATA. "인터널 테이블 초기화

  "SAKN 별 합계 계산
  LOOP AT GT_DATA INTO GS_DATA.
    CLEAR LS_DATA. "사용하기 전 초기화

    CASE GS_DATA-INDI_CD.
      WHEN 'S'.
        LS_DATA-S_AMOUNT = GS_DATA-DMBTR. "차변 값의 합계
      WHEN 'H'.
        LS_DATA-H_AMOUNT = GS_DATA-DMBTR. "대변 값의 합계
    ENDCASE.


    "SAKNR(계정코드)별 딱 한 값만 저장되도록
    READ TABLE LT_DATA INTO LS_DATA WITH KEY SAKNR = GS_DATA-SAKNR.

    IF SY-SUBRC NE 0.
*--- 유동/비유동 구분 후 폴더 노드 값 부여
      IF GS_DATA-SAKNR CP '10*'.
        LS_DATA-FLTXT2  = '유동 자산'.
      ELSE.
        LS_DATA-FLTXT2  = '비유동 자산'.
      ENDIF.
      LS_DATA-FLTXT = '자산'.
*--- ----- ---- BP NAME 불러오기
      IF GS_DATA-BPCODE IS NOT INITIAL.
        SELECT SINGLE * FROM ZEA_SKA1 INTO ZEA_SKA1 WHERE BPCODE EQ GS_DATA-BPCODE.
        LS_DATA-GLTXT = GS_DATA-GLTXT && '(파트너:' && ZEA_SKA1-BPNAME && ')'.     "계정명
      ELSE. "BP CODE가 없는 경우
        "자산
        LS_DATA-GLTXT = GS_DATA-GLTXT .     "계정명
      ENDIF.
      LS_DATA-SAKNR = GS_DATA-SAKNR .  "계정번호
      LS_DATA-D_WAERS = 'KRW'.                                "통화코드

*----           계정잔액 구하기
      CASE GS_DATA-INDI_CD.
        WHEN 'S'.

          READ TABLE GT_DATA INTO GS_DATA WITH KEY INDI_CD = 'H' SAKNR = LS_DATA-SAKNR.

          IF SY-SUBRC NE 0.
            LS_DATA-T_AMOUNT = LS_DATA-S_AMOUNT.
          ELSE. "대변이 있다면 ?
            LS_DATA-T_AMOUNT = LS_DATA-S_AMOUNT -  GS_DATA-DMBTR.
          ENDIF.
        WHEN 'H'. "지금 돌고있는 GS_DATA는 대변 금액 .

          READ TABLE GT_DATA INTO GS_DATA WITH KEY INDI_CD = 'S' SAKNR = LS_DATA-SAKNR.

          IF SY-SUBRC NE 0. "실패. 한값밖에 없음.
            LS_DATA-T_AMOUNT = LS_DATA-H_AMOUNT.
          ELSE. "차변이 있다면?
            LS_DATA-T_AMOUNT = LS_DATA-H_AMOUNT -  GS_DATA-DMBTR.
          ENDIF.

      ENDCASE.

      APPEND LS_DATA TO LT_DATA.

    ELSE. " 딱 한번만 저장되어야 하기 때문 (S/H ->  T)

    ENDIF.

    MODIFY LT_DATA FROM LS_DATA INDEX  SY-TABIX.

  ENDLOOP.

  APPEND LINES OF LT_DATA TO GT_DISPLAY1.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MOVE_DISPLAY2
*&---------------------------------------------------------------------*
FORM MOVE_DISPLAY2 .

  DATA : LT_DATA  TYPE TABLE OF  TS_DISPLAY,
         LS_DATA  TYPE TS_DISPLAY,
         LV_INDEX TYPE SY-TABIX.

  REFRESH GT_DISPLAY2. "인터널 테이블 초기화
  REFRESH LT_DATA. "인터널 테이블 초기화


  "SAKN 별 합계 계산
  LOOP AT GT_DATA2 INTO GS_DATA2.
    CLEAR LS_DATA. "사용하기 전 초기화

    CASE GS_DATA2-INDI_CD.
      WHEN 'S'.
        LS_DATA-S_AMOUNT = GS_DATA2-DMBTR. "차변 값의 합계
      WHEN 'H'.
        LS_DATA-H_AMOUNT = GS_DATA2-DMBTR. "대변 값의 합계
    ENDCASE.


    "SAKNR(계정코드)별 딱 한 값만 저장되도록
    READ TABLE LT_DATA INTO LS_DATA WITH KEY SAKNR = GS_DATA2-SAKNR.
    IF SY-SUBRC NE 0.
*---- 유동/비유동 구분 후 하위 폴더 노드 값 부여

      IF GS_DATA2-SAKNR CP  '22*'.
        LS_DATA-FLTXT2 = '비유동 부채'.
      ELSE.
        LS_DATA-FLTXT2 = '유동 부채'.
      ENDIF.

      LS_DATA-FLTXT = '부채'.                                 "폴더명(상위)
*--- ----- ---- BP NAME 불러오기
      IF GS_DATA2-BPCODE IS NOT INITIAL.
        SELECT SINGLE * FROM ZEA_SKA1 INTO ZEA_SKA1 WHERE BPCODE EQ GS_DATA-BPCODE.
        LS_DATA-GLTXT = GS_DATA2-GLTXT && '(파트너:' && ZEA_SKA1-BPNAME && ')'.     "계정명
      ELSE. "BP CODE가 없는 경우
        "자산
        LS_DATA-GLTXT = GS_DATA2-GLTXT .     "계정명
      ENDIF.
      LS_DATA-SAKNR = GS_DATA2-SAKNR.                         "계정번호
      LS_DATA-D_WAERS = 'KRW'.                                "통화코드

*----           계정잔액 구하기

      CASE GS_DATA-INDI_CD.

        WHEN 'S'.

          READ TABLE GT_DATA2 INTO GS_DATA2 WITH KEY INDI_CD = 'H' SAKNR = LS_DATA-SAKNR.

          IF SY-SUBRC NE 0.
            LS_DATA-T_AMOUNT = LS_DATA-S_AMOUNT.
          ELSE. "대변이 있다면 ?
            LS_DATA-T_AMOUNT =  GS_DATA2-DMBTR - LS_DATA-S_AMOUNT.
          ENDIF.
        WHEN 'H'. "지금 돌고있는 GS_DATA는 대변 금액 .

          READ TABLE GT_DATA2 INTO GS_DATA2 WITH KEY INDI_CD = 'S' SAKNR = LS_DATA-SAKNR.

          IF SY-SUBRC NE 0. "실패. 한값밖에 없음.
            LS_DATA-T_AMOUNT = LS_DATA-H_AMOUNT.
          ELSE. "차변이 있다면?
            LS_DATA-T_AMOUNT = GS_DATA2-DMBTR - LS_DATA-H_AMOUNT .
          ENDIF.

      ENDCASE.

      APPEND LS_DATA TO LT_DATA.

    ELSE. " 딱 한번만 저장되어야 하기 때문 (S/H ->  T)

    ENDIF.

    MODIFY LT_DATA FROM LS_DATA INDEX  SY-TABIX.

  ENDLOOP.

  APPEND LINES OF LT_DATA TO GT_DISPLAY2.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form MOVE_DISPLAY3
*&---------------------------------------------------------------------*
FORM MOVE_DISPLAY3 .

  DATA : LT_DATA  TYPE TABLE OF  TS_DISPLAY,
         LS_DATA  TYPE TS_DISPLAY,
         LV_INDEX TYPE SY-TABIX.

  REFRESH GT_DISPLAY3. "인터널 테이블 초기화
  REFRESH LT_DATA. "인터널 테이블 초기화


  "SAKN 별 합계 계산
  LOOP AT GT_DATA3 INTO GS_DATA3.
    CLEAR LS_DATA. "사용하기 전 초기화

    CASE GS_DATA3-INDI_CD.
      WHEN 'S'.
        LS_DATA-S_AMOUNT = GS_DATA3-DMBTR. "차변 값의 합계
      WHEN 'H'.
        LS_DATA-H_AMOUNT = GS_DATA3-DMBTR. "대변 값의 합계
    ENDCASE.

    "SAKNR(계정코드)별 딱 한 값만 저장되도록
    READ TABLE LT_DATA INTO LS_DATA WITH KEY SAKNR = GS_DATA3-SAKNR.
    IF SY-SUBRC NE 0.
      LS_DATA-FLTXT = '자본'.                                 "계정폴더(상위)
      LS_DATA-FLTXT2 = '자본금'.                              "계정폴더(하위)
      LS_DATA-GLTXT = GS_DATA3-GLTXT.                         "계정명
      LS_DATA-SAKNR = GS_DATA3-SAKNR.                         "계정번호
      LS_DATA-D_WAERS = 'KRW'.                                "통화코드

*----           계정잔액 구하기

      CASE GS_DATA-INDI_CD.

        WHEN 'S'.

          READ TABLE GT_DATA3 INTO GS_DATA3 WITH KEY INDI_CD = 'H' SAKNR = LS_DATA-SAKNR.

          IF SY-SUBRC NE 0.
            LS_DATA-T_AMOUNT = LS_DATA-S_AMOUNT.
          ELSE. "대변이 있다면 ?
            LS_DATA-T_AMOUNT = GS_DATA3-DMBTR - LS_DATA-S_AMOUNT .
          ENDIF.
        WHEN 'H'. "지금 돌고있는 GS_DATA는 대변 금액 .

          READ TABLE GT_DATA3 INTO GS_DATA3 WITH KEY INDI_CD = 'S' SAKNR = LS_DATA-SAKNR.

          IF SY-SUBRC NE 0. "실패. 한값밖에 없음.
            LS_DATA-T_AMOUNT = LS_DATA-H_AMOUNT.
          ELSE. "차변이 있다면?
            LS_DATA-T_AMOUNT =  GS_DATA3-DMBTR - LS_DATA-H_AMOUNT .
          ENDIF.

      ENDCASE.

      APPEND LS_DATA TO LT_DATA.

    ELSE. " 딱 한번만 저장되어야 하기 때문 (S/H ->  T)

    ENDIF.

    MODIFY LT_DATA FROM LS_DATA INDEX  SY-TABIX.

  ENDLOOP.

  APPEND LINES OF LT_DATA TO GT_DISPLAY3.

  GS_DISPLAY3-FLTXT2   = '자본'.  "계정과목 폴더 (상위) - 자산/부채/자본 - 구분
  GS_DISPLAY3-FLTXT = '자본금'. "계정과목 폴더 (하위) - 유동/비유동 구분
  GS_DISPLAY3-GLTXT = '이익잉여금'.
  GS_DISPLAY3-SAKNR =  '350000'.
  GS_DISPLAY3-T_AMOUNT = LV_INCOME.
  GS_DISPLAY3-D_WAERS = 'KRW'.

  APPEND  GS_DISPLAY3 TO GT_DISPLAY3.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_LAYOUT
*&---------------------------------------------------------------------*
FORM SET_LAYOUT .

  GS_LAYOUT-ZEBRA      = 'X'.
  GS_LAYOUT-CWIDTH_OPT = 'A'.
  GS_LAYOUT-SEL_MODE   = 'D'.


  GS_LAYOUT2-ZEBRA      = 'X'.
  GS_LAYOUT2-CWIDTH_OPT = 'A'.
  GS_LAYOUT2-SEL_MODE   = 'D'.


  GS_LAYOUT3-ZEBRA      = 'X'.
  GS_LAYOUT3-CWIDTH_OPT = 'A'.
  GS_LAYOUT3-SEL_MODE   = 'D'.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form CALL_SAKNR
*&---------------------------------------------------------------------*
FORM CALL_SAKNR  USING   PV_INDEX_OUTTAB PO_SENDERS PO_GROUPLEVEL .

  CASE  PO_SENDERS.
*&------------------자산 Tree
    WHEN GCL_TREE.

      CLEAR GS_DISPLAY1.
*--- 더블클릭 값 점검
      READ TABLE GT_DISPLAY1 INTO GS_DISPLAY1 INDEX PV_INDEX_OUTTAB. "선택한 노드를 가져와
      "찾기에 실패했다면 나가고
      IF SY-SUBRC NE 0.
        EXIT.
      ELSE.                                     "찾기에 성공한 경우

        IF PO_GROUPLEVEL NE 'GLTXT'.            "만약 클릭한 것이 'G/L Account'가 아닌 경우
          MESSAGE '상세조회는 계정과목 명을 선택해주세요.' TYPE 'E' DISPLAY LIKE 'S'.
          EXIT.
        ELSE.
          SET PARAMETER ID 'ZEA_SAKNR' FIELD GS_DISPLAY1-SAKNR.
          CALL TRANSACTION 'ZEA_FI040' AND SKIP FIRST SCREEN.
        ENDIF.
      ENDIF.
*&------------------부채 Tree
    WHEN GCL_TREE_2.

      CLEAR GS_DISPLAY2.
*--- 더블클릭 값 점검
      READ TABLE GT_DISPLAY2 INTO GS_DISPLAY2 INDEX PV_INDEX_OUTTAB. "선택한 노드를 가져와
      "찾기에 실패했다면 나가고
      IF SY-SUBRC NE 0.
        EXIT.
      ELSE.                                     "찾기에 성공한 경우

        IF PO_GROUPLEVEL NE 'GLTXT'.            "만약 클릭한 것이 'G/L Account'가 아닌 경우
          MESSAGE '상세조회는 계정과목 명을 선택해주세요.' TYPE 'E' DISPLAY LIKE 'S'.
          EXIT.
        ELSE.
          SET PARAMETER ID 'ZEA_SAKNR' FIELD GS_DISPLAY2-SAKNR.
          CALL TRANSACTION 'ZEA_FI040' AND SKIP FIRST SCREEN.
        ENDIF.
      ENDIF.
*&------------------자본 Tree
    WHEN GCL_TREE_3.

      READ TABLE GT_DISPLAY3 INTO GS_DISPLAY3 INDEX PV_INDEX_OUTTAB. "선택한 노드를 가져와
      "찾기에 실패했다면 나가고
      IF SY-SUBRC NE 0.
        EXIT.
      ELSE.                                     "찾기에 성공한 경우

         IF PO_GROUPLEVEL NE 'GLTXT'.            "만약 클릭한 것이 'G/L Account'가 아닌 경우
          MESSAGE '상세조회는 계정과목 명을 선택해주세요.' TYPE 'E' DISPLAY LIKE 'S'.
          EXIT.

        ELSE.
          IF GS_DISPLAY3-SAKNR EQ  '350000'.
            CALL TRANSACTION 'ZEA_FI090'
            AND SKIP FIRST SCREEN .
          ENDIF.
        ENDIF.
      ENDIF.


  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_HANDLER_TREE
*&---------------------------------------------------------------------*
FORM SET_HANDLER_TREE .

*-- For 자산 Tree

  CREATE OBJECT GCL_HANDLER.

  SET HANDLER :  GCL_HANDLER->HANDLE_DOUBLE_CLICK FOR GCL_TREE.

  DATA LT_EVENT TYPE CNTL_SIMPLE_EVENTS. "LT
  DATA LS_EVENT LIKE LINE OF LT_EVENT.   "WA


  GCL_TREE->GET_REGISTERED_EVENTS(
    IMPORTING
      EVENTS     =  LT_EVENT        " simple_events
    EXCEPTIONS
      CNTL_ERROR = 1                " cntl_error
      OTHERS     = 2
  ).
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
      WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

*--- Evnet 추가
  LS_EVENT-EVENTID = CL_GUI_SIMPLE_TREE=>EVENTID_NODE_DOUBLE_CLICK.
  LS_EVENT-APPL_EVENT = 'X'.
  APPEND LS_EVENT TO LT_EVENT.

  GCL_TREE->SET_REGISTERED_EVENTS(
    EXPORTING
      EVENTS                    =  LT_EVENT  " Event Table
    EXCEPTIONS
      CNTL_ERROR                = 1                " cntl_error
      CNTL_SYSTEM_ERROR         = 2                " cntl_system_error
      ILLEGAL_EVENT_COMBINATION = 3                " ILLEGAL_EVENT_COMBINATION
      OTHERS                    = 4
  ).
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
      WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_HANDLER_TREE2
*&---------------------------------------------------------------------*
FORM SET_HANDLER_TREE2 .

*-- For 자산 Tree

  SET HANDLER :  GCL_HANDLER->HANDLE_DOUBLE_CLICK FOR GCL_TREE_2.
*  SET HANDLER :  GCL_HANDLER->HANDLE_DOUBLE_CLICK FOR GCL_TREE_3.

  DATA LT_EVENT TYPE CNTL_SIMPLE_EVENTS. "LT
  DATA LS_EVENT LIKE LINE OF LT_EVENT.   "WA

  GCL_TREE_2->GET_REGISTERED_EVENTS(
    IMPORTING
      EVENTS     =  LT_EVENT        " simple_events
    EXCEPTIONS
      CNTL_ERROR = 1                " cntl_error
      OTHERS     = 2
  ).

  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
      WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

*--- Evnet 추가
  LS_EVENT-EVENTID = CL_GUI_SIMPLE_TREE=>EVENTID_NODE_DOUBLE_CLICK.
  LS_EVENT-APPL_EVENT = 'X'.
  APPEND LS_EVENT TO LT_EVENT.

  GCL_TREE_2->SET_REGISTERED_EVENTS(
    EXPORTING
      EVENTS                    =  LT_EVENT  " Event Table
    EXCEPTIONS
      CNTL_ERROR                = 1                " cntl_error
      CNTL_SYSTEM_ERROR         = 2                " cntl_system_error
      ILLEGAL_EVENT_COMBINATION = 3                " ILLEGAL_EVENT_COMBINATION
      OTHERS                    = 4
  ).
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
      WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_HANDLER_TREE3
*&---------------------------------------------------------------------*
FORM SET_HANDLER_TREE3 .

  SET HANDLER :  GCL_HANDLER->HANDLE_DOUBLE_CLICK FOR GCL_TREE_3.

  DATA LT_EVENT TYPE CNTL_SIMPLE_EVENTS. "LT
  DATA LS_EVENT LIKE LINE OF LT_EVENT.   "WA

  GCL_TREE_3->GET_REGISTERED_EVENTS(
    IMPORTING
      EVENTS     =  LT_EVENT        " simple_events
    EXCEPTIONS
      CNTL_ERROR = 1                " cntl_error
      OTHERS     = 2
  ).

  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
      WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

*--- Evnet 추가
  LS_EVENT-EVENTID = CL_GUI_SIMPLE_TREE=>EVENTID_NODE_DOUBLE_CLICK.
  LS_EVENT-APPL_EVENT = 'X'.
  APPEND LS_EVENT TO LT_EVENT.

  GCL_TREE_3->SET_REGISTERED_EVENTS(
    EXPORTING
      EVENTS                    =  LT_EVENT  " Event Table
    EXCEPTIONS
      CNTL_ERROR                = 1                " cntl_error
      CNTL_SYSTEM_ERROR         = 2                " cntl_system_error
      ILLEGAL_EVENT_COMBINATION = 3                " ILLEGAL_EVENT_COMBINATION
      OTHERS                    = 4
  ).
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
      WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.
