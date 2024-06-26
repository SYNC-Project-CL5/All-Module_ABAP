*&---------------------------------------------------------------------*
*& Include ZEA_OPEN_MANG_TOP
*&---------------------------------------------------------------------*
REPORT ZEA_OPEN_MANG_TOP MESSAGE-ID ZEA_MSG_FI.

**********************************************************************
* TABLES
**********************************************************************
TABLES : ZEA_FIT700 , "고객원장 테이블
         ZEA_BKPF ,   "전표 헤더 테이블
         ZEA_BSEG ,   "전표 아이템 테이블
         ZEA_KNA1 ,   "고객 마스터 테이블
         ZEA_SKB1 .   "G/L 마스터 테이블

  " FI 전표 아이템 테이블
  DATA: GT_BSEG TYPE TABLE OF ZEA_BSEG,
        GS_BSEG TYPE ZEA_BSEG.

  DATA : GT_FIT700 LIKE TABLE OF ZEA_FIT700,
       GS_FIT700 TYPE ZEA_FIT700.
**********************************************************************
* Class instance
**********************************************************************
DATA : GO_CONTAINER     TYPE REF TO CL_GUI_DOCKING_CONTAINER,
       GO_ALV_GRID      TYPE REF TO CL_GUI_ALV_GRID,
*-- For Top-of-page -------------------------------------------------*
       GO_TOP_CONTAINER TYPE REF TO CL_GUI_DOCKING_CONTAINER,
       GO_DYNDOC_ID     TYPE REF TO CL_DD_DOCUMENT,
       GO_HTML_CNTRL    TYPE REF TO CL_GUI_HTML_VIEWER.

**********************************************************************
* Internal table and Work area
**********************************************************************
DATA : BEGIN OF GS_DATA.
         INCLUDE STRUCTURE ZEA_FIT700.

DATA :   STATUS           TYPE C LENGTH 1,       "반제여부 체크용
         MANG             TYPE ZEA_FIT700-BLDAT, "만기일 계산용
         GTEXT            TYPE TGSBT-GTEXT,
         CELL_TAB         TYPE LVC_T_STYL,
         DROP_DOWN_HANDLE TYPE INT4,
         ZLSCH            TYPE ZEA_KNA1-ZLSCH,
       END OF GS_DATA.

DATA : GT_DATA LIKE TABLE OF GS_DATA.

*-- For ALV
DATA : GS_VARIANT  TYPE DISVARIANT,
       GT_FIELDCAT TYPE LVC_T_FCAT,
       GS_FIELDCAT TYPE LVC_S_FCAT,
       GS_LAYOUT   TYPE LVC_S_LAYO,
       GV_SAVE    TYPE CHAR01.

*-- ALV Toolbar
DATA : GS_TOOLBAR      TYPE STB_BUTTON,   " For ALV Toolbar button
       GT_UI_FUNCTIONS TYPE UI_FUNCTIONS, " Exclude ALV Standard button
       GS_STABLE       TYPE LVC_S_STBL,   " Stable when ALV refresh

       GT_FILTER       TYPE LVC_T_FILT,
       GS_FILTER       TYPE LVC_S_FILT,

       GT_INDEX_ROWS   TYPE LVC_T_ROW,
       GS_INDEX_ROWS   TYPE LVC_S_ROW,

       GT_TOOLBAR      TYPE UI_FUNCTIONS,

       GT_F4           TYPE LVC_T_F4,
       GS_F4           TYPE LVC_S_F4.

*-- For ALV List box
       DATA :          GT_DROP TYPE LVC_T_DROP,
       GS_DROP         TYPE LVC_S_DROP.

*-- For select box
DATA : GS_VRM_NAME  TYPE VRM_ID,
       GS_VRM_POSI  TYPE VRM_VALUES,
       GS_VRM_VALUE LIKE LINE OF GS_VRM_POSI.
DATA : GT_VALUE LIKE T093T OCCURS 0 WITH HEADER LINE.

*--- "Screen 변수 -
DATA : DDATE LIKE ZEA_BKPF-BLDAT,    "DDATE : 만기일
       BLART LIKE ZEA_BKPF-BLART,    "전표유형
       BUDAT LIKE ZEA_BKPF-BUDAT,    "증빙 일자
       BLDAT LIKE ZEA_BKPF-BLDAT.    "전기 일자


**********************************************************************
* Common variable
**********************************************************************
RANGES GR_GROUP FOR ZEA_SKA1-BPROLE.

DATA : OK_CODE TYPE SY-UCOMM,
       GV_DATE TYPE ZEA_BKPF-BUDAT,
       GV_MODE VALUE 'D'.



DEFINE _LAST_DAY.

  CALL FUNCTION 'LAST_DAY_OF_MONTHS'
    EXPORTING
      DAY_IN            = &1
    IMPORTING
      LAST_DAY_OF_MONTH = &1.

END-OF-DEFINITION.

**********************************************************************
* About Toolbar Controll
**********************************************************************
DEFINE _ADD_TOOLBAR.

  CLEAR GS_TOOLBAR.
  MOVE : &1 TO GS_TOOLBAR-BUTN_TYPE,
         &2 TO GS_TOOLBAR-FUNCTION,
         &3 TO GS_TOOLBAR-ICON,
         &4 TO GS_TOOLBAR-QUICKINFO,
         &5 TO GS_TOOLBAR-TEXT,
         &6 TO GS_TOOLBAR-DISABLED.
  APPEND GS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

END-OF-DEFINITION.

**********************************************************************
* Class - Variant
**********************************************************************
CONSTANTS: GC_DUEDATE  TYPE STRING VALUE 'DUEDATE',
           GC_OPEN     TYPE STRING VALUE 'DISPLAY_OPEN',
           GC_CLEARING TYPE STRING VALUE 'DISPAY_CLEARING',
           GC_ALL_ITEM TYPE STRING VALUE 'DISPLAY_ALL'.

**********************************************************************
* Common MACRO
**********************************************************************
DEFINE _MC_POPUP_CONFIRM.
  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      TITLEBAR              = &1
*      DISPLAY_CANCEL_BUTTON = ''
      TEXT_QUESTION         = &2
      TEXT_BUTTON_1         = 'YES'
      ICON_BUTTON_1         = '@2K@'
      TEXT_BUTTON_2         = 'NO'
      ICON_BUTTON_2         = '@2O@ '
    IMPORTING
      ANSWER                = &3
    EXCEPTIONS
      TEXT_NOT_FOUND        = 1
      OTHERS                = 2.
END-OF-DEFINITION.
