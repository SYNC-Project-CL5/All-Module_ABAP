*&---------------------------------------------------------------------*
*& Report ZEA_FI_BS
*&---------------------------------------------------------------------*
*& [FI] 대차대조표 프로그램 2024-04-24   [생성] ACA5-17 이세영
*&---------------------------------------------------------------------*
*& [2024.05.02] [완료] / 단위 테스트 미진행] - [PM] 김건우 : -
*&---------------------------------------------------------------------*
* 1. 유동/비유동 구분 (O)
* 2. 계정 잔액 정상 조회 (O)
* 3. ALV Tree 별 Layout 구분 (O)
* 4. 더블클릭 시, 계정별 잔액 세부 조회 기능 (O)
*&---------------------------------------------------------------------*
REPORT ZEA_FI100 MESSAGE-ID ZEA_MSG.

* [2024.05.04] 현재 당기순이익 불러오기 - 함수 첨부함 (예리)
DATA: LV_INCOME TYPE ZEA_BSEG-DMBTR.

CALL FUNCTION 'ZEA_NI'
 IMPORTING
   EV_INCOME = LV_INCOME.

INCLUDE ZEA_FI100_TOP.
*INCLUDE ZEA_FI_BS_4_TOP.  " 전역변수 선언

INCLUDE ZEA_FI100_CLS.
*INCLUDE ZEA_FI_BS_4_CLS.  " Local Class 정의구현

INCLUDE ZEA_FI100_PBO.
*INCLUDE ZEA_FI_BS_4_PBO.  " Screen 출력 전 Logic 처리 / PBO

INCLUDE ZEA_FI100_PAI.
*INCLUDE ZEA_FI_BS_4_PAI.  " Screen 출력 후 사용자에 의한 명령 처리

INCLUDE ZEA_FI100_F01.
*INCLUDE ZEA_FI_BS_4_F01.  " Form Subroutines 모음

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

*-- Select Data
  PERFORM GET_DATA.  "자산
  PERFORM GET_DATA2. "부채
  PERFORM GET_DATA3. "자본

*-- Make Display Data
  PERFORM MOVE_DISPLAY.  "왼쪽 컨테이너 값 채우기 - 자산
  PERFORM MOVE_DISPLAY2. "왼쪽 컨테이너 값 채우기 - 부채
  PERFORM MOVE_DISPLAY3. "왼쪽 컨테이너 값 채우기 - 자본

  " []는 인터널 테이블에 담겨있는 내용을 의미, 즉 쌓여있는 데이터
  IF GT_DATA[] IS INITIAL. " => 한 줄도 없는지 검사
    MESSAGE '검색된 결과가 없습니다.' TYPE 'S' DISPLAY LIKE 'W'.
  ELSE.

*-- Display Data
    CALL SCREEN 0100.
  ENDIF.
