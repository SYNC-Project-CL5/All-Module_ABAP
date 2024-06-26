*&---------------------------------------------------------------------*
*& Include          YE00_EX007CLS
*&---------------------------------------------------------------------*

CLASS LCL_EVENT_HANDLER DEFINITION.

  PUBLIC SECTION.

    CLASS-METHODS:
      ON_NODE_DOUBLE_CLICK FOR EVENT NODE_DOUBLE_CLICK
                                  OF CL_GUI_SIMPLE_TREE
                           IMPORTING NODE_KEY
                                     SENDER.

ENDCLASS.

CLASS LCL_EVENT_HANDLER IMPLEMENTATION.

  METHOD ON_NODE_DOUBLE_CLICK.
    PERFORM HANDLE_NODE_DOUBLE_CLICK USING NODE_KEY
                                           SENDER.
    ENDMETHOD.
ENDCLASS.
