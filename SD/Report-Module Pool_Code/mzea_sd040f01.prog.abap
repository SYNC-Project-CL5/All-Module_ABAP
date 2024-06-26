*&---------------------------------------------------------------------*
*& Include          MZEA_PP100F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form MAKE_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM MAKE_FIELDCAT_0100 .

  LOOP AT GT_FIELDCAT INTO GS_FIELDCAT.
*
    CASE ABAP_ON.
      WHEN GS_FIELDCAT-KEY.
        GS_FIELDCAT-EDIT = ABAP_OFF.
      WHEN OTHERS.
        GS_FIELDCAT-EDIT = ABAP_ON.
    ENDCASE.

    CASE GS_FIELDCAT-FIELDNAME.

      WHEN 'VBELN'.
        GS_FIELDCAT-HOTSPOT = ABAP_ON.
        GS_FIELDCAT-JUST      = 'C'.
        GS_FIELDCAT-KEY     = ABAP_ON.
*        GS_FIELDCAT-EDIT    = ABAP_On.
      WHEN 'CUSCODE'.
        GS_FIELDCAT-JUST      = 'C'.
        GS_FIELDCAT-HOTSPOT = ABAP_ON.
      WHEN 'BPCUS'.
        GS_FIELDCAT-JUST      = 'C'.
        GS_FIELDCAT-COLTEXT = '고객명'.
      WHEN 'TOAMT'.
        GS_FIELDCAT-EMPHASIZE = 'C310'.
      WHEN 'STATUS'.
        GS_FIELDCAT-COLTEXT = 'Status'.
        GS_FIELDCAT-ICON    = ABAP_ON.
        GS_FIELDCAT-KEY     = ABAP_OFF.
        GS_FIELDCAT-NO_OUT  = ABAP_ON.
      WHEN 'STATUS2'.
        GS_FIELDCAT-JUST      = 'C'.
        GS_FIELDCAT-NO_OUT  = ABAP_ON.
      WHEN 'STATUS3'.
        GS_FIELDCAT-JUST      = 'C'.
        GS_FIELDCAT-NO_OUT  = ABAP_ON.
      WHEN 'STATUS4'.
        GS_FIELDCAT-JUST      = 'C'.
        GS_FIELDCAT-NO_OUT  = ABAP_ON.
      WHEN 'STATUS_K'.
        GS_FIELDCAT-COLTEXT = '고객 여신 상태'.
        GS_FIELDCAT-JUST      = 'C'.
      WHEN 'LOEKZ'.
        GS_FIELDCAT-JUST      = 'C'.
        GS_FIELDCAT-NO_OUT  = ABAP_ON.
      WHEN 'COLOR'.
        GS_FIELDCAT-NO_OUT  = ABAP_ON.
      WHEN 'LIGHT'.
        GS_FIELDCAT-COLTEXT = '승인여부'.
      WHEN 'ERNAM'.
        GS_FIELDCAT-JUST      = 'C'.
        GS_FIELDCAT-EDIT = ABAP_OFF.
      WHEN 'ERDAT'.
        GS_FIELDCAT-JUST      = 'C'.
        GS_FIELDCAT-EDIT = ABAP_OFF.
      WHEN 'ERZET'.
        GS_FIELDCAT-JUST      = 'C'.
        GS_FIELDCAT-EDIT = ABAP_OFF.
      WHEN 'MARK'.
        GS_FIELDCAT-NO_OUT  = ABAP_ON.
      WHEN 'AENAM'.
        GS_FIELDCAT-NO_OUT  = ABAP_ON.
      WHEN 'AEDAT'.
        GS_FIELDCAT-NO_OUT  = ABAP_ON.
      WHEN 'AEZET'.
        GS_FIELDCAT-NO_OUT  = ABAP_ON.

    ENDCASE.

    MODIFY GT_FIELDCAT FROM GS_FIELDCAT.

  ENDLOOP.

  LOOP AT GT_FIELDCAT2 INTO GS_FIELDCAT2.
    CASE GS_FIELDCAT2-FIELDNAME.

      WHEN 'VBELN'.
        GS_FIELDCAT2-JUST      = 'C'.
      WHEN 'POSNR'.
        GS_FIELDCAT2-JUST      = 'C'.
      WHEN 'MATNR'.
        GS_FIELDCAT2-JUST      = 'C'.
      WHEN 'MEINS'.
        GS_FIELDCAT2-COLTEXT = '단위'.
      WHEN 'MAKTX'.
        GS_FIELDCAT2-COL_POS = 4.
      WHEN 'STATUS'.
        GS_FIELDCAT2-COLTEXT = '송장 생성 여부'.
*        GS_FIELDCAT2-ICON    = ABAP_ON.
        GS_FIELDCAT2-JUST      = 'C'.
        GS_FIELDCAT2-KEY     = ABAP_OFF.
*        GS_FIELDCAT-NO_OUT  = ABAP_ON.
      WHEN 'COLOR'.
        GS_FIELDCAT2-NO_OUT  = ABAP_ON.
      WHEN 'LIGHT'.
        GS_FIELDCAT2-NO_OUT  = ABAP_ON.
      WHEN 'MARK'.
        GS_FIELDCAT2-NO_OUT  = ABAP_ON.
      WHEN 'IT_FIELD_COLORS'.
        GS_FIELDCAT2-NO_OUT  = ABAP_ON.
      WHEN 'STYLE'.
        GS_FIELDCAT-NO_OUT  = ABAP_ON.
      WHEN 'AENAM'.
        GS_FIELDCAT2-NO_OUT  = ABAP_ON.
      WHEN 'AEDAT'.
        GS_FIELDCAT2-NO_OUT  = ABAP_ON.
      WHEN 'AEZET'.
        GS_FIELDCAT2-NO_OUT  = ABAP_ON.
      WHEN 'ERNAM'.
        GS_FIELDCAT2-NO_OUT  = ABAP_ON.
      WHEN 'ERDAT'.
        GS_FIELDCAT2-NO_OUT  = ABAP_ON.
      WHEN 'ERZET'.
        GS_FIELDCAT2-NO_OUT  = ABAP_ON.
      WHEN 'ID'.
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
  GS_LAYOUT-SEL_MODE   = 'B'.
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
  GV_SAVE = 'A'.
  GS_LAYOUT2-CWIDTH_OPT = 'A'.
  GS_LAYOUT2-ZEBRA      = ABAP_ON.
  GS_LAYOUT2-SEL_MODE   = 'B'.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_DATA
*&---------------------------------------------------------------------*
FORM SELECT_DATA .

  REFRESH GT_DATA.

  SELECT *
      FROM ZEA_SDT040 AS A
      JOIN ZEA_KNKK AS B
        ON B~CUSCODE EQ A~CUSCODE
      JOIN ZEA_KNA1 AS C
        ON C~CUSCODE EQ A~CUSCODE
    INTO CORRESPONDING FIELDS OF TABLE @GT_DATA.

  SORT GT_DATA BY VBELN.

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
    CASE GS_DISPLAY-STATUS2.
      WHEN ''.
        GS_DISPLAY-LIGHT = 2.
      WHEN 'X'.
        GS_DISPLAY-LIGHT = 3.
    ENDCASE.

    CASE GS_DISPLAY-LOEKZ.
      WHEN 'X'.
        GS_DISPLAY-LIGHT = 1.
    ENDCASE.

*--------------------------------------------------------------------*
    APPEND GS_DISPLAY TO GT_DISPLAY.

  ENDLOOP.

  SORT GT_DISPLAY BY LIGHT DESCENDING.

  DESCRIBE TABLE GT_DISPLAY LINES GV_LINES.

  IF GT_DISPLAY IS INITIAL.
    MESSAGE S013 DISPLAY LIKE 'W'.
  ELSE.
    MESSAGE S006 WITH GV_LINES.
  ENDIF.

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
      CONTAINER_NAME = 'CCON'
    EXCEPTIONS
      OTHERS         = 1.

  IF SY-SUBRC NE 0.
    MESSAGE E020. " Custom Container 생성 중 오류가 발생했습니다.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
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


*
*  CREATE OBJECT GO_ALV_GRID
*    EXPORTING
*      I_PARENT = GO_CONTAINER
*    EXCEPTIONS
*      OTHERS   = 1.
*
*  IF SY-SUBRC NE 0.
*    MESSAGE E021. " ALV Grid 생성 중 오류가 발생했습니다.
**   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_0100
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV_0100 .

  CLEAR GS_VARIANT.
  GS_VARIANT-REPORT = SY-REPID. " 현재 프로그램 이름을 전달
  GV_SAVE = 'A'. " 개인용/공용 모두 생성 가능하도록 설정

  CLEAR GS_VARIANT2.
  GS_VARIANT2-REPORT = SY-REPID. " 현재 프로그램 이름을 전달
  GV_SAVE2 = 'A'. " 개인용/공용 모두 생성 가능하도록 설정
  GS_VARIANT2-HANDLE = 'ALV2'.

  CALL METHOD GO_ALV_GRID_TOP->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
      I_STRUCTURE_NAME              = 'ZEA_SDT040'
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
    MESSAGE 'ALV에 데이터를 설정하는 과정 중 오류가 발생했습니다.' TYPE 'E'.
  ENDIF.

  CALL METHOD GO_ALV_GRID_BOT->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
      I_STRUCTURE_NAME = 'ZEA_SDT050'     " Internal Output Table Structure Name
      IS_VARIANT       = GS_VARIANT2  " Layout
      I_SAVE           = GV_SAVE2     " Save Layout
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

  CALL METHOD GO_ALV_GRID_TOP->SET_READY_FOR_INPUT
    EXPORTING
      I_READY_FOR_INPUT = 0.                " 처음 실행했을때 조회상태로 설정 ( 0으로 설정 )

  CALL METHOD GO_ALV_GRID_TOP->REGISTER_EDIT_EVENT
    EXPORTING
*     I_EVENT_ID = CL_GUI_ALV_GRID=>MC_EVT_MODIFIED " Event ID
      I_EVENT_ID = CL_GUI_ALV_GRID=>MC_EVT_ENTER   " ENTER 눌렀을때 작용하도록 설정.
    EXCEPTIONS
      ERROR      = 1                " Error
      OTHERS     = 2.

  SET HANDLER LCL_EVENT_HANDLER=>ON_TOOLBAR FOR GO_ALV_GRID_TOP.
  SET HANDLER LCL_EVENT_HANDLER=>ON_DOUBLE_CLICK FOR GO_ALV_GRID_TOP.
  SET HANDLER LCL_EVENT_HANDLER=>ON_USER_COMMAND FOR GO_ALV_GRID_TOP.
  SET HANDLER LCL_EVENT_HANDLER=>ON_HOTSPOT_CLICK FOR GO_ALV_GRID_TOP.
  SET HANDLER LCL_EVENT_HANDLER=>ON_BUTTON_CLICK FOR GO_ALV_GRID_TOP.
  SET HANDLER LCL_EVENT_HANDLER=>ON_DATA_CHANGED FOR GO_ALV_GRID_TOP.

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
  DATA: LT_FIELDCAT2 TYPE KKBLO_T_FIELDCAT.

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

  REFRESH GT_FIELDCAT2.

  CALL FUNCTION 'K_KKB_FIELDCAT_MERGE'
    EXPORTING
      I_CALLBACK_PROGRAM     = SY-REPID
      I_TABNAME              = 'GS_DISPLAY2'
*     I_STRUCNAME            =
      I_INCLNAME             = SY-REPID
      I_BYPASSING_BUFFER     = ABAP_ON
      I_BUFFER_ACTIVE        = ABAP_OFF
    CHANGING
      CT_FIELDCAT            = LT_FIELDCAT2
    EXCEPTIONS
      INCONSISTENT_INTERFACE = 1
      OTHERS                 = 2.

  IF SY-SUBRC EQ 0.
    CALL FUNCTION 'LVC_TRANSFER_FROM_KKBLO'
      EXPORTING
        IT_FIELDCAT_KKBLO = LT_FIELDCAT2 " KKBLO
      IMPORTING
        ET_FIELDCAT_LVC   = GT_FIELDCAT2 " LVC
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

* 버튼 추가 =>> 승인
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

* 버튼 추가 =>> 삭제
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-FUNCTION = GC_REJECT.
      LS_TOOLBAR-ICON = ICON_LED_RED.
      LS_TOOLBAR-TEXT = | 반려 : { LV_RED }  |.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

    WHEN GO_ALV_GRID_BOT.
  ENDCASE.

** 구분자 =>> |
*  CLEAR LS_TOOLBAR.
*  LS_TOOLBAR-BUTN_TYPE = 3. " 구분자
*  APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.
*
** 버튼 추가 =>> 예약취소
*  CLEAR LS_TOOLBAR.
*  LS_TOOLBAR-BUTN_TYPE = 0. " 버튼
*  LS_TOOLBAR-FUNCTION = GC_BOOKING_CANCEL.
*  LS_TOOLBAR-TEXT = '예약취소'.
*  APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.
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

      ENDCASE.

  ENDCASE.
*  CASE PO_SENDER.
*    WHEN GO_ALV_GRID_TOP. "PO_SENDER 가 GO_ALV_GRID 일 때
*      CASE PV_UCOMM.  " 선택한 버튼 (PV_UCOMM은 SY-UCOMM 타입)

*       WHEN GC_BOOKING_CANCEL.
*          " 예약 취소
*          PERFORM BOOKING_CANCEL USING PO_SENDER.

*      ENDCASE.


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

  READ TABLE GT_DISPLAY INTO GS_DISPLAY INDEX PS_ROW_ID-INDEX.


  CASE PO_SENDER.
    WHEN GO_ALV_GRID_TOP.
      CASE PS_COLUMN_ID-FIELDNAME.
        WHEN 'VBELN'.

          LOOP AT GT_DISPLAY INTO GS_DISPLAY.
            GS_DISPLAY-COLOR = SPACE.
            MODIFY GT_DISPLAY FROM GS_DISPLAY TRANSPORTING COLOR.
          ENDLOOP.

          READ TABLE GT_DISPLAY INTO GS_DISPLAY INDEX PS_ROW_ID-INDEX.


          SELECT *
            FROM ZEA_SDT050 AS A
            JOIN ZEA_MMT020 AS C     " 자재 TEXT
              ON C~MATNR EQ A~MATNR
             AND SPRAS EQ SY-LANGU
            INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY2
*            JOIN ZEA_SDT040 AS B
*              ON B~VBELN EQ A~VBELN
            WHERE A~VBELN EQ GS_DISPLAY-VBELN.

*          SORT GT_DISPLAY2 BY VBELN.  " 이거 쓰면 맨 밑 판매오더번호 내용만 핫스팟으로 뜸;;

          PERFORM REFRESH_ALV_0100.

        WHEN 'CUSCODE'.
          READ TABLE GT_DISPLAY INTO GS_DISPLAY INDEX PS_ROW_ID-INDEX.

          IF PS_ROW_ID-ROWTYPE IS INITIAL.

            " ZEA_SD160 프로그램에서 1000번 스크린 뛰어넘고 출력.
            SUBMIT ZEA_SD160 WITH PA_CUS = GS_DISPLAY-CUSCODE AND RETURN.

*            SET PARAMETER ID 'ZEA_KNKK' FIELD GS_DISPLAY-CUSCODE.
*            CALL TRANSACTION 'ZEASD160'.
          ENDIF.
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
FORM HANDLE_BUTTON_CLICK USING PS_ROW_NO
                                   PS_COL_ID
                                   PO_SENDER.


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
* 추가------------------------------------------------
  DATA: LS_LVC_MODI TYPE LVC_S_MODI,
        LS_STABLE   TYPE LVC_S_STBL.
  DATA: LV_ERROR.
*-----------------------------------------------------
  DATA(LT_MOD) = PR_DATA_CHANGED->MT_MOD_CELLS[].

  IF LT_MOD[] IS NOT INITIAL.
    GV_CHANGED = ABAP_ON.
  ENDIF.


* 추가------------------------------------------------
  LOOP AT PR_DATA_CHANGED->MT_GOOD_CELLS INTO LS_LVC_MODI.
    CHECK LS_LVC_MODI-VALUE IS NOT INITIAL.
    READ TABLE GT_DISPLAY INTO DATA(LS_ITAB) INDEX LS_LVC_MODI-ROW_ID.
    CHECK SY-SUBRC = 0.

    CASE LS_LVC_MODI-FIELDNAME. "입력시 점검


      WHEN 'TOAMT'.

    ENDCASE.

  ENDLOOP.


  CALL METHOD CL_GUI_CFW=>SET_NEW_OK_CODE
    EXPORTING
      NEW_CODE = 'DYNP'.

*-----------------------------------------------------
ENDFORM.
*&---------------------------------------------------------------------*
*& Form EDIT_MODE
*&---------------------------------------------------------------------*
FORM EDIT_MODE .

  DATA LV_CHECK TYPE I.

  LV_CHECK = GO_ALV_GRID_TOP->IS_READY_FOR_INPUT( ).

  IF LV_CHECK EQ 0.
    LV_CHECK = 1.
  ELSE.
    LV_CHECK = 0.
  ENDIF.

  CALL METHOD GO_ALV_GRID_TOP->SET_READY_FOR_INPUT
    EXPORTING
      I_READY_FOR_INPUT = LV_CHECK. " Ready for Input Status

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DATA_DELETE
*&---------------------------------------------------------------------*
FORM DATA_DELETE .

  DATA LT_INDEX_ROWS TYPE LVC_T_ROW.
  DATA LS_INDEX_ROW LIKE LINE OF LT_INDEX_ROWS.

  CALL METHOD GO_ALV_GRID_TOP->GET_SELECTED_ROWS
    IMPORTING
      ET_INDEX_ROWS = LT_INDEX_ROWS     " Indexes of Selected Rows
*     ET_ROW_NO     =                  " Numeric IDs of Selected Rows
    .

  IF LT_INDEX_ROWS[] IS INITIAL.
    " TEXT-M01: 라인을 선택하세요.
    MESSAGE S000 DISPLAY LIKE 'W' WITH '최소 한 행이상 선택하세요'.

  ELSE.
    READ TABLE LT_INDEX_ROWS INTO LS_INDEX_ROW-INDEX INDEX 1.

    READ TABLE GT_DISPLAY INTO GS_DISPLAY INDEX LS_INDEX_ROW-INDEX.

    IF GS_DISPLAY-LIGHT = 3.
      MESSAGE S000 DISPLAY LIKE 'W' WITH '이미 승인된 판매 오더 입니다.'.

    ELSEIF GS_DISPLAY-LIGHT = 1.
       MESSAGE S000 DISPLAY LIKE 'W' WITH '이미 반려된 판매 오더 입니다.'.

    ELSE.

       _MC_POPUP_CONFIRM 'DELETE' '정말 반려하시겠습니까?' GV_ANSWER.
      CHECK GV_ANSWER = '1'.

    DATA LV_SUBRC TYPE I.
    DATA LV_COUNT TYPE I.

    LOOP AT LT_INDEX_ROWS INTO LS_INDEX_ROW WHERE ROWTYPE IS INITIAL.

      READ TABLE GT_DISPLAY INTO GS_DISPLAY INDEX LS_INDEX_ROW-INDEX.

      IF SY-SUBRC EQ 0.

*        " DATABASE TABLE 의 RECORD 삭제
*        DELETE FROM ZEA_SDT040
*          WHERE VBELN EQ GS_DISPLAY-VBELN.

        UPDATE ZEA_SDT040 SET LOEKZ = 'X'
                              AENAM  = SY-UNAME
                              AEDAT  = SY-DATUM
                              AEZET  = SY-UZEIT
                        WHERE VBELN EQ GS_DISPLAY-VBELN.

        IF SY-SUBRC EQ 0.
          LV_COUNT += 1.
        ENDIF.

*         ITAB 변경로직
*        DELETE GT_DISPLAY INDEX LS_INDEX_ROW-INDEX.

        LOOP AT LT_INDEX_ROWS INTO LS_INDEX_ROW.
          READ TABLE GT_DISPLAY INTO GS_DISPLAY INDEX LS_INDEX_ROW-INDEX.
          GS_DISPLAY-LOEKZ = 'X'.
          GS_DISPLAY-LIGHT = 1.
          MODIFY GT_DISPLAY FROM GS_DISPLAY
          INDEX LS_INDEX_ROW TRANSPORTING LOEKZ LIGHT.
        ENDLOOP.
        "실행된 결과를 LV_SUBRC에 누적합산
        ADD SY-SUBRC TO LV_SUBRC.

      ENDIF.

    ENDLOOP.

    IF LV_SUBRC EQ 0.
      "변경사항에 대한 확정처리
      COMMIT WORK AND WAIT.
      MESSAGE S000 WITH LV_COUNT '건의 데이터가 취소되었습니다.'.

      PERFORM REFRESH_ALV_0100.
    ELSE.
      " 변경사항에 대한 원복처리
      ROLLBACK WORK.
      MESSAGE S000 DISPLAY LIKE 'W' WITH '데이터 취소를 실패하였습니다.'.
    ENDIF.

  ENDIF.
ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form APPROVE_DATA
*&---------------------------------------------------------------------*
FORM APPROVE_DATA .

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
    MESSAGE S000 DISPLAY LIKE 'W' WITH '한 행을 선택하세요'.
  ELSE.

    READ TABLE LT_INDEX_ROWS INTO LS_INDEX_ROW-INDEX INDEX 1.

    READ TABLE GT_DISPLAY INTO GS_DISPLAY INDEX LS_INDEX_ROW-INDEX.

    IF GS_DISPLAY-LIGHT = 3.
      MESSAGE S000 DISPLAY LIKE 'W' WITH '이미 승인된 판매 오더 입니다.'.

    ELSEIF GS_DISPLAY-LIGHT = 1.
       MESSAGE S000 DISPLAY LIKE 'W' WITH '이미 반려된 판매 오더 입니다.'.

    ELSE.

      IF GS_DISPLAY-STATUS_K EQ 'R'.
        MESSAGE I000 DISPLAY LIKE 'W'
                     WITH '고객의 여신 잔액이 5% 미만 이므로 승인이 불가 합니다'.

      ELSEIF GS_DISPLAY-STATUS_K EQ 'Y'.
        _MC_POPUP_CONFIRM '승인'
        '고객의 여신 잔액이 30% 미만 입니다. 승인하시겠습니까?' GV_ANSWER.
        CHECK GV_ANSWER = '1'.

        PERFORM APPROVE_CHECK_DATA.

      ELSEIF GS_DISPLAY-STATUS_K EQ 'G'.

        _MC_POPUP_CONFIRM '승인' '선택한 결재건을 승인하시겠습니까?' GV_ANSWER.
        CHECK GV_ANSWER = '1'.

        PERFORM APPROVE_CHECK_DATA.

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
*& Form APPROVE_FILTER
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
*& Form WAIT_FILTER
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
*& Form REJECT_FILTER
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
*& Form DATA_SAVE
*&---------------------------------------------------------------------*
FORM DATA_SAVE .

  DATA: LS_SDT040 TYPE ZEA_SDT040,
        LT_SDT040 TYPE TABLE OF ZEA_SDT040.

  MOVE-CORRESPONDING GT_DISPLAY TO LT_SDT040.

  LOOP AT LT_SDT040 INTO LS_SDT040.
    IF LS_SDT040-VBELN IS INITIAL.
      MESSAGE E000 WITH 'CHECK KEY FIELD.'.
    ENDIF.
  ENDLOOP.

  MODIFY ZEA_SDT040 FROM TABLE LT_SDT040.

  IF SY-SUBRC EQ 0.
    COMMIT WORK AND WAIT.
    MESSAGE S015.
  ELSE.
    ROLLBACK WORK.
    MESSAGE S016 DISPLAY LIKE 'E'.
  ENDIF.

* db - 화면 동기화   --> 화면 REFRESH 해준다는 느낌
  PERFORM SELECT_DATA.
  PERFORM MAKE_DISPLAY_DATA.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form APPROVE_CHECK_DATA
*&---------------------------------------------------------------------*
FORM APPROVE_CHECK_DATA .

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
      AND LV_CHECK IS INITIAL.
        UPDATE ZEA_SDT040 SET STATUS2 = 'X'
                              AEDAT    = SY-DATUM
                              AEZET    = SY-UZEIT
                              AENAM    = SY-UNAME
                        WHERE VBELN EQ GS_DISPLAY-VBELN.
        ADD SY-SUBRC TO LV_SUBRC.

        IF LV_SUBRC EQ 0.
          LV_COUNT += 1.
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
        GS_DISPLAY-STATUS2 = 'X'.
        MODIFY GT_DISPLAY FROM GS_DISPLAY
        INDEX LS_INDEX_ROW-INDEX TRANSPORTING STATUS2 LIGHT.
      ENDLOOP.


      PERFORM REFRESH_ALV_0100.
    ELSE.
      " 변경사항에 대한 원복처리
      ROLLBACK WORK.
      MESSAGE S000 DISPLAY LIKE 'W' WITH '정상적인 결재를 진행해주세요.'.
    ENDIF.
  ENDIF.


ENDFORM.
