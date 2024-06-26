*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZEA_SDT050MV....................................*
TABLES: ZEA_SDT050MV, *ZEA_SDT050MV. "view work areas
CONTROLS: TCTRL_ZEA_SDT050MV
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZEA_SDT050MV. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZEA_SDT050MV.
* Table for entries selected to show on screen
DATA: BEGIN OF ZEA_SDT050MV_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZEA_SDT050MV.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZEA_SDT050MV_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZEA_SDT050MV_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZEA_SDT050MV.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZEA_SDT050MV_TOTAL.

*.........table declarations:.................................*
TABLES: ZEA_SDT050                     .
