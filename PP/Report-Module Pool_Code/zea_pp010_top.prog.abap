*&---------------------------------------------------------------------*
*& Include          ZALV_GRID_DISPLAY_TOP
*&---------------------------------------------------------------------*
TABLES: ZEA_STKO, ZEA_STPO, ZEA_MMT010, ZEA_T001W, ZEA_MMT020.

CLASS LCL_EVENT_HANDLER DEFINITION DEFERRED.

CONSTANTS: GC_INSERT             TYPE STRING VALUE 'INSERT',
           GC_DELETE             TYPE STRING VALUE 'DELETE',
           GC_SEMI_RAW_MATERIALS TYPE STRING VALUE 'SEMI_RAW_MATERIALS',
           GC_SEMI_MATERIALS     TYPE STRING VALUE 'SEMI_MATERIALS',
           GC_RAW_MATERIALS      TYPE STRING VALUE 'RAW_MATERIALS'.

DATA: BEGIN OF GS_DATA,
        BOMID    TYPE ZEA_STPO-BOMID,
        BOMINDEX TYPE ZEA_STPO-BOMINDEX,
        MATNR    TYPE ZEA_STPO-MATNR,
        MATTYPE  TYPE ZEA_MMT010-MATTYPE,
        MAKTX    TYPE ZEA_MMT020-MAKTX,
        MENGE    TYPE ZEA_STPO-MENGE,
        MEINS    TYPE ZEA_STPO-MEINS,

      END OF GS_DATA.


DATA GT_DATA LIKE TABLE OF GS_DATA.

DATA: BEGIN OF GS_DISPLAY.
        INCLUDE STRUCTURE GS_DATA.
DATA:   STATUS          LIKE ICON-ID, " 아이콘
        COLOR           TYPE C LENGTH 4, " 행 색상 정보
        LIGHT           TYPE C,          " 신호등 표시를 위한
        " EXCEPTION 필드
        " 0:비움 1:빨강 2:노랑 3:초록
        IT_FIELD_COLORS TYPE LVC_T_SCOL, " 셀 별 색상정보 인터널 테이블
        STYLE           TYPE LVC_T_STYL, " 셀 스타일(모양)
        MARK            TYPE CHAR1,      " 셀의 마킹 정보
      END OF GS_DISPLAY.

DATA: GT_DISPLAY LIKE TABLE OF GS_DISPLAY.

DATA: BEGIN OF GS_DATA2,
        MATNR   TYPE ZEA_MMT010-MATNR,
        MATTYPE TYPE ZEA_MMT010-MATTYPE,
        MAKTX   TYPE ZEA_MMT020-MAKTX,
*        WEIGHT  TYPE ZEA_MMT010-WEIGHT,
        MEINS1  TYPE ZEA_MMT010-MEINS1,
      END OF GS_DATA2.

DATA: GT_DATA2 LIKE TABLE OF GS_DATA2.


DATA: BEGIN OF GS_DISPLAY2.
DATA: ADD_ITEM        TYPE ICON-ID.
      INCLUDE STRUCTURE GS_DATA2.
DATA:
      STATUS          LIKE ICON-ID, " 아이콘
      COLOR           TYPE C LENGTH 4, " 행 색상 정보
      LIGHT           TYPE C,          " 신호등 표시를 위한
      " EXCEPTION 필드
      " 0:비움 1:빨강 2:노랑 3:초록
      IT_FIELD_COLORS TYPE LVC_T_SCOL, " 셀 별 색상정보 인터널 테이블
      STYLE           TYPE LVC_T_STYL, " 셀 스타일(모양)
      MARK            TYPE CHAR1,      " 셀의 마킹 정보
      END OF GS_DISPLAY2.

DATA: GS_FIELD_COLOR TYPE LVC_S_SCOL.

DATA: GT_DISPLAY2 LIKE TABLE OF GS_DISPLAY2.

DATA: GO_CONTAINER     TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      GO_CONTAINER_2   TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      GO_ALV_GRID      TYPE REF TO CL_GUI_ALV_GRID,
      GO_ALV_GRID_2    TYPE REF TO CL_GUI_ALV_GRID,
      GO_EVENT_HANDLER TYPE REF TO LCL_EVENT_HANDLER.

DATA: GS_VARIANT       TYPE DISVARIANT,
      GV_SAVE          TYPE C,

      GT_FIELDCAT      TYPE LVC_T_FCAT,
      GS_FIELDCAT      TYPE LVC_S_FCAT,

      GS_LAYOUT        TYPE LVC_S_LAYO,

      GT_FILTER        TYPE LVC_T_FILT,
      GS_FILTER        TYPE LVC_S_FILT,

      GT_INDEX_ROWS    TYPE LVC_T_ROW,
      GS_INDEX_ROWS    TYPE LVC_S_ROW,

      GT_TOOLBAR       TYPE UI_FUNCTIONS,

      GT_F4            TYPE LVC_T_F4,
      GS_F4            TYPE LVC_S_F4,

      OK_CODE          TYPE SY-UCOMM,
      GV_LINES         TYPE SY-TFILL,
      GV_ANSWER        TYPE CHAR1,
      GV_CHANGED       TYPE CHAR1,
      GV_MATNR_CHANGED TYPE CHAR1,
      GV_SCR_ON        TYPE CHAR1,



      BTN              TYPE CHAR10.

DATA: BEGIN OF S0100,
        MATNR   TYPE CHAR20,
        MAKTX   TYPE CHAR20,
        MATTYPE TYPE CHAR20,
      END OF S0100.

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
