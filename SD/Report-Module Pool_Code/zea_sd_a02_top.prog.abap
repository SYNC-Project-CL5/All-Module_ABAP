*&---------------------------------------------------------------------*
*& Include          ZALV_GRID_DISPLAY_TOP
*&---------------------------------------------------------------------*
TABLES: ZEA_SDT090, ZEA_MMT010, ZEA_MMT020, ZEA_MMT050, t001.

CLASS LCL_EVENT_HANDLER DEFINITION DEFERRED.

DATA: BEGIN OF GS_DATA,
        MATNR    TYPE ZEA_SDT090-MATNR,
        MAKTX    TYPE ZEA_MMT020-MAKTX,
        WERKS    TYPE ZEA_SDT090-WERKS,
        VALID_EN TYPE ZEA_SDT090-VALID_EN,
        VALID_ST TYPE ZEA_SDT090-VALID_ST,
        NETPR    TYPE ZEA_SDT090-NETPR,
        WAERS    TYPE ZEA_SDT090-WAERS,
        LOEKZ    TYPE ZEA_SDT090-LOEKZ,
        ERNAM    TYPE ZEA_SDT090-ERNAM,
        ERDAT    TYPE ZEA_SDT090-ERDAT,
        ERZET    TYPE ZEA_SDT090-ERZET,
        AENAM    TYPE ZEA_SDT090-AENAM,
        AEDAT    TYPE ZEA_SDT090-AEDAT,
        AEZET    TYPE ZEA_SDT090-AEZET,
      END OF GS_DATA.

DATA: GT_DATA LIKE TABLE OF GS_DATA.


DATA: BEGIN OF GS_DISPLAY.
        INCLUDE STRUCTURE GS_DATA.
DATA: STATUS LIKE ICON-ID, " 아이콘
        COLOR           TYPE C LENGTH 4, " 행 색상 정보
        LIGHT           TYPE C,          " 신호등 표시를 위한
                                         " EXCEPTION 필드
                                         " 0:비움 1:빨강 2:노랑 3:초록
        IT_FIELD_COLORS TYPE LVC_T_SCOL, " 셀 별 색상정보 인터널 테이블
        STYLE           TYPE LVC_T_STYL, " 셀 스타일(모양)
        MARK            TYPE CHAR1,      " 셀의 마킹 정보
      END OF GS_DISPLAY.

DATA: GT_DISPLAY LIKE TABLE OF GS_DISPLAY.

DATA: GO_CONTAINER TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      GO_ALV_GRID      TYPE REF TO CL_GUI_ALV_GRID,
      GO_EVENT_HANDLER TYPE REF TO LCL_EVENT_HANDLER.

DATA: GS_VARIANT TYPE DISVARIANT,
      GV_SAVE     TYPE C,

      GT_FIELDCAT TYPE LVC_T_FCAT,
      GS_FIELDCAT TYPE LVC_S_FCAT,

      GS_LAYOUT   TYPE LVC_S_LAYO,

      GT_FILTER   TYPE LVC_T_FILT,
      GS_FILTER   TYPE LVC_S_FILT,

      GT_INDEX_ROWS      TYPE LVC_T_ROW,
      GS_INDEX_ROWS      TYPE LVC_S_ROW,

      OK_CODE     TYPE SY-UCOMM,
      GV_LINES    TYPE SY-TFILL,
      GV_ANSWER   TYPE CHAR1,
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
