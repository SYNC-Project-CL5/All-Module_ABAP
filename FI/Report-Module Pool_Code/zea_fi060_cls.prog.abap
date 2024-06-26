*&---------------------------------------------------------------------*
*& Include          ZMEETROOMC01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Class LCL_EVENT_HANDLER
*&---------------------------------------------------------------------*
CLASS LCL_EVENT_HANDLER DEFINITION FINAL.

  PUBLIC SECTION.
    CLASS-METHODS :

      ON_TOOLBAR FOR EVENT TOOLBAR OF CL_GUI_ALV_GRID
        IMPORTING E_OBJECT
                  E_INTERACTIVE
                  SENDER,

      ON_USER_COMMAND FOR EVENT USER_COMMAND OF CL_GUI_ALV_GRID
        IMPORTING E_UCOMM       " SY-UCOMM
                  SENDER,

      TOP_OF_PAGE   FOR EVENT TOP_OF_PAGE
        OF CL_GUI_ALV_GRID
        IMPORTING E_DYNDOC_ID,

      DOUBLE_CLICK FOR EVENT DOUBLE_CLICK OF CL_GUI_ALV_GRID
        IMPORTING E_COLUMN E_ROW ,

      ON_HOTSPOT_CLICK FOR EVENT HOTSPOT_CLICK OF CL_GUI_ALV_GRID
        IMPORTING E_ROW_ID      " LVC_S_ROW  (ROWTYPE, INDEX)
                  E_COLUMN_ID   " LVC_S_COL  (FIELDNAME)
                  ES_ROW_NO     " LVC_S_ROID (ROW_ID)
                  SENDER.

ENDCLASS.
*&---------------------------------------------------------------------*
*& Class (Implementation) LCL_EVENT_HANDLER
*&---------------------------------------------------------------------*
CLASS LCL_EVENT_HANDLER IMPLEMENTATION.

  METHOD ON_TOOLBAR.
    PERFORM HANDLER_TOOLBAR  USING E_OBJECT
                                   SENDER.
  ENDMETHOD.

  METHOD ON_USER_COMMAND.
    PERFORM HANDLE_USER_COMMAND USING E_UCOMM
                                      SENDER.
  ENDMETHOD.

  METHOD TOP_OF_PAGE.
    PERFORM EVENT_TOP_OF_PAGE.
  ENDMETHOD.

  METHOD DOUBLE_CLICK.
    PERFORM GET_DATA_BKPF USING E_COLUMN E_ROW .
  ENDMETHOD.


  METHOD ON_HOTSPOT_CLICK.
    PERFORM HANDLE_HOTSPOT_CLICK USING E_ROW_ID
                                       E_COLUMN_ID
                                       SENDER.
  ENDMETHOD.

ENDCLASS.
