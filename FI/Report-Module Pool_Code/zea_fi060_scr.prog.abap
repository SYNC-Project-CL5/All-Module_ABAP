*&---------------------------------------------------------------------*
*& Include          ZEA_OPEN_MANG_SCR
*&---------------------------------------------------------------------*


" T01 : Costomer selection
SELECTION-SCREEN BEGIN OF BLOCK B01 WITH FRAME TITLE TEXT-T01.

  SELECT-OPTIONS : SO_CSTAC FOR ZEA_KNA1-CUSCODE,
                   SO_COCO FOR ZEA_FIT700-BUKRS
                   NO-EXTENSION
                   NO INTERVALS DEFAULT '1000'.

SELECTION-SCREEN END OF BLOCK B01.

SELECTION-SCREEN SKIP 1.

                                          " T02 : Line item selection
SELECTION-SCREEN BEGIN OF BLOCK B02 WITH FRAME TITLE TEXT-T02.

    SELECTION-SCREEN SKIP 1.
                                                  " T03 : Status
  SELECTION-SCREEN BEGIN OF BLOCK B03 WITH FRAME TITLE TEXT-T03.

    PARAMETERS RAD_OPEN RADIOBUTTON GROUP RAG1. "Open items
    SELECT-OPTIONS OPEN_DAT FOR ZEA_FIT700-BUDAT NO-EXTENSION
                                                 NO INTERVALS.
    PARAMETERS RAD_CLEA RADIOBUTTON GROUP RAG1.       "Cleared items
    SELECT-OPTIONS SO_C_DAT FOR ZEA_FIT700-BUDAT.

    PARAMETERS RAD_ALL RADIOBUTTON GROUP RAG1 DEFAULT 'X'. "All items
    SELECT-OPTIONS SO_RESDT FOR ZEA_FIT700-BUDAT.

  SELECTION-SCREEN END OF BLOCK B03.
SELECTION-SCREEN END OF BLOCK B02.
