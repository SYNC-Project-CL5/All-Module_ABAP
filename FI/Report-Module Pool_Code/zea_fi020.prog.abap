*&---------------------------------------------------------------------*
*& Report ZALV_GRID_DISPLAY
*&---------------------------------------------------------------------*
*& [FI] 전표조회 프로그램 2024.04.13 [완료] - ACA5-17 이세영
*&---------------------------------------------------------------------*
*& [2024.04.18 / 단위 테스트 완료] - [PM] 김건우 : o
*&---------------------------------------------------------------------*
*& [2024.05.04 / 수정 완료]
*& - Screen 가시성 조정
*&---------------------------------------------------------------------*
REPORT ZEA_FI020 MESSAGE-ID ZEA_MSG.

INCLUDE ZEA_FI020_TOP.
INCLUDE ZEA_FI020_SCR.
INCLUDE ZEA_FI020_CLS.
INCLUDE ZEA_FI020_PBO.
INCLUDE ZEA_FI020_PAI.
INCLUDE ZEA_FI020_F01.

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

AT SELECTION-SCREEN.
  PERFORM SSCR_USER_COMMAND.

*----------------------------------------------------------------------*
* START-OF-SELECTION
*----------------------------------------------------------------------*
START-OF-SELECTION.

  PERFORM SELECT_DATA.
  PERFORM MAKE_DISPLAY_DATA.
  PERFORM DISPLAY_DATA.
