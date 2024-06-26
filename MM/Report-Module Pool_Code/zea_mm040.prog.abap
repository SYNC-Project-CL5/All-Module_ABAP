*&---------------------------------------------------------------------*
*& Report ZEA_MM040
*&---------------------------------------------------------------------*
*& [MM] 플랜트 데이터 조회/생성/수정/삭제 프로그램 - ACA5-10 김혜진
*&---------------------------------------------------------------------*
*& [2024.04.22 / 단위 테스트 완료] - [PM] 김건우 : x
*& [2024.04.22 / 단위 테스트 완료] - [PM] 김건우 : o
*&---------------------------------------------------------------------*
REPORT ZEA_MM040.

*&--------------------------------------------------------------------*
*& INCLUDE MODULE
*&--------------------------------------------------------------------*
INCLUDE ZEA_MM040_TOP.
INCLUDE ZEA_MM040_SCR.
INCLUDE ZEA_MM040_CLS.
INCLUDE ZEA_MM040_PBO.
INCLUDE ZEA_MM040_PAI.
INCLUDE ZEA_MM040_F01.

*&--------------------------------------------------------------------*
*& INITIALIZATION
*&--------------------------------------------------------------------*
INITIALIZATION.
  CLEAR: GT_MMT030, GT_MMT030[].

*&--------------------------------------------------------------------*
*& AT SELECTION-SCREEN
*&--------------------------------------------------------------------*
AT SELECTION-SCREEN.

*&--------------------------------------------------------------------*
*& START-OF-SELECTION
*&--------------------------------------------------------------------*
START-OF-SELECTION.
  PERFORM REFRESH_RTN.

*&--------------------------------------------------------------------*
*& END-OF-SELECTION
*&--------------------------------------------------------------------*
END-OF-SELECTION.
  PERFORM DISPLAY_DATA.