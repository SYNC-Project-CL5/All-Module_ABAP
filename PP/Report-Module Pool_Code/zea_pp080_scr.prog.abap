*&---------------------------------------------------------------------*
*& Include          ZALV_GRID_DISPLAY_SCR
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF SCREEN 1100 AS SUBSCREEN.
SELECTION-SCREEN BEGIN OF BLOCK B01 WITH FRAME TITLE TEXT-T01.
  SELECT-OPTIONS: SO_MRPID  FOR ZEA_MDKP-MRPID,
                  SO_PDAT FOR ZEA_MDKP-PDPDAT.
*                  SO_PMON FOR ZEA_MDKP-PDPMON.

SELECTION-SCREEN BEGIN OF LINE.
* TEXT-S02: 생산계획월
SELECTION-SCREEN COMMENT (28) TEXT-S02 FOR FIELD SO_PMON.
SELECT-OPTIONS SO_PMON FOR ZEA_MDKP-PDPMON NO-EXTENSION.
SELECTION-SCREEN PUSHBUTTON (10) TEXT-S01 USER-COMMAND SEARCH.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN END OF BLOCK B01.
SELECTION-SCREEN END OF SCREEN 1100.



* PARAMETERS PA_LAYO TYPE DISVARIANT.
*EX--------------------------------------------------------------------*
*SELECTION-SCREEN BEGIN OF TABBED BLOCK TAB_BLOCK FOR 10 LINES.
*SELECTION-SCREEN TAB (20) TAB1 USER-COMMAND COMM1 DEFAULT SCREEN 1100.
*SELECTION-SCREEN TAB (20) TAB2 USER-COMMAND COMM2 DEFAULT SCREEN 1200.
*SELECTION-SCREEN TAB (20) TAB3 USER-COMMAND COMM3 DEFAULT SCREEN 1300.
*SELECTION-SCREEN END OF BLOCK TAB_BLOCK.
*
*SELECTION-SCREEN BEGIN OF SCREEN 1100 AS SUBSCREEN.
*SELECT-OPTIONS:
*  SO_CAR  FOR GS_FLIGHT-CARRID MEMORY ID CAR,
*  SO_CON  FOR GS_FLIGHT-CONNID.
*
*SELECTION-SCREEN PUSHBUTTON /35(20) BUTTXT USER-COMMAND CLICK_DETAIL.
*
*" TEXT-T02: City about flight
*SELECTION-SCREEN BEGIN OF BLOCK CITY WITH FRAME TITLE TEXT-T02.
*SELECT-OPTIONS:
*  SO_CITYF FOR GS_FLIGHT-CITYFROM MODIF ID CTY,
*  SO_CITYT FOR GS_FLIGHT-CITYTO   MODIF ID CTY.
*SELECTION-SCREEN END OF BLOCK CITY.
*SELECTION-SCREEN END OF SCREEN 1100.
*
*SELECTION-SCREEN BEGIN OF SCREEN 1200 AS SUBSCREEN.
*SELECT-OPTIONS:
*  SO_DAY  FOR GS_FLIGHT-FLDATE NO-EXTENSION.
*SELECTION-SCREEN END OF SCREEN 1200.
*
*SELECTION-SCREEN BEGIN OF SCREEN 1300 AS SUBSCREEN.
*
*SELECTION-SCREEN BEGIN OF BLOCK CHECK.
*
*PARAMETERS:
*  PA_RA1  RADIOBUTTON GROUP RAG1," USER-COMMAND MODE, " Read all flights
*  PA_RA2  RADIOBUTTON GROUP RAG1,                   " Read only domestic flights
*  PA_RA3  RADIOBUTTON GROUP RAG1 DEFAULT 'X'.       " Read only international flights
*
*PARAMETERS:
*  PA_CTRFR LIKE GS_FLIGHT-COUNTRYFR.
*
*SELECTION-SCREEN END OF BLOCK CHECK.
*
*SELECTION-SCREEN END OF SCREEN 1300.

*EX------------------------------------------------------------------*
*SELECTION-SCREEN BEGIN OF BLOCK B01 WITH FRAME TITLE TEXT-T01.
*
*SELECT-OPTIONS SO_DAY FOR SFLIGHT-FLDATE OBLIGATORY
*                                         NO-EXTENSION.
*
*SELECTION-SCREEN SKIP 1. " 1줄 건너뛰기
*
*SELECTION-SCREEN BEGIN OF BLOCK B02 WITH FRAME
*                                    TITLE TEXT-T02
*                                    NO INTERVALS.
*PARAMETERS PA_CTRF  TYPE SPFLI-COUNTRYFR OBLIGATORY.
*SELECT-OPTIONS SO_CITYF FOR SPFLI-CITYFROM NO INTERVALS.
*SELECTION-SCREEN END OF BLOCK B02.
*
*SELECTION-SCREEN BEGIN OF BLOCK B03 WITH FRAME
*                                    TITLE TEXT-T03
*                                    NO INTERVALS.
*PARAMETERS PA_CTRT  TYPE SPFLI-COUNTRYTO OBLIGATORY.
*SELECT-OPTIONS SO_CITYT FOR SPFLI-CITYTO NO INTERVALS.
*SELECTION-SCREEN END OF BLOCK B03.
*
*SELECTION-SCREEN END OF BLOCK B01.
*--------------------------------------------------------------------*

*EX------------------------------------------------------------------*
" TEXT-T01 : Execute Mode
*SELECTION-SCREEN BEGIN OF BLOCK B01 WITH FRAME TITLE TEXT-T01.
*SELECTION-SCREEN BEGIN OF LINE.
*
*PARAMETERS PA_INS RADIOBUTTON GROUP RAG1.
*" TEXT-L01: Insert Data
*SELECTION-SCREEN COMMENT (15) TEXT-L01 FOR FIELD PA_INS.
*
*PARAMETERS PA_SEL RADIOBUTTON GROUP RAG1.
*" TEXT-L02: Select Data
*SELECTION-SCREEN COMMENT (15) TEXT-L02 FOR FIELD PA_SEL.
*
*PARAMETERS PA_DEL RADIOBUTTON GROUP RAG1.
*" TEXT-L03: Delete All Data
*SELECTION-SCREEN COMMENT (15) TEXT-L03 FOR FIELD PA_DEL.
*
*SELECTION-SCREEN END OF LINE.
*SELECTION-SCREEN END OF BLOCK B01.
*
*" TEXT-T02 : Selection Options
*SELECTION-SCREEN BEGIN OF BLOCK B02 WITH FRAME TITLE TEXT-T02.
*SELECT-OPTIONS:
*  SO_CAR FOR ZDETAIL_E00_REV-CARRID,
*  SO_CON FOR ZDETAIL_E00_REV-CONNID,
*  SO_DAT FOR ZDETAIL_E00_REV-FLDATE,
*  SO_ODT FOR ZDETAIL_E00_REV-ORDER_DATE.
*SELECTION-SCREEN END OF BLOCK B02.
*
*" TEXT-T03 : Additional Options
*SELECTION-SCREEN BEGIN OF BLOCK B03 WITH FRAME TITLE TEXT-T03.
*SELECT-OPTIONS:
*  SO_CTRF FOR ZDETAIL_E00_REV-COUNTRYFR NO INTERVALS NO-EXTENSION,
*  SO_CITF FOR ZDETAIL_E00_REV-CITYFROM  NO INTERVALS NO-EXTENSION,
*  SO_CTRT FOR ZDETAIL_E00_REV-COUNTRYTO NO INTERVALS NO-EXTENSION,
*  SO_CITT FOR ZDETAIL_E00_REV-CITYTO    NO INTERVALS NO-EXTENSION.
*PARAMETERS
*  PA_INCL AS CHECKBOX.
*SELECTION-SCREEN END OF BLOCK B03.
*--------------------------------------------------------------------*

*EX------------------------------------------------------------------*
*SELECTION-SCREEN BEGIN OF BLOCK B01 WITH FRAME TITLE TEXT-T01.
*
*  SELECT-OPTIONS: SO_CAR FOR ZFLIGHT_E23-CARRID,
*                  SO_CON FOR ZFLIGHT_E23-CONNID,
*                  SO_DAT FOR ZFLIGHT_E23-FLDATE NO-EXTENSION.
*
*  SELECTION-SCREEN SKIP 1.
*
*  PARAMETERS: P_MAX TYPE I.
*
*SELECTION-SCREEN END OF BLOCK B01.
*
*SELECTION-SCREEN SKIP 1.
*
*SELECTION-SCREEN PUSHBUTTON /1(30) BUTTXT USER-COMMAND CLICK_DETAIL.
*
*SELECTION-SCREEN BEGIN OF BLOCK B02 WITH FRAME TITLE TEXT-T02.
*
*  PARAMETERS : PA_RAD1 RADIOBUTTON GROUP RD1 MODIF ID MOD
*                                             USER-COMMAND RG1,
*               PA_RAD2 RADIOBUTTON GROUP RD1 MODIF ID MOD,
*               PA_RAD3 RADIOBUTTON GROUP RD1 MODIF ID MOD,
*               PA_RAD4 RADIOBUTTON GROUP RD1 MODIF ID MOD DEFAULT 'X'.
*
*SELECTION-SCREEN END OF BLOCK B02.
*--------------------------------------------------------------------*
