*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZEA_SDV050_MT...................................*
TABLES: ZEA_SDV050_MT, *ZEA_SDV050_MT. "view work areas
CONTROLS: TCTRL_ZEA_SDV050_MT
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZEA_SDV050_MT. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZEA_SDV050_MT.
* Table for entries selected to show on screen
DATA: BEGIN OF ZEA_SDV050_MT_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZEA_SDV050_MT.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZEA_SDV050_MT_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZEA_SDV050_MT_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZEA_SDV050_MT.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZEA_SDV050_MT_TOTAL.

*.........table declarations:.................................*
TABLES: ZEA_SDT040                     .
TABLES: ZEA_SDT050                     .
