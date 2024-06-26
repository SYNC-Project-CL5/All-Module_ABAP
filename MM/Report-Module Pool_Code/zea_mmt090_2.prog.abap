*&---------------------------------------------------------------------*
*& Report ZEA_CHECK_MT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEA_MMT090_2 MESSAGE-ID ZEA_MSG.

INCLUDE ZEA_MMT090_2TOP.

INCLUDE ZEA_MMT090_2SCR.

INCLUDE ZEA_MMT090_2CLS.

INCLUDE ZEA_MMT090_2PBO.

INCLUDE ZEA_MMT090_2PAI.

INCLUDE ZEA_MMT090_2F01.


INITIALIZATION.

AT SELECTION-SCREEN OUTPUT.

AT SELECTION-SCREEN.

START-OF-SELECTION.

PERFORM SELECT_DATA.
PERFORM MAKE_DISPLAY_DATA.
PERFORM DISPLAY_DATA.
