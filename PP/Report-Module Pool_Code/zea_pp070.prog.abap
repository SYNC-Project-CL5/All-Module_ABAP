*&---------------------------------------------------------------------*
*& Report ZEA_PP070
*&---------------------------------------------------------------------*
*& [PP] MRP 계산
*& [2024.05.13 / 단위 테스트 완료] - [PM] 김건우 : o
*&---------------------------------------------------------------------*
REPORT ZEA_PP070 MESSAGE-ID ZEA_MSG.

INCLUDE ZEA_PP070_TOP.
INCLUDE ZEA_PP070_CLS.
INCLUDE ZEA_PP070_SCR.
INCLUDE ZEA_PP070_PBO.
INCLUDE ZEA_PP070_PAI.
INCLUDE ZEA_PP070_F01.

INITIALIZATION.

AT SELECTION-SCREEN.

START-OF-SELECTION.

  PERFORM SELECT_DATA.
*  PERFORM MODIFY_DATA.

  CALL SCREEN 0100.
