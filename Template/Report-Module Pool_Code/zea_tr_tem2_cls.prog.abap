*&---------------------------------------------------------------------*
*& Include          ZEA_TR_TEM2_CLS
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Class lcl_event_handler
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION FINAL.
  PUBLIC SECTION.
    METHODS :
      handle_double_click FOR EVENT node_double_click OF cl_gui_simple_tree
        IMPORTING
          node_key.

ENDCLASS.
*&---------------------------------------------------------------------*
*& Class (Implementation) lcl_event_handler
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.

  METHOD handle_double_click.

    PERFORM get_sbook USING node_key.

  ENDMETHOD.

ENDCLASS.
