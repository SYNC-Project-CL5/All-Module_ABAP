*&---------------------------------------------------------------------*
*& Include          ZALV_GRID_CRUD_CLS
*&---------------------------------------------------------------------*
CLASS LCL_EVENT_HANDLER DEFINITION.

  PUBLIC SECTION.

    CLASS-METHODS:

      ON_TOOLBAR FOR EVENT TOOLBAR OF CL_GUI_ALV_GRID
        IMPORTING E_OBJECT      " MT_TOOLBAR Attribute 보유,
                                " TYPE TTB_BUTTON
                                " LINE TYPE STB_BUTTON
                  E_INTERACTIVE
                  SENDER,

      ON_USER_COMMAND FOR EVENT USER_COMMAND OF CL_GUI_ALV_GRID
        IMPORTING E_UCOMM       " SY-UCOMM
                  SENDER,

      ON_DATA_CHANGED FOR EVENT DATA_CHANGED OF CL_GUI_ALV_GRID
                      IMPORTING ER_DATA_CHANGED
                                SENDER.


ENDCLASS.

CLASS LCL_EVENT_HANDLER IMPLEMENTATION.


  METHOD ON_TOOLBAR.
    PERFORM HANDLER_TOOLBAR USING E_OBJECT
                                  SENDER.
  ENDMETHOD.

  METHOD ON_USER_COMMAND.
    PERFORM HANDLE_USER_COMMAND USING E_UCOMM
                                      SENDER.
  ENDMETHOD.

  METHOD ON_DATA_CHANGED.
    PERFORM HANDLE_DATA_CHANGED USING ER_DATA_CHANGED
                                      SENDER.
  ENDMETHOD.

ENDCLASS.
