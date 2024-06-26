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

  IF GO_CONTAINER_1 IS INITIAL.
    PERFORM CREATE_OBJECT_0100.
    PERFORM SET_ALV_FIELDCAT_0100.
    PERFORM SET_ALV_LAYOUT_0100.
    PERFORM SET_ALV_EVENT_0100.
    PERFORM SET_TOOLBAR_0100.
    PERFORM DISPLAY_ALV_0100.
  ELSE.
    PERFORM MODIFY_DISPLAY_DATA.
    PERFORM REFRESH_ALV_0100.
  ENDIF.

  IF GO_CONTAINER_2 IS INITIAL.
    PERFORM CREATE_OBJECT_DETAIL_0100.
    PERFORM SET_ALV_FIELDCAT_DETAIL_0100.
    PERFORM SET_ALV_LAYOUT_DETAIL_0100.
    PERFORM SET_ALV_EVENT_DETAIL_0100.
    PERFORM SET_TOOLBAR_DETAIL_0100.
    PERFORM DISPLAY_ALV_DETAIL_0100.
  ELSE.
    PERFORM MODIFY_DISPLAY_DATA2.
    PERFORM REFRESH_ALV_DETAIL_0100.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0110 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE STATUS_0110 OUTPUT.
  SET PF-STATUS 'S0110'.
  SET TITLEBAR  'T0110'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CLEAR_STKO_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE CLEAR_STKO_0100 OUTPUT.
  IF ZEA_STKO-BOMID IS INITIAL.
    CLEAR ZEA_STKO.
  ENDIF.
ENDMODULE.
