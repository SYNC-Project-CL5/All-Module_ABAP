*&---------------------------------------------------------------------*
*& Report ZEA_GW_TES
*&---------------------------------------------------------------------*
*& [MM] 재고 이전 프로그램
*&---------------------------------------------------------------------*
REPORT ZEA_MM110 MESSAGE-ID ZEA_MSG.

INCLUDE ZEA_MM110_TOP.
INCLUDE ZEA_MM110_SCR.
INCLUDE ZEA_MM110_CLS.
INCLUDE ZEA_MM110_PBO.
INCLUDE ZEA_MM110_PAI.
INCLUDE ZEA_MM110_F01.
INCLUDE ZEA_MM110_F02.

*----------------------------------------------------------------------*
* INITIALIZATION
*----------------------------------------------------------------------*
INITIALIZATION.
  S0100-UNIT = 'PKG'.
*----------------------------------------------------------------------*
* AT SELECTION SCREEN OUTPUT
*----------------------------------------------------------------------*
AT SELECTION-SCREEN OUTPUT.


*----------------------------------------------------------------------*
* AT SELECTION SCREEN
*----------------------------------------------------------------------*
AT SELECTION-SCREEN. " ON VALUE-REQUEST FOR PA_MATNR.
*  PERFORM GET_DROPDOWN.


*----------------------------------------------------------------------*
* START-OF-SELECTION
*----------------------------------------------------------------------*
START-OF-SELECTION.
PERFORM SELECT_DATA.
PERFORM SELECT_DATA_LISTBOX.
PERFORM MAKE_DISPLAY_DATA.
PERFORM DISPLAY_DATA.
