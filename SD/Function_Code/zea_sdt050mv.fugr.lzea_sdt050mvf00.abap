*---------------------------------------------------------------------*
*    view related FORM routines
*---------------------------------------------------------------------*
*...processing: ZEA_SDT050MV....................................*
FORM GET_DATA_ZEA_SDT050MV.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZEA_SDT050 WHERE
(VIM_WHERETAB) .
    CLEAR ZEA_SDT050MV .
ZEA_SDT050MV-MANDT =
ZEA_SDT050-MANDT .
ZEA_SDT050MV-VBELN =
ZEA_SDT050-VBELN .
ZEA_SDT050MV-POSNR =
ZEA_SDT050-POSNR .
ZEA_SDT050MV-MATNR =
ZEA_SDT050-MATNR .
ZEA_SDT050MV-AUQUA =
ZEA_SDT050-AUQUA .
ZEA_SDT050MV-MEINS =
ZEA_SDT050-MEINS .
ZEA_SDT050MV-NETPR =
ZEA_SDT050-NETPR .
ZEA_SDT050MV-AUAMO =
ZEA_SDT050-AUAMO .
ZEA_SDT050MV-WAERS =
ZEA_SDT050-WAERS .
ZEA_SDT050MV-STATUS =
ZEA_SDT050-STATUS .
ZEA_SDT050MV-ERNAM =
ZEA_SDT050-ERNAM .
ZEA_SDT050MV-ERDAT =
ZEA_SDT050-ERDAT .
ZEA_SDT050MV-ERZET =
ZEA_SDT050-ERZET .
ZEA_SDT050MV-AENAM =
ZEA_SDT050-AENAM .
ZEA_SDT050MV-AEDAT =
ZEA_SDT050-AEDAT .
ZEA_SDT050MV-AEZET =
ZEA_SDT050-AEZET .
<VIM_TOTAL_STRUC> = ZEA_SDT050MV.
    APPEND TOTAL.
  ENDSELECT.
  SORT TOTAL BY <VIM_XTOTAL_KEY>.
  <STATUS>-ALR_SORTED = 'R'.
*.check dynamic selectoptions (not in DDIC)...........................*
  IF X_HEADER-SELECTION NE SPACE.
    PERFORM CHECK_DYNAMIC_SELECT_OPTIONS.
  ELSEIF X_HEADER-DELMDTFLAG NE SPACE.
    PERFORM BUILD_MAINKEY_TAB.
  ENDIF.
  REFRESH EXTRACT.
ENDFORM.
*---------------------------------------------------------------------*
FORM DB_UPD_ZEA_SDT050MV .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZEA_SDT050MV.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZEA_SDT050MV-ST_DELETE EQ GELOESCHT.
     READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
     IF SY-SUBRC EQ 0.
       DELETE EXTRACT INDEX SY-TABIX.
     ENDIF.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN GELOESCHT.
  SELECT SINGLE FOR UPDATE * FROM ZEA_SDT050 WHERE
  VBELN = ZEA_SDT050MV-VBELN AND
  POSNR = ZEA_SDT050MV-POSNR .
    IF SY-SUBRC = 0.
    DELETE ZEA_SDT050 .
    ENDIF.
    IF STATUS-DELETE EQ GELOESCHT.
      READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY> BINARY SEARCH.
      DELETE EXTRACT INDEX SY-TABIX.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN OTHERS.
  SELECT SINGLE FOR UPDATE * FROM ZEA_SDT050 WHERE
  VBELN = ZEA_SDT050MV-VBELN AND
  POSNR = ZEA_SDT050MV-POSNR .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZEA_SDT050.
    ENDIF.
ZEA_SDT050-MANDT =
ZEA_SDT050MV-MANDT .
ZEA_SDT050-VBELN =
ZEA_SDT050MV-VBELN .
ZEA_SDT050-POSNR =
ZEA_SDT050MV-POSNR .
ZEA_SDT050-MATNR =
ZEA_SDT050MV-MATNR .
ZEA_SDT050-AUQUA =
ZEA_SDT050MV-AUQUA .
ZEA_SDT050-MEINS =
ZEA_SDT050MV-MEINS .
ZEA_SDT050-NETPR =
ZEA_SDT050MV-NETPR .
ZEA_SDT050-AUAMO =
ZEA_SDT050MV-AUAMO .
ZEA_SDT050-WAERS =
ZEA_SDT050MV-WAERS .
ZEA_SDT050-STATUS =
ZEA_SDT050MV-STATUS .
ZEA_SDT050-ERNAM =
ZEA_SDT050MV-ERNAM .
ZEA_SDT050-ERDAT =
ZEA_SDT050MV-ERDAT .
ZEA_SDT050-ERZET =
ZEA_SDT050MV-ERZET .
ZEA_SDT050-AENAM =
ZEA_SDT050MV-AENAM .
ZEA_SDT050-AEDAT =
ZEA_SDT050MV-AEDAT .
ZEA_SDT050-AEZET =
ZEA_SDT050MV-AEZET .
    IF SY-SUBRC = 0.
    UPDATE ZEA_SDT050 ##WARN_OK.
    ELSE.
    INSERT ZEA_SDT050 .
    ENDIF.
    READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
    IF SY-SUBRC EQ 0.
      <XACT> = ORIGINAL.
      MODIFY EXTRACT INDEX SY-TABIX.
    ENDIF.
    <ACTION> = ORIGINAL.
    MODIFY TOTAL.
  ENDCASE.
ENDLOOP.
CLEAR: STATUS_ZEA_SDT050MV-UPD_FLAG,
STATUS_ZEA_SDT050MV-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ZEA_SDT050MV.
  SELECT SINGLE * FROM ZEA_SDT050 WHERE
VBELN = ZEA_SDT050MV-VBELN AND
POSNR = ZEA_SDT050MV-POSNR .
ZEA_SDT050MV-MANDT =
ZEA_SDT050-MANDT .
ZEA_SDT050MV-VBELN =
ZEA_SDT050-VBELN .
ZEA_SDT050MV-POSNR =
ZEA_SDT050-POSNR .
ZEA_SDT050MV-MATNR =
ZEA_SDT050-MATNR .
ZEA_SDT050MV-AUQUA =
ZEA_SDT050-AUQUA .
ZEA_SDT050MV-MEINS =
ZEA_SDT050-MEINS .
ZEA_SDT050MV-NETPR =
ZEA_SDT050-NETPR .
ZEA_SDT050MV-AUAMO =
ZEA_SDT050-AUAMO .
ZEA_SDT050MV-WAERS =
ZEA_SDT050-WAERS .
ZEA_SDT050MV-STATUS =
ZEA_SDT050-STATUS .
ZEA_SDT050MV-ERNAM =
ZEA_SDT050-ERNAM .
ZEA_SDT050MV-ERDAT =
ZEA_SDT050-ERDAT .
ZEA_SDT050MV-ERZET =
ZEA_SDT050-ERZET .
ZEA_SDT050MV-AENAM =
ZEA_SDT050-AENAM .
ZEA_SDT050MV-AEDAT =
ZEA_SDT050-AEDAT .
ZEA_SDT050MV-AEZET =
ZEA_SDT050-AEZET .
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZEA_SDT050MV USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZEA_SDT050MV-VBELN TO
ZEA_SDT050-VBELN .
MOVE ZEA_SDT050MV-POSNR TO
ZEA_SDT050-POSNR .
MOVE ZEA_SDT050MV-MANDT TO
ZEA_SDT050-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZEA_SDT050'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZEA_SDT050 TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZEA_SDT050'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*
