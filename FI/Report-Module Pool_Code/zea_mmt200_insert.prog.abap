*&---------------------------------------------------------------------*
*& Report ZEA_MMT200_INSERT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEA_MMT200_INSERT.

TABLES ZEA_MMT200.

DATA : GS_MMT200 TYPE ZEA_MMT200,
       GT_MMT200 TYPE TABLE OF ZEA_MMT200.

DO 5 TIMES.
GS_MMT200-MOVID = 'MV' && '1239'.
GS_MMT200-BOOKID = 'PY' && '1239'.
GS_MMT200-ELCDT = SY-DATUM.
GS_MMT200-MATNR = '30000000'.
GS_MMT200-CHARG = '80000019'.
GS_MMT200-PLANTFR = '10003'.
GS_MMT200-PLANTTO = '10006'.
GS_MMT200-LGORTFR = 'SL04'.
GS_MMT200-LGORTTO = 'SL07'.
GS_MMT200-DMBTR = 30000.
GS_MMT200-WAERS1 = 'KRW'.
GS_MMT200-MENGE = '2'.
GS_MMT200-MEINS = 'PKG'.
GS_MMT200-STATUS = ' '.
GS_MMT200-GRUND = 'TEST5'.

GS_MMT200-ERNAM  = SY-UNAME.
GS_MMT200-ERDAT  = SY-DATUM.
GS_MMT200-ERZET  = SY-UZEIT.

* APPEND GS_MMT200 TO GT_MMT200.
 MODIFY ZEA_MMT200 FROM GS_MMT200.
ENDDO.
 IF SY-SUBRC EQ 0.
    COMMIT WORK AND WAIT .
    MESSAGE '성공' TYPE 'S'.
  ELSE.
    MESSAGE '에러' TYPE 'E'.

   ENDIF.
