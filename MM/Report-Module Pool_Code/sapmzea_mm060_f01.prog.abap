*&---------------------------------------------------------------------*
*& Include          SAPMZEA_MM060
*&---------------------------------------------------------------------*
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

    <LFS_FCAT>-KEY     = ' '.

    CASE <LFS_FCAT>-FIELDNAME.
      WHEN 'ICON'.
        <LFS_FCAT>-COL_POS   = 1.
        <LFS_FCAT>-COLTEXT   = '요청생성상태'.
        <LFS_FCAT>-JUST      = 'C'.
        <LFS_FCAT>-OUTPUTLEN = 10.
      WHEN 'BANFN'.
        <LFS_FCAT>-COL_POS   = 2.
        <LFS_FCAT>-KEY       = 'X'.
        <LFS_FCAT>-COLTEXT   = '구매요청번호'.
        <LFS_FCAT>-JUST      = 'C'.
        <LFS_FCAT>-OUTPUTLEN = 10.
      WHEN 'BNFPO'.
        <LFS_FCAT>-COL_POS   = 3.
        <LFS_FCAT>-KEY       = 'X'.
        <LFS_FCAT>-COLTEXT   = '품목번호'.
        <LFS_FCAT>-OUTPUTLEN = 5.
        <LFS_FCAT>-JUST      = 'C'.

      WHEN 'BEDAT'.
        <LFS_FCAT>-COL_POS   = 4.
        <LFS_FCAT>-COLTEXT   = '구매오더 예정일'.
        <LFS_FCAT>-OUTPUTLEN = 10.
      WHEN 'INFO_NO'.
        <LFS_FCAT>-COL_POS   = 5.
        <LFS_FCAT>-COLTEXT   = '정보레코드'.
        <LFS_FCAT>-JUST      = 'C'.
        <LFS_FCAT>-OUTPUTLEN = 10.
      WHEN 'ODDATE'.
        <LFS_FCAT>-COL_POS   = 6.
        <LFS_FCAT>-COLTEXT   = '발주일자'.
        <LFS_FCAT>-OUTPUTLEN = 10.
      WHEN 'WERKS'.
        <LFS_FCAT>-COL_POS = 7.
        <LFS_FCAT>-COLTEXT = '플랜트'.
        <LFS_FCAT>-JUST      = 'C'.
        <LFS_FCAT>-OUTPUTLEN = 6.
      WHEN 'MRPID'.
        <LFS_FCAT>-COL_POS = 8.
        <LFS_FCAT>-COLTEXT = 'MRP ID'.
        <LFS_FCAT>-EMPHASIZE = 'C310'.
        <LFS_FCAT>-JUST      = 'C'.
        <LFS_FCAT>-OUTPUTLEN = 10.
      WHEN 'MATNR'.
        <LFS_FCAT>-COL_POS = 9.
        <LFS_FCAT>-COLTEXT = '자재코드'.
        <LFS_FCAT>-JUST      = 'C'.
        <LFS_FCAT>-OUTPUTLEN = 11.
      WHEN 'MENGE'.
        <LFS_FCAT>-COL_POS = 10.
        <LFS_FCAT>-COLTEXT = '수량'.
        <LFS_FCAT>-OUTPUTLEN = 18.
      WHEN 'MEINS'.
        <LFS_FCAT>-COL_POS = 11.
        <LFS_FCAT>-COLTEXT = '단위'.
        <LFS_FCAT>-OUTPUTLEN = 5.
        <LFS_FCAT>-JUST      = 'C'.

      WHEN 'LGORT'.
        <LFS_FCAT>-COL_POS = 12.
        <LFS_FCAT>-COLTEXT = '저장위치'.
        <LFS_FCAT>-JUST      = 'C'.
        <LFS_FCAT>-OUTPUTLEN = 6.
      WHEN 'CHECKBOX'.
        <LFS_FCAT>-COL_POS   = 13.
        <LFS_FCAT>-COLTEXT   = '구매요청 승인여부'.
        <LFS_FCAT>-JUST      = 'C'.
        <LFS_FCAT>-OUTPUTLEN = 10.
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
FORM SET_LAYOUT1  CHANGING PS_LAYO TYPE LVC_S_LAYO.

  CLEAR: PS_LAYO.
  PS_LAYO-NO_ROWINS  = 'X'.
  PS_LAYO-NO_ROWMOVE = 'X'.
  PS_LAYO-SEL_MODE   = 'D'.

  DATA : LV_TITLE TYPE LVC_TITLE.
  DATA(LV_CNT) = LINES( GT_DISP1 ).
  LV_TITLE = '구매요청 :' && LV_CNT && '건'.
  PS_LAYO-GRID_TITLE = LV_TITLE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_GRID_EVENT_RECEIVER1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_GRID_EVENT_RECEIVER1 .

  CREATE OBJECT LCL_EVENT_RECEIVER.

  SET HANDLER:
  LCL_EVENT_RECEIVER->HANDLE_TOOLBAR      FOR GO_GRID1,
  LCL_EVENT_RECEIVER->HANDLE_USER_COMMAND FOR GO_GRID1.

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

    <LFS_FCAT>-KEY     = ' '.

    CASE <LFS_FCAT>-FIELDNAME.
      WHEN 'ICON'.
        <LFS_FCAT>-COL_POS   = 1.
        <LFS_FCAT>-COLTEXT   = '상태'.
        <LFS_FCAT>-JUST      = 'C'.
        <LFS_FCAT>-OUTPUTLEN = 5.
      WHEN 'MRPID'.
        <LFS_FCAT>-COL_POS   = 2.
        <LFS_FCAT>-COLTEXT   = 'MRPID'.
        <LFS_FCAT>-OUTPUTLEN = 10.
        <LFS_FCAT>-EMPHASIZE = 'C310'.
      WHEN 'WERKS'.
        <LFS_FCAT>-COL_POS   = 3.
        <LFS_FCAT>-COLTEXT   = '플랜트'.
        <LFS_FCAT>-OUTPUTLEN = 5.
      WHEN 'MATNR'.
        <LFS_FCAT>-COL_POS   = 4.
        <LFS_FCAT>-COLTEXT   = '자재코드'.
        <LFS_FCAT>-OUTPUTLEN = 10.
      WHEN 'STOCK'.
        <LFS_FCAT>-COL_POS   = 5.
        <LFS_FCAT>-COLTEXT   = '재고량'.
        <LFS_FCAT>-OUTPUTLEN = 10.
      WHEN 'USEQTY'.
        <LFS_FCAT>-COL_POS   = 6.
        <LFS_FCAT>-COLTEXT   = '소비 수량'.
        <LFS_FCAT>-OUTPUTLEN = 10.
      WHEN 'REQQTY'.
        <LFS_FCAT>-COL_POS   = 7.
        <LFS_FCAT>-COLTEXT   = '필요 수량'.
        <LFS_FCAT>-OUTPUTLEN = 10.
      WHEN 'MEINS'.
        <LFS_FCAT>-COL_POS   = 8.
        <LFS_FCAT>-COLTEXT   = '단위'.
        <LFS_FCAT>-OUTPUTLEN = 5.
      WHEN 'PLANSDATE'.
        <LFS_FCAT>-COL_POS   = 9.
        <LFS_FCAT>-COLTEXT   = '생산요청일'.
        <LFS_FCAT>-OUTPUTLEN = 10.
      WHEN 'PLANEDATE'.
        <LFS_FCAT>-COL_POS   = 10.
        <LFS_FCAT>-COLTEXT   = '생산완료일'.
        <LFS_FCAT>-OUTPUTLEN = 10.
      WHEN 'LOEKZ'.
        <LFS_FCAT>-COL_POS   = 11.
        <LFS_FCAT>-COLTEXT   = '삭제플래그'.
        <LFS_FCAT>-OUTPUTLEN = 7.
        <LFS_FCAT>-JUST      = 'C'.
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
FORM SET_LAYOUT2  CHANGING PS_LAYO TYPE LVC_S_LAYO.

  CLEAR: PS_LAYO.
  PS_LAYO-NO_ROWINS  = 'X'.
  PS_LAYO-NO_ROWMOVE = 'X'.
  PS_LAYO-SEL_MODE   = 'D'.
*  PS_LAYO-CWIDTH_OPT = 'X'.

  DATA : LV_TITLE TYPE LVC_TITLE.
  DATA(LV_CNT) = LINES( GT_DISP2 ).
  LV_TITLE = 'MRP 결과: ' && LV_CNT && '건'.
  PS_LAYO-GRID_TITLE = LV_TITLE.

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
*& Form HANDLE_USER_COMMAND
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_UCOMM
*&---------------------------------------------------------------------*
FORM HANDLE_USER_COMMAND  USING C_UCOMM.

  CASE C_UCOMM.
    WHEN ''.

  ENDCASE.
  CLEAR: C_UCOMM.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_TOOLBAR
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_OBJECT
*&      --> E_INTERACTIVE
*&---------------------------------------------------------------------*
FORM HANDLE_TOOLBAR  USING P_OBJECT TYPE REF TO
                                    CL_ALV_EVENT_TOOLBAR_SET
                          P_INTERACTIVE TYPE CHAR1.

  DATA : LS_TOOLBAR TYPE STB_BUTTON.
  CLEAR LS_TOOLBAR.
  LS_TOOLBAR-BUTN_TYPE = 3.
  APPEND LS_TOOLBAR TO P_OBJECT->MT_TOOLBAR.

**  CLEAR LS_TOOLBAR.
**  LS_TOOLBAR-FUNCTION = 'CREATE'.
**  LS_TOOLBAR-ICON = ICON_GENERATE.
**  LS_TOOLBAR-QUICKINFO = 'CREATE'.
**  LS_TOOLBAR-TEXT = '구매요청생성'.
**  LS_TOOLBAR-DISABLED = ''.
**  APPEND LS_TOOLBAR TO P_OBJECT->MT_TOOLBAR.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_RTN
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CREATE_RTN .

  DATA : LV_ANSWER TYPE C.

  CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
    EXPORTING
      DEFAULTOPTION  = 'N'
      TEXTLINE1      = '구매요청문서는 MRP 결과를 통해 생성됩니다.'
      TEXTLINE2      = '생성하시겠습니까?'
      TITEL          = '생성 팝업'
      CANCEL_DISPLAY = ' '
    IMPORTING
      ANSWER         = LV_ANSWER.
  IF LV_ANSWER NE 'J'.
    MESSAGE '취소되었습니다.' TYPE 'S'.
    EXIT.
  ENDIF.

  DATA : LV_RETURN TYPE C.
  DATA : LT_SVAL   TYPE STANDARD TABLE OF SVAL.

  LT_SVAL
  = VALUE #( (  TABNAME   = 'ZEA_MDKP'
                FIELDNAME = 'MRPID'
                FIELD_ATTR = '01'     )
             (  TABNAME   = 'ZEA_MDKP'
                FIELDNAME = 'WERKS'
                FIELD_ATTR = '01'     ) ).

  CALL FUNCTION 'POPUP_GET_VALUES'
    EXPORTING
      POPUP_TITLE     = 'MRP 조회조건'
      START_COLUMN    = 15
      START_ROW       = 5
    IMPORTING
      RETURNCODE      = LV_RETURN
    TABLES
      FIELDS          = LT_SVAL
    EXCEPTIONS
      ERROR_IN_FIELDS = 1
      OTHERS          = 2.
  IF LV_RETURN EQ 'A'.
    MESSAGE '취소되었습니다.' TYPE 'S'.
    EXIT.
  ENDIF.

  CLEAR: GR_PPMRP[].
  CLEAR: GR_PPWER[].
  LOOP AT LT_SVAL INTO DATA(LS_SVAL).
    IF LS_SVAL-VALUE IS NOT INITIAL.
      CASE LS_SVAL-FIELDNAME.
        WHEN 'MRPID'.
          CLEAR: GR_PPMRP.
          GR_PPMRP-SIGN   = 'I'.
          GR_PPMRP-OPTION = 'EQ'.
          GR_PPMRP-LOW    = LS_SVAL-VALUE.
          GR_PPMRP-HIGH   = ' '.
          APPEND GR_PPMRP.
        WHEN 'WERKS'.
          GR_PPWER-SIGN   = 'I'.
          GR_PPWER-OPTION = 'EQ'.
          GR_PPWER-LOW    = LS_SVAL-VALUE.
          GR_PPWER-HIGH   = ' '.
          APPEND GR_PPWER.
      ENDCASE.
    ENDIF.
  ENDLOOP.

  PERFORM GET_MRP_DATA.

 "MRP 데이터중 PR이 생성된 건은 체크 표시, 삭제된 품목은 엑스표시
 "(MRP테이블에 구매요청 필드가 없기에 추가 SELECT)
  SELECT BANFN, BNFPO, MRPID
         INTO TABLE @DATA(LT_PR)
         FROM ZEA_MMT130
              FOR ALL ENTRIES IN @GT_DISP2
         WHERE MRPID EQ @GT_DISP2-MRPID.
  SORT LT_PR BY MRPID.

  LOOP AT GT_DISP2.
    DATA(LV_TABIX) = SY-TABIX.

    READ TABLE LT_PR INTO DATA(LS_PR)
    WITH KEY MRPID = GT_DISP2-MRPID BINARY SEARCH.

    IF SY-SUBRC EQ 0.
      IF GT_DISP2-LOEKZ EQ 'X'.
        GT_DISP2-ICON = '@0W@'.
      ELSE.
        GT_DISP2-ICON = '@0V@'.
      ENDIF.
      IF GT_DISP2-REQQTY EQ 0.
        GT_DISP2-ICON = '@00@'.
      ENDIF.
      MODIFY GT_DISP2 INDEX LV_TABIX.
    ELSE.
      IF GT_DISP2-LOEKZ EQ 'X'.
        GT_DISP2-ICON = '@0W@'.
      ENDIF.
      IF GT_DISP2-REQQTY EQ 0.
        GT_DISP2-ICON = '@00@'.
      ENDIF.
      MODIFY GT_DISP2 INDEX LV_TABIX.
    ENDIF.
  ENDLOOP.

                               "가로 "세로
  CALL SCREEN 0200 STARTING AT  60   1
                   ENDING   AT  190  25.

  PERFORM REFRESH_RTN. "PR
  PERFORM REFRESH_TABLE_DISPLAY_0100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_TOOLBAR2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_OBJECT
*&      --> E_INTERACTIVE
*&---------------------------------------------------------------------*
FORM HANDLE_TOOLBAR2  USING P_OBJECT TYPE REF TO
                                    CL_ALV_EVENT_TOOLBAR_SET
                          P_INTERACTIVE TYPE CHAR1.

  DATA : LS_TOOLBAR TYPE STB_BUTTON.
  CLEAR LS_TOOLBAR.
  LS_TOOLBAR-BUTN_TYPE = 3.
  APPEND LS_TOOLBAR TO P_OBJECT->MT_TOOLBAR.

  CLEAR LS_TOOLBAR.
  LS_TOOLBAR-FUNCTION  = 'EXCUTE'.
  LS_TOOLBAR-ICON      = ICON_GENERATE.
  LS_TOOLBAR-QUICKINFO = '생성'.
  LS_TOOLBAR-TEXT      = 'MRP 구매요청 생성'.
  LS_TOOLBAR-DISABLED  = ''.
  APPEND LS_TOOLBAR TO P_OBJECT->MT_TOOLBAR.

  DATA: LV_CNT_1 TYPE I.
  DATA: LV_CNT_2 TYPE I.
  DATA: LV_CNT_3 TYPE I.
  DATA: LV_CNT_4 TYPE I.
  LOOP AT GT_DISP2.
    IF GT_DISP2-ICON = '@0V@'.     "정상
      ADD 1 TO LV_CNT_1.

    ELSEIF GT_DISP2-ICON EQ '@00@'."제외
      ADD 1 TO LV_CNT_2.

    ELSEIF GT_DISP2-ICON EQ '@0W@'."삭제
      ADD 1 TO LV_CNT_3.

    ELSEIF GT_DISP2-ICON EQ SPACE. "미생성
      ADD 1 TO LV_CNT_4.
    ENDIF.

  ENDLOOP.

  CLEAR LS_TOOLBAR.
  LS_TOOLBAR-FUNCTION  = '1'.
  LS_TOOLBAR-ICON      = ICON_OKAY.
  LS_TOOLBAR-QUICKINFO = '생성'.
  LS_TOOLBAR-TEXT      = '생성:' && LV_CNT_1.
  LS_TOOLBAR-DISABLED  = ''.
  APPEND LS_TOOLBAR TO P_OBJECT->MT_TOOLBAR.

  CLEAR LS_TOOLBAR.
  LS_TOOLBAR-FUNCTION  = '2'.
  LS_TOOLBAR-ICON      = ICON_DUMMY.
  LS_TOOLBAR-QUICKINFO = '제외'.
  LS_TOOLBAR-TEXT      = '제외:' && LV_CNT_2.
  LS_TOOLBAR-DISABLED  = ''.
  APPEND LS_TOOLBAR TO P_OBJECT->MT_TOOLBAR.

  CLEAR LS_TOOLBAR.
  LS_TOOLBAR-FUNCTION  = '3'.
  LS_TOOLBAR-ICON      = ICON_CANCEL.
  LS_TOOLBAR-QUICKINFO = '삭제'.
  LS_TOOLBAR-TEXT      = '삭제:' && LV_CNT_3.
  LS_TOOLBAR-DISABLED  = ''.
  APPEND LS_TOOLBAR TO P_OBJECT->MT_TOOLBAR.

  CLEAR LS_TOOLBAR.
  LS_TOOLBAR-FUNCTION  = '4'.
  LS_TOOLBAR-ICON      = ' '.
  LS_TOOLBAR-QUICKINFO = '미처리'.
  LS_TOOLBAR-TEXT      = '미처리:' && LV_CNT_4.
  LS_TOOLBAR-DISABLED  = ''.
  APPEND LS_TOOLBAR TO P_OBJECT->MT_TOOLBAR.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH_RTN
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM REFRESH_RTN.

  PERFORM GET_PR_DATA  TABLES GT_DISP1.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_RANGE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_RANGE .

  CLEAR: GR_BANFN[].
  CLEAR: GR_INFO_NO[].
  CLEAR: GR_MRPID[].
  CLEAR: GR_WERKS[].
  CLEAR: GR_LGORT[].
  CLEAR: GR_MATNR[].

  IF ZEA_MMT130-BANFN IS NOT INITIAL.
    APPEND VALUE #( SIGN   = 'I'
                    OPTION = 'EQ '
                    LOW    = ZEA_MMT130-BANFN
                    HIGH   = SPACE          ) TO GR_BANFN.
  ENDIF.

  IF ZEA_MMT130-INFO_NO IS NOT INITIAL.
    APPEND VALUE #( SIGN   = 'I'
                    OPTION = 'EQ '
                    LOW    = ZEA_MMT130-INFO_NO
                    HIGH   = SPACE          ) TO GR_INFO_NO.
  ENDIF.

  IF ZEA_MMT130-MRPID IS NOT INITIAL.
    APPEND VALUE #( SIGN   = 'I'
                    OPTION = 'EQ '
                    LOW    = ZEA_MMT130-MRPID
                    HIGH   = SPACE          ) TO GR_MRPID.
  ENDIF.

  IF ZEA_MMT130-WERKS IS NOT INITIAL.
    APPEND VALUE #( SIGN   = 'I'
                    OPTION = 'EQ '
                    LOW    = ZEA_MMT130-WERKS
                    HIGH   = SPACE          ) TO GR_WERKS.
  ENDIF.

  IF ZEA_MMT130-LGORT IS NOT INITIAL.
    APPEND VALUE #( SIGN   = 'I'
                    OPTION = 'EQ '
                    LOW    = ZEA_MMT130-LGORT
                    HIGH   = SPACE          ) TO GR_LGORT.
  ENDIF.

  IF ZEA_MMT130-MATNR IS NOT INITIAL.
    APPEND VALUE #( SIGN   = 'I'
                    OPTION = 'EQ '
                    LOW    = ZEA_MMT130-MATNR
                    HIGH   = SPACE          ) TO GR_MATNR.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_PR_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_DISP2
*&---------------------------------------------------------------------*
FORM GET_PR_DATA  TABLES   PT_TAB STRUCTURE GT_DISP1.

  PERFORM SET_RANGE.

  CLEAR: PT_TAB[].
  SELECT * INTO CORRESPONDING FIELDS OF TABLE @PT_TAB
           FROM ZEA_MMT130
           WHERE BANFN   IN @GR_BANFN
           AND   INFO_NO IN @GR_INFO_NO
           AND   MRPID   IN @GR_MRPID
           AND   WERKS   IN @GR_WERKS
           AND   LGORT   IN @GR_LGORT
           AND   MATNR   IN @GR_MATNR
           ORDER BY PRIMARY KEY.
  IF SY-SUBRC NE 0.
    MESSAGE '데이터가 없습니다.' TYPE 'S' DISPLAY LIKE 'E'.
  ENDIF.

  CLEAR: PT_TAB.
  PT_TAB-ICON =  ICON_OKAY.
  MODIFY PT_TAB TRANSPORTING ICON
                WHERE ICON IS INITIAL.

  IF PT_TAB[] IS NOT INITIAL.
   MESSAGE '새로고침 완료.' TYPE 'S'..
  ELSE.
    MESSAGE '데이터가 없습니다.' TYPE 'S' DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_PURCHASE_REQUEST
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CREATE_PURCHASE_REQUEST.

  DATA : LT_ROWS TYPE LVC_T_ROW.
  DATA : LS_ROWS TYPE LVC_S_ROW.

  CALL METHOD GO_GRID2->GET_SELECTED_ROWS
  IMPORTING ET_INDEX_ROWS = LT_ROWS.
  IF LT_ROWS[] IS INITIAL.
     MESSAGE '항목을 선택하세요.' TYPE 'I' DISPLAY LIKE 'E'.
     EXIT.
  ENDIF.

  DATA : LV_ANSWER TYPE C.
  CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
    EXPORTING
      DEFAULTOPTION  = 'N'
      TEXTLINE1      = '생성하시겠습니까?'
      TEXTLINE2      = '(구매요청번호는 자동 채번됩니다.)'
      TITEL          = '생성 팝업'
      START_ROW      =  10
      START_COLUMN   =  80
      CANCEL_DISPLAY = ' '
    IMPORTING
      ANSWER         = LV_ANSWER.
  IF LV_ANSWER NE 'J'.
    MESSAGE '취소되었습니다.' TYPE 'S'.
    EXIT.
  ENDIF.

  LOOP AT LT_ROWS INTO LS_ROWS.

   "선택된 INDEX로 ALV GRID의 INDEX를 읽는다.
    READ TABLE GT_DISP2 INDEX LS_ROWS-INDEX.
    CHECK SY-SUBRC EQ 0.

   "ALV GRID 데이터 확인
    IF GT_DISP2-ICON EQ '@0V@'.
       MESSAGE '이미 생성된 데이터가 포함되어 있습니다.' TYPE 'I' DISPLAY LIKE 'E'.
       EXIT.
    ENDIF.
    IF GT_DISP2-ICON EQ '@0W@'.
       MESSAGE '데이터를 확인하세요.' TYPE 'I' DISPLAY LIKE 'E'.
       EXIT.
    ENDIF.

  ENDLOOP.

 "Error가 없을 경우만 실행
  CHECK SY-MSGTY NE 'E'.

  LOOP AT LT_ROWS INTO LS_ROWS.
    READ TABLE GT_DISP2 INDEX LS_ROWS-INDEX.
    CHECK SY-SUBRC EQ 0.
    DATA(LV_TABIX) = SY-TABIX.
    GT_DISP2-SELECTED = 'X'."선택된 ROW 표시
    MODIFY GT_DISP2 INDEX LV_TABIX.
  ENDLOOP.

 "가공을 위해 임시 테이블 사용
  DATA(LT_TAB) = GT_DISP2[].
  SORT LT_TAB BY MRPID SELECTED.

 "Header와 Item이 존재하기에 선택된 하나의 MRP번호만 남긴다.
 "(모두 선택하지 않아도 자동 생성 되도록)
 "MRP ITEM이 여러건인 경우 어느 ROW를 선택할지 모르니 SELECTED 포함)
  DELETE ADJACENT DUPLICATES FROM LT_TAB COMPARING MRPID SELECTED.
  DELETE LT_TAB WHERE SELECTED NE 'X'. "선택하지 않은 MRPID 삭제

  CLEAR: GT_DISP2.
  GT_DISP2-SELECTED = SPACE.
  MODIFY GT_DISP2 TRANSPORTING SELECTED
                  WHERE SELECTED IS NOT INITIAL.

  DATA : LT_PR     LIKE  ZEA_MMT130        OCCURS 0 WITH HEADER LINE.
  DATA : LV_BANFN  LIKE  ZEA_MMT130-BANFN.
  DATA : LV_BNFPO  LIKE  ZEA_MMT130-BNFPO.
  DATA : LV_ERR    TYPE  C.

  DATA : LV_CNT    TYPE  N  LENGTH 3.

 "선택된 ROW의 MRPID들만 처리
  LOOP  AT  LT_TAB  INTO  DATA(LS_TAB).

       "ALV GRID에서 1개이상 선택된 MRPID는 모두 처리
        LOOP  AT  GT_DISP2 WHERE MRPID EQ LS_TAB-MRPID.

              LV_TABIX = SY-TABIX.

              IF GT_DISP2-LOEKZ IS NOT INITIAL.
                 GT_DISP2-ICON = '@0W@'.
                 MODIFY GT_DISP2 INDEX LV_TABIX.
                 CONTINUE.
              ENDIF.

             "MRP 결과에 수량이 '0'이면 Pass
              IF GT_DISP2-REQQTY EQ 0.
                GT_DISP2-ICON = '@00@'.
                MODIFY GT_DISP2 INDEX LV_TABIX.
                CONTINUE.
              ENDIF.

              ON CHANGE OF GT_DISP2-MRPID.
                PERFORM PURCHASE_REQUEST_NUMBER
                CHANGING LV_BANFN."PR번호 채번

                CLEAR: LT_PR.
              ENDON.

              ADD 1 TO LV_CNT.

              PERFORM MAKE_PR_DATA TABLES LT_PR
                                   USING  GT_DISP2
                                          LV_BANFN
                                   CHANGING LV_ERR.

              GT_DISP2-ICON = '@0V@'.
              MODIFY GT_DISP2 INDEX LV_TABIX.

        ENDLOOP.

  ENDLOOP.

  DATA : LV_MSG TYPE STRING.

  IF LT_PR[] IS NOT INITIAL.

    INSERT ZEA_MMT130 FROM TABLE LT_PR
    ACCEPTING DUPLICATE KEYS."INSERT 시 덤프 방지
    IF SY-SUBRC NE 0.
      ROLLBACK WORK.
    ELSE.
      COMMIT WORK.
    ENDIF.

    CONCATENATE LV_CNT
                '건'
                ' 생성되었습니다.' INTO LV_MSG.
    MESSAGE LV_MSG TYPE 'I' DISPLAY LIKE 'S'.

  ELSE.

    MESSAGE 'MRP 데이터 오류' TYPE 'I' DISPLAY LIKE 'E'.

  ENDIF.

  PERFORM REFRESH_TABLE_DISPLAY_0200.
  CALL METHOD CL_GUI_CFW=>FLUSH.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_PR_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LT_PR
*&---------------------------------------------------------------------*
FORM MAKE_PR_DATA TABLES PT_PR_ITEM STRUCTURE ZEA_MMT130
                  USING  PS_STR     STRUCTURE GT_DISP2
                         LV_BANFN
                  CHANGING C_ERR."혹시모를 Validation Check 를 위해..

  PT_PR_ITEM-BANFN = LV_BANFN.              "구매요청 문서번호
  PT_PR_ITEM-WERKS = PS_STR-WERKS.          "플랜트


  PT_PR_ITEM-BNFPO = PT_PR_ITEM-BNFPO + 10. "구매요청 품목번호
  PT_PR_ITEM-MATNR = PS_STR-MATNR.          "자재

** MRP 수량에 (-)부호로 데이터가 만들어짐, (-)제거
  DATA : LV_MENGE TYPE C LENGTH 15.
  LV_MENGE = PS_STR-REQQTY.
  REPLACE: ALL OCCURRENCES OF '-' IN LV_MENGE WITH SPACE.
  PS_STR-REQQTY = LV_MENGE.

* 단위 변환(MRP단위: KG, 오더단위: EA)
  SELECT SINGLE MATNR,
                BSTME,
                MEINS2,
                WEIGHT,
                MEINS1
    INTO @DATA(LS_MMT010)
    FROM ZEA_MMT010
    WHERE MATNR EQ @PT_PR_ITEM-MATNR.
  PT_PR_ITEM-MENGE = PS_STR-REQQTY / LS_MMT010-WEIGHT.
  PT_PR_ITEM-MEINS = LS_MMT010-MEINS2. "단위(MRP데이터는 KG 고정)

  PT_PR_ITEM-MRPID = PS_STR-MRPID.          "MRPID

  SELECT SINGLE INFO_NO, WERKS              "정보레코드
    INTO @DATA(LS_MMT050)
    FROM ZEA_MMT050 "(자재코드 기준으로 데이터 추출)
    WHERE MATNR EQ @PT_PR_ITEM-MATNR.
  PT_PR_ITEM-INFO_NO = LS_MMT050-INFO_NO.   "정보레코드
  PT_PR_ITEM-WERKS   = LS_MMT050-WERKS.     "플랜트

  SELECT SINGLE SCODE                       "저장위치
    INTO @PT_PR_ITEM-LGORT
    FROM ZEA_MMT060
    WHERE WERKS EQ @PT_PR_ITEM-WERKS.

  APPEND PT_PR_ITEM.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form PURCHASE_REQUEST_NUMBER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- PT_PR_BANFN
*&---------------------------------------------------------------------*
FORM PURCHASE_REQUEST_NUMBER  CHANGING PV_BANFN.

  DATA : NR_RANGE_NR  LIKE  INRI-NRRANGENR.
  DATA : OBJECT       LIKE  INRI-OBJECT.
  DATA : QUANTITY     LIKE  INRI-QUANTITY.
  DATA : LV_NUM       TYPE  I.

  CLEAR: NR_RANGE_NR, OBJECT, QUANTITY.
  NR_RANGE_NR = '05'.
  OBJECT      = 'ZEA_MMNR'.
  QUANTITY    = 1.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      NR_RANGE_NR                   = NR_RANGE_NR
      OBJECT                        = OBJECT
      QUANTITY                      = QUANTITY
    IMPORTING
      NUMBER                        = LV_NUM
    EXCEPTIONS
      INTERVAL_NOT_FOUND            = 1
      NUMBER_RANGE_NOT_INTERN       = 2
      OBJECT_NOT_FOUND              = 3
      QUANTITY_IS_0                 = 4
      QUANTITY_IS_NOT_1             = 5
      INTERVAL_OVERFLOW             = 6
      BUFFER_OVERFLOW               = 7
      OTHERS                        = 8.
  IF SY-SUBRC EQ 0.
    PV_BANFN = LV_NUM.
    CONDENSE PV_BANFN NO-GAPS."공백제거
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_MRP_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM GET_MRP_DATA .

  SELECT * INTO TABLE @DATA(LT_MRP_HEAD)
           FROM ZEA_MDKP
           WHERE MRPID IN @GR_PPMRP "MRPID
           AND   WERKS IN @GR_PPWER."플랜트
  IF SY-SUBRC NE 0.
    MESSAGE 'MRP 결과가 없습니다.' TYPE 'I' DISPLAY LIKE 'W'.
    EXIT.
  ENDIF.

  SELECT * INTO TABLE @DATA(LT_MRP_ITEM)
           FROM ZEA_MDTB
                FOR ALL ENTRIES IN @LT_MRP_HEAD
           WHERE MRPID EQ @LT_MRP_HEAD-MRPID.
  IF SY-SUBRC NE 0.
    MESSAGE 'MRP 데이터 오류' TYPE 'I' DISPLAY LIKE 'E'.
    EXIT.
  ENDIF.

  CLEAR: GT_DISP2[].
  LOOP AT LT_MRP_HEAD INTO DATA(LS_HEAD).

       CLEAR: GT_DISP2.
       GT_DISP2-MRPID = LS_HEAD-MRPID."MRPID
       GT_DISP2-WERKS = LS_HEAD-WERKS."플랜트

       LOOP AT LT_MRP_ITEM INTO DATA(LS_ITEM)
                           WHERE MRPID EQ LS_HEAD-MRPID.

         GT_DISP2-MATNR     = LS_ITEM-MATNR.
         GT_DISP2-STOCK     = LS_ITEM-STOCK.
         GT_DISP2-USEQTY    = LS_ITEM-USEQTY.
         GT_DISP2-REQQTY    = LS_ITEM-REQQTY.
         GT_DISP2-MEINS     = LS_ITEM-MEINS.
         GT_DISP2-PLANSDATE = LS_ITEM-PLANSDATE.
         GT_DISP2-PLANEDATE = LS_ITEM-PLANEDATE.
         GT_DISP2-LOEKZ     = LS_ITEM-LOEKZ.
         APPEND GT_DISP2.

       ENDLOOP.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_SORT1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GT_SORT1
*&---------------------------------------------------------------------*
FORM SET_SORT1 CHANGING PT_SORT TYPE LVC_T_SORT.

  DATA : LS_SORT TYPE LVC_S_SORT.

  CLEAR: LS_SORT.
  LS_SORT-SPOS      = 1.
  LS_SORT-FIELDNAME = 'BANFN'.
  LS_SORT-UP        = 'X'.
  APPEND LS_SORT TO PT_SORT.

  SORT PT_SORT BY FIELDNAME.

ENDFORM.
