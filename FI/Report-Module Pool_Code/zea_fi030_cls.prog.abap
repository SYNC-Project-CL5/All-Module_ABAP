*&---------------------------------------------------------------------*
*& Include          ZEA_GL_DISPLAY_CLS
*&---------------------------------------------------------------------*
CLASS  LCL_EVENT_HANDLER DEFINITION.

  PUBLIC SECTION.
    CLASS-METHODS:
      ON_TOOLBAR      FOR EVENT TOOLBAR OF CL_GUI_ALV_GRID
        IMPORTING E_OBJECT
                  SENDER,

      ON_USER_COMMAND FOR EVENT USER_COMMAND OF CL_GUI_ALV_GRID
        IMPORTING E_UCOMM
                  SENDER.

ENDCLASS.

CLASS LCL_EVENT_HANDLER IMPLEMENTATION.

  METHOD ON_TOOLBAR.
    PERFORM HANDLE_TOOLBAR USING E_OBJECT
                                 SENDER.

  ENDMETHOD.

  METHOD ON_USER_COMMAND.
    PERFORM HANDLE_USER_COMMAND USING E_UCOMM
                                      SENDER.
  ENDMETHOD.


ENDCLASS.
