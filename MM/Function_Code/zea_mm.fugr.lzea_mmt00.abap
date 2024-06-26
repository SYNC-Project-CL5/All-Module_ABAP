*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZEA_MMV040......................................*
TABLES: ZEA_MMV040, *ZEA_MMV040. "view work areas
CONTROLS: TCTRL_ZEA_MMV040
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZEA_MMV040. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZEA_MMV040.
* Table for entries selected to show on screen
DATA: BEGIN OF ZEA_MMV040_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZEA_MMV040.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZEA_MMV040_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZEA_MMV040_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZEA_MMV040.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZEA_MMV040_TOTAL.

*.........table declarations:.................................*
TABLES: ZEA_MMT040                     .
TABLES: ZEA_MMT050                     .
