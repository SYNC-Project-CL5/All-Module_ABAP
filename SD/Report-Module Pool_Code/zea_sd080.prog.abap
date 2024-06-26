*&---------------------------------------------------------------------*
*& Report ZEA_SD080
*&---------------------------------------------------------------------*
*& [SD] 대금 청구 문서 생성 프로그램 2024.04.29 [완료] - ACA5-15 유연수
*& [2024.04.29 / 단위  - [PM] 김건우 :
*&---------------------------------------------------------------------*
REPORT ZEA_SD080 MESSAGE-ID ZEA_MSG.

INCLUDE ZEA_SD080_TOP.
INCLUDE ZEA_SD080_SCR.
INCLUDE ZEA_SD080_CLS.
INCLUDE ZEA_SD080_PBO.
INCLUDE ZEA_SD080_PAI.
INCLUDE ZEA_SD080_F01.

*----------------------------------------------------------------------*
* INITIALIZATION
*----------------------------------------------------------------------*
INITIALIZATION.
  PERFORM INIT_DATA.

*----------------------------------------------------------------------*
* AT SELECTION SCREEN OUTPUT
*----------------------------------------------------------------------*
AT SELECTION-SCREEN OUTPUT.
  PERFORM MODIFY_SSCREEN.

*----------------------------------------------------------------------*
* AT SELECTION SCREEN
*----------------------------------------------------------------------*
* AT SELECTION-SCREEN ON BLOCK B01.
* PERFORM CHECK_INPUT.

AT SELECTION-SCREEN.
  PERFORM SSCR_USER_COMMAND.

*----------------------------------------------------------------------*
* START-OF-SELECTION
*----------------------------------------------------------------------*
START-OF-SELECTION.

*  PERFORM SELECT_DATA.
*  PERFORM MAKE_DISPLAY_DATA.
  PERFORM DISPLAY_DATA.
