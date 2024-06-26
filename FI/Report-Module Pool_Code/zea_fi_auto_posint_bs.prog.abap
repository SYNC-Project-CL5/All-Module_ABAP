*&---------------------------------------------------------------------*
*& Report ZEA_FI_AUTO_POSINT_PL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEA_FI_AUTO_POSINT_BS.

INCLUDE ZEA_FI_AUTO_POSINT_BS_TOP.
INCLUDE ZEA_FI_AUTO_POSINT_BS_F01.

*WRITE: GV_BELNR_NUMBER." 채번 확인 완료

INITIALIZATION.
  PERFORM BS.  " 자산/부채/자본
