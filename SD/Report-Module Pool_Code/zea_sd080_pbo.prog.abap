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

  " SY-UNAME 현재 사용자
  " SY-DATUM 현재 날짜
  " SY-UZEIT 현재 시간

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

  IF GO_CONTAINER IS INITIAL.
    PERFORM CREATE_OBJECT_0100.
    PERFORM SET_ALV_FIELDCAT_0100.
    PERFORM SET_ALV_LAYOUT_0100.
    PERFORM SET_ALV_EVENT_0100.
    PERFORM DISPLAY_ALV_0100.
  ELSE.
    PERFORM REFRESH_ALV_0100.
  ENDIF.

  IF GO_CONTAINER_2 IS INITIAL.
    PERFORM CREATE_OBJECT2_0100.
    PERFORM SET_ALV_FIELDCAT2_0100.
    PERFORM SET_ALV_LAYOUT2_0100.
*    PERFORM SET_ALV_EVENT2_0100.
    PERFORM DISPLAY_ALV2_0100.
  ELSE.
    GO_ALV_GRID_2->REFRESH_TABLE_DISPLAY( ) .
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0110 OUTPUT
*&---------------------------------------------------------------------*
MODULE STATUS_0110 OUTPUT.
 SET PF-STATUS '0110'.
 SET TITLEBAR '0110'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ALV_0110 OUTPUT
*&---------------------------------------------------------------------*
MODULE INIT_ALV_0110 OUTPUT.

  IF GO_CONTAINER_3 IS INITIAL.
    PERFORM CREATE_OBJECT_0110.
    PERFORM SET_ALV_FIELDCAT_0110.
    PERFORM SET_ALV_LAYOUT_0110.
*    PERFORM SET_ALV_EVENT_0110.
    PERFORM DISPLAY_ALV_0110.
  ELSE.
    PERFORM REFRESH_ALV_0110.
  ENDIF.
ENDMODULE.
