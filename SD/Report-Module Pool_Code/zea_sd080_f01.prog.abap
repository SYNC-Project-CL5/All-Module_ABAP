*&---------------------------------------------------------------------*
*& Include          ZALV_GRID_DISPLAY_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form MAKE_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM MAKE_FIELDCAT_0100 .

  LOOP AT GT_FIELDCAT INTO GS_FIELDCAT.

    CASE GS_FIELDCAT-FIELDNAME.
      WHEN 'ICON'.
        GS_FIELDCAT-COL_POS   = 0.
        GS_FIELDCAT-COLTEXT = '배송 상태'.
        GS_FIELDCAT-ICON    = ABAP_ON.
      WHEN 'VBELN'.
        GS_FIELDCAT-COL_POS = 1.
        GS_FIELDCAT-HOTSPOT = ABAP_ON.
        GS_FIELDCAT-JUST      = 'C'.
      WHEN 'STATUS'.
        GS_FIELDCAT-NO_OUT = ABAP_ON.
      WHEN 'STATUS2'.
        GS_FIELDCAT-NO_OUT = ABAP_ON.
      WHEN 'STATUS3'.
        GS_FIELDCAT-COLTEXT = '청구 문서 생성 유/무'.
        GS_FIELDCAT-JUST      = 'C'.
      WHEN 'STATUS4'.
        GS_FIELDCAT-COLTEXT = '수금 완료 여부'.
        GS_FIELDCAT-JUST      = 'C'.
      WHEN 'COLOR'.
        GS_FIELDCAT-NO_OUT  = ABAP_ON.
      WHEN 'LIGHT'.
        GS_FIELDCAT-NO_OUT  = ABAP_ON.
      WHEN 'MARK'.
        GS_FIELDCAT-NO_OUT  = ABAP_ON.
      WHEN 'BPCUS'.
        GS_FIELDCAT-COLTEXT = '고객명'.
        GS_FIELDCAT-COL_POS = 2.
        GS_FIELDCAT-JUST      = 'C'.
      WHEN 'CUSCODE'.
        GS_FIELDCAT-JUST      = 'C'.
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
      WHEN 'ZLSCH'.
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
  GS_LAYOUT-INFO_FNAME = 'COLOR'.           " 행 색상
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

*  SELECT *
*    FROM ZEA_SDT040 AS A
*    JOIN ZEA_KNA1 AS B
*      ON B~CUSCODE EQ A~CUSCODE
*    INTO CORRESPONDING FIELDS OF TABLE GT_DATA
*    WHERE A~STATUS2 = 'X'.
*
*  SORT GT_DATA BY VBELN CUSCODE.

  SELECT A~VBELN, A~CUSCODE, A~SADDR, A~VDATU, A~ADATU,
         A~ODDAT, A~TOAMT, A~WAERS, A~STATUS, A~STATUS2,
         A~STATUS3, A~STATUS4, B~BPCUS, B~ZLSCH, C~PAYNR
    FROM ZEA_SDT040 AS A
    JOIN ZEA_KNA1   AS B
      ON B~CUSCODE EQ A~CUSCODE
    LEFT JOIN ZEA_SDT070 AS C
*        ON B~CUSCODE EQ C~CUSCODE
      ON A~VBELN EQ C~VBELN
    JOIN ZEA_SDT060 AS D
      ON D~VBELN EQ A~VBELN
    INTO CORRESPONDING FIELDS OF TABLE @GT_DATA
    WHERE A~STATUS2 = 'X'
      AND D~STATUS2 = 'O'.

  SORT GT_DATA BY VBELN CUSCODE.

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

    IF GS_DISPLAY-STATUS4 = 'X'.

*      CLEAR GS_FIELD_COLOR.
      GS_DISPLAY-COLOR = 'C611'.
    ENDIF.


    IF GS_DISPLAY-STATUS2 = 'X'.
      GS_DISPLAY-ICON = ICON_LED_GREEN.

    ELSEIF GS_DISPLAY-STATUS2 = ''.
      GS_DISPLAY-ICON = ICON_LED_RED.

    ENDIF.

*--------------------------------------------------------------------*
    APPEND GS_DISPLAY TO GT_DISPLAY.

  ENDLOOP.

  SORT GT_DISPLAY BY ICON.

*  LOOP AT GT_DATA2 INTO GS_DATA2.
*
*    CLEAR GS_DISPLAY2.
*
*    MOVE-CORRESPONDING GS_DATA2 TO GS_DISPLAY2.
*
**신규 필드------------------------------------------------------------*
*
*
**--------------------------------------------------------------------*
*    APPEND GS_DISPLAY2 TO GT_DISPLAY2.
*
*  ENDLOOP.


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


  CREATE OBJECT GO_ALV_GRID
    EXPORTING
      I_PARENT = GO_CONTAINER
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

  CALL METHOD GO_ALV_GRID->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
*     I_STRUCTURE_NAME              = 'SPFLI'
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

*     PERFORM GET_FIELDCAT_0100.
  PERFORM GET_FIELDCAT2   USING    GT_DISPLAY
                          CHANGING GT_FIELDCAT.
  PERFORM MAKE_FIELDCAT_0100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_EVENT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_EVENT_0100 .

  SET HANDLER LCL_EVENT_HANDLER=>ON_TOOLBAR FOR GO_ALV_GRID.
  SET HANDLER LCL_EVENT_HANDLER=>ON_DOUBLE_CLICK FOR GO_ALV_GRID.
  SET HANDLER LCL_EVENT_HANDLER=>ON_USER_COMMAND FOR GO_ALV_GRID.
  SET HANDLER LCL_EVENT_HANDLER=>ON_HOTSPOT_CLICK FOR GO_ALV_GRID.
  SET HANDLER LCL_EVENT_HANDLER=>ON_BUTTON_CLICK FOR GO_ALV_GRID.

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
*& Form HANDLER_TOOLBAR
*&---------------------------------------------------------------------*
FORM HANDLER_TOOLBAR
  USING PO_OBJECT TYPE REF TO CL_ALV_EVENT_TOOLBAR_SET
        PO_SENDER TYPE REF TO CL_GUI_ALV_GRID.

  " Internal Table PO_OBJECT->MT_TOOLBAR 를 위한 작업공간
  " PO_OBJECT->MT_TOOLBAR >>> 클래스의 Attribute ( Public , Instance )
  DATA LS_TOOLBAR LIKE LINE OF PO_OBJECT->MT_TOOLBAR.

  DATA : LV_DELIV TYPE I,
         LV_OK    TYPE I,
         LV_ING   TYPE I,
         LV_NO    TYPE I.

  CASE PO_SENDER.
    WHEN GO_ALV_GRID.

      LOOP AT GT_DISPLAY INTO GS_DISPLAY.

        CASE GS_DISPLAY-ICON.
          WHEN ICON_LED_GREEN.
            ADD 1 TO LV_DELIV.
         ENDCASE.

         CASE GS_DISPLAY-STATUS3.
          WHEN 'X'.
            ADD 1 TO LV_OK.
          WHEN ''.
            ADD 1 TO LV_NO.
        ENDCASE.
      ENDLOOP.

* 구분자 =>> |
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 3. " 구분자
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 전체 조회
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 0.
      LS_TOOLBAR-FUNCTION = GC_DELIV.
      LS_TOOLBAR-TEXT = TEXT-L09 && ':' && LV_DELIV.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 청구 문서 생성 O
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 0.
      LS_TOOLBAR-FUNCTION = GC_DELIV_OK.
      LS_TOOLBAR-ICON = ICON_INCOMING_TASK.
      LS_TOOLBAR-TEXT = TEXT-L10 && ':' && LV_OK.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

** 버튼 추가 =>> 배송 완료 /
*      CLEAR LS_TOOLBAR.
*      LS_TOOLBAR-BUTN_TYPE = 0.
*      LS_TOOLBAR-FUNCTION = GC_DELIV_ING.
*      LS_TOOLBAR-ICON = ICON_LED_YELLOW.
*      LS_TOOLBAR-TEXT = TEXT-L11 && ':' && LV_ING.
*      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 청구 문서 생성 X
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 0.
      LS_TOOLBAR-FUNCTION = GC_DELIV_NO.
      LS_TOOLBAR-ICON = ICON_TERMINATED_TASK.
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
    WHEN GO_ALV_GRID. "PO_SENDER 가 GO_ALV_GRID 일 때
      CASE PV_UCOMM.  " 선택한 버튼 (PV_UCOMM은 SY-UCOMM 타입)
        WHEN GC_DELIV.
          PERFORM DELIV_FILTER.
          PERFORM SET_ALV_FILTER.

        WHEN GC_DELIV_OK.
          PERFORM DELIV_OK_FILTER.
          PERFORM SET_ALV_FILTER.

        WHEN GC_DELIV_NO.
          PERFORM DELIV_NO_FILTER.
          PERFORM SET_ALV_FILTER.

        WHEN GC_DELIV_ING.
*          PERFORM SELECT_DATA.
*          PERFORM MAKE_DISPLAY_DATA.
          PERFORM DELIV_ING_FILTER.
          PERFORM SET_ALV_FILTER.

      ENDCASE.
  ENDCASE.
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

  CASE PS_COLUMN_ID-FIELDNAME.
    WHEN 'VBELN'.

      PERFORM PAYNR_DATA.

      SORT GT_DATA2 BY VBELN .

      REFRESH GT_DISPLAY2.
      PERFORM MAKE_DISPLAY2_DATA.
      CALL METHOD GO_ALV_GRID_2->REFRESH_TABLE_DISPLAY( ).
*      PERFORM REFRESH_ALV_0100.

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


  DATA(LT_MOD) = PR_DATA_CHANGED->MT_MOD_CELLS[].

  IF LT_MOD[] IS NOT INITIAL.
    GV_CHANGED = ABAP_ON.
  ENDIF.

ENDFORM.
*** INCLUDE ZDISPLAY_F01
*** INCLUDE ZDISPLAY_F01
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT2_0100
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT2_0100 .

  CREATE OBJECT GO_CONTAINER_2
    EXPORTING
      CONTAINER_NAME = 'CCON2'                 " Name of the Screen CustCtrl Name to Link Container To
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

  PERFORM GET_FIELDCAT2   USING    GT_DISPLAY2
                         CHANGING GT_FIELDCAT2.

  PERFORM MAKE_FIELDCAT2_0100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_FIELDCAT2_0100
*&---------------------------------------------------------------------*
FORM MAKE_FIELDCAT2_0100 .

  LOOP AT GT_FIELDCAT2 INTO GS_FIELDCAT2.

    CASE GS_FIELDCAT2-FIELDNAME.
      WHEN 'VBELN'.
        GS_FIELDCAT2-JUST      = 'C'.
      WHEN 'POSNR'.
        GS_FIELDCAT2-JUST      = 'C'.
      WHEN 'MAKTX'.
        GS_FIELDCAT2-COLTEXT    = '자재명'.
        GS_FIELDCAT2-COL_POS    = 3.
        GS_FIELDCAT2-EMPHASIZE = 'C500'.
      WHEN 'MATNR'.
        GS_FIELDCAT2-JUST      = 'C'.
      WHEN 'STATUS'.
        GS_FIELDCAT2-NO_OUT    = ABAP_ON.

      WHEN 'AUQUA'.
        GS_FIELDCAT2-QFIELDNAME = 'MEINS'.
        GS_FIELDCAT2-EMPHASIZE = 'C300'.

      WHEN 'NETPR'.
        GS_FIELDCAT2-CFIELDNAME = 'WAERS'.
        GS_FIELDCAT2-EMPHASIZE = 'C310'.
      WHEN 'AUAMO'.
        GS_FIELDCAT2-CFIELDNAME = 'WAERS'.
        GS_FIELDCAT2-EMPHASIZE = 'C310'.
    ENDCASE.

    MODIFY GT_FIELDCAT2 FROM GS_FIELDCAT2.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_LAYOUT2_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_LAYOUT2_0100 .

  CLEAR GS_LAYOUT.
  CLEAR GS_VARIANT2.
  CLEAR GV_SAVE2.

  GS_VARIANT2-REPORT = SY-REPID.
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
  GS_VARIANT2-HANDLE = 'ALV2'.
  CALL METHOD GO_ALV_GRID_2->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
      IS_VARIANT                    = GS_VARIANT2
      I_SAVE                        = GV_SAVE2
      IS_LAYOUT                     = GS_LAYOUT
    CHANGING
      IT_OUTTAB                     = GT_DISPLAY2
      IT_FIELDCATALOG               = GT_FIELDCAT2
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
*& Form PAYNR_DATA
*&---------------------------------------------------------------------*
FORM PAYNR_DATA .

  SELECT
*    A~STATUS,
    A~VBELN, A~POSNR, A~MATNR,
       C~MAKTX ,A~AUQUA ,A~MEINS ,A~NETPR,
       A~AUAMO ,A~WAERS
*              B~SBELNR
      FROM ZEA_SDT050 AS A     " 판매오더 ITEM
      JOIN ZEA_MMT020 AS C     " 자재 TEXT
       ON C~MATNR EQ A~MATNR
      AND SPRAS EQ @SY-LANGU
*      LEFT OUTER JOIN ZEA_SDT110 AS B
*        ON B~VBELN EQ A~VBELN
*       AND B~MATNR EQ A~MATNR
      INTO CORRESPONDING FIELDS OF TABLE @GT_DATA2
      WHERE A~VBELN EQ @GS_DISPLAY-VBELN.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_DISPLAY2_DATA
*&---------------------------------------------------------------------*
FORM MAKE_DISPLAY2_DATA .

  LOOP AT GT_DATA2 INTO GS_DATA2.

    CLEAR GS_DISPLAY2.

    MOVE-CORRESPONDING GS_DATA2 TO GS_DISPLAY2.

*신규 필드------------------------------------------------------------*


*--------------------------------------------------------------------*
    APPEND GS_DISPLAY2 TO GT_DISPLAY2.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_DATA_SDT040
*&---------------------------------------------------------------------*
FORM SELECT_DATA_SDT040 .

  REFRESH GT_DISPLAY.

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
   JOIN ZEA_SDT060 AS D
     ON D~VBELN EQ A~VBELN
  INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY
 WHERE A~VBELN   IN R_VBELN
   AND A~CUSCODE IN R_CUSCODE
   AND A~VDATU   IN R_VDATU
    AND A~STATUS2 = 'X'
    AND D~STATUS2 = 'O'.


*       SELECT A~VBELN, A~CUSCODE, A~SADDR, A~VDATU, A~ADATU,
*           A~ODDAT, A~TOAMT, A~WAERS, A~STATUS, A~STATUS3,
*           B~BPCUS, B~ZLSCH, C~PAYNR
*      FROM ZEA_SDT040 AS A
*      JOIN ZEA_KNA1   AS B
*        ON B~CUSCODE EQ A~CUSCODE
*      LEFT JOIN ZEA_SDT070 AS C
**        ON B~CUSCODE EQ C~CUSCODE
*        ON A~VBELN EQ C~VBELN
*      JOIN ZEA_SDT060 AS D
*        ON D~VBELN EQ A~VBELN
*      INTO CORRESPONDING FIELDS OF TABLE @GT_DATA
*      WHERE A~STATUS2 = 'X'
*        AND D~STATUS2 = 'O'.

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

*    IF GS_DISPLAY-VDATU > SY-DATUM.
*      GS_DISPLAY-ICON = ICON_LED_RED.
*    ELSEIF GS_DISPLAY-VDATU <= SY-DATUM.
*      GS_DISPLAY-ICON = ICON_LED_YELLOW.
*    ENDIF.

*    IF GS_DISPLAY-STATUS3 = 'X'.
*      GS_DISPLAY-ICON = ICON_LED_GREEN.
*
*    ENDIF.


    IF GS_DISPLAY-STATUS3 = 'X'.
      GS_DISPLAY-ICON = ICON_LED_GREEN.

    ELSEIF GS_DISPLAY-STATUS3 = ''.
      GS_DISPLAY-ICON = ICON_LED_RED.

    ENDIF.


*--------------------------------------------------------------------*
    MODIFY GT_DISPLAY FROM GS_DISPLAY.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DELIV_FILTER
*&---------------------------------------------------------------------*
FORM DELIV_FILTER .

  REFRESH GT_FILTER.

  CLEAR GS_FILTER.
  GS_FILTER-FIELDNAME = 'ICON'.
  GS_FILTER-SIGN      = 'I'.
  GS_FILTER-OPTION    = 'EQ'.
  GS_FILTER-LOW       = ICON_LED_GREEN.
  APPEND GS_FILTER TO GT_FILTER.
*
*  CLEAR GS_FILTER.
*  GS_FILTER-FIELDNAME = 'ICON'.
*  GS_FILTER-SIGN      = 'I'.
*  GS_FILTER-OPTION    = 'EQ'.
*  GS_FILTER-LOW       = ICON_LED_YELLOW.
*  APPEND GS_FILTER TO GT_FILTER.

  CLEAR GS_FILTER.
  GS_FILTER-FIELDNAME = 'ICON'.
  GS_FILTER-SIGN      = 'I'.
  GS_FILTER-OPTION    = 'EQ'.
  GS_FILTER-LOW       = ICON_LED_RED.
  APPEND GS_FILTER TO GT_FILTER.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DELIV_OK_FILTER
*&---------------------------------------------------------------------*
FORM DELIV_OK_FILTER .

  REFRESH GT_FILTER.

  CLEAR GS_FILTER.
  GS_FILTER-FIELDNAME = 'ICON'.
  GS_FILTER-SIGN      = 'I'.
  GS_FILTER-OPTION    = 'EQ'.
  GS_FILTER-LOW       = ICON_LED_GREEN.
  APPEND GS_FILTER TO GT_FILTER.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DELIV_NO_FILTER
*&---------------------------------------------------------------------*
FORM DELIV_NO_FILTER .

  REFRESH GT_FILTER.

  CLEAR GS_FILTER.
  GS_FILTER-FIELDNAME = 'ICON'.
  GS_FILTER-SIGN      = 'I'.
  GS_FILTER-OPTION    = 'EQ'.
  GS_FILTER-LOW       = ICON_LED_RED.
  APPEND GS_FILTER TO GT_FILTER.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DELIV_ING_FILTER
*&---------------------------------------------------------------------*
FORM DELIV_ING_FILTER .

*  REFRESH GT_FILTER.
*
*  CLEAR GS_FILTER.
*  GS_FILTER-FIELDNAME = 'ICON'.
*  GS_FILTER-SIGN      = 'I'.
*  GS_FILTER-OPTION    = 'EQ'.
*  GS_FILTER-LOW       = ICON_LED_YELLOW.
*  APPEND GS_FILTER TO GT_FILTER.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_DATA_0100
*&---------------------------------------------------------------------*
FORM CREATE_DATA_0100 .

  DATA LT_INDEX_ROWS TYPE LVC_T_ROW.
  DATA LS_INDEX_ROW  TYPE LVC_S_ROW.

  CALL METHOD GO_ALV_GRID->GET_SELECTED_ROWS
    IMPORTING
      ET_INDEX_ROWS = LT_INDEX_ROWS.

  IF LT_INDEX_ROWS[] IS INITIAL.

    " 아이템만 한 줄 선택하도록 안내
    " TEXT-M01: 라인을 선택하세요.
    MESSAGE S000 DISPLAY LIKE 'W' WITH '최소 한 행이상 선택하세요'.

  ELSE.

    READ TABLE LT_INDEX_ROWS INTO LS_INDEX_ROW INDEX 1.
    READ TABLE GT_DISPLAY   INTO GS_DISPLAY  INDEX LS_INDEX_ROW-INDEX.

    IF SY-SUBRC EQ 0.
      IF GS_DISPLAY-STATUS3 EQ 'X'.
        " 이미 생성된 청구 문서입니다.
        MESSAGE S035 DISPLAY LIKE 'E'.
      ELSE.
        _MC_POPUP_CONFIRM '청구 문서 생성' '청구 문서를 생성하시겠습니까?' GV_ANSWER.
        CHECK GV_ANSWER = '1'.

        ZEA_SDT040-WAERS = 'KRW'.
        ZEA_SDT090-WAERS = 'KRW'.
        CLEAR ZEA_SDT070-PAYNR.
        PERFORM MOVE_DATA.
        CALL SCREEN 0110 STARTING AT 50 5.
      ENDIF.

    ENDIF.


  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MOVE_DATA
*&---------------------------------------------------------------------*
FORM MOVE_DATA .

*    " 헤더는 아이템의 판매오더 번호로 찾는다.
  READ TABLE GT_DISPLAY INTO GS_DISPLAY
*                        INTO GS_DISPLAY-VBELN
                        WITH KEY VBELN = GS_DISPLAY-VBELN.

*-- [FI] 고객 테이블
  ZEA_KNA1-BPCUS      = GS_DISPLAY-BPCUS.     " [BP] 고객명

*-- [SD] 판매오더 Header
  ZEA_SDT040-VBELN    = GS_DISPLAY-VBELN.     " 판매오더 번호
  ZEA_SDT040-ODDAT    = GS_DISPLAY-ODDAT.

*-- [SD] 대금청구 Header
  ZEA_SDT070-INVDT    = SY-DATUM.             " 청구 일자
  ZEA_SDT070-CUSCODE  = GS_DISPLAY-CUSCODE.   " [BP] 고객코드
  ZEA_SDT070-CHARGE   = GS_DISPLAY-TOAMT * 9 / 10. " 공제액
  ZEA_SDT070-EATAX   = GS_DISPLAY-TOAMT / 10. " 부가 가치세
  ZEA_SDT070-BILLAMT   = GS_DISPLAY-TOAMT.     " 청구 금액
  ZEA_SDT070-WAERS    = GS_DISPLAY-WAERS.     " 통화코드
  ZEA_SDT070-BUKRS    = '1000'.               " 회사코드
  ZEA_SDT070-ZLSCH    = GS_DISPLAY-ZLSCH.               " 지금 조건코드
*  ZEA_SDT070-GJAHR    =                      " 회계연도
*  ZEA_SDT070-BELNR    =                      " 전표번호

*-- [SD] 회사코드
  ZEA_FIT000-BUTXT    = '(주) 한국타이어앤테크놀로지'. " 회사명


  REFRESH GT_DISPLAY3.

  PERFORM PAYNR_DATA_3.
*
*  SORT GT_DATA3 BY VBELN .
*
*
  PERFORM MAKE_DISPLAY3_DATA.
*  CALL METHOD GO_ALV_GRID_3->REFRESH_TABLE_DISPLAY( ).  " 이거 주석 풀면 덤프

*  LOOP AT GT_DISPLAY2 INTO GS_DISPLAY3.
*
*    APPEND GS_DISPLAY2 TO GT_DISPLAY3.
*
*  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_DATA
*&---------------------------------------------------------------------*
FORM CREATE_DATA .

  DATA LV_MSG TYPE STRING.
  DATA LV_SUBRC TYPE I.

  DATA LT_INDEX_ROWS TYPE LVC_T_ROW.
  DATA LS_INDEX_ROW LIKE LINE OF LT_INDEX_ROWS.

  DATA: LT_SDT120 TYPE TABLE OF ZEA_SDT120,
        LS_SDT120 TYPE ZEA_SDT120.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      NR_RANGE_NR             = '01'                 " Number range number
      OBJECT                  = 'ZEA_PAYNR'                 " Name of number range object
    IMPORTING
      NUMBER                  = ZEA_SDT070-PAYNR                 " free number
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

  ZEA_SDT070-PAYNR(3) = 'PAY'.    " 앞 3글자 PAY 로 변경

  CALL FUNCTION 'ZEA_FI_DA'
    EXPORTING
      IV_PAYNR   = ZEA_SDT070-PAYNR " 청구 문서 번호
      IV_INVDT   = ZEA_SDT070-INVDT " 청구 일자
      IV_CUSCODE = ZEA_SDT070-CUSCODE " [BP] 고객코드
      IV_CHARGE  = ZEA_SDT070-CHARGE " 공제액
      IV_EATAX   = ZEA_SDT070-EATAX  " 부가 가치세
      IV_WAERS   = ZEA_SDT070-WAERS  " 통화코드
      IV_NETPR   = GS_DISPLAY2-NETPR " 판매 단가
      IV_AUQUA   = GS_DISPLAY2-AUQUA " 주문 수량
      IV_PLANT   = ''                " [BP] 직영점코드 ( B2C 일때만 값)
      IV_CHECK   = ''                "  소매일 경우 'X' 값을 주세요
    IMPORTING
      EV_BELNR   = ZEA_SDT070-BELNR " 전표 번호
      EV_BUKRS   = ZEA_SDT070-BUKRS " 회사코드
      EV_GJAHR   = ZEA_SDT070-GJAHR. " 회계연도

  ZEA_SDT070-VBELN    = ZEA_SDT040-VBELN.
  ZEA_SDT070-ODDAT    = ZEA_SDT040-ODDAT.
*  ZEA_SDT070-INVDT    = " 이미 화면에 출력 중
*  ZEA_SDT070-CUSCODE  =
*  ZEA_SDT070-CHARGE   =
*  ZEA_SDT070-EATAX    =
*  ZEA_SDT070-BILLAMT  =
*  ZEA_SDT070-BUKRS    = EV_BUKRS.
*  ZEA_SDT070-GJAHR    = EV_GJAHR.
*  ZEA_SDT070-BELNR    = EV_BELNR.
*  ZEA_SDT070-STATUS    =
  ZEA_SDT070-ERDAT = SY-DATUM.
  ZEA_SDT070-ERNAM = SY-UNAME.
  ZEA_SDT070-ERZET = SY-UZEIT.

*ZLSCH
*PAYDT
*STATUS
*LOEKZ

  INSERT ZEA_SDT070.

  IF SY-SUBRC NE 0.
    LV_SUBRC = 4.
    ROLLBACK WORK.
    MESSAGE '청구 문서 데이터 추가에 실패했습니다.' TYPE 'E'.
    EXIT.
  ENDIF.

*--- 대금 청구 아이템 테이블에 저장
  LOOP AT GT_DISPLAY2 INTO GS_DISPLAY2.



*  ZEA_SDT120-PAYNR = ZEA_SDT070-PAYNR.
*  ZEA_SDT120-POSNR = '0010'.
*  ZEA_SDT120-MATNR = GS_DISPLAY2-MATNR.
*  ZEA_SDT120-AUQUA = GS_DISPLAY2-AUQUA.
*  ZEA_SDT120-MEINS = GS_DISPLAY2-MEINS.
*  ZEA_SDT120-NETPR = GS_DISPLAY2-NETPR.
*  ZEA_SDT120-WAERS = GS_DISPLAY2-WAERS.
*
*
*  ZEA_SDT120-ERDAT = SY-DATUM.
*  ZEA_SDT120-ERNAM = SY-UNAME.
*  ZEA_SDT120-ERZET = SY-UZEIT.

    MODIFY GT_DISPLAY2 FROM GS_DISPLAY2.

    MOVE-CORRESPONDING ZEA_SDT070 TO LS_SDT120.
    MOVE-CORRESPONDING GS_DISPLAY2 TO LS_SDT120.
    APPEND LS_SDT120 TO LT_SDT120.

*    MOVE-CORRESPONDING ZEA_SDT070 TO ZEA_SDT120.
*    MOVE-CORRESPONDING GS_DISPLAY2 TO ZEA_SDT120.

    INSERT ZEA_SDT120 FROM LS_SDT120.

    IF SY-SUBRC NE 0.
      LV_SUBRC = 4.
      ROLLBACK WORK.
      MESSAGE '청구 문서 데이터 추가에 실패했습니다.' TYPE 'E'.
      EXIT.
    ENDIF.

  ENDLOOP.

  UPDATE ZEA_SDT040 SET STATUS3 = 'X'
                        AENAM  = SY-UNAME
                        AEDAT  = SY-DATUM
                        AEZET  = SY-UZEIT
                        WHERE VBELN
                        EQ ZEA_SDT070-VBELN.

*     Itab 변경 로직
  READ TABLE GT_DISPLAY INTO GS_DISPLAY WITH KEY VBELN = GS_DISPLAY-VBELN.
  IF SY-SUBRC EQ 0.
    GS_DISPLAY-ICON = ICON_LED_GREEN.
    GS_DISPLAY-PAYNR = ZEA_SDT070-PAYNR.
    GS_DISPLAY-STATUS3 = 'X'.
    MODIFY GT_DISPLAY FROM GS_DISPLAY INDEX SY-TABIX.
  ENDIF.

  COMMIT WORK AND WAIT.

  GO_ALV_GRID->REFRESH_TABLE_DISPLAY( IS_STABLE = VALUE #( ROW = 'X' COL = 'X' ) ).
  GO_ALV_GRID_2->REFRESH_TABLE_DISPLAY( IS_STABLE = VALUE #( ROW = 'X' COL = 'X' ) ).

  LV_MSG = |청구 문서 번호 { ZEA_SDT070-PAYNR } 가 생성되었습니다. |.





*      LOOP AT LT_INDEX_ROWS INTO LS_INDEX_ROW.
*    READ TABLE GT_DISPLAY INTO GS_DISPLAY INDEX LS_INDEX_ROW-INDEX.
*    GS_DISPLAY-STATUS3 = 'X'.
*    MODIFY GT_DISPLAY FROM GS_DISPLAY
*    INDEX LS_INDEX_ROW-INDEX TRANSPORTING STATUS3.
*  ENDLOOP.
*  PERFORM REFRESH_ALV_0100.

**    READ TABLE GT_DISPLAY INTO GS_DISPLAY WITH KEY VBELN = GS_DISPLAY-VBELN.
**    IF SY-SUBRC EQ 0.
**      GS_DISPLAY-ICON = ICON_LED_GREEN.
**      MODIFY GT_DISPLAY FROM GS_DISPLAY INDEX SY-TABIX.
**      ENDIF.

***  GS_DISPLAY-ICON = ICON_LED_GREEN.
***  MODIFY GT_DISPLAY FROM GS_DISPLAY TRANSPORTING ICON WHERE VBELN EQ GS_DISPLAY-VBELN.

  IF LV_SUBRC EQ 0.
    COMMIT WORK AND WAIT.
    MESSAGE LV_MSG TYPE 'S'.
  ELSE.
    ROLLBACK WORK.
    MESSAGE S016 DISPLAY LIKE 'E'. "데이터 저장 중 오류가 발생했습니다.
  ENDIF.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH_ALV_0110
*&---------------------------------------------------------------------*
FORM REFRESH_ALV_0110 .

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
*& Form CREATE_OBJECT_0110
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT_0110 .

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
*& Form SET_ALV_FIELDCAT_0110
*&---------------------------------------------------------------------*
FORM SET_ALV_FIELDCAT_0110 .

  PERFORM GET_FIELDCAT_0110     USING    GT_DISPLAY3
                                CHANGING GT_FIELDCAT3.

  PERFORM MAKE_FIELDCAT2_0110.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_FIELDCAT_0110
*&---------------------------------------------------------------------*
FORM GET_FIELDCAT_0110  USING PT_TAB TYPE STANDARD TABLE
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
*& Form MAKE_FIELDCAT2_0110
*&---------------------------------------------------------------------*
FORM MAKE_FIELDCAT2_0110 .

  LOOP AT GT_FIELDCAT3 INTO GS_FIELDCAT3.

    CASE GS_FIELDCAT3-FIELDNAME.
      WHEN 'VBELN'.
        GS_FIELDCAT3-JUST      = 'C'.
      WHEN 'POSNR'.
        GS_FIELDCAT3-JUST      = 'C'.
      WHEN 'MAKTX'.
        GS_FIELDCAT3-COLTEXT    = '자재명'.
        GS_FIELDCAT3-COL_POS    = 3.
      WHEN 'MATNR'.
        GS_FIELDCAT3-JUST      = 'C'.
      WHEN 'STATUS'.
        GS_FIELDCAT3-NO_OUT    = ABAP_ON.

      WHEN 'AUQUA'.
        GS_FIELDCAT3-QFIELDNAME = 'MEINS'.

      WHEN 'NETPR'.
        GS_FIELDCAT3-CFIELDNAME = 'WAERS'.

      WHEN 'AUAMO'.
        GS_FIELDCAT3-CFIELDNAME = 'WAERS'.
    ENDCASE.

    MODIFY GT_FIELDCAT3 FROM GS_FIELDCAT3.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_LAYOUT_0110
*&---------------------------------------------------------------------*
FORM SET_ALV_LAYOUT_0110 .
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
*& Form DISPLAY_ALV_0110
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV_0110 .

  CALL METHOD GO_ALV_GRID_3->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
*     I_STRUCTURE_NAME              = 'ZEA_SDT050'
      IS_VARIANT                    = GS_VARIANT
      I_SAVE                        = GV_SAVE3
      IS_LAYOUT                     = GS_LAYOUT
    CHANGING
      IT_OUTTAB                     = GT_DISPLAY3
      IT_FIELDCATALOG               = GT_FIELDCAT3
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
*& Form MAKE_DISPLAY3_DATA
*&---------------------------------------------------------------------*
FORM MAKE_DISPLAY3_DATA .

  LOOP AT GT_DATA3 INTO GS_DATA3.

    CLEAR GS_DISPLAY3.

    MOVE-CORRESPONDING GS_DATA3 TO GS_DISPLAY3.

*신규 필드------------------------------------------------------------*


*--------------------------------------------------------------------*
    APPEND GS_DISPLAY3 TO GT_DISPLAY3.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form PAYNR_DATA_3
*&---------------------------------------------------------------------*
FORM PAYNR_DATA_3 .

  SELECT
*    A~STATUS,
  A~VBELN, A~POSNR, A~MATNR,
     C~MAKTX ,A~AUQUA ,A~MEINS ,A~NETPR,
     A~AUAMO ,A~WAERS
*              B~SBELNR
    FROM ZEA_SDT050 AS A     " 판매오더 ITEM
    JOIN ZEA_MMT020 AS C     " 자재 TEXT
     ON C~MATNR EQ A~MATNR
    AND SPRAS EQ @SY-LANGU
*      LEFT OUTER JOIN ZEA_SDT110 AS B
*        ON B~VBELN EQ A~VBELN
*       AND B~MATNR EQ A~MATNR
    INTO CORRESPONDING FIELDS OF TABLE @GT_DATA3
    WHERE A~VBELN EQ @GS_DISPLAY-VBELN.

ENDFORM.
