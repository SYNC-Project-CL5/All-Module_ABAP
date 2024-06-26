*&---------------------------------------------------------------------*
*& Include          ZALV_GRID_DISPLAY_PBO
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
*& Module CLEAR_OK_CODE OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE CLEAR_OK_CODE OUTPUT.
  CLEAR OK_CODE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ALV_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE INIT_ALV_0100 OUTPUT.

  " CCON : 생산 계획
  IF GO_CONTAINER IS INITIAL.
    PERFORM CREATE_OBJECT_0100.
    PERFORM SET_ALV_FIELDCAT_0100.
    PERFORM SET_ALV_LAYOUT_0100.
    PERFORM SET_ALV_EVENT_0100.
    PERFORM DISPLAY_ALV_0100.
  ELSE.
    PERFORM REFRESH_ALV_0100.
  ENDIF.

  " CCON2 : 판매계획
  IF GO_CONTAINER_2 IS INITIAL.
    PERFORM CREATE_OBJECT2_0100.
    PERFORM SET_ALV_FIELDCAT2_0100.
    PERFORM SET_ALV_LAYOUT2_0100.
    PERFORM SET_ALV_EVENT2_0100.
    PERFORM DISPLAY_ALV2_0100.
  ELSE.
    PERFORM REFRESH_ALV2_0100.
  ENDIF.

ENDMODULE.
