*&---------------------------------------------------------------------*
*& Include          ZALV_GRID_DISPLAY_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form MAKE_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM MAKE_FIELDCAT_0100 .

  LOOP AT GT_FIELDCAT INTO GS_FIELDCAT.

    CASE GS_FIELDCAT-FIELDNAME.
      WHEN 'VBELN'.
        GS_FIELDCAT-COL_POS = 1.
        GS_FIELDCAT-HOTSPOT = ABAP_ON.
*      WHEN 'CUSCODE'.
**        GS_FIELDCAT-KEY  = ABAP_ON.
*        GS_FIELDCAT-EMPHASIZE = 'C501'.
      WHEN 'ICON'.
        GS_FIELDCAT-COL_POS   = 0.
        GS_FIELDCAT-COLTEXT = '출고 문서 유/무'.
        GS_FIELDCAT-ICON    = ABAP_ON.
*        GS_FIELDCAT-KEY     = ABAP_OFF.
*        GS_FIELDCAT-NO_OUT  = ABAP_ON.
      WHEN 'STATUS'.
        GS_FIELDCAT-NO_OUT = ABAP_ON.
      WHEN 'COLOR'.
        GS_FIELDCAT-NO_OUT  = ABAP_ON.
      WHEN 'LIGHT'.
        GS_FIELDCAT-NO_OUT  = ABAP_ON.
      WHEN 'MARK'.
        GS_FIELDCAT-NO_OUT  = ABAP_ON.
      WHEN 'BPCUS'.
        GS_FIELDCAT-COLTEXT = '고객명'.
        GS_FIELDCAT-COL_POS = 2.

      WHEN 'TOAMT'.
        GS_FIELDCAT-CFIELDNAME = 'WAERS'.
        GS_FIELDCAT-EMPHASIZE = 'C310'.

      WHEN 'ERNAM'.
        GS_FIELDCAT-NO_OUT  = ABAP_ON.
      WHEN 'ERDAT'.
        GS_FIELDCAT-NO_OUT  = ABAP_ON.
      WHEN 'ERZET'.
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


* CLEAR GS_FIELDCAT.
*    GS_FIELDCAT-FIELDNAME = 'CARRID'.        " 필드 이름
*    GS_FIELDCAT-COLTEXT   = TEXT-F01.        " 출력 되는 컬럼명
*   GS_FIELDCAT-HOTSPOT   = ABAP_ON.         " HOTSPOT 설정

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

  GV_SAVE1 = 'A'.   " '' : Layout 저장불가
  " 'U' : 저장한 사용자만 사용가능
  " 'X' : Layout을 저장하면 모든 사용자가 사용 가능
  " 'A' : Layout을 저장할 때 'U'/'X' 선택 가능
  GS_LAYOUT-CWIDTH_OPT = 'A'.
*  GS_LAYOUT-CWIDTH_OPT = ABAP_ON.
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
*  GS_LAYOUT-EXCP_FNAME = 'LIGHT'.           " 신호등
*  GS_LAYOUT-EXCP_LED = ABAP_ON.             " 신호등 모양 변경
*  GS_LAYOUT-CTAB_FNAME = 'IT_FIELD_COLORS'. " 셀 별 색상
*  GS_LAYOUT-STYLEFNAME  = 'STYLE'.          " 스타일
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_DATA
*&---------------------------------------------------------------------*
FORM SELECT_DATA .

  REFRESH GT_DATA.


  SELECT *
    FROM ZEA_SDT040 AS A
    JOIN ZEA_KNA1 AS B
      ON B~CUSCODE EQ A~CUSCODE
    INTO CORRESPONDING FIELDS OF TABLE GT_DATA
    WHERE A~STATUS2 = 'X'.



  SORT GT_DATA BY VBELN CUSCODE.


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

    IF GS_DISPLAY-STATUS = 'X'.
      GS_DISPLAY-ICON = ICON_LED_GREEN.
    ELSEIF GS_DISPLAY-STATUS = 'I'.
      GS_DISPLAY-ICON = ICON_LED_YELLOW.
    ELSE.
      GS_DISPLAY-ICON = ICON_LED_RED.
    ENDIF.

*    GS_DISPLAY2-SBELNR = ZEA_SDT060-SBELNR.
*--------------------------------------------------------------------*
    APPEND GS_DISPLAY TO GT_DISPLAY.

  ENDLOOP.

  SORT GT_DISPLAY BY ICON.
 DESCRIBE TABLE GT_DISPLAY LINES GV_LINES.
 MESSAGE S006 WITH GV_LINES.
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

*  DESCRIBE TABLE GT_DISPLAY LINES GV_LINES.

  IF GT_DISPLAY IS INITIAL.
*    MESSAGE S013 DISPLAY LIKE 'W'.
*  ELSE.
*    MESSAGE S006 WITH GV_LINES.
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

  CLEAR GS_VARIANT.
  CLEAR GV_SAVE1.

  GS_VARIANT-REPORT = SY-REPID.
*  GS_VARIANT-VARIANT = PA_LAYO.

  CALL METHOD GO_ALV_GRID_1->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
*     I_STRUCTURE_NAME              = ''
      IS_VARIANT                    = GS_VARIANT
      I_SAVE                        = GV_SAVE1
      IS_LAYOUT                     = GS_LAYOUT
      IT_TOOLBAR_EXCLUDING          = GT_TOOLBAR[]
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
    MESSAGE E023. " ALV Grid 에 데이터를 전달하는 중 오류가 발생했습니다.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_FIELDCAT_0100 .

*     PERFORM GET_FIELDCAT_0100.
  PERFORM GET_FIELDCAT_0100   USING    GT_DISPLAY
                              CHANGING GT_FIELDCAT.
*  PERFORM GET_FIELDCAT2   USING    GT_DISPLAY2
*                          CHANGING GT_FIELDCAT.
  PERFORM MAKE_FIELDCAT_0100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_EVENT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_EVENT_0100 .

  SET HANDLER LCL_EVENT_HANDLER=>ON_TOOLBAR FOR GO_ALV_GRID_1.
  SET HANDLER LCL_EVENT_HANDLER=>ON_DOUBLE_CLICK FOR GO_ALV_GRID_1.
  SET HANDLER LCL_EVENT_HANDLER=>ON_USER_COMMAND FOR GO_ALV_GRID_1.
  SET HANDLER LCL_EVENT_HANDLER=>ON_HOTSPOT_CLICK FOR GO_ALV_GRID_1.
  SET HANDLER LCL_EVENT_HANDLER=>ON_BUTTON_CLICK FOR GO_ALV_GRID_1.

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

  CLEAR LS_STABLE.

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

  CALL METHOD GO_ALV_GRID_4->REFRESH_TABLE_DISPLAY
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

  DATA : LV_INVOICE TYPE I,
         LV_OK      TYPE I,
         LV_ING     TYPE I,
         LV_NO      TYPE I.


  CASE PO_SENDER.
    WHEN GO_ALV_GRID_1.

      LOOP AT GT_DISPLAY INTO GS_DISPLAY.

        CASE GS_DISPLAY-ICON.
          WHEN ICON_LED_GREEN.
            ADD 1 TO LV_INVOICE.
            ADD 1 TO LV_OK.
          WHEN ICON_LED_RED.
            ADD 1 TO LV_INVOICE.
            ADD 1 TO LV_NO.
          WHEN ICON_LED_YELLOW.
            ADD 1 TO LV_INVOICE.
            ADD 1 TO LV_ING.
        ENDCASE.
      ENDLOOP.


* 구분자 =>> |
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 3. " 구분자
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 출고 문서처리 O/X
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 0. " 출고 문서처리 O/X
      LS_TOOLBAR-FUNCTION = GC_INVOICE.
      LS_TOOLBAR-TEXT = TEXT-L09 && ':' && LV_INVOICE.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 출고 문서 처리 O
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 0. " 출고 문서처리 O
      LS_TOOLBAR-FUNCTION = GC_INVOICE_OK.
      LS_TOOLBAR-ICON = ICON_LED_GREEN.
      LS_TOOLBAR-TEXT = TEXT-L10 && ':' && LV_OK.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 출고 문서 처리 진행중
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 0. " 출고 문서처리 진행중
      LS_TOOLBAR-FUNCTION = GC_INVOICE_ING.
      LS_TOOLBAR-ICON = ICON_LED_YELLOW.
      LS_TOOLBAR-TEXT = TEXT-L11 && ':' && LV_ING.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 출고 문서 처리 X
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 0. " 출고 문서처리 X
      LS_TOOLBAR-FUNCTION = GC_INVOICE_NO.
      LS_TOOLBAR-ICON = ICON_LED_RED.
      LS_TOOLBAR-TEXT = TEXT-L07 && ':' && LV_NO.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.
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
    WHEN GO_ALV_GRID_1. "PO_SENDER 가 GO_ALV_GRID 일 때
      CASE PV_UCOMM.  " 선택한 버튼 (PV_UCOMM은 SY-UCOMM 타입)
        WHEN GC_INVOICE.
*          PERFORM SELECT_DATA.
*          PERFORM MAKE_DISPLAY_DATA.
          PERFORM INVOICE_FILTER.
          PERFORM SET_ALV_FILTER.

        WHEN GC_INVOICE_OK.
*          PERFORM SELECT_DATA.
*          PERFORM MAKE_DISPLAY_DATA.
          PERFORM INVOICE_OK_FILTER.
          PERFORM SET_ALV_FILTER.

        WHEN GC_INVOICE_NO.
*          PERFORM SELECT_DATA.
*          PERFORM MAKE_DISPLAY_DATA.
          PERFORM INVOICE_NO_FILTER.
          PERFORM SET_ALV_FILTER.

        WHEN GC_INVOICE_ING.
*          PERFORM SELECT_DATA.
*          PERFORM MAKE_DISPLAY_DATA.
          PERFORM INVOICE_ING_FILTER.
          PERFORM SET_ALV_FILTER.





*       WHEN GC_BOOKING_CANCEL.
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


  READ TABLE GT_DISPLAY INTO GS_DISPLAY INDEX PS_ROW_ID-INDEX.

  CASE PS_COLUMN_ID-FIELDNAME.
    WHEN 'VBELN'.

      PERFORM SBELNR_DATA.


*        AND B~VBELN EQ @GS_DISPLAY-VBELN.

      " 기존 셀렉트 문 (강사님께 내일 여쭤보ㅛ6기)
*      SELECT A~STATUS A~VBELN A~POSNR A~MATNR
*       C~MAKTX A~AUQUA A~MEINS A~NETPR
*       A~AUAMO A~WAERS
*      FROM ZEA_SDT050 AS A     " 판매오더 헤더
*      JOIN ZEA_MMT020 AS C     " 자재 TEXT
*       ON C~MATNR EQ A~MATNR
*      AND SPRAS EQ SY-LANGU
*      INTO CORRESPONDING FIELDS OF TABLE GT_DATA2
*      WHERE A~VBELN EQ GS_DISPLAY-VBELN.

      SORT GT_DATA BY VBELN CUSCODE.

      REFRESH GT_DISPLAY2.
      PERFORM MAKE_DISPLAY2_DATA.
      PERFORM REFRESH_ALV_0100.

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
*  CHECK PS_ROW-ROWTYPE IS INITIAL.
*
*  READ TABLE GT_DISPLAY INTO GS_DISPLAY INDEX PS_ROW-INDEX.
*
*  SELECT  *
*    FROM ZEA_SDT110
*    INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY2
*    WHERE SBELNR EQ GS_DISPLAY-SBELNR.
**      AND CONNID EQ GS_DISPLAY-CONNID.
*
*  PERFORM REFRESH_ALV_0100.


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


  DATA(LT_MOD) = PR_DATA_CHANGED->MT_MOD_CELLS[].

  IF LT_MOD[] IS NOT INITIAL.
    GV_CHANGED = ABAP_ON.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_0160
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT_0160 .

  CREATE OBJECT GO_CONTAINER_3
    EXPORTING
      CONTAINER_NAME = 'CCON3'
    EXCEPTIONS
      OTHERS         = 1.

  IF SY-SUBRC NE 0.
    MESSAGE E020. " Custom Container 생성 중 오류가 발생했습니다.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  CREATE OBJECT GO_ALV_GRID_3
    EXPORTING
      I_PARENT = GO_CONTAINER_3
    EXCEPTIONS
      OTHERS   = 1.

  IF SY-SUBRC NE 0.
    MESSAGE E021. " ALV Grid 생성 중 오류가 발생했습니다.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_0160
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV_0160 .

  CALL METHOD GO_ALV_GRID_3->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
*     I_STRUCTURE_NAME              = 'ZEA_SDT050'
      IS_VARIANT                    = GS_VARIANT
      I_SAVE                        = GV_SAVE3
      IS_LAYOUT                     = GS_LAYOUT
    CHANGING
      IT_OUTTAB                     = GT_DISPLAY3
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
*& Form REFRESH_ALV_0160
*&---------------------------------------------------------------------*
FORM REFRESH_ALV_0160 .

  DATA LS_STABLE TYPE LVC_S_STBL.
  LS_STABLE-ROW = ABAP_ON.
  LS_STABLE-COL = ABAP_ON.

  CALL METHOD GO_ALV_GRID_3->REFRESH_TABLE_DISPLAY
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
*& Form MOVE_DATA
*&---------------------------------------------------------------------*
FORM MOVE_DATA .

  " 헤더는 아이템의 판매오더 번호로 찾는다.
  READ TABLE GT_DISPLAY INTO GS_DISPLAY
                        WITH KEY VBELN = GS_DISPLAY2-VBELN.

*-- [FI] 고객 테이블
  ZEA_KNA1-BPCUS      = GS_DISPLAY-BPCUS.     " [BP] 고객명

*-- [SD] 판매오더 Header
  ZEA_SDT040-VBELN    = GS_DISPLAY-VBELN.     " 판매오더 번호
  ZEA_SDT040-CUSCODE  = GS_DISPLAY-CUSCODE.   " [BP] 고객코드
  ZEA_SDT040-SADDR    = GS_DISPLAY-SADDR.     " 판매 배송지 주소
  ZEA_SDT040-VDATU    = GS_DISPLAY-VDATU.     " 배송 요청일

*-- [SD] 판매오더 Item
  ZEA_SDT050-MATNR    = GS_DISPLAY2-MATNR.

  CLEAR ZEA_SDT060.
  CLEAR ZEA_SDT110.

*-- [SD] 출고오더 Header
  ZEA_SDT060-VBELN    = GS_DISPLAY2-VBELN.    " 판매오더 번호
  ZEA_SDT060-DQDAT    = GS_DISPLAY-VDATU.
  ZEA_SDT060-DADAT    = GS_DISPLAY-VDATU .


*-- [MM] 자재 텍스트 테이블
  ZEA_MMT020-MAKTX    = GS_DISPLAY2-MAKTX.

  REFRESH GT_DISPLAY3.
  APPEND GS_DISPLAY2 TO GT_DISPLAY3.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_DATA_2
*&---------------------------------------------------------------------*
FORM SELECT_DATA_2 .

  SELECT  *
    FROM ZEA_SDT050
    INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY2
    WHERE VBELN EQ GS_DISPLAY-VBELN.

  SORT GT_DISPLAY BY VBELN.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_DATA
*&---------------------------------------------------------------------*
FORM CREATE_DATA .

*&---------------------------------------------------------------------*
*& 알고리즘
*& 1) ZEA_SDT060에서 판매오더 번호를 찾지 못했을 경우 -> 무조건 채번
*& 2) ZEA_SDT060에서 판매오더 번호를 찾았을 경우
*& 3) ZEA_SDT060에 판매오더 번호가 같고 고객번호가 같을 때,
*& 4-1) 해당 되는 데이터 값을 찾고, 찾은 데이터의 저장되어 있는 출고 요청일과
*&      새로 입력한 출고일(ZEA_SDT060-RQDAT) 이 같으면 -> 채번 X, 인덱스 증가
*& 4-2) 해당 되는 데이터 값을 찾고, 찾은 데이터의 저장되어 있는 출고 요청일과
*&      새로 입력한 출고일(ZEA_SDT060-RQDAT) 이 다르면  -> 채번
*&---------------------------------------------------------------------*

  DATA LV_COUNT TYPE I.

*      SELECT SINGLE *
*    FROM ZEA_MMT190
*    INTO GS_MMT190
*    WHERE MATNR EQ ZEA_SDT050-MATNR
*      AND WERKS EQ ZEA_SDT060-WERKS.
*
*        IF SY-SUBRC EQ 0.

  " 출고 헤더에서 판매오더번호 기준으로 검색
  SELECT SBELNR VBELN RQDAT CUSCODE WERKS
    FROM ZEA_SDT060
    INTO CORRESPONDING FIELDS OF TABLE GT_CHECK
    WHERE VBELN EQ GS_DISPLAY2-VBELN.

  DESCRIBE TABLE GT_CHECK LINES GV_LINES.





*      " 1. 전체 수량 비교 -> IF
*      IF GS_DISPLAY2-AUQUA > GS_MMT190-CALQTY.              " GS_MMT190에 DEC_TABLE_DATA를 통해서 값이 들어가 있음.
*        MESSAGE E037. " 재고가 부족합니다.
*
*        " 2. 필요수량에서 배치의 보유 수량만큼 제거(보유 수량이 같거나 적을 때만 제거)
*        "     배치의 보유수량이 많으면 필요한 만큼만 제거.
*      ELSE.


  IF GV_LINES EQ 0.     " 출고 문서번호를 무조건 채번해야되는 경우
    PERFORM CREATE_NUMBER.
  ELSE.                        " 경우의 수에 따라 채번을 할지 / Index 만 올릴지

    READ TABLE GT_CHECK INTO GS_CHECK
                        WITH KEY RQDAT = ZEA_SDT060-RQDAT
                                 WERKS = GV_LIST.
    IF SY-SUBRC EQ 0.
      " 동일한 출고일자, 플랜트가 있음 => 해당 출고 문서의 인덱스 추가
      PERFORM NOT_CREATE_NUMBER USING GS_CHECK-SBELNR.

    ELSE.
      " 동일한 출고일자, 플랜트가 없음 => 신규 출고 문서번호 생성
      PERFORM CREATE_NUMBER.

    ENDIF.
  ENDIF.
*      ENDIF.


***    " 채번 하지않고 출하 아이템 테이블에 인덱스만 추가하여 DB 저장
***    IF  ZEA_SDT060-VBELN EQ GS_CHECK-VBELN AND
***        ZEA_SDT040-CUSCODE EQ GS_CHECK-CUSCODE AND
***        ZEA_SDT060-RQDAT EQ GS_CHECK-RQDAT AND
***        GV_LIST EQ GS_CHECK-WERKS.
***
***      PERFORM NOT_CREATE_NUMBER.
***
***      " 출하 요청일이 다르고, 출하되는 플랜트도 다르면 새로운 출고 문서번호 채번
***    ELSEIF ZEA_SDT060-VBELN EQ GS_CHECK-VBELN AND
***           ZEA_SDT040-CUSCODE EQ GS_CHECK-CUSCODE AND
***           ZEA_SDT060-RQDAT NE GS_CHECK-RQDAT AND
***           GV_LIST NE GS_CHECK-WERKS.
***
***      PERFORM CREATE_NUMBER.
***
***      " 출하 요청일은 같지만, 출하되는 플랜트가 다를 경우 출고 문서번호 채번
***    ELSEIF ZEA_SDT060-VBELN EQ GS_CHECK-VBELN AND
***           ZEA_SDT040-CUSCODE EQ GS_CHECK-CUSCODE AND
***           ZEA_SDT060-RQDAT EQ GS_CHECK-RQDAT AND
***           GV_LIST NE GS_CHECK-WERKS.
***
***      PERFORM CREATE_NUMBER.
***
***      " 출하 요청일이 다르지만, 출하되는 플랜트는 동일할 경우 출고 문서번호 채번
***    ELSEIF ZEA_SDT060-VBELN EQ GS_CHECK-VBELN AND
***           ZEA_SDT040-CUSCODE EQ GS_CHECK-CUSCODE AND
***           ZEA_SDT060-RQDAT NE GS_CHECK-RQDAT AND
***           GV_LIST EQ GS_CHECK-WERKS.
***
***      PERFORM CREATE_NUMBER.
***    ENDIF.


*    ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form INVOICE_FILTER
*&---------------------------------------------------------------------*
FORM INVOICE_FILTER .

  REFRESH GT_FILTER.

  CLEAR GS_FILTER.
  GS_FILTER-FIELDNAME = 'ICON'.
  GS_FILTER-SIGN      = 'I'.
  GS_FILTER-OPTION    = 'EQ'.
  GS_FILTER-LOW       = ICON_LED_GREEN.
  APPEND GS_FILTER TO GT_FILTER.

  CLEAR GS_FILTER.
  GS_FILTER-FIELDNAME = 'ICON'.
  GS_FILTER-SIGN      = 'I'.
  GS_FILTER-OPTION    = 'EQ'.
  GS_FILTER-LOW       = ICON_LED_YELLOW.
  APPEND GS_FILTER TO GT_FILTER.

  CLEAR GS_FILTER.
  GS_FILTER-FIELDNAME = 'ICON'.
  GS_FILTER-SIGN      = 'I'.
  GS_FILTER-OPTION    = 'EQ'.
  GS_FILTER-LOW       = ICON_LED_RED.
  APPEND GS_FILTER TO GT_FILTER.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form INVOICE_OK_FILTER
*&---------------------------------------------------------------------*
FORM INVOICE_OK_FILTER .

  REFRESH GT_FILTER.

  CLEAR GS_FILTER.
  GS_FILTER-FIELDNAME = 'ICON'.
  GS_FILTER-SIGN      = 'I'.
  GS_FILTER-OPTION    = 'EQ'.
  GS_FILTER-LOW       = ICON_LED_GREEN.
  APPEND GS_FILTER TO GT_FILTER.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form INVOICE_NO_FILTER
*&---------------------------------------------------------------------*
FORM INVOICE_NO_FILTER .

  REFRESH GT_FILTER.

  CLEAR GS_FILTER.
  GS_FILTER-FIELDNAME = 'ICON'.
  GS_FILTER-SIGN      = 'I'.
  GS_FILTER-OPTION    = 'EQ'.
  GS_FILTER-LOW       = ICON_LED_RED.
  APPEND GS_FILTER TO GT_FILTER.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_DATA_CASE2
*&---------------------------------------------------------------------*
FORM CREATE_DATA_CASE2 .

  DATA LV_SUBRC TYPE I.
  DATA LT_SDT110 TYPE TABLE OF ZEA_SDT110.
  DATA LS_SDT110 TYPE ZEA_SDT110.
*  DATA LV_YEAR TYPE N LENGTH 4.
  DATA LV_CUSCODE TYPE ZEA_SDT110-CUSCODE.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      NR_RANGE_NR             = '001'                 " Number range number
      OBJECT                  = 'ZEA_VBELN'                 " Name of number range object
    IMPORTING
      NUMBER                  = ZEA_SDT060-VBELN                  " free number
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

  REPLACE FIRST OCCURRENCE OF '00' IN ZEA_SDT060-VBELN WITH 'SB'.

*  SELECT SINGLE CUSCODE
*    INTO LV_CUSCODE
*    FROM ZEA_SDT040
*    WHERE MATNR EQ GS_DISPLAY-MATNR
*    AND WERKS EQ GS_DISPLAY-WERKS.

  ZEA_SDT110-CUSCODE = LV_CUSCODE.

  GS_DISPLAY-ICON  = ICON_LED_GREEN.
  ZEA_SDT060-ERDAT = SY-DATUM.
  ZEA_SDT060-ERNAM = SY-UNAME.
  ZEA_SDT060-ERZET = SY-UZEIT.
  ZEA_SDT060-VBELN = GS_DISPLAY-VBELN.
  ZEA_SDT060-CUSCODE = GS_DISPLAY-CUSCODE.
  ZEA_SDT060-ADRNR = GS_DISPLAY-SADDR.
  ZEA_SDT060-RETSU = '출고 완료'.
  ZEA_SDT060-RQDAT = ZEA_SDT060-RQDAT.
  ZEA_SDT060-REDAT = SY-DATUM.
  ZEA_SDT060-DQDAT = SY-DATUM + 3.
  ZEA_SDT060-DADAT = SY-DATUM + 3.
  ZEA_SDT060-DESTU = '배송중'.
  ZEA_SDT060-STATUS = 'X'.



  ZEA_SDT110-POSNR = '0000000010'.

  INSERT ZEA_SDT060.

  IF SY-SUBRC NE 0.
    LV_SUBRC = 4.
    ROLLBACK WORK.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_DATA_CASE1
*&---------------------------------------------------------------------*
FORM CREATE_DATA_CASE1 .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT2_0100
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT2_0100 .

  CREATE OBJECT GO_CONTAINER_2
    EXPORTING
      CONTAINER_NAME = 'CCON2'
    EXCEPTIONS
      OTHERS         = 1.

  IF SY-SUBRC NE 0.
    MESSAGE E020. " Custom Container 생성 중 오류가 발생했습니다.
  ENDIF.

  CREATE OBJECT GO_ALV_GRID_2
    EXPORTING
      I_PARENT = GO_CONTAINER_2
    EXCEPTIONS
      OTHERS   = 1.

  IF SY-SUBRC NE 0.
    MESSAGE E021. " ALV Grid 생성 중 오류가 발생했습니다.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FIELDCAT2_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_FIELDCAT2_0100 .

  PERFORM GET_FIELDCAT_0100     USING    GT_DISPLAY2
                                CHANGING GT_FIELDCAT.

  PERFORM MAKE_FIELDCAT2_0100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_LAYOUT2_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_LAYOUT2_0100 .

  CLEAR GS_LAYOUT.
  CLEAR GS_VARIANT.
  CLEAR GV_SAVE2.

  GS_VARIANT-REPORT = SY-REPID.
  GV_SAVE2 = 'A'.   " '' : Layout 저장불가

  GS_LAYOUT-CWIDTH_OPT = 'A'.               " 열 최적화
  GS_LAYOUT-ZEBRA      = ABAP_ON.           " ZEBRA
  GS_LAYOUT-SEL_MODE   = 'B'.               " 열 단위 선택
*  GS_LAYOUT-GRID_TITLE = TEXT-T01.          " ALV TITLE TEXT
  GS_LAYOUT-INFO_FNAME = 'COLOR'.           " 행 색상
  GS_LAYOUT-STYLEFNAME = 'STYLE'.          " 스타일

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV2_0100
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV2_0100 .

  CALL METHOD GO_ALV_GRID_2->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
      IS_VARIANT                    = GS_VARIANT
      I_SAVE                        = GV_SAVE2
      IS_LAYOUT                     = GS_LAYOUT
    CHANGING
      IT_OUTTAB                     = GT_DISPLAY2
      IT_FIELDCATALOG               = GT_FIELDCAT
    EXCEPTIONS
      INVALID_PARAMETER_COMBINATION = 1
      PROGRAM_ERROR                 = 2
      TOO_MANY_LINES                = 3
      OTHERS                        = 4.

  IF SY-SUBRC <> 0.
    " ALV Grid 에 데이터를 전달하는 중 오류가 발생했습니다.
    MESSAGE E023.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_FIELDCAT2_0100
*&---------------------------------------------------------------------*
FORM MAKE_FIELDCAT2_0100 .

  LOOP AT GT_FIELDCAT INTO GS_FIELDCAT.

    CASE GS_FIELDCAT-FIELDNAME.
      WHEN 'MAKTX'.
        GS_FIELDCAT-COLTEXT    = '자재명'.
        GS_FIELDCAT-COL_POS    = 3.
        GS_FIELDCAT-EMPHASIZE = 'C500'.

      WHEN 'STATUS'.
        GS_FIELDCAT-NO_OUT    = ABAP_ON.

      WHEN 'ICON'.
        GS_FIELDCAT-COL_POS   = 0.
        GS_FIELDCAT-COLTEXT = '출고 문서 유/무'.
        GS_FIELDCAT-ICON    = ABAP_ON.

      WHEN 'AUQUA'.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
        GS_FIELDCAT-EMPHASIZE = 'C300'.

      WHEN 'NETPR'.
        GS_FIELDCAT-CFIELDNAME = 'WAERS'.
        GS_FIELDCAT-EMPHASIZE = 'C310'.

      WHEN 'AUAMO'.
        GS_FIELDCAT-CFIELDNAME = 'WAERS'.
        GS_FIELDCAT-EMPHASIZE = 'C310'.

    ENDCASE.

    MODIFY GT_FIELDCAT FROM GS_FIELDCAT.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_DATA_LISTBOX
*&---------------------------------------------------------------------*
FORM SELECT_DATA_LISTBOX .

  SELECT DISTINCT WERKS PNAME1
    FROM ZEA_T001W
    INTO CORRESPONDING FIELDS OF TABLE GT_LIST.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FIELDCAT_0160
*&---------------------------------------------------------------------*
FORM SET_ALV_FIELDCAT_0160 .

  PERFORM GET_FIELDCAT_0100     USING    GT_DISPLAY2
                                CHANGING GT_FIELDCAT.

  PERFORM MAKE_FIELDCAT2_0160.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_FIELDCAT2_0160
*&---------------------------------------------------------------------*
FORM MAKE_FIELDCAT2_0160 .

  LOOP AT GT_FIELDCAT INTO GS_FIELDCAT.

    CASE GS_FIELDCAT-FIELDNAME.
      WHEN 'MAKTX'.
        GS_FIELDCAT-COLTEXT    = '자재명'.
        GS_FIELDCAT-COL_POS    = 3.
      WHEN 'AUQUA'.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
      WHEN 'NETPR'.
        GS_FIELDCAT-CFIELDNAME = 'WAERS'.
      WHEN 'AUAMO'.
        GS_FIELDCAT-CFIELDNAME = 'WAERS'.
      WHEN 'ICON'.
        GS_FIELDCAT-NO_OUT = ABAP_ON.

      WHEN 'STATUS'.
        GS_FIELDCAT-NO_OUT = ABAP_ON.
      WHEN 'SBELNR'.
        GS_FIELDCAT-NO_OUT = ABAP_ON.


    ENDCASE.

    MODIFY GT_FIELDCAT FROM GS_FIELDCAT.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_LAYOUT_0160
*&---------------------------------------------------------------------*
FORM SET_ALV_LAYOUT_0160 .

  CLEAR GS_LAYOUT.
  CLEAR GS_VARIANT.
  CLEAR GV_SAVE3.

  GS_VARIANT-REPORT = SY-REPID.
  GV_SAVE2 = 'A'.   " '' : Layout 저장불가

  GS_LAYOUT-CWIDTH_OPT = 'A'.               " 열 최적화
  GS_LAYOUT-ZEBRA      = ABAP_ON.           " ZEBRA
  GS_LAYOUT-SEL_MODE   = 'B'.               " 열 단위 선택
*  GS_LAYOUT-GRID_TITLE = TEXT-T01.          " ALV TITLE TEXT
  GS_LAYOUT-INFO_FNAME = 'COLOR'.           " 행 색상
  GS_LAYOUT-STYLEFNAME = 'STYLE'.          " 스타일

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_NUMBER
*&---------------------------------------------------------------------*
FORM CREATE_NUMBER .

  DATA LV_MSG TYPE STRING.

  DATA LV_SUBRC TYPE I.
  DATA LS_SDT110 TYPE ZEA_SDT110.  " 출고문서 아이템


  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      NR_RANGE_NR             = '01'                 " Number range number
      OBJECT                  = 'ZEA_SBELNR'                 " Name of number range object
    IMPORTING
      NUMBER                  = ZEA_SDT060-SBELNR                 " free number
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

*  REPLACE FIRST OCCURRENCE OF '00' IN ZEA_SDT060-SBELNR WITH 'SL'.
  ZEA_SDT060-SBELNR(2) = 'SL'.
*  ZEA_SDT060-VBELN  = . 이미 화면에 출력중
  ZEA_SDT060-CUSCODE  = ZEA_SDT040-CUSCODE.
  ZEA_SDT060-ADRNR    = ZEA_SDT040-SADDR.
  ZEA_SDT060-WERKS    = GV_LIST.

* 출고 요청일이 오늘보다 늦을 경우 -> 출고대기
* 출고 요청일 = 오늘 날짜          -> 출고완료
  IF ZEA_SDT060-RQDAT LE SY-DATUM.
    ZEA_SDT060-RQDAT    = ZEA_SDT060-RQDAT. " 출고요청일
    ZEA_SDT060-REDAT    = SY-DATUM. " 출고일
    ZEA_SDT060-RETSU    = '출고 완료'.
    ZEA_SDT060-DESTU    = '배송중'.
  ELSE.
    ZEA_SDT060-RQDAT    = ZEA_SDT060-RQDAT. " 출고요청일
    ZEA_SDT060-REDAT    = ZEA_SDT060-RQDAT. " 출고일
    ZEA_SDT060-RETSU    = '출고 대기'.
    ZEA_SDT060-DESTU    = '배송 대기'.
  ENDIF.

  ZEA_SDT060-DQDAT    =  ZEA_SDT040-VDATU. " 이미 화면에 출력중 배송 요청일
*  ZEA_SDT060-DADAT    = " 이미 화면에 출력중
*  ZEA_SDT060-STATUS   = ?
  ZEA_SDT060-ERDAT = SY-DATUM.
  ZEA_SDT060-ERNAM = SY-UNAME.
  ZEA_SDT060-ERZET = SY-UZEIT.

  INSERT ZEA_SDT060 .

  IF SY-SUBRC NE 0.
    LV_SUBRC = 4.
    ROLLBACK WORK.
    MESSAGE '출고 문서 데이터 추가에 실패했습니다.' TYPE 'E'.
    EXIT.
  ENDIF.


*--- 출하 운송 아이템 테이블에 저장

  MOVE-CORRESPONDING ZEA_SDT060  TO LS_SDT110.
  MOVE-CORRESPONDING GS_DISPLAY2 TO LS_SDT110.

  LS_SDT110-SBELNR  = ZEA_SDT060-SBELNR.
  LS_SDT110-POSNR   = '0010'.
*  LS_SDT110-VBELN   = ZEA_SDT060-VBELN.
*  LS_SDT110-CUSCODE = ZEA_SDT060-CUSCODE.
*  LS_SDT110-ADRNR   = ZEA_SDT060-ADRNR.
*  LS_SDT110-WERKS   = GV_LIST.
  LS_SDT110-MATNR   = GS_DISPLAY2-MATNR.
*  LS_SDT110-AUQUA   = GS_DISPLAY2-AUQUA.
*  LS_SDT110-MEINS   = GS_DISPLAY2-MEINS.
*  LS_SDT110-STATUS  = GS_DISPLAY2-STATUS.
  LS_SDT110-ERDAT = SY-DATUM.
  LS_SDT110-ERNAM = SY-UNAME.
  LS_SDT110-ERZET = SY-UZEIT.




  INSERT ZEA_SDT110 FROM LS_SDT110. " 출하 운송 아이템에 Insert

  IF SY-SUBRC NE 0.
    LV_SUBRC = 4.
    ROLLBACK WORK.
    MESSAGE '출고 문서 데이터 추가에 실패했습니다.' TYPE 'E'.
    EXIT.
  ENDIF.

*-- 판매 오더 아이템 상태플래그에 업데이트
  UPDATE ZEA_SDT050 SET STATUS = 'X'
                        AENAM  = SY-UNAME
                        AEDAT  = SY-DATUM
                        AEZET  = SY-UZEIT
                                       WHERE VBELN EQ ZEA_SDT040-VBELN
                                       AND POSNR EQ GS_DISPLAY2-POSNR.
  SORT GT_DISPLAY2 BY ICON DESCENDING.

  COMMIT WORK AND WAIT.

  " 판매오더 아이템의 아이콘 변경
  GS_DISPLAY2-SBELNR = ZEA_SDT060-SBELNR.
  GS_DISPLAY2-ICON = ICON_LED_GREEN.
  MODIFY GT_DISPLAY2 FROM GS_DISPLAY2 TRANSPORTING ICON SBELNR WHERE VBELN EQ GS_DISPLAY2-VBELN
                                                                 AND POSNR EQ GS_DISPLAY2-POSNR.

  SELECT COUNT(*)
    FROM ZEA_SDT050
   WHERE VBELN  EQ ZEA_SDT060-VBELN
     AND STATUS NE 'X'.

  IF SY-SUBRC EQ 0.

*-- 판매 오더 헤더 상태플래그에 업데이트
    UPDATE ZEA_SDT040 SET STATUS = 'I'
                          AENAM  = SY-UNAME
                          AEDAT  = SY-DATUM
                          AEZET  = SY-UZEIT
                          WHERE VBELN EQ ZEA_SDT060-VBELN.


    " 판매오더 헤더의 아이콘 변경
    READ TABLE GT_DISPLAY INTO GS_DISPLAY WITH KEY VBELN = GS_DISPLAY2-VBELN.
    IF SY-SUBRC EQ 0.
      GS_DISPLAY-ICON = ICON_LED_YELLOW.
      MODIFY GT_DISPLAY FROM GS_DISPLAY INDEX SY-TABIX.
      SORT GT_DISPLAY BY ICON.
    ENDIF.

  ELSE.

*-- 판매 오더 헤더 상태플래그에 업데이트
    UPDATE ZEA_SDT040 SET STATUS = 'X'
                          AENAM  = SY-UNAME
                          AEDAT  = SY-DATUM
                          AEZET  = SY-UZEIT
                          WHERE VBELN EQ ZEA_SDT060-VBELN.

    " 판매오더 헤더의 아이콘 변경
    READ TABLE GT_DISPLAY INTO GS_DISPLAY WITH KEY VBELN = GS_DISPLAY2-VBELN.
    IF SY-SUBRC EQ 0.
      GS_DISPLAY-ICON = ICON_LED_GREEN.
      MODIFY GT_DISPLAY FROM GS_DISPLAY INDEX SY-TABIX.
      SORT GT_DISPLAY BY ICON.
    ENDIF.

  ENDIF.

*  PERFORM SBELNR_DATA.
*  GS_DISPLAY2-SBELNR = ZEA_SDT060-SBELNR.

*  LOOP AT GT_DISPLAY2 INTO GS_DISPLAY2.
*
*    GS_DISPLAY2-SBELNR = ZEA_SDT060-SBELNR.
*
*
*    ENDLOOP.
*    APPEND GS_DISPLAY2 TO GT_DISPLAY2.

*  PERFORM REFRESH_ALV_0100.

  GO_ALV_GRID_1->REFRESH_TABLE_DISPLAY( IS_STABLE = VALUE #( ROW = 'X' COL = 'X' ) ).
  GO_ALV_GRID_2->REFRESH_TABLE_DISPLAY( IS_STABLE = VALUE #( ROW = 'X' COL = 'X' ) ).

  LV_MSG = |출고 문서 번호 { ZEA_SDT060-SBELNR } 가 생성되었습니다. |.


  DATA: IS_HEAD TYPE ZEA_MMT090,
        IT_ITEM TYPE ZEA_MMY100.

  DATA: EV_RETURN(1), LV_RETURN(1).
*
  IF LV_SUBRC EQ 0.
    COMMIT WORK AND WAIT.
*
* [오류보고] 2024.05.04 : FI 테스트를 위해서 실행하였으나, MM함수 Exporting IS_HEAD, IT_ITEM 내보내는 값이 없음.
*                         (자재문서번호는 EXPORTING 시 제외하고 테스트 중)

    CALL FUNCTION 'ZEA_MM_SDFG'
      EXPORTING
        IV_SBELNR = ZEA_SDT060-SBELNR   "출고문서번호
        IV_POSNR  = LS_SDT110-POSNR     "출고문서 품목번호
      IMPORTING
        ES_HEAD   = IS_HEAD             "[MM] 자재문서 Header
        ET_ITEM   = IT_ITEM             "자재문서 ITEM 테이블타입
        EV_RETURN = LV_RETURN.          " Message Type('S':성공, 'E':실패)

    CALL FUNCTION 'ZEA_FI_WL'
      EXPORTING
        IS_HEAD = IS_HEAD                 " [MM] 자재문서 Header
        IT_ITEM = IT_ITEM.                 " 자재문서 ITEM 테이블타입
*        IV_MBLNR = IV_MBLNR.                 " 자재문서 번호



    MESSAGE LV_MSG TYPE 'S'.

  ELSE.
    ROLLBACK WORK.
    MESSAGE S016 DISPLAY LIKE 'E'. "데이터 저장 중 오류가 발생했습니다.
  ENDIF.

*
*
*
*
*
*  SELECT *
*  FROM ZEA_SDT040 AS A
*  JOIN ZEA_KNA1 AS B
*    ON B~CUSCODE EQ A~CUSCODE
*  INTO CORRESPONDING FIELDS OF TABLE GT_DATA
*  WHERE A~STATUS2 = 'X'.
*
*  SORT GT_DATA BY VBELN CUSCODE.
*
**  LOOP AT GT_DISPLAY INTO GS_DISPLAY.
**    IF GS_DISPLAY-STATUS EQ 'X'.
**      GS_DISPLAY-ICON = ICON_LED_GREEN.
**    ELSEIF GS_DISPLAY-STATUS EQ 'I'.
**      GS_DISPLAY-ICON = ICON_LED_YELLOW.
**    ELSE.
**      GS_DISPLAY-ICON = ICON_LED_RED.
**    ENDIF.
**
**    MODIFY GT_DISPLAY FROM GS_DISPLAY.
**  ENDLOOP.
*  REFRESH GT_DISPLAY.
*  PERFORM SELECT_DISPLAY_DATA.
**  PERFORM MODIFY_DISPLAY_DATA.
**  PERFORM MAKE_DISPLAY_DATA.
**--------------------------------------------------------------------*
*
*  REFRESH GT_DISPLAY2.
*  CLEAR GS_DISPLAY2.
*
*  SELECT A~STATUS A~VBELN A~POSNR A~MATNR
*       C~MAKTX A~AUQUA A~MEINS A~NETPR
*       A~AUAMO A~WAERS
* FROM ZEA_SDT050 AS A
* JOIN ZEA_SDT040 AS B
*   ON B~VBELN EQ A~VBELN
* JOIN ZEA_MMT020 AS C
*   ON C~MATNR EQ A~MATNR
*  AND SPRAS EQ SY-LANGU
* INTO CORRESPONDING FIELDS OF TABLE GT_DATA2
* WHERE A~VBELN EQ LS_SDT110-VBELN.
*
*  SORT GT_DATA2 BY STATUS VBELN.
*
*  REFRESH GT_DISPLAY2.
*  PERFORM MAKE_DISPLAY2_DATA.
*
**  LOOP AT GT_DISPLAY2 INTO GS_DISPLAY2.
**    IF GS_DISPLAY2-STATUS EQ 'X'.
**      GS_DISPLAY-ICON = ICON_LED_GREEN.
**    ELSEIF GS_DISPLAY2-STATUS EQ ''.
**      GS_DISPLAY-ICON = ICON_LED_RED.
**    ENDIF.
**
**    MODIFY GT_DISPLAY2 FROM GS_DISPLAY2.
**  ENDLOOP.
*
*
*  DATA(LV_COUNT2) = REDUCE I( INIT COUNT = 0 FOR WA IN GT_DISPLAY2
*                    WHERE ( STATUS = 'X' ) NEXT COUNT = COUNT + 1 ).
*  DATA(LV_COUNT3) = LINES( GT_DISPLAY2 ).
*
*  IF LV_COUNT2 EQ LV_COUNT3.
*
**--- 판매 오더 헤더 테이블 STATUS에 값 저장 로직
*    SELECT SINGLE *
*      FROM ZEA_SDT040
*      INTO CORRESPONDING FIELDS OF ZEA_SDT040
*      WHERE VBELN EQ ZEA_SDT040-VBELN.
*
**-- 판매 오더 헤더 상태플래그에 업데이트
*    UPDATE ZEA_SDT040 SET STATUS = 'X'
*    WHERE VBELN EQ ZEA_SDT040-VBELN.
*
*    REFRESH GT_DATA.
*
*    SELECT *
*    FROM ZEA_SDT040 AS A
*    JOIN ZEA_KNA1 AS B
*      ON B~CUSCODE EQ A~CUSCODE
*    INTO CORRESPONDING FIELDS OF TABLE GT_DATA.
*
*    SORT GT_DATA BY VBELN CUSCODE.
*
**    PERFORM MAKE_DISPLAY_DATA.
*  ENDIF.
*
*  PERFORM SELECT_DISPLAY_DATA.
*  PERFORM MODIFY_DISPLAY_DATA.
*  PERFORM REFRESH_ALV_0100.
*
*
*
*  IF LV_SUBRC EQ 0.
*    COMMIT WORK AND WAIT.
*    MESSAGE S015. "데이터가 성공적으로 저장되었습니다.
*  ELSE.
*    ROLLBACK WORK.
*    MESSAGE S016 DISPLAY LIKE 'E'. "데이터 저장 중 오류가 발생했습니다.
*  ENDIF.





ENDFORM.
*&---------------------------------------------------------------------*
*& Form NOT_CREATE_NUMBER
*&---------------------------------------------------------------------*
FORM NOT_CREATE_NUMBER USING PV_SBELNR TYPE ZEA_SDT060-SBELNR.

  DATA LV_MSG2 TYPE STRING.

  SELECT MAX( POSNR )
    FROM ZEA_SDT110
    INTO ZEA_SDT110-POSNR
    WHERE SBELNR EQ PV_SBELNR.


  ZEA_SDT060-SBELNR = PV_SBELNR.
*  ZEA_SDT060-VBELN  = . 이미 화면에 출력중
  ZEA_SDT060-CUSCODE  = ZEA_SDT040-CUSCODE.
  ZEA_SDT060-ADRNR    = ZEA_SDT040-SADDR.
  ZEA_SDT060-WERKS    = GV_LIST.
  ZEA_SDT060-RETSU    = '출고 완료'.
  ZEA_SDT060-RQDAT    = SY-DATUM. " 출고요청일
*  ZEA_SDT060-REDAT    = . " 출고일
  ZEA_SDT060-DQDAT    =  " 이미 화면에 출력중 배송 요청일
*  ZEA_SDT060-DADAT    = " 이미 화면에 출력중
  ZEA_SDT060-DESTU    = '배송중'.
*  ZEA_SDT060-STATUS   = ?
  ZEA_SDT060-ERDAT = SY-DATUM.
  ZEA_SDT060-ERNAM = SY-UNAME.
  ZEA_SDT060-ERZET = SY-UZEIT.


*--- 출하 운송 아이템 테이블에 저장
  DATA LS_SDT110 TYPE ZEA_SDT110.
  MOVE-CORRESPONDING ZEA_SDT060  TO LS_SDT110.
  MOVE-CORRESPONDING GS_DISPLAY2 TO LS_SDT110.

  LS_SDT110-SBELNR  = ZEA_SDT060-SBELNR.
  LS_SDT110-POSNR   = ZEA_SDT110-POSNR + 10.
*  LS_SDT110-VBELN   = ZEA_SDT060-VBELN.
*  LS_SDT110-CUSCODE = ZEA_SDT060-CUSCODE.
*  LS_SDT110-ADRNR   = ZEA_SDT060-ADRNR.
*  LS_SDT110-WERKS   = GV_LIST.
  LS_SDT110-MATNR   = GS_DISPLAY2-MATNR.
*  LS_SDT110-AUQUA   = GS_DISPLAY2-AUQUA.
*  LS_SDT110-MEINS   = GS_DISPLAY2-MEINS.
*  LS_SDT110-STATUS  = GS_DISPLAY2-STATUS.
  LS_SDT110-ERDAT = SY-DATUM.
  LS_SDT110-ERNAM = SY-UNAME.
  LS_SDT110-ERZET = SY-UZEIT.


  INSERT ZEA_SDT110 FROM LS_SDT110. " 출하 운송 아이템에 Insert

  IF SY-SUBRC NE 0.
*    LV_SUBRC = 4.
    ROLLBACK WORK.
    MESSAGE '출고 문서 데이터 추가에 실패했습니다.' TYPE 'E'.
    EXIT.
  ENDIF.

*-- 판매 오더 아이템 상태플래그에 업데이트
  UPDATE ZEA_SDT050 SET STATUS = 'X'
                        AENAM  = SY-UNAME
                        AEDAT  = SY-DATUM
                        AEZET  = SY-UZEIT
                        WHERE VBELN EQ ZEA_SDT060-VBELN
                        AND POSNR EQ GS_DISPLAY2-POSNR.

  COMMIT WORK AND WAIT.

  " 판매오더 아이템의 아이콘 변경
  GS_DISPLAY2-SBELNR = ZEA_SDT060-SBELNR.
  GS_DISPLAY2-ICON = ICON_LED_GREEN.
  MODIFY GT_DISPLAY2 FROM GS_DISPLAY2 TRANSPORTING ICON SBELNR WHERE VBELN EQ GS_DISPLAY2-VBELN
                                                                 AND POSNR EQ GS_DISPLAY2-POSNR.

  SELECT COUNT(*)
    FROM ZEA_SDT050
   WHERE VBELN  EQ ZEA_SDT060-VBELN
     AND STATUS NE 'X'.

  IF SY-SUBRC EQ 0.

*-- 판매 오더 헤더 상태플래그에 업데이트
    UPDATE ZEA_SDT040 SET STATUS = 'I'
                          AENAM  = SY-UNAME
                          AEDAT  = SY-DATUM
                          AEZET  = SY-UZEIT
                          WHERE VBELN EQ ZEA_SDT060-VBELN.


    " 판매오더 헤더의 아이콘 변경
    READ TABLE GT_DISPLAY INTO GS_DISPLAY WITH KEY VBELN = GS_DISPLAY2-VBELN.
    IF SY-SUBRC EQ 0.
      GS_DISPLAY-ICON = ICON_LED_YELLOW.
      MODIFY GT_DISPLAY FROM GS_DISPLAY INDEX SY-TABIX.
      SORT GT_DISPLAY BY ICON.
    ENDIF.

  ELSE.

*-- 판매 오더 헤더 상태플래그에 업데이트
    UPDATE ZEA_SDT040 SET STATUS = 'X'
                          AENAM  = SY-UNAME
                          AEDAT  = SY-DATUM
                          AEZET  = SY-UZEIT
                          WHERE VBELN EQ ZEA_SDT060-VBELN.

    " 판매오더 헤더의 아이콘 변경
    READ TABLE GT_DISPLAY INTO GS_DISPLAY WITH KEY VBELN = GS_DISPLAY2-VBELN.
    IF SY-SUBRC EQ 0.
      GS_DISPLAY-ICON = ICON_LED_GREEN.
      MODIFY GT_DISPLAY FROM GS_DISPLAY INDEX SY-TABIX.
      SORT GT_DISPLAY BY ICON.
    ENDIF.

  ENDIF.

  LV_MSG2 = |출고 문서 번호 { PV_SBELNR } 가 생성되었습니다. |.

  DATA: IS_HEAD  TYPE ZEA_MMT090,
*        IT_ITEM  TYPE TABLE OF ZEA_MMT100.
        IT_ITEM  TYPE ZEA_MMY100.

   DATA: EV_RETURN(1), LV_RETURN(1).

  IF SY-SUBRC EQ 0.
    COMMIT WORK AND WAIT.


    CALL FUNCTION 'ZEA_MM_SDFG'
      EXPORTING
        IV_SBELNR = ZEA_SDT060-SBELNR   "출고문서번호
        IV_POSNR  = LS_SDT110-POSNR     "출고문서 품목번호
      IMPORTING
        ES_HEAD   = IS_HEAD             "[MM] 자재문서 Header
        ET_ITEM   = IT_ITEM             "자재문서 ITEM 테이블타입
        EV_RETURN = LV_RETURN.          " Message Type('S':성공, 'E':실패)

    CALL FUNCTION 'ZEA_FI_WL'
      EXPORTING
        IS_HEAD = IS_HEAD                 " [MM] 자재문서 Header
        IT_ITEM = IT_ITEM.                 " 자재문서 ITEM 테이블타입

  ELSE.
    ROLLBACK WORK.
    MESSAGE S016 DISPLAY LIKE 'E'. "데이터 저장 중 오류가 발생했습니다.
  ENDIF.

*  PERFORM SBELNR_DATA.
*  GS_DISPLAY2-SBELNR = PV_SBELNR.

* LOOP AT GT_DISPLAY2 INTO GS_DISPLAY2.
*
*    GS_DISPLAY2-SBELNR = PV_SBELNR.
*
*
*    ENDLOOP.
*    APPEND GS_DISPLAY2 TO GT_DISPLAY2.

  PERFORM REFRESH_ALV_0100.



**
***  DATA LV_MSG TYPE STRING.
**
**  DATA LV_SUBRC TYPE I.
***  DATA LV_SBELNR TYPE ZEA_SDT060-SBELNR.
**  DATA LT_SDT110 TYPE TABLE OF ZEA_SDT110.
**  DATA LS_SDT110 TYPE ZEA_SDT110.
**
**  DATA LT_SDT040 TYPE TABLE OF ZEA_SDT040.
**  DATA LS_SDT040 TYPE ZEA_SDT040.
**
**  DATA LT_INDEX_ROWS TYPE LVC_T_ROW.
**  DATA LS_INDEX_ROW LIKE LINE OF LT_INDEX_ROWS.
**
**  CALL METHOD GO_ALV_GRID_3->GET_SELECTED_ROWS
**    IMPORTING
**      ET_INDEX_ROWS = LT_INDEX_ROWS     " Indexes of Selected Rows
***     ET_ROW_NO     =                  " Numeric IDs of Selected Rows
**    .
**
***  SELECT SINGLE SBELNR
***    INTO LV_SBELNR
***    FROM ZEA_SDT060
***    WHERE VBELN EQ GS_DISPLAY-VBELN.
**
**  SELECT MAX( POSNR )
**    FROM ZEA_SDT110
**    INTO ZEA_SDT110-POSNR
**    WHERE SBELNR EQ PV_SBELNR.
**
**  ZEA_SDT110-POSNR = ZEA_SDT110-POSNR + 10.
**  ZEA_SDT060-SBELNR = PV_SBELNR.
**
***--- 출하 운송 아이템 테이블에 저장
***  LOOP AT GT_DISPLAY INTO GS_DISPLAY.
**
**  MOVE-CORRESPONDING GS_DISPLAY2 TO LS_SDT110.
**
**  LS_SDT110-SBELNR  = PV_SBELNR.
**  LS_SDT110-POSNR   = ZEA_SDT110-POSNR.
**  LS_SDT110-VBELN   = ZEA_SDT060-VBELN.
**  LS_SDT110-CUSCODE = ZEA_SDT040-CUSCODE.
**  LS_SDT110-ADRNR   = GS_DISPLAY-SADDR.
**  LS_SDT110-WERKS   = GV_LIST.
**  LS_SDT110-MATNR   = ZEA_SDT050-MATNR.
**  LS_SDT110-MEINS   = GS_DISPLAY2-MEINS.
**  LS_SDT110-ERDAT = SY-DATUM.
**  LS_SDT110-ERNAM = SY-UNAME.
**  LS_SDT110-ERZET = SY-UZEIT.
**
**
**  INSERT ZEA_SDT110 FROM LS_SDT110. " 출하 운송 아이템에 Insert
**
**  IF SY-SUBRC NE 0.
**    LV_SUBRC = 4.
**    ROLLBACK WORK.
**  ENDIF.
**
***  ENDLOOP.
**
***--- 판매 오더 헤더 테이블 STATUS에 값 저장 로직
**  SELECT SINGLE *
**    FROM ZEA_SDT040
**    INTO CORRESPONDING FIELDS OF ZEA_SDT040
**    WHERE VBELN EQ ZEA_SDT040-VBELN.
**
***-- 판매 오더 헤더 상태플래그에 업데이트
**  UPDATE ZEA_SDT040 SET STATUS = 'I'
**  WHERE VBELN EQ ZEA_SDT040-VBELN.
**
***--- 판매 오더 아이템 테이블 STATUS에 값 저장 로직
**  SELECT SINGLE *
**    FROM ZEA_SDT050
**    INTO CORRESPONDING FIELDS OF ZEA_SDT050
**    WHERE VBELN EQ ZEA_SDT060-VBELN.
**
***-- 판매 오더 아이템 상태플래그에 업데이트
**  UPDATE ZEA_SDT050 SET STATUS = 'X'
**  WHERE VBELN EQ ZEA_SDT060-VBELN
**    AND POSNR EQ LS_SDT110-POSNR.
**
**  SELECT *
**  FROM ZEA_SDT040 AS A
**  JOIN ZEA_KNA1 AS B
**    ON B~CUSCODE EQ A~CUSCODE
**  INTO CORRESPONDING FIELDS OF TABLE GT_DATA.
**
**  SORT GT_DATA BY VBELN CUSCODE.
**
***  LOOP AT GT_DISPLAY INTO GS_DISPLAY.
***    IF GS_DISPLAY-STATUS EQ 'X'.
***      GS_DISPLAY-ICON = ICON_LED_GREEN.
***    ELSEIF GS_DISPLAY-STATUS EQ 'I'.
***      GS_DISPLAY-ICON = ICON_LED_YELLOW.
***    ELSE.
***      GS_DISPLAY-ICON = ICON_LED_RED.
***    ENDIF.
***
***    MODIFY GT_DISPLAY FROM GS_DISPLAY.
***  ENDLOOP.
**  REFRESH GT_DISPLAY.
**  PERFORM SELECT_DISPLAY_DATA.
***  PERFORM MODIFY_DISPLAY_DATA.
***  PERFORM MAKE_DISPLAY_DATA.
***--------------------------------------------------------------------*
**
**  REFRESH GT_DISPLAY2.
**  CLEAR GS_DISPLAY2.
**
**  SELECT A~STATUS A~VBELN A~POSNR A~MATNR
**       C~MAKTX A~AUQUA A~MEINS A~NETPR
**       A~AUAMO A~WAERS
** FROM ZEA_SDT050 AS A
** JOIN ZEA_SDT040 AS B
**   ON B~VBELN EQ A~VBELN
** JOIN ZEA_MMT020 AS C
**   ON C~MATNR EQ A~MATNR
**  AND SPRAS EQ SY-LANGU
** INTO CORRESPONDING FIELDS OF TABLE GT_DATA2
** WHERE A~VBELN EQ LS_SDT110-VBELN.
**
**  SORT GT_DATA2 BY STATUS VBELN.
**
**  REFRESH GT_DISPLAY2.
**
**  PERFORM SELECT_DISPLAY_DATA.
**  PERFORM MAKE_DISPLAY2_DATA.
**
***  LOOP AT GT_DISPLAY2 INTO GS_DISPLAY2.
***    IF GS_DISPLAY2-STATUS EQ 'X'.
***      GS_DISPLAY-ICON = ICON_LED_GREEN.
***    ELSEIF GS_DISPLAY2-STATUS EQ ''.
***      GS_DISPLAY-ICON = ICON_LED_RED.
***    ENDIF.
***
***    MODIFY GT_DISPLAY2 FROM GS_DISPLAY2.
***  ENDLOOP.
**
**
**  DATA(LV_COUNT2) = REDUCE I( INIT COUNT = 0 FOR WA IN GT_DISPLAY2
**                    WHERE ( STATUS = 'X' ) NEXT COUNT = COUNT + 1 ).
**  DATA(LV_COUNT3) = LINES( GT_DISPLAY2 ).
**
**  IF LV_COUNT2 EQ LV_COUNT3.
**
***--- 판매 오더 헤더 테이블 STATUS에 값 저장 로직
**    SELECT SINGLE *
**      FROM ZEA_SDT040
**      INTO CORRESPONDING FIELDS OF ZEA_SDT040
**      WHERE VBELN EQ ZEA_SDT040-VBELN.
**
***-- 판매 오더 헤더 상태플래그에 업데이트
**    UPDATE ZEA_SDT040 SET STATUS = 'X'
**    WHERE VBELN EQ ZEA_SDT040-VBELN.
**
**    REFRESH GT_DATA.
**
**    SELECT *
**    FROM ZEA_SDT040 AS A
**    JOIN ZEA_KNA1 AS B
**      ON B~CUSCODE EQ A~CUSCODE
**    INTO CORRESPONDING FIELDS OF TABLE GT_DATA.
**
**    SORT GT_DATA BY VBELN CUSCODE.
**
**    PERFORM SELECT_DISPLAY_DATA.
**
***    PERFORM MODIFY_DISPLAY_DATA.
***    PERFORM MAKE_DISPLAY_DATA.
**  ENDIF.
**
**  PERFORM MODIFY_DISPLAY_DATA.
**  PERFORM REFRESH_ALV_0100.
**
**
**  IF LV_SUBRC EQ 0.
**    COMMIT WORK AND WAIT.
**    MESSAGE S015. "데이터가 성공적으로 저장되었습니다.
**  ELSE.
**    ROLLBACK WORK.
**    MESSAGE S016 DISPLAY LIKE 'E'. "데이터 저장 중 오류가 발생했습니다.
**  ENDIF.
**
***  LV_MSG = |출고 문서번호 { PV_SBELNR } 이 생성되었습니다.|.
***  MESSAGE LV_MSG TYPE 'S'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_DISPLAY2_DATA
*&---------------------------------------------------------------------*
FORM MAKE_DISPLAY2_DATA .

*  DATA LS_STYLE TYPE LVC_S_STYL.
*
*  LOOP AT GT_DISPLAY2 INTO GS_DISPLAY2.
*
**신규 필드------------------------------------------------------------*
*
*    IF GS_DISPLAY2-STATUS = 'X'.
*      GS_DISPLAY2-ICON = ICON_LED_GREEN.
*    ELSEIF GS_DISPLAY2-STATUS = 'I'.
*      GS_DISPLAY2-ICON = ICON_LED_YELLOW.
*    ELSE.
*      GS_DISPLAY2-ICON = ICON_LED_RED.
*    ENDIF.
*
**--------------------------------------------------------------------*
*    MODIFY GT_DISPLAY2 FROM GS_DISPLAY2.
*
*  ENDLOOP.

  LOOP AT GT_DATA2 INTO GS_DATA2.

    CLEAR GS_DISPLAY2.

    MOVE-CORRESPONDING GS_DATA2 TO GS_DISPLAY2.

*신규 필드------------------------------------------------------------*

    IF GS_DISPLAY2-STATUS = 'X'.
      GS_DISPLAY2-ICON = ICON_LED_GREEN.
    ELSEIF GS_DISPLAY2-STATUS = ''.
      GS_DISPLAY2-ICON = ICON_LED_RED.
    ENDIF.

*    GS_DISPLAY2-SBELNR = ZEA_SDT060-SBELNR.

*--------------------------------------------------------------------*
    APPEND GS_DISPLAY2 TO GT_DISPLAY2.

  ENDLOOP.

  SORT GT_DISPLAY2 BY ICON ASCENDING.

ENDFORM.
*&---------------------------------------------------------------------*
*&
*&  아래는 재고량 검색을 위한 서브루틴들
*&
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT4_0100
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT4_0100 .

  CREATE OBJECT GO_CONTAINER_4
    EXPORTING
      CONTAINER_NAME = 'CCON4'
    EXCEPTIONS
      OTHERS         = 1.

  IF SY-SUBRC NE 0.
    MESSAGE E020. " Custom Container 생성 중 오류가 발생했습니다.
  ENDIF.

  CREATE OBJECT GO_ALV_GRID_4
    EXPORTING
      I_PARENT = GO_CONTAINER_4
    EXCEPTIONS
      OTHERS   = 1.

  IF SY-SUBRC NE 0.
    MESSAGE E021. " ALV Grid 생성 중 오류가 발생했습니다.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FIELDCAT4_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_FIELDCAT4_0100 .

  PERFORM GET_FIELDCAT4_0100     USING    GT_DATA4
                                 CHANGING GT_FIELDCAT4.

  PERFORM MAKE_FIELDCAT4_0100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_FIELDCAT4_0100
*&---------------------------------------------------------------------*
FORM GET_FIELDCAT4_0100  USING PT_TAB TYPE STANDARD TABLE
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
*& Form MAKE_FIELDCAT4_0100
*&---------------------------------------------------------------------*
FORM MAKE_FIELDCAT4_0100 .

  LOOP AT GT_FIELDCAT4 INTO GS_FIELDCAT4.

    CASE GS_FIELDCAT4-FIELDNAME.
      WHEN 'MATNR'.
*        GS_FIELDCAT-COLTEXT    = '자재명'.
        GS_FIELDCAT4-COL_POS    = 0.
*        GS_FIELDCAT4-NO_OUT  = ABAP_ON.

      WHEN 'MAKTX'.
        GS_FIELDCAT4-COL_POS    = 1.
        GS_FIELDCAT4-EMPHASIZE = 'C500'.

      WHEN 'WERKS'.
        GS_FIELDCAT4-COL_POS    = 2.

      WHEN 'PNAME1'.
        GS_FIELDCAT4-COL_POS    = 3.
        GS_FIELDCAT4-EMPHASIZE = 'C500'.

      WHEN 'SCODE'.
        GS_FIELDCAT4-COL_POS    = 4.

      WHEN 'CALQTY'.
        GS_FIELDCAT4-COL_POS    = 5.
        GS_FIELDCAT4-QFIELDNAME = 'MEINS'.
        GS_FIELDCAT4-EMPHASIZE = 'C300'.

      WHEN 'MEINS'.
        GS_FIELDCAT4-COL_POS    = 6.

      WHEN 'SUM_VALUE'.
        GS_FIELDCAT4-COL_POS    = 7.
        GS_FIELDCAT4-CFIELDNAME = 'WAERS'.
        GS_FIELDCAT4-NO_OUT     = ABAP_ON.

      WHEN 'WAERS'.
        GS_FIELDCAT4-COL_POS    = 8.
        GS_FIELDCAT4-NO_OUT     = ABAP_ON.





    ENDCASE.

    MODIFY GT_FIELDCAT4 FROM GS_FIELDCAT4.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_LAYOUT4_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_LAYOUT4_0100 .

  CLEAR GS_LAYOUT.
  CLEAR GS_VARIANT.
  CLEAR GV_SAVE2.

  GS_VARIANT-REPORT = SY-REPID.
  GV_SAVE2 = 'A'.   " '' : Layout 저장불가

  GS_LAYOUT-CWIDTH_OPT = 'A'.               " 열 최적화
  GS_LAYOUT-ZEBRA      = ABAP_ON.           " ZEBRA
  GS_LAYOUT-SEL_MODE   = 'B'.               " 열 단위 선택
*    GS_LAYOUT-GRID_TITLE = TEXT-T01.          " ALV TITLE TEXT
  GS_LAYOUT-INFO_FNAME = 'COLOR'.           " 행 색상
  GS_LAYOUT-STYLEFNAME = 'STYLE'.          " 스타일

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV4_0100
*&---------------------------------------------------------------------*

FORM DISPLAY_ALV4_0100 .

  CALL METHOD GO_ALV_GRID_4->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
      IS_VARIANT                    = GS_VARIANT
      I_SAVE                        = GV_SAVE2
      IS_LAYOUT                     = GS_LAYOUT
    CHANGING
      IT_OUTTAB                     = GT_DATA4
      IT_FIELDCATALOG               = GT_FIELDCAT4
    EXCEPTIONS
      INVALID_PARAMETER_COMBINATION = 1
      PROGRAM_ERROR                 = 2
      TOO_MANY_LINES                = 3
      OTHERS                        = 4.

  IF SY-SUBRC <> 0.
    " ALV Grid 에 데이터를 전달하는 중 오류가 발생했습니다.
    MESSAGE E023.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_DATA_MMT190
*&---------------------------------------------------------------------*
FORM SELECT_DATA_MMT190 .

  SELECT *
    FROM ZEA_MMT190 AS A
    JOIN ZEA_T001W AS B
    ON B~WERKS EQ A~WERKS
    JOIN ZEA_MMT020 AS C
    ON C~MATNR EQ A~MATNR
    INTO CORRESPONDING FIELDS OF TABLE GT_DATA4
    WHERE SPRAS EQ SY-LANGU
      AND A~MATNR LIKE '30%'.     " 자재코드가 30으로 시작하는 데이터만 조회

  SORT GT_DATA4 BY MATNR WERKS SCODE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_DATA_CONDITION
*&---------------------------------------------------------------------*
FORM SELECT_DATA_CONDITION .

  RANGES R_SCODE FOR ZEA_MMT190-SCODE.
  RANGES R_WERKS FOR ZEA_MMT190-WERKS.
  RANGES R_MATNR FOR ZEA_MMT190-MATNR.

  REFRESH R_SCODE[].
  CLEAR R_SCODE.
  REFRESH R_WERKS[].
  CLEAR R_WERKS.
  REFRESH R_MATNR[].
  CLEAR R_MATNR.

  IF ZEA_MMT190-SCODE IS NOT INITIAL.
    R_SCODE-SIGN    = 'I'.
    R_SCODE-OPTION  = 'EQ'.
    R_SCODE-LOW     = ZEA_MMT190-SCODE.
    APPEND R_SCODE.
  ENDIF.
  IF ZEA_MMT190-WERKS IS NOT INITIAL.
    R_WERKS-SIGN    = 'I'.
    R_WERKS-OPTION  = 'EQ'.
    R_WERKS-LOW     = ZEA_MMT190-WERKS.
    APPEND R_WERKS.
  ENDIF.
  IF ZEA_MMT190-MATNR IS NOT INITIAL.
    R_MATNR-SIGN    = 'I'.
    R_MATNR-OPTION  = 'EQ'.
    R_MATNR-LOW     = ZEA_MMT190-MATNR.
    APPEND R_MATNR.
  ENDIF.

  SELECT *
  FROM ZEA_MMT190 AS A
  JOIN ZEA_T001W AS B
  ON B~WERKS EQ A~WERKS
  JOIN ZEA_MMT020 AS C
  ON C~MATNR EQ A~MATNR
  INTO CORRESPONDING FIELDS OF TABLE GT_DATA4
  WHERE A~SCODE IN R_SCODE
    AND A~WERKS IN R_WERKS
    AND A~MATNR IN R_MATNR
    AND SPRAS EQ SY-LANGU
    AND A~MATNR LIKE '30%'.

  SORT GT_DATA4 BY MATNR WERKS SCODE.

*  CLEAR ZEA_MMT190-MATNR.
*  CLEAR ZEA_MMT190-WERKS.
*  CLEAR ZEA_T001W-PNAME1.
*  CLEAR ZEA_MMT020-MAKTX.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form INVOICE_ING_FILTER
*&---------------------------------------------------------------------*
FORM INVOICE_ING_FILTER .

  REFRESH GT_FILTER.

  CLEAR GS_FILTER.
  GS_FILTER-FIELDNAME = 'ICON'.
  GS_FILTER-SIGN      = 'I'.
  GS_FILTER-OPTION    = 'EQ'.
  GS_FILTER-LOW       = ICON_LED_YELLOW.
  APPEND GS_FILTER TO GT_FILTER.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_DATA_SDT040
*&---------------------------------------------------------------------*
FORM SELECT_DATA_SDT040 .

  RANGES R_VBELN FOR ZEA_SDT050-VBELN.
  RANGES R_CUSCODE FOR ZEA_SDT040-CUSCODE.
  RANGES R_VDATU FOR ZEA_SDT040-VDATU.

  REFRESH R_VBELN[].
  CLEAR R_VBELN.
  REFRESH R_CUSCODE[].
  CLEAR R_CUSCODE.
  REFRESH R_VDATU[].
  CLEAR R_VDATU.

  IF ZEA_SDT050-VBELN IS NOT INITIAL.
    R_VBELN-SIGN    = 'I'.
    R_VBELN-OPTION  = 'EQ'.
    R_VBELN-LOW     = ZEA_SDT050-VBELN.
    APPEND R_VBELN.
  ENDIF.
  IF ZEA_SDT040-CUSCODE IS NOT INITIAL.
    R_CUSCODE-SIGN    = 'I'.
    R_CUSCODE-OPTION  = 'EQ'.
    R_CUSCODE-LOW     = ZEA_SDT040-CUSCODE.
    APPEND R_CUSCODE.
  ENDIF.
  IF ZEA_SDT040-VDATU IS NOT INITIAL.
    R_VDATU-SIGN    = 'I'.
    R_VDATU-OPTION  = 'EQ'.
    R_VDATU-LOW     = ZEA_SDT040-VDATU.
    APPEND R_VDATU.
  ENDIF.

  SELECT *
  FROM ZEA_SDT040 AS A
  JOIN ZEA_KNA1 AS B
    ON B~CUSCODE EQ A~CUSCODE
*  JOIN ZEA_SDT050 AS C
*    ON A~VBELN EQ C~VBELN
  INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY
 WHERE A~VBELN   IN R_VBELN
   AND A~CUSCODE IN R_CUSCODE
   AND A~VDATU   IN R_VDATU
    AND A~STATUS2 = 'X'.

  SORT GT_DISPLAY BY VBELN CUSCODE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_DISPLAY_DATA2
*&---------------------------------------------------------------------*
FORM MAKE_DISPLAY_DATA2 .

  DATA LS_STYLE TYPE LVC_S_STYL.

*  REFRESH GT_DISPLAY.
*  REFRESH GT_DISPLAY2.

  LOOP AT GT_DISPLAY INTO GS_DISPLAY.

*신규 필드------------------------------------------------------------*

    IF GS_DISPLAY-STATUS = 'X'.
      GS_DISPLAY-ICON = ICON_LED_GREEN.
    ELSEIF GS_DISPLAY-STATUS = 'I'.
      GS_DISPLAY-ICON = ICON_LED_YELLOW.
    ELSE.
      GS_DISPLAY-ICON = ICON_LED_RED.
    ENDIF.

*--------------------------------------------------------------------*
    MODIFY GT_DISPLAY FROM GS_DISPLAY.

  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form MODIFY_DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM MODIFY_DISPLAY_DATA .


  DATA LS_STYLE TYPE LVC_S_STYL.

  LOOP AT GT_DISPLAY INTO GS_DISPLAY.

*신규 필드------------------------------------------------------------*

    IF GS_DISPLAY-STATUS = 'X'.
      GS_DISPLAY-ICON = ICON_LED_GREEN.
    ELSEIF GS_DISPLAY-STATUS = 'I'.
      GS_DISPLAY-ICON = ICON_LED_YELLOW.
    ELSE.
      GS_DISPLAY-ICON = ICON_LED_RED.
    ENDIF.

*--------------------------------------------------------------------*
    MODIFY GT_DISPLAY FROM GS_DISPLAY.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM SELECT_DISPLAY_DATA .

  REFRESH GT_DISPLAY.


  SELECT *
    FROM ZEA_SDT040 AS A
    JOIN ZEA_KNA1 AS B
      ON B~CUSCODE EQ A~CUSCODE
    INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY
    WHERE A~STATUS2 = 'X'.



  SORT GT_DISPLAY BY VBELN CUSCODE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_DATA_0100
*&---------------------------------------------------------------------*
FORM CREATE_DATA_0100 .

  DATA LT_INDEX_ROWS TYPE LVC_T_ROW.
  DATA LS_INDEX_ROW  TYPE LVC_S_ROW.

  CALL METHOD GO_ALV_GRID_2->GET_SELECTED_ROWS
    IMPORTING
      ET_INDEX_ROWS = LT_INDEX_ROWS.

  IF LT_INDEX_ROWS[] IS INITIAL.

    " 아이템만 한 줄 선택하도록 안내
    " TEXT-M01: 라인을 선택하세요.
    MESSAGE S000 DISPLAY LIKE 'W' WITH '최소 한 행이상 선택하세요'.

  ELSE.

    READ TABLE LT_INDEX_ROWS INTO LS_INDEX_ROW INDEX 1.
    READ TABLE GT_DISPLAY2   INTO GS_DISPLAY2  INDEX LS_INDEX_ROW-INDEX.

    IF SY-SUBRC EQ 0.
      IF GS_DISPLAY2-ICON EQ ICON_LED_GREEN.
        " 이미 생성된 출고 문서입니다.
        MESSAGE S032 DISPLAY LIKE 'E'.
      ELSE.
        _MC_POPUP_CONFIRM '출고 문서 생성' '출고 문서를 생성하시겠습니까?' GV_ANSWER.
        CHECK GV_ANSWER = '1'.

        PERFORM MOVE_DATA.
        CALL SCREEN 0160 STARTING AT 50 5.
      ENDIF.

    ENDIF.


  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form SBELNR_DATA
*&---------------------------------------------------------------------*
FORM SBELNR_DATA .

  SELECT A~STATUS, A~VBELN, A~POSNR, A~MATNR,
       C~MAKTX ,A~AUQUA ,A~MEINS ,A~NETPR,
       A~AUAMO ,A~WAERS, B~SBELNR
*              D~SBELNR
      FROM ZEA_SDT050 AS A     " 판매오더 헤더
      JOIN ZEA_MMT020 AS C     " 자재 TEXT
       ON C~MATNR EQ A~MATNR
      AND SPRAS EQ @SY-LANGU
      LEFT OUTER JOIN ZEA_SDT110 AS B
        ON B~VBELN EQ A~VBELN
       AND B~MATNR EQ A~MATNR
      INTO CORRESPONDING FIELDS OF TABLE @GT_DATA2
      WHERE A~VBELN EQ @GS_DISPLAY-VBELN.

    SORT GT_DATA2 BY STATUS POSNR.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MMT190_F4_HELP
*&---------------------------------------------------------------------*
FORM MMT190_F4_HELP .

  DATA: LT_RETURN_TAB TYPE DDSHRETVAL OCCURS 0,
        LS_RETURN_TAB LIKE LINE OF LT_RETURN_TAB.

  DATA: LT_DSELC TYPE DSELC OCCURS 0,
        LS_DSELC LIKE LINE OF LT_DSELC.

  DATA: LS_VALUE  TYPE SEAHLPRES,
        LT_VALUE  TYPE TABLE OF SEAHLPRES,
        LS_FIELD  TYPE DFIES,
        LT_FIELDS TYPE TABLE OF DFIES.

  DATA: BEGIN OF LT190_MATNR OCCURS 0,
          MATNR TYPE ZEA_MMT190-MATNR,
          MAKTX TYPE ZEA_MMT020-MAKTX,
        END OF LT190_MATNR.

  DATA: LT_MAP TYPE TABLE OF DSELC WITH HEADER LINE.

  CLEAR : LT190_MATNR, LT190_MATNR[],
           LT_VALUE, LT_VALUE[],
           LT_FIELDS, LT_FIELDS[].

  SELECT DISTINCT A~MATNR
          B~MAKTX
          INTO TABLE LT190_MATNR
         FROM ZEA_MMT190 AS A
         JOIN ZEA_MMT020 AS B
           ON B~MATNR EQ A~MATNR
          AND B~SPRAS EQ SY-LANGU
          WHERE A~MATNR LIKE '30%'.

  SORT LT190_MATNR BY MATNR.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      RETFIELD        = 'MATNR'           " Name of return field in FIELD_TAB
      DYNPPROG        = SY-REPID          " Current program
      DYNPNR          = SY-DYNNR          " Screen number
*     DYNPROFIELD     = 'ZEA_MMT010-MATNR'
      WINDOW_TITLE    = '판가 생성'        " Title for the hit list
      VALUE_ORG       = 'S'               " Value return: C: cell by cell, S: structured
    TABLES
*     FIELD_TAB       = LT_FIELDS[]
      VALUE_TAB       = LT190_MATNR[]                 " Table of values: entries cell by cell
      RETURN_TAB      = LT_RETURN_TAB[]
*     DYNPFLD_MAPPING = LT_MAP
    EXCEPTIONS
      PARAMETER_ERROR = 1                " Incorrect parameter
      NO_VALUES_FOUND = 2                " No values found
      OTHERS          = 3.

  IF SY-SUBRC EQ 0.
    READ TABLE LT_RETURN_TAB INTO LS_RETURN_TAB INDEX 1.
    IF SY-SUBRC EQ 0.
      ZEA_MMT190-MATNR = LS_RETURN_TAB-FIELDVAL.

      READ TABLE LT190_MATNR WITH KEY MATNR = ZEA_MMT190-MATNR BINARY SEARCH.
      IF SY-SUBRC EQ 0.
        ZEA_MMT190-MATNR        = LT190_MATNR-MATNR.
        ZEA_MMT020-MAKTX        = LT190_MATNR-MAKTX.
*        ZEA_MMT010-STPRS        = LT_MATNR-STPRS.
*        ZEA_SDT090-NETPR        = LT_MATNR-STPRS * 4.
*        ZEA_MMT010-WAERS        = LT_MATNR-WAERS.

        LEAVE SCREEN.
      ENDIF.
    ENDIF.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form DEC_TABLE_DATA
*&---------------------------------------------------------------------*
FORM DEC_TABLE_DATA .

  " 삭제 플래그 값 없는 것들만 조회하고 배치번호로 정렬
  SELECT SINGLE *
    FROM ZEA_MMT190
    INTO GS_MMT190
    WHERE MATNR EQ ZEA_SDT050-MATNR
      AND WERKS EQ ZEA_SDT060-WERKS.
*    WHERE LVORM EQ ''.

*  SORT GT_MMT190 BY CHARG.

*  READ TABLE GT_MMT190 INTO GS_MMT190
*                       WITH KEY MATNR = ZEA_SDT050-MATNR
*                                WERKS = ZEA_SDT060-WERKS.
  IF SY-SUBRC EQ 0.
      IF GS_DISPLAY2-AUQUA > GS_MMT190-CALQTY.
        MESSAGE E037. " 재고가 부족합니다.
      ELSE.

    GS_MMT190-CALQTY = GS_MMT190-CALQTY - GS_DISPLAY2-AUQUA.

    UPDATE ZEA_MMT190 SET CALQTY = GS_MMT190-CALQTY
                          AENAM  = SY-UNAME
                          AEDAT  = SY-DATUM
                          AEZET  = SY-UZEIT
                    WHERE MATNR = ZEA_SDT050-MATNR
                      AND WERKS = ZEA_SDT060-WERKS.
      ENDIF.
  ENDIF.

  " itab GS_DISPLAY4에도 바로 반영되게 해야할듯.

  GS_DATA4-CALQTY = GS_MMT190-CALQTY.
  MODIFY GT_DATA4 FROM GS_DATA4 TRANSPORTING CALQTY WHERE WERKS EQ ZEA_SDT060-WERKS
                                                                AND MATNR EQ GS_DISPLAY2-MATNR.
*
*  READ TABLE GT_DATA4 INTO GS_DATA4 WITH KEY CALQTY = GS_DATA4-CALQTY.
*    IF SY-SUBRC EQ 0.
*      GS_DATA4-CALQTY = GS_DATA4-CALQTY - GS_DISPLAY2-AUQUA.
*      MODIFY GT_DATA4 FROM GS_DATA4 TRANSPORTING CALQTY.
*    ENDIF.



*    CALL FUNCTION 'SAPGUI_SET_FUNCTIONCODE'
*      EXPORTING
*        FUNCTIONCODE           = 'ENTE'              " Function code
*      EXCEPTIONS
*        FUNCTION_NOT_SUPPORTED = 1                " Not supported on this front end platform
*        OTHERS                 = 2
*      .
*    IF SY-SUBRC <> 0.
*     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*       WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*    ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DEC_BATCH_DATA
*&---------------------------------------------------------------------*
FORM DEC_BATCH_DATA .

  " 삭제 플래그 값 없는 것들만 조회하고 배치번호로 정렬
  SELECT *
    FROM ZEA_MMT070
    INTO TABLE GT_MMT070
    WHERE LVORM EQ ''.

  SORT GT_MMT070 BY CHARG.


  READ TABLE GT_MMT070 INTO GS_MMT070
                     WITH KEY MATNR = ZEA_SDT050-MATNR
                              WERKS = ZEA_SDT060-WERKS.
  IF SY-SUBRC EQ 0.
    " 1. 전체 수량 비교 -> IF
    IF GS_DISPLAY2-AUQUA > GS_MMT190-CALQTY.              " GS_MMT190에 DEC_TABLE_DATA를 통해서 값이 들어가 있음.
      MESSAGE E037. " 재고가 부족합니다.

      " 2. 필요수량에서 배치의 보유 수량만큼 제거(보유 수량이 같거나 적을 때만 제거)
      "     배치의 보유수량이 많으면 필요한 만큼만 제거.
    ELSE.


      IF GS_MMT070-REMQTY GT GS_DISPLAY2-AUQUA.

        GS_MMT070-REMQTY = GS_MMT070-REMQTY - GS_DISPLAY2-AUQUA.
        GS_DISPLAY2-AUQUA = 0.

        UPDATE ZEA_MMT070 SET REMQTY = GS_MMT070-REMQTY
                              AENAM  = SY-UNAME
                              AEDAT  = SY-DATUM
                              AEZET  = SY-UZEIT
                        WHERE MATNR = GS_MMT070-MATNR
                          AND WERKS = GS_MMT070-WERKS
                          AND CHARG = GS_MMT070-CHARG.

        " 배치번호 제일 빠른거 읽어 와서 WHERE 절에 ?

      ELSEIF GS_MMT070-REMQTY EQ GS_DISPLAY2-AUQUA.

        GS_MMT070-REMQTY = GS_MMT070-REMQTY - GS_DISPLAY2-AUQUA.
        GS_DISPLAY2-AUQUA = 0.

        UPDATE ZEA_MMT070 SET REMQTY = GS_MMT070-REMQTY
                              LVORM  = 'X' " 배치번호 제일 빠른것 '만' 삭제
                              AENAM  = SY-UNAME
                              AEDAT  = SY-DATUM
                              AEZET  = SY-UZEIT
                          WHERE MATNR = GS_MMT070-MATNR
                          AND WERKS = GS_MMT070-WERKS
                          AND CHARG = GS_MMT070-CHARG.



      ELSEIF GS_MMT070-REMQTY LT GS_DISPLAY2-AUQUA.



        LOOP AT GT_MMT070 INTO GS_MMT070 WHERE MATNR EQ GS_DISPLAY2-MATNR
                                           AND WERKS EQ ZEA_SDT060-WERKS.             " LOOP 탈출을 GS_DISPLAY2가 0 이 됐을때 탈출 하게.
          IF GS_DISPLAY2-AUQUA EQ 0.
            EXIT.
          ENDIF.
          " LOOP를 돌면서 배치번호가 다음으로 넘어가게는 어떻게?
          " SELECT 를 계속 해줘야하나? LOOP안에 SELECT는 문제가 많은데
          IF GS_MMT070-REMQTY LT GS_DISPLAY2-AUQUA.

            GS_DISPLAY2-AUQUA = GS_DISPLAY2-AUQUA - GS_MMT070-REMQTY.
            GS_MMT070-REMQTY = 0.

            UPDATE ZEA_MMT070 SET REMQTY = GS_MMT070-REMQTY
                                  LVORM  = 'X' " 배치번호 제일 빠른것 '만' 삭제
                                  AENAM  = SY-UNAME
                                  AEDAT  = SY-DATUM
                                  AEZET  = SY-UZEIT
                              WHERE MATNR = GS_MMT070-MATNR
                              AND WERKS = GS_MMT070-WERKS
                              AND CHARG = GS_MMT070-CHARG
                              AND LVORM NE 'X'.

          ELSEIF GS_MMT070-REMQTY EQ GS_DISPLAY2-AUQUA.

            GS_MMT070-REMQTY = 0.
            GS_DISPLAY2-AUQUA = 0.

            UPDATE ZEA_MMT070 SET REMQTY = GS_MMT070-REMQTY
                                  LVORM  = 'X' " 배치번호 제일 빠른것 '만' 삭제
                                  AENAM  = SY-UNAME
                                  AEDAT  = SY-DATUM
                                  AEZET  = SY-UZEIT
                              WHERE MATNR = GS_MMT070-MATNR
                              AND WERKS = GS_MMT070-WERKS
                              AND CHARG = GS_MMT070-CHARG
                              AND LVORM NE 'X'.

            " 3. 필요수량이 0이 아닌경우 2의 과정을 반복
            "    만약, 필요수량이 0인경우 종료.
          ELSEIF GS_MMT070-REMQTY GT GS_DISPLAY2-AUQUA.
            GS_MMT070-REMQTY = GS_MMT070-REMQTY - GS_DISPLAY2-AUQUA.
            GS_DISPLAY2-AUQUA = 0.

            UPDATE ZEA_MMT070 SET REMQTY = GS_MMT070-REMQTY
                                  AENAM  = SY-UNAME
                                  AEDAT  = SY-DATUM
                                  AEZET  = SY-UZEIT
                            WHERE MATNR = GS_MMT070-MATNR
                              AND WERKS = GS_MMT070-WERKS
                              AND CHARG = GS_MMT070-CHARG.
          ENDIF.

        ENDLOOP.

      ELSE.
      ENDIF.


    ENDIF.
  ELSE.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form T001W_F4HELP
*&---------------------------------------------------------------------*
FORM T001W_F4HELP .

  DATA: LT_RETURN_TAB TYPE DDSHRETVAL OCCURS 0,
        LS_RETURN_TAB LIKE LINE OF LT_RETURN_TAB.

  DATA: LT_DSELC TYPE DSELC OCCURS 0,
        LS_DSELC LIKE LINE OF LT_DSELC.

  DATA: LS_VALUE  TYPE SEAHLPRES,
        LT_VALUE  TYPE TABLE OF SEAHLPRES,
        LS_FIELD  TYPE DFIES,
        LT_FIELDS TYPE TABLE OF DFIES.

  DATA : BEGIN OF LT001W_WERKS OCCURS 0,
           WERKS  TYPE ZEA_MMT190-WERKS,
           PNAME1 TYPE ZEA_T001W-PNAME1,
         END OF LT001W_WERKS.

  DATA: LT_MAP TYPE TABLE OF DSELC WITH HEADER LINE.

  CLEAR : LT001W_WERKS, LT001W_WERKS[],
          LT_VALUE, LT_VALUE[],
          LT_FIELDS, LT_FIELDS[].

  SELECT A~WERKS
         B~PNAME1
         INTO TABLE LT001W_WERKS
         FROM ZEA_MMT190 AS A
         JOIN ZEA_T001W  AS B
           ON A~WERKS EQ B~WERKS.

    SORT LT001W_WERKS BY WERKS.
    DELETE ADJACENT DUPLICATES FROM LT001W_WERKS COMPARING ALL FIELDS.

    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      RETFIELD        = 'WERKS'           " Name of return field in FIELD_TAB
      DYNPPROG        = SY-REPID          " Current program
      DYNPNR          = SY-DYNNR          " Screen number
*     DYNPROFIELD     = 'ZEA_MMT010-MATNR'
      WINDOW_TITLE    = '플랜트 선택'        " Title for the hit list
      VALUE_ORG       = 'S'               " Value return: C: cell by cell, S: structured
    TABLES
*     FIELD_TAB       = LT_FIELDS[]
      VALUE_TAB       = LT001W_WERKS[]                 " Table of values: entries cell by cell
      RETURN_TAB      = LT_RETURN_TAB[]
*     DYNPFLD_MAPPING = LT_MAP
    EXCEPTIONS
      PARAMETER_ERROR = 1                " Incorrect parameter
      NO_VALUES_FOUND = 2                " No values found
      OTHERS          = 3.

  IF SY-SUBRC EQ 0.
    READ TABLE LT_RETURN_TAB INTO LS_RETURN_TAB INDEX 1.
    IF SY-SUBRC EQ 0.
      ZEA_MMT190-WERKS = LS_RETURN_TAB-FIELDVAL.

      READ TABLE LT001W_WERKS WITH KEY WERKS = ZEA_MMT190-WERKS BINARY SEARCH.
      IF SY-SUBRC EQ 0.
        ZEA_MMT190-WERKS        = LT001W_WERKS-WERKS.
        ZEA_T001W-PNAME1        = LT001W_WERKS-PNAME1.

        LEAVE SCREEN.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHECK_DATA
*&---------------------------------------------------------------------*
FORM CHECK_DATA .
*
  IF GV_LIST IS INITIAL.
    MESSAGE I000 DISPLAY LIKE 'E' WITH '출고할 플랜트 위치를 설정하세요.'.
    EXIT.
  ELSE.
  SELECT SINGLE *
    FROM ZEA_SDT110
    WHERE SBELNR  EQ ZEA_SDT060-SBELNR
      AND MATNR   EQ ZEA_SDT050-MATNR
      AND VBELN   EQ ZEA_SDT060-VBELN
      AND WERKS   EQ ZEA_SDT060-WERKS.
*      AND CUSCODE EQ ZEA_SDT040-CUSCODE.

    IF SY-SUBRC EQ 0.
    MESSAGE I000 DISPLAY LIKE 'E' WITH '동일한 출고 정보가 존재합니다'.
    ELSE.
      PERFORM CREATE_DATA.
  ENDIF.
  ENDIF.
ENDFORM.
