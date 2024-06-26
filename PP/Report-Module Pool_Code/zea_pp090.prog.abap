*&---------------------------------------------------------------------*
*& Report ZEA_PP090
*&---------------------------------------------------------------------*
*& [PP] 생산오더 생성
*& [2024.05.13 / 단위 테스트 완료] - [PM] 김건우 : o
*&---------------------------------------------------------------------*
REPORT ZEA_PP090 MESSAGE-ID ZEA_MSG.

INCLUDE ZEA_PP090_TOP.
INCLUDE ZEA_PP090_CLS.
INCLUDE ZEA_PP090_SCR.
INCLUDE ZEA_PP090_PBO.
INCLUDE ZEA_PP090_PAI.
INCLUDE ZEA_PP090_F01.

INITIALIZATION.

AT SELECTION-SCREEN.

START-OF-SELECTION.

  PERFORM SELECT_DATA.
  PERFORM MAKE_DISPLAY_DATA.

  CALL SCREEN 0100.
