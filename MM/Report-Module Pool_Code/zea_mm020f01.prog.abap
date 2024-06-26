*&---------------------------------------------------------------------*
*& Include          YE07_STROF01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form SELECT_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SELECT_DATA .

  REFRESH GT_DATA.

  SELECT *
    FROM ZEA_MMT060
    WHERE WERKS IN @SO_WERKS
      AND SCODE IN @SO_SCODE
      AND STYPE IN @SO_STYPE
    INTO  CORRESPONDING FIELDS OF TABLE @GT_DATA.
*
*    SORT GT_DATA BY WERKS SCODE.
*    MOVE-CORRESPONDING GS_DATA TO GS_DISPLAY.

*  SELECT *
*    INTO CORRESPONDING FIELDS OF TABLE GT_DATA
*    FROM ZEA_MMT060.
**    WHERE WERKS EQ ZEA_MMT060-WERKS.

  SORT GT_DATA BY WERKS SCODE.
  MOVE-CORRESPONDING GS_DATA TO GS_DISPLAY.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM DISPLAY_DATA .

  DESCRIBE TABLE GT_DISPLAY LINES GV_LINES.

  IF GT_DISPLAY IS INITIAL.
    MESSAGE S013 DISPLAY LIKE 'W'.
  ELSE.
    MESSAGE S006 WITH GV_LINES.
  ENDIF.

  IF NOT SY-BATCH IS INITIAL.
    EXIT.
  ENDIF.



  CALL SCREEN 0100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_0100
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT_0100 .

  CREATE OBJECT GO_CONTAINER
    EXPORTING
      CONTAINER_NAME = 'CCON'
    EXCEPTIONS
      OTHERS         = 1.
  IF SY-SUBRC <> 0.
    MESSAGE E020.
  ENDIF.

  CREATE OBJECT GO_ALV_GRID
    EXPORTING
      I_PARENT = GO_CONTAINER
    EXCEPTIONS
      OTHERS   = 0.
  IF SY-SUBRC <> 0.
    MESSAGE E021.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_0100
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV_0100 .

  CHECK SY-BATCH EQ SPACE.

  CALL METHOD GO_ALV_GRID->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
      IS_VARIANT                    = GS_VARIANT
      I_SAVE                        = GV_SAVE
      IS_LAYOUT                     = GS_LAYOUT
    CHANGING
      IT_OUTTAB                     = GT_DISPLAY
      IT_FIELDCATALOG               = GT_FIELDCAT
    EXCEPTIONS
      INVALID_PARAMETER_COMBINATION = 1
      PROGRAM_ERROR                 = 2
      TOO_MANY_LINES                = 3
      OTHERS                        = 4.
  IF SY-SUBRC <> 0.

  ENDIF.

  CALL METHOD CL_GUI_CFW=>FLUSH
    EXCEPTIONS
      CNTL_SYSTEM_ERROR = 1
      CNTL_ERROR        = 2
      OTHERS            = 3.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH_ALV_0100
*&---------------------------------------------------------------------*
FORM REFRESH_ALV_0100 .

  DATA LS_STABLE TYPE LVC_S_STBL.
  LS_STABLE-ROW = ABAP_ON.
  LS_STABLE-COL = ABAP_ON.

  CALL METHOD GO_ALV_GRID->REFRESH_TABLE_DISPLAY
    EXPORTING
      IS_STABLE = LS_STABLE
    EXCEPTIONS
      FINISHED  = 1
      OTHERS    = 2.
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
      WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM MAKE_DISPLAY_DATA .

  REFRESH GT_DISPLAY.

  LOOP AT GT_DATA INTO GS_DATA.

    CLEAR GS_DISPLAY.

    MOVE-CORRESPONDING GS_DATA TO GS_DISPLAY.

    IF GS_DISPLAY-STYPE = '공장'.

      GS_DISPLAY-STATUS = ICON_PPE_PLINE.

    ELSEIF GS_DISPLAY-STYPE = '창고'.
      GS_DISPLAY-STATUS = ICON_TRANSPORT_POINT.
    ELSE.
      GS_DISPLAY-STATUS = ICON_LED_RED.
    ENDIF.

    APPEND GS_DISPLAY TO GT_DISPLAY.


  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_FIELDCAT_0100 .

  PERFORM GET_FIELDCAT2 USING GT_DISPLAY CHANGING GT_FIELDCAT.
  PERFORM MAKE_FIELDCAT_0100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET-FIELDCAT2
*&---------------------------------------------------------------------*
FORM GET_FIELDCAT2  USING    PT_TAB TYPE STANDARD TABLE
                    CHANGING PT_FCAT TYPE LVC_T_FCAT.

  DATA: LO_DREF TYPE REF TO DATA.

  CREATE DATA LO_DREF LIKE PT_TAB.
  FIELD-SYMBOLS <LT_TAB> TYPE TABLE.
  ASSIGN LO_DREF->* TO <LT_TAB>.

  TRY.
      CALL METHOD CL_SALV_TABLE=>FACTORY
        IMPORTING
          R_SALV_TABLE = DATA(LR_TABLE)
        CHANGING
          T_TABLE      = <LT_TAB>.
    CATCH CX_SALV_MSG. " ALV: General Error Class with Message
  ENDTRY.

  PT_FCAT = CL_SALV_CONTROLLER_METADATA=>GET_LVC_FIELDCATALOG(
            R_COLUMNS = LR_TABLE->GET_COLUMNS( )
            R_AGGREGATIONS = LR_TABLE->GET_AGGREGATIONS( ) ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM MAKE_FIELDCAT_0100 .

  LOOP AT GT_FIELDCAT INTO GS_FIELDCAT.

    CASE GS_FIELDCAT-FIELDNAME.

      WHEN 'STATUS'.
        GS_FIELDCAT-COLTEXT = TEXT-F01.

      WHEN 'WERKS'.
        GS_FIELDCAT-JUST = 'C'.
      WHEN 'SCODE'.
*        GS_FIELDCAT-LOWERCASE = ABAP_ON.
        GS_FIELDCAT-JUST = 'C'.
      WHEN 'STYPE'.
        GS_FIELDCAT-COLTEXT = TEXT-F03.
        GS_FIELDCAT-JUST = 'C'.
        GS_FIELDCAT-EDIT = ABAP_ON.
      WHEN 'SNAME'.
        GS_FIELDCAT-COLTEXT = TEXT-F02.
        GS_FIELDCAT-EDIT = ABAP_ON.

      WHEN 'STTEL'.
        GS_FIELDCAT-EDIT = ABAP_ON.
      WHEN 'ADDRESS'.
        GS_FIELDCAT-EDIT = ABAP_ON.
      WHEN 'TELNO'.
        GS_FIELDCAT-EDIT = ABAP_ON.




    ENDCASE.

    MODIFY GT_FIELDCAT FROM GS_FIELDCAT.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_LAYOUT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_LAYOUT_0100 .

  CLEAR GS_LAYOUT.
  CLEAR GS_VARIANT.
  CLEAR GV_SAVE.

  GS_VARIANT-REPORT = SY-REPID.
  GV_SAVE = 'A'.

  GS_LAYOUT-CWIDTH_OPT = 'X'.
  GS_LAYOUT-ZEBRA      = ABAP_ON.
  GS_LAYOUT-SEL_MODE   = 'D'.
  GS_LAYOUT-STYLEFNAME  = 'STYLE'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_SEARCH
*&---------------------------------------------------------------------*
FORM SET_SEARCH .

*  PERFORM READ_MMT060 USING GS_DISPLAY-WERKS.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form READ_MMT060
*&---------------------------------------------------------------------*
FORM READ_MMT060  USING    P_GS_DISPLAY_WERKS.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SEARCH_MT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SEARCH_MT .

*  RANGES R_WERKS FOR ZEA_MMT060-WERKS.
*  RANGES R_SCODE FOR ZEA_MMT060-SCODE.
*  RANGES R_STYPE FOR ZEA_MMT060-STYPE.
*
*  REFRESH R_WERKS[].
*  CLEAR R_WERKS.
*  REFRESH R_SCODE[].
*  CLEAR R_SCODE.
*  REFRESH R_STYPE[].
*  CLEAR R_STYPE.
*
*
*  IF SO_WERKS IS NOT INITIAL.
*    R_WERKS-SIGN    = 'I'.
*    R_WERKS-OPTION  = 'EQ'.
*    R_WERKS-LOW     = GS_DATA-WERKS.
*    APPEND R_WERKS.
*  ENDIF.
*
*  IF SO_SCODE IS NOT INITIAL.
*    R_SCODE-SIGN    = 'i'.
*    R_SCODE-OPTION  = 'eq'.
*    R_SCODE-LOW     = GS_DATA-SCODE.
*    APPEND R_SCODE.
*  ENDIF.
*
*  IF SO_STYPE IS NOT INITIAL.
*    R_STYPE-SIGN    = 'i'.
*    R_STYPE-OPTION  = 'eq'.
*    R_STYPE-LOW     = GS_DATA-STYPE.
*    APPEND R_STYPE.
*  ENDIF.

  SELECT *
  FROM ZEA_MMT060
  INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY
  WHERE WERKS IN SO_WERKS
    AND SCODE  IN SO_SCODE
    AND STYPE  IN SO_STYPE
    AND SNAME  IN SO_SNAME.
  SORT GT_DISPLAY BY WERKS SCODE.

  LOOP AT GT_DISPLAY INTO DATA(GS_DISPLAY).

    CASE GS_DISPLAY-STYPE.
      WHEN '공장'.
        GS_DISPLAY-STATUS = ICON_PPE_PLINE.
      WHEN '창고'.
        GS_DISPLAY-STATUS = ICON_TRANSPORT_POINT.
      WHEN OTHERS.
        GS_DISPLAY-STATUS = ICON_LED_RED.
    ENDCASE.

    " 내부 테이블 업데이트
    MODIFY GT_DISPLAY FROM GS_DISPLAY.
  ENDLOOP.


*  IF ZEA_MMT060-WERKS IS INITIAL AND ZEA_MMT060-SCODE IS INITIAL
*     AND ZEA_MMT060-STYPE IS INITIAL.
*    SELECT *
*      FROM ZEA_MMT060
*      INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY.
*
*  ELSE.
*    REFRESH R_WERKS[].
*
*    CLEAR R_WERKS.
*    R_WERKS-SIGN    = 'I'.
*    R_WERKS-OPTION  = 'EQ'.
*    R_WERKS-LOW     = ZEA_MMT060-WERKS.
*    R_WERKS-HIGH     = ''.
**    APPEND R_WERKS.
*
*    REFRESH R_SCODE[].
*    CLEAR R_SCODE.
*    R_SCODE-SIGN    = 'I'.
*    R_SCODE-OPTION  = 'EQ'.
*    R_SCODE-LOW     = ZEA_MMT060-SCODE.
*    R_SCODE-HIGH     = ''.
**    APPEND R_SCODE.
*
*    REFRESH R_STYPE[].
*    CLEAR R_SCODE.
*    R_STYPE-SIGN    = 'I'.
*    R_STYPE-OPTION  = 'EQ'.
*    R_STYPE-LOW     = ZEA_MMT060-SCODE.
*    R_STYPE-HIGH     = ''.
*    APPEND R_STYPE.
*
*
*  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form EDIT_MODE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM EDIT_MODE .
  CLEAR GS_DISPLAY.
  ZEA_MMT060-AENAM = SY-UNAME.
  ZEA_MMT060-AEZET = SY-UZEIT.
  ZEA_MMT060-AEDAT = SY-DATUM.



  DATA LV_CHECK TYPE I.

  LV_CHECK = GO_ALV_GRID->IS_READY_FOR_INPUT( ).

  IF LV_CHECK EQ 0.
    LV_CHECK = 1.

  ELSE.
    LV_CHECK = 0.
  ENDIF.


  CALL METHOD GO_ALV_GRID->SET_READY_FOR_INPUT
    EXPORTING
      I_READY_FOR_INPUT = LV_CHECK.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLER_TOOLBAR
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_OBJECT
*&      --> SENDER
*&---------------------------------------------------------------------*
FORM HANDLER_TOOLBAR
  USING PO_OBJECT TYPE REF TO CL_ALV_EVENT_TOOLBAR_SET
        PO_SENDER TYPE REF TO CL_GUI_ALV_GRID.

  DATA LS_TOOLBAR LIKE LINE OF PO_OBJECT->MT_TOOLBAR.

  DATA : LV_FAC TYPE I,
         LV_STR TYPE I,
         LV_OTH TYPE I,
         LV_ALL TYPE I.


  CASE PO_SENDER.
    WHEN GO_ALV_GRID.

      LOOP AT  GT_DISPLAY INTO GS_DISPLAY.

        CASE GS_DISPLAY-STYPE.
          WHEN '공장'.
            ADD 1 TO LV_ALL.
            ADD 1 TO LV_FAC.
          WHEN '창고'.
            ADD 1 TO LV_ALL.
            ADD 1 TO LV_STR.
          WHEN OTHERS.
*          WHEN OTHERS.
*            ADD 1 TO LV_OTH.
            CASE GS_DISPLAY-STATUS.
              WHEN ICON_LED_RED.
                ADD 1 TO LV_ALL.
                ADD 1 TO LV_OTH.
            ENDCASE.
        ENDCASE.


      ENDLOOP.

* 구분자 =>> |
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 3. " 구분자
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

*      CLEAR LS_TOOLBAR.
*      LS_TOOLBAR-BUTN_TYPE = 0.
*      LS_TOOLBAR-FUNCTION = GC_FACA.
*      LS_TOOLBAR-ICON = ICON_PPE_PLINE.
*      LS_TOOLBAR-TEXT = TEXT-L06 && ':' && LV_FACA.
*      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.
*
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 0.
      LS_TOOLBAR-FUNCTION = GC_FIN_ALL.
*      LS_TOOLBAR-ICON = ICON_TRANSPORT_POINT.
      LS_TOOLBAR-TEXT = TEXT-L11 && ':' && LV_ALL.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 공장
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 0.
      LS_TOOLBAR-FUNCTION = GC_FACTORY.
      LS_TOOLBAR-ICON = ICON_PPE_PLINE.
      LS_TOOLBAR-TEXT = TEXT-L10 && ':' && LV_FAC.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 창고
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 0.
      LS_TOOLBAR-FUNCTION = GC_STORAGE.
      LS_TOOLBAR-ICON = ICON_TRANSPORT_POINT.
      LS_TOOLBAR-TEXT = TEXT-L07 && ':' && LV_STR.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.



      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 0.
      LS_TOOLBAR-FUNCTION = GC_OTHERS.
      LS_TOOLBAR-ICON = ICON_LED_RED.
      LS_TOOLBAR-TEXT = TEXT-L08 && ':' && LV_OTH.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.



  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_USER_COMMAND
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_UCOMM
*&      --> SENDER
*&---------------------------------------------------------------------*
FORM HANDLE_USER_COMMAND  USING PV_UCOMM TYPE SY-UCOMM
                                PO_SENDER TYPE REF TO CL_GUI_ALV_GRID.

  CASE PO_SENDER.
    WHEN GO_ALV_GRID.
      CASE PV_UCOMM.

        WHEN GC_FIN_ALL.
          PERFORM ALL_FILTER.
          PERFORM SET_ALV_FILTER.

        WHEN GC_FACTORY.
          PERFORM FAC_FILTER.
          PERFORM SET_ALV_FILTER.

        WHEN GC_STORAGE.
          PERFORM STR_FILTER.
          PERFORM SET_ALV_FILTER.

        WHEN GC_OTHERS.
          PERFORM OTH_FILTER.
          PERFORM SET_ALV_FILTER.

      ENDCASE.
  ENDCASE.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_DATA_CHANGED
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ER_DATA_CHANGED
*&      --> SENDER
*&---------------------------------------------------------------------*
FORM HANDLE_DATA_CHANGED
  USING PR_DATA_CHANGED TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
        PR_SENDER TYPE REF TO CL_GUI_ALV_GRID.


  DATA(LT_MOD) = PR_DATA_CHANGED->MT_MOD_CELLS[].

  IF LT_MOD[] IS NOT INITIAL.
    GV_CHANGED = ABAP_ON.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form DATA_INSERT
*&---------------------------------------------------------------------*
FORM DATA_INSERT .

  CALL SCREEN 0110 STARTING AT 50 5.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  EXIT_0110  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE EXIT_0110 INPUT.
  CASE OK_CODE.
    WHEN 'CANC'.
      MESSAGE S000 DISPLAY LIKE 'W' WITH '생성 작업이 취소되었습니다.'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0110  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0110 INPUT.
  DATA: RAD1 TYPE ABAP_BOOL,
        RAD2 TYPE ABAP_BOOL.

  CASE OK_CODE.
    WHEN 'SAVE'.
      CLEAR GS_DISPLAY.

      IF RAD1 = ABAP_TRUE.

        ZEA_MMT060-STYPE = '공장'.
        GS_DISPLAY-STYPE = ZEA_MMT060-STYPE.
        GS_DISPLAY-STATUS = ICON_PPE_PLINE.
*        PERFORM GET_INFO_NUMBERRANGE.
        PERFORM GET_INFO_NUMBERRANGE2.

      ELSEIF RAD2 = ABAP_TRUE.
        ZEA_MMT060-STYPE = '창고'.
        GS_DISPLAY-STYPE = ZEA_MMT060-STYPE.
        GS_DISPLAY-STATUS = ICON_TRANSPORT_POINT.
*        PERFORM GET_INFO_NUMBERRANGE.
        PERFORM GET_INFO_NUMBERRANGE3.
      ENDIF.


      DATA LS_MMT060 TYPE ZEA_MMT060.

      LS_MMT060-WERKS    = ZEA_MMT060-WERKS.
      LS_MMT060-SCODE  = ZEA_MMT060-SCODE.
      LS_MMT060-STYPE        = ZEA_MMT060-STYPE.
      LS_MMT060-SNAME   = ZEA_MMT060-SNAME.
      LS_MMT060-STTEL   = ZEA_MMT060-STTEL.
      LS_MMT060-ADDRESS   = ZEA_MMT060-ADDRESS.
      LS_MMT060-TELNO   = ZEA_MMT060-TELNO.

      MOVE-CORRESPONDING ZEA_MMT060 TO GS_DISPLAY.
      MOVE-CORRESPONDING GT_DISPLAY TO GT_DATA.

      INSERT ZEA_MMT060 FROM LS_MMT060.

      GS_DISPLAY-WERKS = ZEA_MMT060-WERKS.

      IF SY-SUBRC = 0.
        APPEND GS_DISPLAY TO GT_DISPLAY.

        COMMIT WORK AND WAIT.

        MESSAGE S015.  " 데이터 성공적으로 저장되었습니다.
        LEAVE TO SCREEN 0.
      ELSE.
        ROLLBACK WORK. " 데이터 저장 중 오류가 발생했습니다.
        MESSAGE E016.
      ENDIF.

  ENDCASE.


ENDMODULE.
*&---------------------------------------------------------------------*
*& Form DATA_SAVE
*&---------------------------------------------------------------------*
FORM DATA_SAVE .

  DATA LT_MMT060 TYPE TABLE OF ZEA_MMT060.
  DATA LV_SUBRC TYPE I.

  DATA LV_TABIX LIKE SY-TABIX.

  LOOP AT GT_DISPLAY INTO GS_DISPLAY.
******************************
    LV_TABIX = SY-TABIX.
******************************
    READ TABLE GT_DATA INTO GS_DATA INDEX SY-TABIX.

    IF GS_DISPLAY-WERKS NE GS_DATA-WERKS
    OR GS_DISPLAY-SCODE NE GS_DATA-SCODE
    OR GS_DISPLAY-STYPE NE GS_DATA-STYPE
    OR GS_DISPLAY-SNAME  NE GS_DATA-SNAME
    OR GS_DISPLAY-STTEL NE GS_DATA-STTEL
    OR GS_DISPLAY-ADDRESS NE GS_DATA-ADDRESS
    OR GS_DISPLAY-TELNO NE GS_DATA-TELNO.

    ENDIF.


    MODIFY GT_DISPLAY
      FROM GS_DISPLAY
*****************************
*      INDEX SY-TABIX  "이게 잘못됨.
      INDEX LV_TABIX.
*****************************



  ENDLOOP.

  MOVE-CORRESPONDING GT_DISPLAY TO GT_DATA.

  MODIFY GT_DISPLAY
    FROM GS_DISPLAY
    INDEX LV_TABIX.

  MOVE-CORRESPONDING GT_DISPLAY TO LT_MMT060.

  MODIFY ZEA_MMT060 FROM TABLE LT_MMT060.
  IF SY-SUBRC NE 0.
    ADD SY-SUBRC TO LV_SUBRC.
  ENDIF.

*    MOVE-CORRESPONDING GT_DISPLAY TO LT_MMT060.
*    MODIFY ZEA_MMT060.
  MOVE-CORRESPONDING GS_DISPLAY TO GS_DATA.

  IF LV_SUBRC EQ 0.

    COMMIT WORK AND WAIT.
    MESSAGE S015.
  ELSE.
    ROLLBACK WORK.
    MESSAGE S016 DISPLAY LIKE 'E'.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form DELETE_DATA
*&---------------------------------------------------------------------*
FORM DELETE_DATA .
  DATA: LT_INDEX_ROWS   TYPE LVC_T_ROW,
        LS_INDEX_ROW    LIKE LINE OF LT_INDEX_ROWS,
        LV_SUBRC        TYPE I,
        LV_COUNT        TYPE I,
        LT_DELETE_INDEX TYPE TABLE OF SY-TABIX,
        LV_INDEX        TYPE SY-TABIX.

  CALL METHOD GO_ALV_GRID->GET_SELECTED_ROWS
    IMPORTING
      ET_INDEX_ROWS = LT_INDEX_ROWS.

  IF LT_INDEX_ROWS[] IS INITIAL.
    MESSAGE '최소 한 행 이상 선택하세요' TYPE 'W'.
  ELSE.
    " 선택된 행의 인덱스 수집
    LOOP AT LT_INDEX_ROWS INTO LS_INDEX_ROW.
      APPEND LS_INDEX_ROW-INDEX TO LT_DELETE_INDEX.
    ENDLOOP.

    " 인덱스를 역순으로 정렬
    SORT LT_DELETE_INDEX DESCENDING.

    " 역순으로 삭제 진행
    LOOP AT LT_DELETE_INDEX INTO LV_INDEX.
      READ TABLE GT_DISPLAY INTO GS_DISPLAY INDEX LV_INDEX.
      IF SY-SUBRC = 0.
        DELETE FROM ZEA_MMT060 WHERE STYPE = GS_DISPLAY-STYPE.
        IF SY-SUBRC = 0.
          LV_COUNT += 1.
        ENDIF.
        DELETE GT_DISPLAY INDEX LV_INDEX.
      ENDIF.
    ENDLOOP.

    " 결과 처리
    IF LV_COUNT > 0.
      COMMIT WORK AND WAIT.
      MESSAGE S000 WITH LV_COUNT '건의 데이터가 삭제되었습니다.'.
      PERFORM REFRESH_ALV_0100.
    ELSE.
      ROLLBACK WORK.
      MESSAGE '데이터 삭제를 실패하였습니다' TYPE 'E'.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_INFO_NUMBERRANGE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM GET_INFO_NUMBERRANGE .
  DATA : NR_RANGE_NR  LIKE  INRI-NRRANGENR.
  DATA : OBJECT       LIKE  INRI-OBJECT.
  DATA : QUANTITY     LIKE  INRI-QUANTITY.
  DATA : GV_NUM       TYPE  I.

  CLEAR: NR_RANGE_NR, OBJECT, QUANTITY.
  NR_RANGE_NR = '01'.
  OBJECT      = 'ZEA_MMNR2'.
  QUANTITY    = 1.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      NR_RANGE_NR             = NR_RANGE_NR
      OBJECT                  = OBJECT
      QUANTITY                = QUANTITY
    IMPORTING
      NUMBER                  = ZEA_MMT060-WERKS
    EXCEPTIONS
      INTERVAL_NOT_FOUND      = 1
      NUMBER_RANGE_NOT_INTERN = 2
      OBJECT_NOT_FOUND        = 3
      QUANTITY_IS_0           = 4
      QUANTITY_IS_NOT_1       = 5
      INTERVAL_OVERFLOW       = 6
      BUFFER_OVERFLOW         = 7
      OTHERS                  = 8.

***** Case 1 (Old Syntax)
*  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
*  EXPORTING INPUT  = ZEA_MMT010-MATNR
*  IMPORTING OUTPUT = ZEA_MMT010-MATNR.

***** Case 2 (New Syntax)
  ZEA_MMT060-WERKS = |{ ZEA_MMT060-WERKS ALPHA = OUT  }|.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_INFO_NUMBERRANGE2
*&---------------------------------------------------------------------*
FORM GET_INFO_NUMBERRANGE2 .
  DATA : NR_RANGE_NR  LIKE  INRI-NRRANGENR.
  DATA : OBJECT       LIKE  INRI-OBJECT.
  DATA : QUANTITY     LIKE  INRI-QUANTITY.
  DATA : GV_NUM       TYPE  ZEC_SDT060-VBELN.

  CLEAR: NR_RANGE_NR, OBJECT, QUANTITY.
  NR_RANGE_NR = '01'.
  OBJECT      = 'ZEA_MMNR3'.   " NUMBER RANGE 만든 이름
  QUANTITY    = 1.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      NR_RANGE_NR = '01'
      OBJECT      = 'ZEA_MMNR3'
      QUANTITY    = 1
    IMPORTING
      NUMBER      = GV_NUM
    EXCEPTIONS
      OTHERS      = 1.

  ZEA_MMT060-SCODE = 'PL' && GV_NUM.




*    DATA : NR_RANGE_NR  LIKE  INRI-NRRANGENR.
*  DATA : OBJECT       LIKE  INRI-OBJECT.
*  DATA : QUANTITY     LIKE  INRI-QUANTITY.
*  DATA : GV_NUM       TYPE  I.
*
*  CLEAR: NR_RANGE_NR, OBJECT, QUANTITY.
*  NR_RANGE_NR = '01'.
*  OBJECT      = 'ZEA_MMNR3'.
*  QUANTITY    = 1.
*
*  CALL FUNCTION 'NUMBER_GET_NEXT'
*    EXPORTING
*      NR_RANGE_NR             = NR_RANGE_NR
*      OBJECT                  = OBJECT
*      QUANTITY                = QUANTITY
*    IMPORTING
*      NUMBER                  = ZEA_MMT060-SCODE
*    EXCEPTIONS
*      INTERVAL_NOT_FOUND      = 1
*      NUMBER_RANGE_NOT_INTERN = 2
*      OBJECT_NOT_FOUND        = 3
*      QUANTITY_IS_0           = 4
*      QUANTITY_IS_NOT_1       = 5
*      INTERVAL_OVERFLOW       = 6
*      BUFFER_OVERFLOW         = 7
*      OTHERS                  = 8.
*  ZEA_MMT060-SCODE = 'SL' && GV_NUM.
*
****** Case 1 (Old Syntax)
**  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
**  EXPORTING INPUT  = ZEA_MMT010-MATNR
**  IMPORTING OUTPUT = ZEA_MMT010-MATNR.
*
****** Case 2 (New Syntax)
*  ZEA_MMT060-SCODE = |{ ZEA_MMT060-SCODE ALPHA = OUT  }|.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_INFO_NUMBERRANGE3
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM GET_INFO_NUMBERRANGE3 .
  DATA : NR_RANGE_NR  LIKE  INRI-NRRANGENR.
  DATA : OBJECT       LIKE  INRI-OBJECT.
  DATA : QUANTITY     LIKE  INRI-QUANTITY.
  DATA : GV_NUM       TYPE  ZEC_SDT060-VBELN.

  CLEAR: NR_RANGE_NR, OBJECT, QUANTITY.
  NR_RANGE_NR = '01'.
  OBJECT      = 'ZEA_MMNR4'.   " NUMBER RANGE 만든 이름
  QUANTITY    = 1.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      NR_RANGE_NR = '01'
      OBJECT      = 'ZEA_MMNR4'
      QUANTITY    = 1
    IMPORTING
      NUMBER      = GV_NUM
    EXCEPTIONS
      OTHERS      = 1.

  ZEA_MMT060-SCODE = 'SL' && GV_NUM.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_EVENT_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_ALV_EVENT_0100 .
  CALL METHOD GO_ALV_GRID->SET_READY_FOR_INPUT
    EXPORTING
      I_READY_FOR_INPUT = 0.

  CALL METHOD GO_ALV_GRID->REGISTER_EDIT_EVENT
    EXPORTING
      I_EVENT_ID = CL_GUI_ALV_GRID=>MC_EVT_MODIFIED
    EXCEPTIONS
      ERROR      = 1                " Error
      OTHERS     = 2.

  SET HANDLER LCL_EVENT_HANDLER=>ON_TOOLBAR FOR GO_ALV_GRID.
  SET HANDLER LCL_EVENT_HANDLER=>ON_DATA_CHANGED FOR GO_ALV_GRID.
  SET HANDLER LCL_EVENT_HANDLER=>ON_USER_COMMAND FOR GO_ALV_GRID.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form FAC_FILTER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FAC_FILTER .
  REFRESH GT_FILTER.

  CLEAR GS_FILTER.
  GS_FILTER-FIELDNAME = 'STYPE'.
  GS_FILTER-SIGN      = 'I'.
  GS_FILTER-OPTION    = 'EQ'.
  GS_FILTER-LOW       = '공장'.
  APPEND GS_FILTER TO GT_FILTER.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FILTER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_ALV_FILTER .
  " ALV에 Filter 정보를 적용하는 과정
  CALL METHOD GO_ALV_GRID->SET_FILTER_CRITERIA
    EXPORTING
      IT_FILTER = GT_FILTER                " Filter Conditions
    EXCEPTIONS
      OTHERS    = 1.

  IF SY-SUBRC NE 0.
    MESSAGE E000 WITH '필터 적용에 실패하였습니다'.
  ENDIF.

  " ALV가 새로고침될 때, 현재 라인, 열을 유지할 지
  DATA LS_STABLE TYPE LVC_S_STBL.
  LS_STABLE-ROW = 'X'.
  LS_STABLE-COL = 'X'.


CALL METHOD go_alv_grid->refresh_table_display.


  CALL METHOD GO_ALV_GRID->REFRESH_TABLE_DISPLAY
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
*& Form STR_FILTER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM STR_FILTER .
  REFRESH GT_FILTER.

  CLEAR GS_FILTER.
  GS_FILTER-FIELDNAME = 'STYPE'.
  GS_FILTER-SIGN      = 'I'.
  GS_FILTER-OPTION    = 'EQ'.
  GS_FILTER-LOW       = '창고'.
  APPEND GS_FILTER TO GT_FILTER.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form OTH_FILTER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM OTH_FILTER .
  REFRESH GT_FILTER.

  CLEAR GS_FILTER.
  GS_FILTER-FIELDNAME = 'STATUS'.
  GS_FILTER-SIGN      = 'I'.
  GS_FILTER-OPTION    = 'EQ'.
  GS_FILTER-LOW       = ICON_LED_RED.
  APPEND GS_FILTER TO GT_FILTER.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form ALL_FILTER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM ALL_FILTER .
  REFRESH GT_FILTER.

  CLEAR GS_FILTER.
  APPEND GS_FILTER TO GT_FILTER.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form BACK_RTN
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM BACK_RTN .
   READ TABLE GT_DISPLAY WITH KEY STATUS = ICON_PPE_PLINE
   TRANSPORTING NO FIELDS.
   IF SY-SUBRC EQ 0.
     LV_ANSWER = 'X'.
   ENDIF.

  "오류 데이터가 있을 경우
   READ TABLE GT_DISPLAY WITH KEY STATUS = ICON_TRANSPORT_POINT
    TRANSPORTING NO FIELDS.
   IF SY-SUBRC EQ 0.
     LV_ANSWER = 'X'.
   ENDIF.

  "신규 데이터가 있을 경우
   READ TABLE GT_DISPLAY WITH KEY STATUS = ICON_LED_RED
   TRANSPORTING NO FIELDS.
   IF SY-SUBRC EQ 0.
     LV_ANSWER = 'X'.
   ENDIF.

  "팝업
   IF LV_ANSWER EQ 'X'.
     CLEAR: LV_ANSWER.
     CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
        EXPORTING
          DEFAULTOPTION  = 'N'
          TEXTLINE1      = '저장되지 않은 데이터가 있습니다.'
          TEXTLINE2      = '종료하시겠습니까?'
          TITEL          = 'Cancel'
          CANCEL_DISPLAY = ' '
        IMPORTING
          ANSWER         = LV_ANSWER.
     IF LV_ANSWER NE 'J'.
       MESSAGE '취소되었습니다.' TYPE 'S'.
       EXIT.
     ENDIF.
   ENDIF.

   IF GO_ALV_GRID IS NOT INITIAL.
     CALL METHOD GO_ALV_GRID->FREE.
     CALL METHOD GO_CONTAINER->FREE.
     CLEAR: GO_ALV_GRID, GO_CONTAINER.
   ENDIF.

   PERFORM PROGRAM_UNLOCKED.
   LEAVE TO SCREEN 0.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form PROGRAM_UNLOCKED
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM PROGRAM_UNLOCKED .
  DATA : LV_NAME TYPE SY-REPID.
  LV_NAME = SY-REPID.

  CALL FUNCTION 'DEQUEUE_E_TRDIR'
   EXPORTING
     MODE_TRDIR   = 'X'
     NAME         = LV_NAME
     X_NAME       = ' '
     _SCOPE       = '3'
     _SYNCHRON    = ' '
     _COLLECT     = ' '.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form MMT060_F4_HELP
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM MMT060_F4_HELP .
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
        ZEA_MMT060-WERKS       = LTT001W_WERKS-WERKS.
        GS_DATA-PNAME1              = LTT001W_WERKS-PNAME1.
      ZEA_MMT060-WERKS       = LTT001W_WERKS-SCODE.


        LEAVE SCREEN.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.
