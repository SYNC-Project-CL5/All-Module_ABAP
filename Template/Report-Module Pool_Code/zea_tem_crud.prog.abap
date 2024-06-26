*&---------------------------------------------------------------------*
*& Report ZALV_GRID_CRUD
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEA_TEM_CRUD MESSAGE-ID ZEA_MSG.

INCLUDE ZEA_TEM_CRUD_TOP.
INCLUDE ZEA_TEM_CRUD_SCR.
INCLUDE ZEA_TEM_CRUD_CLS.
INCLUDE ZEA_TEM_CRUD_PBO.
INCLUDE ZEA_TEM_CRUD_PAI.
INCLUDE ZEA_TEM_CRUD_F01.

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
