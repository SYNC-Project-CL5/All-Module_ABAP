*&---------------------------------------------------------------------*
*& Include          YE00_EX001_SCR
*&---------------------------------------------------------------------*
SELECTION-SCREEN SKIP 1. "Selection Screen에서 1줄 건너띄기

*TEXT-T01 : G/L Account Balance Display
SELECTION-SCREEN BEGIN OF BLOCK B01 WITH FRAME TITLE TEXT-T01.

  SELECT-OPTIONS:
    SO_SAKNR FOR GS_ALL-SAKNR NO-EXTENSION. " G/L Code
  PARAMETERS:
    PA_BUKRS TYPE ZEA_BUKRS, " 회사코드 (1000번)
    PA_GJAHR TYPE ZEA_GJAHR. " 회계연도

SELECTION-SCREEN END OF BLOCK B01.
