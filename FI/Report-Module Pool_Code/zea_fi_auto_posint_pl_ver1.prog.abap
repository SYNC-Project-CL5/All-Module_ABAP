*&---------------------------------------------------------------------*
*& Report ZEA_FI_AUTO_POSINT_PL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEA_FI_AUTO_POSINT_PL_VER1.

INCLUDE ZEA_FI_AUTO_POSINT_PL_TOP_VER.
*INCLUDE ZEA_FI_AUTO_POSINT_PL_TOP.
INCLUDE ZEA_FI_AUTO_POSINT_PL_F01_VER.
*INCLUDE ZEA_FI_AUTO_POSINT_PL_F01.

*WRITE: GV_BELNR_NUMBER." 채번 확인 완료


INITIALIZATION.
  PERFORM SALES.   " 매출원가/매출
  PERFORM SALARY.  " 급여
  PERFORM EXPENSE. " 판관비
