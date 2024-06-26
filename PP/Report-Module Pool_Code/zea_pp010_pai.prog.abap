*&---------------------------------------------------------------------*
*& Include          ZALV_GRID_DISPLAY_PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE EXIT_0100 INPUT.

  CASE OK_CODE.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'CANC'.
      LEAVE TO SCREEN 0.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.

  CALL METHOD GO_ALV_GRID->CHECK_CHANGED_DATA.



  CASE OK_CODE.
    WHEN 'SEARCH_BTN'.
      PERFORM SELECT_DATA_CONDITION.
    WHEN 'BTN_ALL'.
      PERFORM SELECT_ALL.
    WHEN 'REFRESH'.
      PERFORM REFRESH_ALV_0100.
      PERFORM REFRESH_ALV2_0100.
    WHEN 'RUD'.
      LEAVE TO TRANSACTION 'ZEAPP020'.
    WHEN 'HD_EXC'.
      CALL TRANSACTION 'ZEAPP030'.
    WHEN 'IT_EXC'.
      CALL TRANSACTION 'ZEAPP040'.
    WHEN 'BTN'.
      GV_SCR_ON = ABAP_ON.
      CLEAR S0100.
    WHEN 'CREATE'.
      PERFORM CREATE_DATA.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'SAVE'.

    WHEN OTHERS.

  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F4HELP  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE F4HELP INPUT.

  DATA: LT_RETURN_TAB TYPE DDSHRETVAL OCCURS 0,
        LS_RETURN_TAB LIKE LINE OF LT_RETURN_TAB.

  DATA: LT_DSELC TYPE DSELC OCCURS 0,
        LS_DSELC LIKE LINE OF LT_DSELC.

  DATA: LS_VALUE  TYPE SEAHLPRES,
        LT_VALUE  TYPE TABLE OF SEAHLPRES,
        LS_FIELD  TYPE DFIES,
        LT_FIELDS TYPE TABLE OF DFIES.


  DATA : BEGIN OF LT_MAT OCCURS 0,
           MATNR   TYPE ZEA_MMT010-MATNR,
           MAKTX   TYPE ZEA_MMT020-MAKTX,
           MATTYPE TYPE ZEA_MMT010-MATTYPE,
         END OF LT_MAT.

  DATA: LT_MAP TYPE TABLE OF DSELC WITH HEADER LINE.

  CLEAR : LT_MAT, LT_MAT[],
          LT_VALUE, LT_VALUE[],
          LT_FIELDS, LT_FIELDS[].

*  DATA: LT_MAT LIKE TABLE OF LS_MAT.

  SELECT A~MATNR B~MAKTX A~MATTYPE
  INTO CORRESPONDING FIELDS OF TABLE LT_MAT
  FROM ZEA_MMT010 AS A
  INNER JOIN ZEA_MMT020 AS B
  ON A~MATNR EQ B~MATNR
  WHERE A~MATTYPE EQ '반제품'
     OR A~MATTYPE EQ '원자재'.

  " RETURN 값 Mapping 용 테이블
*  DATA: LT_MAP TYPE TABLE OF DSELC WITH HEADER LINE.

  LOOP AT LT_MAT.
    LS_VALUE-STRING = LT_MAT-MATNR.
    APPEND LS_VALUE TO LT_VALUE.
    LS_VALUE-STRING = LT_MAT-MAKTX.
    APPEND LS_VALUE TO LT_VALUE.
    LS_VALUE-STRING = LT_MAT-MATTYPE.
    APPEND LS_VALUE TO LT_VALUE.
  ENDLOOP.

  CLEAR LS_FIELD.
  LS_FIELD-FIELDNAME = 'MATNR'.
  LS_FIELD-INTLEN = 20.
  LS_FIELD-LENG = 20.
  LS_FIELD-OUTPUTLEN = 20.
  LS_FIELD-REPTEXT = '자재코드'.
  APPEND LS_FIELD TO LT_FIELDS.

  CLEAR LS_FIELD.
  LS_FIELD-FIELDNAME = 'MAKTX'.
  LS_FIELD-INTLEN = 20.
  LS_FIELD-LENG = 20.
  LS_FIELD-OUTPUTLEN = 20.
  LS_FIELD-REPTEXT = '자재명'.
  APPEND LS_FIELD TO LT_FIELDS.

  CLEAR LS_FIELD.
  LS_FIELD-FIELDNAME = 'MATTYPE'.
  LS_FIELD-INTLEN = 20.
  LS_FIELD-LENG = 20.
  LS_FIELD-OUTPUTLEN = 20.
  LS_FIELD-REPTEXT = '자재타입'.
  APPEND LS_FIELD TO LT_FIELDS.


*  LS_DSELC-FLDNAME = 'MAKTX'.
*  LS_DSELC-DYFLDNAME = 'S0100-MAKTX'.
*  APPEND LS_DSELC TO LT_DSELC.

  CLEAR: LT_MAP.
  LT_MAP-FLDNAME = 'MATNR'.
  LT_MAP-DYFLDNAME = 'S0100-MATNR'.
  APPEND LT_MAP.

  CLEAR: LT_MAP.
  LT_MAP-FLDNAME = 'MAKTX'.
  LT_MAP-DYFLDNAME = 'S0100-MAKTX'.
  APPEND LT_MAP.

  CLEAR: LT_MAP.
  LT_MAP-FLDNAME = 'MATTYPE'.
  LT_MAP-DYFLDNAME = 'S0100-MATTYPE'.
  APPEND LT_MAP.
*

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      RETFIELD        = 'MATNR'                 " Name of return field in FIELD_TAB
      DYNPPROG        = SY-REPID            " Current program
      DYNPNR          = SY-DYNNR            " Screen number
      DYNPROFIELD     = 'S0100-MATNR'
      WINDOW_TITLE    = '자재그룹'                 " Title for the hit list
      VALUE_ORG       = 'C'              " Value return: C: cell by cell, S: structured
    TABLES
      FIELD_TAB       = LT_FIELDS
      VALUE_TAB       = LT_VALUE                 " Table of values: entries cell by cell
      RETURN_TAB      = LT_RETURN_TAB[]
      DYNPFLD_MAPPING = LT_MAP
    EXCEPTIONS
      PARAMETER_ERROR = 1                " Incorrect parameter
      NO_VALUES_FOUND = 2                " No values found
      OTHERS          = 3.

  IF SY-SUBRC EQ 0.
    READ TABLE LT_RETURN_TAB INTO LS_RETURN_TAB INDEX 1.
    IF SY-SUBRC EQ 0.
      S0100-MATNR = LS_RETURN_TAB-FIELDVAL.
    ENDIF.
  ENDIF.


ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F4HELP2  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE F4HELP2 INPUT.

  DATA: LT_RETURN_TAB2 TYPE DDSHRETVAL OCCURS 0,
        LS_RETURN_TAB2 LIKE LINE OF LT_RETURN_TAB.

  DATA: LT_DSELC2 TYPE DSELC OCCURS 0,
        LS_DSELC2 LIKE LINE OF LT_DSELC.

  DATA: LS_VALUE2  TYPE SEAHLPRES,
        LT_VALUE2  TYPE TABLE OF SEAHLPRES,
        LS_FIELD2  TYPE DFIES,
        LT_FIELDS2 TYPE TABLE OF DFIES.


  DATA : BEGIN OF LT_MAT2 OCCURS 0,
           MATNR   TYPE ZEA_MMT010-MATNR,
           MAKTX   TYPE ZEA_MMT020-MAKTX,
           MATTYPE TYPE ZEA_MMT010-MATTYPE,
         END OF LT_MAT2.

  DATA: LT_MAP2 TYPE TABLE OF DSELC WITH HEADER LINE.

  CLEAR : LT_MAT2, LT_MAT2[],
          LT_VALUE2, LT_VALUE2[],
          LT_FIELDS2, LT_FIELDS2[].

*  DATA: LT_MAT LIKE TABLE OF LS_MAT.

  SELECT A~MATNR B~MAKTX A~MATTYPE
    INTO CORRESPONDING FIELDS OF TABLE LT_MAT2
    FROM ZEA_MMT010 AS A
    INNER JOIN ZEA_MMT020 AS B
    ON B~MATNR EQ A~MATNR
   AND B~SPRAS EQ SY-LANGU
  WHERE A~MATTYPE EQ '완제품'
     OR A~MATTYPE EQ '반제품'.

  " RETURN 값 Mapping 용 테이블
*  DATA: LT_MAP TYPE TABLE OF DSELC WITH HEADER LINE.

  LOOP AT LT_MAT2.
    LS_VALUE2-STRING = LT_MAT2-MATNR.
    APPEND LS_VALUE2 TO LT_VALUE2.
    LS_VALUE2-STRING = LT_MAT2-MAKTX.
    APPEND LS_VALUE2 TO LT_VALUE2.
    LS_VALUE2-STRING = LT_MAT2-MATTYPE.
    APPEND LS_VALUE2 TO LT_VALUE2.
  ENDLOOP.

  CLEAR LS_FIELD2.
  LS_FIELD2-FIELDNAME = 'MATNR'.
  LS_FIELD2-INTLEN = 18.
  LS_FIELD2-LENG = 18.
  LS_FIELD2-OUTPUTLEN = 18.
  LS_FIELD2-REPTEXT = '자재코드'.
  APPEND LS_FIELD2 TO LT_FIELDS2.

  CLEAR LS_FIELD2.
  LS_FIELD2-FIELDNAME = 'MAKTX'.
  LS_FIELD2-INTLEN = 40.
  LS_FIELD2-LENG = 20.
  LS_FIELD2-OUTPUTLEN = 20.
  LS_FIELD2-REPTEXT = '자재명'.
  APPEND LS_FIELD2 TO LT_FIELDS2.

  CLEAR LS_FIELD2.
  LS_FIELD2-FIELDNAME = 'MATTYPE'.
  LS_FIELD2-INTLEN = 7.
  LS_FIELD2-LENG = 7.
  LS_FIELD2-OUTPUTLEN = 7.
  LS_FIELD2-REPTEXT = '자재타입'.
  APPEND LS_FIELD2 TO LT_FIELDS2.


*  LS_DSELC-FLDNAME = 'MAKTX'.
*  LS_DSELC-DYFLDNAME = 'S0100-MAKTX'.
*  APPEND LS_DSELC TO LT_DSELC.

  CLEAR: LT_MAP2.
  LT_MAP2-FLDNAME = 'MATNR'.
  LT_MAP2-DYFLDNAME = 'ZEA_STKO-MATNR'.
  APPEND LT_MAP2.

  CLEAR: LT_MAP2.
  LT_MAP2-FLDNAME = 'MAKTX'.
  LT_MAP2-DYFLDNAME = 'ZEA_MMT020-MAKTX'.
  APPEND LT_MAP2.

  CLEAR: LT_MAP2.
  LT_MAP2-FLDNAME = 'MATTYPE'.
  LT_MAP2-DYFLDNAME = 'ZEA_MMT010-MATTYPE'.
  APPEND LT_MAP2.
*

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      RETFIELD        = 'MATNR'                 " Name of return field in FIELD_TAB
      DYNPPROG        = SY-REPID            " Current program
      DYNPNR          = SY-DYNNR            " Screen number
      DYNPROFIELD     = 'ZEA_STKO-MATNR'
      WINDOW_TITLE    = '자재그룹'                 " Title for the hit list
      VALUE_ORG       = 'C'              " Value return: C: cell by cell, S: structured
    TABLES
      FIELD_TAB       = LT_FIELDS2
      VALUE_TAB       = LT_VALUE2                 " Table of values: entries cell by cell
      RETURN_TAB      = LT_RETURN_TAB2[]
      DYNPFLD_MAPPING = LT_MAP2
    EXCEPTIONS
      PARAMETER_ERROR = 1                " Incorrect parameter
      NO_VALUES_FOUND = 2                " No values found
      OTHERS          = 3.

  IF SY-SUBRC EQ 0.
    READ TABLE LT_RETURN_TAB2 INTO LS_RETURN_TAB2 INDEX 1.
    IF SY-SUBRC EQ 0.
      ZEA_MMT010-MATNR = LS_RETURN_TAB2-FIELDVAL.
    ENDIF.
  ENDIF.

ENDMODULE.
