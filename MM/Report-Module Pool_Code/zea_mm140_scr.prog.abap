*&---------------------------------------------------------------------*
*& Include          ZEA_MM140_SCR
*&---------------------------------------------------------------------*

SELECTION-SCREEN FUNCTION KEY 1.

" TEXT-T01: Selection Options
SELECTION-SCREEN BEGIN OF BLOCK B01 WITH FRAME TITLE TEXT-T01.

" 대소문자 구별하는 문자열 257자리
PARAMETERS PA_FNAME TYPE FILE_NAME.

SELECTION-SCREEN END OF BLOCK B01.
