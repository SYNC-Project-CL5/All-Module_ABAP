*&---------------------------------------------------------------------*
*& Include          ZEA_GW_TES_F02
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form GET_DROPDOWN : 미사용
*&---------------------------------------------------------------------*
FORM GET_DROPDOWN .

  DATA : LT_DROPLIST TYPE VRM_VALUES.

  SELECT MATNR AS KEY,
         MAKTX AS TEXT "&& '(' && MATNR && ')' AS TEXT
    FROM ZEA_MMT020
    INTO TABLE @LT_DROPLIST
    WHERE SPRAS EQ @SY-LANGU
      AND MATNR GE '30000000'
    ORDER BY KEY ASCENDING.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      ID     = 'PA_MATNR'    " TOP에서 선언했던 Parameter ListBox "
      VALUES = LT_DROPLIST.  " LT_DROPLIST( Listbox Data ) "


ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_DATA
*&---------------------------------------------------------------------*
FORM SELECT_DATA .

*  " 생산 실적 조회 (DISPLAY)
*  SELECT FROM ZEA_AFRU AS A
*         JOIN ZEA_MMT020 AS B
*           ON B~MATNR EQ A~MATNR
*       FIELDS *
*        WHERE A~MATNR IN @SO_MATNR
*          AND A~TSDAT IN @SO_TSDAT
*         INTO CORRESPONDING FIELDS OF TABLE @GT_DISPLAY.

  REFRESH GT_HEADER.

  " 노드 구성 요소 조회
  SELECT FROM ZEA_MMT190 AS A
    JOIN ZEA_MMT020 AS B
      ON B~MATNR EQ A~MATNR
    JOIN ZEA_T001W AS C
      ON C~WERKS EQ A~WERKS
    JOIN ZEA_MMT060 AS D
      ON D~WERKS EQ A~WERKS
  FIELDS C~BUKRS, A~WERKS, C~PNAME1, A~SCODE,
         D~SNAME, A~MATNR, B~MAKTX
    WHERE A~MATNR GE '30000000'
         INTO CORRESPONDING FIELDS OF TABLE @GT_HEADER.


  " CDC 재고를 위한 조회 (DISPLAY2)
  SELECT FROM ZEA_MMT190 AS A
         JOIN ZEA_MMT020 AS B
           ON B~MATNR EQ A~MATNR
         JOIN ZEA_T001W AS C
           ON C~WERKS EQ A~WERKS
         JOIN ZEA_MMT060 AS D
           ON D~WERKS EQ A~WERKS
*          AND D~WERKS EQ C~WERKS
*          AND D~SCODE EQ A~SCODE
        FIELDS *
        WHERE A~WERKS EQ '10000'
         INTO CORRESPONDING FIELDS OF TABLE @GT_DATA2.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM MAKE_DISPLAY_DATA .

**-- DISPLAY 구성 : 생산 실적
*  REFRESH GT_DISPLAY.
*
*  LOOP AT GT_DATA INTO GS_DATA.
*
*    CLEAR GS_DISPLAY.
*
*    MOVE-CORRESPONDING GS_DATA TO GS_DISPLAY.
*
**신규 필드------------------------------------------------------------*
*
**    CASE GS_DISPLAY-MATTYPE.
**      WHEN '반제품'.
**        CLEAR GS_FIELD_COLOR.
**        GS_FIELD_COLOR-FNAME = 'MATTYPE'.
**        GS_FIELD_COLOR-COLOR-COL = 5. " 초록
**        GS_FIELD_COLOR-COLOR-INT = 0.
**        GS_FIELD_COLOR-COLOR-INV = 0.
**        APPEND GS_FIELD_COLOR TO GS_DISPLAY-IT_FIELD_COLORS.
**      WHEN '완제품'.
**        CLEAR GS_FIELD_COLOR.
**        GS_FIELD_COLOR-FNAME = 'MATTYPE'.
**        GS_FIELD_COLOR-COLOR-COL = 1. " 파랑
**        GS_FIELD_COLOR-COLOR-INT = 0.
**        GS_FIELD_COLOR-COLOR-INV = 0.
**        APPEND GS_FIELD_COLOR TO GS_DISPLAY-IT_FIELD_COLORS.
**    ENDCASE.
*
**--------------------------------------------------------------------*
*    APPEND GS_DISPLAY TO GT_DISPLAY.
*
*  ENDLOOP.
*
*  DESCRIBE TABLE GT_DISPLAY LINES GV_LINES.
*
*  IF GT_DISPLAY IS INITIAL.
*    MESSAGE S013 DISPLAY LIKE 'W'.
*  ELSE.
*    MESSAGE S006 WITH GV_LINES.
*  ENDIF.

*-- DISPLAY2 구성 : CDC
  REFRESH GT_DISPLAY2.

  LOOP AT GT_DATA2 INTO GS_DATA2.

    CLEAR GS_DISPLAY2.

    MOVE-CORRESPONDING GS_DATA2 TO GS_DISPLAY2.

*신규 필드------------------------------------------------------------*
*--------------------------------------------------------------------*
    APPEND GS_DISPLAY2 TO GT_DISPLAY2.

  ENDLOOP.

  DESCRIBE TABLE GT_DISPLAY2 LINES GV_LINES.

  IF GT_DISPLAY2 IS INITIAL.
    MESSAGE S013 DISPLAY LIKE 'W'.
  ELSE.
*    MESSAGE S006 WITH GV_LINES.
  ENDIF.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM DISPLAY_DATA .

*  DESCRIBE TABLE GT_DISPLAY LINES GV_LINES.
*
*  IF GT_DISPLAY IS INITIAL.
*    MESSAGE S013 DISPLAY LIKE 'W'.
*  ELSE.
*    MESSAGE S006 WITH GV_LINES.
*  ENDIF.

  CHECK SY-UNAME EQ 'ACA5-03'
     OR SY-UNAME EQ 'ACA5-07'
     OR SY-UNAME EQ 'ACA5-08'
     OR SY-UNAME EQ 'ACA5-10'
     OR SY-UNAME EQ 'ACA5-12'
     OR SY-UNAME EQ 'ACA5-15'
     OR SY-UNAME EQ 'ACA5-17'
     OR SY-UNAME EQ 'ACA5-23'
     OR SY-UNAME EQ 'ACA-05'.

  CALL SCREEN 0100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MOVE_DATA_CDC_TO_RDC
*&---------------------------------------------------------------------*
FORM MOVE_DATA_CDC_TO_RDC .

*  DATA LT_INDEX_ROWS TYPE LVC_T_ROW.
*  DATA LS_INDEX_ROW  TYPE LVC_S_ROW.
*
*  CALL METHOD GO_ALV_GRID_2->GET_SELECTED_ROWS
*    IMPORTING
*      ET_INDEX_ROWS = LT_INDEX_ROWS.
*
*  IF LT_INDEX_ROWS[] IS INITIAL.
*
*    " 최소 한 행이상 선택하세요
*    MESSAGE S003 DISPLAY LIKE 'W'.
*
*  ELSE.
*
*    " 300번 스크린 호출
*    CALL SCREEN 0300 STARTING AT 30 5.
*
*
*    READ TABLE LT_INDEX_ROWS INTO LS_INDEX_ROW INDEX 1.
*    READ TABLE GT_DISPLAY2   INTO GS_DISPLAY2  INDEX LS_INDEX_ROW-INDEX.
*
*    APPEND GS_DISPLAY2 TO GT_DISPLAY3.
*    DELETE GT_DISPLAY2 INDEX LS_INDEX_ROW-INDEX.
*
*
*    GO_ALV_GRID_1->REFRESH_TABLE_DISPLAY( ).
*    GO_ALV_GRID_2->REFRESH_TABLE_DISPLAY( ).
**    PERFORM REFRESH_ALV_0100_GRID_2_3.
*  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_HOTSPOT_CLICK
*&---------------------------------------------------------------------*
FORM HANDLE_HOTSPOT_CLICK USING PS_ROW    TYPE LVC_S_ROW
                                PS_COLUMN TYPE LVC_S_COL
                                PO_SENDER TYPE REF TO CL_GUI_ALV_GRID.

  CLEAR GS_DISPLAY.
  REFRESH GT_DISPLAY3.

  READ TABLE GT_DISPLAY INTO GS_DISPLAY INDEX PS_ROW-INDEX.

  ZEA_MMT070-MATNR = GS_DISPLAY-MATNR.
  ZEA_MMT020-MAKTX = GS_DISPLAY-MAKTX.
  ZEA_MMT070-WERKS = GS_DISPLAY-WERKS.
  ZEA_T001W-PNAME1 = GS_DISPLAY-PNAME1.

  SELECT FROM ZEA_MMT070 AS A
         JOIN ZEA_MMT020 AS B  ON B~MATNR EQ A~MATNR
         JOIN ZEA_T001W  AS C  ON C~WERKS EQ A~WERKS
       FIELDS *
        WHERE A~MATNR EQ @GS_DISPLAY-MATNR
          AND A~WERKS EQ @GS_DISPLAY-WERKS
         INTO CORRESPONDING FIELDS OF TABLE @GT_DISPLAY3.


*
*  ZEA_AUFK-AUFNR       = GS_DISPLAY4-AUFNR.
*  ZEA_AUFK-PLANID      = GS_DISPLAY4-PLANID.
*  ZEA_AUFK-WERKS       = GS_DISPLAY4-WERKS.
*  ZEA_T001W-PNAME1     = GS_DISPLAY4-PNAME1.
*  ZEA_AUFK-MATNR       = GS_DISPLAY4-MATNR.
*  ZEA_MMT020-MAKTX     = GS_DISPLAY4-MAKTX.
*  ZEA_AUFK-TOT_QTY     = GS_DISPLAY4-TOT_QTY.
*  ZEA_AUFK-MEINS       = GS_DISPLAY4-MEINS.
*  ZEA_AUFK-APPROVER    = GS_DISPLAY4-APPROVER.
*  ZEA_PPT020-SDATE     = GS_DISPLAY4-SDATE.
*  ZEA_PPT020-EDATE     = GS_DISPLAY4-EDATE.
*  ZEA_PPT020-ISPDATE   = GS_DISPLAY4-ISPDATE.

  CALL SCREEN 0400 STARTING AT 30 5.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_NODE_DOUBLE_CLICK
*&---------------------------------------------------------------------*
FORM HANDLE_NODE_DOUBLE_CLICK   USING PV_NODE_KEY TYPE MTREESNODE-NODE_KEY
                                     PV_SENDER   TYPE REF TO CL_GUI_SIMPLE_TREE.

  IF GO_ALV_GRID IS INITIAL.
    " 출력할 ALV가 없습니다.
    MESSAGE S000 DISPLAY LIKE 'E' WITH TEXT-E01.
    EXIT.
  ENDIF.

  READ TABLE GT_NODE_INFO INTO GS_NODE_INFO
                          WITH KEY NODE_KEY = PV_NODE_KEY
                                   BINARY SEARCH.

  CHECK SY-SUBRC EQ 0.

  RANGES: R_BUKRS FOR GS_NODE_INFO-BUKRS,
          R_WERKS FOR GS_NODE_INFO-WERKS,
          R_SCODE FOR GS_NODE_INFO-SCODE,
          R_MATNR FOR GS_NODE_INFO-MATNR.

  IF GS_NODE_INFO-BUKRS IS NOT INITIAL.
    R_BUKRS-SIGN = 'I'.
    R_BUKRS-OPTION = 'EQ'.
    R_BUKRS-LOW = GS_NODE_INFO-BUKRS.
    APPEND R_BUKRS.
  ENDIF.

  IF GS_NODE_INFO-WERKS IS NOT INITIAL.
    R_WERKS-SIGN = 'I'.
    R_WERKS-OPTION = 'EQ'.
    R_WERKS-LOW = GS_NODE_INFO-WERKS.
    APPEND R_WERKS.
  ENDIF.

  IF GS_NODE_INFO-SCODE IS NOT INITIAL.
    R_SCODE-SIGN = 'I'.
    R_SCODE-OPTION = 'EQ'.
    R_SCODE-LOW = GS_NODE_INFO-SCODE.
    APPEND R_SCODE.
  ENDIF.

  IF GS_NODE_INFO-MATNR IS NOT INITIAL.
    R_MATNR-SIGN = 'I'.
    R_MATNR-OPTION = 'EQ'.
    R_MATNR-LOW = GS_NODE_INFO-MATNR.
    APPEND R_MATNR.
  ENDIF.

  SELECT FROM ZEA_MMT190  AS A
         JOIN ZEA_MMT020  AS B ON B~MATNR EQ A~MATNR
         JOIN ZEA_T001W   AS C ON C~WERKS EQ A~WERKS
         JOIN ZEA_MMT060  AS D ON D~WERKS EQ A~WERKS

       FIELDS *
        WHERE C~BUKRS       IN @R_BUKRS
          AND A~WERKS       IN @R_WERKS
          AND A~SCODE       IN @R_SCODE
          AND A~MATNR       IN @R_MATNR
          AND A~MATNR GE '30000000'
       INTO CORRESPONDING FIELDS OF TABLE @GT_DISPLAY.


  SORT GT_DISPLAY BY MATNR WERKS SCODE.

  CLEAR GS_DISPLAY.
  READ TABLE GT_DISPLAY INTO GS_DISPLAY INDEX 1.

  IF R_MATNR IS NOT INITIAL.

    GV_PNAME1  = GS_DISPLAY-PNAME1. " 플랜트명
    GV_SNAME   = GS_DISPLAY-SNAME.  " 저장위치명
    GV_MAKTX   = GS_DISPLAY-MAKTX.  " 자재명
    GV_CALQTY  = GS_DISPLAY-CALQTY. " 수량
    GV_MEINS   = GS_DISPLAY-MEINS.  " 단위
    GV_WEIGHT  = GS_DISPLAY-WEIGHT.  " 무게
    GV_MEINS2  = GS_DISPLAY-MEINS2.  " 단위

  ELSEIF R_SCODE IS NOT INITIAL AND R_MATNR IS INITIAL.
    CLEAR GV_PNAME1.
    CLEAR GV_SNAME.
    CLEAR GV_MAKTX.
    CLEAR GV_CALQTY.
    CLEAR GV_MEINS.
    GV_PNAME1  = GS_DISPLAY-PNAME1. " 플랜트명
    GV_SNAME   = GS_DISPLAY-SNAME.  " 저장위치명

  ELSEIF R_WERKS IS NOT INITIAL AND R_SCODE IS INITIAL AND R_MATNR IS INITIAL.
    CLEAR GV_PNAME1.
    CLEAR GV_SNAME.
    CLEAR GV_MAKTX.
    CLEAR GV_CALQTY.
    CLEAR GV_MEINS.
    GV_PNAME1  = GS_DISPLAY-PNAME1. " 플랜트명
  ELSEIF R_WERKS IS INITIAL AND R_SCODE IS INITIAL AND R_MATNR IS INITIAL.
    CLEAR GV_PNAME1.
    CLEAR GV_SNAME.
    CLEAR GV_MAKTX.
    CLEAR GV_CALQTY.
    CLEAR GV_MEINS.
  ENDIF.

  DESCRIBE TABLE GT_DISPLAY LINES GV_LINES.

  IF GT_DISPLAY IS INITIAL.
    MESSAGE S013 DISPLAY LIKE 'W'.
  ELSE.
    MESSAGE S091 WITH GV_LINES.
  ENDIF.


  GO_ALV_GRID->REFRESH_TABLE_DISPLAY(
    EXCEPTIONS
      FINISHED       = 1                " Display was Ended (by Export)
      OTHERS         = 2
  ).

  LEAVE SCREEN.

**  CALL FUNCTION 'SAPGUI_SET_FUNCTIONCODE'
**    EXPORTING
**      FUNCTIONCODE           = 'ENTE'
**    EXCEPTIONS
**      FUNCTION_NOT_SUPPORTED = 1
**      OTHERS                 = 2.
**
**
**  IF SY-SUBRC <> 0.
**    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**      WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
**  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_DATA_LISTBOX
*&---------------------------------------------------------------------*
FORM SELECT_DATA_LISTBOX .

  SELECT MATNR MAKTX
    FROM ZEA_MMT020
    INTO CORRESPONDING FIELDS OF TABLE GT_LIST
    WHERE MATNR BETWEEN '300000' AND '300023'
      AND SPRAS EQ SY-LANGU.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form TRANSPORT_TIRE
*&---------------------------------------------------------------------*
FORM TRANSPORT_TIRE .

  CLEAR ZEA_MMT100-PLANTTO.
  CLEAR ZEA_T001W-PNAME1.
  CLEAR ZEA_MMT100-LGORTTO.

  CASE OK_CODE.
    WHEN 'BTN_TRANS1'.
      ZEA_MMT100-PLANTFR = '10002'.
      ZEA_T001W-PNAME1   = '구로직영점'.
      ZEA_MMT100-LGORTFR = 'SL03'.
      ZEA_MMT100-MATNR = GV_LIST1.

      PERFORM SELECT_MAKTX USING GV_LIST1.

    WHEN 'BTN_TRANS2'.
      ZEA_MMT100-PLANTFR = '10003'.
      ZEA_T001W-PNAME1   = '평택직영점'.
      ZEA_MMT100-LGORTFR = 'SL04'.
      ZEA_MMT100-MATNR = GV_LIST2.

      PERFORM SELECT_MAKTX USING GV_LIST2.

    WHEN 'BTN_TRANS3'.
      ZEA_MMT100-PLANTFR = '10004'.
      ZEA_T001W-PNAME1   = '종로직영점'.
      ZEA_MMT100-LGORTFR = 'SL05'.
      ZEA_MMT100-MATNR = GV_LIST3.

      PERFORM SELECT_MAKTX USING GV_LIST3.

    WHEN 'BTN_TRANS4' .
      ZEA_MMT100-PLANTFR = '10005'.
      ZEA_T001W-PNAME1   = '인천직영점'.
      ZEA_MMT100-LGORTFR = 'SL06'.
      ZEA_MMT100-MATNR = GV_LIST4.

      PERFORM SELECT_MAKTX USING GV_LIST4.

    WHEN 'BTN_TRANS5' .
      ZEA_MMT100-PLANTFR = '10006'.
      ZEA_T001W-PNAME1   = '오산직영점'.
      ZEA_MMT100-LGORTFR = 'SL07'.
      ZEA_MMT100-MATNR = GV_LIST5.

      PERFORM SELECT_MAKTX USING GV_LIST5.

    WHEN 'BTN_TRANS6' .
      ZEA_MMT100-PLANTFR = '10007'.
      ZEA_T001W-PNAME1   = '대구직영점'.
      ZEA_MMT100-LGORTFR = 'SL08'.
      ZEA_MMT100-MATNR = GV_LIST6.

      PERFORM SELECT_MAKTX USING GV_LIST6.

    WHEN 'BTN_TRANS7' .
      ZEA_MMT100-PLANTFR = '10008'.
      ZEA_T001W-PNAME1   = '대전직영점'.
      ZEA_MMT100-LGORTFR = 'SL09'.
      ZEA_MMT100-MATNR = GV_LIST7.

      PERFORM SELECT_MAKTX USING GV_LIST7.

    WHEN 'BTN_TRANS8' .
      ZEA_MMT100-PLANTFR = '10009'.
      ZEA_T001W-PNAME1   = '부천직영점'.
      ZEA_MMT100-LGORTFR = 'SL10'.
      ZEA_MMT100-MATNR = GV_LIST8.

      PERFORM SELECT_MAKTX USING GV_LIST8.

    WHEN 'BTN_TRANS9' .
      ZEA_MMT100-PLANTFR = '10000'.
      ZEA_T001W-PNAME1   = 'CDC'.
      ZEA_MMT100-LGORTFR = 'SL01'.
      ZEA_MMT100-MATNR = GV_LIST9.

      PERFORM SELECT_MAKTX USING GV_LIST9.

    WHEN 'BTN_TRANS10' .
      ZEA_MMT100-PLANTFR = '10001'.
      ZEA_T001W-PNAME1   = 'RDC'.
      ZEA_MMT100-LGORTFR = 'SL02'.
      ZEA_MMT100-MATNR = GV_LIST10.

      PERFORM SELECT_MAKTX USING GV_LIST10.

    WHEN OTHERS.
  ENDCASE.


  PERFORM MOVE_INFO.


  " 300번 스크린 호출
  CALL SCREEN 0300 STARTING AT 30 3.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MOVE_DATA
*&---------------------------------------------------------------------*
FORM MOVE_DATA .





ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_DATA_0300
*&---------------------------------------------------------------------*
FORM SELECT_DATA_0300 .


  CASE OK_CODE.

    WHEN 'BTN_TRANS1'.

      SELECT FROM ZEA_MMT070
           FIELDS *
            WHERE MATNR EQ @GV_LIST1
              AND WERKS EQ '10002'
             INTO CORRESPONDING FIELDS OF TABLE @GT_DISPLAY5.

    WHEN 'BTN_TRANS2'.

      SELECT FROM ZEA_MMT070
           FIELDS *
            WHERE MATNR EQ @GV_LIST2
              AND WERKS EQ '10003'
             INTO CORRESPONDING FIELDS OF TABLE @GT_DISPLAY5.

    WHEN 'BTN_TRANS3'.

      SELECT FROM ZEA_MMT070
           FIELDS *
            WHERE MATNR EQ @GV_LIST3
              AND WERKS EQ '10004'
             INTO CORRESPONDING FIELDS OF TABLE @GT_DISPLAY5.

    WHEN 'BTN_TRANS4'.

      SELECT FROM ZEA_MMT070
           FIELDS *
            WHERE MATNR EQ @GV_LIST4
              AND WERKS EQ '10005'
             INTO CORRESPONDING FIELDS OF TABLE @GT_DISPLAY5.

    WHEN 'BTN_TRANS5'.

      SELECT FROM ZEA_MMT070
           FIELDS *
            WHERE MATNR EQ @GV_LIST5
              AND WERKS EQ '10006'
             INTO CORRESPONDING FIELDS OF TABLE @GT_DISPLAY5.

    WHEN 'BTN_TRANS6'.

      SELECT FROM ZEA_MMT070
           FIELDS *
            WHERE MATNR EQ @GV_LIST6
              AND WERKS EQ '10007'
             INTO CORRESPONDING FIELDS OF TABLE @GT_DISPLAY5.

    WHEN 'BTN_TRANS7'.

      SELECT FROM ZEA_MMT070
           FIELDS *
            WHERE MATNR EQ @GV_LIST7
              AND WERKS EQ '10008'
             INTO CORRESPONDING FIELDS OF TABLE @GT_DISPLAY5.

    WHEN 'BTN_TRANS8'.

      SELECT FROM ZEA_MMT070
           FIELDS *
            WHERE MATNR EQ @GV_LIST8
              AND WERKS EQ '10009'
             INTO CORRESPONDING FIELDS OF TABLE @GT_DISPLAY5.

    WHEN 'BTN_TRANS9'.

      SELECT FROM ZEA_MMT070
           FIELDS *
            WHERE MATNR EQ @GV_LIST9
              AND WERKS EQ '10000'
             INTO CORRESPONDING FIELDS OF TABLE @GT_DISPLAY5.

    WHEN 'BTN_TRANS10'.

      SELECT FROM ZEA_MMT070
           FIELDS *
            WHERE MATNR EQ @GV_LIST10
              AND WERKS EQ '10001'
             INTO CORRESPONDING FIELDS OF TABLE @GT_DISPLAY5.


  ENDCASE.




ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_DOUBLE_CLICK
*&---------------------------------------------------------------------*
FORM HANDLE_DOUBLE_CLICK   USING PS_ROW    TYPE LVC_S_ROW
                                PS_COLUMN TYPE LVC_S_COL
                                PO_SENDER TYPE REF TO CL_GUI_ALV_GRID.

  DATA LT_INDEX_ROWS TYPE LVC_T_ROW.
  DATA LS_INDEX_ROW LIKE LINE OF LT_INDEX_ROWS.

  CALL METHOD GO_ALV_GRID_4->GET_SELECTED_ROWS
    IMPORTING
      ET_INDEX_ROWS = LT_INDEX_ROWS     " Indexes of Selected Rows
*     ET_ROW_NO     =                  " Numeric IDs of Selected Rows
    .

  IF LT_INDEX_ROWS[] IS INITIAL.
    " TEXT-M01: 라인을 선택하세요.
    MESSAGE S000 DISPLAY LIKE 'W' WITH '라인을 선택하세요'.
  ELSE.

    LOOP AT LT_INDEX_ROWS INTO LS_INDEX_ROW WHERE ROWTYPE IS INITIAL.
      READ TABLE GT_DISPLAY5 INTO GS_DISPLAY5 INDEX LS_INDEX_ROW-INDEX.

      IF S0100-CHARG1 IS INITIAL.

        S0100-CHARG1 = GS_DISPLAY5-CHARG.

      ELSEIF S0100-CHARG2 IS INITIAL.

        S0100-CHARG2 = GS_DISPLAY5-CHARG.

      ELSEIF S0100-CHARG3 IS INITIAL.

        S0100-CHARG3 = GS_DISPLAY5-CHARG.

      ELSEIF S0100-CHARG4 IS INITIAL.

        S0100-CHARG4 = GS_DISPLAY5-CHARG.

      ENDIF.

    ENDLOOP.

  ENDIF.





*  CLEAR GS_DISPLAY5.

  LEAVE TO SCREEN 0300.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CAL_MENGE
*&---------------------------------------------------------------------*
FORM CAL_MENGE .

*  S0100-MENGET = S0100-MENGE1 + S0100-MENGE2 +
*                 S0100-MENGE3 + S0100-MENGE4.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_PLANT
*&---------------------------------------------------------------------*
FORM SELECT_PLANT .


*--------------------------------------------------------------------*
*-- POV 기능으로 아래 로직 대체함

**  SELECT SINGLE B~PNAME1
**    FROM ZEA_MMT060 AS A
**    JOIN ZEA_T001W AS B
**      ON B~WERKS EQ A~WERKS
**    WHERE A~WERKS EQ @ZEA_MMT100-PLANTTO
**    INTO @S0100-PNAME1.
**
**  SELECT SINGLE A~SCODE
**    FROM ZEA_MMT060 AS A
**    JOIN ZEA_T001W AS B
**      ON B~WERKS EQ A~WERKS
**    WHERE A~WERKS EQ @ZEA_MMT100-PLANTTO
**    INTO @ZEA_MMT100-LGORTTO.



*  SELECT FROM ZEA_MMT060 AS A
*         JOIN ZEA_T001W AS B
*           ON B~WERKS EQ A~WERKS
*         FIELDS B~PNAME1 A~SCODE
*         WHERE WERKS EQ ZEA_MMT100-PLANTTO
*         INTO S0100-PNAME1 ZEA_MMT100-LGORTTO

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MMT190_F4_HELP
*&---------------------------------------------------------------------*
FORM MMT190_F4_HELP .

  DATA: LT_RETURN_TAB TYPE DDSHRETVAL OCCURS 0,
        LS_RETURN_TAB LIKE LINE OF LT_RETURN_TAB.

  DATA: LT_DSELC TYPE DSELC OCCURS 0,
        LS_DSELC LIKE LINE OF LT_DSELC.

  DATA: LS_VALUE  TYPE SEAHLPRES,
        LT_VALUE  TYPE TABLE OF SEAHLPRES,
        LS_FIELD  TYPE DFIES,
        LT_FIELDS TYPE TABLE OF DFIES.

  DATA: BEGIN OF LTT001W_WERKS OCCURS 0,
          WERKS  TYPE ZEA_T001W-WERKS,
          PNAME1 TYPE ZEA_T001W-PNAME1,
          SCODE  TYPE ZEA_MMT060-SCODE,
        END OF LTT001W_WERKS.

*  DATA: BEGIN OF LT190_MATNR OCCURS 0,
*          MATNR TYPE ZEA_MMT190-MATNR,
*          MAKTX TYPE ZEA_MMT020-MAKTX,
*        END OF LT190_MATNR.

  DATA: LT_MAP TYPE TABLE OF DSELC WITH HEADER LINE.

  CLEAR :  LTT001W_WERKS,  LTT001W_WERKS[],
           LT_VALUE, LT_VALUE[],
           LT_FIELDS, LT_FIELDS[].

  SELECT A~WERKS A~PNAME1 B~SCODE
    INTO TABLE LTT001W_WERKS
    FROM ZEA_T001W AS A
    JOIN ZEA_MMT060 AS B
      ON B~WERKS EQ A~WERKS.

  SORT  LTT001W_WERKS BY WERKS.

*  SELECT A~MATNR
*          B~MAKTX
*          INTO TABLE LT190_MATNR
*         FROM ZEA_MMT190 AS A
*         JOIN ZEA_MMT020 AS B
*           ON B~MATNR EQ A~MATNR
*          AND B~SPRAS EQ SY-LANGU
*          WHERE A~MATNR LIKE '30%'.

*  SORT LT190_MATNR BY MATNR.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      RETFIELD        = 'WERKS'           " Name of return field in FIELD_TAB
      DYNPPROG        = SY-REPID          " Current program
      DYNPNR          = SY-DYNNR          " Screen number
*     DYNPROFIELD     = 'ZEA_MMT010-MATNR'
      WINDOW_TITLE    = '입고 플랜트'        " Title for the hit list
      VALUE_ORG       = 'S'               " Value return: C: cell by cell, S: structured
    TABLES
*     FIELD_TAB       = LT_FIELDS[]
      VALUE_TAB       = LTT001W_WERKS[]                 " Table of values: entries cell by cell
      RETURN_TAB      = LT_RETURN_TAB[]
*     DYNPFLD_MAPPING = LT_MAP
    EXCEPTIONS
      PARAMETER_ERROR = 1                " Incorrect parameter
      NO_VALUES_FOUND = 2                " No values found
      OTHERS          = 3.

  IF SY-SUBRC EQ 0.
    READ TABLE LT_RETURN_TAB INTO LS_RETURN_TAB INDEX 1.
    IF SY-SUBRC EQ 0.
      ZEA_T001W-WERKS = LS_RETURN_TAB-FIELDVAL.

      READ TABLE LTT001W_WERKS WITH KEY WERKS = ZEA_T001W-WERKS BINARY SEARCH.
      IF SY-SUBRC EQ 0.
        ZEA_MMT100-PLANTTO        = LTT001W_WERKS-WERKS.
        S0100-PNAME1              = LTT001W_WERKS-PNAME1.
        ZEA_MMT100-LGORTTO        = LTT001W_WERKS-SCODE.


        LEAVE SCREEN.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_MAKTX
*&---------------------------------------------------------------------*
FORM SELECT_MAKTX USING PV_LIST.

  SELECT SINGLE
   FROM ZEA_MMT020
 FIELDS MAKTX
  WHERE MATNR EQ @PV_LIST
   INTO @ZEA_MMT020-MAKTX.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MOVE_TIRE_DATA
*&---------------------------------------------------------------------*
FORM MOVE_TIRE_DATA_MMT190 .

  DATA: LT_MMT190 TYPE TABLE OF ZEA_MMT190,
        LS_MMT190 LIKE LINE OF LT_MMT190.

*-- 출고 될 플랜트의 수량을 감소 시킴

  " 재고 테이블의 재고량을 SELECT 하여 WA에 담음
  SELECT SINGLE
         FROM ZEA_MMT190
       FIELDS *
        WHERE MATNR EQ @ZEA_MMT100-MATNR
          AND WERKS EQ @ZEA_MMT100-PLANTFR
          AND SCODE EQ @ZEA_MMT100-LGORTFR
          INTO @LS_MMT190.

  IF SY-SUBRC EQ 0.
    " 입력한 재고 이전 수량이 재고테이블의 양보다 많을 경우 에러메시지
    IF S0100-MENGET > LS_MMT190-CALQTY.
      MESSAGE E037. " 재고가 부족합니다.
    ELSE.
      " 재고 테이블의 수량 = 재고 테이블 수량 - 입력한 수량
      LS_MMT190-CALQTY = LS_MMT190-CALQTY - S0100-MENGET.
      LS_MMT190-WEIGHT = LS_MMT190-WEIGHT - ( S0100-MENGET * 4 ).
      " 재고 테이블 수량 업데이트
      UPDATE ZEA_MMT190 SET CALQTY = LS_MMT190-CALQTY
                            WEIGHT = LS_MMT190-WEIGHT
                            AENAM  = SY-UNAME
                            AEDAT  = SY-DATUM
                            AEZET  = SY-UZEIT
                      WHERE MATNR  = LS_MMT190-MATNR
                        AND WERKS  = LS_MMT190-WERKS
                        AND SCODE  = LS_MMT190-SCODE.

      CLEAR LS_MMT190.
    ENDIF.
  ENDIF.

*-- 입고 될 플랜트의 수량을 증가 시킴

  " 재고 테이블의 재고량을 SELECT 하여 WA에 담음
  SELECT SINGLE
         FROM ZEA_MMT190
       FIELDS *
        WHERE MATNR EQ @ZEA_MMT100-MATNR
          AND WERKS EQ @ZEA_MMT100-PLANTTO
          AND SCODE EQ @ZEA_MMT100-LGORTTO
          INTO @LS_MMT190.

  IF SY-SUBRC EQ 0.
    " 재고 테이블의 수량 = 재고 테이블 수량 + 입력한 수량
    LS_MMT190-CALQTY = LS_MMT190-CALQTY + S0100-MENGET.
    LS_MMT190-WEIGHT = LS_MMT190-WEIGHT + ( S0100-MENGET * 4 ).
    " 재고 테이블 수량 업데이트
    UPDATE ZEA_MMT190 SET CALQTY = LS_MMT190-CALQTY
                          WEIGHT = LS_MMT190-WEIGHT
                          AENAM  = SY-UNAME
                          AEDAT  = SY-DATUM
                          AEZET  = SY-UZEIT
                    WHERE MATNR  = LS_MMT190-MATNR
                      AND WERKS  = LS_MMT190-WERKS
                      AND SCODE  = LS_MMT190-SCODE.

    CLEAR LS_MMT190.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHANGE_TIRE_BATCH_DATA_MMT070
*&---------------------------------------------------------------------*
FORM CHANGE_TIRE_BATCH_DATA_MMT070 .

  DATA: LT_MMT070   TYPE TABLE OF ZEA_MMT070,
        LT_MMT070_2 TYPE TABLE OF ZEA_MMT070,
        LS_MMT070   LIKE LINE OF LT_MMT070,
        LS_MMT070_2 LIKE LINE OF LT_MMT070,
        LV_STATUS   TYPE C LENGTH 1,
        LV_MENGET   TYPE ZEA_MMT100-MENGE.

  LV_MENGET = S0100-MENGET.

  " 삭제 플래그 값 없는 것들만 조회하고 배치번호로 정렬
  SELECT *
    FROM ZEA_MMT070
    INTO TABLE LT_MMT070
    WHERE LVORM EQ ''.

  " 배치번호 순으로 정렬
  SORT LT_MMT070 BY CHARG.

  "
  READ TABLE LT_MMT070 INTO LS_MMT070
                       WITH KEY MATNR = ZEA_MMT100-MATNR
                                WERKS = ZEA_MMT100-PLANTFR
                                SCODE = ZEA_MMT100-LGORTFR.

  IF SY-SUBRC EQ 0.

    " 입력 수량이 배치번호의 잔여수량보다 적을 때
    " 배치의 보유수량이 많으면 필요한 만큼만 제거.
    IF LS_MMT070-REMQTY GT S0100-MENGET.

      LS_MMT070-REMQTY = LS_MMT070-REMQTY - S0100-MENGET.
*      GS_DISPLAY2-AUQUA = 0.

      UPDATE ZEA_MMT070 SET REMQTY = LS_MMT070-REMQTY
                            AENAM  = SY-UNAME
                            AEDAT  = SY-DATUM
                            AEZET  = SY-UZEIT
                      WHERE MATNR = LS_MMT070-MATNR
                        AND WERKS = LS_MMT070-WERKS
                        AND SCODE = LS_MMT070-SCODE
                        AND CHARG = LS_MMT070-CHARG.

      " 입고될 플랜트에 동일한 배치번호 상품이 존재하는지 확인하기 위해
      " 아래의 셀렉 문 수행
      CLEAR LS_MMT070_2.

      SELECT SINGLE *
        FROM ZEA_MMT070
        WHERE CHARG EQ @LS_MMT070-CHARG
          AND WERKS EQ @ZEA_MMT100-PLANTTO
          AND SCODE EQ @ZEA_MMT100-LGORTTO
          AND MATNR EQ @LS_MMT070-MATNR
        INTO CORRESPONDING FIELDS OF @LS_MMT070_2.


      " 이전할 플랜트에 이미 동일한 배치번호를 갖고 있는 재고가 있으면, Update
      " 동일한 배치번호를 갖는 재고가 없으면, Insert
      IF SY-SUBRC EQ 0.


*        LS_MMT070_2-CALQTY = LS_MMT070_2-CALQTY + S0100-MENGET.
        LS_MMT070_2-REMQTY = LS_MMT070_2-REMQTY + S0100-MENGET.

        UPDATE ZEA_MMT070 SET " CALQTY = LS_MMT070_2-CALQTY
                              REMQTY = LS_MMT070_2-REMQTY
                              LVORM  = ''
                               AENAM  = SY-UNAME
                               AEDAT  = SY-DATUM
                               AEZET  = SY-UZEIT
                       WHERE CHARG EQ LS_MMT070-CHARG
                         AND WERKS EQ ZEA_MMT100-PLANTTO
                         AND SCODE EQ ZEA_MMT100-LGORTTO
                         AND MATNR EQ LS_MMT070-MATNR.


      ELSE.

        LS_MMT070-CALQTY = LS_MMT070-CALQTY.
        LS_MMT070-REMQTY = S0100-MENGET.
        LS_MMT070-WERKS  = ZEA_MMT100-PLANTTO.
        LS_MMT070-SCODE  = ZEA_MMT100-LGORTTO.
        LS_MMT070-ERDAT = SY-DATUM.
        LS_MMT070-ERNAM = SY-UNAME.
        LS_MMT070-ERZET = SY-UZEIT.
        INSERT ZEA_MMT070 FROM LS_MMT070.

      ENDIF.

*--------------------------------------------------------------------*
      " 입력 수량과 배치번호의 잔여수량이 같을 때
    ELSEIF LS_MMT070-REMQTY EQ S0100-MENGET.

      LS_MMT070-REMQTY = LS_MMT070-REMQTY - S0100-MENGET.
*     LS_MMT070-REMQTY = 0 이 됨

      UPDATE ZEA_MMT070 SET REMQTY = LS_MMT070-REMQTY
                            LVORM  = 'X' " 배치번호 제일 빠른것 '만' 삭제
                            AENAM  = SY-UNAME
                            AEDAT  = SY-DATUM
                            AEZET  = SY-UZEIT
                        WHERE MATNR = LS_MMT070-MATNR
                        AND WERKS = LS_MMT070-WERKS
                        AND SCODE = LS_MMT070-SCODE
                        AND CHARG = LS_MMT070-CHARG.

      " 입고될 플랜트에 동일한 배치번호 상품이 존재하는지 확인하기 위해
      " 아래의 셀렉 문 수행
      CLEAR LS_MMT070_2.

      SELECT SINGLE *
        FROM ZEA_MMT070
        WHERE CHARG EQ @LS_MMT070-CHARG
          AND WERKS EQ @ZEA_MMT100-PLANTTO
          AND SCODE EQ @ZEA_MMT100-LGORTTO
          AND MATNR EQ @LS_MMT070-MATNR
        INTO CORRESPONDING FIELDS OF @LS_MMT070_2.


      " 이전할 플랜트에 이미 동일한 배치번호를 갖고 있는 재고가 있으면, Update
      " 동일한 배치번호를 갖는 재고가 없으면, Insert
      IF SY-SUBRC EQ 0.

*        LS_MMT070_2-CALQTY = LS_MMT070_2-CALQTY + S0100-MENGET.
        LS_MMT070_2-REMQTY = LS_MMT070_2-REMQTY + S0100-MENGET.

        UPDATE ZEA_MMT070 SET " CALQTY = LS_MMT070_2-CALQTY
                              REMQTY = LS_MMT070_2-REMQTY
                              LVORM  = ''
                               AENAM  = SY-UNAME
                               AEDAT  = SY-DATUM
                               AEZET  = SY-UZEIT
                       WHERE CHARG EQ LS_MMT070-CHARG
                         AND WERKS EQ ZEA_MMT100-PLANTTO
                         AND SCODE EQ ZEA_MMT100-LGORTTO
                         AND MATNR EQ LS_MMT070-MATNR.

      ELSE.

        LS_MMT070-CALQTY = LS_MMT070-CALQTY.
        LS_MMT070-REMQTY = S0100-MENGET.
        LS_MMT070-WERKS  = ZEA_MMT100-PLANTTO.
        LS_MMT070-SCODE  = ZEA_MMT100-LGORTTO.
        LS_MMT070-ERDAT = SY-DATUM.
        LS_MMT070-ERNAM = SY-UNAME.
        LS_MMT070-ERZET = SY-UZEIT.
        INSERT ZEA_MMT070 FROM LS_MMT070.

      ENDIF.



*--------------------------------------------------------------------*
      " 입력된 수량이 배치번호의 잔여 수량보다 많을 경우
    ELSEIF LS_MMT070-REMQTY LT S0100-MENGET.

      LOOP AT LT_MMT070 INTO LS_MMT070 WHERE MATNR EQ ZEA_MMT100-MATNR
                                         AND WERKS EQ ZEA_MMT100-PLANTFR
                                         AND SCODE EQ ZEA_MMT100-LGORTFR.

        " LV_STATUS 에 X 가 들어오면 루프문 EXIT.
        IF LV_STATUS EQ 'X'.
          EXIT.
        ENDIF.

        " 잔여수량이 입력 수량보다 적을 시
        IF LS_MMT070-REMQTY LT S0100-MENGET.

          S0100-MENGET = S0100-MENGET - LS_MMT070-REMQTY.
*           S0100-MENGET 값에 잔여수량이 뺀 만큼이 들어감

          " 잔여수량이 어짜피 0이 되기에 하드코딩 수행
          " 잔여수량이 0이 되었으므로 해당 배치번호에 'X' 표시
          UPDATE ZEA_MMT070 SET REMQTY = '0'
                                LVORM  = 'X' " 배치번호 제일 빠른것 '만' 삭제
                                AENAM  = SY-UNAME
                                AEDAT  = SY-DATUM
                                AEZET  = SY-UZEIT
                          WHERE MATNR = LS_MMT070-MATNR
                            AND WERKS = LS_MMT070-WERKS
                            AND SCODE = LS_MMT070-SCODE
                            AND CHARG = LS_MMT070-CHARG
                            AND LVORM NE 'X'.


          " 입고될 플랜트에 동일한 배치번호 상품이 존재하는지 확인하기 위해
          " 아래의 셀렉 문 수행
          CLEAR LS_MMT070_2.

          SELECT SINGLE *
            FROM ZEA_MMT070
            WHERE CHARG EQ @LS_MMT070-CHARG
              AND WERKS EQ @ZEA_MMT100-PLANTTO
              AND SCODE EQ @ZEA_MMT100-LGORTTO
              AND MATNR EQ @LS_MMT070-MATNR
            INTO CORRESPONDING FIELDS OF @LS_MMT070_2.

          " 이전할 플랜트에 이미 동일한 배치번호를 갖고 있는 재고가 있으면, Update
          " 동일한 배치번호를 갖는 재고가 없으면, Insert
          IF SY-SUBRC EQ 0.

*            LS_MMT070_2-CALQTY = LS_MMT070_2-CALQTY + LS_MMT070-REMQTY.
            LS_MMT070_2-REMQTY = LS_MMT070_2-REMQTY + LS_MMT070-REMQTY.

            UPDATE ZEA_MMT070 SET " CALQTY = LS_MMT070_2-CALQTY
                                  REMQTY = LS_MMT070_2-REMQTY
                                  LVORM  = ''
                                   AENAM  = SY-UNAME
                                   AEDAT  = SY-DATUM
                                   AEZET  = SY-UZEIT
                           WHERE CHARG EQ LS_MMT070-CHARG
                             AND WERKS EQ ZEA_MMT100-PLANTTO
                             AND SCODE EQ ZEA_MMT100-LGORTTO
                             AND MATNR EQ LS_MMT070-MATNR.

          ELSE.
            " A 플랜트에서 잔여수량 전체를 이전하였으므로
            " 입고되는 B 플랜트에는 수량은 A.잔여수량 만큼
            " 잔여수량도 A.잔여수량 만큼
            LS_MMT070-CALQTY = LS_MMT070-CALQTY.
            LS_MMT070-REMQTY = LS_MMT070-REMQTY.
            LS_MMT070-WERKS  = ZEA_MMT100-PLANTTO.
            LS_MMT070-SCODE  = ZEA_MMT100-LGORTTO.
            LS_MMT070-ERDAT = SY-DATUM.
            LS_MMT070-ERNAM = SY-UNAME.
            LS_MMT070-ERZET = SY-UZEIT.
            INSERT ZEA_MMT070 FROM LS_MMT070.
          ENDIF.


*--------------------------------------------------------------------*
          " 잔여수량과 입력 수량이 같을 시.
        ELSEIF LS_MMT070-REMQTY EQ S0100-MENGET.
          " 위의 IF문을 탔으면 입력 수량값에는 변경되어 있는 값이 저장 되어 있음.

          " 잔여수량과 입력 수량과 같이에 잔여수량이 0으로 바뀜
          " 잔여가 0이므로 배치번호 삭제
          UPDATE ZEA_MMT070 SET REMQTY = '0'
                                LVORM  = 'X' " 배치번호 제일 빠른것 '만' 삭제
                                AENAM  = SY-UNAME
                                AEDAT  = SY-DATUM
                                AEZET  = SY-UZEIT
                          WHERE MATNR = LS_MMT070-MATNR
                            AND WERKS = LS_MMT070-WERKS
                            AND SCODE = LS_MMT070-SCODE
                            AND CHARG = LS_MMT070-CHARG
                            AND LVORM NE 'X'.

          " 입고될 플랜트에 동일한 배치번호 상품이 존재하는지 확인하기 위해
          " 아래의 셀렉 문 수행
          CLEAR LS_MMT070_2.

          SELECT SINGLE *
            FROM ZEA_MMT070
            WHERE CHARG EQ @LS_MMT070-CHARG
              AND WERKS EQ @ZEA_MMT100-PLANTTO
              AND SCODE EQ @ZEA_MMT100-LGORTTO
              AND MATNR EQ @LS_MMT070-MATNR
            INTO CORRESPONDING FIELDS OF @LS_MMT070_2.

          " 이전할 플랜트에 이미 동일한 배치번호를 갖고 있는 재고가 있으면, Update
          " 동일한 배치번호를 갖는 재고가 없으면, Insert
          IF SY-SUBRC EQ 0.

*            LS_MMT070_2-CALQTY = LS_MMT070_2-CALQTY + LS_MMT070-REMQTY.
            LS_MMT070_2-REMQTY = LS_MMT070_2-REMQTY + LS_MMT070-REMQTY.

            UPDATE ZEA_MMT070 SET " CALQTY = LS_MMT070_2-CALQTY
                                  REMQTY = LS_MMT070_2-REMQTY
                                  LVORM  = ''
                                   AENAM  = SY-UNAME
                                   AEDAT  = SY-DATUM
                                   AEZET  = SY-UZEIT
                           WHERE CHARG EQ LS_MMT070-CHARG
                             AND WERKS EQ ZEA_MMT100-PLANTTO
                             AND SCODE EQ ZEA_MMT100-LGORTTO
                             AND MATNR EQ LS_MMT070-MATNR.

            " 루프문 탈출
            LV_STATUS = 'X'.

          ELSE.
            LS_MMT070-CALQTY = LS_MMT070-CALQTY.
            LS_MMT070-REMQTY = LS_MMT070-REMQTY.
            LS_MMT070-WERKS  = ZEA_MMT100-PLANTTO.
            LS_MMT070-SCODE  = ZEA_MMT100-LGORTTO.
            LS_MMT070-ERDAT = SY-DATUM.
            LS_MMT070-ERNAM = SY-UNAME.
            LS_MMT070-ERZET = SY-UZEIT.
            INSERT ZEA_MMT070 FROM LS_MMT070.

            " 루프문 탈출
            LV_STATUS = 'X'.
          ENDIF.

*--------------------------------------------------------------------*

          " 잔여수량이 입력 수량보다 클경우
          " 루프 탈출
        ELSEIF LS_MMT070-REMQTY GT S0100-MENGET.

          " 잔여수량에서 변경된 입력 수량만큼을 뺌
          LS_MMT070-REMQTY = LS_MMT070-REMQTY - S0100-MENGET.

          " 변경된 잔여수량을 업데이트
          " 아직 잔여 수량이 존재하므로 해당 업데이트에서는 삭제플래그에 값을 주지 않음
          UPDATE ZEA_MMT070 SET REMQTY =  LS_MMT070-REMQTY
                                AENAM  = SY-UNAME
                                AEDAT  = SY-DATUM
                                AEZET  = SY-UZEIT
                          WHERE MATNR = LS_MMT070-MATNR
                            AND WERKS = LS_MMT070-WERKS
                            AND SCODE = LS_MMT070-SCODE
                            AND CHARG = LS_MMT070-CHARG.

          " 입고될 플랜트에 동일한 배치번호 상품이 존재하는지 확인하기 위해
          " 아래의 셀렉 문 수행
          CLEAR LS_MMT070_2.

          SELECT SINGLE *
            FROM ZEA_MMT070
            WHERE CHARG EQ @LS_MMT070-CHARG
              AND WERKS EQ @ZEA_MMT100-PLANTTO
              AND SCODE EQ @ZEA_MMT100-LGORTTO
              AND MATNR EQ @LS_MMT070-MATNR
            INTO CORRESPONDING FIELDS OF @LS_MMT070_2.

          " 이전할 플랜트에 이미 동일한 배치번호를 갖고 있는 재고가 있으면, Update
          " 동일한 배치번호를 갖는 재고가 없으면, Insert
          IF SY-SUBRC EQ 0.

            LS_MMT070_2-CALQTY = LS_MMT070_2-CALQTY + S0100-MENGET.
            LS_MMT070_2-REMQTY = LS_MMT070_2-REMQTY + S0100-MENGET.

            UPDATE ZEA_MMT070 SET " CALQTY = LS_MMT070_2-CALQTY
                                  REMQTY = LS_MMT070_2-REMQTY
                                  LVORM  = ''
                                   AENAM  = SY-UNAME
                                   AEDAT  = SY-DATUM
                                   AEZET  = SY-UZEIT
                           WHERE CHARG EQ LS_MMT070-CHARG
                             AND WERKS EQ ZEA_MMT100-PLANTTO
                             AND SCODE EQ ZEA_MMT100-LGORTTO
                             AND MATNR EQ LS_MMT070-MATNR.

            " 루프문 탈출
            LV_STATUS = 'X'.

          ELSE.
            " 변경된 입력 수량만큼 배치번호에 적용
            LS_MMT070-CALQTY = LS_MMT070-CALQTY.
            LS_MMT070-REMQTY = S0100-MENGET.
            LS_MMT070-WERKS  = ZEA_MMT100-PLANTTO.
            LS_MMT070-SCODE  = ZEA_MMT100-LGORTTO.
            LS_MMT070-ERDAT = SY-DATUM.
            LS_MMT070-ERNAM = SY-UNAME.
            LS_MMT070-ERZET = SY-UZEIT.
            INSERT ZEA_MMT070 FROM LS_MMT070.

            " 루프문 탈출
            LV_STATUS = 'X'.
          ENDIF.

        ENDIF.

      ENDLOOP.

    ELSE.
    ENDIF.


  ELSE.

  ENDIF.

*  " 화면 리프레쉬를 위해 다시 셀렉트
*  PERFORM SELECT_DATA_070 USING LS_MMT070-MATNR
*                              LS_MMT070-WERKS
*                              LS_MMT070-SCODE.

  REFRESH GT_DISPLAY5.

  SELECT FROM ZEA_MMT070
     FIELDS *
      WHERE MATNR EQ @ZEA_MMT100-MATNR
        AND WERKS EQ @ZEA_MMT100-PLANTFR
        AND SCODE EQ @ZEA_MMT100-LGORTFR
       INTO CORRESPONDING FIELDS OF TABLE @GT_DISPLAY5.

  S0100-MENGET = LV_MENGET.

  DATA : LV_TEXT TYPE C LENGTH 8."SDYDO_TEXT_ELEMENT.

  LV_TEXT = S0100-MENGET.
  WRITE S0100-MENGET TO LV_TEXT UNIT 'PKG'.

  MESSAGE S081 WITH LV_TEXT.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_USER_COMMAND
*&---------------------------------------------------------------------*
FORM HANDLE_USER_COMMAND  USING PV_UCOMM TYPE SY-UCOMM
                               PO_SENDER  TYPE REF TO CL_GUI_ALV_GRID.

  CASE PO_SENDER.
    WHEN GO_ALV_GRID_4. "PO_SENDER 가 GO_ALV_GRID 일 때
      CASE PV_UCOMM.  " 선택한 버튼 (PV_UCOMM은 SY-UCOMM 타입)
        WHEN GC_INVOICE.
*          PERFORM SELECT_DATA.
*          PERFORM MAKE_DISPLAY_DATA.
          PERFORM INVOICE_FILTER.
          PERFORM SET_ALV_FILTER.

        WHEN GC_INVOICE_OK.
*          PERFORM SELECT_DATA.
*          PERFORM MAKE_DISPLAY_DATA.
          PERFORM INVOICE_OK_FILTER.
          PERFORM SET_ALV_FILTER.

        WHEN GC_INVOICE_NO.
*          PERFORM SELECT_DATA.
*          PERFORM MAKE_DISPLAY_DATA.
          PERFORM INVOICE_NO_FILTER.
          PERFORM SET_ALV_FILTER.


      ENDCASE.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLER_TOOLBAR
*&---------------------------------------------------------------------*

FORM HANDLER_TOOLBAR    USING PO_OBJECT TYPE REF TO CL_ALV_EVENT_TOOLBAR_SET
        PO_SENDER TYPE REF TO CL_GUI_ALV_GRID.

  " Internal Table PO_OBJECT->MT_TOOLBAR 를 위한 작업공간
  " PO_OBJECT->MT_TOOLBAR >>> 클래스의 Attribute ( Public , Instance )
  DATA LS_TOOLBAR LIKE LINE OF PO_OBJECT->MT_TOOLBAR.

  DATA : LV_INVOICE TYPE I,
         LV_OK      TYPE I,
         LV_ING     TYPE I,
         LV_NO      TYPE I.


  CASE PO_SENDER.
    WHEN GO_ALV_GRID_4.

      LOOP AT GT_DISPLAY5 INTO GS_DISPLAY5.

        CASE GS_DISPLAY5-ICON.
          WHEN ICON_LED_GREEN.
            ADD 1 TO LV_INVOICE.
            ADD 1 TO LV_OK.
          WHEN ICON_LED_RED.
            ADD 1 TO LV_INVOICE.
            ADD 1 TO LV_NO.
*          WHEN ICON_LED_YELLOW.
*            ADD 1 TO LV_INVOICE.
*            ADD 1 TO LV_ING.
        ENDCASE.
      ENDLOOP.


* 구분자 =>> |
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 3. " 구분자
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 전체조회
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 0. " 사용가능 배치번호 O/X
      LS_TOOLBAR-FUNCTION = GC_INVOICE.
      LS_TOOLBAR-TEXT = TEXT-L09 && ':' && LV_INVOICE.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 사용 가능 배치번호
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 0. " 사용 가능 배치번호
      LS_TOOLBAR-FUNCTION = GC_INVOICE_OK.
      LS_TOOLBAR-ICON = ICON_LED_GREEN.
      LS_TOOLBAR-TEXT = TEXT-L10 && ':' && LV_OK.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 사용 불가능 배치번호
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 0. " 사용 불가능 배치번호
      LS_TOOLBAR-FUNCTION = GC_INVOICE_NO.
      LS_TOOLBAR-ICON = ICON_LED_RED.
      LS_TOOLBAR-TEXT = TEXT-L11 && ':' && LV_NO.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form INVOICE_FILTER
*&---------------------------------------------------------------------*
FORM INVOICE_FILTER .

  REFRESH GT_FILTER.

  CLEAR GS_FILTER.
  GS_FILTER-FIELDNAME = 'ICON'.
  GS_FILTER-SIGN      = 'I'.
  GS_FILTER-OPTION    = 'EQ'.
  GS_FILTER-LOW       = ICON_LED_GREEN.
  APPEND GS_FILTER TO GT_FILTER.

  CLEAR GS_FILTER.
  GS_FILTER-FIELDNAME = 'ICON'.
  GS_FILTER-SIGN      = 'I'.
  GS_FILTER-OPTION    = 'EQ'.
  GS_FILTER-LOW       = ICON_LED_RED.
  APPEND GS_FILTER TO GT_FILTER.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FILTER
*&---------------------------------------------------------------------*
FORM SET_ALV_FILTER .

  " ALV에 Filter 정보를 적용하는 과정
  CALL METHOD GO_ALV_GRID_4->SET_FILTER_CRITERIA
    EXPORTING
      IT_FILTER = GT_FILTER                " Filter Conditions
    EXCEPTIONS
      OTHERS    = 1.

  IF SY-SUBRC NE 0.
    MESSAGE E000 WITH '필터 적용에 실패하였습니다'.
  ENDIF.

  " ALV가 새로고침될 때, 현재 라인, 열을 유지할 지
  DATA LS_STABLE TYPE LVC_S_STBL.
  LS_STABLE-ROW = ABAP_ON.
  LS_STABLE-COL = ABAP_ON.

  " 적용된 Filter 기준으로 데이터를 출력
  CALL METHOD GO_ALV_GRID_4->REFRESH_TABLE_DISPLAY
    EXPORTING
      IS_STABLE = LS_STABLE                  " With Stable Rows/Columns
*     I_SOFT_REFRESH =                  " Without Sort, Filter, etc.
    EXCEPTIONS
      OTHERS    = 1.

  IF SY-SUBRC NE 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
      WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form INVOICE_OK_FILTER
*&---------------------------------------------------------------------*
FORM INVOICE_OK_FILTER .

  REFRESH GT_FILTER.

  CLEAR GS_FILTER.
  GS_FILTER-FIELDNAME = 'ICON'.
  GS_FILTER-SIGN      = 'I'.
  GS_FILTER-OPTION    = 'EQ'.
  GS_FILTER-LOW       = ICON_LED_GREEN.
  APPEND GS_FILTER TO GT_FILTER.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form INVOICE_NO_FILTER
*&---------------------------------------------------------------------*
FORM INVOICE_NO_FILTER .

  REFRESH GT_FILTER.

  CLEAR GS_FILTER.
  GS_FILTER-FIELDNAME = 'ICON'.
  GS_FILTER-SIGN      = 'I'.
  GS_FILTER-OPTION    = 'EQ'.
  GS_FILTER-LOW       = ICON_LED_RED.
  APPEND GS_FILTER TO GT_FILTER.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form MODIFY_DISPLAY_0300
*&---------------------------------------------------------------------*
FORM MODIFY_DISPLAY_0300 .

*  REFRESH GT_DISPLAY5.

  LOOP AT GT_DISPLAY5 INTO GS_DISPLAY5.

*    CLEAR GS_DISPLAY5.

*    MOVE-CORRESPONDING GS_DISPLAY5 TO GS_DISPLAY5.

*신규 필드------------------------------------------------------------*

    IF GS_DISPLAY5-LVORM = ''.
      GS_DISPLAY5-ICON = ICON_LED_GREEN.
    ELSEIF GS_DISPLAY5-LVORM = 'X'.
      GS_DISPLAY5-ICON = ICON_LED_RED.
    ENDIF.

*--------------------------------------------------------------------*
    MODIFY GT_DISPLAY5 FROM GS_DISPLAY5.

  ENDLOOP.

  DESCRIBE TABLE GT_DISPLAY2 LINES GV_LINES.

  IF GT_DISPLAY2 IS INITIAL.
    MESSAGE S013 DISPLAY LIKE 'W'.
  ELSE.
*    MESSAGE S006 WITH GV_LINES.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_TIRE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
FORM GET_TIRE .


  CLEAR ZEA_MMT100-PLANTFR.
  CLEAR ZEA_T001W-PNAME1.
  CLEAR ZEA_MMT100-LGORTFR.

  CASE OK_CODE.
    WHEN 'BTN_GET1'.
      ZEA_MMT100-PLANTTO = '10002'.
      S0100-PNAME1   = '한국타이어 구로점'.
      ZEA_MMT100-LGORTTO = 'SL03'.
      ZEA_MMT100-MATNR = GV_LIST1.

      PERFORM SELECT_MAKTX USING GV_LIST1.

    WHEN 'BTN_GET2'.
      ZEA_MMT100-PLANTTO = '10003'.
      S0100-PNAME1   = '한국타이어 평택점'.
      ZEA_MMT100-LGORTTO = 'SL04'.
      ZEA_MMT100-MATNR = GV_LIST2.

      PERFORM SELECT_MAKTX USING GV_LIST2.

    WHEN 'BTN_GET3'.
      ZEA_MMT100-PLANTTO = '10004'.
      S0100-PNAME1   = '한국타이어 종로점'.
      ZEA_MMT100-LGORTTO = 'SL05'.
      ZEA_MMT100-MATNR = GV_LIST3.

      PERFORM SELECT_MAKTX USING GV_LIST3.

    WHEN 'BTN_GET4'.
      ZEA_MMT100-PLANTTO = '10005'.
      S0100-PNAME1   = '한국타이어 인천점'.
      ZEA_MMT100-LGORTTO = 'SL06'.
      ZEA_MMT100-MATNR = GV_LIST4.

      PERFORM SELECT_MAKTX USING GV_LIST4.

    WHEN 'BTN_GET5'.
      ZEA_MMT100-PLANTTO = '10006'.
      S0100-PNAME1   = '한국타이어 오산점'.
      ZEA_MMT100-LGORTTO = 'SL07'.
      ZEA_MMT100-MATNR = GV_LIST5.

      PERFORM SELECT_MAKTX USING GV_LIST5.

    WHEN 'BTN_GET6'.
      ZEA_MMT100-PLANTTO = '10007'.
      S0100-PNAME1   = '한국타이어 대구점'.
      ZEA_MMT100-LGORTTO = 'SL08'.
      ZEA_MMT100-MATNR = GV_LIST6.

      PERFORM SELECT_MAKTX USING GV_LIST6.

    WHEN 'BTN_GET7'.
      ZEA_MMT100-PLANTTO = '10008'.
      S0100-PNAME1   = '한국타이어 대전점'.
      ZEA_MMT100-LGORTTO = 'SL09'.
      ZEA_MMT100-MATNR = GV_LIST7.

      PERFORM SELECT_MAKTX USING GV_LIST7.

    WHEN 'BTN_GET8'.
      ZEA_MMT100-PLANTTO = '10009'.
      S0100-PNAME1   = '한국타이어 부천점'.
      ZEA_MMT100-LGORTTO = 'SL10'.
      ZEA_MMT100-MATNR = GV_LIST8.

      PERFORM SELECT_MAKTX USING GV_LIST8.

    WHEN 'BTN_GET9'.
      ZEA_MMT100-PLANTTO = '10000'.
      S0100-PNAME1   = '한국타이어 CDC'.
      ZEA_MMT100-LGORTTO = 'SL01'.
      ZEA_MMT100-MATNR = GV_LIST9.

      PERFORM SELECT_MAKTX USING GV_LIST9.

    WHEN 'BTN_GET10'.
      ZEA_MMT100-PLANTTO = '10001'.
      S0100-PNAME1   = '한국타이어 RDC'.
      ZEA_MMT100-LGORTTO = 'SL02'.
      ZEA_MMT100-MATNR = GV_LIST10.

      PERFORM SELECT_MAKTX USING GV_LIST10.

    WHEN OTHERS.
  ENDCASE.

  PERFORM MOVE_INFO.




  " 300번 스크린 호출
  CALL SCREEN 0500 STARTING AT 30 5.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_DATA2_0300
*&---------------------------------------------------------------------*
FORM SELECT_DATA2_0300 .

  SELECT FROM ZEA_MMT190  AS A
         JOIN ZEA_MMT020  AS B ON B~MATNR EQ A~MATNR
         JOIN ZEA_T001W   AS C ON C~WERKS EQ A~WERKS
         JOIN ZEA_MMT060  AS D ON D~WERKS EQ A~WERKS

       FIELDS *
        WHERE C~BUKRS       EQ 1000
          AND A~WERKS       EQ @ZEA_MMT100-PLANTFR
          AND A~SCODE       EQ @ZEA_MMT100-LGORTFR
          AND A~MATNR       EQ @ZEA_MMT100-MATNR
       INTO CORRESPONDING FIELDS OF TABLE @GT_DISPLAY6.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT2_0300
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT2_0300 .

  CREATE OBJECT GO_CONTAINER_5
    EXPORTING
      CONTAINER_NAME = 'CCON5'
    EXCEPTIONS
      OTHERS         = 1.

  IF SY-SUBRC <> 0.
    MESSAGE E020.
  ENDIF.

  CREATE OBJECT GO_ALV_GRID_5
    EXPORTING
      I_PARENT = GO_CONTAINER_5
    EXCEPTIONS
      OTHERS   = 1.

  IF SY-SUBRC NE 0.
    MESSAGE E021.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FIELDCAT2_0300
*&---------------------------------------------------------------------*
FORM SET_ALV_FIELDCAT2_0300 .

  PERFORM GET_FIELDCAT    USING    GT_DISPLAY6
                          CHANGING GT_FIELDCAT5.

  PERFORM MAKE_FIELDCAT5_0100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_FIELDCAT5_0100
*&---------------------------------------------------------------------*
FORM MAKE_FIELDCAT5_0100 .

  LOOP AT GT_FIELDCAT5 INTO GS_FIELDCAT5.

    CASE GS_FIELDCAT5-FIELDNAME.

      WHEN 'MATNR' OR 'WERKS'.
*        GS_FIELDCAT5-HOTSPOT = ABAP_ON.
        GS_FIELDCAT5-KEY = ABAP_ON.
        GS_FIELDCAT5-JUST = 'C'.

      WHEN 'SCODE'.
        GS_FIELDCAT5-KEY = ABAP_ON.
        GS_FIELDCAT5-JUST = 'C'.

      WHEN 'MAKTX' OR 'PNAME1' OR 'SNAME'.
        GS_FIELDCAT5-EMPHASIZE = 'C500'.
        GS_FIELDCAT5-JUST = 'C'.

      WHEN 'CALQTY'.
        GS_FIELDCAT5-EMPHASIZE = 'C300'.
        GS_FIELDCAT5-QFIELDNAME = 'MEINS'.

      WHEN 'WEIGHT'.
        GS_FIELDCAT5-EMPHASIZE = 'C300'.
        GS_FIELDCAT5-QFIELDNAME = 'MEINS2'.

*      WHEN 'SUM_VALUE'.
*        GS_FIELDCAT-CFIELDNAME = 'WAERS'.

      WHEN  'PNAME1' OR 'SCODE' OR 'SNAME'.
        GS_FIELDCAT5-JUST = 'C'.

      WHEN 'LVORM'.
        GS_FIELDCAT3-COLTEXT = '삭제플래그'.

      WHEN OTHERS.

    ENDCASE.
    MODIFY GT_FIELDCAT5 FROM GS_FIELDCAT5.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY5_ALV_0300
*&---------------------------------------------------------------------*
FORM DISPLAY5_ALV_0300 .

  CLEAR GS_VARIANT.
  GS_VARIANT-REPORT = SY-REPID.
  GS_VARIANT-HANDLE = '0006'. " 프로그램 내 ALV 구별자

  GV_SAVE = 'A'. " 개인용/공용 모두 생성 가능하도록 설정

  CALL METHOD GO_ALV_GRID_5->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
*     I_STRUCTURE_NAME              = 'ZEA_SDT050'                 " Internal Output Table Structure Name
      IS_VARIANT                    = GS_VARIANT                 " Layout
      I_SAVE                        = GV_SAVE               " Save Layout
      IS_LAYOUT                     = GS_LAYOUT                " Layout
    CHANGING
      IT_OUTTAB                     = GT_DISPLAY6                " Output Table
      IT_FIELDCATALOG               = GT_FIELDCAT5                 " Field Catalog
*     IT_SORT                       =                  " Sort Criteria
*     IT_FILTER                     =                  " Filter Criteria
    EXCEPTIONS
      INVALID_PARAMETER_COMBINATION = 1                " Wrong Parameter
      PROGRAM_ERROR                 = 2                " Program Errors
      TOO_MANY_LINES                = 3                " Too many Rows in Ready for Input Grid
      OTHERS                        = 4.
  IF SY-SUBRC <> 0.
    " ALV Grid 에 데이터를 전달하는 중 오류가 발생했습니다.
    MESSAGE E023.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH2_ALV_0300
*&---------------------------------------------------------------------*
FORM REFRESH2_ALV_0300 USING PO_ALV_GRID_5 TYPE REF TO CL_GUI_ALV_GRID.


  CHECK PO_ALV_GRID_5 IS BOUND.

  DATA LS_STABLE TYPE LVC_S_STBL.

  LS_STABLE-ROW = ABAP_ON.
  LS_STABLE-COL = ABAP_ON.

  PO_ALV_GRID_5->REFRESH_TABLE_DISPLAY(
    EXPORTING
      IS_STABLE      = LS_STABLE  " With Stable Rows/Columns
      I_SOFT_REFRESH = ABAP_OFF   " Without Sort, Filter, etc.
    EXCEPTIONS
      FINISHED       = 1          " Display was Ended (by Export)
      OTHERS         = 2
  ).
  IF SY-SUBRC <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF..
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_LAYOUT2_0300
*&---------------------------------------------------------------------*
FORM SET_ALV_LAYOUT2_0300 .

  CLEAR GS_LAYOUT.

  GS_LAYOUT-ZEBRA = ABAP_ON.
  GS_LAYOUT-CWIDTH_OPT = 'A'.
  GS_LAYOUT-SEL_MODE = 'B'.

  GS_LAYOUT-NO_ROWINS = ABAP_ON.
  GS_LAYOUT-NO_ROWMOVE = ABAP_ON.

  GS_LAYOUT-CTAB_FNAME = 'CELL_COLOR'.
  GS_LAYOUT-INFO_FNAME = 'ROWCOLOR'.
  GS_LAYOUT-STYLEFNAME = 'STYLE'.

  GS_LAYOUT-GRID_TITLE = TEXT-L03. " Search Result

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MM_FI_FUNCTION
*&---------------------------------------------------------------------*
FORM MM_FI_FUNCTION .

  DATA: IS_HEAD TYPE ZEA_MMT090,
        IT_ITEM TYPE ZEA_MMY100.

  CALL FUNCTION 'ZEA_MM_TRF'
    EXPORTING
      IV_PLANTFR  = ZEA_MMT100-PLANTFR " 플랜트ID(시작)
      IV_PLANTTO  = ZEA_MMT100-PLANTTO " 플랜트ID(도착)
      IV_MATNR    = ZEA_MMT100-MATNR   " 자재코드
      IV_QUANTITY = S0100-MENGET       " 이동 수량
    IMPORTING
      ES_HEAD     = IS_HEAD                 " [MM] 자재문서 Header
      ET_ITEM     = IT_ITEM                 " 자재문서 ITEM 테이블타입
    .

  CALL FUNCTION 'ZEA_FI_WL'
    EXPORTING
      IS_HEAD  = IS_HEAD   " [MM] 자재문서 Header
      IT_ITEM  = IT_ITEM.   " 자재문서 ITEM 테이블타입


ENDFORM.
