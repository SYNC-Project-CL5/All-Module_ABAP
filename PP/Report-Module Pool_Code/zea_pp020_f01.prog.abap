*&---------------------------------------------------------------------*
*& Include          ZALV_GRID_DISPLAY_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form MAKE_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM MAKE_FIELDCAT_0100 .

  LOOP AT GT_FIELDCAT INTO GS_FIELDCAT.

    CASE ABAP_ON.
      WHEN GS_FIELDCAT-KEY.
        GS_FIELDCAT-EDIT = ABAP_OFF.
      WHEN OTHERS.
        GS_FIELDCAT-EDIT = ABAP_ON.
    ENDCASE.

    CASE GS_FIELDCAT-FIELDNAME.
      WHEN 'BOMID'.
        GS_FIELDCAT-KEY = ABAP_ON.
        GS_FIELDCAT-EDIT = ABAP_OFF.
      WHEN 'PNAME1'.
        GS_FIELDCAT-EDIT = ABAP_OFF.
      WHEN 'MATNR'.
*        GS_FIELDCAT-JUST      = 'C'.
        GS_FIELDCAT-OUTPUTLEN = 10.
        GS_FIELDCAT-F4AVAILABL = ABAP_ON.
      WHEN 'MAKTX'.
        GS_FIELDCAT-OUTPUTLEN = 25.
        GS_FIELDCAT-EDIT      = ABAP_OFF.
      WHEN 'MATTYPE'.
        GS_FIELDCAT-OUTPUTLEN = 10.
        GS_FIELDCAT-EDIT      = ABAP_OFF.
      WHEN 'MENGE'.
        GS_FIELDCAT-OUTPUTLEN = 10.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
      WHEN 'MEINS'.
        GS_FIELDCAT-COLTEXT   = '단위'.
        GS_FIELDCAT-JUST      = 'L'.
        GS_FIELDCAT-OUTPUTLEN = 5.
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
        GS_FIELDCAT-NO_OUT  = ABAP_ON.
      WHEN 'MARK'.
        GS_FIELDCAT-NO_OUT  = ABAP_ON.
    ENDCASE.




    MODIFY GT_FIELDCAT FROM GS_FIELDCAT.

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
  GS_VARIANT-HANDLE = '1'.
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
  GS_LAYOUT-INFO_FNAME = 'COLOR'.           " 행 색상
*  GS_LAYOUT-EXCP_FNAME = 'LIGHT'.           " 신호등
*  GS_LAYOUT-EXCP_LED = ABAP_ON.             " 신호등 모양 변경
  GS_LAYOUT-CTAB_FNAME = 'IT_FIELD_COLORS'. " 셀 별 색상
*  GS_LAYOUT-STYLEFNAME  = 'STYLE'.          " 스타일
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_DATA
*&---------------------------------------------------------------------*
FORM SELECT_DATA .

  REFRESH GT_DATA.

  SELECT *
  INTO CORRESPONDING FIELDS OF TABLE @GT_DATA
  FROM ZEA_STKO AS A  JOIN ZEA_T001W  AS B ON B~WERKS EQ A~WERKS
                      JOIN ZEA_MMT020 AS C ON C~MATNR EQ A~MATNR
                                      AND C~SPRAS EQ @SY-LANGU
                      JOIN ZEA_MMT010 AS D ON D~MATNR EQ A~MATNR.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM MAKE_DISPLAY_DATA .

  REFRESH GT_DISPLAY.
  REFRESH GT_DISPLAY2.

  LOOP AT GT_DATA INTO GS_DATA.

    CLEAR GS_DISPLAY.

    MOVE-CORRESPONDING GS_DATA TO GS_DISPLAY.

*신규 필드------------------------------------------------------------*

    CASE GS_DISPLAY-MATTYPE.
      WHEN '반제품'.
        CLEAR GS_FIELD_COLOR.
        GS_FIELD_COLOR-FNAME = 'MATTYPE'.
        GS_FIELD_COLOR-COLOR-COL = 5. " 초록
        GS_FIELD_COLOR-COLOR-INT = 0.
        GS_FIELD_COLOR-COLOR-INV = 0.
        APPEND GS_FIELD_COLOR TO GS_DISPLAY-IT_FIELD_COLORS.
      WHEN '완제품'.
        CLEAR GS_FIELD_COLOR.
        GS_FIELD_COLOR-FNAME = 'MATTYPE'.
        GS_FIELD_COLOR-COLOR-COL = 1. " 파랑
        GS_FIELD_COLOR-COLOR-INT = 1.
        GS_FIELD_COLOR-COLOR-INV = 0.
        APPEND GS_FIELD_COLOR TO GS_DISPLAY-IT_FIELD_COLORS.
    ENDCASE.


*--------------------------------------------------------------------*
    APPEND GS_DISPLAY TO GT_DISPLAY.

  ENDLOOP.

  LOOP AT GT_DATA2 INTO GS_DATA2.

    CLEAR GS_DISPLAY2.

    MOVE-CORRESPONDING GS_DATA2 TO GS_DISPLAY2.

*신규 필드------------------------------------------------------------*

*    CASE GS_DISPLAY2-MATTYPE.
*      WHEN '원자재'.
*        CLEAR GS_FIELD_COLOR.
*        GS_FIELD_COLOR-FNAME = 'MATTYPE'.
*        GS_FIELD_COLOR-COLOR-COL = 3. " 노랑
*        GS_FIELD_COLOR-COLOR-INT = 0.
*        GS_FIELD_COLOR-COLOR-INV = 0.
*        APPEND GS_FIELD_COLOR TO GS_DISPLAY2-IT_FIELD_COLORS.
*      WHEN '반제품'.
*        CLEAR GS_FIELD_COLOR.
*        GS_FIELD_COLOR-FNAME = 'MATTYPE'.
*        GS_FIELD_COLOR-COLOR-COL = 5. " 초록
*        GS_FIELD_COLOR-COLOR-INT = 0.
*        GS_FIELD_COLOR-COLOR-INV = 0.
*        APPEND GS_FIELD_COLOR TO GS_DISPLAY2-IT_FIELD_COLORS.
*    ENDCASE.

*--------------------------------------------------------------------*
    APPEND GS_DISPLAY2 TO GT_DISPLAY2.

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

  CHECK SY-UNAME EQ 'ACA5-03'
     OR SY-UNAME EQ 'ACA5-07'
     OR SY-UNAME EQ 'ACA5-08'
     OR SY-UNAME EQ 'ACA5-10'
     OR SY-UNAME EQ 'ACA5-12'
     OR SY-UNAME EQ 'ACA5-15'
     OR SY-UNAME EQ 'ACA5-17'
     OR SY-UNAME EQ 'ACA5-23'
     OR SY-UNAME EQ 'ACA-05'.

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



  CREATE OBJECT GO_CONTAINER_1
    EXPORTING
      CONTAINER_NAME = 'CCON'
    EXCEPTIONS
      OTHERS         = 1.

  IF SY-SUBRC NE 0.
    MESSAGE E020. " Custom Container 생성 중 오류가 발생했습니다.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.


  CREATE OBJECT GO_ALV_GRID_1
    EXPORTING
      I_PARENT = GO_CONTAINER_1
    EXCEPTIONS
      OTHERS   = 1.

  IF SY-SUBRC NE 0.
    MESSAGE E021. " ALV Grid 생성 중 오류가 발생했습니다.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_0100
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV_0100 .

  CALL METHOD GO_ALV_GRID_1->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
*     I_STRUCTURE_NAME              = 'ZEA_STKO'
      IS_VARIANT                    = GS_VARIANT
      I_SAVE                        = GV_SAVE
      IS_LAYOUT                     = GS_LAYOUT
      IT_TOOLBAR_EXCLUDING          = GT_TOOLBAR
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
    " ALV Grid 에 데이터를 전달하는 중 오류가 발생했습니다.
    MESSAGE E023.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_FIELDCAT_0100 .

  PERFORM GET_FIELDCAT_0100   USING    GT_DISPLAY
                              CHANGING GT_FIELDCAT.

  PERFORM MAKE_FIELDCAT_0100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_EVENT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_EVENT_0100 .

* 서치헬프를 적용할 필드를 지정해준다.

  GS_F4-FIELDNAME = 'MATNR'.
  GS_F4-REGISTER = 'X'.

  INSERT GS_F4 INTO TABLE GT_F4.

  CALL METHOD GO_ALV_GRID_1->REGISTER_F4_FOR_FIELDS
    EXPORTING
      IT_F4 = GT_F4.

  CALL METHOD GO_ALV_GRID_1->SET_READY_FOR_INPUT
    EXPORTING
      I_READY_FOR_INPUT = 0.                " Ready for Input Status

  CALL METHOD GO_ALV_GRID_1->REGISTER_EDIT_EVENT
    EXPORTING
      I_EVENT_ID = CL_GUI_ALV_GRID=>MC_EVT_MODIFIED " Event ID
    EXCEPTIONS
      ERROR      = 1                " Error
      OTHERS     = 2.

  SET HANDLER LCL_EVENT_HANDLER=>ON_TOOLBAR FOR GO_ALV_GRID_1.
  SET HANDLER LCL_EVENT_HANDLER=>ON_DOUBLE_CLICK FOR GO_ALV_GRID_1.
  SET HANDLER LCL_EVENT_HANDLER=>ON_USER_COMMAND FOR GO_ALV_GRID_1.
  SET HANDLER LCL_EVENT_HANDLER=>ON_HOTSPOT_CLICK FOR GO_ALV_GRID_1.
  SET HANDLER LCL_EVENT_HANDLER=>ON_BUTTON_CLICK FOR GO_ALV_GRID_1.
  SET HANDLER LCL_EVENT_HANDLER=>ON_ONF4 FOR GO_ALV_GRID_1.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH_ALV_0100
*&---------------------------------------------------------------------*
FORM REFRESH_ALV_0100 .

  DATA LS_STABLE TYPE LVC_S_STBL.
  LS_STABLE-ROW = ABAP_ON.
  LS_STABLE-COL = ABAP_ON.

  CALL METHOD GO_ALV_GRID_1->REFRESH_TABLE_DISPLAY
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
FORM GET_FIELDCAT_0100_KKB.

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
FORM GET_FIELDCAT_0100 USING PT_TAB TYPE STANDARD TABLE
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
  CALL METHOD GO_ALV_GRID_1->SET_FILTER_CRITERIA
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
  CALL METHOD GO_ALV_GRID_1->REFRESH_TABLE_DISPLAY
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

  DATA : LV_FIN_SEMI TYPE I,
         LV_SEMI_RAW TYPE I,
         LV_FIN      TYPE I,
         LV_SEMI     TYPE I,
         LV_RAW      TYPE I.

  CASE PO_SENDER.
    WHEN GO_ALV_GRID_1.
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
            ADD 1 TO LV_FIN_SEMI.
            ADD 1 TO LV_FIN.
          WHEN '반제품'.
            ADD 1 TO LV_FIN_SEMI.
            ADD 1 TO LV_SEMI.
        ENDCASE.
      ENDLOOP.

* 구분자 =>> |
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 3. " 구분자
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 완제품/반제품
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 0. " 완제품/반제품
      LS_TOOLBAR-FUNCTION = GC_FIN_SEMI_MATERIALS.
      LS_TOOLBAR-TEXT = TEXT-L09 && ':' && LV_FIN_SEMI.
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



    WHEN GO_ALV_GRID_2.
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

* 구분자 =>> |
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 3. " 구분자
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

      LOOP AT  GT_DISPLAY2 INTO GS_DISPLAY2.

        CASE GS_DISPLAY2-MATTYPE.
          WHEN '반제품'.
            ADD 1 TO LV_SEMI_RAW.
            ADD 1 TO LV_SEMI.
          WHEN '원자재'.
            ADD 1 TO LV_SEMI_RAW.
            ADD 1 TO LV_RAW.
        ENDCASE.
      ENDLOOP.

* 버튼 추가 =>> 반제품/완제품
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 0. " 반제품/원자재
      LS_TOOLBAR-FUNCTION = GC_SEMI_RAW_MATERIALS.
      LS_TOOLBAR-TEXT = TEXT-L06 && ':' && LV_SEMI_RAW.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 반제품
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 0. " 반제품
      LS_TOOLBAR-FUNCTION = GC_SEMI_MATERIALS.
      LS_TOOLBAR-ICON = ICON_LED_GREEN.
      LS_TOOLBAR-TEXT = TEXT-L07 && ':' && LV_SEMI.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 반제품
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 0. " 원자재
      LS_TOOLBAR-FUNCTION = GC_RAW_MATERIALS.
      LS_TOOLBAR-ICON = ICON_LED_YELLOW.
      LS_TOOLBAR-TEXT = TEXT-L08 && ':' && LV_RAW.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

  ENDCASE.


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
    WHEN GO_ALV_GRID_1. "PO_SENDER 가 GO_ALV_GRID 일 때
      CASE PV_UCOMM.  " 선택한 버튼 (PV_UCOMM은 SY-UCOMM 타입)
        WHEN GC_CHANGE.
          PERFORM EDIT_MODE USING PO_SENDER.

        WHEN GC_DELETE.
          PERFORM DATA_DELETE USING PO_SENDER.

        WHEN GC_FIN_SEMI_MATERIALS.
          PERFORM FIN_SEMI_FILTER.
          PERFORM SET_ALV_FILTER.

        WHEN GC_FINISHED_MATERIALS.
          PERFORM FIN_FILTER.
          PERFORM SET_ALV_FILTER.

        WHEN GC_SEMI_MATERIALS.
          PERFORM SEMI_FILTER.
          PERFORM SET_ALV_FILTER.

      ENDCASE.

    WHEN GO_ALV_GRID_2.
      CASE PV_UCOMM.
        WHEN GC_CHANGE.
          PERFORM EDIT_MODE USING PO_SENDER.

        WHEN GC_DELETE.
          PERFORM DATA_DELETE USING PO_SENDER.

        WHEN GC_SEMI_RAW_MATERIALS.
          PERFORM SEMI_RAW_FILTER.
          PERFORM SET_ALV_FILTER2.

        WHEN GC_SEMI_MATERIALS.
          PERFORM SEMI_FILTER.
          PERFORM SET_ALV_FILTER2.

        WHEN GC_RAW_MATERIALS.
          PERFORM RAW_FILTER.
          PERFORM SET_ALV_FILTER2.
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

  CASE PO_SENDER.
    WHEN GO_ALV_GRID_1.

      LOOP AT GT_DISPLAY INTO GS_DISPLAY.
        GS_DISPLAY-COLOR = SPACE.
        MODIFY GT_DISPLAY FROM GS_DISPLAY TRANSPORTING COLOR.
      ENDLOOP.

      READ TABLE GT_DISPLAY INTO GS_DISPLAY INDEX PS_ROW-INDEX.

      SELECT  *
        FROM ZEA_STPO AS A
        INNER JOIN ZEA_MMT020 AS B
        ON A~MATNR EQ B~MATNR
        AND SPRAS  EQ SY-LANGU
        INNER JOIN ZEA_MMT010 AS C
        ON C~MATNR EQ B~MATNR
        INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY2
        WHERE A~BOMID EQ GS_DISPLAY-BOMID
          AND A~LOEKZ NE ABAP_ON.

      SORT GT_DISPLAY2 BY BOMINDEX.

      MOVE-CORRESPONDING GT_DISPLAY2 TO GT_DATA2. " SAVE 버튼 로직에서 사용

      GS_DISPLAY-COLOR = 'C310'.
      MODIFY GT_DISPLAY FROM GS_DISPLAY INDEX PS_ROW-INDEX
      TRANSPORTING COLOR.

      DESCRIBE TABLE GT_DISPLAY2 LINES GV_LINES.

      IF GT_DISPLAY2 IS INITIAL.
        MESSAGE S013 DISPLAY LIKE 'W'.
      ELSE.
        MESSAGE S006 WITH GV_LINES.
      ENDIF.

*      PERFORM REFRESH_ALV_DETAIL_0100.
      CALL METHOD CL_GUI_CFW=>SET_NEW_OK_CODE
        EXPORTING
          NEW_CODE = 'ENTER'.                 " New OK_CODE

    WHEN GO_ALV_GRID_2.
    WHEN OTHERS.



  ENDCASE.




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

  DATA: LS_MOD_CELLS TYPE LVC_S_MODI,
        LS_INS_CELLS TYPE LVC_S_MOCE,
        LS_PROTOCOL  TYPE LVC_S_MSG1,
        LS_CELLS     TYPE LVC_S_MODI,
        LS_VALUE     TYPE LVC_VALUE.

  DATA(LT_MOD) = PR_DATA_CHANGED->MT_MOD_CELLS[].

  LOOP AT LT_MOD INTO LS_MOD_CELLS.
    CASE LS_MOD_CELLS-FIELDNAME.
      WHEN 'MENGE'.
        GV_CHANGED = ABAP_ON.
    ENDCASE.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_DETAIL_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT_DETAIL_0100 .

  CREATE OBJECT GO_CONTAINER_2
    EXPORTING
      CONTAINER_NAME = 'CCON2'
    EXCEPTIONS
      OTHERS         = 1.

  IF SY-SUBRC NE 0.
    MESSAGE E020. " Custom Container 생성 중 오류가 발생했습니다.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  CREATE OBJECT GO_ALV_GRID_2
    EXPORTING
      I_PARENT = GO_CONTAINER_2
    EXCEPTIONS
      OTHERS   = 1.

  IF SY-SUBRC NE 0.
    MESSAGE E021. " ALV Grid 생성 중 오류가 발생했습니다.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FIELDCAT_DETAIL_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_ALV_FIELDCAT_DETAIL_0100 .

  PERFORM GET_FIELDCAT_0100     USING    GT_DISPLAY2
                                CHANGING GT_FIELDCAT.
*  PERFORM GET_FIELDCAT2   USING    GT_DISPLAY2
*                          CHANGING GT_FIELDCAT.
  PERFORM MAKE_FIELDCAT_DETAIL_0100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_LAYOUT_DETAIL_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_ALV_LAYOUT_DETAIL_0100 .

  CLEAR GS_LAYOUT.
  CLEAR GS_VARIANT.
  CLEAR GV_SAVE.

  GS_VARIANT-REPORT = SY-REPID.
  GS_VARIANT-HANDLE = '2'.
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
*  GS_LAYOUT-EXCP_FNAME = 'LIGHT'.           " 신호등
*  GS_LAYOUT-EXCP_LED = ABAP_ON.             " 신호등 모양 변경
  GS_LAYOUT-CTAB_FNAME = 'IT_FIELD_COLORS'. " 셀 별 색상
*  GS_LAYOUT-STYLEFNAME  = 'STYLE'.          " 스타일


ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_EVENT_DETAIL_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_ALV_EVENT_DETAIL_0100 .

* 서치헬프를 적용할 필드를 지정해준다.

  GS_F4-FIELDNAME = 'MATNR'.
  GS_F4-REGISTER = 'X'.

  INSERT GS_F4 INTO TABLE GT_F4.

  CALL METHOD GO_ALV_GRID_2->REGISTER_F4_FOR_FIELDS
    EXPORTING
      IT_F4 = GT_F4.

  CALL METHOD GO_ALV_GRID_2->SET_READY_FOR_INPUT
    EXPORTING
      I_READY_FOR_INPUT = 0.                " Ready for Input Status

  CALL METHOD GO_ALV_GRID_2->REGISTER_EDIT_EVENT
    EXPORTING
      I_EVENT_ID = CL_GUI_ALV_GRID=>MC_EVT_MODIFIED " Event ID
    EXCEPTIONS
      ERROR      = 1                " Error
      OTHERS     = 2.

  SET HANDLER LCL_EVENT_HANDLER=>ON_TOOLBAR FOR GO_ALV_GRID_2.
  SET HANDLER LCL_EVENT_HANDLER=>ON_DOUBLE_CLICK FOR GO_ALV_GRID_2.
  SET HANDLER LCL_EVENT_HANDLER=>ON_USER_COMMAND FOR GO_ALV_GRID_2.
  SET HANDLER LCL_EVENT_HANDLER=>ON_HOTSPOT_CLICK FOR GO_ALV_GRID_2.
  SET HANDLER LCL_EVENT_HANDLER=>ON_BUTTON_CLICK FOR GO_ALV_GRID_2.
  SET HANDLER LCL_EVENT_HANDLER=>ON_DATA_CHANGED FOR GO_ALV_GRID_2.
  SET HANDLER LCL_EVENT_HANDLER=>ON_DATA_CHANGED_FINISHED FOR GO_ALV_GRID_2.
  SET HANDLER LCL_EVENT_HANDLER=>ON_ONF4 FOR GO_ALV_GRID_2.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_DETAIL_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV_DETAIL_0100 .

  CALL METHOD GO_ALV_GRID_2->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
*     I_STRUCTURE_NAME              = 'ZEA_STPO'
      IS_VARIANT                    = GS_VARIANT
      I_SAVE                        = GV_SAVE
      IS_LAYOUT                     = GS_LAYOUT
      IT_TOOLBAR_EXCLUDING          = GT_TOOLBAR
    CHANGING
      IT_OUTTAB                     = GT_DISPLAY2
      IT_FIELDCATALOG               = GT_FIELDCAT
*     IT_SORT                       =
*     IT_FILTER                     =
    EXCEPTIONS
      INVALID_PARAMETER_COMBINATION = 1
      PROGRAM_ERROR                 = 2
      TOO_MANY_LINES                = 3
      OTHERS                        = 4.

  IF SY-SUBRC <> 0.
    " ALV Grid 에 데이터를 전달하는 중 오류가 발생했습니다.
    MESSAGE E023.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH_ALV_DETAIL_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM REFRESH_ALV_DETAIL_0100 .

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

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_FIELDCAT_DETAIL_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM MAKE_FIELDCAT_DETAIL_0100 .

  LOOP AT GT_FIELDCAT INTO GS_FIELDCAT.
    CASE ABAP_ON.
      WHEN GS_FIELDCAT-KEY.
        GS_FIELDCAT-EDIT = ABAP_OFF.
      WHEN OTHERS.
        GS_FIELDCAT-EDIT = ABAP_ON.
    ENDCASE.

    CASE GS_FIELDCAT-FIELDNAME.
      WHEN 'BOMID'.
        GS_FIELDCAT-KEY = ABAP_ON.
        GS_FIELDCAT-EDIT = ABAP_OFF.
      WHEN 'BOMINDEX'.
        GS_FIELDCAT-KEY = ABAP_ON.
        GS_FIELDCAT-OUTPUTLEN = 8.
        GS_FIELDCAT-JUST = 'C'.
        GS_FIELDCAT-EDIT = ABAP_OFF.
      WHEN 'MATNR'.
*        GS_FIELDCAT-JUST      = 'C'.
        GS_FIELDCAT-OUTPUTLEN = 10.
        GS_FIELDCAT-F4AVAILABL = ABAP_ON.
      WHEN 'MAKTX'.
        GS_FIELDCAT-OUTPUTLEN = 25.
        GS_FIELDCAT-EDIT      = ABAP_OFF.
      WHEN 'MATTYPE'.
        GS_FIELDCAT-OUTPUTLEN = 10.
        GS_FIELDCAT-EDIT      = ABAP_OFF.
      WHEN 'MENGE'.
        GS_FIELDCAT-OUTPUTLEN = 10.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
        GS_FIELDCAT-DO_SUM    = ABAP_ON.
      WHEN 'MEINS'.
        GS_FIELDCAT-COLTEXT   = '단위'.
        GS_FIELDCAT-JUST      = 'L'.
        GS_FIELDCAT-OUTPUTLEN = 5.
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
        GS_FIELDCAT-NO_OUT  = ABAP_ON.
      WHEN 'MARK'.
        GS_FIELDCAT-NO_OUT  = ABAP_ON.
    ENDCASE.

    MODIFY GT_FIELDCAT FROM GS_FIELDCAT.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DATA_INSERT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PO_SENDER
*&---------------------------------------------------------------------*
FORM DATA_INSERT  USING  PO_SENDER.

  " 데이터를 생성할 수 있는 팝업창을 호출
  CALL SCREEN 0110 STARTING AT 50 5.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form EDIT_MODE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PO_SENDER
*&---------------------------------------------------------------------*
FORM EDIT_MODE  USING PO_SENDER TYPE REF TO CL_GUI_ALV_GRID.

  DATA LV_CHECK TYPE I.

  LV_CHECK = PO_SENDER->IS_READY_FOR_INPUT( ).

  IF LV_CHECK EQ 0.
    LV_CHECK = 1.
  ELSE.
    LV_CHECK = 0.
  ENDIF.

  CALL METHOD PO_SENDER->SET_READY_FOR_INPUT
    EXPORTING
      I_READY_FOR_INPUT = LV_CHECK. " Ready for Input Status

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DATA_DELETE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PO_SENDER
*&---------------------------------------------------------------------*
FORM DATA_DELETE  USING PO_SENDER TYPE REF TO CL_GUI_ALV_GRID.

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
    WHEN GO_ALV_GRID_1.
      IF LT_INDEX_ROWS[] IS INITIAL.
        " TEXT-M01: 라인을 선택하세요.
        MESSAGE S000 DISPLAY LIKE 'W' WITH '최소 한 행이상 선택하세요'.

      ELSE.

        LOOP AT LT_INDEX_ROWS INTO LS_INDEX_ROW WHERE ROWTYPE IS INITIAL.

          READ TABLE GT_DISPLAY INTO GS_DISPLAY INDEX LS_INDEX_ROW-INDEX.

          IF SY-SUBRC EQ 0.

            UPDATE ZEA_STKO
               SET LOEKZ = ABAP_ON
             WHERE BOMID    EQ GS_DISPLAY-BOMID.

            "실행된 결과를 LV_SUBRC에 누적합산
            ADD SY-SUBRC TO LV_SUBRC.

            UPDATE ZEA_STPO
               SET LOEKZ = ABAP_ON
             WHERE BOMID    EQ GS_DISPLAY-BOMID.

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

    WHEN GO_ALV_GRID_2.
      IF LT_INDEX_ROWS[] IS INITIAL.
        " TEXT-M01: 라인을 선택하세요.
        MESSAGE S000 DISPLAY LIKE 'W' WITH '최소 한 행이상 선택하세요'.

      ELSE.

        LOOP AT LT_INDEX_ROWS INTO LS_INDEX_ROW WHERE ROWTYPE IS INITIAL.

          READ TABLE GT_DISPLAY2 INTO GS_DISPLAY2 INDEX LS_INDEX_ROW-INDEX.

          IF SY-SUBRC EQ 0.

            UPDATE ZEA_STPO
               SET LOEKZ = ABAP_ON
             WHERE BOMID    EQ GS_DISPLAY2-BOMID
               AND BOMINDEX EQ GS_DISPLAY2-BOMINDEX.

            "실행된 결과를 LV_SUBRC에 누적합산
            ADD SY-SUBRC TO LV_SUBRC.

            IF SY-SUBRC EQ 0.
              LV_COUNT += 1.
            ENDIF.

            " ITAB 변경로직
            GS_DISPLAY2-MARK = ABAP_ON.
            MODIFY GT_DISPLAY2 FROM GS_DISPLAY2 INDEX LS_INDEX_ROW-INDEX
            TRANSPORTING MARK.

          ENDIF.

        ENDLOOP.

        IF LV_SUBRC EQ 0.
          DELETE GT_DISPLAY2
           WHERE MARK EQ ABAP_ON.
          "변경사항에 대한 확정처리
          COMMIT WORK AND WAIT.
          MESSAGE S000 WITH LV_COUNT '건의 데이터가 삭제되었습니다.'.

          PERFORM REFRESH_ALV_DETAIL_0100.
        ELSE.
          " 변경사항에 대한 원복처리
          ROLLBACK WORK.
          MESSAGE S000 DISPLAY LIKE 'W' WITH '데이터 삭제를 실패하였습니다.'.
        ENDIF.

      ENDIF.

      LOOP AT GT_DISPLAY2 INTO GS_DISPLAY2.
        GS_DISPLAY2-BOMINDEX = ( SY-TABIX  ) * 10.
        MODIFY GT_DISPLAY2 FROM GS_DISPLAY2 TRANSPORTING BOMINDEX.
      ENDLOOP.


  ENDCASE.

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

  REFRESH GT_DISPLAY.
  REFRESH GT_DISPLAY2.

  DATA LV_BOMID TYPE C LENGTH 8.

  SELECT SINGLE BOMID
    FROM ZEA_STKO
    INTO LV_BOMID.

  SELECT *
    FROM ZEA_STKO
    INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY
    WHERE BOMID EQ ZEA_STKO-BOMID.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_DATA_ALL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SELECT_DATA_ALL .

  REFRESH GT_DISPLAY.

  SELECT *
    FROM ZEA_STKO
    INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SEMI_RAW_FILTER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SEMI_RAW_FILTER .

  REFRESH GT_FILTER.

  CLEAR GS_FILTER.
  GS_FILTER-FIELDNAME = 'MATTYPE'.
  GS_FILTER-SIGN      = 'I'.
  GS_FILTER-OPTION    = 'EQ'.
  GS_FILTER-LOW       = '반제품'.
  APPEND GS_FILTER TO GT_FILTER.

  CLEAR GS_FILTER.
  GS_FILTER-FIELDNAME = 'MATTYPE'.
  GS_FILTER-SIGN      = 'I'.
  GS_FILTER-OPTION    = 'EQ'.
  GS_FILTER-LOW       = '원자재'.
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
*& Form SET_ALV_FILTER2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_ALV_FILTER2 .

  " ALV에 Filter 정보를 적용하는 과정
  CALL METHOD GO_ALV_GRID_2->SET_FILTER_CRITERIA
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
  CALL METHOD GO_ALV_GRID_2->REFRESH_TABLE_DISPLAY
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
*& Form FIN_SEMI_FILTER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FIN_SEMI_FILTER .

  REFRESH GT_FILTER.

  CLEAR GS_FILTER.
  GS_FILTER-FIELDNAME = 'MATTYPE'.
  GS_FILTER-SIGN      = 'I'.
  GS_FILTER-OPTION    = 'EQ'.
  GS_FILTER-LOW       = '완제품'.
  APPEND GS_FILTER TO GT_FILTER.

  CLEAR GS_FILTER.
  GS_FILTER-FIELDNAME = 'MATTYPE'.
  GS_FILTER-SIGN      = 'I'.
  GS_FILTER-OPTION    = 'EQ'.
  GS_FILTER-LOW       = '반제품'.
  APPEND GS_FILTER TO GT_FILTER.

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
*& Form SET_TOOLBAR_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_TOOLBAR_0100 .

  REFRESH GT_TOOLBAR.

  GT_TOOLBAR[] = VALUE #(
                              ( CL_GUI_ALV_GRID=>MC_FC_LOC_APPEND_ROW )
                              ( CL_GUI_ALV_GRID=>MC_FC_LOC_COPY )
                              ( CL_GUI_ALV_GRID=>MC_FC_LOC_COPY_ROW )
                              ( CL_GUI_ALV_GRID=>MC_FC_LOC_CUT )
                              ( CL_GUI_ALV_GRID=>MC_FC_LOC_DELETE_ROW )
                              ( CL_GUI_ALV_GRID=>MC_FC_LOC_INSERT_ROW )
*                              ( CL_GUI_ALV_GRID=>MC_FC_LOC_MOVE_ROW )
                              ( CL_GUI_ALV_GRID=>MC_FC_LOC_PASTE )
                              ( CL_GUI_ALV_GRID=>MC_FC_LOC_PASTE_NEW_ROW )
                              ( CL_GUI_ALV_GRID=>MC_FC_LOC_UNDO )
                              ( CL_GUI_ALV_GRID=>MC_FC_REFRESH )
*                              ( CL_GUI_ALV_GRID=>MC_FC_CHECK )
*                              ( CL_GUI_ALV_GRID=>MC_FC_GRAPH )
*                              ( CL_GUI_ALV_GRID=>MC_FC_HELP )
*                              ( CL_GUI_ALV_GRID=>MC_FC_INFO )
*                              ( CL_GUI_ALV_GRID=>MC_FC_VIEWS )
*                              ( CL_GUI_ALV_GRID=>MC_FC_PRINT )
                           ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_TOOLBAR_DETAIL_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_TOOLBAR_DETAIL_0100 .

  REFRESH GT_TOOLBAR.

  GT_TOOLBAR[] = VALUE #(
                              ( CL_GUI_ALV_GRID=>MC_FC_LOC_APPEND_ROW )
                              ( CL_GUI_ALV_GRID=>MC_FC_LOC_COPY )
                              ( CL_GUI_ALV_GRID=>MC_FC_LOC_COPY_ROW )
                              ( CL_GUI_ALV_GRID=>MC_FC_LOC_CUT )
                              ( CL_GUI_ALV_GRID=>MC_FC_LOC_DELETE_ROW )
                              ( CL_GUI_ALV_GRID=>MC_FC_LOC_INSERT_ROW )
*                              ( CL_GUI_ALV_GRID=>MC_FC_LOC_MOVE_ROW )
                              ( CL_GUI_ALV_GRID=>MC_FC_LOC_PASTE )
                              ( CL_GUI_ALV_GRID=>MC_FC_LOC_PASTE_NEW_ROW )
                              ( CL_GUI_ALV_GRID=>MC_FC_LOC_UNDO )
                              ( CL_GUI_ALV_GRID=>MC_FC_REFRESH )
*                              ( CL_GUI_ALV_GRID=>MC_FC_CHECK )
*                              ( CL_GUI_ALV_GRID=>MC_FC_GRAPH )
*                              ( CL_GUI_ALV_GRID=>MC_FC_HELP )
*                              ( CL_GUI_ALV_GRID=>MC_FC_INFO )
*                              ( CL_GUI_ALV_GRID=>MC_FC_VIEWS )
*                              ( CL_GUI_ALV_GRID=>MC_FC_PRINT )
                           ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_ONF4
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> SENDER
*&      --> E_FIELDNAME
*&      --> E_FIELDVALUE
*&      --> ES_ROW_NO
*&      --> ER_EVENT_DATA
*&      --> ET_BAD_CELLS
*&      --> E_DISPLAY
*&---------------------------------------------------------------------*
FORM HANDLE_ONF4  USING    PO_SENDER        TYPE REF TO CL_GUI_ALV_GRID
                           PV_FIELDNAME     TYPE LVC_FNAME
                           PV_FIELDVALUE    TYPE LVC_VALUE
                           PV_ROW_NO        TYPE LVC_S_ROID
                           PV_EVENT_DATA    TYPE REF TO CL_ALV_EVENT_DATA
                           PV_BAD_CELLS     TYPE LVC_T_MODI
                           PV_DISPLAY       TYPE CHAR01.

  DATA : LS_LVC_MODI TYPE LVC_S_MODI.
  FIELD-SYMBOLS : <F4TAB> TYPE LVC_T_MODI.

  PV_EVENT_DATA->M_EVENT_HANDLED = ABAP_ON.

  DATA LT_RETURN TYPE TABLE OF DDSHRETVAL WITH HEADER LINE.

  CALL FUNCTION 'F4IF_FIELD_VALUE_REQUEST'
    EXPORTING
      TABNAME           = 'ZEA_MMT010'                 " Table/structure name from Dictionary
      FIELDNAME         = 'MATNR'                 " Field name from Dictionary
      SEARCHHELP        = 'ZEA_SH_MATNR'            " Search help as screen field attribute
*     SHLPPARAM         = SPACE            " Search help parameter in screen field
      DYNPPROG          = SY-REPID            " Current program
      DYNPNR            = SY-DYNNR           " Screen number
      DYNPROFIELD       = 'PA_MATNR'          " Name of screen field for value return
*     STEPL             = 0                " Steploop line of screen field
*     VALUE             = SPACE            " Field contents for F4 call
*     MULTIPLE_CHOICE   = SPACE            " Switch on multiple selection
*     DISPLAY           = SPACE            " Override readiness for input
*     SUPPRESS_RECORDLIST = SPACE            " Skip display of the hit list
*     CALLBACK_PROGRAM  = SPACE            " Program for callback before F4 start
*     CALLBACK_FORM     = SPACE            " Form for callback before F4 start (-> long docu)
*     CALLBACK_METHOD   =                  " Interface for Callback Routines
*     SELECTION_SCREEN  = SPACE            " Behavior as in Selection Screen (->Long Docu)
*    IMPORTING
*     USER_RESET        =                  " Single-Character Flag
    TABLES
      RETURN_TAB        = LT_RETURN                  " Return the selected value
    EXCEPTIONS
      FIELD_NOT_FOUND   = 1                " Field does not exist in the Dictionary
      NO_HELP_FOR_FIELD = 2                " No F4 help is defined for the field
      INCONSISTENT_HELP = 3                " F4 help for the field is inconsistent
      NO_VALUES_FOUND   = 4                " No values found
      OTHERS            = 5.




  ASSIGN PV_EVENT_DATA->M_DATA->* TO <F4TAB>.
  LS_LVC_MODI-ROW_ID    = PV_ROW_NO-ROW_ID.
  LS_LVC_MODI-FIELDNAME = PV_FIELDNAME.
  LS_LVC_MODI-VALUE     =  LT_RETURN-FIELDVAL.
  APPEND LS_LVC_MODI TO <F4TAB>.

  CLEAR GS_MMT010.

  SELECT SINGLE *
    INTO CORRESPONDING FIELDS OF GS_MMT010
    FROM ZEA_MMT010 AS A
    INNER JOIN ZEA_MMT020 AS B
    ON A~MATNR EQ B~MATNR
    WHERE A~MATNR EQ LT_RETURN-FIELDVAL.


  CASE PO_SENDER.
    WHEN GO_ALV_GRID_1.
      GS_DISPLAY-MATNR = GS_MMT010-MATNR.
      GS_DISPLAY-MAKTX = GS_MMT010-MAKTX.
      GS_DISPLAY-MATTYPE = GS_MMT010-MATTYPE.
      GS_DISPLAY-MENGE = GS_MMT010-WEIGHT.
      GS_DISPLAY-MEINS = GS_MMT010-MEINS1.

      MODIFY GT_DISPLAY FROM GS_DISPLAY INDEX PV_ROW_NO-ROW_ID.

      PERFORM REFRESH_ALV_0100.

    WHEN GO_ALV_GRID_2.
      GS_DISPLAY2-BOMINDEX = PV_ROW_NO-ROW_ID * 10.
      GS_DISPLAY2-MATNR = GS_MMT010-MATNR.
      GS_DISPLAY2-MAKTX = GS_MMT010-MAKTX.
      GS_DISPLAY2-MATTYPE = GS_MMT010-MATTYPE.
      GS_DISPLAY2-MENGE = SPACE. "GS_MMT010-WEIGHT.
      GS_DISPLAY2-MEINS = GS_MMT010-MEINS1.

      MODIFY GT_DISPLAY2 FROM GS_DISPLAY2 INDEX PV_ROW_NO-ROW_ID.

      PERFORM REFRESH_ALV_DETAIL_0100.
  ENDCASE.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form SAVE_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PO_SENDER
*&---------------------------------------------------------------------*
FORM SAVE_DATA  USING   PO_SENDER.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form SEARCH_BOM
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SEARCH_BOM .

  RANGES R_BOMID FOR ZEA_STKO-BOMID.

  REFRESH R_BOMID[].
  CLEAR R_BOMID.

  IF ZEA_STKO-BOMID IS NOT INITIAL.
    R_BOMID-SIGN    = 'I'.
    R_BOMID-OPTION  = 'EQ'.
    R_BOMID-LOW     = ZEA_STKO-BOMID.
    R_BOMID-HIGH    = ''.
    APPEND R_BOMID.
  ENDIF.

  SELECT *
  INTO CORRESPONDING FIELDS OF TABLE @GT_DISPLAY
  FROM ZEA_STKO AS A  JOIN ZEA_T001W  AS B ON B~WERKS EQ A~WERKS
                      JOIN ZEA_MMT020 AS C ON C~MATNR EQ A~MATNR
                                      AND C~SPRAS EQ @SY-LANGU
                      JOIN ZEA_MMT010 AS D ON D~MATNR EQ A~MATNR
                      WHERE A~LOEKZ NE @ABAP_ON
                      AND A~BOMID IN @R_BOMID.

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

  CALL METHOD GO_ALV_GRID_2->CHECK_CHANGED_DATA.

  DATA LV_SUBRC TYPE I.
  DATA LT_STKO TYPE TABLE OF ZEA_STKO.
  DATA LT_STPO TYPE TABLE OF ZEA_STPO.
  DATA LV_SUM TYPE ZEA_STKO-MENGE.

  LOOP AT GT_DISPLAY2 INTO GS_DISPLAY2.
    READ TABLE GT_DATA2 INTO GS_DATA2 INDEX SY-TABIX.
    IF GS_DISPLAY2-MATNR   NE GS_DATA2-MATNR
    OR GS_DISPLAY2-MAKTX   NE GS_DATA2-MAKTX
    OR GS_DISPLAY2-MATTYPE NE GS_DATA2-MATTYPE
    OR GS_DISPLAY2-MENGE   NE GS_DATA2-MENGE
    OR GS_DISPLAY2-MEINS   NE GS_DATA2-MEINS.
      GS_DISPLAY2-AENAM = SY-UNAME.
      GS_DISPLAY2-AEDAT = SY-DATUM.
      GS_DISPLAY2-AEZET = SY-UZEIT.
    ENDIF.

    LV_SUM += GS_DISPLAY2-MENGE.
    MODIFY GT_DISPLAY2
      FROM GS_DISPLAY2
      INDEX SY-TABIX
      TRANSPORTING AENAM AEDAT AEZET.
  ENDLOOP.

  GS_DISPLAY-MENGE = LV_SUM.

  MODIFY GT_DISPLAY
      FROM GS_DISPLAY
      TRANSPORTING MENGE
      WHERE COLOR EQ 'C310'.

  LOOP AT GT_DISPLAY INTO GS_DISPLAY.
    READ TABLE GT_DATA INTO GS_DATA INDEX SY-TABIX.
    IF GS_DISPLAY-WERKS   NE GS_DATA-WERKS
    OR GS_DISPLAY-MATNR   NE GS_DATA-MATNR
    OR GS_DISPLAY-MAKTX   NE GS_DATA-MAKTX
    OR GS_DISPLAY-MATTYPE NE GS_DATA-MATTYPE
    OR GS_DISPLAY-MENGE   NE GS_DATA-MENGE
    OR GS_DISPLAY-MEINS   NE GS_DATA-MEINS.
      GS_DISPLAY-AENAM = SY-UNAME.
      GS_DISPLAY-AEDAT = SY-DATUM.
      GS_DISPLAY-AEZET = SY-UZEIT.
    ENDIF.

    MODIFY GT_DISPLAY2
      FROM GS_DISPLAY2
      INDEX SY-TABIX
      TRANSPORTING AENAM AEDAT AEZET.

  ENDLOOP.

  MOVE-CORRESPONDING GT_DISPLAY TO LT_STKO.
  MOVE-CORRESPONDING GT_DISPLAY2 TO LT_STPO.

  MODIFY ZEA_STKO FROM TABLE LT_STKO.
  IF SY-SUBRC NE 0.
    ADD SY-SUBRC TO LV_SUBRC.
  ENDIF.

  MODIFY ZEA_STPO FROM TABLE LT_STPO.
  IF SY-SUBRC NE 0.
    ADD SY-SUBRC TO LV_SUBRC.
  ENDIF.

  IF LV_SUBRC EQ 0.
    COMMIT WORK AND WAIT.
    MESSAGE S015. "데이터가 성공적으로 저장되었습니다.
  ELSE.
    ROLLBACK WORK.
    MESSAGE S016 DISPLAY LIKE 'E'. "데이터 저장 중 오류가 발생했습니다.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form F4_HELP
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


  DATA : BEGIN OF LT_BOMID OCCURS 0,
           BOMID   TYPE ZEA_STKO-BOMID,
           WERKS   TYPE ZEA_STKO-WERKS,
           PNAME1  TYPE ZEA_T001W-PNAME1,
           MATNR   TYPE ZEA_STKO-MATNR,
           MAKTX   TYPE ZEA_MMT020-MAKTX,
           MATTYPE TYPE ZEA_MMT010-MATTYPE,
           MENGE   TYPE ZEA_STKO-MENGE,
           MEINS   TYPE ZEA_STKO-MEINS,
         END OF LT_BOMID.

  DATA: LT_MAP TYPE TABLE OF DSELC WITH HEADER LINE.

  CLEAR : LT_BOMID, LT_BOMID[],
          LT_VALUE, LT_VALUE[],
          LT_FIELDS, LT_FIELDS[].

  SELECT A~BOMID,
         A~WERKS,
         B~PNAME1,
         A~MATNR,
         C~MAKTX,
         D~MATTYPE,
         A~MENGE,
         A~MEINS
    INTO CORRESPONDING FIELDS OF TABLE @LT_BOMID
    FROM ZEA_STKO AS A  JOIN ZEA_T001W  AS B ON B~WERKS EQ A~WERKS
                        JOIN ZEA_MMT020 AS C ON C~MATNR EQ A~MATNR
                                       AND C~SPRAS EQ @SY-LANGU
                        JOIN ZEA_MMT010 AS D ON D~MATNR EQ A~MATNR.

  SORT LT_BOMID BY BOMID.


**  LOOP AT LT_BOMID.
**    LS_VALUE-STRING = LT_BOMID-BOMID.
**    APPEND LS_VALUE TO LT_VALUE.
**    LS_VALUE-STRING = LT_BOMID-WERKS.
**    APPEND LS_VALUE TO LT_VALUE.
**    LS_VALUE-STRING = LT_BOMID-PNAME1.
**    APPEND LS_VALUE TO LT_VALUE.
**    LS_VALUE-STRING = LT_BOMID-MATNR.
**    APPEND LS_VALUE TO LT_VALUE.
**    LS_VALUE-STRING = LT_BOMID-MAKTX.
**    APPEND LS_VALUE TO LT_VALUE.
**    LS_VALUE-STRING = LT_BOMID-MATTYPE.
**    APPEND LS_VALUE TO LT_VALUE.
**    LS_VALUE-STRING = LT_BOMID-MENGE.
**    APPEND LS_VALUE TO LT_VALUE.
**    LS_VALUE-STRING = LT_BOMID-MEINS.
**    APPEND LS_VALUE TO LT_VALUE.
**  ENDLOOP.

  CLEAR LS_FIELD.
  LS_FIELD-FIELDNAME = 'BOMID'.
  LS_FIELD-INTLEN = 20.
  LS_FIELD-LENG = 20.
  LS_FIELD-OUTPUTLEN = 20.
  LS_FIELD-REPTEXT = 'BOMID'.
  APPEND LS_FIELD TO LT_FIELDS.

  CLEAR LS_FIELD.
  LS_FIELD-FIELDNAME = 'WERKS'.
  LS_FIELD-INTLEN = 20.
  LS_FIELD-LENG = 20.
  LS_FIELD-OUTPUTLEN = 20.
  LS_FIELD-REPTEXT = '플랜트ID'.
  APPEND LS_FIELD TO LT_FIELDS.

  CLEAR LS_FIELD.
  LS_FIELD-FIELDNAME = 'PNAME1'.
  LS_FIELD-INTLEN = 20.
  LS_FIELD-LENG = 20.
  LS_FIELD-OUTPUTLEN = 20.
  LS_FIELD-REPTEXT = '플랜트명'.
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

  CLEAR LS_FIELD.
  LS_FIELD-FIELDNAME = 'MATTYPE'.
  LS_FIELD-INTLEN = 20.
  LS_FIELD-LENG = 20.
  LS_FIELD-OUTPUTLEN = 20.
  LS_FIELD-REPTEXT = '자재유형'.
  APPEND LS_FIELD TO LT_FIELDS.

  CLEAR LS_FIELD.
  LS_FIELD-FIELDNAME = 'MENGE'.
  LS_FIELD-INTLEN = 20.
  LS_FIELD-LENG = 20.
  LS_FIELD-OUTPUTLEN = 20.
  LS_FIELD-REPTEXT = '수량'.
  APPEND LS_FIELD TO LT_FIELDS.

  CLEAR LS_FIELD.
  LS_FIELD-FIELDNAME = 'MEINS'.
  LS_FIELD-INTLEN = 20.
  LS_FIELD-LENG = 20.
  LS_FIELD-OUTPUTLEN = 20.
  LS_FIELD-REPTEXT = '단위'.
  APPEND LS_FIELD TO LT_FIELDS.




**  CLEAR: LT_MAP.
**  LT_MAP-FLDNAME = 'BOMID'.
**  LT_MAP-DYFLDNAME = 'ZEA_STKO-BOMID'.
**  APPEND LT_MAP.
**
**  CLEAR: LT_MAP.
**  LT_MAP-FLDNAME = 'WERKS'.
**  LT_MAP-DYFLDNAME = 'ZEA_STKO-WERKS'.
**  APPEND LT_MAP.
**
**  CLEAR: LT_MAP.
**  LT_MAP-FLDNAME = 'PNAME1'.
**  LT_MAP-DYFLDNAME = 'ZEA_T001W-PNAME1'.
**  APPEND LT_MAP.
**
**  CLEAR: LT_MAP.
**  LT_MAP-FLDNAME = 'MATNR'.
**  LT_MAP-DYFLDNAME = 'ZEA_STKO-MATNR'.
**  APPEND LT_MAP.
**
**  CLEAR: LT_MAP.
**  LT_MAP-FLDNAME = 'MAKTX'.
**  LT_MAP-DYFLDNAME = 'ZEA_MMT020-MAKTX'.
**  APPEND LT_MAP.
**
**  CLEAR: LT_MAP.
**  LT_MAP-FLDNAME = 'MATTYPE'.
**  LT_MAP-DYFLDNAME = 'ZEA_MMT010-MATTYPE'.
**  APPEND LT_MAP.
**
**  CLEAR: LT_MAP.
**  LT_MAP-FLDNAME = 'MENGE'.
**  LT_MAP-DYFLDNAME = 'ZEA_STKO-MENGE'.
**  APPEND LT_MAP.
**
**  CLEAR: LT_MAP.
**  LT_MAP-FLDNAME = 'MEINS'.
**  LT_MAP-DYFLDNAME = 'ZEA_STKO-MEINS'.
**  APPEND LT_MAP.




  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      RETFIELD        = 'BOMID'           " Name of return field in FIELD_TAB
      DYNPPROG        = SY-REPID          " Current program
      DYNPNR          = SY-DYNNR          " Screen number
*     DYNPROFIELD     = 'ZEA_STKO-BOMID'
      WINDOW_TITLE    = '자재그룹'        " Title for the hit list
      VALUE_ORG       = 'S'               " Value return: C: cell by cell, S: structured
    TABLES
*     FIELD_TAB       = LT_FIELDS[]
      VALUE_TAB       = LT_BOMID[]                 " Table of values: entries cell by cell
      RETURN_TAB      = LT_RETURN_TAB[]
*     DYNPFLD_MAPPING = LT_MAP
    EXCEPTIONS
      PARAMETER_ERROR = 1                " Incorrect parameter
      NO_VALUES_FOUND = 2                " No values found
      OTHERS          = 3.

  IF SY-SUBRC EQ 0.
    READ TABLE LT_RETURN_TAB INTO LS_RETURN_TAB INDEX 1.
    IF SY-SUBRC EQ 0.
      ZEA_STKO-BOMID = LS_RETURN_TAB-FIELDVAL.

      READ TABLE LT_BOMID WITH KEY BOMID = ZEA_STKO-BOMID BINARY SEARCH.
      IF SY-SUBRC EQ 0.
        ZEA_T001W-PNAME1      = LT_BOMID-PNAME1.
        ZEA_STKO-WERKS        = LT_BOMID-WERKS.
        ZEA_MMT020-MAKTX      = LT_BOMID-MAKTX.
        ZEA_STKO-MATNR        = LT_BOMID-MATNR.
        ZEA_STKO-MENGE        = LT_BOMID-MENGE.
        ZEA_MMT010-MATTYPE    = LT_BOMID-MATTYPE.
        ZEA_STKO-MEINS        = LT_BOMID-MEINS.
        LEAVE SCREEN.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MODIFY_DISPLAY_DATA2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM MODIFY_DISPLAY_DATA2 .

  LOOP AT GT_DISPLAY2 INTO GS_DISPLAY2.

    CASE GS_DISPLAY2-MATTYPE.
      WHEN '원자재'.
        CLEAR GS_FIELD_COLOR.
        GS_FIELD_COLOR-FNAME = 'MATTYPE'.
        GS_FIELD_COLOR-COLOR-COL = 3. " 노랑
        GS_FIELD_COLOR-COLOR-INT = 1.
        GS_FIELD_COLOR-COLOR-INV = 0.
        APPEND GS_FIELD_COLOR TO GS_DISPLAY2-IT_FIELD_COLORS.
      WHEN '반제품'.
        CLEAR GS_FIELD_COLOR.
        GS_FIELD_COLOR-FNAME = 'MATTYPE'.
        GS_FIELD_COLOR-COLOR-COL = 5. " 초록
        GS_FIELD_COLOR-COLOR-INT = 0.
        GS_FIELD_COLOR-COLOR-INV = 0.
        APPEND GS_FIELD_COLOR TO GS_DISPLAY2-IT_FIELD_COLORS.
    ENDCASE.

    MODIFY GT_DISPLAY2 FROM GS_DISPLAY2.
  ENDLOOP.

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

  LOOP AT GT_DISPLAY INTO GS_DISPLAY.

    CASE GS_DISPLAY-MATTYPE.
      WHEN '완제품'.
        CLEAR GS_FIELD_COLOR.
        GS_FIELD_COLOR-FNAME = 'MATTYPE'.
        GS_FIELD_COLOR-COLOR-COL = 1. " 파랑
        GS_FIELD_COLOR-COLOR-INT = 1.
        GS_FIELD_COLOR-COLOR-INV = 0.
        APPEND GS_FIELD_COLOR TO GS_DISPLAY-IT_FIELD_COLORS.
      WHEN '반제품'.
        CLEAR GS_FIELD_COLOR.
        GS_FIELD_COLOR-FNAME = 'MATTYPE'.
        GS_FIELD_COLOR-COLOR-COL = 5. " 초록
        GS_FIELD_COLOR-COLOR-INT = 0.
        GS_FIELD_COLOR-COLOR-INV = 0.
        APPEND GS_FIELD_COLOR TO GS_DISPLAY-IT_FIELD_COLORS.
    ENDCASE.

    MODIFY GT_DISPLAY FROM GS_DISPLAY.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SEARCH_ALL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SEARCH_ALL .

  REFRESH GT_DISPLAY.
  CLEAR: ZEA_STKO, ZEA_MMT020, ZEA_MMT010, ZEA_T001W.

  SELECT *
  INTO CORRESPONDING FIELDS OF TABLE @GT_DISPLAY
  FROM ZEA_STKO AS A  JOIN ZEA_T001W  AS B ON B~WERKS EQ A~WERKS
                      JOIN ZEA_MMT020 AS C ON C~MATNR EQ A~MATNR
                                      AND C~SPRAS EQ @SY-LANGU
                      JOIN ZEA_MMT010 AS D ON D~MATNR EQ A~MATNR.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_DATA_CHANGED_FINISHED
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_MODIFIED
*&      --> SENDER
*&---------------------------------------------------------------------*
FORM HANDLE_DATA_CHANGED_FINISHED  USING    E_MODIFIED
                                            P_SENDER TYPE REF TO CL_GUI_ALV_GRID.

  CHECK E_MODIFIED IS NOT INITIAL AND GV_CHANGED EQ ABAP_ON.

  CLEAR GV_CHANGED.
  P_SENDER->REFRESH_TABLE_DISPLAY(
*    EXPORTING
*      IS_STABLE      =                  " With Stable Rows/Columns
*      I_SOFT_REFRESH =                  " Without Sort, Filter, etc.
*    EXCEPTIONS
*      FINISHED       = 1                " Display was Ended (by Export)
*      OTHERS         = 2
  ).
  IF SY-SUBRC <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.
