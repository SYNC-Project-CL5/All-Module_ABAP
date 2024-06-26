*&---------------------------------------------------------------------*
*& Include          ZEA_MM030_CLS
*&---------------------------------------------------------------------*
CLASS LCL_EVENT_RECEIVER DEFINITION.
  PUBLIC SECTION.

  METHODS:
        HANDLE_USER_COMMAND
        FOR EVENT USER_COMMAND   OF CL_GUI_ALV_GRID
        IMPORTING E_UCOMM,

        HANDLE_TOOLBAR
        FOR EVENT TOOLBAR        OF CL_GUI_ALV_GRID
        IMPORTING E_OBJECT
                  E_INTERACTIVE,

       HANDLE_DATA_CHANGED
       FOR EVENT DATA_CHANGED    OF CL_GUI_ALV_GRID
       IMPORTING ER_DATA_CHANGED
                 E_ONF4
                 E_ONF4_BEFORE
                 E_ONF4_AFTER
                 E_UCOMM.

ENDCLASS.
CLASS LCL_EVENT_RECEIVER IMPLEMENTATION.

  METHOD HANDLE_USER_COMMAND.
    PERFORM HANDLE_USER_COMMAND USING E_UCOMM.
  ENDMETHOD.

  METHOD HANDLE_TOOLBAR.
    PERFORM HANDLE_TOOLBAR USING E_OBJECT
                                 E_INTERACTIVE.
  ENDMETHOD.

  METHOD: HANDLE_DATA_CHANGED.
    PERFORM HANDLE_DATA_CHANGED USING ER_DATA_CHANGED
                                      E_ONF4
                                      E_ONF4_BEFORE
                                      E_ONF4_AFTER
                                      E_UCOMM.
  ENDMETHOD.

ENDCLASS.
DATA : LCL_EVENT_RECEIVER TYPE REF TO LCL_EVENT_RECEIVER.
