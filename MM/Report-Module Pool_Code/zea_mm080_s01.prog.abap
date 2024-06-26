*&---------------------------------------------------------------------*
*& Include          ZEA_MM080_S01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.

  SET PF-STATUS 'S0100'.
  SET TITLEBAR  'T0100'.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.

  CASE OK_CODE.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'SAVE'.
      PERFORM SAVE_RTN.
    WHEN 'GOPO'.
      CALL TRANSACTION 'ZEA_MM070'.
  ENDCASE.
  CLEAR: OK_CODE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE EXIT_0100 INPUT.

  CASE OK_CODE.
    WHEN 'EXIT' OR 'CANC'.
      LEAVE TO SCREEN 0.
  ENDCASE.
  CLEAR: OK_CODE.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE INIT_0100 OUTPUT.

  IF GO_CONTAINER1 IS INITIAL."Header
    PERFORM CREATE_OBJECT1.
    PERFORM CREATE_ALV_OBJ1.
  ELSE.
    PERFORM REFRESH_TABLE_DISPLAY.

  ENDIF.

  IF GO_CONTAINER2 IS INITIAL."Item
    PERFORM CREATE_OBJECT2.
    PERFORM CREATE_ALV_OBJ2.
  ELSE.
    PERFORM REFRESH_TABLE_DISPLAY.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT1 .

  CREATE OBJECT GO_CONTAINER1
    EXPORTING
      CONTAINER_NAME = 'CON1'.

  CREATE OBJECT GO_GRID1
    EXPORTING
      I_PARENT = GO_CONTAINER1.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH_TABLE_DISPLAY
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM REFRESH_TABLE_DISPLAY .

  DATA : LS_STBL TYPE LVC_S_STBL.

  CLEAR: LS_STBL.
  LS_STBL-ROW = 'X'.
  LS_STBL-COL = 'X'.

  IF GO_GRID1 IS NOT INITIAL.
    CLEAR: GT_FCAT1[].
    PERFORM SET_FIELDCAT1 CHANGING GT_FCAT1.
    CALL METHOD GO_GRID1->SET_FRONTEND_FIELDCATALOG
    EXPORTING IT_FIELDCATALOG = GT_FCAT1.

    CLEAR: GS_LAYO1.
    PERFORM SET_LAYOUT1   CHANGING GS_LAYO1.
    CALL METHOD GO_GRID1->SET_FRONTEND_LAYOUT
    EXPORTING IS_LAYOUT = GS_LAYO1.

    CALL METHOD GO_GRID1->REFRESH_TABLE_DISPLAY
    EXPORTING IS_STABLE = LS_STBL.
  ENDIF.

  IF GO_GRID2 IS NOT INITIAL.
    CLEAR: GT_FCAT2[].
    PERFORM SET_FIELDCAT2 CHANGING GT_FCAT2.
    CALL METHOD GO_GRID2->SET_FRONTEND_FIELDCATALOG
    EXPORTING IT_FIELDCATALOG = GT_FCAT2.

    CLEAR: GS_LAYO2.
    PERFORM SET_LAYOUT2   CHANGING GS_LAYO2.
    CALL METHOD GO_GRID2->SET_FRONTEND_LAYOUT
    EXPORTING IS_LAYOUT = GS_LAYO2.

    CALL METHOD GO_GRID2->REFRESH_TABLE_DISPLAY
    EXPORTING IS_STABLE = LS_STBL.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT2 .

  CREATE OBJECT GO_CONTAINER2
    EXPORTING
      CONTAINER_NAME = 'CON2'.

  CREATE OBJECT GO_GRID2
    EXPORTING
      I_PARENT = GO_CONTAINER2.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_ALV_OBJ2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CREATE_ALV_OBJ2 .

*-----------------------------------------------*
  PERFORM SET_FIELDCAT2 CHANGING GT_FCAT2.
  PERFORM SET_LAYOUT2   CHANGING GS_LAYO2.
  PERFORM SET_SORT2     CHANGING GT_SORT2.
*-----------------------------------------------*
  PERFORM SET_GRID_FIRST_DISPLAY2.
*-----------------------------------------------*

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_FIELDCAT1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GT_FCAT1
*&---------------------------------------------------------------------*
FORM SET_FIELDCAT1  CHANGING PT_FCAT TYPE LVC_T_FCAT.

  DATA : LT_SLIS_FCAT  TYPE  SLIS_T_FIELDCAT_ALV.

  DATA : LV_PROG_NAME  LIKE SY-REPID.
  DATA : LV_INCLNAME   LIKE SY-REPID.

  DATA : LT_FCAT       TYPE  LVC_T_FCAT.

  CLEAR: LV_PROG_NAME, LV_INCLNAME.
  LV_PROG_NAME = SY-REPID.
  LV_INCLNAME  = SY-REPID.

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      I_PROGRAM_NAME         = LV_PROG_NAME
      I_INCLNAME             = LV_INCLNAME
      I_CLIENT_NEVER_DISPLAY = 'X'
      I_INTERNAL_TABNAME     = 'GT_DISP1'
    CHANGING
      CT_FIELDCAT            = LT_SLIS_FCAT
   EXCEPTIONS
     INCONSISTENT_INTERFACE  = 1
     PROGRAM_ERROR           = 2
     OTHERS                  = 3.

  CALL FUNCTION 'LVC_TRANSFER_FROM_SLIS'
    EXPORTING
      IT_FIELDCAT_ALV = LT_SLIS_FCAT
    IMPORTING
      ET_FIELDCAT_LVC = LT_FCAT
    TABLES
      IT_DATA         = GT_DISP1
    EXCEPTIONS
      IT_DATA_MISSING = 1
      OTHERS          = 2.

  CALL FUNCTION 'LVC_FIELDCAT_COMPLETE'
    CHANGING
      CT_FIELDCAT = LT_FCAT.

  CLEAR: PT_FCAT[].
  PT_FCAT[] = LT_FCAT[].

  LOOP AT PT_FCAT ASSIGNING FIELD-SYMBOL(<LFS_FCAT>).
    <LFS_FCAT>-OUTPUTLEN = 12.
    <LFS_FCAT>-KEY       = SPACE.
    CASE <LFS_FCAT>-FIELDNAME.
*      WHEN 'CHKBOX'.
*        <LFS_FCAT>-COL_POS  = 1.
*        <LFS_FCAT>-COLTEXT  = ' '.
*        <LFS_FCAT>-EDIT     = 'X'.
*        <LFS_FCAT>-CHECKBOX = 'X'.
*        <LFS_FCAT>-OUTPUTLEN = 8.
      WHEN 'MATNR'.
        <LFS_FCAT>-COL_POS = 2.
        <LFS_FCAT>-COLTEXT = '자재코드'.
        <LFS_FCAT>-JUST    = 'C'.
      WHEN 'MAKTX'.
        <LFS_FCAT>-COL_POS = 3.
        <LFS_FCAT>-COLTEXT = '자재코드 내역'.
      WHEN 'MENGE'.
        <LFS_FCAT>-COL_POS = 4.
        <LFS_FCAT>-COLTEXT = '수량'.
        <LFS_FCAT>-DO_SUM  = 'X'.
      WHEN 'MEINS'.
        <LFS_FCAT>-COL_POS = 5.
        <LFS_FCAT>-COLTEXT = '단위'.
        <LFS_FCAT>-JUST    = 'C'.
      WHEN 'TOTCOST'.
        <LFS_FCAT>-COL_POS = 6.
        <LFS_FCAT>-COLTEXT = '금액'.
        <LFS_FCAT>-DO_SUM  = 'X'.
        <LFS_FCAT>-OUTPUTLEN = 15.
      WHEN 'WAERS'.
        <LFS_FCAT>-COL_POS = 7.
        <LFS_FCAT>-COLTEXT = '통화'.
        <LFS_FCAT>-JUST    = 'C'.
      WHEN OTHERS.
        <LFS_FCAT>-TECH = 'X'.
    ENDCASE.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_LAYOUT1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GS_LAYO1
*&---------------------------------------------------------------------*
FORM SET_LAYOUT1 CHANGING PS_LAYO TYPE LVC_S_LAYO.

  CLEAR: PS_LAYO.
  PS_LAYO-NO_ROWINS  = 'X'.
  PS_LAYO-NO_ROWMOVE = 'X'.
  PS_LAYO-SEL_MODE   = 'D'.
  PS_LAYO-NO_ROWMARK = 'X'.
  PS_LAYO-TOTALS_BEF = 'X'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_SORT1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GT_SORT1
*&---------------------------------------------------------------------*
FORM SET_SORT1  CHANGING PT_SORT TYPE LVC_T_SORT.

  DATA : LS_SORT TYPE LVC_S_SORT.

*  LS_SORT-SPOS      = 1.
*  LS_SORT-FIELDNAME = 'MATNR'.
*  LS_SORT-UP        = 'X'.
*  APPEND LS_SORT TO PT_SORT.
*  SORT PT_SORT BY FIELDNAME.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_GRID_FIRST_DISPLAY1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_GRID_FIRST_DISPLAY1 .

  CALL METHOD GO_GRID1->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
      IS_LAYOUT                     = GS_LAYO1
    CHANGING
      IT_OUTTAB                     = GT_DISP1[]
      IT_FIELDCATALOG               = GT_FCAT1[]
      IT_SORT                       = GT_SORT1[]
    EXCEPTIONS
      INVALID_PARAMETER_COMBINATION = 1
      PROGRAM_ERROR                 = 2
      TOO_MANY_LINES                = 3
      OTHERS                        = 4.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_FIELDCAT2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GT_FCAT2
*&---------------------------------------------------------------------*
FORM SET_FIELDCAT2  CHANGING PT_FCAT TYPE LVC_T_FCAT.

  DATA : LT_SLIS_FCAT  TYPE  SLIS_T_FIELDCAT_ALV.

  DATA : LV_PROG_NAME  LIKE SY-REPID.
  DATA : LV_INCLNAME   LIKE SY-REPID.

  DATA : LT_FCAT       TYPE  LVC_T_FCAT.

  CLEAR: LV_PROG_NAME, LV_INCLNAME.
  LV_PROG_NAME = SY-REPID.
  LV_INCLNAME  = SY-REPID.

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      I_PROGRAM_NAME         = LV_PROG_NAME
      I_INCLNAME             = LV_INCLNAME
      I_CLIENT_NEVER_DISPLAY = 'X'
      I_INTERNAL_TABNAME     = 'GT_DISP2'
    CHANGING
      CT_FIELDCAT            = LT_SLIS_FCAT
   EXCEPTIONS
     INCONSISTENT_INTERFACE  = 1
     PROGRAM_ERROR           = 2
     OTHERS                  = 3.

  CALL FUNCTION 'LVC_TRANSFER_FROM_SLIS'
    EXPORTING
      IT_FIELDCAT_ALV = LT_SLIS_FCAT
    IMPORTING
      ET_FIELDCAT_LVC = LT_FCAT
    TABLES
      IT_DATA         = GT_DISP2
    EXCEPTIONS
      IT_DATA_MISSING = 1
      OTHERS          = 2.

  CALL FUNCTION 'LVC_FIELDCAT_COMPLETE'
    CHANGING
      CT_FIELDCAT = LT_FCAT.

  CLEAR: PT_FCAT[].
  PT_FCAT[] = LT_FCAT[].

  LOOP AT PT_FCAT ASSIGNING FIELD-SYMBOL(<LFS_FCAT>).
    <LFS_FCAT>-OUTPUTLEN = 12.
    <LFS_FCAT>-KEY       = SPACE.
    CASE <LFS_FCAT>-FIELDNAME.
      WHEN 'PONUM'.
        <LFS_FCAT>-COL_POS = 1.
        <LFS_FCAT>-COLTEXT = '구매오더 문서번호'.
        <LFS_FCAT>-JUST    = 'C'.
      WHEN 'EBELP'.
        <LFS_FCAT>-COL_POS = 2.
        <LFS_FCAT>-COLTEXT = '품목번호'.
        <LFS_FCAT>-JUST    = 'C'.
        <LFS_FCAT>-OUTPUTLEN = 5.
      WHEN 'ARIVDATE'.
        <LFS_FCAT>-COL_POS = 3.
        <LFS_FCAT>-COLTEXT = '입고 예정일'.
        <LFS_FCAT>-JUST    = 'C'.
      WHEN 'MATNR'.
        <LFS_FCAT>-COL_POS = 4.
        <LFS_FCAT>-COLTEXT = '자재코드'.
        <LFS_FCAT>-JUST    = 'C'.
      WHEN 'MAKTX'.
        <LFS_FCAT>-COL_POS = 5.
        <LFS_FCAT>-COLTEXT = '자재코드 내역'.
        <LFS_FCAT>-OUTPUTLEN = 15.
      WHEN 'WERKS'.
        <LFS_FCAT>-COL_POS = 6.
        <LFS_FCAT>-COLTEXT = '플랜트'.
        <LFS_FCAT>-JUST    = 'C'.
        <LFS_FCAT>-OUTPUTLEN = 5.
      WHEN 'MENGE'.
        <LFS_FCAT>-COL_POS = 7.
        <LFS_FCAT>-COLTEXT = '수량'.
        <LFS_FCAT>-DO_SUM  = 'X'.
*        <LFS_FCAT>-OUTPUTLEN = 5.
      WHEN 'MEINS'.
        <LFS_FCAT>-COL_POS = 8.
        <LFS_FCAT>-COLTEXT = '단위'.
        <LFS_FCAT>-JUST    = 'C'.
        <LFS_FCAT>-OUTPUTLEN = 5.
      WHEN 'WRBTR'.
        <LFS_FCAT>-COL_POS = 9.
        <LFS_FCAT>-COLTEXT = '구매 단가'.
        <LFS_FCAT>-DO_SUM  = 'X'.
        <LFS_FCAT>-OUTPUTLEN = 18.
      WHEN 'WAERS'.
        <LFS_FCAT>-COL_POS = 10.
        <LFS_FCAT>-COLTEXT = '통화'.
        <LFS_FCAT>-JUST    = 'C'.
        <LFS_FCAT>-OUTPUTLEN = 5.

      WHEN 'MBLNR'.
        <LFS_FCAT>-COL_POS = 11.
        <LFS_FCAT>-COLTEXT = '입고 자재문서'.
        <LFS_FCAT>-JUST    = 'C'.
      WHEN 'MBGNO'.
        <LFS_FCAT>-COL_POS = 12.
        <LFS_FCAT>-COLTEXT = '품목번호'.
        <LFS_FCAT>-JUST    = 'C'.
        <LFS_FCAT>-OUTPUTLEN = 5.
      WHEN 'GJAHR'.
        <LFS_FCAT>-COL_POS = 13.
        <LFS_FCAT>-COLTEXT = '회계연도'.
        <LFS_FCAT>-JUST    = 'C'.
        <LFS_FCAT>-OUTPUTLEN = 5.

      WHEN 'BUDAT'.
        <LFS_FCAT>-COL_POS = 14.
        <LFS_FCAT>-COLTEXT = '전기일자'.
        <LFS_FCAT>-JUST    = 'C'.

      WHEN 'BELNR'.
        <LFS_FCAT>-COL_POS = 14.
        <LFS_FCAT>-COLTEXT = '송장문서번호'.
        <LFS_FCAT>-HOTSPOT = 'X'.
        <LFS_FCAT>-JUST    = 'C'.
      WHEN 'ICON'.
        <LFS_FCAT>-COL_POS = 15.
        <LFS_FCAT>-COLTEXT = '문서생성상태'.
        <LFS_FCAT>-JUST    = 'C'.
      WHEN OTHERS.
        <LFS_FCAT>-TECH = 'X'.
    ENDCASE.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_LAYOUT2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GS_LAYO2
*&---------------------------------------------------------------------*
FORM SET_LAYOUT2 CHANGING PS_LAYO TYPE LVC_S_LAYO.

  CLEAR: PS_LAYO.
  PS_LAYO-NO_ROWINS  = 'X'.
  PS_LAYO-NO_ROWMOVE = 'X'.
  PS_LAYO-SEL_MODE   = 'A'.
  PS_LAYO-ZEBRA      = 'X'.
*  PS_LAYO-CWIDTH_OPT = 'A'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_SORT2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GT_SORT2
*&---------------------------------------------------------------------*
FORM SET_SORT2  CHANGING PT_SORT TYPE LVC_T_SORT.

  DATA : LS_SORT TYPE LVC_S_SORT.

  CLEAR: LS_SORT.
  LS_SORT-SPOS      = 1.
  LS_SORT-FIELDNAME = 'PONUM'.
  LS_SORT-UP        = 'X'.
  LS_SORT-SUBTOT    = 'X'.
  APPEND LS_SORT TO PT_SORT.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_GRID_FIRST_DISPLAY2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_GRID_FIRST_DISPLAY2 .

  CALL METHOD GO_GRID2->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
      IS_LAYOUT                     = GS_LAYO2
    CHANGING
      IT_OUTTAB                     = GT_DISP2[]
      IT_FIELDCATALOG               = GT_FCAT2[]
      IT_SORT                       = GT_SORT2[]
    EXCEPTIONS
      INVALID_PARAMETER_COMBINATION = 1
      PROGRAM_ERROR                 = 2
      TOO_MANY_LINES                = 3
      OTHERS                        = 4.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SAVE_RTN
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SAVE_RTN .

  IF GT_DISP1[] IS INITIAL OR
     GT_DISP2[] IS INITIAL.
     MESSAGE '저장할 데이터를 확인하세요.' TYPE 'I' DISPLAY LIKE 'E'.
     EXIT.
  ENDIF.

  DATA:  LV_COL     TYPE  SY-CUCOL.
  DATA:  LV_ROW     TYPE  SY-CUROW.
  DATA : LV_ANSWER  TYPE  C.
  CALL FUNCTION 'POPUP_TO_CONFIRM_WITH_MESSAGE'
    EXPORTING
      DEFAULTOPTION        = 'N'
      DIAGNOSETEXT1        = '구매오더별 송장문서가 생성됩니다.'
      DIAGNOSETEXT2        = '생성하시겠습니까?'
      DIAGNOSETEXT3        = '(송장 문서번호는 자동 채번됩니다.)'
      TEXTLINE1            = '  '
      TEXTLINE2            = '  '
      TITEL                = '송장문서 생성 팝업'
      START_COLUMN         = 50
      START_ROW            = 6
      CANCEL_DISPLAY       = ' '
    IMPORTING
      ANSWER               = LV_ANSWER.
  IF LV_ANSWER NE 'J'.
    MESSAGE '취소되었습니다.' TYPE 'S'.
    EXIT.
  ENDIF.

  READ TABLE GT_DISP2
  WITH KEY ICON = SPACE.
  IF SY-SUBRC NE 0.
    MESSAGE '처리할 데이터가 없습니다.' TYPE 'I' DISPLAY LIKE 'E'.
    EXIT.
  ENDIF.

  PERFORM MAKE_INVOICE_DATA.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_LIFR_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM GET_LIFR_DATA .

 "공급업체 입력
  IF ZEA_LFA1-VENCODE IS NOT INITIAL.
    SELECT SINGLE *
      INTO @DATA(LS_LFA1)
      FROM ZEA_LFA1
      WHERE VENCODE EQ @ZEA_LFA1-VENCODE.
    IF SY-SUBRC NE 0.
      ZEA_LFA1-BPVEN = '공급업체 코드를 확인하세요.'.
      EXIT.
    ENDIF.

*** "통화
    SELECT SINGLE WAERS1
      FROM ZEA_MMT050
      WHERE VENCODE EQ @P_LIFNR
      INTO @DATA(LV_WAERS).
    ZEA_MMT160-WAERS = LV_WAERS.
    ZEA_MMT150-WAERS = LV_WAERS.
    ZEA_MMT100-WAERS1 = LV_WAERS.
    GV_WAERS2        = LV_WAERS.
    GV_WAERS3        = LV_WAERS.

    ZEA_LFA1-BPVEN  = LS_LFA1-BPVEN.  "공급업체 내역
    ZEA_LFA1-BPCSNR = LS_LFA1-BPCSNR. "공급업체 사업자번호
    ZEA_LFA1-BPADRR = LS_LFA1-BPADRR. "공급업체 주소

*   ZEA_LFA1-ACCNT     = LS_LFA1-ACCNT.     "계좌번호
    ZEA_BKNA-BANKCODE  = LS_LFA1-BANKCODE.  "은행코드
    SELECT SINGLE BPBANK
      INTO @ZEA_BKNA-BPBANK
      FROM ZEA_BKNA
     WHERE BANKCODE EQ @ZEA_BKNA-BANKCODE.

    SELECT SINGLE ACCNT
      INTO @ZEA_BKNA-ACCNT
      FROM ZEA_BKNA
     WHERE BANKCODE EQ @ZEA_BKNA-BANKCODE.


    ZEA_LFA1-ZLSCH  = LS_LFA1-ZLSCH.  "공급업체 지급조건
    IF ZEA_LFA1-ZLSCH IS NOT INITIAL.
      SELECT SINGLE ZLTXT "지급조건 내역
        INTO @ZEA_TVZBT-ZLTXT
        FROM ZEA_TVZBT
       WHERE ZLSCH EQ @ZEA_LFA1-ZLSCH.
    ENDIF.

    ZEA_LFA1-SAKNR  = LS_LFA1-SAKNR.  "G/L 계정
    IF ZEA_LFA1-SAKNR IS NOT INITIAL.
      SELECT SINGLE GLTXT
        INTO @ZEA_SKB1-GLTXT
        FROM ZEA_SKB1
        WHERE BUKRS EQ @P_BUKRS
        AND   SAKNR EQ @ZEA_LFA1-SAKNR.
      IF SY-SUBRC NE 0.
        ZEA_SKB1-GLTXT = 'G/L계정 마스터를 확인하세요.'.
      ENDIF.
    ENDIF.

  ELSE.

   "화면 입력값 모두 Clear
    CLEAR: ZEA_LFA1-BPVEN,  ZEA_LFA1-BPVEN, ZEA_LFA1-BPCSNR,
           ZEA_LFA1-BPADRR, ZEA_LFA1-ZLSCH, ZEA_TVZBT-ZLTXT,
           ZEA_LFA1-SAKNR,  ZEA_SKB1-GLTXT.

  ENDIF.

ENDFORM.
