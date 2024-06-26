*&---------------------------------------------------------------------*
*& Include          MZ_ZEA_GL_DISPLAY_2_TOP
*&---------------------------------------------------------------------*

TABLES: zea_bkpf, zea_bseg, ZEA_FIT300.

*CLASS lcl_event_handler DEFINITION DEFERRED.
*
*CLASS LCL_EVENT_HANDLER DEFINITION DEFERRED.

DATA: GT_DATA TYPE TABLE OF ZEA_BSEG,
      GS_DATA TYPE ZEA_BSEG.

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
      GO_ALV_GRID      TYPE REF TO CL_GUI_ALV_GRID.
*      GO_EVENT_HANDLER TYPE REF TO LCL_EVENT_HANDLER.

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

*-- Screen 0100 변수
      DATA :AUGBL LIKE ZEA_BSEG-BELNR,
            BLART LIKE ZEA_FIT300-DESCR.

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
