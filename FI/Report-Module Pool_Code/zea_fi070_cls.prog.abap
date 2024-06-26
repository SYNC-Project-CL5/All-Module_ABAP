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

      ON_TOP_OF_PAGE   FOR EVENT TOP_OF_PAGE
        OF CL_GUI_ALV_GRID
        IMPORTING E_DYNDOC_ID,

      ON_DOUBLE_CLICK FOR EVENT DOUBLE_CLICK OF CL_GUI_ALV_GRID
        IMPORTING E_COLUMN E_ROW
                  ES_ROW_NO SENDER,

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
    PERFORM HANDLER_TOOLBAR  USING E_OBJECT     "Toolbar 버튼 구현
                                   SENDER.
  ENDMETHOD.

  METHOD ON_USER_COMMAND.
    PERFORM HANDLE_USER_COMMAND USING E_UCOMM   "TOOLBAR 버튼 클릭 시 구현
                                      SENDER.
  ENDMETHOD.

  METHOD ON_TOP_OF_PAGE.                      "TOP Page 구현
    PERFORM EVENT_TOP_OF_PAGE.
  ENDMETHOD.

  METHOD ON_DOUBLE_CLICK.
    PERFORM HANDLE_DOUBLE_CLICK USING E_ROW    "ALV 더블 클릭 구현
                                      E_COLUMN
                                      SENDER.

  ENDMETHOD.

  METHOD ON_HOTSPOT_CLICK.
    PERFORM HANDLE_HOTSPOT_CLICK USING E_ROW_ID
                                       E_COLUMN_ID
                                       SENDER.
  ENDMETHOD.

ENDCLASS.
