*&---------------------------------------------------------------------*
*& Include          YE00_EX007CLS
*&---------------------------------------------------------------------*
CLASS LCL_EVENT_HANDLER DEFINITION.
  PUBLIC SECTION.

    CLASS-METHODS:
      ON_NODE_DOUBLE_CLICK FOR EVENT NODE_DOUBLE_CLICK OF CL_GUI_SIMPLE_TREE
        IMPORTING NODE_KEY
                  SENDER,

      ON_NODE_DOUBLE_CLICK2 FOR EVENT NODE_DOUBLE_CLICK OF CL_GUI_SIMPLE_TREE
        IMPORTING NODE_KEY
                  SENDER,

      ON_TOOLBAR FOR EVENT TOOLBAR OF CL_GUI_ALV_GRID
        IMPORTING E_OBJECT      " MT_TOOLBAR Attribute 보유,
                  " TYPE TTB_BUTTON
                  " LINE TYPE STB_BUTTON
                  E_INTERACTIVE
                  SENDER,

      ON_TOOLBAR2 FOR EVENT TOOLBAR OF CL_GUI_ALV_GRID
        IMPORTING E_OBJECT      " MT_TOOLBAR Attribute 보유,
                  " TYPE TTB_BUTTON
                  " LINE TYPE STB_BUTTON
                  E_INTERACTIVE
                  SENDER,

      ON_USER_COMMAND FOR EVENT USER_COMMAND OF CL_GUI_ALV_GRID
        IMPORTING E_UCOMM       " SY-UCOMM
                  SENDER.
ENDCLASS.

CLASS LCL_EVENT_HANDLER IMPLEMENTATION.
  METHOD ON_NODE_DOUBLE_CLICK.
    PERFORM HANDLE_NODE_DOUBLE_CLICK USING NODE_KEY
                                           SENDER.

  ENDMETHOD.

  METHOD ON_NODE_DOUBLE_CLICK2.

    PERFORM HANDLE_NODE_DOUBLE_CLICK2 USING NODE_KEY
                                            SENDER.
  ENDMETHOD.

  METHOD ON_TOOLBAR.
    PERFORM HANDLER_TOOLBAR USING E_OBJECT
                                  SENDER.
  ENDMETHOD.

    METHOD ON_TOOLBAR2.
    PERFORM HANDLER_TOOLBAR2 USING E_OBJECT
                                  SENDER.
  ENDMETHOD.

  METHOD ON_USER_COMMAND.
    PERFORM HANDLE_USER_COMMAND USING E_UCOMM
                                      SENDER.


  ENDMETHOD.


ENDCLASS.
