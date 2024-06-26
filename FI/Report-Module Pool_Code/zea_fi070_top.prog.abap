*&---------------------------------------------------------------------*
*& Include ZEA_OPEN_MANG_TOP
*&---------------------------------------------------------------------*
REPORT ZEA_OPEN_MANG_TOP MESSAGE-ID ZEA_MSG_FI.

CLASS LCL_EVENT_HANDLER DEFINITION DEFERRED.
**********************************************************************
* TABLES
**********************************************************************
TABLES : ZEA_FIT800 , "Vendor 원장 테이블
         ZEA_BKPF ,   "전표 헤더 테이블
         ZEA_BSEG ,   "전표 아이템 테이블
         ZEA_LFA1 ,   "벤더 마스터 테이블
         ZEA_SKA1 ,   "비즈니스 마스터 테이블
         ZEA_BKNA ,   "은행 마스터 테이블
         ZEA_SKB1 ,    "G/L 마스터 테이블,
         ZEA_TCURR.

DATA : GT_FIT800 LIKE TABLE OF ZEA_FIT800,
       GS_FIT800 TYPE ZEA_FIT800.

DATA : CV_BN TYPE ZEA_FIT800-BELNR ,   "KA전표번호 (KZ: 레퍼런스 값)
       GV_BP TYPE ZEA_FIT800-VENCODE.  "KZ전표 내 Recon 값

" FI 환율 테이블
DATA: GS_TCURR       TYPE ZEA_TCURR,
      GT_TCURR       TYPE TABLE OF ZEA_TCURR,
      GV_COVT_AMOUNT TYPE ZEA_BSEG-WRBTR.

**********************************************************************
* Class instance
**********************************************************************
DATA : GO_CONTAINER     TYPE REF TO CL_GUI_DOCKING_CONTAINER,
       GO_ALV_GRID      TYPE REF TO CL_GUI_ALV_GRID,
*-- For Top-of-page -------------------------------------------------*
       GO_TOP_CONTAINER TYPE REF TO CL_GUI_DOCKING_CONTAINER,
       GO_DYNDOC_ID     TYPE REF TO CL_DD_DOCUMENT,
       GO_HTML_CNTRL    TYPE REF TO CL_GUI_HTML_VIEWER,

*-- For Top-of-ALV -------------------------------------------------*
       GO_CONTAINER_2   TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
       GO_ALV_GRID_2    TYPE REF TO CL_GUI_ALV_GRID,
       GO_EVENT_HANDLER TYPE REF TO LCL_EVENT_HANDLER.

**********************************************************************
* Internal table and Work area
**********************************************************************
*-- For Display ZEA_FIT800-BLDAT = 'KA'
DATA : BEGIN OF GS_DATA.
         INCLUDE STRUCTURE ZEA_FIT800 .
DATA :   STATUS           TYPE C LENGTH 1,
         ZLSCH            LIKE ZEA_LFA1-ZLSCH,
         MANG             LIKE ZEA_FIT800-BLDAT,
         GTEXT            TYPE TGSBT-GTEXT,
         CELL_TAB         TYPE LVC_T_STYL,
         DROP_DOWN_HANDLE TYPE INT4,
       END OF GS_DATA.

DATA : GT_DATA LIKE TABLE OF GS_DATA.

*-- For Display ZEA_FIT800-BLDAT = 'KZ'
DATA : BEGIN OF GS_DATA2.
DATA:
  BSCHL     TYPE ZEA_FIT800-BSCHL,
  ITNUM     TYPE ZEA_FIT800-ITNUM,
  STATUS    TYPE C LENGTH 1,
  AUGDT     TYPE ZEA_FIT800-AUGDT,
  BELNR     TYPE ZEA_FIT800-BELNR,
  BPCODE   TYPE ZEA_FIT800-VENCODE,
  SAKNR     TYPE ZEA_FIT800-SAKNR,
  DMBTR     TYPE ZEA_FIT800-DMBTR,
  EATAX     TYPE zea_FIT800-EATAX,
  D_WAERS   TYPE ZEA_FIT800-D_WAERS,
  WRBTR     TYPE ZEA_FIT800-WRBTR,
  W_WAERS   TYPE ZEA_FIT800-W_WAERS,
  APAY_BOOK TYPE ZEA_FIT800-APAY_BOOK.

DATA:
    END OF GS_DATA2.

DATA: GT_DATA2 LIKE TABLE OF GS_DATA2.

*-- For ALV
DATA : GS_VARIANT   TYPE DISVARIANT,
       GS_VARIANT2  TYPE DISVARIANT,

       GT_FIELDCAT  TYPE LVC_T_FCAT,
       GS_FIELDCAT  TYPE LVC_S_FCAT,

       GT_FIELDCAT2 TYPE LVC_T_FCAT,
       GS_FIELDCAT2 TYPE LVC_S_FCAT,

       GS_LAYOUT    TYPE LVC_S_LAYO,
       GS_LAYOUT2   TYPE LVC_S_LAYO.

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
       GS_F4           TYPE LVC_S_F4,

       GV_SCR_ON       TYPE CHAR1,
       GV_SAVE         TYPE C,
       GV_SAVE2        TYPE C,
       GV_LINES        TYPE SY-TFILL,
       GV_ANSWER       TYPE CHAR1,
       GV_CHANGED      TYPE CHAR1.

*-- For ALV List box
DATA : GT_DROP TYPE LVC_T_DROP,
       GS_DROP TYPE LVC_S_DROP.

*-- For select box
DATA : GS_VRM_NAME  TYPE VRM_ID,
       GS_VRM_POSI  TYPE VRM_VALUES,
       GS_VRM_VALUE LIKE LINE OF GS_VRM_POSI.
DATA : GT_VALUE LIKE T093T OCCURS 0 WITH HEADER LINE.

*--- "Screen 변수 - 0100
DATA : DDATE LIKE ZEA_BKPF-BLDAT,      "DDATE : 만기일

       BLDAT LIKE ZEA_BKPF-BLDAT,
       BUDAT LIKE ZEA_BKPF-BUDAT,
       XBLNR LIKE ZEA_BKPF-XBLNR,
       GJAHR LIKE ZEA_BKPF-GJAHR.

*--- "Screen 변수 - 0200
DATA :
  GV_AMOUNT    LIKE ZEA_BSEG-DMBTR,      "전표별 KA전표 금액 SUM 보관 변수
  D_WAERS2     TYPE ZEA_FIT800-D_WAERS,  "지급금액 (통화단위)
  D_WAERS3     TYPE ZEA_FIT800-D_WAERS,  "반제금액 (통화단위)
  AP_AMOUNT    TYPE ZEA_FIT800-DMBTR,    "반제금액 (통화금액)
  OPEN_AMOUNT  TYPE ZEA_FIT800-DMBTR,    "총 미결액(통화금액)
  OPEN_AMOUNT2 TYPE ZEA_FIT800-DMBTR,    "지급 액  (통화금액)
  POST_DATE    TYPE DATS,                "전기일자
  VENCODE      TYPE ZEA_FIT800-VENCODE,  "공급사 코드
  BELNR_200    LIKE ZEA_FIT800-BELNR.    "선택한 라인의 전표번호

DATA GV_KR_BELNR TYPE ZEA_FIT800-BELNR.
DATA GV_EV_BELNR TYPE ZEA_FIT800-BELNR.
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
CONSTANTS: GC_PAY_BOOK TYPE STRING VALUE 'PAY_DAY_BOOKING',
           GC_OPEN     TYPE STRING VALUE 'DISPLAY_OPEN',
           GC_CLEARING TYPE STRING VALUE 'DISPAY_CLEARING',
           GC_ALL_ITEM TYPE STRING VALUE 'DISPLAY_ALL',
           GC_PAY      TYPE STRING VALUE 'PAY_A/P',
           GC_DUEDATE  TYPE STRING VALUE  'DUEDATE'.
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
