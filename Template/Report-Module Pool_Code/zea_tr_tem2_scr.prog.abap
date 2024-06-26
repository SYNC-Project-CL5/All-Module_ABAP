*&---------------------------------------------------------------------*
*& Include          ZEA_TR_TEM2_SCR
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-t01.
  SELECT-OPTIONS : so_carr FOR sflight-carrid,
                   so_conn FOR sflight-connid.
SELECTION-SCREEN END OF BLOCK bl1.
