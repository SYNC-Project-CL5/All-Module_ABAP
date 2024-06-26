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

  IF GO_CONTAINER_1 IS INITIAL AND GO_CONTAINER_2 IS INITIAL.
    PERFORM CREATE_OBJECT_0100.
    PERFORM SET_ALV_FIELDCAT_0100.
    PERFORM SET_ALV_LAYOUT_0100.
    PERFORM SET_TOOLBAR_0100.
    PERFORM SET_ALV_EVENT_0100.
    PERFORM DISPLAY_ALV_0100.
  ELSE.
    PERFORM REFRESH_ALV_0100.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0150 OUTPUT
*&---------------------------------------------------------------------*
MODULE STATUS_0150 OUTPUT.
  SET PF-STATUS '0150'.
  SET TITLEBAR '0150'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0160 OUTPUT
*&---------------------------------------------------------------------*
MODULE STATUS_0160 OUTPUT.
  SET PF-STATUS '0160'.
  SET TITLEBAR '0160'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0170 OUTPUT
*&---------------------------------------------------------------------*
MODULE STATUS_0170 OUTPUT.
  SET PF-STATUS '0170'.
  SET TITLEBAR '0170'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ALV_0160 OUTPUT
*&---------------------------------------------------------------------*
MODULE INIT_ALV_0160 OUTPUT.

  IF GO_CONTAINER_3 IS INITIAL.
    PERFORM CREATE_OBJECT_0160.
    PERFORM SET_ALV_FIELDCAT_0100.
    PERFORM SET_ALV_LAYOUT_0100.
    PERFORM SET_ALV_EVENT_0100.
    PERFORM DISPLAY_ALV_0160.
  ELSE.
    PERFORM REFRESH_ALV_0160.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0180 OUTPUT
*&---------------------------------------------------------------------*
MODULE STATUS_0180 OUTPUT.
 SET PF-STATUS '0180'.
 SET TITLEBAR '0180'.
ENDMODULE.
