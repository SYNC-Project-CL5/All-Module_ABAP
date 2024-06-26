*&---------------------------------------------------------------------*
*& Report ZALV_GRID_DISPLAY
*&---------------------------------------------------------------------*
*& [SD] 판가 생성 및 조회
*&---------------------------------------------------------------------*
*& [2024.04.19 / 단위 테스트 요청] - [SD] 유연수
*& [2024.04.22 / 단위 테스트 완료] - [PM] 김건우 : o
*&---------------------------------------------------------------------*
REPORT ZEA_SD_A02 MESSAGE-ID ZMSG_E23.

INCLUDE ZEA_SD_A02_TOP.
INCLUDE ZEA_SD_A02_SCR.
INCLUDE ZEA_SD_A02_CLS.
INCLUDE ZEA_SD_A02_PBO.
INCLUDE ZEA_SD_A02_PAI.
INCLUDE ZEA_SD_A02_F01.

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
