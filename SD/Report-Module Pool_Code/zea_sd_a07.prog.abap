*&---------------------------------------------------------------------*
*& Report ZALV_GRID_DISPLAY
*&---------------------------------------------------------------------*
*& [2024.04.18 / 단위 테스트 완료] - [PM] 김건우 : x
*&---------------------------------------------------------------------*
REPORT ZEA_SD_A07 MESSAGE-ID ZMSG_E23.

INCLUDE ZEA_SD_A07_TOP.
INCLUDE ZEA_SD_A07_SCR.
INCLUDE ZEA_SD_A07_CLS.
INCLUDE ZEA_SD_A07_PBO.
INCLUDE ZEA_SD_A07_PAI.
INCLUDE ZEA_SD_A07_F01.

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
