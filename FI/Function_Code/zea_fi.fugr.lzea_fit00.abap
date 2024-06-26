*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZEA_FI_SKA1.....................................*
TABLES: ZEA_FI_SKA1, *ZEA_FI_SKA1. "view work areas
CONTROLS: TCTRL_ZEA_FI_SKA1
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZEA_FI_SKA1. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZEA_FI_SKA1.
* Table for entries selected to show on screen
DATA: BEGIN OF ZEA_FI_SKA1_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZEA_FI_SKA1.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZEA_FI_SKA1_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZEA_FI_SKA1_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZEA_FI_SKA1.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZEA_FI_SKA1_TOTAL.

*.........table declarations:.................................*
TABLES: ZEA_SKA1                       .
TABLES: ZEA_T005                       .
