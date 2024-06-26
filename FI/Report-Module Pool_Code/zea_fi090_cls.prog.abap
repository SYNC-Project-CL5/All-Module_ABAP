*&---------------------------------------------------------------------*
*& Include          YE08_EX001_CLS
*&---------------------------------------------------------------------*
CLASS LCL_EVENT_HANDLER DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
      ON_HOTSPOT_CLICK FOR EVENT HOTSPOT_CLICK OF CL_GUI_ALV_GRID
        IMPORTING E_ROW_ID      " LVC_S_ROW  (ROWTYPE, INDEX)
                  E_COLUMN_ID   " LVC_S_COL  (FIELDNAME)
                  ES_ROW_NO     " LVC_S_ROID (ROW_ID)
                  SENDER.

    CLASS-METHODS:
      ON_DOUBLE_CLICK FOR EVENT DOUBLE_CLICK OF CL_GUI_ALV_GRID
        IMPORTING E_ROW
                  E_COLUMN
                  SENDER.

ENDCLASS.

CLASS LCL_EVENT_HANDLER IMPLEMENTATION.
  METHOD ON_HOTSPOT_CLICK.
    PERFORM HANDLE_HOTSPOT_CLICK USING E_ROW_ID
                                       E_COLUMN_ID
                                       SENDER.
  ENDMETHOD.

  METHOD ON_DOUBLE_CLICK.
    PERFORM DOUBLE_CLICK USING E_ROW
                               E_COLUMN
                               SENDER.
  ENDMETHOD.

ENDCLASS.
