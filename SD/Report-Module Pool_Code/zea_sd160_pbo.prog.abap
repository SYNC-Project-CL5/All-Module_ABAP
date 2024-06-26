*&---------------------------------------------------------------------*
*& Include          ZEA_SD160_PBO
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.
 SET PF-STATUS 'S0100'.
 SET TITLEBAR 'T0100'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CLEAR_OK_CODE OUTPUT
*&---------------------------------------------------------------------*
MODULE CLEAR_OK_CODE OUTPUT.

  CLEAR OK_CODE.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module MAKE_DATA OUTPUT
*&---------------------------------------------------------------------*
MODULE MAKE_DATA OUTPUT.

MESSAGE S000 WITH ZEA_KNA1-BPCUS '의 여신현황이 조회되었습니다.'.




ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0110 OUTPUT
*&---------------------------------------------------------------------*
MODULE STATUS_0110 OUTPUT.
 SET PF-STATUS 'S0110'.
 SET TITLEBAR 'T0110' WITH ZEA_KNA1-BPCUS.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ALV_0110 OUTPUT
*&---------------------------------------------------------------------*
MODULE INIT_ALV_0110 OUTPUT.

    IF GO_CONTAINER IS INITIAL.


    PERFORM CREATE_OBJECT_0110.

    PERFORM SET_ALV_LAYOUT_0110.
    PERFORM SET_ALV_FIELDCAT_0110.
*
*    PERFORM SET_ALV_EVENT_0100.

    PERFORM DISPLAY_ALV_0110.

  ELSE.

*    CALL METHOD GO_ALV_GRID->REFRESH_TABLE_DISPLAY.

  ENDIF.

ENDMODULE.
