*&---------------------------------------------------------------------*
*& Include          ZALV_GRID_DISPLAY_PBO
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.
  SET PF-STATUS 'S0100'.
  SET TITLEBAR 'T0100'.

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

  IF GO_CONTAINER IS INITIAL.
    PERFORM CREATE_OBJECT_0100.
    PERFORM SET_ALV_FIELDCAT_0100.
    PERFORM SET_ALV_LAYOUT_0100.
    PERFORM SET_ALV_EVENT_0100.
    PERFORM SET_TOOLBAR_0100.
    PERFORM DISPLAY_ALV_0100.
  ELSE.
    PERFORM REFRESH_ALV_0100.
  ENDIF.

  IF GO_CONTAINER_2 IS INITIAL.
    PERFORM CREATE_OBJECT2_0100.
    PERFORM SET_ALV_FIELDCAT2_0100.
    PERFORM SET_ALV_LAYOUT2_0100.
    PERFORM SET_ALV_EVENT2_0100.
    PERFORM DISPLAY_ALV2_0100.
  ELSE.
    PERFORM MODIFY_DISPLAY_DATA2.
    PERFORM REFRESH_ALV2_0100.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module MOVE_TO_DYNP_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE MOVE_TO_DYNP_0100 OUTPUT.

  IF ZEA_STKO-MATNR IS INITIAL.
    CLEAR: ZEA_MMT020-MAKTX, ZEA_MMT010-MATTYPE.
  ELSE.
    SELECT SINGLE MAKTX
      FROM ZEA_MMT020
      INTO @ZEA_MMT020-MAKTX
      WHERE MATNR EQ @ZEA_STKO-MATNR.

    SELECT SINGLE MATTYPE
      FROM ZEA_MMT010
      INTO @ZEA_MMT010-MATTYPE
      WHERE MATNR EQ @ZEA_STKO-MATNR.
  ENDIF.

  IF ZEA_T001W-WERKS IS INITIAL.
    CLEAR: ZEA_T001W.
  ELSE.
    SELECT SINGLE PNAME1
      FROM ZEA_T001W
      INTO @ZEA_T001W-PNAME1
      WHERE WERKS EQ @ZEA_T001W-WERKS.
  ENDIF.

  IF S0100-MATNR IS INITIAL.
    CLEAR: S0100.
  ELSE.
    SELECT SINGLE MAKTX
      FROM ZEA_MMT020
      INTO @S0100-MAKTX
      WHERE MATNR EQ @S0100-MATNR.

    SELECT SINGLE MATTYPE
      FROM ZEA_MMT010
      INTO @S0100-MATTYPE
      WHERE MATNR EQ @S0100-MATNR.

  ENDIF.

  IF ZEA_STKO-MENGE IS INITIAL.
    ZEA_STKO-MENGE = 1.
  ENDIF.

  IF ZEA_STKO-MEINS IS INITIAL.
    ZEA_STKO-MEINS = 'PKG'.
  ENDIF.


ENDMODULE.
