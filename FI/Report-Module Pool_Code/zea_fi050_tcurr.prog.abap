*&---------------------------------------------------------------------*
*& Report ZEA_FI050_TUCRR
*&---------------------------------------------------------------------*
*& [FI] 환율 Reporting
*&---------------------------------------------------------------------*
REPORT ZEA_FI050_TCURR MESSAGE-ID ZEA_MSG.

INCLUDE ZEA_FI050_TCURR_TOP.
INCLUDE ZEA_FI050_TCURR_SCR.
INCLUDE ZEA_FI050_TCURR_CLS.

INCLUDE ZEA_FI050_TCURR_PBO.
INCLUDE ZEA_FI050_TCURR_PAI.
INCLUDE ZEA_FI050_TCURR_F01.

*&---------------------------------------------------------------------*
INITIALIZATION.

AT SELECTION-SCREEN OUTPUT.

AT SELECTION-SCREEN.
  PERFORM INPUT_CHECK.

START-OF-SELECTION.
  PERFORM SELECT_DATA.
  PERFORM MAKE_DISPLAY_DATA.
  PERFORM DISPLAY_DATA.
