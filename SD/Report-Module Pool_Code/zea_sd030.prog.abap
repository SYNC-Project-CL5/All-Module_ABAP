*&---------------------------------------------------------------------*
*& Report ZEA_SD030
*&---------------------------------------------------------------------*
*& [SD] 판매오더 생성
*&---------------------------------------------------------------------*
REPORT ZEA_SD030 MESSAGE-ID ZEA_MSG.

INCLUDE ZEA_SD030_TOP.
INCLUDE ZEA_SD030_CLS.
INCLUDE ZEA_SD030_PBO.
INCLUDE ZEA_SD030_PAI.
INCLUDE ZEA_SD030_F01.

*--------------------------------------------------------------------*

INITIALIZATION.
ZEA_SDT040-WAERS = 'KRW'.

AT SELECTION-SCREEN OUTPUT.

AT SELECTION-SCREEN.

START-OF-SELECTION.
  PERFORM DISPLAY_DATA.
