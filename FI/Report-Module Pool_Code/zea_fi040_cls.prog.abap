*&---------------------------------------------------------------------*
*& Include          ZEA_FI040_CLS
*&---------------------------------------------------------------------*

CLASS LCL_EVENT_HANDLER DEFINITION. " 정의

  PUBLIC SECTION.

  " ALV 가 2개 이상일때는 Static Method를 사용할 수 없다.
  " 없는 거 해보기
    METHODS: " Static Method 를 정의한다.
      ON_DOUBLE_CLICK FOR EVENT DOUBLE_CLICK OF CL_GUI_ALV_GRID
        IMPORTING E_COLUMN
                  E_ROW
                  SENDER,

      ON_HOTSPOT_CLICK FOR EVENT HOTSPOT_CLICK OF CL_GUI_ALV_GRID
        IMPORTING E_COLUMN_ID
                  E_ROW_ID
                  SENDER.

ENDCLASS.

CLASS LCL_EVENT_HANDLER IMPLEMENTATION.  " 구현

  METHOD ON_DOUBLE_CLICK.
    PERFORM HANDLE_DOUBLE_CLICK USING E_COLUMN E_ROW SENDER.
  ENDMETHOD.

  METHOD ON_HOTSPOT_CLICK.
    PERFORM HANDLE_DOUBLE_CLICK USING E_COLUMN_ID E_ROW_ID SENDER.
  ENDMETHOD.
ENDCLASS.
