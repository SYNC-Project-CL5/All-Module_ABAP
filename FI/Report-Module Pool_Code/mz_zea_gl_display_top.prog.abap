*&---------------------------------------------------------------------*
*& Include          MZ_ZEA_GL_DISPLAY_TOP
*&---------------------------------------------------------------------*
CLASS LCL_EVENT_HANDLER DEFINITION DEFERRED.

TABLES: ZEA_BKPF, ZEA_BSEG, ZEA_FIT300, ZEA_MMT170.


DATA: GT_DATA TYPE TABLE OF ZEA_BSEG,
      GS_DATA TYPE ZEA_BSEG.

DATA: BEGIN OF GS_DISPLAY.
        INCLUDE STRUCTURE GS_DATA.
DATA:
        XBLNR TYPE ZEA_BKPF-XBLNR,
      END OF GS_DISPLAY.

DATA: GT_DISPLAY LIKE TABLE OF GS_DISPLAY.

DATA: GO_CONTAINER TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      GO_ALV_GRID  TYPE REF TO CL_GUI_ALV_GRID,
      GCL_HANDLER  TYPE REF TO LCL_EVENT_HANDLER.

DATA: GS_VARIANT    TYPE DISVARIANT,
      GV_SAVE       TYPE C,

      GT_FIELDCAT   TYPE LVC_T_FCAT,
      GS_FIELDCAT   TYPE LVC_S_FCAT,


      GS_LAYOUT     TYPE LVC_S_LAYO,

      GT_FILTER     TYPE LVC_T_FILT,
      GS_FILTER     TYPE LVC_S_FILT,

      GT_INDEX_ROWS TYPE LVC_T_ROW,
      GS_INDEX_ROWS TYPE LVC_S_ROW,

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
