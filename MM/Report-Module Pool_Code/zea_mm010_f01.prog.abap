*&---------------------------------------------------------------------*
*& Include          ZALV_GRID_CRUD_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form MAKE_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM MAKE_FIELDCAT_0100 .


  LOOP AT GT_FIELDCAT INTO GS_FIELDCAT.
*
*    CASE ABAP_ON.
*      WHEN GS_FIELDCAT-KEY.
*        GS_FIELDCAT-EDIT = ABAP_OFF.  " 키필드는 수정 불가능
*      WHEN OTHERS.
*        GS_FIELDCAT-EDIT = ABAP_ON.   " 이외 필드 수정 가능
*    ENDCASE.

    CASE GS_FIELDCAT-FIELDNAME.

      WHEN 'MATNR'.
        GS_FIELDCAT-KEY = ABAP_ON.

      WHEN 'STATUS'.
        GS_FIELDCAT-COLTEXT = '품목'.

      WHEN 'MAKTX'.
*        GS_FIELDCAT-EDIT = ABAP_OFF.
      WHEN 'MATTYPE'.
        GS_FIELDCAT-EDIT = ABAP_ON.
      WHEN 'MATGRP'.
        GS_FIELDCAT-EDIT  = ABAP_ON.
      WHEN 'BSTME'.
        GS_FIELDCAT-EDIT  = ABAP_ON.
        GS_FIELDCAT-QFIELDNAME = 'MEINS2'.
      WHEN 'MEINS2'.
        GS_FIELDCAT-EDIT  = ABAP_ON.
      WHEN 'WEIGHT'.
        GS_FIELDCAT-EDIT  = ABAP_ON.
        GS_FIELDCAT-QFIELDNAME = 'MEINS1'.
      WHEN 'MEINS1'.
        GS_FIELDCAT-EDIT  = ABAP_ON.
      WHEN 'STPRS'.
        GS_FIELDCAT-EDIT  = ABAP_ON.
        GS_FIELDCAT-CFIELDNAME = 'WAERS'.
      WHEN 'WAERS'.
        GS_FIELDCAT-EDIT  = ABAP_ON.
      WHEN 'LOEKZ'.
        GS_FIELDCAT-EDIT  = ABAP_ON.
        GS_FIELDCAT-CHECKBOX = 'X'.


      WHEN 'LIGHT'.
        GS_FIELDCAT-TECH  = ABAP_ON.
      WHEN 'MARK'.
        GS_FIELDCAT-TECH  = ABAP_ON.
      WHEN 'ERNAM'.
        GS_FIELDCAT-EDIT = ABAP_OFF.
      WHEN 'ERDAT'.
        GS_FIELDCAT-EDIT = ABAP_OFF.
      WHEN 'ERZET'.
        GS_FIELDCAT-EDIT = ABAP_OFF.
      WHEN 'AENAM'.
        GS_FIELDCAT-TECH = ABAP_ON.
      WHEN 'AEDAT'.
        GS_FIELDCAT-TECH = ABAP_ON.
      WHEN 'AEZET'.
        GS_FIELDCAT-TECH = ABAP_ON.

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
  GS_LAYOUT-STYLEFNAME  = 'STYLE'.          " 스타일

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_DATA
*&---------------------------------------------------------------------*
FORM SELECT_DATA .

  REFRESH GT_DATA.

  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE GT_DATA
    FROM ZEA_MMT010 AS A
    INNER JOIN ZEA_MMT020 AS B
    ON A~MATNR EQ B~MATNR
    AND SPRAS EQ SY-LANGU.

  SORT GT_DATA BY MATNR.
  MOVE-CORRESPONDING GS_DATA TO GS_DISPLAY.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM MAKE_DISPLAY_DATA .

  REFRESH GT_DISPLAY.

  LOOP AT GT_DATA INTO GS_DATA.

    CLEAR GS_DISPLAY.

    MOVE-CORRESPONDING GS_DATA TO GS_DISPLAY.

*신규 필드------------------------------------------------------------*

    IF GS_DISPLAY-MATTYPE = '원자재'.

      GS_DISPLAY-STATUS = ICON_LED_YELLOW. " LED 등

    ELSEIF GS_DISPLAY-MATTYPE = '반제품'.

      GS_DISPLAY-STATUS = ICON_LED_GREEN. " LED 등

    ELSEIF GS_DISPLAY-MATTYPE = '완제품'.
      GS_DISPLAY-STATUS = ICON_BUSINAV_PROC_EXIST. " LED 등
    ENDIF.



*--------------------------------------------------------------------*
    APPEND GS_DISPLAY TO GT_DISPLAY.

  ENDLOOP.

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

* 만약 현재 프로그램이 배치 모드에서 실행 중이라면 프로그램을 종료합니다.
  IF NOT SY-BATCH IS INITIAL. EXIT. ENDIF.

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

  IF SY-SUBRC NE 0.
    MESSAGE E020.
  ENDIF.


  CREATE OBJECT GO_ALV_GRID
    EXPORTING
      I_PARENT = GO_CONTAINER
    EXCEPTIONS
      OTHERS   = 1.

  IF SY-SUBRC NE 0.
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
*     IT_SORT                       =
*     IT_FILTER                     =
    EXCEPTIONS
      INVALID_PARAMETER_COMBINATION = 1
      PROGRAM_ERROR                 = 2
      TOO_MANY_LINES                = 3
      OTHERS                        = 4.

  IF SY-SUBRC <> 0.
    MESSAGE E023.
  ENDIF.

  CALL METHOD CL_GUI_CFW=>FLUSH
    EXCEPTIONS
      CNTL_SYSTEM_ERROR = 1
      CNTL_ERROR        = 2
      OTHERS            = 3.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_FIELDCAT_0100 .
  PERFORM GET_FIELDCAT2   USING    GT_DISPLAY
                          CHANGING GT_FIELDCAT.

  PERFORM MAKE_FIELDCAT_0100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_EVENT_0100
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
*& Form GET_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM GET_FIELDCAT_0100 .

  DATA: LT_FIELDCAT TYPE KKBLO_T_FIELDCAT.

  REFRESH GT_FIELDCAT.

  CALL FUNCTION 'K_KKB_FIELDCAT_MERGE'
    EXPORTING
      I_CALLBACK_PROGRAM     = SY-REPID
      I_TABNAME              = 'GS_DISPLAY'
*     I_STRUCNAME            =
      I_INCLNAME             = SY-REPID
      I_BYPASSING_BUFFER     = ABAP_ON
      I_BUFFER_ACTIVE        = ABAP_OFF
    CHANGING
      CT_FIELDCAT            = LT_FIELDCAT
    EXCEPTIONS
      INCONSISTENT_INTERFACE = 1
      OTHERS                 = 2.

  IF SY-SUBRC EQ 0.
    CALL FUNCTION 'LVC_TRANSFER_FROM_KKBLO'
      EXPORTING
        IT_FIELDCAT_KKBLO = LT_FIELDCAT " KKBLO
      IMPORTING
        ET_FIELDCAT_LVC   = GT_FIELDCAT " LVC
      EXCEPTIONS
        IT_DATA_MISSING   = 1
        OTHERS            = 2.

    IF SY-SUBRC NE 0.
      MESSAGE E022.
    ENDIF.

  ELSE.
    MESSAGE E022.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_FIELDCAT2
*&---------------------------------------------------------------------*
FORM GET_FIELDCAT2 USING PT_TAB TYPE STANDARD TABLE
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
              R_COLUMNS      = LR_TABLE->GET_COLUMNS( )
              R_AGGREGATIONS = LR_TABLE->GET_AGGREGATIONS( )
            ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FILTER
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
  LS_STABLE-ROW = ABAP_ON.
  LS_STABLE-COL = ABAP_ON.

  " 적용된 Filter 기준으로 데이터를 출력
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
*& Form DATA_SAVE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DATA_SAVE .

  DATA LT_MMT010 TYPE TABLE OF ZEA_MMT010.
  DATA LT_MMT020 TYPE TABLE OF ZEA_MMT020.
  DATA LV_SUBRC TYPE I.

******************************
  DATA : LV_TABIX LIKE SY-TABIX.
******************************

  LOOP AT GT_DISPLAY INTO GS_DISPLAY.
******************************
*    LV_TABIX = SY-TABIX.
******************************
    READ TABLE GT_DATA INTO GS_DATA WITH KEY MATNR = GS_DISPLAY-MATNR.
    IF SY-SUBRC EQ 0.

      IF GS_DISPLAY-MATNR NE GS_DATA-MATNR
      OR GS_DISPLAY-MAKTX NE GS_DATA-MAKTX
      OR GS_DISPLAY-MATTYPE NE GS_DATA-MATTYPE
      OR GS_DISPLAY-MATGRP  NE GS_DATA-MATGRP
      OR GS_DISPLAY-WEIGHT NE GS_DATA-WEIGHT
      OR GS_DISPLAY-MEINS1 NE GS_DATA-MEINS1
      OR GS_DISPLAY-BSTME NE GS_DATA-BSTME
      OR GS_DISPLAY-MEINS2 NE GS_DATA-MEINS2
      OR GS_DISPLAY-LOEKZ NE GS_DATA-LOEKZ.

      ENDIF.

    ENDIF.

    GS_DISPLAY-SPRAS = SY-LANGU.

    MODIFY GT_DISPLAY
      FROM GS_DISPLAY

*****************************
*      INDEX SY-TABIX  "이게 잘못됨.
*      INDEX LV_TABIX
*****************************
      TRANSPORTING AENAM AEDAT AEZET SPRAS.


  ENDLOOP.

  MOVE-CORRESPONDING GT_DISPLAY TO GT_DATA.
  MOVE-CORRESPONDING GT_DISPLAY TO LT_MMT010.
  MOVE-CORRESPONDING GT_DISPLAY TO LT_MMT020.



  MODIFY ZEA_MMT010 FROM TABLE LT_MMT010.
  IF SY-SUBRC NE 0.
    ADD SY-SUBRC TO LV_SUBRC.
  ENDIF.


  MODIFY ZEA_MMT020 FROM TABLE LT_MMT020.
  IF SY-SUBRC NE 0.
    ADD SY-SUBRC TO LV_SUBRC.

  ENDIF.



  IF LV_SUBRC EQ 0.

    COMMIT WORK AND WAIT.
    MESSAGE S015.
  ELSE.
    ROLLBACK WORK.
    MESSAGE S016 DISPLAY LIKE 'E'.
  ENDIF.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form EDIT_MODE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM EDIT_MODE . "조회, 수정 토글버튼

  CLEAR GS_DISPLAY.
  ZEA_MMT010-AENAM = SY-UNAME.
  ZEA_MMT010-AEZET = SY-UZEIT.
  ZEA_MMT010-AEDAT = SY-DATUM.



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
FORM HANDLER_TOOLBAR
  USING PO_OBJECT TYPE REF TO CL_ALV_EVENT_TOOLBAR_SET
        PO_SENDER TYPE REF TO CL_GUI_ALV_GRID.

  DATA LS_TOOLBAR LIKE LINE OF PO_OBJECT->MT_TOOLBAR.

  DATA : LV_FIN_ALL  TYPE I,
         LV_FIN_SEMI TYPE I,
         LV_FIN      TYPE I,
         LV_SEMI     TYPE I,
         LV_RAW      TYPE I.

  CASE PO_SENDER.
    WHEN GO_ALV_GRID.
* 구분자 =>> |
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 3. " 구분자
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.


* 버튼 추가 =>> 변경
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 0. " 버튼
      LS_TOOLBAR-FUNCTION = GC_CHANGE.
      LS_TOOLBAR-TEXT = TEXT-L04. " 변경
      LS_TOOLBAR-ICON = ICON_CHANGE.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 삭제
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 0. " 버튼
      LS_TOOLBAR-FUNCTION = GC_DELETE.
      LS_TOOLBAR-TEXT = TEXT-L05. " 삭제
      LS_TOOLBAR-ICON = ICON_DELETE.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

      LOOP AT  GT_DISPLAY INTO GS_DISPLAY.

        CASE GS_DISPLAY-MATTYPE.
          WHEN '완제품'.
            ADD 1 TO LV_FIN_ALL.
            ADD 1 TO LV_FIN.
          WHEN '반제품'.
            ADD 1 TO LV_FIN_ALL.
            ADD 1 TO LV_SEMI.
          WHEN '원자재'.
            ADD 1 TO LV_FIN_ALL.
            ADD 1 TO LV_RAW.
        ENDCASE.
      ENDLOOP.

* 구분자 =>> |
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 3. " 구분자
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 0.
      LS_TOOLBAR-FUNCTION = GC_FIN_ALL_MATERIALS.
      LS_TOOLBAR-TEXT = TEXT-L06 && ':' && LV_FIN_ALL.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 완제품
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 0. " 완제품
      LS_TOOLBAR-FUNCTION = GC_FINISHED_MATERIALS.
      LS_TOOLBAR-ICON = ICON_BUSINAV_PROC_EXIST.
      LS_TOOLBAR-TEXT = TEXT-L10 && ':' && LV_FIN.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 반제품
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 0. " 반제품
      LS_TOOLBAR-FUNCTION = GC_SEMI_MATERIALS.
      LS_TOOLBAR-ICON = ICON_LED_GREEN.
      LS_TOOLBAR-TEXT = TEXT-L07 && ':' && LV_SEMI.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 0. " 원자재
      LS_TOOLBAR-FUNCTION = GC_RAW_MATERIALS.
      LS_TOOLBAR-ICON = ICON_LED_YELLOW.
      LS_TOOLBAR-TEXT = TEXT-L08 && ':' && LV_RAW.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.



  ENDCASE.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form DATA_DELETE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DATA_DELETE .

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
        DELETE FROM ZEA_MMT010 WHERE MATNR = GS_DISPLAY-MATNR.
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
*& Module STATUS_0110 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE STATUS_0110 OUTPUT.
  SET PF-STATUS 'S0110'.
  SET TITLEBAR  'T0110'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Form HANDLE_DATA_CHANGED
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
*& Form SEARCH_MT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SEARCH_MT .


  RANGES R_STATUS FOR GS_DISPLAY-MATTYPE.
  RANGES R_MATNR FOR ZEA_MMT010-MATNR.
  RANGES R_MATTYPE FOR ZEA_MMT010-MATTYPE.
  RANGES R_MATGRP FOR ZEA_MMT010-MATGRP.
  RANGES R_BSTME FOR ZEA_MMT010-BSTME.
  RANGES R_MEINS2 FOR ZEA_MMT010-MEINS2.



  PERFORM MAKE_DISPLAY_DATA.



  REFRESH R_MATNR[].
  CLEAR R_MATNR.
  REFRESH R_MATTYPE[].
  CLEAR R_MATTYPE.
  REFRESH R_MATGRP[].
  CLEAR R_MATGRP.
  REFRESH R_BSTME[].
  CLEAR R_BSTME.
  REFRESH R_MEINS2[].
  CLEAR R_MEINS2.


*PERFORM MAKE_DISPLAY_DATA.

*  IF GS_DISPLAY-STATUS IS NOT INITIAL.
*    R_STATUS-SIGN = 'I'.
*    R_STATUS-OPTION  = 'EQ'.
*    R_STATUS-LOW     = GS_DISPLAY-STATUS.
*    APPEND R_STATUS.
*    ENDIF.

  IF ZEA_MMT010-MATNR IS NOT INITIAL.
    R_MATNR-SIGN = 'I'.
    R_MATNR-OPTION  = 'EQ'.
    R_MATNR-LOW     = ZEA_MMT010-MATNR.
    APPEND R_MATNR.
  ENDIF.

  IF  ZEA_MMT010-MATTYPE IS NOT INITIAL.
    R_MATTYPE-SIGN    = 'I'.
    R_MATTYPE-OPTION  = 'EQ'.
    R_MATTYPE-LOW     =  ZEA_MMT010-MATTYPE.




    APPEND R_MATTYPE.
  ENDIF.

  IF  ZEA_MMT010-MATGRP IS NOT INITIAL.
    R_MATGRP-SIGN    = 'I'.
    R_MATGRP-OPTION  = 'EQ'.
    R_MATGRP-LOW     =  ZEA_MMT010-MATGRP.
    APPEND R_MATGRP.
  ENDIF.

  IF  ZEA_MMT010-BSTME IS NOT INITIAL.
    R_BSTME-SIGN    = 'I'.
    R_BSTME-OPTION  = 'EQ'.
    R_BSTME-LOW     =  ZEA_MMT010-BSTME.
    APPEND R_BSTME.
  ENDIF.

  IF  ZEA_MMT010-MEINS2 IS NOT INITIAL.
    R_MEINS2-SIGN    = 'I'.
    R_MEINS2-OPTION  = 'EQ'.
    R_MEINS2-LOW     =  ZEA_MMT010-MEINS2.
    APPEND R_MEINS2.
  ENDIF.

  SELECT *
    FROM ZEA_MMT010 AS A JOIN ZEA_MMT020 AS B
    ON A~MATNR EQ B~MATNR
    INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY
      WHERE A~MATNR IN R_MATNR
        AND SPRAS EQ SY-LANGU
        AND A~MATTYPE IN R_MATTYPE
        AND A~MATGRP IN R_MATGRP
        AND A~BSTME IN R_BSTME
        AND A~MEINS2 IN R_MEINS2.

  DATA LS_STYLE TYPE LVC_S_STYL.



  LOOP AT GT_DISPLAY INTO DATA(GS_DISPLAY).
    " 조건에 따라 STATUS 설정

    CASE GS_DISPLAY-MATTYPE.
      WHEN '원자재'.
        GS_DISPLAY-STATUS = ICON_LED_YELLOW.
      WHEN '반제품'.
        GS_DISPLAY-STATUS = ICON_LED_GREEN.
      WHEN '완제품'.
        GS_DISPLAY-STATUS = ICON_BUSINAV_PROC_EXIST.
    ENDCASE.

    " 내부 테이블 업데이트
    MODIFY GT_DISPLAY FROM GS_DISPLAY.
  ENDLOOP.





*SELECT *
*  FROM ZEA_MMT010
*  INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY
*      WHERE MATNR IN R_MATNR
*        AND MATTYPE IN R_MATTYPE
*        AND MATGRP IN R_MATGRP
*        AND BSTME IN R_BSTME
*        AND MEINS2 IN R_MEINS2.







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
        WHEN GC_CHANGE.
          PERFORM EDIT_MODE2 USING PO_SENDER.

        WHEN GC_DELETE.
          PERFORM DATA_DELETE2 USING PO_SENDER.

        WHEN GC_FIN_ALL_MATERIALS.
          PERFORM ALL_FILTER.
          PERFORM SET_ALV_FILTER.

        WHEN GC_FINISHED_MATERIALS.
          PERFORM FIN_FILTER.
          PERFORM SET_ALV_FILTER.

        WHEN GC_SEMI_MATERIALS.
          PERFORM SEMI_FILTER.
          PERFORM SET_ALV_FILTER.

        WHEN GC_RAW_MATERIALS.
          PERFORM RAW_FILTER.
          PERFORM SET_ALV_FILTER.

      ENDCASE.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form EDIT_MODE2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PO_SENDER
*&---------------------------------------------------------------------*
FORM EDIT_MODE2 USING PO_SENDER TYPE REF TO CL_GUI_ALV_GRID.

  DATA LV_CHECK TYPE I.

  LV_CHECK = PO_SENDER->IS_READY_FOR_INPUT( ).

  IF LV_CHECK EQ 0.
    LV_CHECK = 1.
  ELSE.
    LV_CHECK = 0.
  ENDIF.

  CALL METHOD PO_SENDER->SET_READY_FOR_INPUT
    EXPORTING
      I_READY_FOR_INPUT = LV_CHECK.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DATA_DELETE2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PO_SENDER
*&---------------------------------------------------------------------*
FORM DATA_DELETE2 USING PO_SENDER TYPE REF TO CL_GUI_ALV_GRID.

  _MC_POPUP_CONFIRM 'DELETE' '정말 삭제하시겠습니까?' GV_ANSWER.
  CHECK GV_ANSWER = '1'.

  DATA LT_INDEX_ROWS TYPE LVC_T_ROW.
  DATA LS_INDEX_ROW LIKE LINE OF LT_INDEX_ROWS.

  CALL METHOD PO_SENDER->GET_SELECTED_ROWS
    IMPORTING
      ET_INDEX_ROWS = LT_INDEX_ROWS     " Indexes of Selected Rows
*     ET_ROW_NO     =                  " Numeric IDs of Selected Rows
    .

  DATA LV_SUBRC TYPE I.
  DATA LV_COUNT TYPE I.

  CASE PO_SENDER.
    WHEN GO_ALV_GRID.
      IF LT_INDEX_ROWS[] IS INITIAL.
        " TEXT-M01: 라인을 선택하세요.
        MESSAGE S000 DISPLAY LIKE 'W' WITH '최소 한 행이상 선택하세요'.

      ELSE.

        LOOP AT LT_INDEX_ROWS INTO LS_INDEX_ROW WHERE ROWTYPE IS INITIAL.

          READ TABLE GT_DISPLAY INTO GS_DISPLAY INDEX LS_INDEX_ROW-INDEX.

          IF SY-SUBRC EQ 0.

            UPDATE ZEA_MMT010
               SET LOEKZ = ABAP_ON
             WHERE MATNR    EQ GS_DISPLAY-MATNR.

            "실행된 결과를 LV_SUBRC에 누적합산
            ADD SY-SUBRC TO LV_SUBRC.

            IF SY-SUBRC EQ 0.
              LV_COUNT += 1.
            ENDIF.

            " ITAB 변경로직
            GS_DISPLAY-MARK = ABAP_ON.
            MODIFY GT_DISPLAY FROM GS_DISPLAY INDEX LS_INDEX_ROW-INDEX
            TRANSPORTING MARK.

          ENDIF.

        ENDLOOP.

        IF LV_SUBRC EQ 0.
          DELETE GT_DISPLAY
           WHERE MARK EQ ABAP_ON.
          "변경사항에 대한 확정처리
          COMMIT WORK AND WAIT.
          MESSAGE S000 WITH LV_COUNT '건의 데이터가 삭제되었습니다.'.

          PERFORM REFRESH_ALV_0100.
        ELSE.
          " 변경사항에 대한 원복처리
          ROLLBACK WORK.
          MESSAGE S000 DISPLAY LIKE 'W' WITH '데이터 삭제를 실패하였습니다.'.
        ENDIF.

      ENDIF.

    WHEN GO_ALV_GRID.
      IF LT_INDEX_ROWS[] IS INITIAL.
        " TEXT-M01: 라인을 선택하세요.
        MESSAGE S000 DISPLAY LIKE 'W' WITH '최소 한 행이상 선택하세요'.

      ELSE.

        LOOP AT LT_INDEX_ROWS INTO LS_INDEX_ROW WHERE ROWTYPE IS INITIAL.

          READ TABLE GT_DISPLAY INTO GS_DISPLAY INDEX LS_INDEX_ROW-INDEX.

          IF SY-SUBRC EQ 0.

            UPDATE ZEA_MMT010
               SET LOEKZ = ABAP_ON
             WHERE MATNR    EQ GS_DISPLAY-MATNR.

            "실행된 결과를 LV_SUBRC에 누적합산
            ADD SY-SUBRC TO LV_SUBRC.

            IF SY-SUBRC EQ 0.
              LV_COUNT += 1.
            ENDIF.

            " ITAB 변경로직
            GS_DISPLAY-MARK = ABAP_ON.
            MODIFY GT_DISPLAY FROM GS_DISPLAY INDEX LS_INDEX_ROW-INDEX
            TRANSPORTING MARK.

          ENDIF.

        ENDLOOP.

        IF LV_SUBRC EQ 0.
          DELETE GT_DISPLAY
           WHERE MARK EQ ABAP_ON.
          "변경사항에 대한 확정처리
          COMMIT WORK AND WAIT.
          MESSAGE S000 WITH LV_COUNT '건의 데이터가 삭제되었습니다.'.

          PERFORM REFRESH_ALV_0100.
        ELSE.
          " 변경사항에 대한 원복처리
          ROLLBACK WORK.
          MESSAGE S000 DISPLAY LIKE 'W' WITH '데이터 삭제를 실패하였습니다.'.
        ENDIF.

      ENDIF.


  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FIN_FILTER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FIN_FILTER .

  REFRESH GT_FILTER.

  CLEAR GS_FILTER.
  GS_FILTER-FIELDNAME = 'MATTYPE'.
  GS_FILTER-SIGN      = 'I'.
  GS_FILTER-OPTION    = 'EQ'.
  GS_FILTER-LOW       = '완제품'.
  APPEND GS_FILTER TO GT_FILTER.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SEMI_FILTER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SEMI_FILTER .

  REFRESH GT_FILTER.

  CLEAR GS_FILTER.
  GS_FILTER-FIELDNAME = 'MATTYPE'.
  GS_FILTER-SIGN      = 'I'.
  GS_FILTER-OPTION    = 'EQ'.
  GS_FILTER-LOW       = '반제품'.
  APPEND GS_FILTER TO GT_FILTER.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form RAW_FILTER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM RAW_FILTER .

  REFRESH GT_FILTER.

  CLEAR GS_FILTER.
  GS_FILTER-FIELDNAME = 'MATTYPE'.
  GS_FILTER-SIGN      = 'I'.
  GS_FILTER-OPTION    = 'EQ'.
  GS_FILTER-LOW       = '원자재'.
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
*& Form DELETE_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_SENDER
*&---------------------------------------------------------------------*
FORM DELETE_DATA.
  DATA LT_INDEX_ROWS TYPE LVC_T_ROW.
  DATA LS_INDEX_ROW LIKE LINE OF LT_INDEX_ROWS.


  CALL METHOD GO_ALV_GRID->GET_SELECTED_ROWS
    IMPORTING
      ET_INDEX_ROWS = LT_INDEX_ROWS     " Indexes of Selected Rows
*     ET_ROW_NO     =                  " Numeric IDs of Selected Rows
    .

  DATA LV_SUBRC TYPE I.
  DATA LV_COUNT TYPE I.


  IF LT_INDEX_ROWS[] IS INITIAL.
    " TEXT-M01: 라인을 선택하세요.
    MESSAGE S000 DISPLAY LIKE 'W' WITH '최소 한 행이상 선택하세요'.

  ELSE.
    LOOP AT GT_DISPLAY INTO GS_DISPLAY WHERE MARK EQ 'X'.
      GS_DISPLAY-MARK = SPACE.
      MODIFY GT_DISPLAY FROM GS_DISPLAY TRANSPORTING MARK.
    ENDLOOP.

    LOOP AT LT_INDEX_ROWS INTO LS_INDEX_ROW WHERE ROWTYPE IS INITIAL.

      READ TABLE GT_DISPLAY INTO GS_DISPLAY INDEX LS_INDEX_ROW-INDEX.

      IF SY-SUBRC EQ 0.

        UPDATE ZEA_MMT010
           SET LOEKZ = ABAP_ON
         WHERE MATNR    EQ GS_DISPLAY-MATNR.

        "실행된 결과를 LV_SUBRC에 누적합산
        ADD SY-SUBRC TO LV_SUBRC.

        IF SY-SUBRC EQ 0.
          LV_COUNT += 1.

          " 삭제 트랜잭션을 커밋
          IF SY-SUBRC = 0.
            COMMIT WORK.
            WRITE: / '모든 삭제 플래그가 설정된 항목이 삭제되었습니다.'.
          ENDIF.
        ENDIF.

        " ITAB 변경로직
        GS_DISPLAY-MARK = ABAP_ON.
        MODIFY GT_DISPLAY FROM GS_DISPLAY INDEX LS_INDEX_ROW-INDEX
        TRANSPORTING MARK.

      ENDIF.

    ENDLOOP.
*          DELETE GT_DISPLAY .
*           WHERE MARK EQ ABAP_ON.
    IF LV_SUBRC EQ 0.
      GS_DISPLAY-LOEKZ = 'X'.
      MODIFY GT_DISPLAY FROM GS_DISPLAY TRANSPORTING LOEKZ
      WHERE MARK EQ 'X'.

      "변경사항에 대한 확정처리
      COMMIT WORK AND WAIT.
      MESSAGE S000 WITH LV_COUNT '건의 데이터가 삭제되었습니다.'.

*      SELECT *
*        FROM ZEA_MMT010 AS A
*        JOIN ZEA_MMT020 AS B
*          ON B~MATNR EQ A~MATNR
*         AND SPRAS EQ SY-LANGU
*        INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY.
*
*      LOOP AT GT_DISPLAY INTO GS_DISPLAY.
*
*        MODIFY  GT_DISPLAY FROM GS_DISPLAY.
*      ENDLOOP.
*
*      SORT GT_DISPLAY BY MATNR.
      PERFORM REFRESH_ALV_0100.
    ELSE.
      " 변경사항에 대한 원복처리
      ROLLBACK WORK.
      MESSAGE S000 DISPLAY LIKE 'W' WITH '데이터 삭제를 실패하였습니다.'.
    ENDIF.

  ENDIF.

*  DATA: LT_INDEX_ROWS   TYPE LVC_T_ROW,
*        LS_INDEX_ROW    LIKE LINE OF LT_INDEX_ROWS,
*        LV_SUBRC        TYPE I,
*        LV_COUNT        TYPE I,
*        LT_DELETE_INDEX TYPE TABLE OF SY-TABIX,
*        LV_INDEX        TYPE SY-TABIX.
*
*  CALL METHOD GO_ALV_GRID->GET_SELECTED_ROWS
*    IMPORTING
*      ET_INDEX_ROWS = LT_INDEX_ROWS.
*
*  IF LT_INDEX_ROWS[] IS INITIAL.
*    MESSAGE '최소 한 행 이상 선택하세요' TYPE 'W'.
*  ELSE.
*    " 선택된 행의 인덱스 수집
*    LOOP AT LT_INDEX_ROWS INTO LS_INDEX_ROW.
*      UPDATE ZEA_MMT010
*      SET LOEKZ = ABAP_ON
*    WHERE MATNR    EQ GS_DISPLAY-MATNR.
*      APPEND LS_INDEX_ROW-INDEX TO LT_DELETE_INDEX.
*    ENDLOOP.
*
*    " 인덱스를 역순으로 정렬
*    SORT LT_DELETE_INDEX DESCENDING.
*
*    " 역순으로 삭제 진행
*    LOOP AT LT_DELETE_INDEX INTO LV_INDEX.
*      READ TABLE GT_DISPLAY INTO GS_DISPLAY INDEX LV_INDEX.
*      IF SY-SUBRC = 0.
*        DELETE FROM ZEA_MMT010 WHERE MATNR = GS_DISPLAY-MATNR.
*        IF SY-SUBRC = 0.
*          LV_COUNT += 1.
*        ENDIF.
*        DELETE GT_DISPLAY INDEX LV_INDEX.
*      ENDIF.
*    ENDLOOP.
*
*    " 결과 처리
*    IF LV_COUNT > 0.
*      COMMIT WORK AND WAIT.
*      MESSAGE S000 WITH LV_COUNT '건의 데이터가 삭제되었습니다.'.
*      PERFORM REFRESH_ALV_0100.
*    ELSE.
*      ROLLBACK WORK.
*      MESSAGE '데이터 삭제를 실패하였습니다' TYPE 'E'.
*    ENDIF.
*  ENDIF.




ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_INFO_NUMBERRANGE
*&---------------------------------------------------------------------*
FORM GET_INFO_NUMBERRANGE .
  DATA : NR_RANGE_NR  LIKE  INRI-NRRANGENR.
  DATA : OBJECT       LIKE  INRI-OBJECT.
  DATA : QUANTITY     LIKE  INRI-QUANTITY.
  DATA : GV_NUM       TYPE  I.

  CLEAR: NR_RANGE_NR, OBJECT, QUANTITY.
  NR_RANGE_NR = '01'.
  OBJECT      = 'ZEA_MMNR'.
  QUANTITY    = 1.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      NR_RANGE_NR             = NR_RANGE_NR
      OBJECT                  = OBJECT
      QUANTITY                = QUANTITY
    IMPORTING
      NUMBER                  = ZEA_MMT010-MATNR
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
  ZEA_MMT010-MATNR = |{ ZEA_MMT010-MATNR ALPHA = OUT  }|.

*둘중 편한걸로

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_INFO_NUMBERRANGE2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM GET_INFO_NUMBERRANGE2 .
  DATA : NR_RANGE_NR  LIKE  INRI-NRRANGENR.
  DATA : OBJECT       LIKE  INRI-OBJECT.
  DATA : QUANTITY     LIKE  INRI-QUANTITY.
  DATA : GV_NUM       TYPE  I.

  CLEAR: NR_RANGE_NR, OBJECT, QUANTITY.
  NR_RANGE_NR = '02'.
  OBJECT      = 'ZEA_MMNR'.
  QUANTITY    = 1.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      NR_RANGE_NR             = NR_RANGE_NR
      OBJECT                  = OBJECT
      QUANTITY                = QUANTITY
    IMPORTING
      NUMBER                  = ZEA_MMT010-MATNR
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
  ZEA_MMT010-MATNR = |{ ZEA_MMT010-MATNR ALPHA = OUT  }|.

*둘중 편한걸로
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
  DATA : GV_NUM       TYPE  I.

  CLEAR: NR_RANGE_NR, OBJECT, QUANTITY.
  NR_RANGE_NR = '03'.
  OBJECT      = 'ZEA_MMNR'.
  QUANTITY    = 1.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      NR_RANGE_NR             = NR_RANGE_NR
      OBJECT                  = OBJECT
      QUANTITY                = QUANTITY
    IMPORTING
      NUMBER                  = ZEA_MMT010-MATNR
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
  ZEA_MMT010-MATNR = |{ ZEA_MMT010-MATNR ALPHA = OUT  }|.

*둘중 편한걸로
ENDFORM.
