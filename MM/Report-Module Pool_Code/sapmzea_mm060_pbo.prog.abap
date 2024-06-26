*&---------------------------------------------------------------------*
*& Include          SAPMZEA_MM060
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
*& Module CLEAR_OK_CODE_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE CLEAR_OK_CODE_0100 OUTPUT.

  CLEAR: OK_CODE.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ALV_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE INIT_ALV_0100 OUTPUT.

  IF GO_CONTAINER IS INITIAL.
    "Create Container
     PERFORM CREATE_OBJECT_0100.
    "Create ALV Objects
     PERFORM CREATE_ALV_OBJ_0100.
  ELSE.
    "Rrfresh Grid
     PERFORM REFRESH_TABLE_DISPLAY_0100.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT_0100 .

  CREATE OBJECT GO_CONTAINER
     EXPORTING
       CONTAINER_NAME  = 'CCON'
     EXCEPTIONS
       OTHERS          = 1.

  IF SY-SUBRC NE 0.
    MESSAGE '컨테이너 생성에 실패했습니다.' TYPE 'E'.
  ENDIF.

* Create Splitter Container
  CREATE OBJECT GO_SPLITTER
    EXPORTING
      PARENT  = GO_CONTAINER
      ROWS    = 1
      COLUMNS = 1.

* Create ALV Container
  CALL METHOD GO_SPLITTER->SET_COLUMN_WIDTH
    EXPORTING
      ID    = 1
      WIDTH = 100.

* Set Splitter with Container
  CALL METHOD GO_SPLITTER->GET_CONTAINER
    EXPORTING
      ROW    = 1
      COLUMN = 1
    RECEIVING
      CONTAINER = GO_ALV_CON1.

* Create Grid
  CREATE OBJECT GO_GRID1
    EXPORTING
      I_PARENT = GO_ALV_CON1.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_ALV_OBJ_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CREATE_ALV_OBJ_0100 .

*-----------------------------------------------*
  PERFORM SET_FIELDCAT1 CHANGING GT_FCAT1.
  PERFORM SET_LAYOUT1   CHANGING GS_LAYO1.
  PERFORM SET_SORT1     CHANGING GT_SORT1.
*-----------------------------------------------*
  PERFORM SET_GRID_EVENT_RECEIVER1.
  PERFORM SET_GRID_FIRST_DISPLAY1.
*-----------------------------------------------*

ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH_TABLE_DISPLAY_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM REFRESH_TABLE_DISPLAY_0100 .

  DATA : LS_STBL TYPE LVC_S_STBL.

  CLEAR: LS_STBL.
  LS_STBL-ROW = 'X'.
  LS_STBL-COL = 'X'.

  CHECK GO_GRID1 IS NOT INITIAL.

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
*& Module INIT_0110 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE INIT_0110 OUTPUT.

***  IF GO_CON1_1 IS INITIAL.
***    PERFORM CREATE_OBJECT_0110.
***    PERFORM SET_FIELDCATALOG_0110.
***    PERFORM SET_ALV_LAYOUT_0110.
***    PERFORM DISPLAY_ALV_0110.
***  ELSE.
***    PERFORM REFRESH_TABLE_DISPLAY_0110.
***  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_0110
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT_0110 .

***   CREATE OBJECT GO_CON1_1
***    EXPORTING
***      CONTAINER_NAME  = 'CON110'
***    EXCEPTIONS
***      OTHERS          = 1.
***
***  IF SY-SUBRC NE 0.
***    MESSAGE '컨테이너 생성에 실패했습니다.' TYPE 'E'.
***  ENDIF.
***
***  CREATE OBJECT GO_GRID1_1
***    EXPORTING
***      I_PARENT                = GO_CON1_1
***    EXCEPTIONS
***      OTHERS                  = 1.
***  IF SY-SUBRC NE 0.
***    MESSAGE 'ALV 생성에 실패했습니다.' TYPE 'E'.
***  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_FIELDCATALOG_0110
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_FIELDCATALOG_0110.

*  DATA : LT_SLIS_FCAT  TYPE  SLIS_T_FIELDCAT_ALV.
*
*  DATA : LV_PROG_NAME  LIKE SY-REPID.
*  DATA : LV_INCLNAME   LIKE SY-REPID.
*
*  DATA : LT_FCAT       TYPE  LVC_T_FCAT.
*
*  CLEAR: LV_PROG_NAME, LV_INCLNAME.
*  LV_PROG_NAME = SY-REPID.
*  LV_INCLNAME  = SY-REPID.
*
*  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
*    EXPORTING
*      I_PROGRAM_NAME         = LV_PROG_NAME
*      I_INCLNAME             = LV_INCLNAME
*      I_CLIENT_NEVER_DISPLAY = 'X'
*      I_INTERNAL_TABNAME     = 'GT_DISP1_1'
*    CHANGING
*      CT_FIELDCAT            = LT_SLIS_FCAT
*   EXCEPTIONS
*     INCONSISTENT_INTERFACE  = 1
*     PROGRAM_ERROR           = 2
*     OTHERS                  = 3.
*
*  CALL FUNCTION 'LVC_TRANSFER_FROM_SLIS'
*    EXPORTING
*      IT_FIELDCAT_ALV = LT_SLIS_FCAT
*    IMPORTING
*      ET_FIELDCAT_LVC = LT_FCAT
*    TABLES
*      IT_DATA         = GT_DISP1_1
*    EXCEPTIONS
*      IT_DATA_MISSING = 1
*      OTHERS          = 2.
*
*  CALL FUNCTION 'LVC_FIELDCAT_COMPLETE'
*    CHANGING
*      CT_FIELDCAT = LT_FCAT.
*
*  CLEAR: GT_FCAT1_1[].
*  GT_FCAT1_1[] = LT_FCAT[].
*
*  LOOP AT GT_FCAT1_1 ASSIGNING FIELD-SYMBOL(<LFS_FCAT>).
*    CASE <LFS_FCAT>-FIELDNAME.
*      <LFS_FCAT>-KEY = ' '.
*      WHEN 'MRPID'.
*        <LFS_FCAT>-COL_POS = 1.
*        <LFS_FCAT>-OUTPUTLEN = 10.
*        <LFS_FCAT>-EMPHASIZE = 'C310'.
*      WHEN 'MATNR'.
*        <LFS_FCAT>-COL_POS = 2.
*        <LFS_FCAT>-OUTPUTLEN = 10.
*      WHEN 'STOCK'.
*        <LFS_FCAT>-COL_POS = 3.
*        <LFS_FCAT>-OUTPUTLEN = 8.
*      WHEN 'USEQTY'.
*        <LFS_FCAT>-COL_POS = 4.
*        <LFS_FCAT>-OUTPUTLEN = 10.
*      WHEN 'REQQTY'.
*        <LFS_FCAT>-COL_POS = 5.
*        <LFS_FCAT>-OUTPUTLEN = 10.
*      WHEN 'MEINS'.
*        <LFS_FCAT>-COL_POS = 6.
*        <LFS_FCAT>-OUTPUTLEN = 6.
*      WHEN 'PLANSDATE'.
*        <LFS_FCAT>-COL_POS = 7.
*        <LFS_FCAT>-OUTPUTLEN = 10.
*      WHEN 'PLANEDATE'.
*        <LFS_FCAT>-COL_POS = 8.
*        <LFS_FCAT>-OUTPUTLEN = 10.
*      WHEN 'LOEKZ'.
*        <LFS_FCAT>-COL_POS = 9.
*        <LFS_FCAT>-OUTPUTLEN = 7.
*      WHEN OTHERS.
*        <LFS_FCAT>-TECH = 'X'.
*    ENDCASE.
*  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_LAYOUT_0110
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_ALV_LAYOUT_0110 .

*  CLEAR GS_LAYO1_1.
*
*  GS_LAYO1_1-ZEBRA      = 'X'.
*  GS_LAYO1_1-SEL_MODE   = 'D'.
*  GS_LAYO1_1-NO_TOOLBAR = ' '.
*  GS_LAYO1_1-NO_ROWINS  = 'X'.
*  GS_LAYO1_1-NO_ROWMOVE = 'X'.
*  GS_LAYO1_1-NO_ROWMARK = 'X'.
*
*  DATA : LV_TITLE TYPE LVC_TITLE.
*  DATA(LV_CNT) = LINES( GT_DISP1_1 ).
*  LV_TITLE = 'MRP 세부내역:' && LV_CNT && '건'.
*  GS_LAYO1_1-GRID_TITLE = LV_TITLE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_0110
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV_0110 .

*  CALL METHOD GO_GRID1_1->SET_TABLE_FOR_FIRST_DISPLAY
*    EXPORTING
*      IS_LAYOUT       = GS_LAYO1_1   " Layout
*    CHANGING
*      IT_FIELDCATALOG = GT_FCAT1_1   " Fieldcatalog
*      IT_OUTTAB       = GT_DISP1_1[] " Output Table
*    EXCEPTIONS
*      OTHERS          = 1.
*
*  IF SY-SUBRC NE 0.
*    MESSAGE 'ALV 에 데이터를 설정하는 과정 중 오류가 발생하였습니다.' TYPE 'E'.
*  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH_TABLE_DISPLAY_0110
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM REFRESH_TABLE_DISPLAY_0110 .

*  DATA : LS_STBL TYPE LVC_S_STBL.
*
*  CHECK GO_GRID1_1 IS NOT INITIAL.
*
*  CLEAR: GT_FCAT1_1[].
*  PERFORM SET_FIELDCATALOG_0110.
*  CALL METHOD GO_GRID1_1->SET_FRONTEND_FIELDCATALOG
*  EXPORTING IT_FIELDCATALOG = GT_FCAT1_1.
*
*  CLEAR: GS_LAYO1_1.
*  PERFORM SET_ALV_LAYOUT_0110.
*  CALL METHOD GO_GRID1_1->SET_FRONTEND_LAYOUT
*  EXPORTING IS_LAYOUT = GS_LAYO1_1.
*
*  CLEAR: LS_STBL.
*  LS_STBL-ROW = 'X'.
*  LS_STBL-COL = 'X'.
*  CALL METHOD GO_GRID1_1->REFRESH_TABLE_DISPLAY
*  EXPORTING IS_STABLE = LS_STBL.

ENDFORM.
*&---------------------------------------------------------------------*
*& Module STATUS_0200 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE STATUS_0200 OUTPUT.

  SET PF-STATUS 'S0200'.
  SET TITLEBAR  'T0200'.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_0200 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE INIT_0200 OUTPUT.

  IF GO_CON2 IS INITIAL.
    "Create Container
     PERFORM CREATE_OBJECT_0200.
    "Create ALV Objects
     PERFORM CREATE_ALV_OBJ_0200.
  ELSE.
    "Rrfresh Grid
     PERFORM REFRESH_TABLE_DISPLAY_0200.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_0200
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT_0200 .

  CREATE OBJECT GO_CON2
     EXPORTING
       CONTAINER_NAME  = 'CON200'.

  CREATE OBJECT GO_GRID2
    EXPORTING
      I_PARENT = GO_CON2.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_ALV_OBJ_0200
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CREATE_ALV_OBJ_0200 .

*-----------------------------------------------*
  PERFORM SET_FIELDCAT2 CHANGING GT_FCAT2.
  PERFORM SET_LAYOUT2   CHANGING GS_LAYO2.
  PERFORM SET_SORT2     CHANGING GT_SORT2.
*-----------------------------------------------*
  PERFORM SET_GRID_EVENT_RECEIVER2.
  PERFORM SET_GRID_FIRST_DISPLAY2.
*-----------------------------------------------*

ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH_TABLE_DISPLAY_0200
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM REFRESH_TABLE_DISPLAY_0200 .

  DATA : LS_STBL TYPE LVC_S_STBL.

  CLEAR: LS_STBL.
  LS_STBL-ROW = 'X'.
  LS_STBL-COL = 'X'.

  CHECK GO_GRID2 IS NOT INITIAL.

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

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_USER_COMMAND2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_UCOMM
*&---------------------------------------------------------------------*
FORM HANDLE_USER_COMMAND2  USING C_UCOMM.

  CASE C_UCOMM.
    WHEN 'EXCUTE'.
      PERFORM CREATE_PURCHASE_REQUEST.
  ENDCASE.
  CLEAR: C_UCOMM.

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
  LS_SORT-FIELDNAME = 'MRPID'.
  LS_SORT-UP        = 'X'.
  APPEND LS_SORT TO PT_SORT.

  SORT PT_SORT BY FIELDNAME.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  F4_BANFN  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE F4_BANFN INPUT.

  DATA : BEGIN OF LT_MMT130 OCCURS 0,
           BANFN LIKE ZEA_MMT130-BANFN,
         END OF LT_MMT130.
  DATA : LT_RETURN LIKE	DDSHRETVAL OCCURS 0 WITH HEADER LINE.

  CLEAR: LT_MMT130[].
  SELECT DISTINCT BANFN
    INTO TABLE @LT_MMT130
    FROM ZEA_MMT130
    ORDER BY BANFN.

 "Search Help를 생성하는 함수 실행
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      RETFIELD        = 'BANFN'             "기준필드
      DYNPPROG        = SY-CPROG            "프로그램
      DYNPNR          = SY-DYNNR            "스크린
      DYNPROFIELD     = 'ZEA_MMT130-BANFN'  "스크린의 필드
      WINDOW_TITLE    = '구매요청 문서번호' "창 이름
      VALUE_ORG       = 'S'                 "스트럭처(S)
    TABLES
      VALUE_TAB       = LT_MMT130[] "F4 헬프의 데이터를 담고 있는 테이블
      RETURN_TAB      = LT_RETURN[]
    EXCEPTIONS
      PARAMETER_ERROR = 1
      NO_VALUES_FOUND = 2
      OTHERS          = 3.

ENDMODULE.
