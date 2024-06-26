*&---------------------------------------------------------------------*
*& Include          YE00_EX001_CLS
*&---------------------------------------------------------------------*

CLASS LCL_EVENT_HANDLER DEFINITION. " 정의
  PUBLIC SECTION.
    CLASS-METHODS: " Static Method 를 정의한다.
      ON_HOTSPOT_CLICK FOR EVENT HOTSPOT_CLICK OF CL_GUI_ALV_GRID
        IMPORTING E_ROW_ID     " LVC_S_ROW
                  E_COLUMN_ID  " LVC_S_COL
                  SENDER,

      ON_HOTSPOT_CLICK2 FOR EVENT HOTSPOT_CLICK OF CL_GUI_ALV_GRID
        IMPORTING E_ROW_ID     " LVC_S_ROW
                  E_COLUMN_ID  " LVC_S_COL
                  SENDER.
ENDCLASS.

CLASS LCL_EVENT_HANDLER IMPLEMENTATION. " 구현



  METHOD ON_HOTSPOT_CLICK.
    PERFORM HANDLE_DOUBLE_CLICK USING E_ROW_ID
                                      E_COLUMN_ID
                                      SENDER.
  ENDMETHOD.

  METHOD ON_HOTSPOT_CLICK2.
    PERFORM HANDLE_HOTSPOT_CLICK2 USING E_ROW_ID
                                      E_COLUMN_ID
                                      SENDER.
  ENDMETHOD.

ENDCLASS.
