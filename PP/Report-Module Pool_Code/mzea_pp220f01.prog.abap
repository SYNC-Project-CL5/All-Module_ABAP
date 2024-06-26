*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form SELECT_DATA
*&---------------------------------------------------------------------*
FORM SELECT_DATA_PPT020.

  REFRESH GT_DATA2.

  SELECT *
    FROM ZEA_PPT020 AS A
    JOIN ZEA_T001W AS B
      ON B~WERKS EQ A~WERKS
    JOIN ZEA_MMT020 AS C
      ON C~MATNR EQ A~MATNR
    INTO CORRESPONDING FIELDS OF TABLE GT_DATA2
   WHERE SPRAS EQ SY-LANGU.

  SORT GT_DATA2 BY ORDIDX.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_DATA_AUFK
*&---------------------------------------------------------------------*
FORM SELECT_DATA_AUFK .

  REFRESH GT_DATA.

  SELECT A~AUFNR, A~PLANID, B~PNAME1, B~WERKS, A~MATNR, C~MAKTX,
         A~TOT_QTY, A~MEINS, A~APPROVAL, A~APPROVER, D~SDATE, D~EDATE,
         D~ISPDATE, D~REPQTY, D~RQTY, D~UNIT, D~LOEKZ
    FROM ZEA_AUFK AS A
    JOIN ZEA_PPT020 AS D
      ON D~AUFNR EQ A~AUFNR
    JOIN ZEA_T001W AS B
      ON B~WERKS EQ A~WERKS
    LEFT JOIN ZEA_MMT020 AS C
      ON C~MATNR EQ A~MATNR
     AND C~SPRAS EQ @SY-LANGU
    INTO CORRESPONDING FIELDS OF TABLE @GT_DATA
   WHERE A~APPROVAL EQ 'A'
     AND D~EDATE NE 0
     AND D~SDATE NE 0
     AND D~LOEKZ NE 'O'.


  SORT GT_DATA BY AUFNR.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM MAKE_DISPLAY_DATA .

*-- DISPLAY 구성 : 헤더 테이블
  REFRESH GT_DISPLAY.

  LOOP AT GT_DATA INTO GS_DATA.

    CLEAR GS_DISPLAY.

    MOVE-CORRESPONDING GS_DATA TO GS_DISPLAY.

*신규 필드------------------------------------------------------------*

    IF GS_DISPLAY-APPROVAL = 'A'.
      GS_DISPLAY-STATUS = ICON_LED_GREEN.
    ENDIF.
    IF GS_DISPLAY-LOEKZ = 'I'.
      GS_DISPLAY-STATUS2 = ICON_TRANSPORT.
      GS_DISPLAY-LIGHT = 1.
    ENDIF.
*--------------------------------------------------------------------*
    APPEND GS_DISPLAY TO GT_DISPLAY.

  ENDLOOP.

  DESCRIBE TABLE GT_DISPLAY LINES GV_LINES.

  IF GT_DISPLAY IS INITIAL.
*    MESSAGE S013 DISPLAY LIKE 'W'.
  ELSE.
*    MESSAGE S006 WITH GV_LINES.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_DISPLAY_DATA2
*&---------------------------------------------------------------------*
FORM MAKE_DISPLAY_DATA2 .

*-- DISPLAY2 구성 : 아이템 테이블
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
*    MESSAGE S013 DISPLAY LIKE 'W'.
  ELSE.
    MESSAGE S006 WITH GV_LINES.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_0100
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT_0100 .

  " 화면 전체를 차지하는 커스텀 컨트롤과 연결되는 커스텀 컨테이너
  CREATE OBJECT GO_CONTAINER
    EXPORTING
      CONTAINER_NAME = 'CCON' " Name of the Screen CustCtrl Name to Link Container To
    EXCEPTIONS
      OTHERS         = 1.

  IF SY-SUBRC NE 0.
    MESSAGE '컨테이너 생성에 실패했습니다.' TYPE 'E'.
  ENDIF.

  CREATE OBJECT GO_SPLIT
    EXPORTING
      PARENT  = GO_CONTAINER       " Parent Container
      ROWS    = 2                  " Number of Rows to be displayed
      COLUMNS = 1                  " Number of Columns to be Displayed
    EXCEPTIONS
      OTHERS  = 1.

  IF SY-SUBRC <> 0.
    MESSAGE '분리 컨테이너 생성에 실패했습니다.' TYPE 'E'.
  ENDIF.

  " CLASSIC 한 메소드 호출 방법
  CALL METHOD GO_SPLIT->GET_CONTAINER
    EXPORTING
      ROW       = 1 " Row
      COLUMN    = 1 " Column
    RECEIVING
      CONTAINER = GO_CON_TOP. " Container

  CALL METHOD GO_SPLIT->GET_CONTAINER
    EXPORTING
      ROW       = 2 " Row
      COLUMN    = 1 " Column
    RECEIVING
      CONTAINER = GO_CON_BOT. " Container

  " 신문법 중 하나
  GO_CON_TOP = GO_SPLIT->GET_CONTAINER( ROW = 1 COLUMN = 1 ).
  GO_CON_BOT = GO_SPLIT->GET_CONTAINER( ROW = 2 COLUMN = 1 ).


  " TOP 컨테이너에 ALV를 생성
  CREATE OBJECT GO_ALV_GRID_TOP
    EXPORTING
      I_PARENT = GO_CON_TOP " Parent Container
    EXCEPTIONS
      OTHERS   = 1.

  IF SY-SUBRC NE 0.
    MESSAGE 'TOP ALV 생성에 실패했습니다.' TYPE 'E'.
  ENDIF.

  " BOT 컨테이너에 ALV를 생성
  CREATE OBJECT GO_ALV_GRID_BOT
    EXPORTING
      I_PARENT = GO_CON_BOT
    EXCEPTIONS
      OTHERS   = 1.
  IF SY-SUBRC NE 0.
    MESSAGE 'BOT ALV 생성에 실패했습니다.' TYPE 'E'.
  ENDIF.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_FIELDCAT_0100 .

  PERFORM GET_FIELDCAT    USING    GT_DISPLAY
                          CHANGING GT_FIELDCAT.

  PERFORM MAKE_FIELDCAT_0100.

  PERFORM GET_FIELDCAT    USING    GT_DISPLAY2
                          CHANGING GT_FIELDCAT2.

  PERFORM MAKE_FIELDCAT2_0100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_FIELDCAT2
*&---------------------------------------------------------------------*
FORM GET_FIELDCAT  USING PT_TAB TYPE STANDARD TABLE
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
*& Form MAKE_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM MAKE_FIELDCAT_0100 .

  LOOP AT GT_FIELDCAT INTO GS_FIELDCAT.

    CASE GS_FIELDCAT-FIELDNAME.

      WHEN 'AUFNR'.
        GS_FIELDCAT-HOTSPOT = ABAP_ON.
        GS_FIELDCAT-KEY = ABAP_ON.
      WHEN 'PLANID'.
        GS_FIELDCAT-COL_POS = 1.
        GS_FIELDCAT-JUST = 'C'.
      WHEN 'WERKS'.
        GS_FIELDCAT-COL_POS = 2.
        GS_FIELDCAT-JUST = 'C'.
        GS_FIELDCAT-EMPHASIZE = 'C500'.
      WHEN 'PNAME1'.
        GS_FIELDCAT-COL_POS = 3.
        GS_FIELDCAT-JUST = 'C'.
        GS_FIELDCAT-EMPHASIZE = 'C500'.
      WHEN 'MATNR'.
        GS_FIELDCAT-NO_OUT = ABAP_ON.
        GS_FIELDCAT-EMPHASIZE = 'C500'.
      WHEN 'MAKTX'.
        GS_FIELDCAT-COL_POS = 4.
        GS_FIELDCAT-EMPHASIZE = 'C500'.
      WHEN 'TOT_QTY'.
        GS_FIELDCAT-EMPHASIZE = 'C300'.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
      WHEN 'APPROVER'.
        GS_FIELDCAT-COL_POS = 8.
        GS_FIELDCAT-JUST = 'C'.
        GS_FIELDCAT-COLTEXT = '생산오더 결재자'.
      WHEN 'APPROVAL'.
        GS_FIELDCAT-JUST = 'C'.
        GS_FIELDCAT-COL_POS = 0.
        GS_FIELDCAT-NO_OUT = ABAP_ON.
      WHEN 'STATUS'.
        GS_FIELDCAT-COL_POS = 0.
        GS_FIELDCAT-JUST = 'C'.
        GS_FIELDCAT-COLTEXT = '승인상태'.
      WHEN 'REPQTY' OR 'RQTY'.
        GS_FIELDCAT-EMPHASIZE = 'C300'.
        GS_FIELDCAT-QFIELDNAME = 'UNIT'.
      WHEN 'LOEKZ'.
        GS_FIELDCAT-JUST = 'C'.
        GS_FIELDCAT-COLTEXT = '입고여부'.
      WHEN 'STATUS2'.
        GS_FIELDCAT-JUST = 'C'.
        GS_FIELDCAT-COLTEXT = '입고여부'.

    ENDCASE.

    MODIFY GT_FIELDCAT FROM GS_FIELDCAT.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_FIELDCAT2_0100
*&---------------------------------------------------------------------*
FORM MAKE_FIELDCAT2_0100 .

  LOOP AT GT_FIELDCAT2 INTO GS_FIELDCAT2.

    CASE GS_FIELDCAT2-FIELDNAME.

      WHEN 'AUFNR' OR 'ORDIDX'.
        GS_FIELDCAT2-KEY = ABAP_ON.
        GS_FIELDCAT2-JUST = 'C'.

      WHEN 'MATNR' OR 'BOMID' OR 'WERKS'
        " OR 'EXPQTY' OR 'SDATE' OR 'EDATE'
        OR 'ISPDATE' OR 'REPQTY'
        OR 'RQTY'    OR 'LOEKZ'.
        GS_FIELDCAT2-NO_OUT = ABAP_ON.

      WHEN 'MAKTX' OR 'PNAME1'.
        GS_FIELDCAT2-EMPHASIZE = 'C500'.
        GS_FIELDCAT2-JUST      = 'C'.

      WHEN 'SDATE' OR 'EDATE'.
        GS_FIELDCAT2-JUST      = 'C'.

      WHEN 'EXPQTY' OR 'REPQTY' OR 'RQTY'.
        GS_FIELDCAT2-QFIELDNAME = 'UNIT'.

      WHEN 'UNIT'.
        GS_FIELDCAT2-COL_POS    = 8.

      WHEN 'STATUS'.
        GS_FIELDCAT2-COLTEXT = 'Status'.
        GS_FIELDCAT2-ICON    = ABAP_ON.
        GS_FIELDCAT2-KEY     = ABAP_OFF.
        GS_FIELDCAT2-NO_OUT  = ABAP_ON.
      WHEN 'COLOR'.
        GS_FIELDCAT2-NO_OUT  = ABAP_ON.
      WHEN 'LIGHT'.
        GS_FIELDCAT2-NO_OUT  = ABAP_ON.
      WHEN 'MARK'.
        GS_FIELDCAT2-NO_OUT  = ABAP_ON.
    ENDCASE.

    MODIFY GT_FIELDCAT2 FROM GS_FIELDCAT2.

  ENDLOOP.

*    CLEAR GS_FIELDCAT.
*    GS_FIELDCAT-FIELDNAME = 'CARRID'.        " 필드 이름
*    GS_FIELDCAT-COLTEXT   = TEXT-F01.        " 출력 되는 컬럼명
*    GS_FIELDCAT-HOTSPOT   = ABAP_ON.         " HOTSPOT 설정
*    GS_FIELDCAT-ICON      = ABAP_ON. " 'X'   " 아이콘 필드
  " 컬럼을 합산처리하도록 옵션을 켬
*    GS_FIELDCAT-DO_SUM    = ABAP_ON. " 'X'.
*    GS_FIELDCAT-NO_OUT    = ABAP_ON. "'X'.   " 컬럼을 숨김 처리
*    GS_FIELDCAT-TECH      = ABAP_ON. "'X'.   " 컬럼을 삭제 처리
  " 컬럼명 위에 마우스를 올렸을 때 텍스트
*    GS_FIELDCAT-TOOLTIP   = TEXT-F03.
  " 가운데 정렬, 'L': 왼쪽 정렬, 'R': 오른쪽 정렬
*    GS_FIELDCAT-JUST      = 'C'
*    GS_FIELDCAT-CFIELDNAME    = CURRENCY         " 통화 단위 참조
*    GS_FIELDCAT-CHECKBOX  = ABAP_ON          " 체크박스
*    GS_FIELDCAT-INTTYPE   = I.               " 내부 타입
*    GS_FIELDCAT-INTLEN    = 20.              " 내부 길이
*    GS_FIELDCAT-EMPHASIZE = 'C500'.          " 열 색상
*    APPEND GS_FIELDCAT TO GT_FIELDCAT.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_LAYOUT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_LAYOUT_0100 .

  CLEAR GS_LAYOUT.

  GS_LAYOUT-ZEBRA = ABAP_ON.
  GS_LAYOUT-CWIDTH_OPT = 'A'.
  GS_LAYOUT-SEL_MODE = 'B'.

  GS_LAYOUT-NO_ROWINS = ABAP_ON.
  GS_LAYOUT-NO_ROWMOVE = ABAP_ON.

  GS_LAYOUT-CTAB_FNAME = 'CELL_COLOR'.
  GS_LAYOUT-INFO_FNAME = 'ROWCOLOR'.
  GS_LAYOUT-STYLEFNAME = 'STYLE'.

  GS_LAYOUT-GRID_TITLE = TEXT-L01. " Search Result
*  GS_LAYOUT-SMALLTITLE = ABAP_ON.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_EVENT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_EVENT_0100 .

* Static Method는 Class 에 존재하므로 Class=>StaticMethod 접근가능
* Instance Method면 Intance ( 객체 )에 존재하므로 Object->InstanceMethod 접근해야 함
  SET HANDLER:
    LCL_EVENT_HANDLER=>ON_DOUBLE_CLICK FOR GO_ALV_GRID_TOP, " TOP ALV에게만 반응
    LCL_EVENT_HANDLER=>ON_HOTSPOT_CLICK FOR GO_ALV_GRID_TOP. " TOP ALV에게만 반응
***    LCL_EVENT_HANDLER=>ON_DOUBLE_CLICK FOR ALL INSTANCES. " 프로그램의 모든 객체에게 반응
  SET HANDLER LCL_EVENT_HANDLER=>ON_TOOLBAR FOR GO_ALV_GRID_TOP.
  SET HANDLER LCL_EVENT_HANDLER=>ON_USER_COMMAND FOR GO_ALV_GRID_TOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_0100
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV_0100 .

  CLEAR GS_VARIANT.
  GS_VARIANT-REPORT = SY-REPID.
  GS_VARIANT-HANDLE = '0001'. " 프로그램 내 ALV 구별자

  GV_SAVE = 'A'. " 개인용/공용 모두 생성 가능하도록 설정

  CALL METHOD GO_ALV_GRID_TOP->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
*     I_STRUCTURE_NAME = 'ZEA_AUFK'     " Internal Output Table Structure Name
      IS_VARIANT      = GS_VARIANT  " Layout
      I_SAVE          = GV_SAVE     " Save Layout
      IS_LAYOUT       = GS_LAYOUT   " Layout
    CHANGING
      IT_OUTTAB       = GT_DISPLAY    " Output Table
      IT_FIELDCATALOG = GT_FIELDCAT " Field Catalog
    EXCEPTIONS
      OTHERS          = 1.

  IF SY-SUBRC <> 0.
    MESSAGE 'ALV에 데이터를 설정하는 과정 중 오류가 발생했습니다.' TYPE 'E'.
  ENDIF.

  CLEAR GS_VARIANT.
  GS_VARIANT-REPORT = SY-REPID.
  GS_VARIANT-HANDLE = '0005'. " 프로그램 내 ALV 구별자

  GV_SAVE = 'A'. " 개인용/공용 모두 생성 가능하도록 설정

  CALL METHOD GO_ALV_GRID_BOT->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
*     I_STRUCTURE_NAME = 'ZEA_PPT020'     " Internal Output Table Structure Name
      IS_VARIANT      = GS_VARIANT  " Layout
      I_SAVE          = GV_SAVE     " Save Layout
      IS_LAYOUT       = GS_LAYOUT   " Layout
    CHANGING
      IT_OUTTAB       = GT_DISPLAY2    " Output Table
      IT_FIELDCATALOG = GT_FIELDCAT2   " Field Catalog
    EXCEPTIONS
      OTHERS          = 1.


  IF SY-SUBRC <> 0.
    MESSAGE 'ALV에 데이터를 설정하는 과정 중 오류가 발생했습니다.' TYPE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH_ALV_0100
*&---------------------------------------------------------------------*
FORM REFRESH_ALV_0100 USING PO_ALV_GRID TYPE REF TO CL_GUI_ALV_GRID.


  CHECK PO_ALV_GRID IS BOUND.

  DATA LS_STABLE TYPE LVC_S_STBL.

  LS_STABLE-ROW = ABAP_ON.
  LS_STABLE-COL = ABAP_ON.

  CALL METHOD GO_ALV_GRID_TOP->REFRESH_TABLE_DISPLAY
    EXPORTING
      IS_STABLE = LS_STABLE  " With Stable Rows/Columns
*     I_SOFT_REFRESH =           " Without Sort, Filter, etc.
    EXCEPTIONS
      FINISHED  = 1                " Display was Ended (by Export)
      OTHERS    = 2.

  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
      WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  CALL METHOD GO_ALV_GRID_BOT->REFRESH_TABLE_DISPLAY
    EXPORTING
      IS_STABLE = LS_STABLE  " With Stable Rows/Columns
*     I_SOFT_REFRESH =           " Without Sort, Filter, etc.
    EXCEPTIONS
      FINISHED  = 1                " Display was Ended (by Export)
      OTHERS    = 2.

  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
      WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.




ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_DATA_LISTBOX
*&---------------------------------------------------------------------*
FORM SELECT_DATA_LISTBOX .

  SELECT MATNR MAKTX
    FROM ZEA_MMT020
    INTO CORRESPONDING FIELDS OF TABLE GT_LIST
    WHERE MATNR GE '300000'
      AND SPRAS EQ SY-LANGU.

ENDFORM.
*&---------------------------------------------------------------------*
*& Module CREATE_ALV_CONTROL OUTPUT
*&---------------------------------------------------------------------*
MODULE CREATE_ALV_CONTROL OUTPUT.

  CHECK GO_EDITOR IS INITIAL.
  GV_REPID = SY-REPID.
  GV_DYNNR = SY-DYNNR.


*  CREATE OBJECT GO_CONTAINER
*    EXPORTING
*      REPID     = GV_REPID
*      DYNNR     = GV_DYNNR
*      SIDE      = GO_CONTAINER->DOCK_AT_BOTTOM
*      EXTENSION = 300.

  CREATE OBJECT GO_CONTAINER3
    EXPORTING
      CONTAINER_NAME = 'CC_900'
    EXCEPTIONS
      OTHERS         = 1.

  CREATE OBJECT GO_EDITOR
    EXPORTING
      PARENT            = GO_CONTAINER3
      WORDWRAP_MODE     = CL_GUI_TEXTEDIT=>WORDWRAP_AT_FIXED_POSITION
      WORDWRAP_POSITION = 95.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Form save_data
*&---------------------------------------------------------------------*
FORM SAVE_DATA .

  CALL METHOD GO_EDITOR->GET_TEXT_AS_R3TABLE
    IMPORTING
      TABLE  = GT_LINES
    EXCEPTIONS
      OTHERS = 1.

  CALL METHOD CL_GUI_CFW=>FLUSH
    EXCEPTIONS
      OTHERS = 1.

  READ TABLE GT_LINES INTO GV_COMMENT INDEX 1.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form load_data
*&---------------------------------------------------------------------*
FORM LOAD_DATA .

* CALL FUNCTION 'GUI_UPLOAD'
*   EXPORTING
*     filename                      = p_file
*     FILETYPE                      = 'DAT'
*   tables
*     data_tab                      = gt_lines.
*
*  CALL METHOD go_editor->set_text_as_r3table
*    EXPORTING
*      table  = gt_lines
*    EXCEPTIONS
*      OTHERS = 1.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form enable_data
*&---------------------------------------------------------------------*
FORM ENABLE_DATA .

  IF READ_MODE = 0.
    READ_MODE = 1.
  ELSE.
    READ_MODE = 0.
  ENDIF.

  CALL METHOD GO_EDITOR->SET_READONLY_MODE
    EXPORTING
      READONLY_MODE = READ_MODE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form protect_line
*&---------------------------------------------------------------------*
FORM PROTECT_LINE .

  DATA : N TYPE I.

  CALL METHOD GO_EDITOR->GET_SELECTED_TEXT_AS_R3TABLE
    IMPORTING
      TABLE = GT_LINES.

  DESCRIBE TABLE GT_LINES LINES N.

  CALL METHOD GO_EDITOR->PROTECT_LINES
    EXPORTING
      FROM_LINE                     = 0
      TO_LINE                       = N
      PROTECT_MODE                  = 1
      ENABLE_EDITING_PROTECTED_TEXT = 1.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_DOUBLE_CLICK
*&---------------------------------------------------------------------*
FORM HANDLE_HOTSPOT_CLICK  USING PS_ROW    TYPE LVC_S_ROW
                                PS_COLUMN TYPE LVC_S_COL
                                PO_SENDER TYPE REF TO CL_GUI_ALV_GRID.

  " TOP의 데이터 중 더블 클릭한 데이터를 GS_SCARR 에 전달한다.
  READ TABLE GT_DISPLAY INTO GS_DISPLAY INDEX PS_ROW-INDEX.

  " 더블클릭한 TOP 의 항공사코드와 관련있는 항공편 정보만 취급하기 위해
  " 기존에 갖고 있던 데이터를 전부 지우고, 새롭게 데이터를 조회한다.
  REFRESH GT_DISPLAY2.

*  SELECT *
*    FROM ZEA_PPT020 AS A
*    JOIN ZEA_T001W AS B
*      ON B~WERKS EQ A~WERKS
*    JOIN ZEA_MMT020 AS C
*      ON C~MATNR EQ A~MATNR
*    WHERE AUFNR EQ @GS_DISPLAY-AUFNR
*    INTO CORRESPONDING FIELDS OF TABLE @GT_DATA2.

  SELECT *
    FROM ZEA_PPT020 AS A
    JOIN ZEA_T001W AS B
      ON B~WERKS EQ A~WERKS
    JOIN ZEA_MMT020 AS C
      ON C~MATNR EQ A~MATNR
    INTO CORRESPONDING FIELDS OF TABLE GT_DATA2
   WHERE AUFNR EQ GS_DISPLAY-AUFNR
     AND SPRAS EQ SY-LANGU.

  SORT GT_DATA2 BY ORDIDX.

  PERFORM MAKE_DISPLAY_DATA2.


  " GT_SPFLI 의 데이터가 변경되었으므로,
  " 변경된 데이터를 ALV에 출력하기 위해 ALV를 새로고침 한다.
  CALL METHOD GO_ALV_GRID_BOT->REFRESH_TABLE_DISPLAY
*    EXPORTING
*      IS_STABLE      =                  " With Stable Rows/Columns
*      I_SOFT_REFRESH =                  " Without Sort, Filter, etc.
    EXCEPTIONS
      FINISHED = 1                " Display was Ended (by Export)
      OTHERS   = 2.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_DATA_CONDITION
*&---------------------------------------------------------------------*
FORM SELECT_DATA_CONDITION .

  RANGES R_AUFNR FOR ZEA_AUFK-AUFNR.
  RANGES R_PNAME1 FOR ZEA_T001W-PNAME1.
  RANGES R_MATNR FOR ZEA_MMT010-MATNR.

  REFRESH R_AUFNR[].
  CLEAR R_AUFNR.
  REFRESH R_PNAME1[].
  CLEAR R_PNAME1.
  REFRESH R_MATNR[].
  CLEAR R_MATNR.

  IF ZEA_AUFK-AUFNR IS NOT INITIAL.
    R_AUFNR-SIGN    = 'I'.
    R_AUFNR-OPTION  = 'EQ'.
    R_AUFNR-LOW     = ZEA_AUFK-AUFNR.
    APPEND R_AUFNR.
  ENDIF.
  IF ZEA_T001W-PNAME1 IS NOT INITIAL.
    R_PNAME1-SIGN    = 'I'.
    R_PNAME1-OPTION  = 'EQ'.
    R_PNAME1-LOW     = ZEA_T001W-PNAME1.
    APPEND R_PNAME1.
  ENDIF.
  IF ZEA_MMT010-MATNR IS NOT INITIAL.
    R_MATNR-SIGN    = 'I'.
    R_MATNR-OPTION  = 'EQ'.
    R_MATNR-LOW     = ZEA_MMT010-MATNR.
    APPEND R_MATNR.
  ENDIF.

  REFRESH GT_DATA.

  SELECT A~AUFNR A~PLANID B~PNAME1 B~WERKS
         A~MATNR C~MAKTX A~TOT_QTY A~MEINS A~APPROVAL A~APPROVER
    FROM ZEA_AUFK AS A
    JOIN ZEA_T001W AS B
      ON B~WERKS EQ A~WERKS
    JOIN ZEA_MMT020 AS C
      ON C~MATNR EQ A~MATNR
    INTO CORRESPONDING FIELDS OF TABLE GT_DATA
   WHERE A~APPROVAL EQ 'A'
     AND SPRAS EQ SY-LANGU
     AND A~AUFNR IN R_AUFNR
     AND B~PNAME1 IN R_PNAME1
     AND C~MATNR IN R_MATNR.


*  SELECT A~AUFNR, A~PLANID, B~PNAME1, B~WERKS, A~MATNR, C~MAKTX,
*     A~TOT_QTY, A~MEINS, A~APPROVAL, A~APPROVER, D~SDATE, D~EDATE,
*     D~ISPDATE, D~REPQTY, D~RQTY, D~UNIT, D~LOEKZ
*FROM ZEA_AUFK AS A
*JOIN ZEA_PPT020 AS D
*  ON D~AUFNR EQ A~AUFNR
*JOIN ZEA_T001W AS B
*  ON B~WERKS EQ A~WERKS
*LEFT JOIN ZEA_MMT020 AS C
*  ON C~MATNR EQ A~MATNR
* AND C~SPRAS EQ @SY-LANGU
*INTO CORRESPONDING FIELDS OF TABLE @GT_DATA
*WHERE A~APPROVAL EQ 'A'
*         AND SPRAS EQ @SY-LANGU
* AND A~AUFNR IN @R_AUFNR
* AND B~PNAME1 IN @R_PNAME1
* AND C~MAKTX IN @R_MAKTX
*  AND D~EDATE NE 0
*  AND D~SDATE NE 0
*  AND D~LOEKZ NE 'O'.

  SORT GT_DATA BY AUFNR.

  PERFORM MAKE_DISPLAY_DATA.


  " 변경된 데이터를 ALV에 출력하기 위해 ALV를 새로고침 한다.
  CALL METHOD GO_ALV_GRID_TOP->REFRESH_TABLE_DISPLAY
*    EXPORTING
*      IS_STABLE      =                  " With Stable Rows/Columns
*      I_SOFT_REFRESH =                  " Without Sort, Filter, etc.
    EXCEPTIONS
      FINISHED = 1                " Display was Ended (by Export)
      OTHERS   = 2.

  " 변경된 데이터를 ALV에 출력하기 위해 ALV를 새로고침 한다.
  CALL METHOD GO_ALV_GRID_BOT->REFRESH_TABLE_DISPLAY
*    EXPORTING
*      IS_STABLE      =                  " With Stable Rows/Columns
*      I_SOFT_REFRESH =                  " Without Sort, Filter, etc.
    EXCEPTIONS
      FINISHED = 1                " Display was Ended (by Export)
      OTHERS   = 2.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_DOUBLE_CLICK
*&---------------------------------------------------------------------*
FORM HANDLE_DOUBLE_CLICK   USING PS_ROW    TYPE LVC_S_ROW
                                PS_COLUMN TYPE LVC_S_COL
                                PO_SENDER TYPE REF TO CL_GUI_ALV_GRID.


  CLEAR: GV_LIST, GS_LIST.
  REFRESH: GT_LIST, GT_DISPLAY3.


  DATA: GT_AFRU TYPE TABLE OF ZEA_AFRU,
        GS_AFRU TYPE ZEA_AFRU.


  DATA LT_INDEX_ROWS TYPE LVC_T_ROW.
  DATA LS_INDEX_ROW LIKE LINE OF LT_INDEX_ROWS.

  CALL METHOD GO_ALV_GRID_TOP->GET_SELECTED_ROWS
    IMPORTING
      ET_INDEX_ROWS = LT_INDEX_ROWS     " Indexes of Selected Rows
*     ET_ROW_NO     =                  " Numeric IDs of Selected Rows
    .





  IF LT_INDEX_ROWS[] IS INITIAL.
    " TEXT-M01: 라인을 선택하세요.
    MESSAGE S000 DISPLAY LIKE 'W' WITH '라인을 선택하세요'.

  ELSE.

    " 더블 클릭할때마다 생산 검수 디스플레이를 리프레시
    REFRESH GT_DISPLAY3.
*      CLEAR GS_DISPLAY.

    " 생산오더 헤더 테이블의 값을 화면 변수에 넣음
    LOOP AT LT_INDEX_ROWS INTO LS_INDEX_ROW WHERE ROWTYPE IS INITIAL.
      READ TABLE GT_DISPLAY INTO GS_DISPLAY INDEX LS_INDEX_ROW-INDEX.

      ZEA_PPT020-AUFNR = GS_DISPLAY-AUFNR.
      ZEA_PPT020-WERKS = GS_DISPLAY-WERKS.
      ZEA_AUFK-PLANID  = GS_DISPLAY-PLANID.
      GV_LIST          = GS_DISPLAY-MATNR.

    ENDLOOP.
*    ENDIF.
  ENDIF.


  IF GS_DISPLAY-LOEKZ EQ 'I'.

    REFRESH GT_DISPLAY3.

    SELECT
      FROM ZEA_AFRU AS A
      LEFT JOIN ZEA_MMT020 AS B
        ON B~MATNR EQ A~MATNR
       AND B~SPRAS EQ @SY-LANGU
      FIELDS *
      WHERE AUFNR EQ @GS_DISPLAY-AUFNR
      INTO CORRESPONDING FIELDS OF TABLE @GT_DISPLAY3.

    PERFORM MAKE_PERCENT.

    TABSTRIP-ACTIVETAB = 'TAB1'.

    " 강제 PBO 돌게하는 함수
    CALL FUNCTION 'SAPGUI_SET_FUNCTIONCODE'
      EXPORTING
        FUNCTIONCODE           = 'ENTE'
      EXCEPTIONS
        FUNCTION_NOT_SUPPORTED = 1
        OTHERS                 = 2.

    EXIT.

  ELSE.

    " GT_DISPLAY2에 출력되는 ALV 값을 SELECT 하기 위해
    SELECT A~AUFNR A~SDATE A~EDATE A~BOMID
     FROM ZEA_PPT020 AS A
     JOIN ZEA_T001W AS B
       ON B~WERKS EQ A~WERKS
     JOIN ZEA_MMT020 AS C
       ON C~MATNR EQ A~MATNR
     JOIN ZEA_AUFK AS D
       ON D~AUFNR EQ A~AUFNR
     INTO CORRESPONDING FIELDS OF TABLE GT_DATA2
     WHERE A~AUFNR EQ GS_DISPLAY-AUFNR
      AND B~WERKS EQ GS_DISPLAY-WERKS
      AND D~PLANID EQ GS_DISPLAY-PLANID
      AND SPRAS EQ SY-LANGU.

    SORT GT_DATA2 BY ORDIDX.

*    LOOP AT LT_INDEX_ROWS INTO LS_INDEX_ROW WHERE ROWTYPE IS INITIAL.
    READ TABLE GT_DATA2 INTO GS_DATA2 WITH KEY AUFNR = ZEA_PPT020-AUFNR
                                               MATNR = ZEA_PPT020-MATNR.
    READ TABLE GT_DISPLAY INTO GS_DISPLAY WITH KEY AUFNR = ZEA_AUFK-AUFNR
                                               MATNR = ZEA_AUFK-MATNR.
    ZEA_PPT020-SDATE = GS_DATA2-SDATE.
    ZEA_PPT020-EDATE = GS_DATA2-EDATE.
*    ENDLOOP.

    REFRESH GT_DATA3.
    CLEAR S0100.

    " 총 생산량 화면의 값을 각 각의 Tabstrip 으로 이동함
    PERFORM MOVE_DATA_TO_DATA3.
    " 더블 클릭한 자재의 코드에 따라서 맞는 TAB으로 이동함
    PERFORM CHANGE_TAB .

    CLEAR GS_DISPLAY3.
    GS_DISPLAY3-AUFNR = GS_DISPLAY-AUFNR.     " 생산오더 ID
    GS_DISPLAY3-MATNR = GS_DISPLAY-MATNR.     " 자재코드
    GS_DISPLAY3-PDQUAN = GS_DISPLAY-TOT_QTY.  " 생산량
    GS_DISPLAY3-MEINS = GS_DISPLAY-MEINS.     " 단위
    GS_DISPLAY3-MAKTX = GS_DISPLAY-MAKTX.     " 자재명
    GS_DISPLAY3-BOMID = GS_DATA2-BOMID.
    APPEND GS_DISPLAY3 TO GT_DISPLAY3.


*    " 강제 PBO 돌게하는 함수
*    CALL FUNCTION 'SAPGUI_SET_FUNCTIONCODE'
*      EXPORTING
*        FUNCTIONCODE           = 'ENTE'
*      EXCEPTIONS
*        FUNCTION_NOT_SUPPORTED = 1
*        OTHERS                 = 2.

    LEAVE SCREEN.
  ENDIF.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_0110
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT_0110 .

  CREATE OBJECT GO_CONTAINER2
    EXPORTING
      CONTAINER_NAME = 'CCON2'
    EXCEPTIONS
      OTHERS         = 1.

  IF SY-SUBRC <> 0.
    MESSAGE E020.
  ENDIF.

  CREATE OBJECT GO_ALV_GRID_2
    EXPORTING
      I_PARENT = GO_CONTAINER2
    EXCEPTIONS
      OTHERS   = 1.

  IF SY-SUBRC NE 0.
    MESSAGE E021.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_0110
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV_0110 .

  CLEAR GS_VARIANT.
  GS_VARIANT-REPORT = SY-REPID.
  GS_VARIANT-HANDLE = '0002'. " 프로그램 내 ALV 구별자

  GV_SAVE = 'A'. " 개인용/공용 모두 생성 가능하도록 설정

  CALL METHOD GO_ALV_GRID_2->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
*     I_STRUCTURE_NAME              = 'ZEA_SDT050'                 " Internal Output Table Structure Name
      IS_VARIANT                    = GS_VARIANT                 " Layout
      I_SAVE                        = GV_SAVE               " Save Layout
      IS_LAYOUT                     = GS_LAYOUT                " Layout
    CHANGING
      IT_OUTTAB                     = GT_DISPLAY3                 " Output Table
      IT_FIELDCATALOG               = GT_FIELDCAT3                 " Field Catalog
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
*& Form SET_ALV_FIELDCAT_0110
*&---------------------------------------------------------------------*
FORM SET_ALV_FIELDCAT_0110 .

  PERFORM GET_FIELDCAT    USING    GT_DISPLAY3
                          CHANGING GT_FIELDCAT3.

  PERFORM MAKE_FIELDCAT_0110.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH_ALV_0110
*&---------------------------------------------------------------------*
FORM REFRESH_ALV_0110  USING PO_ALV_GRID_2 TYPE REF TO CL_GUI_ALV_GRID.


  CHECK PO_ALV_GRID_2 IS BOUND.

  DATA LS_STABLE TYPE LVC_S_STBL.

  LS_STABLE-ROW = ABAP_ON.
  LS_STABLE-COL = ABAP_ON.

  PO_ALV_GRID_2->REFRESH_TABLE_DISPLAY(
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
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_FIELDCAT_0110
*&---------------------------------------------------------------------*
FORM MAKE_FIELDCAT_0110 .

  LOOP AT GT_FIELDCAT3 INTO GS_FIELDCAT3.

    CASE GS_FIELDCAT3-FIELDNAME.

      WHEN 'AUFNR'.
        GS_FIELDCAT3-JUST    = 'C'.
        GS_FIELDCAT3-KEY     = ABAP_ON.

      WHEN 'STATUS'.
        GS_FIELDCAT3-COL_POS = 0.
        GS_FIELDCAT3-COLTEXT = '공정불량율'.
        GS_FIELDCAT3-JUST    = 'C'.

      WHEN 'BOMID'.
        GS_FIELDCAT3-NO_OUT  = ABAP_ON.

      WHEN 'PDQUAN' OR 'PDBAN' OR 'FNPD'.
        GS_FIELDCAT-EMPHASIZE = 'C300'.
        GS_FIELDCAT3-QFIELDNAME = 'MEINS'.

      WHEN 'MEINS'.
        GS_FIELDCAT3-COLTEXT = '단위'.

      WHEN 'CHARG' OR 'MAKTX' OR 'MATNR'.
        GS_FIELDCAT3-JUST    = 'C'.
        GS_FIELDCAT3-EMPHASIZE = 'C500'.

    ENDCASE.

    MODIFY GT_FIELDCAT3 FROM GS_FIELDCAT3.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_DATA_AFRU
*&---------------------------------------------------------------------*
FORM SELECT_DATA_AFRU .

  REFRESH GT_DATA3.

  SELECT *
    FROM ZEA_AFRU
    INTO CORRESPONDING FIELDS OF TABLE GT_DATA3.

*  SORT GT_DATA BY AUFNR.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_DISPLAY_DATA3
*&---------------------------------------------------------------------*
FORM MAKE_DISPLAY_DATA3 .


*-- DISPLAY2 구성 : 아이템 테이블
  REFRESH GT_DISPLAY3.

  LOOP AT GT_DATA3 INTO GS_DATA3.

    CLEAR GS_DISPLAY3.

    MOVE-CORRESPONDING GS_DATA3 TO GS_DISPLAY3.

*신규 필드------------------------------------------------------------*


*--------------------------------------------------------------------*
    APPEND GS_DISPLAY3 TO GT_DISPLAY3.

  ENDLOOP.

  DESCRIBE TABLE GT_DISPLAY3 LINES GV_LINES.

  IF GT_DISPLAY3 IS INITIAL.
*    MESSAGE S013 DISPLAY LIKE 'W'.
  ELSE.
    MESSAGE S006 WITH GV_LINES.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form INIT_LISTBOX
*&---------------------------------------------------------------------*
FORM INIT_LISTBOX .

  TYPE-POOLS VRM.

  CLEAR: LIST.


  PERFORM SELECT_DATA_LISTBOX.

  LOOP AT GT_LIST INTO GS_LIST.
    VALUE-KEY = GS_LIST-MATNR.
    VALUE-TEXT = GS_LIST-MAKTX.
    APPEND VALUE TO LIST.
    CLEAR: GS_LIST, VALUE.
  ENDLOOP.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      ID     = 'GV_LIST'
      VALUES = LIST
*   EXCEPTIONS
*     ID_ILLEGAL_NAME       = 1
*     OTHERS = 2
    .
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_DISPLAY_DATA_3  " 불량률 아이콘
*&---------------------------------------------------------------------*
FORM MAKE_DISPLAY_DATA_3 .

  DATA LV_PERCENTAGE TYPE I.
  DATA LV_PDBAN TYPE ZEA_AFRU-PDBAN.

  CLEAR GS_DISPLAY3.

  READ TABLE GT_DISPLAY3 INTO GS_DISPLAY3 INDEX 1. " WITH KEY AUFNR = GS_DISPLAY3-AUFNR
  " MATNR = GS_DISPLAY3-MATNR
  " INTO GS_DISPLAY3.

  CASE TABSTRIP-ACTIVETAB.
    WHEN 'TAB2'.
      GS_DISPLAY3-FNPD = GV_FNPD1.
      LV_PDBAN = S0100-PDBAN1 + S0100-PDBAN2 + S0100-PDBAN3 +
                 S0100-PDBAN4 + S0100-PDBAN5 + S0100-PDBAN6.
      GS_DISPLAY3-PDBAN = LV_PDBAN.
    WHEN 'TAB3'.
      GS_DISPLAY3-FNPD = GV_FNPD2.
      LV_PDBAN = S0100-PDBAN7 + S0100-PDBAN8 + S0100-PDBAN9 +
                 S0100-PDBAN10 + S0100-PDBAN11 + S0100-PDBAN12.
      GS_DISPLAY3-PDBAN = LV_PDBAN.
    WHEN 'TAB4'.
      GS_DISPLAY3-FNPD = GV_FNPD3.
      LV_PDBAN = S0100-PDBAN13 + S0100-PDBAN14 + S0100-PDBAN15 +
                 S0100-PDBAN16 + S0100-PDBAN17 + S0100-PDBAN18.
      GS_DISPLAY3-PDBAN = LV_PDBAN.
    WHEN 'TAB5'.
      GS_DISPLAY3-FNPD = GV_FNPD4.
      LV_PDBAN = S0100-PDBAN19 + S0100-PDBAN20 + S0100-PDBAN21 +
                 S0100-PDBAN22 + S0100-PDBAN23 + S0100-PDBAN24.
      GS_DISPLAY3-PDBAN = LV_PDBAN.
  ENDCASE.

  LV_PERCENTAGE = ( GS_DISPLAY3-PDQUAN - GS_DISPLAY3-PDBAN ) / GS_DISPLAY3-PDQUAN * 100.


***-- DISPLAY2 구성 : 아이템 테이블
**  REFRESH GT_DISPLAY3.
**
**  LOOP AT GT_DATA3 INTO GS_DATA3.
**
**    CLEAR GS_DISPLAY3.
**
**    GS_DATA3-PDQUAN = GS_DATA-TOT_QTY.
**
**
**    MOVE-CORRESPONDING GS_DATA3 TO GS_DISPLAY3.

*신규 필드------------------------------------------------------------*

  IF LV_PERCENTAGE EQ 0.
    GS_DISPLAY3-STATUS = ICON_SPACE.
  ELSEIF LV_PERCENTAGE LE 70.
    GS_DISPLAY3-STATUS = ICON_LED_RED.
  ELSEIF LV_PERCENTAGE LE 95.
    GS_DISPLAY3-STATUS = ICON_LED_YELLOW.
  ELSEIF LV_PERCENTAGE LE 100.
    GS_DISPLAY3-STATUS = ICON_LED_GREEN.
  ENDIF.

  MODIFY GT_DISPLAY3 FROM GS_DISPLAY3 TRANSPORTING STATUS FNPD DEFREASON PDBAN
                                             WHERE AUFNR = GS_DISPLAY3-AUFNR.
*--------------------------------------------------------------------*
*    APPEND GS_DISPLAY3 TO GT_DISPLAY3.

*  ENDLOOP.

  DESCRIBE TABLE GT_DISPLAY3 LINES GV_LINES.

  IF GT_DISPLAY3 IS INITIAL.
*    MESSAGE S013 DISPLAY LIKE 'W'.
  ELSE.
    MESSAGE S006 WITH GV_LINES.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHANGE_TAB
*&---------------------------------------------------------------------*
FORM CHANGE_TAB .

*  RANGES R_LIST1 FOR ZEA_MMT010-MATNR.
*  RANGES R_LIST2 FOR ZEA_MMT010-MATNR.
*  RANGES R_LIST3 FOR ZEA_MMT010-MATNR.
*  RANGES R_LIST4 FOR ZEA_MMT010-MATNR.
*  RANGES R_LIST5 FOR ZEA_MMT010-MATNR.
*  RANGES R_LIST6 FOR ZEA_MMT010-MATNR.
*  RANGES R_LIST7 FOR ZEA_MMT010-MATNR.
*  RANGES R_LIST8 FOR ZEA_MMT010-MATNR.
*
*  REFRESH R_LIST1[].
*  CLEAR R_LIST1.
*  R_LIST1-SIGN    = 'I'.
*  R_LIST1-OPTION  = 'BT'.
*  R_LIST1-LOW     = '30000000'.
*  R_LIST1-HIGH    = '30000002'.
*  APPEND R_LIST1.
*
*  REFRESH R_LIST2[].
*  CLEAR R_LIST2.
*  R_LIST2-SIGN    = 'I'.
*  R_LIST2-OPTION  = 'BT'.
*  R_LIST2-LOW     = '30000003'.
*  R_LIST2-HIGH    = '30000005'.
*  APPEND R_LIST2.
*
*  REFRESH R_LIST3[].
*  CLEAR R_LIST3.
*  R_LIST3-SIGN    = 'I'.
*  R_LIST3-OPTION  = 'BT'.
*  R_LIST3-LOW     = '30000006'.
*  R_LIST3-HIGH    = '30000008'.
*  APPEND R_LIST3.
*
*  REFRESH R_LIST4[].
*  CLEAR R_LIST4.
*  R_LIST4-SIGN    = 'I'.
*  R_LIST4-OPTION  = 'BT'.
*  R_LIST4-LOW     = '30000009'.
*  R_LIST4-HIGH    = '300000011'.
*  APPEND R_LIST4.
*
*  REFRESH R_LIST5[].
*  CLEAR R_LIST5.
*  R_LIST5-SIGN    = 'I'.
*  R_LIST5-OPTION  = 'BT'.
*  R_LIST5-LOW     = '30000012'.
*  R_LIST5-HIGH    = '30000014'.
*  APPEND R_LIST5.
*
*  REFRESH R_LIST6[].
*  CLEAR R_LIST6.
*  R_LIST6-SIGN    = 'I'.
*  R_LIST6-OPTION  = 'BT'.
*  R_LIST6-LOW     = '30000015'.
*  R_LIST6-HIGH    = '30000017'.
*  APPEND R_LIST6.
*
*  REFRESH R_LIST7[].
*  CLEAR R_LIST7.
*  R_LIST7-SIGN    = 'I'.
*  R_LIST7-OPTION  = 'BT'.
*  R_LIST7-LOW     = '30000018'.
*  R_LIST7-HIGH    = '30000020'.
*  APPEND R_LIST7.
*
*  REFRESH R_LIST8[].
*  CLEAR R_LIST8.
*  R_LIST8-SIGN    = 'I'.
*  R_LIST8-OPTION  = 'BT'.
*  R_LIST8-LOW     = '30000021'.
*  R_LIST8-HIGH    = '30000023'.
*  APPEND R_LIST8.

*   IF GV_LIST EQ R_LIST1.
*
*     ELSEIF GV_LIST EQ R_LIST2.
*       MESSAGE I000 WITH ' 로직 여기타고 있음'.
*   ENDIF.

  IF GV_LIST GE '30000021'.
    TABSTRIP-ACTIVETAB = 'TAB5'.

  ELSEIF GV_LIST GE '30000018'.
    TABSTRIP-ACTIVETAB = 'TAB4'.

  ELSEIF GV_LIST GE '30000015'.
    TABSTRIP-ACTIVETAB = 'TAB3'.

  ELSEIF GV_LIST GE '30000012'.
    TABSTRIP-ACTIVETAB = 'TAB2'.

  ELSEIF GV_LIST GE '30000009'.
    TABSTRIP-ACTIVETAB = 'TAB5'.

  ELSEIF GV_LIST GE '30000006'.
    TABSTRIP-ACTIVETAB = 'TAB4'.

  ELSEIF GV_LIST GE '30000003'.
    TABSTRIP-ACTIVETAB = 'TAB3'.

  ELSEIF GV_LIST GE '30000000'.
    TABSTRIP-ACTIVETAB = 'TAB2'.
  ENDIF.




ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLER_TOOLBAR
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_OBJECT
*&      --> SENDER
*&---------------------------------------------------------------------*
FORM HANDLER_TOOLBAR  USING PO_OBJECT TYPE REF TO CL_ALV_EVENT_TOOLBAR_SET
                            PO_SENDER TYPE REF TO CL_GUI_ALV_GRID.

  DATA LS_TOOLBAR LIKE LINE OF PO_OBJECT->MT_TOOLBAR.

  CASE PO_SENDER.

    WHEN GO_ALV_GRID_TOP.

      DATA LV_TOTAL TYPE I.
      DATA LV_GREEN TYPE I.
*      DATA LV_RED TYPE I.

      DESCRIBE TABLE GT_DISPLAY.

      LOOP AT GT_DISPLAY INTO GS_DISPLAY.
        ADD 1 TO LV_TOTAL.

        CASE GS_DISPLAY-LIGHT.
          WHEN '1'.
            ADD 1 TO LV_GREEN.
*          WHEN '2'. ADD 1 TO LV_GREEN.
        ENDCASE.

      ENDLOOP.

* 구분자 =>> |
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 3. " 구분자
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 전체
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-FUNCTION = GC_NO_FILTER.
      LS_TOOLBAR-TEXT = | 전체조회 : { SY-TFILL } |.
      LS_TOOLBAR-ICON = ICON_SEARCH.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 삭제 X
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-FUNCTION = GC_TRANSPORT.
      LS_TOOLBAR-ICON = ICON_TRANSPORT.
      LS_TOOLBAR-TEXT = | 미입고 : { LV_GREEN }  |.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.



  ENDCASE.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_USER_COMMAND
*&---------------------------------------------------------------------*
FORM HANDLE_USER_COMMAND  USING PV_UCOMM TYPE SY-UCOMM
                                PO_SENDER  TYPE REF TO CL_GUI_ALV_GRID.

  CASE PO_SENDER.
    WHEN GO_ALV_GRID_TOP. "PO_SENDER 가 GO_ALV_GRID_TOP 일 때
      CASE PV_UCOMM.  " 선택한 버튼 (PV_UCOMM은 SY-UCOMM 타입)

        WHEN GC_NO_FILTER.
          PERFORM NO_FILTER.

        WHEN GC_TRANSPORT.
          PERFORM CHECK_TRANSPORT_FILTER.
      ENDCASE.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM REFRESH_ALV .

  DATA LS_STABLE TYPE LVC_S_STBL.

  LS_STABLE-ROW = ABAP_ON.
  LS_STABLE-COL = ABAP_ON.

  CALL METHOD GO_ALV_GRID_2->REFRESH_TABLE_DISPLAY
    EXPORTING
      IS_STABLE = LS_STABLE  " With Stable Rows/Columns
*     I_SOFT_REFRESH =           " Without Sort, Filter, etc.
    EXCEPTIONS
      FINISHED  = 1                " Display was Ended (by Export)
      OTHERS    = 2.

  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
      WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

*  CALL METHOD GO_EDITOR->REFRESH_TABLE_DISPLAYGO_EDITOR
*    EXPORTING
*      IS_STABLE = LS_STABLE  " With Stable Rows/Columns
**     I_SOFT_REFRESH =           " Without Sort, Filter, etc.
*    EXCEPTIONS
*      FINISHED  = 1                " Display was Ended (by Export)
*      OTHERS    = 2.
*
*  IF SY-SUBRC <> 0.
*    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*      WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form APPROVE_DATA
*&---------------------------------------------------------------------*
FORM APPROVE_DATA .

*  DATA: BEGIN OF LS_DATA.
*          INCLUDE STRUCTURE S0100.
*  DATA  END OF LS_DATA.
*
*  DATA LV_EMPNAME TYPE ZEA_PA0000-EMPNAME.
*
*  DATA LT_DISPLAY LIKE TABLE OF LS_DATA.

  GS_DATA3-TSDAT = ZEA_AFRU-TSDAT.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form MOVE_DATA_TO_DATA3 " 총 생산량 화면의 값을 각 각의 Tabstrip 으로 이동함
*&---------------------------------------------------------------------*
FORM MOVE_DATA_TO_DATA3 .

  IF GS_DISPLAY-MATNR GE '30000021'.

    IF GS_DISPLAY-MATNR EQ '30000021'.

      S0100-PDQUAN22  = GS_DISPLAY-TOT_QTY.

    ELSEIF GS_DISPLAY-MATNR EQ '30000022'.

      S0100-PDQUAN23  = GS_DISPLAY-TOT_QTY.

    ELSEIF GS_DISPLAY-MATNR EQ '30000023'.

      S0100-PDQUAN24  = GS_DISPLAY-TOT_QTY.

    ENDIF.

  ELSEIF GS_DISPLAY-MATNR GE '30000018'.

    IF GS_DISPLAY-MATNR EQ '30000018'.

      S0100-PDQUAN16  = GS_DISPLAY-TOT_QTY.

    ELSEIF GS_DISPLAY-MATNR EQ '30000019'.

      S0100-PDQUAN17  = GS_DISPLAY-TOT_QTY.

    ELSEIF GS_DISPLAY-MATNR EQ '30000020'.

      S0100-PDQUAN18  = GS_DISPLAY-TOT_QTY.

    ENDIF.

  ELSEIF GS_DISPLAY-MATNR GE '30000015'.

    IF GS_DISPLAY-MATNR EQ '30000015'.

      S0100-PDQUAN10  = GS_DISPLAY-TOT_QTY.

    ELSEIF GS_DISPLAY-MATNR EQ '30000016'.

      S0100-PDQUAN11  = GS_DISPLAY-TOT_QTY.

    ELSEIF GS_DISPLAY-MATNR EQ '30000017'.

      S0100-PDQUAN12  = GS_DISPLAY-TOT_QTY.

    ENDIF.

  ELSEIF GS_DISPLAY-MATNR GE '30000012'.

    IF GS_DISPLAY-MATNR EQ '30000012'.

      S0100-PDQUAN4  = GS_DISPLAY-TOT_QTY.

    ELSEIF GS_DISPLAY-MATNR EQ '30000013'.

      S0100-PDQUAN5  = GS_DISPLAY-TOT_QTY.

    ELSEIF GS_DISPLAY-MATNR EQ '30000014'.

      S0100-PDQUAN6  = GS_DISPLAY-TOT_QTY.

    ENDIF.

  ELSEIF GS_DISPLAY-MATNR GE '30000009'.

    IF GS_DISPLAY-MATNR EQ '30000009'.

      S0100-PDQUAN19  = GS_DISPLAY-TOT_QTY.

    ELSEIF GS_DISPLAY-MATNR EQ '30000010'.

      S0100-PDQUAN20  = GS_DISPLAY-TOT_QTY.

    ELSEIF GS_DISPLAY-MATNR EQ '30000011'.

      S0100-PDQUAN21  = GS_DISPLAY-TOT_QTY.

    ENDIF.

  ELSEIF GS_DISPLAY-MATNR GE '30000006'.

    IF GS_DISPLAY-MATNR EQ '30000006'.

      S0100-PDQUAN13  = GS_DISPLAY-TOT_QTY.

    ELSEIF GS_DISPLAY-MATNR EQ '30000007'.

      S0100-PDQUAN14  = GS_DISPLAY-TOT_QTY.

    ELSEIF GS_DISPLAY-MATNR EQ '30000008'.

      S0100-PDQUAN15  = GS_DISPLAY-TOT_QTY.

    ENDIF.

  ELSEIF GS_DISPLAY-MATNR GE '30000003'.

    IF GS_DISPLAY-MATNR EQ '30000003'.

      S0100-PDQUAN7  = GS_DISPLAY-TOT_QTY.

    ELSEIF GS_DISPLAY-MATNR EQ '30000004'.

      S0100-PDQUAN8  = GS_DISPLAY-TOT_QTY.

    ELSEIF GS_DISPLAY-MATNR EQ '30000005'.

      S0100-PDQUAN9  = GS_DISPLAY-TOT_QTY.

    ENDIF.

  ELSEIF GS_DISPLAY-MATNR GE '30000000'.

    IF GS_DISPLAY-MATNR EQ '30000000'.

      S0100-PDQUAN1  = GS_DISPLAY-TOT_QTY.

    ELSEIF GS_DISPLAY-MATNR EQ '30000001'.

      S0100-PDQUAN2  = GS_DISPLAY-TOT_QTY.

    ELSEIF GS_DISPLAY-MATNR EQ '30000002'.

      S0100-PDQUAN3  = GS_DISPLAY-TOT_QTY.

    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form INIT_VAL
*&---------------------------------------------------------------------*
FORM INIT_VAL .

  S0100-UNIT1   = 'PKG'.  S0100-UNIT2   = 'PKG'.  S0100-UNIT3   = 'PKG'.
  S0100-UNIT4   = 'PKG'.  S0100-UNIT5   = 'PKG'.  S0100-UNIT6   = 'PKG'.
  S0100-UNIT7   = 'PKG'.  S0100-UNIT8   = 'PKG'.  S0100-UNIT9   = 'PKG'.
  S0100-UNIT10  = 'PKG'.  S0100-UNIT11  = 'PKG'.  S0100-UNIT12  = 'PKG'.
  S0100-UNIT13  = 'PKG'.  S0100-UNIT14  = 'PKG'.  S0100-UNIT15  = 'PKG'.
  S0100-UNIT16  = 'PKG'.  S0100-UNIT17  = 'PKG'.  S0100-UNIT18  = 'PKG'.
  S0100-UNIT19  = 'PKG'.  S0100-UNIT20  = 'PKG'.  S0100-UNIT21  = 'PKG'.
  S0100-UNIT22  = 'PKG'.  S0100-UNIT23  = 'PKG'.  S0100-UNIT24  = 'PKG'.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form CAL_FNPD
*&---------------------------------------------------------------------*
FORM CAL_FNPD_1_6 .

  S0100-FNPD1 = S0100-PDQUAN1 - S0100-PDBAN1.
  S0100-FNPD2 = S0100-PDQUAN2 - S0100-PDBAN2.
  S0100-FNPD3 = S0100-PDQUAN3 - S0100-PDBAN3.
  S0100-FNPD4 = S0100-PDQUAN4 - S0100-PDBAN4.
  S0100-FNPD5 = S0100-PDQUAN5 - S0100-PDBAN5.
  S0100-FNPD6 = S0100-PDQUAN6 - S0100-PDBAN6.


  GV_FNPD1 = S0100-FNPD1 + S0100-FNPD2 + S0100-FNPD3 +
             S0100-FNPD4 + S0100-FNPD5 + S0100-FNPD6.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form CAL_FNPD_7_12
*&---------------------------------------------------------------------*
FORM CAL_FNPD_7_12 .

  S0100-FNPD7 = S0100-PDQUAN7 - S0100-PDBAN7.
  S0100-FNPD8 = S0100-PDQUAN8 - S0100-PDBAN8.
  S0100-FNPD9 = S0100-PDQUAN9 - S0100-PDBAN9.
  S0100-FNPD10 = S0100-PDQUAN10 - S0100-PDBAN10.
  S0100-FNPD11 = S0100-PDQUAN11 - S0100-PDBAN11.
  S0100-FNPD12 = S0100-PDQUAN12 - S0100-PDBAN12.


  GV_FNPD2 = S0100-FNPD7 + S0100-FNPD8 + S0100-FNPD9 +
             S0100-FNPD10 + S0100-FNPD11 + S0100-FNPD12.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CAL_FNPD_13_18
*&---------------------------------------------------------------------*
FORM CAL_FNPD_13_18 .

  S0100-FNPD13 = S0100-PDQUAN13 - S0100-PDBAN13.
  S0100-FNPD14 = S0100-PDQUAN14 - S0100-PDBAN14.
  S0100-FNPD15 = S0100-PDQUAN15 - S0100-PDBAN15.
  S0100-FNPD16 = S0100-PDQUAN16 - S0100-PDBAN16.
  S0100-FNPD17 = S0100-PDQUAN17 - S0100-PDBAN17.
  S0100-FNPD18 = S0100-PDQUAN18 - S0100-PDBAN18.


  GV_FNPD3 = S0100-FNPD13 + S0100-FNPD14 + S0100-FNPD15 +
             S0100-FNPD16 + S0100-FNPD17 + S0100-FNPD18.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CAL_FNPD_19_24
*&---------------------------------------------------------------------*
FORM CAL_FNPD_19_24 .

  S0100-FNPD19 = S0100-PDQUAN19 - S0100-PDBAN19.
  S0100-FNPD20 = S0100-PDQUAN20 - S0100-PDBAN20.
  S0100-FNPD21 = S0100-PDQUAN21 - S0100-PDBAN21.
  S0100-FNPD22 = S0100-PDQUAN22 - S0100-PDBAN22.
  S0100-FNPD23 = S0100-PDQUAN23 - S0100-PDBAN23.
  S0100-FNPD24 = S0100-PDQUAN24 - S0100-PDBAN24.


  GV_FNPD4 = S0100-FNPD19 + S0100-FNPD20 + S0100-FNPD21 +
             S0100-FNPD22 + S0100-FNPD23 + S0100-FNPD24.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_DISPLAY_DATA3_BTN
*&---------------------------------------------------------------------*
FORM MAKE_DISPLAY_DATA3_BTN .

*  REFRESH GT_DISPLAY3.

  READ TABLE GT_DISPLAY3 WITH KEY AUFNR = GS_DISPLAY3-AUFNR
                                  MATNR = GS_DISPLAY3-MATNR
                                  INTO GS_DISPLAY3.


  GS_DISPLAY3-EMPCODE = ZEA_PA0000-EMPCODE.
  GS_DISPLAY3-TSDAT   = ZEA_AFRU-TSDAT.

*신규 필드------------------------------------------------------------*

  REFRESH GT_DISPLAY3.
*--------------------------------------------------------------------*
  APPEND GS_DISPLAY3 TO GT_DISPLAY3.

  PERFORM MAKE_DISPLAY_DATA_3 .

  TABSTRIP-ACTIVETAB = 'TAB1'.

  DESCRIBE TABLE GT_DISPLAY3 LINES GV_LINES.

  IF GT_DISPLAY3 IS INITIAL.
*    MESSAGE S013 DISPLAY LIKE 'W'.
  ELSE.
    MESSAGE S006 WITH GV_LINES.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form APPROVE_FINAL
*&---------------------------------------------------------------------*
FORM APPROVE_FINAL .

*  REFRESH GT_LINES.
* 생산실적 테이블에 INSERT 하기 위한 로직
  READ TABLE GT_DISPLAY3 INTO GS_DISPLAY3 INDEX 1.
  READ TABLE GT_LINES INTO GS_DISPLAY3-DEFREASON INDEX 1.

  ZEA_AFRU-AUFNR      = GS_DISPLAY3-AUFNR.   " 생산오더 ID
  ZEA_AFRU-MATNR      = GS_DISPLAY3-MATNR.   " 자재코드
  ZEA_AFRU-BOMID      = GS_DISPLAY3-BOMID.   " BOM ID
  ZEA_AFRU-EMPCODE    = ZEA_PA0000-EMPCODE.  " 사원 코드
  ZEA_AFRU-TSDAT      = ZEA_AFRU-TSDAT.   " 생산 검수일자
  ZEA_AFRU-PDQUAN     = GS_DISPLAY3-PDQUAN.  " 생산량
  ZEA_AFRU-PDBAN      = GS_DISPLAY3-PDBAN.   " 폐기량
  ZEA_AFRU-FNPD       = GS_DISPLAY3-FNPD.    " 최종생산량
  ZEA_AFRU-MEINS      = 'PKG'.                " 단위
  ZEA_AFRU-DEFREASON  = GS_DISPLAY3-DEFREASON. " 불량 사유
  ZEA_AFRU-LOEKZ      = ''.

  ZEA_AFRU-ERDAT = SY-DATUM.
  ZEA_AFRU-ERNAM = SY-UNAME.
  ZEA_AFRU-ERZET = SY-UZEIT.

  INSERT ZEA_AFRU.

*-- 생산오더 아이템 테이블 값주기
*  ZEA_PPT020-ISPDATE   = ZEA_AFRU-TSDAT.        " 검수완료 일자
*  ZEA_PPT020-REPQTY    = GS_DISPLAY3-PDBAN.     " 임시 검수수량 = 검수수량
*  ZEA_PPT020-RQTY     = GS_DISPLAY3-FNPD.      " 생산 완료 수량

  UPDATE ZEA_PPT020 SET ISPDATE = ZEA_AFRU-TSDAT       " 검수완료 일자
                        REPQTY  = GS_DISPLAY3-PDBAN    " 임시 검수수량 = 검수수량
                        RQTY    = GS_DISPLAY3-FNPD     " 생산 완료 수량
                        LOEKZ   = 'I'                  " 검수는 완료되었지만 입고를 하지 않으면 I
                        AENAM   = SY-UNAME
                        AEDAT   = SY-DATUM
                        AEZET   = SY-UZEIT
                  WHERE AUFNR EQ ZEA_AFRU-AUFNR
                    AND MATNR EQ ZEA_AFRU-MATNR.


*  MODIFY GT_DISPLAY3 FROM GS_DISPLAY3 TRANSPORTING TSDAT
*                                             WHERE AUFNR = GS_DISPLAY3-AUFNR.

  " 생성한 배치번호를 생산실적(Display 3) 인터널 테이블에 반영
  READ TABLE GT_DISPLAY INTO GS_DISPLAY WITH KEY AUFNR = GS_DISPLAY3-AUFNR.

  GS_DISPLAY-LOEKZ   = 'I'.
  GS_DISPLAY-STATUS2 = ICON_TRANSPORT.
  GS_DISPLAY-LIGHT   = 1.
  GS_DISPLAY-ISPDATE = ZEA_AFRU-TSDAT.
  GS_DISPLAY-REPQTY  = ZEA_AFRU-PDBAN.
  GS_DISPLAY-RQTY    = GS_DISPLAY3-FNPD.
  MODIFY GT_DISPLAY FROM GS_DISPLAY TRANSPORTING LOEKZ STATUS2 LIGHT ISPDATE REPQTY RQTY
                                           WHERE AUFNR = GS_DISPLAY3-AUFNR.

  GS_DISPLAY2-REPQTY  = ZEA_AFRU-TSDAT.
  GS_DISPLAY2-RQTY    = ZEA_AFRU-PDBAN.
  GS_DISPLAY2-ISPDATE = GS_DISPLAY3-FNPD.

  MODIFY GT_DISPLAY2 FROM GS_DISPLAY2 TRANSPORTING ISPDATE REPQTY RQTY
                                         WHERE AUFNR = GS_DISPLAY3-AUFNR.

  " 변경된 데이터를 ALV에 출력하기 위해 ALV를 새로고침 한다.
  CALL METHOD GO_ALV_GRID_TOP->REFRESH_TABLE_DISPLAY
*    EXPORTING
*      IS_STABLE      =                  " With Stable Rows/Columns
*      I_SOFT_REFRESH =                  " Without Sort, Filter, etc.
    EXCEPTIONS
      FINISHED = 1                " Display was Ended (by Export)
      OTHERS   = 2.

  " 변경된 데이터를 ALV에 출력하기 위해 ALV를 새로고침 한다.
  CALL METHOD GO_ALV_GRID_BOT->REFRESH_TABLE_DISPLAY
*    EXPORTING
*      IS_STABLE      =                  " With Stable Rows/Columns
*      I_SOFT_REFRESH =                  " Without Sort, Filter, etc.
    EXCEPTIONS
      FINISHED = 1                " Display was Ended (by Export)
      OTHERS   = 2.




ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_BATCH_NUMBER : 배치 테이블에 완제품 배치번호 채번 후 등록
*&---------------------------------------------------------------------*
FORM CREATE_BATCH_NUMBER .

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      NR_RANGE_NR             = '01'                 " Number range number
      OBJECT                  = 'ZEA_CHARG'          " Name of number range object
    IMPORTING
      NUMBER                  = ZEA_MMT070-CHARG     " free number
    EXCEPTIONS
      INTERVAL_NOT_FOUND      = 1                " Interval not found
      NUMBER_RANGE_NOT_INTERN = 2                " Number range is not internal
      OBJECT_NOT_FOUND        = 3                " Object not defined in TNRO
      QUANTITY_IS_0           = 4                " Number of numbers requested must be > 0
      QUANTITY_IS_NOT_1       = 5                " Number of numbers requested must be 1
      INTERVAL_OVERFLOW       = 6                " Interval used up. Change not possible.
      BUFFER_OVERFLOW         = 7                " Buffer is full
      OTHERS                  = 8.

  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
      WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  ZEA_MMT070-MATNR = GS_DISPLAY3-MATNR.
  ZEA_MMT070-WERKS = '10000'.
  ZEA_MMT070-SCODE = 'SL01'.
  ZEA_MMT070-CALQTY = GS_DISPLAY3-FNPD.
  ZEA_MMT070-REMQTY = GS_DISPLAY3-FNPD.
  ZEA_MMT070-MEINS = 'PKG'.
  ZEA_MMT070-LVORM = ''.
  ZEA_MMT070-ERNAM = SY-UNAME.
  ZEA_MMT070-ERDAT = SY-DATUM.
  ZEA_MMT070-ERZET = SY-UZEIT.

  INSERT ZEA_MMT070.

  " 생산 실적 테이블에 배치 번호 업데이트
  UPDATE ZEA_AFRU SET CHARG = ZEA_MMT070-CHARG
                WHERE AUFNR EQ GS_DISPLAY3-AUFNR
                  AND MATNR EQ GS_DISPLAY3-MATNR
                  AND TSDAT EQ GS_DISPLAY3-TSDAT.


  " 생성한 배치번호를 생산실적(Display 3) 인터널 테이블에 반영
  READ TABLE GT_DISPLAY3 INTO GS_DISPLAY3 INDEX 1.
*
  GS_DISPLAY3-CHARG = ZEA_MMT070-CHARG.

  MODIFY GT_DISPLAY3 FROM GS_DISPLAY3 TRANSPORTING CHARG
                                           WHERE AUFNR = GS_DISPLAY3-AUFNR.




ENDFORM.
*&---------------------------------------------------------------------*
*& Form UPDATE_STOCK_MMT190
*&---------------------------------------------------------------------*
FORM UPDATE_STOCK_MMT190 .


  " 입고를 진행하니 삭제플래그에 O 라는 값을 줌
  UPDATE ZEA_PPT020 SET LOEKZ   = 'O'                  " 검수는 완료되었지만 입고를 하지 않으면 I
                        AENAM   = SY-UNAME
                        AEDAT   = SY-DATUM
                        AEZET   = SY-UZEIT
                  WHERE AUFNR EQ GS_DISPLAY3-AUFNR
                    AND MATNR EQ GS_DISPLAY3-MATNR.

*    " 생성한 배치번호를 생산실적(Display 3) 인터널 테이블에 반영
*  READ TABLE GT_DISPLAY INTO GS_DISPLAY WITH KEY AUFNR = GS_DISPLAY3-AUFNR.

  DELETE GT_DISPLAY WHERE AUFNR = GS_DISPLAY3-AUFNR.
  DELETE GT_DISPLAY2 WHERE AUFNR = GS_DISPLAY3-AUFNR..


  " 변경된 데이터를 ALV에 출력하기 위해 ALV를 새로고침 한다.
  CALL METHOD GO_ALV_GRID_TOP->REFRESH_TABLE_DISPLAY
*    EXPORTING
*      IS_STABLE      =                  " With Stable Rows/Columns
*      I_SOFT_REFRESH =                  " Without Sort, Filter, etc.
    EXCEPTIONS
      FINISHED = 1                " Display was Ended (by Export)
      OTHERS   = 2.

  " 변경된 데이터를 ALV에 출력하기 위해 ALV를 새로고침 한다.
  CALL METHOD GO_ALV_GRID_BOT->REFRESH_TABLE_DISPLAY
*    EXPORTING
*      IS_STABLE      =                  " With Stable Rows/Columns
*      I_SOFT_REFRESH =                  " Without Sort, Filter, etc.
    EXCEPTIONS
      FINISHED = 1                " Display was Ended (by Export)
      OTHERS   = 2.


  " 기존 수량을 읽어오고, 재고 수량의 총 금액을 계산하기 위해 SELECT 문을 수행
  SELECT FROM ZEA_MMT190
       FIELDS *
        WHERE MATNR EQ @GS_DISPLAY3-MATNR
          AND WERKS EQ '10000'
          AND SCODE EQ 'SL01'
         INTO CORRESPONDING FIELDS OF TABLE @GT_MMT190.

  READ TABLE GT_MMT190 INTO GS_MMT190 WITH KEY MATNR = GS_DISPLAY3-MATNR
                                               WERKS = '10000'
                                               SCODE = 'SL01'.

* 재고 테이블에서 금액 필드 삭제 하여 아래 로직은 주석처리함
***  " 자재 마스터에서 원가 정보를 가져오기 위해 아래의 SELECT 문 수행
***  SELECT FROM ZEA_MMT010
***      FIELDS *
***       WHERE MATNR EQ @ZEA_AFRU-MATNR
***        INTO CORRESPONDING FIELDS OF TABLE @GT_MMT010.
***
***  READ TABLE GT_MMT010 INTO GS_MMT010 WITH KEY MATNR = ZEA_AFRU-MATNR.


  " 재고 수량의 총 금액 = 최종 생산량 * 원가
*  LV_SUM_VALUE = GS_DISPLAY3-FNPD * GS_MMT010-STPRS.

  " 재고 테이블의 재고 수량 총 금액 = 기존 재고 수량의 총 금액 + 추가된 재고수량의 금액
*  GS_MMT190-SUM_VALUE = GS_MMT190-SUM_VALUE + LV_SUM_VALUE.

  " 기존 수량에 추가된 수량을 계산 (PKG 단위)
  GS_MMT190-CALQTY = GS_MMT190-CALQTY + GS_DISPLAY3-FNPD.
  " 기존 수량에 추가된 수량을 계산 (EA 단위)
  GS_MMT190-WEIGHT = GS_MMT190-WEIGHT + ( GS_DISPLAY3-FNPD * 4 ).


  UPDATE ZEA_MMT190 SET CALQTY    = GS_MMT190-CALQTY  " 최종 생산량 (PKG) = 수량 UPDATE
                        WEIGHT    = GS_MMT190-WEIGHT  " 최종 생산량 (EA) = 수량 UPDATE
                        AENAM     = SY-UNAME
                        AEDAT     = SY-DATUM
                        AEZET     = SY-UZEIT
                  WHERE MATNR EQ GS_DISPLAY3-MATNR
                    AND WERKS EQ '10000'
                    AND SCODE EQ 'SL01'.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_MMT090_MMT100
*&---------------------------------------------------------------------*
FORM CREATE_MMT090_MMT100 .

  CALL FUNCTION 'ZEA_MM_PP_OFG'
    EXPORTING
      IV_AUFNR = GS_DISPLAY3-AUFNR.

  CALL FUNCTION 'ZEA_FI_PP'
    EXPORTING
      IV_MATNR = GS_DISPLAY3-MATNR " 최종생산품 (완제품 코드)
      IV_FNPD  = GS_DISPLAY3-FNPD  " 최종생산품 (수량)
      IV_AUFNR = GS_DISPLAY3-AUFNR " 생산오더 ID
      IV_PDBAN = GS_DISPLAY3-PDBAN " 폐기량 (검수불합격 수량)
      IV_TSDAT = GS_DISPLAY3-TSDAT " 생산 검수일자 (증빙일자)
*    IMPORTING
*     EV_BELNR =                  " 전표 번호
    .


ENDFORM.
*&---------------------------------------------------------------------*
*& Form F4HELP
*&---------------------------------------------------------------------*
FORM F4HELP .

  DATA: LT_RETURN_TAB TYPE DDSHRETVAL OCCURS 0,
        LS_RETURN_TAB LIKE LINE OF LT_RETURN_TAB.

  DATA: LT_DSELC TYPE DSELC OCCURS 0,
        LS_DSELC LIKE LINE OF LT_DSELC.

  DATA: LS_VALUE  TYPE SEAHLPRES,
        LT_VALUE  TYPE TABLE OF SEAHLPRES,
        LS_FIELD  TYPE DFIES,
        LT_FIELDS TYPE TABLE OF DFIES.

  DATA: BEGIN OF LT020_MATNR OCCURS 0,
          MATNR TYPE ZEA_MMT010-MATNR,
          MAKTX TYPE ZEA_MMT020-MAKTX,
        END OF LT020_MATNR.

  DATA: LT_MAP TYPE TABLE OF DSELC WITH HEADER LINE.

  CLEAR : LT020_MATNR, LT020_MATNR[],
           LT_VALUE, LT_VALUE[],
           LT_FIELDS, LT_FIELDS[].

  SELECT MATNR MAKTX
    INTO TABLE LT020_MATNR
    FROM ZEA_MMT020 AS A
    WHERE A~MATNR LIKE '30%'
    AND SPRAS EQ SY-LANGU.

  SORT LT020_MATNR BY MATNR.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      RETFIELD        = 'MATNR'           " Name of return field in FIELD_TAB
      DYNPPROG        = SY-REPID          " Current program
      DYNPNR          = SY-DYNNR          " Screen number
*     DYNPROFIELD     = 'ZEA_MMT010-MATNR'
      WINDOW_TITLE    = '자재코드-자재명'        " Title for the hit list
      VALUE_ORG       = 'S'               " Value return: C: cell by cell, S: structured
    TABLES
*     FIELD_TAB       = LT_FIELDS[]
      VALUE_TAB       = LT020_MATNR[]                 " Table of values: entries cell by cell
      RETURN_TAB      = LT_RETURN_TAB[]
*     DYNPFLD_MAPPING = LT_MAP
    EXCEPTIONS
      PARAMETER_ERROR = 1                " Incorrect parameter
      NO_VALUES_FOUND = 2                " No values found
      OTHERS          = 3.

  IF SY-SUBRC EQ 0.
    READ TABLE LT_RETURN_TAB INTO LS_RETURN_TAB INDEX 1.
    IF SY-SUBRC EQ 0.
      ZEA_MMT010-MATNR = LS_RETURN_TAB-FIELDVAL.

      READ TABLE LT020_MATNR WITH KEY MATNR = ZEA_MMT010-MATNR BINARY SEARCH.
      IF SY-SUBRC EQ 0.
        ZEA_MMT010-MATNR        = LT020_MATNR-MATNR.
        ZEA_MMT020-MAKTX        = LT020_MATNR-MAKTX.
*        ZEA_MMT010-STPRS        = LT_MATNR-STPRS.
*        ZEA_SDT090-NETPR        = LT_MATNR-STPRS * 4.
*        ZEA_MMT010-WAERS        = LT_MATNR-WAERS.

        LEAVE SCREEN.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form F4HELP2
*&---------------------------------------------------------------------*
FORM F4HELP2 .

  DATA: LT_RETURN_TAB TYPE DDSHRETVAL OCCURS 0,
        LS_RETURN_TAB LIKE LINE OF LT_RETURN_TAB.

  DATA: LT_DSELC TYPE DSELC OCCURS 0,
        LS_DSELC LIKE LINE OF LT_DSELC.

  DATA: LS_VALUE  TYPE SEAHLPRES,
        LT_VALUE  TYPE TABLE OF SEAHLPRES,
        LS_FIELD  TYPE DFIES,
        LT_FIELDS TYPE TABLE OF DFIES.

  DATA: BEGIN OF LTPA000_EMPCODE OCCURS 0,
          EMPCODE TYPE ZEA_PA0000-EMPCODE,  " 사원코드
          DPTCO   TYPE ZEA_HRT010-DPTCO,     " 부서코드
          DPTNAME TYPE ZEA_HRT010-DPTNAME,   " 부서명
          EMPNAME TYPE ZEA_PA0000-EMPNAME,  " 사원명
          GRADE   TYPE ZEA_PA0000-GRADE,      " 직급
          TELNO   TYPE ZEA_PA0000-TELNO,      " 전화번호
        END OF LTPA000_EMPCODE.

  DATA: LT_MAP TYPE TABLE OF DSELC WITH HEADER LINE.

  CLEAR :  LTPA000_EMPCODE,  LTPA000_EMPCODE[],
           LT_VALUE, LT_VALUE[],
           LT_FIELDS, LT_FIELDS[].

  SELECT A~EMPCODE
         B~DPTCO
         B~DPTNAME
         A~EMPNAME
         A~GRADE
         A~TELNO
    INTO TABLE LTPA000_EMPCODE
    FROM ZEA_PA0000 AS A
    JOIN ZEA_HRT010 AS B
      ON B~BUKRS EQ A~BUKRS
     AND B~DPTCO EQ A~DPTCO
    WHERE A~DPTCO EQ '0500'.

  SORT LTPA000_EMPCODE BY EMPCODE.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      RETFIELD        = 'EMPCODE'           " Name of return field in FIELD_TAB
      DYNPPROG        = SY-REPID          " Current program
      DYNPNR          = SY-DYNNR          " Screen number
*     DYNPROFIELD     = 'ZEA_MMT010-MATNR'
      WINDOW_TITLE    = '사원코드-부서코드-부서명-사원명-직급-전화번호'        " Title for the hit list
      VALUE_ORG       = 'S'               " Value return: C: cell by cell, S: structured
    TABLES
*     FIELD_TAB       = LT_FIELDS[]
      VALUE_TAB       = LTPA000_EMPCODE[]                 " Table of values: entries cell by cell
      RETURN_TAB      = LT_RETURN_TAB[]
*     DYNPFLD_MAPPING = LT_MAP
    EXCEPTIONS
      PARAMETER_ERROR = 1                " Incorrect parameter
      NO_VALUES_FOUND = 2                " No values found
      OTHERS          = 3.

  IF SY-SUBRC EQ 0.
    READ TABLE LT_RETURN_TAB INTO LS_RETURN_TAB INDEX 1.
    IF SY-SUBRC EQ 0.
      ZEA_PA0000-EMPCODE = LS_RETURN_TAB-FIELDVAL.

      READ TABLE LTPA000_EMPCODE WITH KEY EMPCODE = ZEA_PA0000-EMPCODE BINARY SEARCH.
      IF SY-SUBRC EQ 0.
        ZEA_PA0000-EMPCODE = LTPA000_EMPCODE-EMPCODE.
        ZEA_PA0000-EMPNAME = LTPA000_EMPCODE-EMPNAME.
        ZEA_PA0000-DPTCO   = LTPA000_EMPCODE-DPTCO.

        LEAVE SCREEN.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form NO_FILTER
*&---------------------------------------------------------------------*
FORM NO_FILTER .

  REFRESH GT_FILTER.

  PERFORM SET_ALV_FILTER.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FILTER
*&---------------------------------------------------------------------*
FORM SET_ALV_FILTER .

  " ALV에 Filter 정보를 적용하는 과정
  CALL METHOD GO_ALV_GRID_TOP->SET_FILTER_CRITERIA
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
  CALL METHOD GO_ALV_GRID_TOP->REFRESH_TABLE_DISPLAY
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
*& Form CHECK_TRANSPORT_FILTER
*&---------------------------------------------------------------------*
FORM CHECK_TRANSPORT_FILTER .

  REFRESH GT_FILTER.

  CLEAR GS_FILTER.
  GS_FILTER-FIELDNAME = 'LIGHT'.
  GS_FILTER-SIGN      = 'I'.
  GS_FILTER-OPTION    = 'EQ'.
  GS_FILTER-LOW       = '1'.
  APPEND GS_FILTER TO GT_FILTER.

  PERFORM SET_ALV_FILTER.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHECK_TRANSPORT
*&---------------------------------------------------------------------*
FORM CHECK_TRANSPORT .

  DATA LV_LOEKZ TYPE C.

  SELECT SINGLE
    FROM ZEA_PPT020
    FIELDS LOEKZ
    WHERE AUFNR EQ @GS_DISPLAY3-AUFNR
    INTO @LV_LOEKZ.

  IF SY-SUBRC EQ 0.

    MESSAGE E000 WITH '입고가 되지 않았습니다. 입고를 수행해주세요.'.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_PERCENT
*&---------------------------------------------------------------------*
FORM MAKE_PERCENT .

  DATA LV_PERCENTAGE TYPE I.
  DATA LV_PDBAN TYPE ZEA_AFRU-PDBAN.

  CLEAR GS_DISPLAY3.

  READ TABLE GT_DISPLAY3 INTO GS_DISPLAY3 INDEX 1.

  LV_PERCENTAGE = ( GS_DISPLAY3-PDQUAN - GS_DISPLAY3-PDBAN ) / GS_DISPLAY3-PDQUAN * 100.


  IF LV_PERCENTAGE EQ 0.
    GS_DISPLAY3-STATUS = ICON_SPACE.
  ELSEIF LV_PERCENTAGE LE 70.
    GS_DISPLAY3-STATUS = ICON_LED_RED.
  ELSEIF LV_PERCENTAGE LE 95.
    GS_DISPLAY3-STATUS = ICON_LED_YELLOW.
  ELSEIF LV_PERCENTAGE LE 100.
    GS_DISPLAY3-STATUS = ICON_LED_GREEN.
  ENDIF.

  MODIFY GT_DISPLAY3 FROM GS_DISPLAY3 TRANSPORTING STATUS
                                             WHERE AUFNR = GS_DISPLAY3-AUFNR.


ENDFORM.
