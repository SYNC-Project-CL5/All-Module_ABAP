*---------------------------------------------------------------------*
*    view related FORM routines
*---------------------------------------------------------------------*
*...processing: ZEA_MMV040......................................*
FORM GET_DATA_ZEA_MMV040.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZEA_MMT040 WHERE
(VIM_WHERETAB) .
    CLEAR ZEA_MMV040 .
ZEA_MMV040-MANDT =
ZEA_MMT040-MANDT .
ZEA_MMV040-MATNR =
ZEA_MMT040-MATNR .
ZEA_MMV040-INFO_NO =
ZEA_MMT040-INFO_NO .
ZEA_MMV040-USEYN =
ZEA_MMT040-USEYN .
ZEA_MMV040-ERNAM =
ZEA_MMT040-ERNAM .
ZEA_MMV040-ERDAT =
ZEA_MMT040-ERDAT .
ZEA_MMV040-ERZET =
ZEA_MMT040-ERZET .
ZEA_MMV040-AENAM =
ZEA_MMT040-AENAM .
ZEA_MMV040-AEDAT =
ZEA_MMT040-AEDAT .
ZEA_MMV040-AEZET =
ZEA_MMT040-AEZET .
    SELECT * FROM ZEA_MMT050 WHERE
INFO_NO = ZEA_MMT040-INFO_NO .
      EXIT.
    ENDSELECT.
<VIM_TOTAL_STRUC> = ZEA_MMV040.
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
FORM DB_UPD_ZEA_MMV040 .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZEA_MMV040.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZEA_MMV040-ST_DELETE EQ GELOESCHT.
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
  SELECT SINGLE FOR UPDATE * FROM ZEA_MMT040 WHERE
  MATNR = ZEA_MMV040-MATNR AND
  INFO_NO = ZEA_MMV040-INFO_NO .
    IF SY-SUBRC = 0.
    DELETE ZEA_MMT040 .
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
  SELECT SINGLE FOR UPDATE * FROM ZEA_MMT040 WHERE
  MATNR = ZEA_MMV040-MATNR AND
  INFO_NO = ZEA_MMV040-INFO_NO .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZEA_MMT040.
    ENDIF.
ZEA_MMT040-MANDT =
ZEA_MMV040-MANDT .
ZEA_MMT040-MATNR =
ZEA_MMV040-MATNR .
ZEA_MMT040-INFO_NO =
ZEA_MMV040-INFO_NO .
ZEA_MMT040-USEYN =
ZEA_MMV040-USEYN .
ZEA_MMT040-ERNAM =
ZEA_MMV040-ERNAM .
ZEA_MMT040-ERDAT =
ZEA_MMV040-ERDAT .
ZEA_MMT040-ERZET =
ZEA_MMV040-ERZET .
ZEA_MMT040-AENAM =
ZEA_MMV040-AENAM .
ZEA_MMT040-AEDAT =
ZEA_MMV040-AEDAT .
ZEA_MMT040-AEZET =
ZEA_MMV040-AEZET .
    IF SY-SUBRC = 0.
    UPDATE ZEA_MMT040 ##WARN_OK.
    ELSE.
    INSERT ZEA_MMT040 .
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
CLEAR: STATUS_ZEA_MMV040-UPD_FLAG,
STATUS_ZEA_MMV040-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ENTRY_ZEA_MMV040.
  SELECT SINGLE * FROM ZEA_MMT040 WHERE
MATNR = ZEA_MMV040-MATNR AND
INFO_NO = ZEA_MMV040-INFO_NO .
ZEA_MMV040-MANDT =
ZEA_MMT040-MANDT .
ZEA_MMV040-MATNR =
ZEA_MMT040-MATNR .
ZEA_MMV040-INFO_NO =
ZEA_MMT040-INFO_NO .
ZEA_MMV040-USEYN =
ZEA_MMT040-USEYN .
ZEA_MMV040-ERNAM =
ZEA_MMT040-ERNAM .
ZEA_MMV040-ERDAT =
ZEA_MMT040-ERDAT .
ZEA_MMV040-ERZET =
ZEA_MMT040-ERZET .
ZEA_MMV040-AENAM =
ZEA_MMT040-AENAM .
ZEA_MMV040-AEDAT =
ZEA_MMT040-AEDAT .
ZEA_MMV040-AEZET =
ZEA_MMT040-AEZET .
    SELECT * FROM ZEA_MMT050 WHERE
INFO_NO = ZEA_MMT040-INFO_NO .
      EXIT.
    ENDSELECT.
    IF SY-SUBRC NE 0.
      CLEAR SY-SUBRC.
    ENDIF.
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZEA_MMV040 USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZEA_MMV040-MATNR TO
ZEA_MMT040-MATNR .
MOVE ZEA_MMV040-INFO_NO TO
ZEA_MMT040-INFO_NO .
MOVE ZEA_MMV040-MANDT TO
ZEA_MMT040-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZEA_MMT040'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZEA_MMT040 TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZEA_MMT040'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*
FORM COMPL_ZEA_MMV040 USING WORKAREA.
*      provides (read-only) fields from secondary tables related
*      to primary tables by foreignkey relationships
ZEA_MMT040-MANDT =
ZEA_MMV040-MANDT .
ZEA_MMT040-MATNR =
ZEA_MMV040-MATNR .
ZEA_MMT040-INFO_NO =
ZEA_MMV040-INFO_NO .
ZEA_MMT040-USEYN =
ZEA_MMV040-USEYN .
ZEA_MMT040-ERNAM =
ZEA_MMV040-ERNAM .
ZEA_MMT040-ERDAT =
ZEA_MMV040-ERDAT .
ZEA_MMT040-ERZET =
ZEA_MMV040-ERZET .
ZEA_MMT040-AENAM =
ZEA_MMV040-AENAM .
ZEA_MMT040-AEDAT =
ZEA_MMV040-AEDAT .
ZEA_MMT040-AEZET =
ZEA_MMV040-AEZET .
    SELECT * FROM ZEA_MMT050 WHERE
INFO_NO = ZEA_MMT040-INFO_NO .
      EXIT.
    ENDSELECT.
    IF SY-SUBRC NE 0.
      CLEAR SY-SUBRC.
    ENDIF.
ENDFORM.