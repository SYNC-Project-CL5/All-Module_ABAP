*&---------------------------------------------------------------------*
*& Include          ZMEETROOMO01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.
  SET PF-STATUS 'S0100'.
  SET TITLEBAR 'T0100'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_PROCESS_CONTROL OUTPUT
*&---------------------------------------------------------------------*
MODULE INIT_PROCESS_CONTROL OUTPUT.


  IF GO_CONTAINER IS INITIAL.

    PERFORM CREATE_OBJECT_0100.
    PERFORM SET_ALV_LAYOUT_0100 .
    PERFORM SET_ALV_FIELDCAT_0100.
    PERFORM SET_ALV_EVENT_0100.
    PERFORM DISPLAY_ALV_0100.

  ELSE.

    PERFORM REFRESH_ALV_0100.

  ENDIF.


ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CLEAR_OK_CODE OUTPUT
*&---------------------------------------------------------------------*
MODULE CLEAR_OK_CODE OUTPUT.

  CLEAR OK_CODE.

ENDMODULE.
