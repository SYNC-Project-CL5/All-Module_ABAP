*&---------------------------------------------------------------------*
*& Report YE00_EX001
*&---------------------------------------------------------------------*
*& [PP] 생산 실적 조회
*&---------------------------------------------------------------------*
REPORT ZEA_PP130.

INCLUDE ZEA_PP130_TOP.
INCLUDE ZEA_PP130_SCR.
INCLUDE ZEA_PP130_CLS.
INCLUDE ZEA_PP130_PBO.
INCLUDE ZEA_PP130_PAI.
INCLUDE ZEA_PP130_F01.


INITIALIZATION.


AT SELECTION-SCREEN OUTPUT.


AT SELECTION-SCREEN.


START-OF-SELECTION.


  PERFORM SELECT_DATA.
  PERFORM MAKE_DISPLAY_DATA.

  CALL SCREEN 0100.
