*&---------------------------------------------------------------------*
*& Include          YE00_EX007PBO
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.
  SET PF-STATUS '0100'.
  SET TITLEBAR  '0100'. " [샘플] 항공사 예약 정보 조회
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_OBJECT_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE INIT_OBJECT_0100 OUTPUT.

  IF GO_CUSTOM_CONTAINER IS INITIAL.

    PERFORM CREATE_OBJECT_0100.

    " TREE 관련 Subroutines
    PERFORM CREATE_NODE_0100.
    PERFORM EXPAND_ROOT_NODE_0100.
    PERFORM SET_TREE_EVENT_0100.

    " ALV 관련 Subroutines
    PERFORM SET_ALV_LAYOUT_0100.
    PERFORM SET_ALV_EVENT_0100.
    PERFORM SET_ALV_FIELDCAT_0100.


  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CLEAR_OK_CODE OUTPUT
*&---------------------------------------------------------------------*
MODULE CLEAR_OK_CODE OUTPUT.

  CLEAR OK_CODE.
ENDMODULE.
