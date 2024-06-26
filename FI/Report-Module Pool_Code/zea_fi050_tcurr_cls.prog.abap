*&---------------------------------------------------------------------*
*& Include          ZEA_FI050_TCURR_CLS
*&---------------------------------------------------------------------*
CLASS  LCL_EVENT_HANDLER DEFINITION.

  PUBLIC SECTION.
    CLASS-METHODS:

      DOUBLE_CLICK FOR EVENT DOUBLE_CLICK OF CL_GUI_ALV_GRID
        IMPORTING E_COLUMN E_ROW ,

      ON_HOTSPOT_CLICK FOR EVENT HOTSPOT_CLICK OF CL_GUI_ALV_GRID
        IMPORTING E_ROW_ID      " LVC_S_ROW  (ROWTYPE, INDEX)
                  E_COLUMN_ID   " LVC_S_COL  (FIELDNAME)
                  ES_ROW_NO     " LVC_S_ROID (ROW_ID)
                  SENDER.


ENDCLASS.

CLASS LCL_EVENT_HANDLER IMPLEMENTATION.

  METHOD DOUBLE_CLICK.
    PERFORM CALCULATION_UKURS USING E_COLUMN E_ROW .
  ENDMETHOD.


  METHOD ON_HOTSPOT_CLICK.

  ENDMETHOD.


ENDCLASS.
