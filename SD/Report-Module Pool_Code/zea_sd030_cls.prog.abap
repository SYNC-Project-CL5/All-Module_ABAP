*&---------------------------------------------------------------------*
*& Include          YE12_PJ034_CLS
*&---------------------------------------------------------------------*

CLASS LCL_EVENT_HANDLER DEFINITION.

  PUBLIC SECTION.
    "Static Method
    CLASS-METHODS:
       ON_DOUBLE_CLICK FOR EVENT DOUBLE_CLICK OF CL_GUI_ALV_GRID
        IMPORTING E_ROW         " LVC_S_ROW  (ROWTYPE, INDEX)
                  E_COLUMN      " LVC_S_COL  (FIELDNAME)
                  ES_ROW_NO     " LVC_S_ROID (ROW_ID)
                  SENDER.

ENDCLASS.


CLASS LCL_EVENT_HANDLER IMPLEMENTATION.
  METHOD ON_DOUBLE_CLICK.
    PERFORM HANDLE_DOUBLE_CLICK USING E_ROW
                                      E_COLUMN
                                      SENDER.
  ENDMETHOD.
ENDCLASS.
