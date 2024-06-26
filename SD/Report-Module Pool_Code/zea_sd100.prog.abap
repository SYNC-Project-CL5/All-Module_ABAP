*&---------------------------------------------------------------------*
*& Report ZEA_TR_TEM
*&---------------------------------------------------------------------*
*& [SD] 판매운영계획 조회 [진행중] - ACA5-12 박지영
*&---------------------------------------------------------------------*
REPORT zea_sd100 MESSAGE-ID ZEA_MSG.

INCLUDE ZEA_SD100_TOP.
*INCLUDE YE12_PJ043_TOP.
*INCLUDE zea_tr_tem_top.  " 전역변수 선언
INCLUDE ZEA_SD100_SCR.
*INCLUDE YE12_PJ043_SCR.
*INCLUDE zea_tr_tem_scr.  " Selection Screen 구성
INCLUDE ZEA_SD100_CLS.
*INCLUDE YE12_PJ043_CLS.
*INCLUDE zea_tr_tem_cls.  " Local Class 정의구현
INCLUDE ZEA_SD100_PBO.
*INCLUDE YE12_PJ043_PBO.
*INCLUDE zea_tr_tem_pbo.  " Screen 출력 전 Logic 처리 / PBO
INCLUDE ZEA_SD100_PAI.
*INCLUDE YE12_PJ043_PAI.
*INCLUDE zea_tr_tem_pai.  " Screen 출력 후 사용자에 의한 명령 처리
INCLUDE ZEA_SD100_F01.
*INCLUDE YE12_PJ043_F01.
*INCLUDE zea_tr_tem_f01.  " Form Subroutines 모음

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
