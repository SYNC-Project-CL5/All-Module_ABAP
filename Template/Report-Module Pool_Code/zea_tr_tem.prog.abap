*&---------------------------------------------------------------------*
*& Report ZEA_TR_TEM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zea_tr_tem MESSAGE-ID oo.

INCLUDE zea_tr_tem_top.  " 전역변수 선언
INCLUDE zea_tr_tem_scr.  " Selection Screen 구성
INCLUDE zea_tr_tem_cls.  " Local Class 정의구현
INCLUDE zea_tr_tem_pbo.  " Screen 출력 전 Logic 처리 / PBO
INCLUDE zea_tr_tem_pai.  " Screen 출력 후 사용자에 의한 명령 처리
INCLUDE zea_tr_tem_f01.  " Form Subroutines 모음

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
