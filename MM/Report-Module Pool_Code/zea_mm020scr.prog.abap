*&---------------------------------------------------------------------*
*& Include          YE07_STROSCR
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF SCREEN 1100 AS SUBSCREEN.
  SELECTION-SCREEN BEGIN OF BLOCK BLK1 WITH FRAME TITLE TEXT-T01.

    SELECT-OPTIONS: SO_WERKS FOR ZEA_MMT060-WERKS,
                    SO_SCODE FOR ZEA_MMT060-SCODE MATCHCODE OBJECT ZEA_MM_SCODE,
                    SO_STYPE FOR ZEA_MMT060-STYPE.

SELECTION-SCREEN BEGIN OF LINE.
* TEXT-S02: Flight Date
SELECTION-SCREEN COMMENT (28) TEXT-S02 FOR FIELD SO_SNAME.
SELECT-OPTIONS SO_SNAME FOR ZEA_MMT060-SNAME NO-EXTENSION.
SELECTION-SCREEN PUSHBUTTON (10) TEXT-S01 USER-COMMAND SEARCH.
SELECTION-SCREEN END OF LINE.
  SELECTION-SCREEN END OF BLOCK BLK1.
  SELECTION-SCREEN END OF SCREEN 1100.
