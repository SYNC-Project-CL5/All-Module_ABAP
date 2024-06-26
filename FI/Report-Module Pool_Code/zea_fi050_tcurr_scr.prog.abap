*&---------------------------------------------------------------------*
*& Include          ZEA_FI050_TUCRR_SCR
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK B01 WITH FRAME TITLE TEXT-T01. " 검색 조건

  PARAMETERS: PA_TCURR TYPE ZEA_TCURR-TCURR OBLIGATORY." 조회 통화
  SELECT-OPTIONS: SO_GDATU FOR ZEA_TCURR-GDATU NO-EXTENSION. " 조회 날짜

 " 한 줄 띄워쓰기 --

SELECTION-SCREEN END OF BLOCK B01.

" 조회기간 선택
SELECTION-SCREEN BEGIN OF BLOCK B02 WITH FRAME TITLE TEXT-T02. " 조회 기간
  PARAMETERS: RA_1 TYPE C RADIOBUTTON GROUP RA1 USER-COMMAND MODE, " 7일 이내
              RA_2 TYPE C RADIOBUTTON GROUP RA1,                   " 15일 이내
              RA_3 TYPE C RADIOBUTTON GROUP RA1 DEFAULT 'X',       " 30일 이내
              RA_4 TYPE C RADIOBUTTON GROUP RA1.                   " 전체조회
  SELECTION-SCREEN END OF BLOCK B02.
