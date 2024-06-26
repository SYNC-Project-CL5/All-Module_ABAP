*&---------------------------------------------------------------------*
*& Report YE12_PJ020
*&---------------------------------------------------------------------*
*& [SD] 연습 - 판매운영계획 생성
*&---------------------------------------------------------------------*
*& [2024.04.18 / 단위 테스트 완료] - [PM] 김건우 : X
*& [2024.04.29 / 단위 테스트 완료] - [PM] 김건우 : O
*&---------------------------------------------------------------------*
REPORT ZEA_SD010 MESSAGE-ID ZEA_MSG.

INCLUDE ZEA_SD010_TOP.
*INCLUDE ZEA_SD011_TOP.
INCLUDE ZEA_SD010_SCR.
*INCLUDE ZEA_SD011_SCR.
INCLUDE ZEA_SD010_CLS.
*INCLUDE ZEA_SD011_CLS.
INCLUDE ZEA_SD010_PBO.
*INCLUDE ZEA_SD011_PBO.
INCLUDE ZEA_SD010_PAI.
*INCLUDE ZEA_SD011_PAI.
INCLUDE ZEA_SD010_F01.
*INCLUDE ZEA_SD011_F01.


*--------------------------------------------------------------------*

INITIALIZATION.
ZEA_SDT020-MEINS = 'PKG'.
ZEA_SDT020-WAERS = 'KRW'.
GV_MODE1 = ABAP_OFF.

*CLEAR GT_DISPLAY2.

AT SELECTION-SCREEN OUTPUT.

AT SELECTION-SCREEN.

START-OF-SELECTION.
  PERFORM SELECT_DATA.
  PERFORM MAKE_DISPLAY_DATA.
  PERFORM DISPLAY_DATA.

*  CALL SCREEN 0100.
