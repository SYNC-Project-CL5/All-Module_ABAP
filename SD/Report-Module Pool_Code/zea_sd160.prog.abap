*&---------------------------------------------------------------------*
*& Report ZEA_SD160
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEA_SD160 MESSAGE-ID ZEA_MSG.

*프로그램 설명 : B2B 고객별 여신 현황을 계산하고 잔액을 조회하는 프로그램
*- 승인된 판매오더중 STATUS4에 'X' 값이 입력되지 않은 건(수금완료되지 않은 건들) 만 조회하여 총 구매금액(TOAMT) 을 합산한다.
*- 합산된 금액을 고객여신 테이블(ZEA_KNKK)에서 여신 한도(KLIMK)필드에서 차액을 구하고 여신 잔액으로 입력한다.
*- 잔액의 비율에 따라 LED로 표시한다.(잔액이 30%부터 노란색 LED, 5%부터 빨간색 LED 표시)
*- SCR에서 고객을 검색하고 검색된 고객의 데이터(ZEA_KNA1)와 함께 여신데이터(ZEA_KNKK)를 보여준다.

INCLUDE ZEA_SD160_TOP.
INCLUDE ZEA_SD160_SCR.
INCLUDE ZEA_SD160_CLS.
INCLUDE ZEA_SD160_PBO.
INCLUDE ZEA_SD160_PAI.
INCLUDE ZEA_SD160_F01.

INITIALIZATION.

AT SELECTION-SCREEN OUTPUT.

  MESSAGE S039.

AT SELECTION-SCREEN.

START-OF-SELECTION.
  PERFORM SELECT_DATA.
  PERFORM DISPLAY_DATA.
  PERFORM MODIFY_DATA.
