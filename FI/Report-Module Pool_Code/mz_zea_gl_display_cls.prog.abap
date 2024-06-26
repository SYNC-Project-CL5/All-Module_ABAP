**&---------------------------------------------------------------------*
*& Include          MZ_ZEA_GL_DISPLAY_CLS
*&---------------------------------------------------------------------*
CLASS LCL_EVENT_HANDLER DEFINITION.

  PUBLIC SECTION.

    METHODS :

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

  METHOD ON_HOTSPOT_CLICK.
    PERFORM HANDLE_HOTSPOT_CLICK USING E_ROW_ID
                                       E_COLUMN_ID
                                       SENDER.
  ENDMETHOD.
ENDCLASS.
