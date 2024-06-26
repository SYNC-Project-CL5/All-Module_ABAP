*&---------------------------------------------------------------------*
*& Report ZALV_GRID_DISPLAY
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTEST_E0322 MESSAGE-ID ZMSG_E23.

INCLUDE ZTEST_E0322_TOP.
*INCLUDE ZALV_GRID_DISPLAY_DETAIL_TOP.
INCLUDE ZTEST_E0322_SCR.
*INCLUDE ZALV_GRID_DISPLAY_DETAIL_SCR.
INCLUDE ZTEST_E0322_CLS.
*INCLUDE ZALV_GRID_DISPLAY_DETAIL_CLS.
INCLUDE ZTEST_E0322_PBO.
*INCLUDE ZALV_GRID_DISPLAY_DETAIL_PBO.
INCLUDE ZTEST_E0322_PAI.
*INCLUDE ZALV_GRID_DISPLAY_DETAIL_PAI.
INCLUDE ZTEST_E0322_F01.
*INCLUDE ZALV_GRID_DISPLAY_DETAIL_F01.

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

  PERFORM SELECT_DATA.
  PERFORM MAKE_DISPLAY_DATA.
  PERFORM DISPLAY_DATA.
