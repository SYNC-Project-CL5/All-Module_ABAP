*&---------------------------------------------------------------------*
*& Include          YE00_EX001_SCR
*&---------------------------------------------------------------------*


" TEXT-T01: Selection Options
SELECTION-SCREEN BEGIN OF BLOCK B01 WITH FRAME TITLE TEXT-T01.

" SELECT-OPTIONS 의 경우 FOR 뒤에는 반드시 변수가 등장해야 한다.
SELECT-OPTIONS SO_MAT FOR ZEA_SDT090-MATNR NO-EXTENSION NO INTERVALS.
SELECT-OPTIONS SO_LOE FOR ZEA_SDT090-LOEKZ NO-EXTENSION NO INTERVALS.



SELECTION-SCREEN END OF BLOCK B01.
