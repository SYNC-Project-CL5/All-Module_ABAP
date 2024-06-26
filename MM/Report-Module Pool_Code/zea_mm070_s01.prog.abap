*&---------------------------------------------------------------------*
*& Include          ZEA_MM070_S01
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
*   -------------------------------------------------------------------
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.

*   -------------------------------------------------------------------
    WHEN 'CHANGE'.
      PERFORM CHANGE_RTN.

*   -------------------------------------------------------------------
    WHEN 'DISPLAY'.
      PERFORM DISPLAY_RTN.

*   -------------------------------------------------------------------
    WHEN 'REFRESH'.
      PERFORM REFRESH_RTN.

*   -------------------------------------------------------------------
    WHEN 'GOIV'.
      CALL TRANSACTION 'ZEA_MM080'.

*   -------------------------------------------------------------------
    WHEN OTHERS.
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
*   -------------------------------------------------------------------
    WHEN 'EXIT'.
      LEAVE TO SCREEN 0.

*   -------------------------------------------------------------------
    WHEN 'CANC'.
      LEAVE TO SCREEN 0.

*   -------------------------------------------------------------------
    WHEN OTHERS.
  ENDCASE.
  CLEAR: OK_CODE.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE INIT_0100 OUTPUT.

  IF GO_CONTAINER1 IS INITIAL.

    PERFORM CREATE_OBJECT1.
    PERFORM CREATE_ALV_OBJ1.

  ELSE.

    PERFORM REFRESH_TABLE_DISPLAY.

  ENDIF.

  IF GO_CONTAINER IS INITIAL.

    PERFORM CREATE_OBJECT2.
    PERFORM CREATE_ALV_OBJ2.

    PERFORM CREATE_OBJECT3.
    PERFORM CREATE_ALV_OBJ3.

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
  EXPORTING CONTAINER_NAME = 'CON1'.

  CREATE OBJECT GO_GRID1
  EXPORTING I_PARENT = GO_CONTAINER1.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_ALV_OBJ1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CREATE_ALV_OBJ1 .

*-----------------------------------------------*
  PERFORM SET_FIELDCAT CHANGING GT_FCAT1.
  PERFORM SET_LAYOUT   CHANGING GS_LAYO1.
  PERFORM SET_SORT     CHANGING GT_SORT1.
  PERFORM SET_GRID_EVENT_RECEIVER1.
  PERFORM SET_GRID_FIRST_DISPLAY1.
*-----------------------------------------------*

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_FIELDCAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GT_FCAT1
*&---------------------------------------------------------------------*
FORM SET_FIELDCAT  CHANGING PT_FCAT TYPE LVC_T_FCAT.

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
*    <LFS_FCAT>-OUTPUTLEN = 12.
    <LFS_FCAT>-KEY       = SPACE.
    CASE <LFS_FCAT>-FIELDNAME.
      WHEN 'ICON'.
        <LFS_FCAT>-COL_POS   = 1.
        <LFS_FCAT>-COLTEXT   = '상태'.
        <LFS_FCAT>-OUTPUTLEN = 3.
        <LFS_FCAT>-JUST      = 'C'.
      WHEN 'PONUM'.
        <LFS_FCAT>-COL_POS   = 2.
        <LFS_FCAT>-COLTEXT = '구매오더번호'.
        <LFS_FCAT>-KEY     = 'X'.
        <LFS_FCAT>-HOTSPOT = 'X'.
       <LFS_FCAT>-OUTPUTLEN = 10.
        <LFS_FCAT>-JUST      = 'C'.
      WHEN 'EBELP'.
        <LFS_FCAT>-COL_POS   = 3.
        <LFS_FCAT>-COLTEXT = '품목번호'.
        <LFS_FCAT>-JUST    = 'C'.
        <LFS_FCAT>-KEY     = 'X'.
        <LFS_FCAT>-OUTPUTLEN = 6.
        <LFS_FCAT>-JUST      = 'C'.
      WHEN 'BANFN'.
        <LFS_FCAT>-COL_POS   = 4.
        <LFS_FCAT>-COLTEXT = '구매요청'.
        <LFS_FCAT>-EMPHASIZE = 'C310'.
        <LFS_FCAT>-JUST    = 'C'.
        <LFS_FCAT>-OUTPUTLEN = 8.
      WHEN 'MATNR'.
        <LFS_FCAT>-COLTEXT = '자재코드'.
        <LFS_FCAT>-JUST    = 'C'.
        <LFS_FCAT>-OUTPUTLEN = 8.
      WHEN 'VENCODE'.
        <LFS_FCAT>-COLTEXT = '공급업체'.
        <LFS_FCAT>-JUST    = 'C'.
        <LFS_FCAT>-OUTPUTLEN = 5.
      WHEN 'INFO_NO'.
        <LFS_FCAT>-COLTEXT = '정보레코드'.
        <LFS_FCAT>-JUST    = 'C'.
        <LFS_FCAT>-OUTPUTLEN = 8.
      WHEN 'WERKS'.
        <LFS_FCAT>-COLTEXT = '플랜트'.
        <LFS_FCAT>-JUST    = 'C'.
        <LFS_FCAT>-OUTPUTLEN = 5.
      WHEN 'LGORT'.
        <LFS_FCAT>-COLTEXT = '저장위치'.
        <LFS_FCAT>-JUST    = 'C'.
        <LFS_FCAT>-OUTPUTLEN = 5.
      WHEN 'CALQTY'.
        <LFS_FCAT>-COLTEXT = '오더 수량'.
        <LFS_FCAT>-DO_SUM  = 'X'.
        <LFS_FCAT>-OUTPUTLEN = 10.
      WHEN 'MEINS'.
        <LFS_FCAT>-COLTEXT = '오더 단위'.
        <LFS_FCAT>-JUST      = 'C'.
        <LFS_FCAT>-OUTPUTLEN = 6.

      WHEN 'DMBTR'.
        <LFS_FCAT>-COLTEXT = '금액'.
        <LFS_FCAT>-DO_SUM  = 'X'.
        <LFS_FCAT>-OUTPUTLEN = 13.
      WHEN 'WAERS'.
        <LFS_FCAT>-COLTEXT = '통화'.
        <LFS_FCAT>-JUST = 'C'.
        <LFS_FCAT>-OUTPUTLEN = 5.
      WHEN OTHERS.
        <LFS_FCAT>-TECH = 'X'.


    ENDCASE.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_LAYOUT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GS_LAYO1
*&---------------------------------------------------------------------*
FORM SET_LAYOUT  CHANGING PS_LAYO TYPE LVC_S_LAYO.

  CLEAR: PS_LAYO.
  PS_LAYO-NO_ROWINS  = 'X'.
  PS_LAYO-NO_ROWMOVE = 'X'.
  PS_LAYO-SEL_MODE   = 'D'.
  PS_LAYO-STYLEFNAME = 'CELL_STYLE'.
*  PS_LAYO-CWIDTH_OPT = 'A'.

  DATA : LV_TITLE TYPE LVC_TITLE.
  DATA(LV_CNT) = LINES( GT_DISP1 ).
  LV_TITLE = '구매오더: ' && LV_CNT && '건'.
  PS_LAYO-GRID_TITLE = LV_TITLE.

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
    PERFORM SET_FIELDCAT CHANGING GT_FCAT1.
    CALL METHOD GO_GRID1->SET_FRONTEND_FIELDCATALOG
    EXPORTING IT_FIELDCATALOG = GT_FCAT1.

    CLEAR: GS_LAYO1.
    PERFORM SET_LAYOUT   CHANGING GS_LAYO1.
    CALL METHOD GO_GRID1->SET_FRONTEND_LAYOUT
    EXPORTING IS_LAYOUT = GS_LAYO1.

    CALL METHOD GO_GRID1->REFRESH_TABLE_DISPLAY
    EXPORTING IS_STABLE = LS_STBL.
  ENDIF.

  IF GO_GRID2 IS NOT INITIAL.
    CLEAR: GT_FCAT2[].
    PERFORM SET_FIELDCAT2 CHANGING GT_FCAT2.
    CALL METHOD GO_GRID1->SET_FRONTEND_FIELDCATALOG
    EXPORTING IT_FIELDCATALOG = GT_FCAT2.

    CLEAR: GS_LAYO2.
    PERFORM SET_LAYOUT2   CHANGING GS_LAYO2.
    CALL METHOD GO_GRID2->SET_FRONTEND_LAYOUT
    EXPORTING IS_LAYOUT = GS_LAYO2.

    CALL METHOD GO_GRID2->REFRESH_TABLE_DISPLAY
    EXPORTING IS_STABLE = LS_STBL.
  ENDIF.

  IF GO_GRID3 IS NOT INITIAL.
    CLEAR: GT_FCAT3[].
    PERFORM SET_FIELDCAT3 CHANGING GT_FCAT3.
    CALL METHOD GO_GRID3->SET_FRONTEND_FIELDCATALOG
    EXPORTING IT_FIELDCATALOG = GT_FCAT3.

    CLEAR: GS_LAYO3.
    PERFORM SET_LAYOUT3   CHANGING GS_LAYO3.
    CALL METHOD GO_GRID3->SET_FRONTEND_LAYOUT
    EXPORTING IS_LAYOUT = GS_LAYO3.

    CALL METHOD GO_GRID3->REFRESH_TABLE_DISPLAY
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

  CREATE OBJECT GO_CONTAINER
  EXPORTING CONTAINER_NAME  = 'CON2'.

  CREATE OBJECT GO_SPLITTER
  EXPORTING PARENT  = GO_CONTAINER
            ROWS    = 2
            COLUMNS = 1.

  CALL METHOD GO_SPLITTER->SET_ROW_HEIGHT
  EXPORTING ID    = 1
            HEIGHT = 47.

  CALL METHOD GO_SPLITTER->GET_CONTAINER
  EXPORTING ROW    = 1
            COLUMN = 1
  RECEIVING CONTAINER = GO_ALV_CON2.

  CREATE OBJECT GO_GRID2
  EXPORTING I_PARENT = GO_ALV_CON2.

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
  PERFORM SET_GRID_EVENT_RECEIVER2.
  PERFORM SET_GRID_FIRST_DISPLAY2.
*-----------------------------------------------*

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
      WHEN 'ICON'.
        <LFS_FCAT>-COLTEXT = '오더생성 상태'.
        <LFS_FCAT>-JUST    = 'C'.
        <LFS_FCAT>-OUTPUTLEN = 8.
      WHEN 'BANFN'.
        <LFS_FCAT>-COLTEXT = '구매요청번호'.
        <LFS_FCAT>-KEY     = ' '.
        <LFS_FCAT>-EMPHASIZE = 'C310'.
        <LFS_FCAT>-JUST      = 'C'.
      WHEN 'BNFPO'.
        <LFS_FCAT>-COLTEXT = '품목번호'.
        <LFS_FCAT>-KEY     = ' '.
        <LFS_FCAT>-JUST    = 'C'.
        <LFS_FCAT>-OUTPUTLEN = 6.
      WHEN 'INFO_NO'.
        <LFS_FCAT>-COLTEXT = '정보레코드'.
        <LFS_FCAT>-JUST    = 'C'.
      WHEN 'WERKS'.
        <LFS_FCAT>-COLTEXT = '플랜트'.
        <LFS_FCAT>-JUST    = 'C'.
      WHEN 'MRPID'.
        <LFS_FCAT>-COLTEXT = 'MRP 결과'.
        <LFS_FCAT>-JUST    = 'C'.
      WHEN 'MATNR'.
        <LFS_FCAT>-COLTEXT = '자재코드'.
        <LFS_FCAT>-JUST    = 'C'.
      WHEN 'MENGE'.
        <LFS_FCAT>-COLTEXT = '요청 수량'.
        <LFS_FCAT>-OUTPUTLEN = 15.
      WHEN 'MEINS'.
        <LFS_FCAT>-COLTEXT = '요청 단위'.
        <LFS_FCAT>-JUST = 'C'.
      WHEN 'SCODE'.
        <LFS_FCAT>-COLTEXT = '저장위치'.
        <LFS_FCAT>-JUST    = 'C'.
      WHEN OTHERS.
        <LFS_FCAT>-TECH    = 'X'.
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
FORM SET_LAYOUT2  CHANGING PS_LAYO TYPE LVC_S_LAYO.

  CLEAR: PS_LAYO.
  PS_LAYO-NO_ROWINS  = 'X'.
  PS_LAYO-NO_ROWMOVE = 'X'.
  PS_LAYO-SEL_MODE   = 'D'.
  PS_LAYO-CWIDTH_OPT = 'A'.

  DATA : LV_TITLE TYPE LVC_TITLE.
  DATA(LV_CNT) = LINES( GT_DISP2 ).
  LV_TITLE = '구매요청:' && LV_CNT && '건'.
  PS_LAYO-GRID_TITLE = LV_TITLE.

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
*& Form SET_FIELDCAT3
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GT_FCAT3
*&---------------------------------------------------------------------*
FORM SET_FIELDCAT3  CHANGING PT_FCAT TYPE LVC_T_FCAT.

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
      I_INTERNAL_TABNAME     = 'GT_DISP3'
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
      IT_DATA         = GT_DISP3
    EXCEPTIONS
      IT_DATA_MISSING = 1
      OTHERS          = 2.

  CALL FUNCTION 'LVC_FIELDCAT_COMPLETE'
    CHANGING
      CT_FIELDCAT = LT_FCAT.

  CLEAR: PT_FCAT[].
  PT_FCAT[] = LT_FCAT[].

  LOOP AT PT_FCAT ASSIGNING FIELD-SYMBOL(<LFS_FCAT>).
    <LFS_FCAT>-KEY       = SPACE.
    CASE <LFS_FCAT>-FIELDNAME.
      WHEN 'LIGHT'.
        <LFS_FCAT>-COL_POS   = 1.
        <LFS_FCAT>-COLTEXT   = '상태'.
        <LFS_FCAT>-OUTPUTLEN = 5.
        <LFS_FCAT>-JUST      = 'C'.
      WHEN 'LV_PERCENT'.
        <LFS_FCAT>-COL_POS   = 2.
        <LFS_FCAT>-COLTEXT   = '현 재고 비율'.
        <LFS_FCAT>-OUTPUTLEN = 8.
        <LFS_FCAT>-JUST      = 'C'.
      WHEN 'MATNR'.
        <LFS_FCAT>-COL_POS = 2.
        <LFS_FCAT>-COLTEXT = '자재코드'.
        <LFS_FCAT>-OUTPUTLEN = 9.
        <LFS_FCAT>-JUST      = 'C'.
      WHEN 'MAKTX'.
        <LFS_FCAT>-COL_POS = 3.
        <LFS_FCAT>-COLTEXT = '자재명'.
        <LFS_FCAT>-OUTPUTLEN = 8.
      WHEN 'WERKS'.
        <LFS_FCAT>-COL_POS = 4.
        <LFS_FCAT>-COLTEXT = '플랜트'.
        <LFS_FCAT>-OUTPUTLEN = 5.
        <LFS_FCAT>-JUST      = 'C'.
      WHEN 'SCODE'.
        <LFS_FCAT>-COL_POS = 5.
        <LFS_FCAT>-COLTEXT = '저장위치'.
        <LFS_FCAT>-OUTPUTLEN = 6.
        <LFS_FCAT>-JUST      = 'C'.
      WHEN 'CALQTY'.
        <LFS_FCAT>-COL_POS = 6.
        <LFS_FCAT>-COLTEXT = '재고수량(EA)'.
        <LFS_FCAT>-OUTPUTLEN = 10.
      WHEN 'MEINS'.
        <LFS_FCAT>-COL_POS = 7.
        <LFS_FCAT>-COLTEXT = '단위'.
        <LFS_FCAT>-OUTPUTLEN = 4.
        <LFS_FCAT>-JUST      = 'C'.
***      WHEN 'WEIGHT'.
***        <LFS_FCAT>-COL_POS = 8.
***        <LFS_FCAT>-COLTEXT = '재고수량(KG)'.
***        <LFS_FCAT>-OUTPUTLEN = 10.
***      WHEN 'MEINS2'.
***        <LFS_FCAT>-COL_POS = 9.
***        <LFS_FCAT>-COLTEXT = '단위'.
***        <LFS_FCAT>-OUTPUTLEN = 4.
***        <LFS_FCAT>-JUST      = 'C'.
      WHEN 'SAFSTK'.
        <LFS_FCAT>-COL_POS = 10.
        <LFS_FCAT>-COLTEXT = '안전재고'.
        <LFS_FCAT>-OUTPUTLEN = 8.
        <LFS_FCAT>-EMPHASIZE = 'C510'.
      WHEN 'MEINS3'.
        <LFS_FCAT>-COL_POS = 11.
        <LFS_FCAT>-COLTEXT = '단위'.
        <LFS_FCAT>-OUTPUTLEN = 4.
        <LFS_FCAT>-JUST      = 'C'.
        <LFS_FCAT>-EMPHASIZE = 'C510'.
      WHEN OTHERS.
        <LFS_FCAT>-TECH = 'X'.
    ENDCASE.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_LAYOUT3
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GS_LAYO3
*&---------------------------------------------------------------------*
FORM SET_LAYOUT3  CHANGING PS_LAYO TYPE LVC_S_LAYO.

  CLEAR: PS_LAYO.
  PS_LAYO-NO_ROWINS  = 'X'.
  PS_LAYO-NO_ROWMOVE = 'X'.
  PS_LAYO-SEL_MODE   = 'D'.
*  PS_LAYO-CWIDTH_OPT = 'A'.
  PS_LAYO-ZEBRA      = 'X'.
  PS_LAYO-EXCP_FNAME = 'LIGHT'.
*
  DATA : LV_TITLE TYPE LVC_TITLE.
  DATA(LV_CNT) = LINES( GT_DISP3 ).
  LV_TITLE = '원재료 재고 현황:'  && LV_CNT && '건'.
  PS_LAYO-GRID_TITLE = LV_TITLE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_GRID_FIRST_DISPLAY3
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_GRID_FIRST_DISPLAY3 .

  CALL METHOD GO_GRID3->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
      IS_LAYOUT                     = GS_LAYO3
    CHANGING
      IT_OUTTAB                     = GT_DISP3[]
      IT_FIELDCATALOG               = GT_FCAT3[]
      IT_SORT                       = GT_SORT3[]
    EXCEPTIONS
      INVALID_PARAMETER_COMBINATION = 1
      PROGRAM_ERROR                 = 2
      TOO_MANY_LINES                = 3
      OTHERS                        = 4.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT3
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT3 .

  CALL METHOD GO_SPLITTER->GET_CONTAINER
  EXPORTING ROW    = 2
            COLUMN = 1
  RECEIVING CONTAINER = GO_ALV_CON3.

*  CALL METHOD GO_SPLITTER->SET_COLUMN_WIDTH
*  EXPORTING ID    = 2
*            WIDTH = 57.

  CREATE OBJECT GO_GRID3
  EXPORTING I_PARENT = GO_ALV_CON3.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_ALV_OBJ3
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CREATE_ALV_OBJ3 .

*-----------------------------------------------*
  PERFORM SET_FIELDCAT3 CHANGING GT_FCAT3.
  PERFORM SET_LAYOUT3   CHANGING GS_LAYO3.
  PERFORM SET_SORT3     CHANGING GT_SORT3.
  PERFORM SET_GRID_EVENT_RECEIVER3.
  PERFORM SET_GRID_FIRST_DISPLAY3.
*-----------------------------------------------*

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_SORT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GT_SORT1
*&---------------------------------------------------------------------*
FORM SET_SORT  CHANGING PT_SORT TYPE LVC_T_SORT.

  DATA : LS_SORT TYPE LVC_S_SORT.

  CLEAR: LS_SORT.
  LS_SORT-SPOS      = 1.
  LS_SORT-FIELDNAME = 'PONUM'.
  LS_SORT-UP        = 'X'.
  LS_SORT-SUBTOT    = 'X'.
  APPEND LS_SORT TO PT_SORT.

  CLEAR: LS_SORT.
  LS_SORT-SPOS      = 2.
  LS_SORT-FIELDNAME = 'EBELP'.
  LS_SORT-UP        = 'X'.
  APPEND LS_SORT TO PT_SORT.

  CLEAR: LS_SORT.
  LS_SORT-SPOS      = 3.
  LS_SORT-FIELDNAME = 'BANFN'.
  LS_SORT-UP        = 'X'.
  APPEND LS_SORT TO PT_SORT.

  CLEAR: LS_SORT.
  LS_SORT-SPOS      = 4.
  LS_SORT-FIELDNAME = 'CALQTY'.
*  LS_SORT-SUBTOT    = 'X'.
  APPEND LS_SORT TO PT_SORT.

  SORT PT_SORT BY FIELDNAME.

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
  LS_SORT-FIELDNAME = 'BANFN'.
  LS_SORT-UP        = 'X'.
  APPEND LS_SORT TO PT_SORT.

  SORT PT_SORT BY FIELDNAME.

ENDFORM.
*&---------------------------------------------------------------------*
*& Module STATUS_0110 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE STATUS_0110 OUTPUT.

  SET PF-STATUS 'S0110'.
  SET TITLEBAR  'T0110'.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0110  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0110 INPUT.

  CASE OK_CODE.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
  ENDCASE.
  CLEAR: OK_CODE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT_0110  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE EXIT_0110 INPUT.

  CASE OK_CODE.
    WHEN 'EXIT' OR 'CANC'.
      LEAVE TO SCREEN 0.
  ENDCASE.
  CLEAR: OK_CODE.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Form SET_GRID_EVENT_RECEIVER1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_GRID_EVENT_RECEIVER1.

  CREATE OBJECT LCL_EVENT_RECEIVER.

  SET HANDLER:
  LCL_EVENT_RECEIVER->HANDLE_HOTSPOT_CLICK1 FOR GO_GRID1,
  LCL_EVENT_RECEIVER->HANDLE_TOOLBAR1       FOR GO_GRID1,
  LCL_EVENT_RECEIVER->HANDLE_USER_COMMAND1  FOR GO_GRID1.

ENDFORM.
*&---------------------------------------------------------------------*
*& Module INIT_0110 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE INIT_0110 OUTPUT.

  IF GO_CONTAINER4 IS INITIAL.

    CREATE OBJECT GO_CONTAINER4
    EXPORTING CONTAINER_NAME = 'CON4'.
    CREATE OBJECT GO_GRID4
    EXPORTING I_PARENT = GO_CONTAINER4.

    PERFORM SET_FIELDCAT4 CHANGING GT_FCAT4.
    PERFORM SET_LAYOUT4   CHANGING GS_LAYO4.
    PERFORM SET_SORT4     CHANGING GT_SORT4.
    PERFORM SET_GRID_EVENT_RECEIVER4.
    PERFORM SET_GRID_FIRST_DISPLAY4.
    PERFORM SET_GRID_SUBTOTAL4.

  ELSE.

    PERFORM REFRESH_TABLE_DISPLAY4.

  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Form SET_FIELDCAT4
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GT_FCAT4
*&---------------------------------------------------------------------*
FORM SET_FIELDCAT4  CHANGING PT_FCAT TYPE LVC_T_FCAT.

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
      I_INTERNAL_TABNAME     = 'GT_DISP4'
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
      IT_DATA         = GT_DISP4
    EXCEPTIONS
      IT_DATA_MISSING = 1
      OTHERS          = 2.

  CALL FUNCTION 'LVC_FIELDCAT_COMPLETE'
    CHANGING
      CT_FIELDCAT = LT_FCAT.

  CLEAR: PT_FCAT[].
  PT_FCAT[] = LT_FCAT[].

  LOOP AT PT_FCAT ASSIGNING FIELD-SYMBOL(<LFS_FCAT>).
    <LFS_FCAT>-KEY     = ' '.
    CASE <LFS_FCAT>-FIELDNAME.
WHEN 'TEXT'.
        <LFS_FCAT>-COL_POS   = 1.
        <LFS_FCAT>-COLTEXT   = '내역'.
        <LFS_FCAT>-OUTPUTLEN = 5.
        <LFS_FCAT>-JUST      = 'L'.
WHEN 'ZLSCHYN'.
        <LFS_FCAT>-COL_POS   = 2.
        <LFS_FCAT>-COLTEXT   = '지급여부'.
        <LFS_FCAT>-OUTPUTLEN = 5.
        <LFS_FCAT>-JUST      = 'C'.
WHEN 'GJAHR'.
        <LFS_FCAT>-COL_POS   = 3.
        <LFS_FCAT>-COLTEXT   = '회계연도'.
        <LFS_FCAT>-OUTPUTLEN = 6.
        <LFS_FCAT>-JUST      = 'C'.
WHEN 'MBLNR'.
        <LFS_FCAT>-COL_POS = 4.
        <LFS_FCAT>-COLTEXT = '문서번호'.
        <LFS_FCAT>-OUTPUTLEN = 12.
        <LFS_FCAT>-JUST      = 'C'.
WHEN 'MBGNO'.
        <LFS_FCAT>-COL_POS = 5.
        <LFS_FCAT>-COLTEXT = '품목번호'.
        <LFS_FCAT>-OUTPUTLEN = 6.
        <LFS_FCAT>-JUST      = 'C'.
WHEN 'BWART'.
        <LFS_FCAT>-COL_POS = 6.
        <LFS_FCAT>-COLTEXT = '이동유형'.
        <LFS_FCAT>-OUTPUTLEN = 7.
        <LFS_FCAT>-JUST      = 'C'.
WHEN 'GRUND'.
        <LFS_FCAT>-COL_POS = 7.
        <LFS_FCAT>-COLTEXT = '이동사유'.
        <LFS_FCAT>-OUTPUTLEN = 10.
WHEN 'MATNR'.
        <LFS_FCAT>-COL_POS = 8.
        <LFS_FCAT>-COLTEXT = '자재코드'.
        <LFS_FCAT>-OUTPUTLEN = 10.
        <LFS_FCAT>-JUST      = 'C'.
WHEN 'PONUM'.
        <LFS_FCAT>-COL_POS = 9.
        <LFS_FCAT>-COLTEXT = '구매오더'.
        <LFS_FCAT>-OUTPUTLEN = 10.
        <LFS_FCAT>-JUST      = 'C'.
**WHEN 'PLANTFR'.
**        <LFS_FCAT>-COL_POS = 10.
**        <LFS_FCAT>-COLTEXT = 'From플랜트'.
**        <LFS_FCAT>-OUTPUTLEN = 8.
**WHEN 'LGORTFR'.
**        <LFS_FCAT>-COL_POS = 11.
**        <LFS_FCAT>-COLTEXT = 'From저장위치'.
**        <LFS_FCAT>-OUTPUTLEN = 8.
WHEN 'PLANTTO'.
        <LFS_FCAT>-COL_POS = 12.
        <LFS_FCAT>-COLTEXT = '플랜트'.
        <LFS_FCAT>-OUTPUTLEN = 8.
        <LFS_FCAT>-JUST      = 'C'.
WHEN 'LGORTTO'.
        <LFS_FCAT>-COL_POS = 13.
        <LFS_FCAT>-COLTEXT = '저장위치'.
        <LFS_FCAT>-OUTPUTLEN = 8.
        <LFS_FCAT>-JUST      = 'C'.
WHEN 'MENGE'.
        <LFS_FCAT>-COL_POS = 14.
        <LFS_FCAT>-COLTEXT = '수량'.
          <LFS_FCAT>-DO_SUM  = 'X'.
        <LFS_FCAT>-OUTPUTLEN = 15.
WHEN 'MEINS'.
        <LFS_FCAT>-COL_POS = 15.
        <LFS_FCAT>-COLTEXT = '단위'.
        <LFS_FCAT>-OUTPUTLEN = 5.
        <LFS_FCAT>-JUST      = 'C'.
WHEN 'DMBTR'.
        <LFS_FCAT>-COL_POS = 16.
        <LFS_FCAT>-COLTEXT = '금액'.
          <LFS_FCAT>-DO_SUM  = 'X'.
        <LFS_FCAT>-OUTPUTLEN = 15.
WHEN 'WAERS1'.
        <LFS_FCAT>-COL_POS = 17.
        <LFS_FCAT>-COLTEXT = '통화'.
        <LFS_FCAT>-OUTPUTLEN = 5.
        <LFS_FCAT>-JUST      = 'C'.
WHEN OTHERS.
        <LFS_FCAT>-TECH = 'X'.
    ENDCASE.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_LAYOUT4
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GS_LAYO4
*&---------------------------------------------------------------------*
FORM SET_LAYOUT4  CHANGING PS_LAYO TYPE LVC_S_LAYO.

  CLEAR: PS_LAYO.
  PS_LAYO-NO_ROWINS  = 'X'.
  PS_LAYO-NO_ROWMOVE = 'X'.
  PS_LAYO-SEL_MODE   = 'D'.
*  PS_LAYO-NO_TOOLBAR = 'X'.
*  PS_LAYO-CWIDTH_OPT = 'A'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_GRID_FIRST_DISPLAY4
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_GRID_FIRST_DISPLAY4 .

  GO_GRID4->SET_TABLE_FOR_FIRST_DISPLAY(
    EXPORTING
      IS_LAYOUT                     = GS_LAYO4
    CHANGING
      IT_OUTTAB                     = GT_DISP4[]
      IT_FIELDCATALOG               = GT_FCAT4[]
      IT_SORT                       = GT_SORT4[]
    EXCEPTIONS
      INVALID_PARAMETER_COMBINATION = 1
      PROGRAM_ERROR                 = 2
      TOO_MANY_LINES                = 3
      OTHERS                        = 4         ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_GRID_EVENT_RECEIVER2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_GRID_EVENT_RECEIVER2 .

  CREATE OBJECT LCL_EVENT_RECEIVER.

  SET HANDLER:
  LCL_EVENT_RECEIVER->HANDLE_TOOLBAR2      FOR GO_GRID2,
  LCL_EVENT_RECEIVER->HANDLE_USER_COMMAND2 FOR GO_GRID2.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH_TABLE_DISPLAY4
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM REFRESH_TABLE_DISPLAY4 .

  DATA : LS_STBL TYPE LVC_S_STBL.

  CLEAR: LS_STBL.
  LS_STBL-ROW = 'X'.
  LS_STBL-COL = 'X'.

  CHECK GO_GRID4 IS NOT INITIAL.

  CLEAR: GT_FCAT4[].
  PERFORM SET_FIELDCAT4 CHANGING GT_FCAT4.
  CALL METHOD GO_GRID4->SET_FRONTEND_FIELDCATALOG
  EXPORTING IT_FIELDCATALOG = GT_FCAT4.

  CLEAR: GS_LAYO4.
  PERFORM SET_LAYOUT4   CHANGING GS_LAYO4.
  CALL METHOD GO_GRID4->SET_FRONTEND_LAYOUT
  EXPORTING IS_LAYOUT = GS_LAYO4.

  CALL METHOD GO_GRID4->REFRESH_TABLE_DISPLAY
  EXPORTING IS_STABLE = LS_STBL.

  PERFORM SET_GRID_SUBTOTAL4.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_SORT4
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GS_SORT4
*&---------------------------------------------------------------------*
FORM SET_SORT4 CHANGING PT_SORT TYPE LVC_T_SORT.

  DATA : LS_SORT TYPE LVC_S_SORT.

  CLEAR: LS_SORT.
  LS_SORT-SPOS      = 1.
  LS_SORT-FIELDNAME = 'TEXT'.
  LS_SORT-DOWN      = 'X'.
  LS_SORT-SUBTOT    = 'X'.
  APPEND LS_SORT TO PT_SORT.

  SORT PT_SORT BY FIELDNAME.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_GRID_SUBTOTAL4
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_GRID_SUBTOTAL4.

  FIELD-SYMBOLS:  <LFS_TOTAL>     LIKE LINE OF  GT_DISP4.
  FIELD-SYMBOLS:  <LFS_SUBTOTAL>  LIKE LINE OF  GT_DISP4.

  DATA : TOTAL    TYPE REF TO DATA.
  DATA : SUBTOTAL TYPE REF TO DATA.

  FIELD-SYMBOLS: <TOTAL>    LIKE GT_DISP4[].
  FIELD-SYMBOLS: <SUBTOTAL> LIKE GT_DISP4[].

  CALL METHOD GO_GRID4->GET_SUBTOTALS
    IMPORTING
      EP_COLLECT00 = TOTAL
      EP_COLLECT01 = SUBTOTAL.

  ASSIGN TOTAL->*    TO <TOTAL>.
  ASSIGN SUBTOTAL->* TO <SUBTOTAL>.

  LOOP AT <TOTAL> ASSIGNING <LFS_TOTAL>.
    <LFS_TOTAL>-MBLNR = '총계'.
  ENDLOOP.

  LOOP AT <SUBTOTAL> ASSIGNING <LFS_SUBTOTAL>.
    IF <LFS_SUBTOTAL>-TEXT CP 'WE'.
      <LFS_SUBTOTAL>-MBLNR = 'Tr./ev. 입고'.
    ELSE.
      <LFS_SUBTOTAL>-MBLNR = 'Tr./ev. 송장'.
    ENDIF.
  ENDLOOP.

  CALL METHOD GO_GRID4->REFRESH_TABLE_DISPLAY
  EXPORTING I_SOFT_REFRESH = 'X'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_GRID_EVENT_RECEIVER4
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_GRID_EVENT_RECEIVER4 .

  CREATE OBJECT LCL_EVENT_RECEIVER.

  SET HANDLER:
  LCL_EVENT_RECEIVER->HANDLE_TOOLBAR4      FOR GO_GRID4.

ENDFORM.
