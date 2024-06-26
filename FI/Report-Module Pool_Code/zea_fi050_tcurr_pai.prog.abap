*&---------------------------------------------------------------------*
*& Include          ZEA_FI050_TUCRR_PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.
  CASE OK_CODE.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'COST'. " 환율계산 팝업 버튼
      CLEAR S0150.
      STATUS = ''.
      S0150-OUTPUT_DIF = ''.

      READ TABLE GT_TCURR INTO GS_TCURR INDEX 0. " 가장 마지막 줄 읽어오기
      S0150-TCURR = PA_TCURR.
      S0150-FCURR = 'KRW'.
      S0150-GDATU = GS_TCURR-GDATU.
      S0150-UKURS = GS_TCURR-UKURS.
      S0150-AVERAGE = GS_TCURR-AVERAGE.

      CALL SCREEN 0150 STARTING AT 5 5.
      PERFORM CAL_UKURS. " 환율계산
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT_0100  INPUT
*&---------------------------------------------------------------------*
MODULE EXIT_0100 INPUT.
  CASE OK_CODE.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'CANC'.
      LEAVE TO SCREEN 0.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT_0150  INPUT
*&---------------------------------------------------------------------*
MODULE EXIT_0150 INPUT.
  CASE OK_CODE.
    WHEN 'CANC'.
      CLEAR S0150.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0150  INPUT
*&---------------------------------------------------------------------*
MODULE USER_COMMAND_0150 INPUT.
  CASE OK_CODE.
    WHEN 'OKAY'.
      CLEAR S0150.
      STATUS = ''.
      S0150-OUTPUT_DIF = ''.
      LEAVE TO SCREEN 0.

    WHEN '' .
      PERFORM CAL_UKURS. " 환율계산

  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
MODULE USER_COMMAND_0200 INPUT.
  CASE OK_CODE.
    WHEN 'OKAY'.
*      CLEAR S0150.
      STATUS = ''.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
