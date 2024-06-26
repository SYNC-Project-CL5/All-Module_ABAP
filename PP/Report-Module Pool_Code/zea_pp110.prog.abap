*&---------------------------------------------------------------------*
*& Report YE00_EX007
*&---------------------------------------------------------------------*
*& [PP] 생산계획 생성 및 조회
*& [2024.05.13 / 단위 테스트 완료] - [PM] 김건우 : o
*&---------------------------------------------------------------------*
REPORT ZEA_PP110 MESSAGE-ID ZEA_MSG.

INCLUDE ZEA_PP110TOP.

INCLUDE ZEA_PP110CLS.

INCLUDE ZEA_PP110SCR.

INCLUDE ZEA_PP110PBO.

INCLUDE ZEA_PP110PAI.

INCLUDE ZEA_PP110F01. " 판매계획과 관련된 서브루틴 집합
INCLUDE ZEA_PP110F02. " 생산계획과 관련된 서브루틴 집합


*----------------------------------------------------------------------*
* INITIALIZATION
*----------------------------------------------------------------------*
INITIALIZATION.

*----------------------------------------------------------------------*
* AT SELECTION SCREEN OUTPUT
*----------------------------------------------------------------------*
AT SELECTION-SCREEN OUTPUT.

*----------------------------------------------------------------------*
* AT SELECTION SCREEN
*----------------------------------------------------------------------*
AT SELECTION-SCREEN.

*----------------------------------------------------------------------*
* START-OF-SELECTION
*----------------------------------------------------------------------*
START-OF-SELECTION.

  PERFORM SELECT_DATA.
  PERFORM DISPLAY_DATA.
  CALL SCREEN 0100.
