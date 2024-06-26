*&---------------------------------------------------------------------*
*& Include          YE12_PJ020_PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT_0100  INPUT
*&---------------------------------------------------------------------*
MODULE EXIT_0100 INPUT.
  CASE OK_CODE.
    WHEN 'EXIT'.
      PERFORM MSG_DATA_MISS.

    WHEN 'CANC'.
      PERFORM MSG_DATA_MISS.
      LEAVE TO SCREEN 0.

    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.

  CASE OK_CODE.
    WHEN 'SAVE'.
      PERFORM COMFIRM_SAVE.
      PERFORM REFRESH_ALV_0100.

    WHEN 'BACK'.
      PERFORM MSG_DATA_MISS.
      LEAVE TO SCREEN 0.


    WHEN 'RERFRESH'.
*      LEAVE TO TRANSACTION 'ZEASD010'.
*      LEAVE SCREEN.
*      CLEAR GT_DISPLAY[].
      PERFORM REFRESH_ALV_0100.
      PERFORM REFRESH_ALV_DETAIL_0100.
*      CLEAR ZEA_SDT020-SAPNR.
      GV_MODE1 = ABAP_OFF.

    WHEN 'SP_DISPLAY'.
      CALL TRANSACTION 'ZEASD010'.
*      LEAVE PROGRAM.

    WHEN 'SP_EXCEL'.
      CALL TRANSACTION 'ZEASD120'.

    WHEN 'CREATE'.
      PERFORM CREATE_SP_DATA.
    WHEN 'PLANT_SEARCH'.
      PERFORM PLANT_SEARCH_SELECT.

  ENDCASE.
  EXIT.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0101  INPUT
*&---------------------------------------------------------------------*
MODULE USER_COMMAND_0101 INPUT.

  CASE OK_CODE.
    WHEN 'REFRESH'.
      CLEAR ZEA_SDT020-SAPNR.
      CLEAR ZEA_SDT020-SP_YEAR.
*      CLEAR ZEA_SDT020-WERKS.
      CLEAR GV_LIST.
      CLEAR ZEA_SDT020-TOTREV.
      CLEAR ZEA_SDT020-SAPQU.
      GV_MODE1 = ABAP_OFF.
    WHEN 'CREATE'.
      IF ZEA_SDT020-SP_YEAR  IS INITIAL
*        OR ZEA_SDT020-WERKS IS INITIAL.
        OR GV_LIST IS INITIAL.
        GV_MODE1 = ABAP_OFF.
***        CLEAR ZEA_SDT020-SP_YEAR.
*        CLEAR ZEA_SDT020-WERKS.
**        CLEAR GV_LIST.
*        LEAVE SCREEN.
      ELSE.
        GV_MODE1 = ABAP_ON.
      ENDIF.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F4HELP  INPUT
*&---------------------------------------------------------------------*
MODULE F4HELP INPUT.

  PERFORM F4_HELP.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0110  INPUT
*&---------------------------------------------------------------------*
MODULE USER_COMMAND_0110 INPUT.

  CASE OK_CODE.
    WHEN 'CANCEL'.
      LEAVE TO SCREEN 0.

    WHEN 'GET'.
      PERFORM GET_PAST_DATA.

 ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_INPUT  INPUT
*&---------------------------------------------------------------------*
MODULE CHECK_INPUT INPUT.

  IF ZEA_SDT020-SP_YEAR < SY-DATUM(4).
    MESSAGE E000 WITH '올해 이전의 년도는 입력할 수 없습니다.'.
  ENDIF.


ENDMODULE.
