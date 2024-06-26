*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZEA_PPV02.......................................*
TABLES: ZEA_PPV02, *ZEA_PPV02. "view work areas
CONTROLS: TCTRL_ZEA_PPV02
TYPE TABLEVIEW USING SCREEN '0002'.
DATA: BEGIN OF STATUS_ZEA_PPV02. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZEA_PPV02.
* Table for entries selected to show on screen
DATA: BEGIN OF ZEA_PPV02_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZEA_PPV02.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZEA_PPV02_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZEA_PPV02_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZEA_PPV02.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZEA_PPV02_TOTAL.

*...processing: ZEA_PPV04.......................................*
TABLES: ZEA_PPV04, *ZEA_PPV04. "view work areas
CONTROLS: TCTRL_ZEA_PPV04
TYPE TABLEVIEW USING SCREEN '0003'.
DATA: BEGIN OF STATUS_ZEA_PPV04. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZEA_PPV04.
* Table for entries selected to show on screen
DATA: BEGIN OF ZEA_PPV04_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZEA_PPV04.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZEA_PPV04_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZEA_PPV04_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZEA_PPV04.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZEA_PPV04_TOTAL.

*...processing: ZEA_T001W.......................................*
DATA:  BEGIN OF STATUS_ZEA_T001W                     .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZEA_T001W                     .
CONTROLS: TCTRL_ZEA_T001W
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZEA_T001W                     .
TABLES: ZEA_CRHD                       .
TABLES: ZEA_T001W                      .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
