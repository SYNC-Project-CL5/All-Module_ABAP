*&---------------------------------------------------------------------*
*& Report ZEA_TR_TEM2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEA_TR_MPS_TEST MESSAGE-ID oo.

INCLUDE ZEA_TR_MPS_TEST_TOP.
*INCLUDE ZEA_TR_MPS_TOP.
*INCLUDE zea_tr_tem2_top.  " 전역변수 선언
INCLUDE ZEA_TR_MPS_TEST_SCR.
*INCLUDE ZEA_TR_MPS_SCR.
*INCLUDE zea_tr_tem2_scr.  " Selection Screen 구성
INCLUDE ZEA_TR_MPS_TEST_CLS.
*INCLUDE ZEA_TR_MPS_CLS.
*INCLUDE zea_tr_tem2_cls.  " Local Class 정의구현
INCLUDE ZEA_TR_MPS_TEST_PBO.
*INCLUDE ZEA_TR_MPS_PBO.
*INCLUDE zea_tr_tem2_pbo.  " Screen 출력 전 Logic 처리 / PBO
INCLUDE ZEA_TR_MPS_TEST_PAI.
*INCLUDE ZEA_TR_MPS_PAI.
*INCLUDE zea_tr_tem2_pai.  " Screen 출력 후 사용자에 의한 명령 처리
INCLUDE ZEA_TR_MPS_TEST_F01.
*INCLUDE ZEA_TR_MPS_F01.
*INCLUDE zea_tr_tem2_f01.  " Form Subroutines 모음

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
  PERFORM get_data.

  CALL SCREEN '0100'.
