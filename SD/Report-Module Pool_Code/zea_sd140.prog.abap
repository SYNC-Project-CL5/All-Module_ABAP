*&---------------------------------------------------------------------*
*& Report YE00_EX001
*&---------------------------------------------------------------------*
*& [SD] 판가 조회 [완료] - ACA5-12 박지영
*&---------------------------------------------------------------------*
REPORT ZEA_SD140.

INCLUDE ZEA_SD140_TOP.
INCLUDE ZEA_SD140_SCR.
INCLUDE ZEA_SD140_CLS.
INCLUDE ZEA_SD140_PBO.
INCLUDE ZEA_SD140_PAI.
INCLUDE ZEA_SD140_F01.


INITIALIZATION.


AT SELECTION-SCREEN OUTPUT.


AT SELECTION-SCREEN.


START-OF-SELECTION.


  PERFORM SELECT_DATA.
  PERFORM MAKE_DISPLAY_DATA.

  CALL SCREEN 0100.
