*&---------------------------------------------------------------------*
*& Module Pool      SAPMZEA_03
*&---------------------------------------------------------------------*
*& [PP] 생산 검수 및 검수
*& [2024.04.26 / 단위 테스트 완료] - [PM] 김건우 : o
*&---------------------------------------------------------------------*

INCLUDE MZEA_PP220TOP.
*INCLUDE SAPMZEA_03TOP.   " Global Data
INCLUDE MZEA_PP220CLS.
*INCLUDE SAPMZEA_03CLS.   " Class
INCLUDE MZEA_PP220O01.
*INCLUDE SAPMZEA_03O01.   " PBO-Modules
INCLUDE MZEA_PP220I01.
*INCLUDE SAPMZEA_03I01.   " PAI-Modules
INCLUDE MZEA_PP220F01.
*INCLUDE SAPMZEA_03F01.   " FORM-Routines

LOAD-OF-PROGRAM.

  PERFORM INIT_VAL.
  PERFORM INIT_LISTBOX.
