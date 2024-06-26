*&---------------------------------------------------------------------*
*& Report ZEA_SD060
*&---------------------------------------------------------------------*
*& [2024.04.18 / 단위 테스트 완료] - [PM] 김건우 : x
*& [2024.04.22 / 단위 테스트 완료] - [PM] 김건우 : o
*&---------------------------------------------------------------------*
REPORT ZEA_SD060 MESSAGE-ID ZEA_MSG.

INCLUDE ZEA_SD060_TOP.
INCLUDE ZEA_SD060_SCR.
INCLUDE ZEA_SD060_CLS.
INCLUDE ZEA_SD060_PBO.
INCLUDE ZEA_SD060_PAI.
INCLUDE ZEA_SD060_F01.

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

  PERFORM SELECT_DATA_LISTBOX.
  PERFORM SELECT_DATA_MMT190.
*  PERFORM MAKE_DISPLAY_DATA.
  PERFORM DISPLAY_DATA.
