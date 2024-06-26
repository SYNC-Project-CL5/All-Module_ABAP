*&---------------------------------------------------------------------*
*& REPORT ZEA_FI040
*&---------------------------------------------------------------------*
*& [FI] G/L 계정원장 프로그램 2024.04.17 [완료] - ACA5-08 김예리
*&---------------------------------------------------------------------*
*& [2024.04.18 / 단위 테스트 완료] - [PM] 김건우 : o
*& [수정이력]
* 1. 전기키가 없는 데이터가 있으면 13번째 줄이 생김 확인.
* 2. 금액+세금 합계 금액이 보이도록 수정함.
* 3. 2024.04.30 : 세금 필드 삭제(덤프) 반영 및 SO_SAKNR INITIALIZATION 수정.
*&---------------------------------------------------------------------*
REPORT ZEA_FI040 MESSAGE-ID ZEA_MSG.

INCLUDE ZEA_FI040_TOP.
INCLUDE ZEA_FI040_SCR.
INCLUDE ZEA_FI040_CLS.

INCLUDE ZEA_FI040_PBO.
INCLUDE ZEA_FI040_PAI.
INCLUDE ZEA_FI040_F01.

* ABAP Event-----------------------------------------------------------*
INITIALIZATION.
  PA_BUKRS = 1000.
  PA_GJAHR = 2024.

  " 재무제표에서 SET Parameter 호출
  CLEAR: SO_SAKNR. " 필드 초기화
  REFRESH SO_SAKNR[].

  SO_SAKNR-SIGN = 'I'.
  SO_SAKNR-OPTION = 'EQ'.
  GET PARAMETER ID 'ZEA_SAKNR' FIELD SO_SAKNR-LOW.
  APPEND SO_SAKNR.

  IF SO_SAKNR-LOW IS INITIAL.
    CLEAR SO_SAKNR.
    REFRESH SO_SAKNR[].
  ENDIF.

AT SELECTION-SCREEN OUTPUT.

AT SELECTION-SCREEN.

START-OF-SELECTION.
  PERFORM SELECT_DATA.
  PERFORM MODIFY_DISPLAY_DATA.
  PERFORM DISPLAY_DATA.
