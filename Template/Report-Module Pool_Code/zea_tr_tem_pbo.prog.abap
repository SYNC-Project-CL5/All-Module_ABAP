*&---------------------------------------------------------------------*
*& Include          ZEA_TR_TEM_PBO
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'S0100'.
  SET TITLEBAR  'T0100'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module SET_FCAT OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE set_fcat OUTPUT.

  IF gt_fcat IS INITIAL.

    PERFORM set_tree_fcat.

  ENDIF.

  IF gt_sort IS INITIAL.

    PERFORM set_sort.

  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CREATE_OBJECT OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE create_object OUTPUT.

  IF gcl_container IS NOT BOUND.

    PERFORM create_object.

  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CLEAR_OK_CODE OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE clear_ok_code OUTPUT.
  CLEAR OK_CODE.
ENDMODULE.
