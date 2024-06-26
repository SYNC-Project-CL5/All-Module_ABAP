*&---------------------------------------------------------------------*
*& Include          MZEA_PP100F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form MAKE_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM MAKE_FIELDCAT_0100 .

  LOOP AT GT_FIELDCAT INTO GS_FIELDCAT.

    CASE GS_FIELDCAT-FIELDNAME.
      WHEN 'AUFNR'.
        GS_FIELDCAT-HOTSPOT = ABAP_ON.
      WHEN 'PNAME1'.
        GS_FIELDCAT-COL_POS = 2.
      WHEN 'APPROVER'.
*        GS_FIELDCAT-NO_OUT = ABAP_ON.
      WHEN 'APPROVAL'.
        GS_FIELDCAT-NO_OUT = ABAP_ON.
      WHEN 'MEINS'.
        GS_FIELDCAT-COLTEXT = '단위'.
      WHEN 'REJREASON'.
        GS_FIELDCAT-DRDN_HNDL = '1'.
        GS_FIELDCAT-DRDN_ALIAS = ABAP_ON.
        GS_FIELDCAT-EDIT       = ABAP_ON.

*      WHEN 'REJECT'.
*        GS_FIELDCAT-COL_POS = 100.
*        GS_FIELDCAT-COLTEXT = '반려사유'.
*        GS_FIELDCAT-JUST    = 'C'.
**        GS_FIELDCAT-STYLE   = CL_GUI_ALV_GRID=>MC_STYLE_BUTTON.
      WHEN 'LOEKZ'.
        GS_FIELDCAT-NO_OUT = ABAP_ON.
      WHEN 'ERNAM'.
        GS_FIELDCAT-NO_OUT = ABAP_ON.
      WHEN 'ERDAT'.
        GS_FIELDCAT-NO_OUT = ABAP_ON.
      WHEN 'ERZET'.
        GS_FIELDCAT-NO_OUT = ABAP_ON.
      WHEN 'AENAM'.
        GS_FIELDCAT-NO_OUT = ABAP_ON.
      WHEN 'AEDAT'.
        GS_FIELDCAT-NO_OUT = ABAP_ON.
      WHEN 'AEZET'.
        GS_FIELDCAT-NO_OUT = ABAP_ON.
      WHEN 'STATUS'.
        GS_FIELDCAT-COLTEXT = 'Status'.
        GS_FIELDCAT-ICON    = ABAP_ON.
        GS_FIELDCAT-KEY     = ABAP_OFF.
        GS_FIELDCAT-NO_OUT  = ABAP_ON.
      WHEN 'COLOR'.
        GS_FIELDCAT-NO_OUT  = ABAP_ON.
      WHEN 'LIGHT'.
        GS_FIELDCAT-COLTEXT = '승인여부'.
*        GS_FIELDCAT-NO_OUT  = ABAP_ON.
      WHEN 'MARK'.
        GS_FIELDCAT-NO_OUT  = ABAP_ON.
    ENDCASE.

    MODIFY GT_FIELDCAT FROM GS_FIELDCAT.

  ENDLOOP.

  LOOP AT GT_FIELDCAT2 INTO GS_FIELDCAT2.

    CASE GS_FIELDCAT2-FIELDNAME.
      WHEN 'ORDIDX'.
        GS_FIELDCAT2-JUST   = 'C'.
      WHEN 'LOEKZ'.
        GS_FIELDCAT2-NO_OUT = ABAP_ON.
      WHEN 'ERNAM'.
        GS_FIELDCAT2-NO_OUT = ABAP_ON.
      WHEN 'ERDAT'.
        GS_FIELDCAT2-NO_OUT = ABAP_ON.
      WHEN 'ERZET'.
        GS_FIELDCAT2-NO_OUT = ABAP_ON.
      WHEN 'AENAM'.
        GS_FIELDCAT2-NO_OUT = ABAP_ON.
      WHEN 'AEDAT'.
        GS_FIELDCAT2-NO_OUT = ABAP_ON.
      WHEN 'AEZET'.
        GS_FIELDCAT2-NO_OUT = ABAP_ON.
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
  CLEAR GS_VARIANT.
  CLEAR GV_SAVE.

  GS_VARIANT-REPORT = SY-REPID.
*  GS_VARIANT-VARIANT = PA_LAYO.
  GV_SAVE = 'A'.   " '' : Layout 저장불가
  " 'U' : 저장한 사용자만 사용가능
  " 'X' : Layout을 저장하면 모든 사용자가 사용 가능
  " 'A' : Layout을 저장할 때 'U'/'X' 선택 가능

  GS_LAYOUT-CWIDTH_OPT = 'A'.
  GS_LAYOUT-ZEBRA      = ABAP_ON.
  GS_LAYOUT-SEL_MODE   = 'D'.
*    GS_LAYOUT-SEL_MODE = 'A'.
  " A: 다중 행, 다중 열 선택, 선택 박스 생성
  " (셀 단위, 전체 선택도 가능)
*    GS_LAYOUT-SEL_MODE = 'B'. " B : 단일 행, 다중 열 선택, 기본 값
  " 기본값으로 해도 Ctrl + y로 강제로 드래그 할 수는 있음
*    GS_LAYOUT-SEL_MODE = 'C'. " C : 다중 행, 다중 열 선택, 줄 단위 선택

*  GS_LAYOUT-GRID_TITLE = TEXT-T10.          " ALV TITLE TEXT
*  GS_LAYOUT-INFO_FNAME = 'COLOR'.           " 행 색상
  GS_LAYOUT-EXCP_FNAME = 'LIGHT'.           " 신호등
  GS_LAYOUT-EXCP_LED = ABAP_ON.             " 신호등 모양 변경
*  GS_LAYOUT-CTAB_FNAME = 'IT_FIELD_COLORS'. " 셀 별 색상
  GS_LAYOUT-STYLEFNAME  = 'STYLE'.          " 스타일

  CLEAR GS_LAYOUT2.

  GS_VARIANT-REPORT = SY-REPID.
*  GS_VARIANT-VARIANT = PA_LAYO.
  GV_SAVE = 'A'.   " '' : Layout 저장불가
  " 'U' : 저장한 사용자만 사용가능
  " 'X' : Layout을 저장하면 모든 사용자가 사용 가능
  " 'A' : Layout을 저장할 때 'U'/'X' 선택 가능

  GS_LAYOUT2-CWIDTH_OPT = 'A'.
  GS_LAYOUT2-ZEBRA      = ABAP_ON.
  GS_LAYOUT2-SEL_MODE   = 'D'.
*    GS_LAYOUT-SEL_MODE = 'A'.
  " A: 다중 행, 다중 열 선택, 선택 박스 생성
  " (셀 단위, 전체 선택도 가능)
*    GS_LAYOUT-SEL_MODE = 'B'. " B : 단일 행, 다중 열 선택, 기본 값
  " 기본값으로 해도 Ctrl + y로 강제로 드래그 할 수는 있음
*    GS_LAYOUT-SEL_MODE = 'C'. " C : 다중 행, 다중 열 선택, 줄 단위 선택

*  GS_LAYOUT-GRID_TITLE = TEXT-T10.          " ALV TITLE TEXT
*  GS_LAYOUT-INFO_FNAME = 'COLOR'.           " 행 색상
*  GS_LAYOUT2-EXCP_FNAME = 'LIGHT'.           " 신호등
*  GS_LAYOUT2-EXCP_LED = ABAP_ON.             " 신호등 모양 변경
*  GS_LAYOUT-CTAB_FNAME = 'IT_FIELD_COLORS'. " 셀 별 색상
*  GS_LAYOUT-STYLEFNAME  = 'STYLE'.          " 스타일
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_DATA
*&---------------------------------------------------------------------*
FORM SELECT_DATA .

  REFRESH GT_DATA.

  SELECT A~AUFNR
         A~WERKS
         C~PNAME1
         A~PLANID
         A~MATNR
         B~MAKTX
         A~TOT_QTY
         A~MEINS
         A~APPROVAL
         A~APPROVER
         A~REJREASON
    INTO CORRESPONDING FIELDS OF TABLE GT_DATA
    FROM ZEA_AUFK AS A
    JOIN ZEA_MMT020 AS B
                    ON B~MATNR EQ A~MATNR
                   AND B~SPRAS EQ SY-LANGU
    JOIN ZEA_T001W AS C
                   ON C~WERKS EQ A~WERKS
    WHERE A~LOEKZ NE 'X'.

  SORT GT_DATA BY APPROVAL DESCENDING AUFNR ASCENDING.

*  REFRESH GT_DATA2.
*
*  SELECT *
*    FROM ZEA_PPT020
*    INTO CORRESPONDING FIELDS OF TABLE GT_DATA2.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM MAKE_DISPLAY_DATA .

  DATA LS_STYLE TYPE LVC_S_STYL.

  REFRESH GT_DISPLAY.
  REFRESH GT_DISPLAY2.

  LOOP AT GT_DATA INTO GS_DATA.

    CLEAR GS_DISPLAY.

    MOVE-CORRESPONDING GS_DATA TO GS_DISPLAY.

*신규 필드------------------------------------------------------------*

    CASE GS_DISPLAY-APPROVAL.
      WHEN 'A'.
        GS_DISPLAY-LIGHT = 3.
      WHEN 'W'.
        GS_DISPLAY-LIGHT = 2 .
      WHEN 'R'.
        GS_DISPLAY-LIGHT = 1.
    ENDCASE.

    IF GS_DISPLAY-LIGHT EQ 2.
      LS_STYLE-FIELDNAME = 'REJREASON'.
      LS_STYLE-STYLE        = CL_GUI_ALV_GRID=>MC_STYLE_ENABLED. "EDIT활성화
      INSERT LS_STYLE INTO TABLE GS_DISPLAY-STYLE.
    ELSE.
      LS_STYLE-FIELDNAME = 'REJREASON'.
      LS_STYLE-STYLE        = CL_GUI_ALV_GRID=>MC_STYLE_DISABLED. "EDIT 비활성화
      INSERT LS_STYLE INTO TABLE GS_DISPLAY-STYLE.
    ENDIF.

*    GS_DISPLAY-REJECT = ICON_DISPLAY_TEXT.

*    CLEAR LS_STYLE.
*    LS_STYLE-FIELDNAME = 'REJECT'.
*    LS_STYLE-STYLE     = CL_GUI_ALV_GRID=>MC_STYLE_BUTTON.
*    APPEND LS_STYLE TO GS_DISPLAY-STYLE.


*--------------------------------------------------------------------*
    APPEND GS_DISPLAY TO GT_DISPLAY.

  ENDLOOP.


  LOOP AT GT_DATA2 INTO GS_DATA2.

    CLEAR GS_DISPLAY2.

    MOVE-CORRESPONDING GS_DATA2 TO GS_DISPLAY2.

*신규 필드------------------------------------------------------------*


*--------------------------------------------------------------------*
    APPEND GS_DISPLAY2 TO GT_DISPLAY2.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM DISPLAY_DATA .

  CHECK SY-UNAME EQ 'ACA5-03'
     OR SY-UNAME EQ 'ACA5-07'
     OR SY-UNAME EQ 'ACA5-08'
     OR SY-UNAME EQ 'ACA5-10'
     OR SY-UNAME EQ 'ACA5-12'
     OR SY-UNAME EQ 'ACA5-15'
     OR SY-UNAME EQ 'ACA5-17'
     OR SY-UNAME EQ 'ACA5-23'
     OR SY-UNAME EQ 'ACA-05'.

  DESCRIBE TABLE GT_DISPLAY LINES GV_LINES.

  IF GT_DISPLAY IS INITIAL.
    MESSAGE S013 DISPLAY LIKE 'W'.
  ELSE.
    MESSAGE S006 WITH GV_LINES.
  ENDIF.

  CALL SCREEN 0100.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form INIT_DATA
*&---------------------------------------------------------------------*
FORM INIT_DATA .

*EX------------------------------------------------------------------*
*  BUTTXT = 'Hide Details'(L04).
*
** Exercise 4에 의해 Tabstrips 생성 및 Tab Title 정의
*  TAB1 = 'Flight connections'(L01).
*  TAB2 = 'Flight date'(L02).
*  TAB3 = 'Flight type'(L03).
*
*  TAB_BLOCK-ACTIVETAB = 'COMM2'.  " 눌려진 제목 부분
*  TAB_BLOCK-DYNNR     = '1200'.   " 출력될 내용 부분
*
** AIRLINE ( SO_CAR ) 에 AA ~ QF 인 데이터이면서 AZ 는 제외하는 조건을
* 초기조건으로 지정해라
*  SO_CAR-SIGN = 'I'.
*  SO_CAR-OPTION = 'BT'.
*  SO_CAR-LOW = 'AA'.
*  SO_CAR-HIGH = 'QF'.
*  APPEND SO_CAR. " 첫번째 조건을 추가
*
*  CLEAR SO_CAR. " Header Line을 초기화
*  SO_CAR-SIGN = 'E'.
*  SO_CAR-OPTION = 'EQ'.
*  SO_CAR-LOW = 'AZ'.
*  APPEND SO_CAR. " 두번째 조건을 추가
*--------------------------------------------------------------------*

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MODIFY_SSCREEN
*&---------------------------------------------------------------------*
FORM MODIFY_SSCREEN .

*EX------------------------------------------------------------------*
*  IF BUTTXT EQ TEXT-L06.
*    LOOP AT SCREEN.
*      IF SCREEN-GROUP1 EQ 'MOD'.
*        SCREEN-ACTIVE = 0.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*
*  ENDIF.
*--------------------------------------------------------------------*

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SSCR_USER_COMMAND
*&---------------------------------------------------------------------*
FORM SSCR_USER_COMMAND .

*EX------------------------------------------------------------------*
*  CASE SY-UCOMM.
*    WHEN 'CLICK_DETAIL'.
*      IF BUTTXT EQ TEXT-L06.
*        BUTTXT = '추가조건 숨김'(L07).
*      ELSE.
*        BUTTXT = '조회조건 추가'(L06).
*      ENDIF.
*  ENDCASE.
*--------------------------------------------------------------------*

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHECK_INPUT
*&---------------------------------------------------------------------*
FORM CHECK_INPUT .


*EX------------------------------------------------------------------*
*  " 출발에 대한 점검
*  SELECT COUNT(*)
*    FROM SPFLI
*   WHERE COUNTRYFR EQ PA_CTRF
*     AND CITYFROM  IN SO_CITYF.
*
*  IF SY-SUBRC NE 0.
*    MESSAGE E010.
*  ENDIF.
*--------------------------------------------------------------------*

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_0100
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT_0100 .

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
      PARENT  = GO_CONTAINER                   " Parent Container
      ROWS    = 2                   " Number of Rows to be displayed
      COLUMNS = 1                   " Number of Columns to be Displayed
    EXCEPTIONS
      OTHERS  = 1.
  IF SY-SUBRC <> 0.
    MESSAGE '분리 컨테이너 생성에 실패했습니다.' TYPE 'E'.
  ENDIF.

  CALL METHOD GO_SPLIT->GET_CONTAINER
    EXPORTING
      ROW       = 1                " Row
      COLUMN    = 1                " Column
    RECEIVING
      CONTAINER = GO_CON_TOP.                 " Container

  CALL METHOD GO_SPLIT->GET_CONTAINER
    EXPORTING
      ROW       = 2                " Row
      COLUMN    = 1                " Column
    RECEIVING
      CONTAINER = GO_CON_BOT.                 " Container

  " 신문법 중 하나
  GO_CON_TOP = GO_SPLIT->GET_CONTAINER( ROW = 1 COLUMN = 1 ).
  GO_CON_BOT = GO_SPLIT->GET_CONTAINER( ROW = 2 COLUMN = 1 ).


  " TOP 컨테이너 ALV를 생성
  CREATE OBJECT GO_ALV_GRID_TOP
    EXPORTING
      I_PARENT = GO_CON_TOP " Parent Container
    EXCEPTIONS
      OTHERS   = 1.

  IF SY-SUBRC NE 0.
    MESSAGE 'ALV 생성에 실패했습니다.' TYPE 'E'.
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
*& Form DISPLAY_ALV_0100
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV_0100 .

  DESCRIBE TABLE GT_DISPLAY LINES GV_LINES.

  IF GT_DISPLAY IS INITIAL.
    MESSAGE S013 DISPLAY LIKE 'W'.
  ELSE.
    MESSAGE S006 WITH GV_LINES.
  ENDIF.

  CLEAR GS_VARIANT.
  GS_VARIANT-REPORT = SY-REPID. " 현재 프로그램 이름을 전달
  GS_VARIANT-HANDLE = '1'.
  GV_SAVE = 'A'. " 개인용/공용 모두 생성 가능하도록 설정

  CALL METHOD GO_ALV_GRID_TOP->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
      I_STRUCTURE_NAME = 'ZEA_AUFK'     " Internal Output Table Structure Name
      IS_VARIANT       = GS_VARIANT  " Layout
      I_SAVE           = GV_SAVE     " Save Layout
      IS_LAYOUT        = GS_LAYOUT   " Layout
    CHANGING
      IT_OUTTAB        = GT_DISPLAY    " Output Table
      IT_FIELDCATALOG  = GT_FIELDCAT          " Field Catalog
    EXCEPTIONS
      OTHERS           = 1.

  IF SY-SUBRC <> 0.
    MESSAGE 'ALV에 데이터를 설정하는 과정 중 오류가 발생했습니다.' TYPE 'E'.
  ENDIF.

  GS_VARIANT-HANDLE = '2'.

  CALL METHOD GO_ALV_GRID_BOT->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
      I_STRUCTURE_NAME = 'ZEA_PPT020'     " Internal Output Table Structure Name
      IS_VARIANT       = GS_VARIANT  " Layout
      I_SAVE           = GV_SAVE     " Save Layout
      IS_LAYOUT        = GS_LAYOUT2   " Layout
    CHANGING
      IT_OUTTAB        = GT_DISPLAY2    " Output Table
      IT_FIELDCATALOG  = GT_FIELDCAT2          " Field Catalog
    EXCEPTIONS
      OTHERS           = 1.

  IF SY-SUBRC <> 0.
    MESSAGE 'ALV에 데이터를 설정하는 과정 중 오류가 발생했습니다.' TYPE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_FIELDCAT_0100 .

*     PERFORM GET_FIELDCAT_0100.
  PERFORM GET_FIELDCAT2   USING    GT_DISPLAY
                          CHANGING GT_FIELDCAT.


  PERFORM GET_FIELDCAT2   USING    GT_DISPLAY2
                          CHANGING GT_FIELDCAT2.

  PERFORM MAKE_FIELDCAT_0100.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_EVENT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_EVENT_0100 .

  SET HANDLER LCL_EVENT_HANDLER=>ON_TOOLBAR FOR GO_ALV_GRID_TOP.
  SET HANDLER LCL_EVENT_HANDLER=>ON_DOUBLE_CLICK FOR GO_ALV_GRID_TOP.
  SET HANDLER LCL_EVENT_HANDLER=>ON_USER_COMMAND FOR GO_ALV_GRID_TOP.
  SET HANDLER LCL_EVENT_HANDLER=>ON_HOTSPOT_CLICK FOR GO_ALV_GRID_TOP.
  SET HANDLER LCL_EVENT_HANDLER=>ON_BUTTON_CLICK FOR GO_ALV_GRID_TOP.

  SET HANDLER LCL_EVENT_HANDLER=>ON_TOOLBAR FOR GO_ALV_GRID_BOT.
  SET HANDLER LCL_EVENT_HANDLER=>ON_DOUBLE_CLICK FOR GO_ALV_GRID_BOT.
  SET HANDLER LCL_EVENT_HANDLER=>ON_USER_COMMAND FOR GO_ALV_GRID_BOT.
  SET HANDLER LCL_EVENT_HANDLER=>ON_HOTSPOT_CLICK FOR GO_ALV_GRID_BOT.
  SET HANDLER LCL_EVENT_HANDLER=>ON_BUTTON_CLICK FOR GO_ALV_GRID_BOT.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH_ALV_0100
*&---------------------------------------------------------------------*
FORM REFRESH_ALV_0100 .

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
*& Form GET_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM GET_FIELDCAT_0100 .

  "DATA GT_FIELDCAT TYPE LVC_T_FCAT.
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
    MESSAGE E022. "Field Catalog 생성 및 변환 중 오류가 발생했습니다.
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
*& Form HANDLER_TOOLBAR
*&---------------------------------------------------------------------*
FORM HANDLER_TOOLBAR
  USING PO_OBJECT TYPE REF TO CL_ALV_EVENT_TOOLBAR_SET
        PO_SENDER TYPE REF TO CL_GUI_ALV_GRID.

  " Internal Table PO_OBJECT->MT_TOOLBAR 를 위한 작업공간
  " PO_OBJECT->MT_TOOLBAR >>> 클래스의 Attribute ( Public , Instance )
  DATA LS_TOOLBAR LIKE LINE OF PO_OBJECT->MT_TOOLBAR.

  CASE PO_SENDER.
    WHEN GO_ALV_GRID_TOP.

      DATA LV_TOTAL TYPE I.
      DATA LV_GREEN TYPE I.
      DATA LV_YELLOW TYPE I.
      DATA LV_RED TYPE I.

      DESCRIBE TABLE GT_DISPLAY.

      LOOP AT GT_DISPLAY INTO GS_DISPLAY.
        ADD 1 TO LV_TOTAL.

        CASE GS_DISPLAY-LIGHT.
          WHEN '1'. ADD 1 TO LV_RED.
          WHEN '2'. ADD 1 TO LV_YELLOW.
          WHEN '3'. ADD 1 TO LV_GREEN.
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
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 승인
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-FUNCTION = GC_APPROVE.
      LS_TOOLBAR-ICON = ICON_LED_GREEN.
      LS_TOOLBAR-TEXT = | 승인 : { LV_GREEN }  |.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 대기
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-FUNCTION = GC_WAIT.
      LS_TOOLBAR-ICON = ICON_LED_YELLOW.
      LS_TOOLBAR-TEXT = | 대기 : { LV_YELLOW }  |.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 반려
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-FUNCTION = GC_REJECT.
      LS_TOOLBAR-ICON = ICON_LED_RED.
      LS_TOOLBAR-TEXT = | 반려 : { LV_RED }  |.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

*
** CONSTANTS GC_CHANGE_CLASS TYPE SY-UCOMM VALUE 'CHANGE_CLASS'.
*
** 버튼 추가 =>> 좌석등급변경
*  CLEAR LS_TOOLBAR.
*  LS_TOOLBAR-FUNCTION = GC_CHANGE_CLASS.
*  LS_TOOLBAR-TEXT     = TEXT-L02. " 좌석등급변경
*  APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.
*
** 구분자 =>> |
*  CLEAR LS_TOOLBAR.
*  LS_TOOLBAR-BUTN_TYPE = 3. " 구분자
*  APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.
*
*  DATA LV_TOTAL TYPE I.
*  DATA LV_GREEN TYPE I.
*  DATA LV_YELLOW TYPE I.
*  DATA LV_RED TYPE I.
*
*  LOOP AT GT_DISPLAY INTO GS_DISPLAY.
*    ADD 1 TO LV_TOTAL.
*
*    CASE GS_DISPLAY-LIGHT.
*      WHEN '1'. ADD 1 TO LV_RED.
*      WHEN '2'. ADD 1 TO LV_YELLOW.
*      WHEN '3'. ADD 1 TO LV_GREEN.
*    ENDCASE.
*
*  ENDLOOP.
*
** 버튼 추가 =>> Totals:  #,###
*  CLEAR LS_TOOLBAR.
*  LS_TOOLBAR-FUNCTION = GC_CLEAR_FILTER.
**  DESCRIBE TABLE GT_DISPLAY.
*  DATA LV_LINES TYPE I.
*  LV_LINES = LINES( GT_DISPLAY ).
*  LS_TOOLBAR-TEXT     = TEXT-L03 && ':' && LV_LINES. " Totals
*  APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.
*
** 버튼 추가 =>> 완료된 예약: #,###
*  CLEAR LS_TOOLBAR.
*  LS_TOOLBAR-FUNCTION = GC_GREEN_FILTER.
*  LS_TOOLBAR-TEXT     = TEXT-L04 && ':' && LV_GREEN. " 완료된 예약
*  APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.
*
** 버튼 추가 =>> 완료된 예약: #,###
*  CLEAR LS_TOOLBAR.
*  LS_TOOLBAR-FUNCTION = GC_YELLOW_FILTER.
*  LS_TOOLBAR-TEXT     = TEXT-L05 && ':' && LV_YELLOW. " 예정된 예약
*  APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.
*
** 버튼 추가 =>> 완료된 예약: #,###
*  CLEAR LS_TOOLBAR.
*  LS_TOOLBAR-FUNCTION = GC_RED_FILTER.
*  LS_TOOLBAR-TEXT     = TEXT-L06 && ':' && LV_RED. " 취소된 예약
*  APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.
    WHEN GO_ALV_GRID_BOT.
  ENDCASE.




ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_USER_COMMAND
*&---------------------------------------------------------------------*
*&   --> E_UCOMM   ->> PO_UCOMM
*&   --> SENDER    ->> PO_SENDER
*&---------------------------------------------------------------------*
FORM HANDLE_USER_COMMAND USING PV_UCOMM TYPE SY-UCOMM
                               PO_SENDER  TYPE REF TO CL_GUI_ALV_GRID.

  CASE PO_SENDER.
    WHEN GO_ALV_GRID_TOP. "PO_SENDER 가 GO_ALV_GRID 일 때
      CASE PV_UCOMM.  " 선택한 버튼 (PV_UCOMM은 SY-UCOMM 타입)

        WHEN GC_NO_FILTER.
          PERFORM NO_FILTER.

        WHEN GC_APPROVE.
          PERFORM APPROVE_FILTER.

        WHEN GC_WAIT.
          PERFORM WAIT_FILTER.

        WHEN GC_REJECT.
          PERFORM REJECT_FILTER.
*          " 예약 취소
*          PERFORM BOOKING_CANCEL USING PO_SENDER.

      ENDCASE.

  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_HOTSPOT_CLICK
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_ROW_ID
*&      --> E_COLUMN_ID
*&      --> SENDER
*&---------------------------------------------------------------------*
FORM HANDLE_HOTSPOT_CLICK USING PS_ROW_ID TYPE LVC_S_ROW
                                PS_COLUMN_ID TYPE  LVC_S_COL
                                PO_SENDER    TYPE REF TO CL_GUI_ALV_GRID.

* 선택한 행이 인터널테이블에 있는 정상적인 데이터인지 체크
  CHECK PS_ROW_ID-ROWTYPE IS INITIAL.

  CASE PO_SENDER.
    WHEN GO_ALV_GRID_TOP.
      CASE PS_COLUMN_ID-FIELDNAME.
        WHEN 'AUFNR'.

          LOOP AT GT_DISPLAY INTO GS_DISPLAY.
            GS_DISPLAY-COLOR = SPACE.
            MODIFY GT_DISPLAY FROM GS_DISPLAY TRANSPORTING COLOR.
          ENDLOOP.

          READ TABLE GT_DISPLAY INTO GS_DISPLAY INDEX PS_ROW_ID-INDEX.


          SELECT *

*                 A~AUFNR
*                 A~ORDIDX
*                 A~MATNR
*                 B~MAKTX
**                 A~BOMID
*                 A~WERKS
*                 C~PNAME1
*                 A~EXPQTY
*                 A~SDATE
*                 A~EDATE
*                 A~ISPDATE
*                 A~REPQTY
*                 A~RQTY
*                 A~UNIT
*                 A~LOEKZ
             INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY2
             FROM ZEA_PPT020 AS A
             JOIN ZEA_MMT020 AS B ON
                                B~MATNR EQ A~MATNR
                            AND B~SPRAS EQ SY-LANGU
             JOIN ZEA_T001W  AS C ON
                                C~WERKS EQ A~WERKS
             WHERE A~AUFNR EQ GS_DISPLAY-AUFNR
               AND A~LOEKZ NE 'X'.

          PERFORM REFRESH_ALV_0100.

      ENDCASE.
  ENDCASE.

**   HOTSPOT 옵션이 적용된 필드들 중에서
*    CASE PS_COLUMN_ID-FIELDNAME.
*
*      WHEN 'CLASS'. " 클릭한 필드가 CLASS 필드일 때
*
*        " 좌석 변경
*        PERFORM CHANGE_CLASS USING PO_SENDER.
*
*      WHEN OTHERS.
*
*    ENDCASE.





ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_DOUBLE_CLICK
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_ROW
*&      --> E_COLUMN
*&      --> SENDER
*&---------------------------------------------------------------------*
FORM HANDLE_DOUBLE_CLICK USING PS_ROW TYPE LVC_S_ROW
                               PS_COL     TYPE  LVC_S_COL
                               PO_SENDER  TYPE REF TO CL_GUI_ALV_GRID.

* 선택한 행이 인터널테이블에 있는 정상적인 데이터인지 체크
  CHECK PS_ROW-ROWTYPE IS INITIAL.

*  CASE PS_COL-FIELDNAME.
*    WHEN 'CARRID' OR 'CARRNAME'.
*
*      " 항공사ID 또는 항공사명을 더블 클릭하면
*      " TRANSACTION BC402MCAR 를 호출한다
*      IF PS_ROW-ROWTYPE IS INITIAL.
*        READ TABLE GT_DISPLAY INTO GS_DISPLAY INDEX PS_ROW-INDEX..
*        SET PARAMETER ID 'CAR' FIELD GS_DISPLAY-CARRID.
*        CALL TRANSACTION 'BC402MCAR'
*          AND SKIP FIRST SCREEN.
*      ENDIF.
*
*
*  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_BUTTON_CLICK
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ES_ROW_NO
*&      --> ES_COL_ID
*&      --> SENDER
*&---------------------------------------------------------------------*
FORM HANDLE_BUTTON_CLICK USING PS_ROW_NO TYPE LVC_S_ROID
                               PS_COL_ID TYPE LVC_S_COL
                               PO_SENDER TYPE REF TO CL_GUI_ALV_GRID.

  CASE PO_SENDER.
    WHEN GO_ALV_GRID_TOP.
      CASE PS_COL_ID-FIELDNAME.
        WHEN ''.
      ENDCASE.
    WHEN GO_ALV_GRID_BOT.
  ENDCASE.


**** MAKE DISPLAY_DATA 에서 다음과 같이 버튼 필드를 설정한다.
*FORM MAKE_DISPLAY_DATA .
*
*  DATA LS_STYLE TYPE LVC_S_STYL.  " GS_DISPLAY-STYLE 의 작업공간
*
*  REFRESH GT_DISPLAY.
*
*  " GT_DATA 의 데이터를 GT_DISPLAY 로 옮긴다.
*  " 옮기는 중 추가로 작업할 내용들도 같이 기록한다.
*  LOOP AT GT_DATA INTO GS_DATA.
*
*    CLEAR GS_DISPLAY.
*    MOVE-CORRESPONDING GS_DATA TO GS_DISPLAY. " 동일한 필드명에게 값 전달
*
*    " 내일부터 출발하는 비행기들은 취소가 가능하도록 버튼을 생성함.
*    IF GS_DISPLAY-FLDATE > SY-DATUM.
*      GS_DISPLAY-CANCEL_BTTXT = TEXT-L01. "'일정 취소'(L01).
*
*      " CANCEL_BTTXT 라는 필드는 스타일을 버튼으로 취급하는 정보를
*      " Internal Table 인 GS_DISPLAY-STYLE 에 한 줄 추가한다.
*      CLEAR LS_STYLE.
*      LS_STYLE-FIELDNAME = 'CANCEL_BTTXT'.
*      LS_STYLE-STYLE     = CL_GUI_ALV_GRID=>MC_STYLE_BUTTON.
*      APPEND LS_STYLE TO GS_DISPLAY-STYLE.
*
*    ENDIF.
*
*    " GS_DATA 와 그리고 내일부터 출발하는 비행기들만 CANCLE_BTTXT 필드와
*    " STYLE 필드에 특별한 값들이 저장된 GS_DISPLAY 를 GT_DISPLAY 로 한 줄 추가한다.
*    APPEND GS_DISPLAY TO GT_DISPLAY.
*
*  ENDLOOP.
*
*ENDFORM.
*--------------------------------------------------------------------*
* SET_ALV_LAYOUT_0100에서 다음과 같이 세팅
*GS_LAYOUT-STYLEFNAME  = 'STYLE'.

*--------------------------------------------------------------------*
* 구현 예시)
*  METHOD ON_BUTTON_CLICK. " 위 정의에 대한 구현
*
*    DATA LV_MSG TYPE STRING.
*
*    CASE ES_COL_ID-FIELDNAME.
*      WHEN 'CANCEL_BTTXT'. " 일정 취소 버튼인지
*
*        " 현재 선택하신 버튼은 &1 번째 줄의 &2 열 입니다.
*        " &1 = ES_ROW_NO-ROW_ID     = 내가 선택한 버튼의 행 위치
*        " &2 = ES_COL_ID-FIELDNAME  = 내가 선택한 버튼의 열 위치
**        LV_MSG = '현재 선택하신 버튼은 ' && ES_ROW_NO-ROW_ID && '번째 줄의'
**            && ES_COL_ID-FIELDNAME && ' 열 입니다.'.
*
**        LV_MSG = |현재 선택하신 버튼은 { ES_ROW_NO-ROW_ID }| &&
**                 | 번째 줄의 { ES_COL_ID-FIELDNAME } 열 입니다.|.
*
**         LV_MSG = |현재 선택하신 버튼은 { ES_ROW_NO-ROW_ID } 번째 줄의 { ES_COL_ID-FIELDNAME } 열 입니다. |.
*
**        MESSAGE LV_MSG TYPE 'I'.
*
*        DATA LV_ANSWER TYPE C.
*
*        CALL FUNCTION 'POPUP_TO_CONFIRM_STEP_2_BUTTON'
*          EXPORTING
**            DEFAULTOPTION  = 'Y'              " Cursorpositionierung auf Antwort Ja oder Nein
*            TEXTLINE1      =  TEXT-M01 "'예약을 취소하시겠습니까?'
**            TEXTLINE2      = SPACE            " zweite Zeile des Dialogfensters
*            TITEL          = TEXT-T03 " 확인
**            START_COLUMN   = 25               " Startspalte des Dialogfensters
**            START_ROW      = 6                " Startzeile des Dialogfensters
**            CANCEL_DISPLAY = ''              " Abbrechen-Knopf anzeigen
*          IMPORTING
*            ANSWER         = LV_ANSWER.                 " ausgewählte Antwort des Endanwenders
*
**          LV_MSG = |내가 선택한 버튼의 값은 { LV_ANSWER } 이다.|.
**          MESSAGE LV_MSG TYPE 'I'.
*
*          CASE LV_ANSWER.
*            WHEN 'J'. " Yes 예 버튼 눌렀을 때
*
*              " ES_ROW_NO-ROW_ID : 내가 버튼을 누른 행 번호
*              "GT_DISPLAY 에서 내가 누른 버튼이 있는 행을 삭제하겠다.
*              DELETE GT_DISPLAY INDEX ES_ROW_NO-ROW_ID.
*
*              DATA LS_STABLE TYPE LVC_S_STBL.
*              " 행의 스크롤 바 고정, 가로 스크롤바도 고정
*              LS_STABLE-ROW = ABAP_ON. " 현재 행의 위치에 여전히 머무르겠다.
*              LS_STABLE-COL = ABAP_ON. " 현재 열의 위치에 여전히 머무르겠다.
*
*              CALL METHOD GO_ALV_GRID->REFRESH_TABLE_DISPLAY
*                EXPORTING
*                  IS_STABLE      = LS_STABLE
**                  I_SOFT_REFRESH =                  " Without Sort, Filter, etc.
*                EXCEPTIONS
*                  FINISHED       = 1                " Display was Ended (by Export)
*                  OTHERS         = 2.
*
*              IF SY-SUBRC <> 0.
*               MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*                 WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*              ENDIF.
*
*            WHEN OTHERS.
*          ENDCASE.
*
*      WHEN OTHERS.         " 아니면 다른 버튼인지
*
*    ENDCASE.


ENDFORM.
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
*& Form APPROVE_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM APPROVE_DATA .

  DATA: LT_PLKO TYPE TABLE OF ZEA_PLKO,
        LS_PLKO TYPE ZEA_PLKO,
        LT_PLPO TYPE TABLE OF ZEA_PLPO,
        LS_PLPO TYPE ZEA_PLPO,
        LV_RTID TYPE ZEA_PLKO-RTID.

  _MC_POPUP_CONFIRM '승인' '선택한 결재건들을 승인하시겠습니까?' GV_ANSWER.
  CHECK GV_ANSWER = '1'.

  DATA LT_INDEX_ROWS TYPE LVC_T_ROW.
  DATA LS_INDEX_ROW LIKE LINE OF LT_INDEX_ROWS.

  CALL METHOD GO_ALV_GRID_TOP->GET_SELECTED_ROWS
    IMPORTING
      ET_INDEX_ROWS = LT_INDEX_ROWS     " Indexes of Selected Rows
*     ET_ROW_NO     =                  " Numeric IDs of Selected Rows
    .

  DATA LV_SUBRC TYPE I.
  DATA LV_COUNT TYPE I.
  DATA LV_CHECK.

  IF LT_INDEX_ROWS[] IS INITIAL.
    " TEXT-M01: 라인을 선택하세요.
    MESSAGE S000 DISPLAY LIKE 'W' WITH '최소 한 행이상 선택하세요'.

  ELSE.
    LOOP AT LT_INDEX_ROWS INTO LS_INDEX_ROW WHERE ROWTYPE IS INITIAL.

      READ TABLE GT_DISPLAY INTO GS_DISPLAY INDEX LS_INDEX_ROW-INDEX.

      IF GS_DISPLAY-LIGHT NE 2.
        ROLLBACK WORK.
        LV_CHECK = ABAP_ON.
      ENDIF.

      IF SY-SUBRC EQ 0
      AND LV_CHECK IS INITIAL
      AND GS_DISPLAY-REJREASON IS INITIAL.
        UPDATE ZEA_AUFK SET APPROVAL = 'A'
                            AEDAT    = SY-DATUM
                            AEZET    = SY-UZEIT
                            AENAM    = SY-UNAME
                      WHERE AUFNR EQ GS_DISPLAY-AUFNR.

        ADD SY-SUBRC TO LV_SUBRC.

        IF LV_SUBRC EQ 0.
          LV_COUNT += 1.

*          GS_DISPLAY-LIGHT = 3.
*          GS_DISPLAY-APPROVAL = 'A'.
*          MODIFY GT_DISPLAY FROM GS_DISPLAY
*          INDEX LS_INDEX_ROW-INDEX TRANSPORTING APPROVAL LIGHT.

          LV_RTID = |RTID{ GS_DISPLAY-AUFNR+5(5) }|.

          MOVE-CORRESPONDING GS_DISPLAY TO LS_PLKO.
          LS_PLKO-RTID   = LV_RTID.
          LS_PLKO-RTSTEP = 1.

          SELECT SINGLE EXPQTY
            FROM ZEA_PPT020
            INTO @DATA(LV_QTY)
            WHERE AUFNR EQ @GS_DISPLAY-AUFNR.

          LS_PLKO-QTY    = LV_QTY.

          SELECT SINGLE UNIT
            FROM ZEA_PPT020
            INTO @DATA(LV_UNIT)
            WHERE AUFNR EQ @GS_DISPLAY-AUFNR.

          LS_PLKO-UNIT   = LV_UNIT.
          LS_PLKO-ERDAT  = SY-DATUM.
          LS_PLKO-ERZET  = SY-UZEIT.
          LS_PLKO-ERNAM  = SY-UNAME.
          INSERT ZEA_PLKO FROM LS_PLKO.

          ADD SY-SUBRC TO LV_SUBRC.

          DO 6 TIMES.
            LS_PLPO-RTID    = LV_RTID.
            LS_PLPO-RTIDX   = SY-INDEX * 10.
            LS_PLPO-WCID    = |WCID000{ SY-INDEX }|.
            LS_PLPO-RTSTEP  = SY-INDEX.

            CASE SY-INDEX.
              WHEN 1.
                LS_PLPO-RTDNAME = '정련 공정'.
              WHEN 2.
                LS_PLPO-RTDNAME = '압출 공정'.
              WHEN 3.
                LS_PLPO-RTDNAME = '압연 공정'.
              WHEN 4.
                LS_PLPO-RTDNAME = '비드 공정'.
              WHEN 5.
                LS_PLPO-RTDNAME = '성형 공정'.
              WHEN 6.
                LS_PLPO-RTDNAME = '가류 공정'.
            ENDCASE.

            LS_PLPO-ERDAT  = SY-DATUM.
            LS_PLPO-ERZET  = SY-UZEIT.
            LS_PLPO-ERNAM  = SY-UNAME.
            INSERT ZEA_PLPO FROM LS_PLPO.

            ADD SY-SUBRC TO LV_SUBRC.
          ENDDO.

        ENDIF.

      ELSE.
        LV_SUBRC = 4.
      ENDIF.

    ENDLOOP.

    IF LV_SUBRC EQ 0
      AND LV_CHECK IS INITIAL.

      "변경사항에 대한 확정처리
      COMMIT WORK AND WAIT.
      MESSAGE S000 WITH LV_COUNT '건의 결재건을 승인하였습니다.'.

*     Itab 변경 로직
      LOOP AT LT_INDEX_ROWS INTO LS_INDEX_ROW.
        READ TABLE GT_DISPLAY INTO GS_DISPLAY INDEX LS_INDEX_ROW-INDEX.
        GS_DISPLAY-LIGHT = 3.
        GS_DISPLAY-APPROVAL = 'A'.
        MODIFY GT_DISPLAY FROM GS_DISPLAY
        INDEX LS_INDEX_ROW-INDEX TRANSPORTING APPROVAL LIGHT.
      ENDLOOP.


      PERFORM REFRESH_ALV_0100.
    ELSE.
      " 변경사항에 대한 원복처리
      ROLLBACK WORK.
      MESSAGE S000 DISPLAY LIKE 'W' WITH '정상적인 결재를 진행해주세요.'.
    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form REJECT_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM REJECT_DATA .

  _MC_POPUP_CONFIRM '반려' '선택한 결재건들을 반려하시겠습니까?' GV_ANSWER.
  CHECK GV_ANSWER = '1'.

  DATA LT_INDEX_ROWS TYPE LVC_T_ROW.
  DATA LS_INDEX_ROW LIKE LINE OF LT_INDEX_ROWS.

  CALL METHOD GO_ALV_GRID_TOP->GET_SELECTED_ROWS
    IMPORTING
      ET_INDEX_ROWS = LT_INDEX_ROWS     " Indexes of Selected Rows
*     ET_ROW_NO     =                  " Numeric IDs of Selected Rows
    .

  DATA LV_SUBRC TYPE I.
  DATA LV_COUNT TYPE I.
  DATA LV_CHECK.

  IF LT_INDEX_ROWS[] IS INITIAL.
    " TEXT-M01: 라인을 선택하세요.
    MESSAGE S000 DISPLAY LIKE 'W' WITH '최소 한 행이상 선택하세요'.

  ELSE.
    LOOP AT LT_INDEX_ROWS INTO LS_INDEX_ROW WHERE ROWTYPE IS INITIAL.

      READ TABLE GT_DISPLAY INTO GS_DISPLAY INDEX LS_INDEX_ROW-INDEX.

      IF GS_DISPLAY-LIGHT NE 2.
        ROLLBACK WORK.
        LV_CHECK = ABAP_ON.
      ENDIF.

      IF SY-SUBRC EQ 0
        AND LV_CHECK IS INITIAL
        AND GS_DISPLAY-REJREASON IS NOT INITIAL.
        UPDATE ZEA_AUFK SET APPROVAL  = 'R'
                            REJREASON = GS_DISPLAY-REJREASON
                            AEDAT     = SY-DATUM
                            AEZET     = SY-UZEIT
                            AENAM     = SY-UNAME
                      WHERE AUFNR     EQ GS_DISPLAY-AUFNR.

        ADD SY-SUBRC TO LV_SUBRC.

        IF LV_SUBRC EQ 0.
          LV_COUNT += 1.
*
*          GS_DISPLAY-LIGHT = 1.
*          GS_DISPLAY-APPROVAL = 'R'.
*          MODIFY GT_DISPLAY FROM GS_DISPLAY
*          INDEX LS_INDEX_ROW-INDEX TRANSPORTING LIGHT APPROVAL REJREASON.
        ENDIF.

      ELSE.
        LV_SUBRC = 4.
      ENDIF.

    ENDLOOP.

    IF LV_SUBRC EQ 0
      AND LV_CHECK IS INITIAL.

      "변경사항에 대한 확정처리
      COMMIT WORK AND WAIT.
      MESSAGE S000 WITH LV_COUNT '건의 결재건을 반려하였습니다.'.

*     Itab 변경 로직
      LOOP AT LT_INDEX_ROWS INTO LS_INDEX_ROW.
        READ TABLE GT_DISPLAY INTO GS_DISPLAY INDEX LS_INDEX_ROW-INDEX.
        GS_DISPLAY-LIGHT = 1.
        GS_DISPLAY-APPROVAL = 'R'.
        MODIFY GT_DISPLAY FROM GS_DISPLAY
        INDEX LS_INDEX_ROW-INDEX TRANSPORTING LIGHT APPROVAL REJREASON.
      ENDLOOP.

      PERFORM REFRESH_ALV_0100.
    ELSE.
      " 변경사항에 대한 원복처리
      ROLLBACK WORK.
      MESSAGE S000 DISPLAY LIKE 'W' WITH '정상적인 결재를 실행해주세요'.
    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_LIST_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_ALV_LIST_0100 .

  GS_DROPDOWN-HANDLE = '1'.
  GS_DROPDOWN-VALUE = '재고 부족'.
  APPEND GS_DROPDOWN TO GT_DROPDOWN.

  GS_DROPDOWN-HANDLE = '1'.
  GS_DROPDOWN-VALUE = '생산 능력 부족'.
  APPEND GS_DROPDOWN TO GT_DROPDOWN.

  GS_DROPDOWN-HANDLE = '1'.
  GS_DROPDOWN-VALUE = '기타'.
  APPEND GS_DROPDOWN TO GT_DROPDOWN.


  CALL METHOD GO_ALV_GRID_TOP->SET_DROP_DOWN_TABLE
    EXPORTING
      IT_DROP_DOWN = GT_DROPDOWN.                 " Dropdown Table

*  CALL METHOD GO_ALV_GRID_TOP->REGISTER_EDIT_EVENT
*    EXPORTING
*      I_EVENT_ID = CL_GUI_ALV_GRID=>MC_EVT_MODIFIED.                 " Event ID




ENDFORM.
*&---------------------------------------------------------------------*
*& Form NO_FILTER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM NO_FILTER .

  REFRESH GT_FILTER.

  PERFORM SET_ALV_FILTER.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form APPROVE_FILTER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM APPROVE_FILTER .

  REFRESH GT_FILTER.

  CLEAR GS_FILTER.
  GS_FILTER-FIELDNAME = 'LIGHT'.
  GS_FILTER-SIGN      = 'I'.
  GS_FILTER-OPTION    = 'EQ'.
  GS_FILTER-LOW       = '3'.
  APPEND GS_FILTER TO GT_FILTER.

  PERFORM SET_ALV_FILTER.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form REJECT_FILTER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM REJECT_FILTER .

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
*& Form WAIT_FILTER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM WAIT_FILTER .

  REFRESH GT_FILTER.

  CLEAR GS_FILTER.
  GS_FILTER-FIELDNAME = 'LIGHT'.
  GS_FILTER-SIGN      = 'I'.
  GS_FILTER-OPTION    = 'EQ'.
  GS_FILTER-LOW       = '2'.
  APPEND GS_FILTER TO GT_FILTER.

  PERFORM SET_ALV_FILTER.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form F4_HELP
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM F4_HELP .

  DATA: LT_RETURN_TAB TYPE DDSHRETVAL OCCURS 0,
        LS_RETURN_TAB LIKE LINE OF LT_RETURN_TAB.

  DATA: LT_DSELC TYPE DSELC OCCURS 0,
        LS_DSELC LIKE LINE OF LT_DSELC.

  DATA: LS_VALUE  TYPE SEAHLPRES,
        LT_VALUE  TYPE TABLE OF SEAHLPRES,
        LS_FIELD  TYPE DFIES,
        LT_FIELDS TYPE TABLE OF DFIES.




  DATA : BEGIN OF LT_AUFNR OCCURS 0,
           AUFNR  TYPE ZEA_AUFK-AUFNR,
           PLANID TYPE ZEA_AUFK-PLANID,
           PNAME1 TYPE ZEA_T001W-PNAME1,
           WERKS  TYPE ZEA_T001W-WERKS,
           MATNR  TYPE ZEA_MMT020-MATNR,
           MAKTX  TYPE ZEA_MMT020-MAKTX,
         END OF LT_AUFNR.

  DATA: LT_MAP TYPE TABLE OF DSELC WITH HEADER LINE.

  CLEAR : LT_AUFNR, LT_AUFNR[],
          LT_VALUE, LT_VALUE[],
          LT_FIELDS, LT_FIELDS[].

  SELECT A~AUFNR
         A~PLANID
         B~PNAME1
         B~WERKS
         C~MATNR
         C~MAKTX
    INTO CORRESPONDING FIELDS OF TABLE LT_AUFNR
    FROM ZEA_AUFK   AS A
    JOIN ZEA_T001W  AS B
                    ON B~WERKS EQ A~WERKS
    JOIN ZEA_MMT020 AS C
                    ON C~MATNR EQ A~MATNR.

  SORT LT_AUFNR BY AUFNR.

*
***  LOOP AT LT_BOMID.
***    LS_VALUE-STRING = LT_BOMID-BOMID.
***    APPEND LS_VALUE TO LT_VALUE.
***    LS_VALUE-STRING = LT_BOMID-WERKS.
***    APPEND LS_VALUE TO LT_VALUE.
***    LS_VALUE-STRING = LT_BOMID-PNAME1.
***    APPEND LS_VALUE TO LT_VALUE.
***    LS_VALUE-STRING = LT_BOMID-MATNR.
***    APPEND LS_VALUE TO LT_VALUE.
***    LS_VALUE-STRING = LT_BOMID-MAKTX.
***    APPEND LS_VALUE TO LT_VALUE.
***    LS_VALUE-STRING = LT_BOMID-MATTYPE.
***    APPEND LS_VALUE TO LT_VALUE.
***    LS_VALUE-STRING = LT_BOMID-MENGE.
***    APPEND LS_VALUE TO LT_VALUE.
***    LS_VALUE-STRING = LT_BOMID-MEINS.
***    APPEND LS_VALUE TO LT_VALUE.
***  ENDLOOP.

  CLEAR LS_FIELD.
  LS_FIELD-FIELDNAME = 'AUFNR'.
  LS_FIELD-INTLEN = 20.
  LS_FIELD-LENG = 20.
  LS_FIELD-OUTPUTLEN = 20.
  LS_FIELD-REPTEXT = '생산오더ID'.
  APPEND LS_FIELD TO LT_FIELDS.

  CLEAR LS_FIELD.
  LS_FIELD-FIELDNAME = 'PLANID'.
  LS_FIELD-INTLEN = 20.
  LS_FIELD-LENG = 20.
  LS_FIELD-OUTPUTLEN = 20.
  LS_FIELD-REPTEXT = '생산계획ID'.
  APPEND LS_FIELD TO LT_FIELDS.

  CLEAR LS_FIELD.
  LS_FIELD-FIELDNAME = 'PNAME1'.
  LS_FIELD-INTLEN = 20.
  LS_FIELD-LENG = 20.
  LS_FIELD-OUTPUTLEN = 20.
  LS_FIELD-REPTEXT = '플랜트명'.
  APPEND LS_FIELD TO LT_FIELDS.

  CLEAR LS_FIELD.
  LS_FIELD-FIELDNAME = 'WERKS'.
  LS_FIELD-INTLEN = 20.
  LS_FIELD-LENG = 20.
  LS_FIELD-OUTPUTLEN = 20.
  LS_FIELD-REPTEXT = '플랜트'.
  APPEND LS_FIELD TO LT_FIELDS.

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


***  CLEAR: LT_MAP.
***  LT_MAP-FLDNAME = 'BOMID'.
***  LT_MAP-DYFLDNAME = 'ZEA_STKO-BOMID'.
***  APPEND LT_MAP.
***
***  CLEAR: LT_MAP.
***  LT_MAP-FLDNAME = 'WERKS'.
***  LT_MAP-DYFLDNAME = 'ZEA_STKO-WERKS'.
***  APPEND LT_MAP.
***
***  CLEAR: LT_MAP.
***  LT_MAP-FLDNAME = 'PNAME1'.
***  LT_MAP-DYFLDNAME = 'ZEA_T001W-PNAME1'.
***  APPEND LT_MAP.
***
***  CLEAR: LT_MAP.
***  LT_MAP-FLDNAME = 'MATNR'.
***  LT_MAP-DYFLDNAME = 'ZEA_STKO-MATNR'.
***  APPEND LT_MAP.
***
***  CLEAR: LT_MAP.
***  LT_MAP-FLDNAME = 'MAKTX'.
***  LT_MAP-DYFLDNAME = 'ZEA_MMT020-MAKTX'.
***  APPEND LT_MAP.
***
***  CLEAR: LT_MAP.
***  LT_MAP-FLDNAME = 'MATTYPE'.
***  LT_MAP-DYFLDNAME = 'ZEA_MMT010-MATTYPE'.
***  APPEND LT_MAP.
***
***  CLEAR: LT_MAP.
***  LT_MAP-FLDNAME = 'MENGE'.
***  LT_MAP-DYFLDNAME = 'ZEA_STKO-MENGE'.
***  APPEND LT_MAP.
***
***  CLEAR: LT_MAP.
***  LT_MAP-FLDNAME = 'MEINS'.
***  LT_MAP-DYFLDNAME = 'ZEA_STKO-MEINS'.
***  APPEND LT_MAP.
*
*
*
*
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      RETFIELD        = 'AUFNR'           " Name of return field in FIELD_TAB
      DYNPPROG        = SY-REPID          " Current program
      DYNPNR          = SY-DYNNR          " Screen number
*     DYNPROFIELD     = 'ZEA_STKO-BOMID'
      WINDOW_TITLE    = '생산오더'        " Title for the hit list
      VALUE_ORG       = 'S'               " Value return: C: cell by cell, S: structured
    TABLES
*     FIELD_TAB       = LT_FIELDS[]
      VALUE_TAB       = LT_AUFNR[]                 " Table of values: entries cell by cell
      RETURN_TAB      = LT_RETURN_TAB[]
*     DYNPFLD_MAPPING = LT_MAP
    EXCEPTIONS
      PARAMETER_ERROR = 1                " Incorrect parameter
      NO_VALUES_FOUND = 2                " No values found
      OTHERS          = 3.

  IF SY-SUBRC EQ 0.
    READ TABLE LT_RETURN_TAB INTO LS_RETURN_TAB INDEX 1.
    IF SY-SUBRC EQ 0.
      ZEA_AUFK-AUFNR = LS_RETURN_TAB-FIELDVAL.

      READ TABLE LT_AUFNR WITH KEY AUFNR = ZEA_AUFK-AUFNR BINARY SEARCH.
      IF SY-SUBRC EQ 0.
        ZEA_AUFK-AUFNR      = LT_AUFNR-AUFNR.
        ZEA_AUFK-PLANID     = LT_AUFNR-PLANID.
        ZEA_T001W-PNAME1    = LT_AUFNR-PNAME1.
        ZEA_T001W-WERKS     = LT_AUFNR-WERKS.
        ZEA_MMT020-MAKTX    = LT_AUFNR-MAKTX.
        ZEA_MMT020-MATNR    = LT_AUFNR-MATNR.
        LEAVE SCREEN.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form LEAVE_TO_PROCESS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM LEAVE_TO_PROCESS .
  CALL TRANSACTION 'ZEAPP120'.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form MODIFY_DISPLAY_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM MODIFY_DISPLAY_DATA .

  DATA LS_STYLE TYPE LVC_S_STYL.


*  REFRESH GT_DISPLAY.
*  REFRESH GT_DISPLAY2.

  LOOP AT GT_DISPLAY INTO GS_DISPLAY.


*신규 필드------------------------------------------------------------*

    CASE GS_DISPLAY-APPROVAL.
      WHEN 'A'.
        GS_DISPLAY-LIGHT = 3.
      WHEN 'W'.
        GS_DISPLAY-LIGHT = 2 .
      WHEN 'R'.
        GS_DISPLAY-LIGHT = 1.
    ENDCASE.

    CLEAR GS_DISPLAY-STYLE.

    IF GS_DISPLAY-LIGHT EQ 2.
      LS_STYLE-FIELDNAME = 'REJREASON'.
      LS_STYLE-STYLE        = CL_GUI_ALV_GRID=>MC_STYLE_ENABLED. "EDIT활성화
      INSERT LS_STYLE INTO TABLE GS_DISPLAY-STYLE.
    ELSE.
      LS_STYLE-FIELDNAME = 'REJREASON'.
      LS_STYLE-STYLE        = CL_GUI_ALV_GRID=>MC_STYLE_DISABLED. "EDIT 비활성화
      INSERT LS_STYLE INTO TABLE GS_DISPLAY-STYLE.
    ENDIF.

*    GS_DISPLAY-REJECT = ICON_DISPLAY_TEXT.

*    CLEAR LS_STYLE.
*    LS_STYLE-FIELDNAME = 'REJECT'.
*    LS_STYLE-STYLE     = CL_GUI_ALV_GRID=>MC_STYLE_BUTTON.
*    APPEND LS_STYLE TO GS_DISPLAY-STYLE.


*--------------------------------------------------------------------*
    MODIFY GT_DISPLAY FROM GS_DISPLAY.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_DATA_CONDITION
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SELECT_DATA_CONDITION .

  RANGES R_AUFNR   FOR ZEA_AUFK-AUFNR.
  RANGES R_PLANID  FOR ZEA_AUFK-PLANID.
  RANGES R_PNAME1  FOR ZEA_T001W-PNAME1.
  RANGES R_MAKTX   FOR ZEA_MMT020-MAKTX.

  REFRESH R_AUFNR[].
  CLEAR R_AUFNR.
  REFRESH R_PLANID[].
  CLEAR R_PLANID.
  REFRESH R_PNAME1[].
  CLEAR R_PNAME1.
  REFRESH R_MAKTX[].
  CLEAR R_MAKTX.

  IF ZEA_AUFK-AUFNR IS NOT INITIAL.
    R_AUFNR-SIGN    = 'I'.
    R_AUFNR-OPTION  = 'EQ'.
    R_AUFNR-LOW     = ZEA_AUFK-AUFNR.
    APPEND R_AUFNR.
  ENDIF.
  IF ZEA_AUFK-PLANID IS NOT INITIAL.
    R_PLANID-SIGN    = 'I'.
    R_PLANID-OPTION  = 'EQ'.
    R_PLANID-LOW     = ZEA_AUFK-PLANID.
    APPEND R_PLANID.
  ENDIF.
  IF ZEA_T001W-PNAME1 IS NOT INITIAL.
    R_PNAME1-SIGN    = 'I'.
    R_PNAME1-OPTION  = 'EQ'.
    R_PNAME1-LOW     = ZEA_T001W-PNAME1.
    APPEND R_PNAME1.
  ENDIF.
  IF ZEA_MMT020-MAKTX IS NOT INITIAL.
    R_MAKTX-SIGN    = 'I'.
    R_MAKTX-OPTION  = 'EQ'.
    R_MAKTX-LOW     = ZEA_MMT020-MAKTX.
    APPEND R_MAKTX.
  ENDIF.

  SELECT A~AUFNR
         A~WERKS
         C~PNAME1
         A~PLANID
         A~MATNR
         B~MAKTX
         A~TOT_QTY
         A~MEINS
         A~APPROVAL
         A~APPROVER
         A~REJREASON
  INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY
  FROM ZEA_AUFK AS A
  JOIN ZEA_MMT020 AS B
                  ON B~MATNR EQ A~MATNR
                 AND B~SPRAS EQ SY-LANGU
  JOIN ZEA_T001W AS C
                 ON C~WERKS EQ A~WERKS
  WHERE A~LOEKZ NE 'X'
    AND AUFNR IN R_AUFNR
    AND PLANID IN R_PLANID
    AND PNAME1 IN R_PNAME1
    AND MAKTX IN R_MAKTX.

  SORT GT_DISPLAY BY APPROVAL DESCENDING AUFNR ASCENDING.


*  PERFORM MODIFY_DISPLAY_DATA.

ENDFORM.
