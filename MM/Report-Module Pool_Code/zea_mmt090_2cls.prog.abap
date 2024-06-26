*&---------------------------------------------------------------------*
*& Include          ZEA_CHECK_MTCLS
*&---------------------------------------------------------------------*

CLASS LCL_EVENT_HANDLER DEFINITION. " 정의
  PUBLIC SECTION.
    CLASS-METHODS: " Static Method 를 정의한다.

      ON_TOOLBAR FOR EVENT TOOLBAR OF CL_GUI_ALV_GRID
                 IMPORTING E_OBJECT
                           E_INTERACTIVE
                           SENDER,

      ON_USER_COMMAND FOR EVENT USER_COMMAND OF CL_GUI_ALV_GRID
        IMPORTING E_UCOMM       " SY-UCOMM
                  SENDER,

      ON_DOUBLE_CLICK FOR EVENT DOUBLE_CLICK OF CL_GUI_ALV_GRID
                      IMPORTING E_ROW       " LVC_S_ROW
                                E_COLUMN    " LVC_S_COL
                                SENDER,
*      ON_HOTSPOT_CLICK FOR EVENT HOTSPOT_CLICK OF CL_GUI_ALV_GRID
*                       IMPORTING E_ROW_ID     " LVC_S_ROW
*                                 E_COLUMN_ID  " LVC_S_COL
*                                 SENDER,


      ON_NODE_DOUBLE_CLICK FOR EVENT NODE_DOUBLE_CLICK OF CL_GUI_SIMPLE_TREE
                           IMPORTING NODE_KEY
                                     SENDER.

ENDCLASS.

CLASS LCL_EVENT_HANDLER IMPLEMENTATION. " 구현

  METHOD ON_DOUBLE_CLICK.
    PERFORM HANDLE_DOUBLE_CLICK USING E_ROW
                                      E_COLUMN
                                      SENDER.
  ENDMETHOD.

  METHOD ON_USER_COMMAND.
    PERFORM HANDLE_USER_COMMAND USING E_UCOMM
                                      SENDER.
  ENDMETHOD.

*  METHOD ON_HOTSPOT_CLICK.
*    PERFORM HANDLE_HOTSPOT_CLICK USING E_ROW_ID
*                                       E_COLUMN_ID
*                                       SENDER.
*  ENDMETHOD.

  METHOD ON_NODE_DOUBLE_CLICK.
    PERFORM HANDLE_NODE_DOUBLE_CLICK USING NODE_KEY
                                           SENDER.

  ENDMETHOD.

  METHOD ON_TOOLBAR.
    PERFORM HANDLER_TOOLBAR USING E_OBJECT
                                  SENDER.
  ENDMETHOD.

ENDCLASS.
