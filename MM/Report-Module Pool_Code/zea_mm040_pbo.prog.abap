*&---------------------------------------------------------------------*
*& Include          ZEA_MM040_PBO
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.

* Dynamic PF-STATUS
  CLEAR : GT_EXCLUDE[].
  CASE GV_MODE.
    WHEN 'D'.
      CLEAR: GT_EXCLUDE.
      GT_EXCLUDE-STATUS_NAME = 'DISPLAY'.
      APPEND GT_EXCLUDE.
      CLEAR: GT_EXCLUDE.
      GT_EXCLUDE-STATUS_NAME = 'INSERT'.
      APPEND GT_EXCLUDE.
      CLEAR: GT_EXCLUDE.
      GT_EXCLUDE-STATUS_NAME = 'DELETE'.
      APPEND GT_EXCLUDE.
    WHEN 'C'.
      CLEAR: GT_EXCLUDE.
      GT_EXCLUDE-STATUS_NAME = 'REFRESH'.
      APPEND GT_EXCLUDE.
      CLEAR: GT_EXCLUDE.
      GT_EXCLUDE-STATUS_NAME = 'CHANGE'.
      APPEND GT_EXCLUDE.
  ENDCASE.
  SET PF-STATUS 'S0100' EXCLUDING GT_EXCLUDE.

* Dynamic TITLEBAR
  DATA : LV_TITLEBAR TYPE STRING.
  IF GV_MODE EQ 'D'.
    LV_TITLEBAR = '조회'.
  ELSE.
    LV_TITLEBAR = '생성/수정/삭제'.
  ENDIF.
  SET TITLEBAR  'T0100' WITH LV_TITLEBAR.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ALV_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE INIT_ALV_0100 OUTPUT.

  IF GO_CONTAINER IS INITIAL.
    PERFORM CREATE_OBJECT_0100.
    PERFORM SET_FIELDCATALOG_0100.
    PERFORM SET_ALV_LAYOUT_0100.
    PERFORM SET_EVENT_RECEIVER_0100.
    PERFORM SET_REGISTER_EVENT_0100.
    PERFORM DISPLAY_ALV_0100.
  ELSE.
    PERFORM REFRESH_TABLE_DISPLAY_0100.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CLEAR_OK_CODE OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE CLEAR_OK_CODE OUTPUT.

  CLEAR OK_CODE.

ENDMODULE.
