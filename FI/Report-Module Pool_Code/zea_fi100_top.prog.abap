*&---------------------------------------------------------------------*
*& Include          ZEA_FI_BS_TOP
*&---------------------------------------------------------------------*

CLASS : LCL_EVENT_HANDLER DEFINITION DEFERRED.
DATA : GCL_HANDLER TYPE REF TO LCL_EVENT_HANDLER.
DATA : GCL_HANDLER_2 TYPE REF TO LCL_EVENT_HANDLER.
DATA : GCL_HANDLER_3 TYPE REF TO LCL_EVENT_HANDLER.

**********************************************************************
* TABLES
**********************************************************************
TABLES : ZEA_BKPF,   "[FI] 전표 Header 테이블
         ZEA_BSEG,   "[FI] 전표 Item   테이블
         ZEA_SKB1,   "[FI] G/L 마스터  테이블
         MTREESNODE, "[TR] NODE 테이블
         ZEA_TBSL,   "[FI] 전기키 테이블
         ZEA_SKA1.   "[FI] BP 마스터 테이블

**********************************************************************
* Internal table and Work area
**********************************************************************
TYPES : BEGIN OF TS_DATA.
          INCLUDE STRUCTURE ZEA_BSEG. " 회계연도 / G/L코드 / GLTXT / 금액/ 세금
TYPES :                               " BSCHL(전기키)
          LEVEL0          TYPE SETID,
          LEVEL0_TEXT(50),
          LEVEL1          TYPE SETID,
          LEVEL1_TEXT(50),
          LEVEL2          TYPE SETID,
          LEVEL2_TEXT(50),

          NEW_SAKNR       TYPE ZEA_BSEG-SAKNR,   " 계정 코드
          S_AMOUNT        TYPE ZEA_BSEG-DMBTR,   " 차변 금액
          H_AMOUNT        TYPE ZEA_BSEG-DMBTR,   " 대변 금액
          T_AMOUNT        TYPE ZEA_BSEG-DMBTR,   " 토탈 금액 여부
          INDI_CD         TYPE ZEA_TBSL-INDI_CD, " 차대변 구분 여부

          BPNAME          TYPE ZEA_SKA1-BPNAME,

        END OF TS_DATA.

*---For Select
* 1. GT_DATA - 자산 테이블
DATA : GT_DATA TYPE TABLE OF TS_DATA,
       GS_DATA TYPE TS_DATA.

* 2. GT_DATA - 부채/자본 테이블
DATA : GT_DATA2 TYPE TABLE OF TS_DATA,    "부채 담는 인터널 테이블
       GS_DATA2 TYPE TS_DATA,

       GT_DATA3 TYPE TABLE OF TS_DATA,    "자본 담는 인터널 테이블
       GS_DATA3 TYPE TS_DATA.

*---For Display
TYPES : BEGIN OF TS_DISPLAY.
TYPES :
  FLTXT2   TYPE ZEA_SKB1-GLTXT,  "계정과목 폴더 (상위) - 자산/부채/자본 - 구분
  FLTXT    TYPE ZEA_SKB1-GLTXT,  "계정과목 폴더 (하위) - 유동/비유동 구분
  GLTXT    TYPE ZEA_SKB1-GLTXT,  "계정명
  SAKNR    TYPE ZEA_SKB1-SAKNR,  "계정코드

  T_AMOUNT TYPE ZEA_BSEG-DMBTR,  "금액(=차대변 차액)
  H_AMOUNT TYPE ZEA_BSEG-DMBTR,
  S_AMOUNT TYPE ZEA_BSEG-DMBTR,

  D_WAERS  TYPE ZEA_BSEG-D_WAERS, " 통화코드
  END OF TS_DISPLAY.

DATA : GT_DISPLAY1 TYPE TABLE OF TS_DISPLAY,
       GS_DISPLAY1 TYPE TS_DISPLAY,

       GT_DISPLAY2 TYPE TABLE OF TS_DISPLAY,
       GS_DISPLAY2 TYPE TS_DISPLAY,

       GT_DISPLAY3 TYPE TABLE OF TS_DISPLAY,
       GS_DISPLAY3 TYPE TS_DISPLAY.

**********************************************************************
* Class instance
**********************************************************************
* Tree ALV  (자산)
DATA : GCL_CONTAINER TYPE REF TO CL_GUI_DOCKING_CONTAINER,
       GCL_TREE      TYPE REF TO CL_GUI_ALV_TREE_SIMPLE,

*-- Field Catalog
       GS_FCAT       TYPE LVC_S_FCAT,
       GT_FCAT       TYPE LVC_T_FCAT,
       GT_FCAT2      TYPE LVC_T_FCAT,
       GT_FCAT3      TYPE LVC_T_FCAT,

*-- ALV Tree Sort
       GS_SORT       TYPE LVC_S_SORT,
       GT_SORT       TYPE LVC_T_SORT,

       GT_SORT2      TYPE LVC_T_SORT,
       GS_SORT2      TYPE LVC_s_SORT,

       GT_SORT3      TYPE LVC_T_SORT,
       GS_SORT3      TYPE LVC_s_SORT,

*-- ALV Layout
       GS_LAYOUT     TYPE LVC_S_LAYO,
       GS_LAYOUT2    TYPE LVC_S_LAYO,
       GS_LAYOUT3    TYPE LVC_S_LAYO,

       GS_VARIANT    TYPE DISVARIANT.

* Tree ALV (부채/자본)----------------------------------------------*
DATA :
  GCL_CONTAINER_2 TYPE REF TO CL_GUI_DOCKING_CONTAINER,   "오른쪽 Docking Container
  GO_SPLIT        TYPE REF TO CL_GUI_SPLITTER_CONTAINER,  "Split
  GO_TOP          TYPE REF TO CL_GUI_CONTAINER,           "Top    (부채)
  GO_BOT          TYPE REF TO CL_GUI_CONTAINER,           "Bottom (자본)

  GCL_TREE_2      TYPE REF TO CL_GUI_ALV_TREE_SIMPLE,   "부채 트리
  GCL_TREE_3      TYPE REF TO CL_GUI_ALV_TREE_SIMPLE.   "자본 트리

**********************************************************************
*  Aout Tree
**********************************************************************
* 0. Tree 테이블
* 트리관련 전역 변수
DATA: GO_GUI_SIMPLE_TREE TYPE REF TO CL_GUI_SIMPLE_TREE,    "SIMPLE TREE
      GO_GUI_COLUMN_TREE TYPE REF TO CL_GUI_COLUMN_TREE,    "COLUMN TREE
      GO_GUI_LIST_TREE   TYPE REF TO CL_GUI_LIST_TREE.      "LIST TREE

DATA: GT_NODES                 TYPE STANDARD TABLE OF MTREESNODE,   "트리에 표시할 노드
      GS_NODES                 TYPE MTREESNODE,
      GT_ITEMS                 TYPE STANDARD TABLE OF MTREEITM,     "트리 노드의 컬럼
      GS_HIERARCHY_HEADER      TYPE TREEV_HHDR,     "트리의 Hierarchy 헤더
      GV_HIERARCHY_COLUMN_NAME TYPE TV_ITMNAME,     "트리의 Hierarchy 컬럼 이름(CL_GUI_COLUMN_TREE에서 사용)
      GS_LIST_HEADER           TYPE TREEV_LHDR,     "트리의 List 헤더(CL_GUI_LIST_TREE에서 사용)
      GV_ITEM_SELECTION        TYPE C.              "트리의 아이템(노드의 컬럼) 선택 가능 여부

* Evnet 관련 변수
DATA : GT_EVENT    TYPE CNTL_SIMPLE_EVENTS,
       GS_EVENT    LIKE LINE OF GT_EVENT,
*       GCL_HANDLER TYPE REF TO LCL_EVENT_HANDLER,
       GV_NODE     TYPE I.
**********************************************************************
* Common variable
**********************************************************************

DATA :          OK_CODE TYPE SY-UCOMM.

DATA :
  GV_SCR_ON  TYPE CHAR1,
  GV_SAVE    TYPE C,
  GV_LINES   TYPE SY-TFILL,
  GV_ANSWER  TYPE CHAR1,
  GV_CHANGED TYPE CHAR1.

**********************************************************************
* 범위값을 가져오는  Range 변수
**********************************************************************

RANGES: R_SAKNR_1  FOR ZEA_SKB1-SAKNR. " GL계정 - 자산
RANGES: R_SAKNR_2  FOR ZEA_SKB1-SAKNR. " GL계정 - 자본
RANGES: R_SAKNR_3  FOR ZEA_SKB1-SAKNR. " GL계정 - 부채


*  " 자산  : 1로 시작
R_SAKNR_1-SIGN   = 'I'.
R_SAKNR_1-OPTION = 'CP'.
R_SAKNR_1-LOW = '1*'.
APPEND R_SAKNR_1.

" 부채     : 2로 시작
R_SAKNR_2-SIGN   = 'I'.
R_SAKNR_2-OPTION = 'CP'.
R_SAKNR_2-LOW = '2*'.
APPEND R_SAKNR_2.

" 자본 : 3로 시작
R_SAKNR_3-SIGN   = 'I'.
R_SAKNR_3-OPTION = 'CP'.
R_SAKNR_3-LOW = '3*'.
APPEND R_SAKNR_3.
