*&---------------------------------------------------------------------*
*& Include          ZEA_MM040_CLS
*&---------------------------------------------------------------------*

CLASS LCL_EVENT_RECEIVER DEFINITION.
  PUBLIC SECTION.

  CLASS-METHODS:
        HANDLE_DATA_CHANGED
        FOR EVENT DATA_CHANGED    OF CL_GUI_ALV_GRID
        IMPORTING ER_DATA_CHANGED
                  E_ONF4
                  E_ONF4_BEFORE
                  E_ONF4_AFTER
                  E_UCOMM.


ENDCLASS.

CLASS LCL_EVENT_RECEIVER IMPLEMENTATION.

  METHOD HANDLE_DATA_CHANGED.
    PERFORM HANDLE_DATA_CHANGED USING ER_DATA_CHANGED
                                      E_ONF4
                                      E_ONF4_BEFORE
                                      E_ONF4_AFTER
                                      E_UCOMM.
  ENDMETHOD.

ENDCLASS.
DATA : LCL_EVENT_RECEIVER TYPE REF TO LCL_EVENT_RECEIVER.
