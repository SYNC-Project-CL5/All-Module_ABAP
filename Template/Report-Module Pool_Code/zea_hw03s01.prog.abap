*&---------------------------------------------------------------------*
*& Include          ZMEETROOMS01
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK pa1 WITH FRAME TITLE TEXT-t01.
  SELECT-OPTIONS so_resdt FOR ztmeetroom-rsv_date OBLIGATORY.
  PARAMETERS : pa_group AS LISTBOX VISIBLE LENGTH 17 OBLIGATORY
                           USER-COMMAND pa_group DEFAULT 'A'.
SELECTION-SCREEN END OF BLOCK pa1.
