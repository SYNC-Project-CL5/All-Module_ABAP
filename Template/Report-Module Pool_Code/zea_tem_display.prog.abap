*&---------------------------------------------------------------------*
*& Report ZALV_GRID_DISPLAY
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEA_TEM_DISPLAY MESSAGE-ID ZMSG_E23.

INCLUDE ZEA_TEM_DISPLAY_TOP.
INCLUDE ZEA_TEM_DISPLAY_SCR.
INCLUDE ZEA_TEM_DISPLAY_CLS.
INCLUDE ZEA_TEM_DISPLAY_PBO.
INCLUDE ZEA_TEM_DISPLAY_PAI.
INCLUDE ZEA_TEM_DISPLAY_F01.

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
