*&---------------------------------------------------------------------*
*& Include          MZEA_PP100O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.
  SET PF-STATUS '0100'.
  SET TITLEBAR '0100'.

  " SY-UNAME 현재 사용자
  " SY-DATUM 현재 날짜
  " SY-UZEIT 현재 시간

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CLEAR_OK_CODE OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE CLEAR_OK_CODE OUTPUT.
  CLEAR OK_CODE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ALV_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE INIT_ALV_0100 OUTPUT.


*  PERFORM DISPLAY_DATA.

  IF GO_CONTAINER IS INITIAL.
    PERFORM SELECT_DATA.
    PERFORM MAKE_DISPLAY_DATA.

    PERFORM CREATE_OBJECT_0100.
    PERFORM SET_ALV_FIELDCAT_0100.
    PERFORM SET_ALV_LIST_0100.
    PERFORM SET_ALV_LAYOUT_0100.
    PERFORM SET_ALV_EVENT_0100.
    PERFORM DISPLAY_ALV_0100.
  ELSE.
    PERFORM MODIFY_DISPLAY_DATA.
    PERFORM REFRESH_ALV_0100.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module FILL_DYNP_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE FILL_DYNP_0100 OUTPUT.

  IF ZEA_T001W-PNAME1 IS INITIAL.
    CLEAR ZEA_T001W-WERKS.
  ELSE.
    SELECT SINGLE WERKS
      FROM ZEA_T001W
      INTO ZEA_T001W-WERKS
     WHERE PNAME1 EQ ZEA_T001W-PNAME1.
  ENDIF.

ENDMODULE.
