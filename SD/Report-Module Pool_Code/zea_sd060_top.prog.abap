*&---------------------------------------------------------------------*
*& Include          ZALV_GRID_DISPLAY_TOP
*&---------------------------------------------------------------------*
TABLES: ZEA_SDT040, ZEA_SDT050, ZEA_SDT060, ZEA_SDT110, ZEA_KNA1,
        ZEA_MMT190, ZEA_MMT020, ZEA_T001W.


CLASS LCL_EVENT_HANDLER DEFINITION DEFERRED.

CONSTANTS : GC_INVOICE    TYPE STRING VALUE 'GC_INVOICE',
            GC_INVOICE_OK TYPE STRING VALUE 'GC_INVOICE_OK',
            GC_INVOICE_NO TYPE STRING VALUE 'GC_INVOICE_NO',
            GC_INVOICE_ING TYPE STRING VALUE 'GC_INVOICE_ING'.

DATA: BEGIN OF GS_DATA,
        VBELN   TYPE ZEA_SDT040-VBELN,
        CUSCODE TYPE ZEA_SDT040-CUSCODE,
        SADDR   TYPE ZEA_SDT040-SADDR,
        VDATU   TYPE ZEA_SDT040-VDATU,
        ADATU   TYPE ZEA_SDT040-ADATU,
        ODDAT   TYPE ZEA_SDT040-ODDAT,
        TOAMT   TYPE ZEA_SDT040-TOAMT,
        WAERS   TYPE ZEA_SDT040-WAERS,
        STATUS  TYPE ZEA_SDT040-STATUS,
*        STATUS2  TYPE ZEA_SDT040-STATUS2,
*        MATNR   TYPE ZEA_SDT050-MATNR,
*        MAKTX   TYPE ZEA_MMT020-MAKTX,
        BPCUS   TYPE ZEA_KNA1-BPCUS,
      END OF GS_DATA.

DATA GT_DATA LIKE TABLE OF GS_DATA.



DATA: BEGIN OF GS_DISPLAY.
        INCLUDE STRUCTURE GS_DATA.
DATA:
        ICON LIKE ICON-ID, " 아이콘
*        COLOR           TYPE C LENGTH 4, " 행 색상 정보
*        LIGHT           TYPE C,          " 신호등 표시를 위한
*        " EXCEPTION 필드
*        " 0:비움 1:빨강 2:노랑 3:초록
*        IT_FIELD_COLORS TYPE LVC_T_SCOL, " 셀 별 색상정보 인터널 테이블
*        STYLE           TYPE LVC_T_STYL, " 셀 스타일(모양)
*        MARK            TYPE CHAR1,      " 셀의 마킹 정보
      END OF GS_DISPLAY.

DATA: GT_DISPLAY LIKE TABLE OF GS_DISPLAY.

*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
DATA: BEGIN OF GS_DATA2,
        VBELN  TYPE ZEA_SDT050-VBELN,
        POSNR  TYPE ZEA_SDT050-POSNR,
        MATNR  TYPE ZEA_SDT050-MATNR,
        AUQUA  TYPE ZEA_SDT050-AUQUA,
        MEINS  TYPE ZEA_SDT050-MEINS,
        NETPR  TYPE ZEA_SDT050-NETPR,
        AUAMO  TYPE ZEA_SDT050-AUAMO,
        WAERS  TYPE ZEA_SDT050-WAERS,
        MAKTX  TYPE ZEA_MMT020-MAKTX,
        STATUS TYPE ZEA_SDT050-STATUS,
        SBELNR TYPE ZEA_SDT060-SBELNR,
      END OF GS_DATA2.

DATA: GT_DATA2 LIKE TABLE OF GS_DATA2.

DATA: BEGIN OF GS_DISPLAY2.
        INCLUDE STRUCTURE GS_DATA2.
DATA:
        ICON LIKE ICON-ID, " 아이콘
*        COLOR           TYPE C LENGTH 4, " 행 색상 정보
*        LIGHT           TYPE C,          " 신호등 표시를 위한
*        " EXCEPTION 필드
*        " 0:비움 1:빨강 2:노랑 3:초록
*        IT_FIELD_COLORS TYPE LVC_T_SCOL, " 셀 별 색상정보 인터널 테이블
*        STYLE           TYPE LVC_T_STYL, " 셀 스타일(모양)
*        MARK            TYPE CHAR1,      " 셀의 마킹 정보
      END OF GS_DISPLAY2.

DATA: GT_DISPLAY2 LIKE TABLE OF GS_DISPLAY2.

*&---------------------------------------------------------------------*
*& 0160 Screen 용 Internal Table 선언
*&---------------------------------------------------------------------*
DATA: BEGIN OF GS_DATA3,
        VBELN  TYPE ZEA_SDT050-VBELN,
        POSNR  TYPE ZEA_SDT050-POSNR,
        MATNR  TYPE ZEA_SDT050-MATNR,
        AUQUA  TYPE ZEA_SDT050-AUQUA,
        MEINS  TYPE ZEA_SDT050-MEINS,
        NETPR  TYPE ZEA_SDT050-NETPR,
        AUAMO  TYPE ZEA_SDT050-AUAMO,
        WAERS  TYPE ZEA_SDT050-WAERS,
        MAKTX  TYPE ZEA_MMT020-MAKTX,
        STATUS TYPE ZEA_SDT050-STATUS,
        SBELNR TYPE ZEA_SDT060-SBELNR,
      END OF GS_DATA3.

DATA: GT_DATA3 LIKE TABLE OF GS_DATA3.

DATA: BEGIN OF GS_DISPLAY3.
        INCLUDE STRUCTURE GS_DATA3.
DATA:
        ICON LIKE ICON-ID, " 아이콘
*        COLOR           TYPE C LENGTH 4, " 행 색상 정보
*        LIGHT           TYPE C,          " 신호등 표시를 위한
*        " EXCEPTION 필드
*        " 0:비움 1:빨강 2:노랑 3:초록
*        IT_FIELD_COLORS TYPE LVC_T_SCOL, " 셀 별 색상정보 인터널 테이블
*        STYLE           TYPE LVC_T_STYL, " 셀 스타일(모양)
*        MARK            TYPE CHAR1,      " 셀의 마킹 정보
      END OF GS_DISPLAY3.

DATA: GT_DISPLAY3 LIKE TABLE OF GS_DISPLAY3.
*&---------------------------------------------------------------------*
DATA : BEGIN OF GS_CHECK,
         SBELNR  TYPE ZEA_SDT060-SBELNR,
         VBELN   TYPE ZEA_SDT060-VBELN,
         RQDAT   TYPE ZEA_SDT060-RQDAT,
         CUSCODE TYPE ZEA_SDT040-CUSCODE,
         WERKS   TYPE ZEA_SDT060-WERKS,
       END OF GS_CHECK.

DATA GT_CHECK LIKE TABLE OF GS_CHECK.

*--------------------------------------------------------------------*
*--------------------------재고 테이블-------------------------------*
*--------------------------------------------------------------------*
DATA: GT_MMT190 TYPE TABLE OF ZEA_MMT190,
      GS_MMT190 LIKE LINE OF  GT_MMT190.

*--------------------------------------------------------------------*
*--------------------------배치 테이블-------------------------------*
*--------------------------------------------------------------------*

DATA: GT_MMT070 TYPE TABLE OF ZEA_MMT070,
      GS_MMT070 LIKE LINE OF  GT_MMT070.
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*

DATA: GO_DOCK          TYPE REF TO CL_GUI_DOCKING_CONTAINER,
      GO_SPLIT         TYPE REF TO CL_GUI_SPLITTER_CONTAINER,
      GO_CONTAINER_1   TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      GO_CONTAINER_2   TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      GO_CONTAINER_3   TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      GO_CONTAINER_4   TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      GO_ALV_GRID_1    TYPE REF TO CL_GUI_ALV_GRID,
      GO_ALV_GRID_2    TYPE REF TO CL_GUI_ALV_GRID,
      GO_ALV_GRID_3    TYPE REF TO CL_GUI_ALV_GRID,
      GO_ALV_GRID_4    TYPE REF TO CL_GUI_ALV_GRID,
      GO_EVENT_HANDLER TYPE REF TO LCL_EVENT_HANDLER.

DATA: GS_VARIANT    TYPE DISVARIANT,
      GV_SAVE1      TYPE C,
      GV_SAVE2      TYPE C,
      GV_SAVE3      TYPE C,

      GT_FIELDCAT   TYPE LVC_T_FCAT,
      GS_FIELDCAT   TYPE LVC_S_FCAT,

      GT_FIELDCAT4   TYPE LVC_T_FCAT,
      GS_FIELDCAT4   TYPE LVC_S_FCAT,

      GS_LAYOUT     TYPE LVC_S_LAYO,

      GT_FILTER     TYPE LVC_T_FILT,
      GS_FILTER     TYPE LVC_S_FILT,

      GT_INDEX_ROWS TYPE LVC_T_ROW,
      GS_INDEX_ROWS TYPE LVC_S_ROW,

      GT_TOOLBAR    TYPE UI_FUNCTIONS,

      GT_F4         TYPE LVC_T_F4,
      GS_F4         TYPE LVC_S_F4,

      OK_CODE       TYPE SY-UCOMM,
      GV_LINES      TYPE SY-TFILL,
      GV_ANSWER     TYPE CHAR1,
      GV_CHANGED,

      GV_SELECTED   TYPE I.

*ListBox 변수 선언
DATA: GV_LIST TYPE CHAR50,
      GT_LIST TYPE TABLE OF ZEA_T001W,
      GS_LIST LIKE LINE OF GT_LIST.

*리스트 박스 구현
DATA: LIST  TYPE VRM_VALUES,
      VALUE LIKE LINE OF LIST.

*----------------------------------------------------------------------*
* Common MACRO
*----------------------------------------------------------------------*
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

*----------------------------------------------------------------------*
* TREE
*----------------------------------------------------------------------*
DATA: BEGIN OF GS_DATA4,
        MATNR     TYPE ZEA_MMT190-MATNR,
        WERKS     TYPE ZEA_MMT190-WERKS,
        SCODE     TYPE ZEA_MMT190-SCODE,
        CALQTY    TYPE ZEA_MMT190-CALQTY,
        MEINS     TYPE ZEA_MMT190-MEINS,
        SUM_VALUE TYPE ZEA_MMT190-WEIGHT,
        WAERS     TYPE ZEA_MMT190-MEINS2,
        PNAME1    TYPE ZEA_T001W-PNAME1,
        MAKTX     TYPE ZEA_MMT020-MAKTX,
      END OF GS_DATA4.

DATA GT_DATA4 LIKE TABLE OF GS_DATA4.

*&---------------------------------------------------------------------*
*TREE
*&---------------------------------------------------------------------*
