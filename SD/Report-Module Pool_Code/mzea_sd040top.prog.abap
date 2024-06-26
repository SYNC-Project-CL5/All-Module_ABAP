*&---------------------------------------------------------------------*
*& Include MZEA_PP100TOP                            - Module Pool      SAPMZEA_PPT100
*&---------------------------------------------------------------------*
PROGRAM MZEA_SD040 MESSAGE-ID ZEA_MSG.

CLASS LCL_EVENT_HANDLER DEFINITION DEFERRED.

*--------------------------------------------------------------------*
* CONSTANTS
*--------------------------------------------------------------------*

TABLES : ZEA_SDT040, ZEA_SDT050, ZEA_KNKK.

CONSTANTS: GC_NO_FILTER TYPE STRING VALUE 'NO_FILTER',
           GC_APPROVE   TYPE STRING VALUE 'APPROVE',
           GC_REJECT    TYPE STRING VALUE 'REJECT',
           GC_WAIT      TYPE STRING VALUE 'WAIT'.


DATA: BEGIN OF GS_DATA,
        VBELN    TYPE ZEA_SDT040-VBELN,
        CUSCODE  TYPE ZEA_SDT040-CUSCODE,
        BPCUS    TYPE ZEA_KNA1-BPCUS,
        SADDR    TYPE ZEA_SDT040-SADDR,
        VDATU    TYPE ZEA_SDT040-VDATU,
        ADATU    TYPE ZEA_SDT040-ADATU,
        ODDAT    TYPE ZEA_SDT040-ODDAT,
        TOAMT    TYPE ZEA_SDT040-TOAMT,
        WAERS    TYPE ZEA_SDT040-WAERS,
        STATUS   TYPE ZEA_SDT040-STATUS,
        STATUS2  TYPE ZEA_SDT040-STATUS2,
        STATUS3  TYPE ZEA_SDT040-STATUS3,
        STATUS4  TYPE ZEA_SDT040-STATUS4,
        LOEKZ    TYPE ZEA_SDT040-LOEKZ,
        ERNAM    TYPE ZEA_SDT040-ERNAM,
        ERDAT    TYPE ZEA_SDT040-ERDAT,
        ERZET    TYPE ZEA_SDT040-ERZET,
        AENAM    TYPE ZEA_SDT040-AENAM,
        AEDAT    TYPE ZEA_SDT040-AEDAT,
        AEZET    TYPE ZEA_SDT040-AEZET,
        STATUS_K TYPE ZEA_KNKK-STATUS_K,
END OF GS_DATA.
*DATA: GS_DATA TYPE ZEA_SDT040.
DATA: GT_DATA LIKE TABLE OF GS_DATA.



DATA: BEGIN OF GS_DISPLAY.
        INCLUDE STRUCTURE GS_DATA.
DATA:
*        STATUS LIKE ICON-ID, " 아이콘
        COLOR           TYPE C LENGTH 4, " 행 색상 정보
        LIGHT           TYPE C,          " 신호등 표시를 위한
        " EXCEPTION 필드
        " 0:비움 1:빨강 2:노랑 3:초록
        IT_FIELD_COLORS TYPE LVC_T_SCOL, " 셀 별 색상정보 인터널 테이블
        STYLE           TYPE LVC_T_STYL, " 셀 스타일(모양)
        MARK            TYPE CHAR1,      " 셀의 마킹 정보
      END OF GS_DISPLAY.

DATA: GT_DISPLAY LIKE TABLE OF GS_DISPLAY.

DATA: GT_DATA2 TYPE TABLE OF ZEA_SDT050,
      GS_DATA2 TYPE ZEA_SDT050.

DATA: BEGIN OF GS_DISPLAY2.
        INCLUDE STRUCTURE GS_DATA2.
DATA:
        MAKTX           TYPE ZEA_MMT020-MAKTX,
*        STATUS          LIKE ICON-ID, " 아이콘
        COLOR           TYPE C LENGTH 4, " 행 색상 정보
        LIGHT           TYPE C,          " 신호등 표시를 위한
        " EXCEPTION 필드
        " 0:비움 1:빨강 2:노랑 3:초록
        IT_FIELD_COLORS TYPE LVC_T_SCOL, " 셀 별 색상정보 인터널 테이블
        STYLE           TYPE LVC_T_STYL, " 셀 스타일(모양)
        MARK            TYPE CHAR1,      " 셀의 마킹 정보
      END OF GS_DISPLAY2.

DATA: GT_DISPLAY2 LIKE TABLE OF GS_DISPLAY2.

DATA: GO_CONTAINER     TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      GO_SPLIT         TYPE REF TO CL_GUI_SPLITTER_CONTAINER,
      GO_CON_TOP       TYPE REF TO CL_GUI_CONTAINER,
      GO_CON_BOT       TYPE REF TO CL_GUI_CONTAINER,
      GO_ALV_GRID_TOP  TYPE REF TO CL_GUI_ALV_GRID,
      GO_ALV_GRID_BOT  TYPE REF TO CL_GUI_ALV_GRID,
*      GO_ALV_GRID      TYPE REF TO CL_GUI_ALV_GRID,
      GO_EVENT_HANDLER TYPE REF TO LCL_EVENT_HANDLER.

DATA: GS_VARIANT    TYPE DISVARIANT,
      GS_VARIANT2   TYPE DISVARIANT,
      GV_SAVE       TYPE C,
      GV_SAVE2      TYPE C,

      GT_FIELDCAT   TYPE LVC_T_FCAT,
      GS_FIELDCAT   TYPE LVC_S_FCAT,
      GT_FIELDCAT2  TYPE LVC_T_FCAT,
      GS_FIELDCAT2  TYPE LVC_S_FCAT,

      GS_LAYOUT     TYPE LVC_S_LAYO,
      GS_LAYOUT2    TYPE LVC_S_LAYO,

      GT_FILTER     TYPE LVC_T_FILT,
      GS_FILTER     TYPE LVC_S_FILT,

      GT_INDEX_ROWS TYPE LVC_T_ROW,
      GS_INDEX_ROWS TYPE LVC_S_ROW,

      GT_DROPDOWN   TYPE LVC_T_DROP,
      GS_DROPDOWN   TYPE LVC_S_DROP,

      OK_CODE       TYPE SY-UCOMM,
      GV_LINES      TYPE SY-TFILL,
      GV_ANSWER     TYPE CHAR1,
      GV_CHANGED.

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
