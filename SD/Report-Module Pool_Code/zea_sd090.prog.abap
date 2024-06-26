*&---------------------------------------------------------------------*
*& Report ZALV_GRID_DISPLAY
*&---------------------------------------------------------------------*
*& [SD] 대금 청구 문서 2024.04.23 [완료] - ACA5-15 유연수
*&---------------------------------------------------------------------*
*& [2024.04.23 / 단위 테스트 요청] - [SD] 유연수
*& [2024.04.23 / 단위 테스트 완료] - [PM] 김건우 :
*&---------------------------------------------------------------------*

REPORT ZEA_SD090 MESSAGE-ID ZMSG_E23.

INCLUDE ZEA_SD090_TOP.
*INCLUDE ZEA_SD090_PRAC_TOP.
INCLUDE ZEA_SD090_SCR.
*INCLUDE ZEA_SD090_PRAC_SCR.
INCLUDE ZEA_SD090_CLS.
*INCLUDE ZEA_SD090_PRAC_CLS.
INCLUDE ZEA_SD090_PBO.
*INCLUDE ZEA_SD090_PRAC_PBO.
INCLUDE ZEA_SD090_PAI.
*INCLUDE ZEA_SD090_PRAC_PAI.
INCLUDE ZEA_SD090_F01.
*INCLUDE ZEA_SD090_PRAC_F01.

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
