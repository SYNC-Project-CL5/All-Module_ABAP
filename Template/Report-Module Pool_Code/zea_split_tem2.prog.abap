*&---------------------------------------------------------------------*
*& Report ZALV_GRID_DISPLAY
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEA_SPLIT_TEM2 MESSAGE-ID ZMSG_E23.

INCLUDE ZEA_SPLIT_TEM2_TOP.
INCLUDE ZEA_SPLIT_TEM2_SCR.
INCLUDE ZEA_SPLIT_TEM2_CLS.
INCLUDE ZEA_SPLIT_TEM2_PBO.
INCLUDE ZEA_SPLIT_TEM2_PAI.
INCLUDE ZEA_SPLIT_TEM2_F01.


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
*  PERFORM MODIFY_DATA.
  PERFORM MAKE_DISPLAY_DATA.
  PERFORM DISPLAY_DATA.
