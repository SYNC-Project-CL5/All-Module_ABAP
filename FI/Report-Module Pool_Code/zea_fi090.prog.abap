*&---------------------------------------------------------------------*
*& Report ZEA_FI090
*&---------------------------------------------------------------------*
*& [FI] 손익계산서 프로그램 [완료] ACA5-08 김예리
*&---------------------------------------------------------------------*
*& [수정이력]
* 1.2024.05.02 : 동일 GL계정과 거래처의 데이터가 1분기 1줄, 2분기 1줄, 총 ALV 라인 두 줄로 나타난다.
*&---------------------------------------------------------------------*
REPORT ZEA_FI090 MESSAGE-ID ZEA_MSG.

INCLUDE ZEA_FI090_TOP.
INCLUDE ZEA_FI090_SCR.
INCLUDE ZEA_FI090_CLS.

INCLUDE ZEA_FI090_PBO.
INCLUDE ZEA_FI090_PAI.
INCLUDE ZEA_FI090_F01.

*&---------------------------------------------------------------------*
INITIALIZATION.
*      P_FILE = 'C:\.pdf'.
AT SELECTION-SCREEN OUTPUT.

AT SELECTION-SCREEN.

START-OF-SELECTION.
  PERFORM SELECT_DATA.
  PERFORM MOVE_DISPLAY_DATA.
  PERFORM MAKE_DISPLAY_DATA. " ALV 행 색상
  PERFORM DISPLAY_DATA.
