*&---------------------------------------------------------------------*
*& Include          ZEA_CHECK_MTPBO
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
MODULE INIT_ALV_0100 OUTPUT.

  IF GO_DOCKING_CONTAINER IS INITIAL.

    PERFORM CREATE_OBJECT_0100.
    PERFORM CREATE_OBJECT_PIC1.
    " TREE 관련 Subroutines
    PERFORM CREATE_NODE_0100.
    PERFORM CREATE_NODE_0100_2.

    SORT GT_NODE_INFO BY NODE_KEY.
    PERFORM ADD_NODE.

    PERFORM EXPAND_ROOT_NODE_0100.
    PERFORM SET_TREE_EVENT_0100.

    " ALV 관련 Subroutines
    PERFORM SET_ALV_LAYOUT_0100.
    PERFORM SET_ALV_FIELDCAT_0100.
    PERFORM SET_ALV_EVENT_0100.
    PERFORM DISPLAY_ALV_0100.
    ENDIF.

    IF GO_CONTAINER_2 IS INITIAL.
      PERFORM CREATE_OBJECT2_0100.
      PERFORM SET_DOCUMENT USING GCL_DOCUMENT.

    ELSE.
      PERFORM SET_DOCUMENT USING GCL_DOCUMENT.

  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0110 OUTPUT
*&---------------------------------------------------------------------*
MODULE STATUS_0110 OUTPUT.
 SET PF-STATUS 'S0110'.
 SET TITLEBAR 'T0110'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ALV_0110 OUTPUT
*&---------------------------------------------------------------------*
MODULE INIT_ALV_0110 OUTPUT.

  IF GO_CONTAINER_3 IS INITIAL.
    PERFORM SELECT_CCON110_DATA.
    PERFORM MODIFY_DISPLAY_0110.
    PERFORM CREATE_OBJECT_0110.
    PERFORM SET_ALV_FIELDCAT_0110.
    PERFORM DISPLAY_ALV_0110.
  ENDIF.

ENDMODULE.
