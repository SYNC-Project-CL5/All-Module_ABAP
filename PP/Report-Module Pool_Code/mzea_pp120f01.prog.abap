*&---------------------------------------------------------------------*
*& Include          MZEA_PP110F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form MAKE_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM MAKE_FIELDCAT_0100 .

  LOOP AT GT_FIELDCAT INTO GS_FIELDCAT.

    CASE GS_FIELDCAT-FIELDNAME.

      WHEN 'RTIDX'.
        GS_FIELDCAT-JUST    = 'C'.
      WHEN 'RTSTEP'.
        GS_FIELDCAT-JUST    = 'C'.
      WHEN 'QTY'.
        GS_FIELDCAT-QFIELDNAME = 'UNIT'.
      WHEN 'UNIT'.
        GS_FIELDCAT-COLTEXT    = '단위'.
      WHEN 'RTST'.
        GS_FIELDCAT-COLTEXT = '시작시간'.
      WHEN 'RTET'.
        GS_FIELDCAT-COLTEXT = '종료시간'.
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
        GS_FIELDCAT-NO_OUT  = ABAP_ON.
      WHEN 'COLOR'.
        GS_FIELDCAT-NO_OUT  = ABAP_ON.
      WHEN 'LIGHT'.
        GS_FIELDCAT-COLTEXT = '상태'.
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
  GV_SAVE = 'A'.

  GS_LAYOUT-CWIDTH_OPT = 'A'.
  GS_LAYOUT-ZEBRA      = ABAP_ON.
  GS_LAYOUT-SEL_MODE   = 'D'.

*  GS_LAYOUT-GRID_TITLE = TEXT-T10.          " ALV TITLE TEXT
*  GS_LAYOUT-INFO_FNAME = 'COLOR'.           " 행 색상
  GS_LAYOUT-EXCP_FNAME = 'LIGHT'.           " 신호등
  GS_LAYOUT-EXCP_LED = ABAP_ON.             " 신호등 모양 변경
  GS_LAYOUT-CTAB_FNAME = 'IT_FIELD_COLORS'. " 셀 별 색상
*  GS_LAYOUT-STYLEFNAME  = 'STYLE'.          " 스타일
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_DATA
*&---------------------------------------------------------------------*
FORM SELECT_DATA .

  REFRESH GT_DATA.

  SELECT A~RTID
         A~RTSTEP
         A~AUFNR
         A~WERKS
*         C~PNAME1
         A~MATNR
         B~MAKTX
         A~QTY
         A~UNIT
*         A~RTNAME
         A~RTST
         A~RTET

    INTO CORRESPONDING FIELDS OF TABLE GT_DATA
    FROM ZEA_PLKO   AS A
    JOIN ZEA_MMT020 AS B
                    ON B~MATNR EQ A~MATNR
                   AND B~SPRAS EQ SY-LANGU
    JOIN ZEA_T001W  AS C
                    ON C~WERKS EQ A~WERKS
    JOIN ZEA_MMT010 AS D
                    ON D~MATNR EQ A~MATNR
    WHERE D~MATTYPE EQ '반제품' OR
          D~MATTYPE EQ '완제품'.


  SORT GT_DATA BY RTSTEP RTID.
*
*  SELECT *
*    INTO CORRESPONDING FIELDS OF TABLE GT_DATA2
*    FROM ZEA_PLPO.




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

    IF GS_DISPLAY-RTST IS INITIAL.
      GS_DISPLAY-LIGHT = 1. " 빨간불
    ELSEIF GS_DISPLAY-RTET IS INITIAL.
      GS_DISPLAY-LIGHT = 2. " 초록불
    ELSE.
      GS_DISPLAY-LIGHT = 3.
    ENDIF.

    CASE GS_DISPLAY-RTSTEP.
      WHEN 1.
        CLEAR GS_FIELD_COLOR.
        GS_FIELD_COLOR-FNAME = 'RTSTEP'.
        GS_FIELD_COLOR-COLOR-COL = 6. " 빨강
        GS_FIELD_COLOR-COLOR-INT = 0.
        GS_FIELD_COLOR-COLOR-INV = 0.
        APPEND GS_FIELD_COLOR TO GS_DISPLAY-IT_FIELD_COLORS.
      WHEN 2.
        CLEAR GS_FIELD_COLOR.
        GS_FIELD_COLOR-FNAME = 'RTSTEP'.
        GS_FIELD_COLOR-COLOR-COL = 7. " 주황
        GS_FIELD_COLOR-COLOR-INT = 0.
        GS_FIELD_COLOR-COLOR-INV = 0.
        APPEND GS_FIELD_COLOR TO GS_DISPLAY-IT_FIELD_COLORS.
      WHEN 3.
        CLEAR GS_FIELD_COLOR.
        GS_FIELD_COLOR-FNAME = 'RTSTEP'.
        GS_FIELD_COLOR-COLOR-COL = 3. " 노랑
        GS_FIELD_COLOR-COLOR-INT = 0.
        GS_FIELD_COLOR-COLOR-INV = 0.
        APPEND GS_FIELD_COLOR TO GS_DISPLAY-IT_FIELD_COLORS.
      WHEN 4.
        CLEAR GS_FIELD_COLOR.
        GS_FIELD_COLOR-FNAME = 'RTSTEP'.
        GS_FIELD_COLOR-COLOR-COL = 4. " 초록
        GS_FIELD_COLOR-COLOR-INT = 0.
        GS_FIELD_COLOR-COLOR-INV = 0.
        APPEND GS_FIELD_COLOR TO GS_DISPLAY-IT_FIELD_COLORS.
      WHEN 5.
        CLEAR GS_FIELD_COLOR.
        GS_FIELD_COLOR-FNAME = 'RTSTEP'.
        GS_FIELD_COLOR-COLOR-COL = 1. " 하늘
        GS_FIELD_COLOR-COLOR-INT = 0.
        GS_FIELD_COLOR-COLOR-INV = 0.
        APPEND GS_FIELD_COLOR TO GS_DISPLAY-IT_FIELD_COLORS.
      WHEN 6.
        CLEAR GS_FIELD_COLOR.
        GS_FIELD_COLOR-FNAME = 'RTSTEP'.
        GS_FIELD_COLOR-COLOR-COL = 5. " 파랑
        GS_FIELD_COLOR-COLOR-INT = 0.
        GS_FIELD_COLOR-COLOR-INV = 0.
        APPEND GS_FIELD_COLOR TO GS_DISPLAY-IT_FIELD_COLORS.
    ENDCASE.

*--------------------------------------------------------------------*
    APPEND GS_DISPLAY TO GT_DISPLAY.

  ENDLOOP.

  REFRESH GT_DISPLAY2.

  LOOP AT GT_DATA2 INTO GS_DATA2.

    CLEAR GS_DISPLAY2.

    MOVE-CORRESPONDING GS_DATA2 TO GS_DISPLAY2.

*신규 필드------------------------------------------------------------*
    CASE GS_DISPLAY2-RTSTEP.
      WHEN 1.
        CLEAR GS_FIELD_COLOR.
        GS_FIELD_COLOR-FNAME = 'RTSTEP'.
        GS_FIELD_COLOR-COLOR-COL = 6. " 빨강
        GS_FIELD_COLOR-COLOR-INT = 0.
        GS_FIELD_COLOR-COLOR-INV = 0.
        APPEND GS_FIELD_COLOR TO GS_DISPLAY2-IT_FIELD_COLORS.
      WHEN 2.
        CLEAR GS_FIELD_COLOR.
        GS_FIELD_COLOR-FNAME = 'RTSTEP'.
        GS_FIELD_COLOR-COLOR-COL = 7. " 주황
        GS_FIELD_COLOR-COLOR-INT = 0.
        GS_FIELD_COLOR-COLOR-INV = 0.
        APPEND GS_FIELD_COLOR TO GS_DISPLAY2-IT_FIELD_COLORS.
      WHEN 3.
        CLEAR GS_FIELD_COLOR.
        GS_FIELD_COLOR-FNAME = 'RTSTEP'.
        GS_FIELD_COLOR-COLOR-COL = 3. " 노랑
        GS_FIELD_COLOR-COLOR-INT = 0.
        GS_FIELD_COLOR-COLOR-INV = 0.
        APPEND GS_FIELD_COLOR TO GS_DISPLAY2-IT_FIELD_COLORS.
      WHEN 4.
        CLEAR GS_FIELD_COLOR.
        GS_FIELD_COLOR-FNAME = 'RTSTEP'.
        GS_FIELD_COLOR-COLOR-COL = 4. " 파랑
        GS_FIELD_COLOR-COLOR-INT = 0.
        GS_FIELD_COLOR-COLOR-INV = 0.
        APPEND GS_FIELD_COLOR TO GS_DISPLAY2-IT_FIELD_COLORS.
      WHEN 5.
        CLEAR GS_FIELD_COLOR.
        GS_FIELD_COLOR-FNAME = 'RTSTEP'.
        GS_FIELD_COLOR-COLOR-COL = 1. " 하늘
        GS_FIELD_COLOR-COLOR-INT = 0.
        GS_FIELD_COLOR-COLOR-INV = 0.
        APPEND GS_FIELD_COLOR TO GS_DISPLAY2-IT_FIELD_COLORS.
      WHEN 6.
        CLEAR GS_FIELD_COLOR.
        GS_FIELD_COLOR-FNAME = 'RTSTEP'.
        GS_FIELD_COLOR-COLOR-COL = 5. " 초록
        GS_FIELD_COLOR-COLOR-INT = 0.
        GS_FIELD_COLOR-COLOR-INV = 0.
        APPEND GS_FIELD_COLOR TO GS_DISPLAY2-IT_FIELD_COLORS.
    ENDCASE.

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

  CHECK SY-UNAME EQ 'ACA5-03'
     OR SY-UNAME EQ 'ACA5-07'
     OR SY-UNAME EQ 'ACA5-08'
     OR SY-UNAME EQ 'ACA5-10'
     OR SY-UNAME EQ 'ACA5-12'
*     OR SY-UNAME EQ 'ACA5-15'
     OR SY-UNAME EQ 'ACA5-17'
     OR SY-UNAME EQ 'ACA5-23'
     OR SY-UNAME EQ 'ACA-05'.

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

  DESCRIBE TABLE GT_DISPLAY LINES GV_LINES.

  IF GT_DISPLAY IS INITIAL.
    MESSAGE S013 DISPLAY LIKE 'W'.
  ELSE.
    MESSAGE S006 WITH GV_LINES.
  ENDIF.

  CALL METHOD GO_ALV_GRID->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
*     I_STRUCTURE_NAME              = ''
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



  CASE PO_SENDER.
    WHEN GO_ALV_GRID.
*     구분자 =>> |
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 3. " 구분자
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

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


* 버튼 추가 =>> 전체
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-FUNCTION = GC_NO_FILTER.
      LS_TOOLBAR-TEXT = | 전체 : { SY-TFILL } |.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 생산전
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-FUNCTION = GC_WAIT.
      LS_TOOLBAR-ICON = ICON_LED_RED.
      LS_TOOLBAR-TEXT = | 생산전 : { LV_RED }  |.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 생산중
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-FUNCTION = GC_PROCESS.
      LS_TOOLBAR-ICON = ICON_LED_YELLOW.
      LS_TOOLBAR-TEXT = | 생산중 : { LV_YELLOW }  |.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 생산완료
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-FUNCTION = GC_COMPLETE.
      LS_TOOLBAR-ICON = ICON_LED_GREEN.
      LS_TOOLBAR-TEXT = | 생산완료 : { LV_GREEN }  |.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 3. " 구분자
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 생산시작
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-FUNCTION = GC_GOPROCESS.
      LS_TOOLBAR-ICON = ICON_PAGE_RIGHT.
      LS_TOOLBAR-TEXT = '생산시작'.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.


    WHEN GO_ALV_GRID_1.
* 구분자 =>> |
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 3. " 구분자
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 생산전
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-FUNCTION = GC_DOPROCESS.
      LS_TOOLBAR-ICON = ICON_PPE_PLINE.
      LS_TOOLBAR-TEXT = '공정 진행'.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

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
    WHEN GO_ALV_GRID. "PO_SENDER 가 GO_ALV_GRID 일 때
      CASE PV_UCOMM.  " 선택한 버튼 (PV_UCOMM은 SY-UCOMM 타입)

        WHEN GC_NO_FILTER.
          PERFORM NO_FILTER.

        WHEN GC_COMPLETE.
          PERFORM COMPLETE_FILTER.

        WHEN GC_PROCESS.
          PERFORM PROCESS_FILTER.

        WHEN GC_WAIT.
          PERFORM WAIT_FILTER.

        WHEN GC_GOPROCESS.
          PERFORM GO_PROCESS.

      ENDCASE.

    WHEN GO_ALV_GRID_1.
      CASE PV_UCOMM.
        WHEN GC_DOPROCESS.
          PERFORM DO_PROCESS.
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

  DATA : BEGIN OF LT_RTID OCCURS 0,
           RTID   TYPE ZEA_PLKO-RTID,
*           RTNAME TYPE ZEA_PLKO-RTNAME,
           AUFNR  TYPE ZEA_PLKO-AUFNR,
           PNAME1 TYPE ZEA_T001W-PNAME1,
           WERKS  TYPE ZEA_T001W-WERKS,
           MAKTX  TYPE ZEA_MMT020-MAKTX,
           MATNR  TYPE ZEA_MMT020-MATNR,
         END OF LT_RTID.

  DATA: LT_MAP TYPE TABLE OF DSELC WITH HEADER LINE.

  CLEAR : LT_RTID, LT_RTID[],
          LT_VALUE, LT_VALUE[],
          LT_FIELDS, LT_FIELDS[].

  SELECT   A~RTID
*           A~RTNAME
           A~AUFNR
           B~PNAME1
           B~WERKS
           C~MAKTX
           C~MATNR
  INTO CORRESPONDING FIELDS OF TABLE LT_RTID
  FROM ZEA_PLKO   AS A
  JOIN ZEA_T001W  AS B
                  ON B~WERKS EQ A~WERKS
  JOIN ZEA_MMT020 AS C
                  ON C~MATNR EQ A~MATNR
                 AND C~SPRAS EQ SY-LANGU.

  SORT LT_RTID BY RTID.

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

*  CLEAR LS_FIELD.
*  LS_FIELD-FIELDNAME = 'AUFNR'.
*  LS_FIELD-INTLEN = 20.
*  LS_FIELD-LENG = 20.
*  LS_FIELD-OUTPUTLEN = 20.
*  LS_FIELD-REPTEXT = '생산오더ID'.
*  APPEND LS_FIELD TO LT_FIELDS.
*
*  CLEAR LS_FIELD.
*  LS_FIELD-FIELDNAME = 'PLANID'.
*  LS_FIELD-INTLEN = 20.
*  LS_FIELD-LENG = 20.
*  LS_FIELD-OUTPUTLEN = 20.
*  LS_FIELD-REPTEXT = '생산계획ID'.
*  APPEND LS_FIELD TO LT_FIELDS.
*
*  CLEAR LS_FIELD.
*  LS_FIELD-FIELDNAME = 'PNAME1'.
*  LS_FIELD-INTLEN = 20.
*  LS_FIELD-LENG = 20.
*  LS_FIELD-OUTPUTLEN = 20.
*  LS_FIELD-REPTEXT = '플랜트명'.
*  APPEND LS_FIELD TO LT_FIELDS.
*
*  CLEAR LS_FIELD.
*  LS_FIELD-FIELDNAME = 'WERKS'.
*  LS_FIELD-INTLEN = 20.
*  LS_FIELD-LENG = 20.
*  LS_FIELD-OUTPUTLEN = 20.
*  LS_FIELD-REPTEXT = '플랜트'.
*  APPEND LS_FIELD TO LT_FIELDS.
*
*  CLEAR LS_FIELD.
*  LS_FIELD-FIELDNAME = 'MATNR'.
*  LS_FIELD-INTLEN = 20.
*  LS_FIELD-LENG = 20.
*  LS_FIELD-OUTPUTLEN = 20.
*  LS_FIELD-REPTEXT = '자재코드'.
*  APPEND LS_FIELD TO LT_FIELDS.
*
*  CLEAR LS_FIELD.
*  LS_FIELD-FIELDNAME = 'MAKTX'.
*  LS_FIELD-INTLEN = 20.
*  LS_FIELD-LENG = 20.
*  LS_FIELD-OUTPUTLEN = 20.
*  LS_FIELD-REPTEXT = '자재명'.
*  APPEND LS_FIELD TO LT_FIELDS.
*
*
****  CLEAR: LT_MAP.
****  LT_MAP-FLDNAME = 'BOMID'.
****  LT_MAP-DYFLDNAME = 'ZEA_STKO-BOMID'.
****  APPEND LT_MAP.
****
****  CLEAR: LT_MAP.
****  LT_MAP-FLDNAME = 'WERKS'.
****  LT_MAP-DYFLDNAME = 'ZEA_STKO-WERKS'.
****  APPEND LT_MAP.
****
****  CLEAR: LT_MAP.
****  LT_MAP-FLDNAME = 'PNAME1'.
****  LT_MAP-DYFLDNAME = 'ZEA_T001W-PNAME1'.
****  APPEND LT_MAP.
****
****  CLEAR: LT_MAP.
****  LT_MAP-FLDNAME = 'MATNR'.
****  LT_MAP-DYFLDNAME = 'ZEA_STKO-MATNR'.
****  APPEND LT_MAP.
****
****  CLEAR: LT_MAP.
****  LT_MAP-FLDNAME = 'MAKTX'.
****  LT_MAP-DYFLDNAME = 'ZEA_MMT020-MAKTX'.
****  APPEND LT_MAP.
****
****  CLEAR: LT_MAP.
****  LT_MAP-FLDNAME = 'MATTYPE'.
****  LT_MAP-DYFLDNAME = 'ZEA_MMT010-MATTYPE'.
****  APPEND LT_MAP.
****
****  CLEAR: LT_MAP.
****  LT_MAP-FLDNAME = 'MENGE'.
****  LT_MAP-DYFLDNAME = 'ZEA_STKO-MENGE'.
****  APPEND LT_MAP.
****
****  CLEAR: LT_MAP.
****  LT_MAP-FLDNAME = 'MEINS'.
****  LT_MAP-DYFLDNAME = 'ZEA_STKO-MEINS'.
****  APPEND LT_MAP.
**
**
**
**
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      RETFIELD        = 'RTID'           " Name of return field in FIELD_TAB
      DYNPPROG        = SY-REPID          " Current program
      DYNPNR          = SY-DYNNR          " Screen number
*     DYNPROFIELD     = 'ZEA_STKO-BOMID'
      WINDOW_TITLE    = '공정 ID'        " Title for the hit list
      VALUE_ORG       = 'S'               " Value return: C: cell by cell, S: structured
    TABLES
*     FIELD_TAB       = LT_FIELDS[]
      VALUE_TAB       = LT_RTID[]                 " Table of values: entries cell by cell
      RETURN_TAB      = LT_RETURN_TAB[]
*     DYNPFLD_MAPPING = LT_MAP
    EXCEPTIONS
      PARAMETER_ERROR = 1                " Incorrect parameter
      NO_VALUES_FOUND = 2                " No values found
      OTHERS          = 3.

  IF SY-SUBRC EQ 0.
    READ TABLE LT_RETURN_TAB INTO LS_RETURN_TAB INDEX 1.
    IF SY-SUBRC EQ 0.
      ZEA_PLKO-RTID = LS_RETURN_TAB-FIELDVAL.

      READ TABLE LT_RTID WITH KEY RTID = ZEA_PLKO-RTID BINARY SEARCH.
      IF SY-SUBRC EQ 0.
        ZEA_PLKO-RTID     = LT_RTID-RTID.
*        ZEA_PLKO-RTNAME   = LT_RTID-RTNAME.
        ZEA_PLKO-AUFNR    = LT_RTID-AUFNR.
        ZEA_T001W-PNAME1  = LT_RTID-PNAME1.
        ZEA_T001W-WERKS   = LT_RTID-WERKS.
        ZEA_MMT020-MAKTX  = LT_RTID-MAKTX.
        ZEA_MMT020-MATNR  = LT_RTID-MATNR.
        LEAVE SCREEN.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SEARCH_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SEARCH_DATA .

*  RANGES GR_RTID   FOR ZEA_PLKO-RTID.
  RANGES R_AUFNR  FOR ZEA_PLKO-AUFNR.
  RANGES R_PNAME1 FOR ZEA_T001W-PNAME1.
  RANGES R_MAKTX  FOR ZEA_MMT020-MAKTX.

  REFRESH GR_RTID[].
  CLEAR GR_RTID.
  REFRESH R_AUFNR[].
  CLEAR R_AUFNR.
  REFRESH R_PNAME1[].
  CLEAR R_PNAME1.
  REFRESH R_MAKTX[].
  CLEAR R_MAKTX.

  IF ZEA_PLKO-RTID IS NOT INITIAL.
    GR_RTID-SIGN    = 'I'.
    GR_RTID-OPTION  = 'EQ'.
    GR_RTID-LOW     = ZEA_PLKO-RTID.
    APPEND GR_RTID.
  ENDIF.

  IF ZEA_PLKO-AUFNR IS NOT INITIAL.
    R_AUFNR-SIGN    = 'I'.
    R_AUFNR-OPTION  = 'EQ'.
    R_AUFNR-LOW     = ZEA_PLKO-AUFNR.
    APPEND R_AUFNR.
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
    R_MAKTX-LOW      = ZEA_MMT020-MAKTX.
    APPEND R_MAKTX.
  ENDIF.

  SELECT   A~RTID
*           A~RTNAME
           A~RTSTEP
           A~AUFNR
*           B~PNAME1
           A~QTY
           A~UNIT
           B~WERKS
           C~MAKTX
           C~MATNR
           A~RTST
           A~RTET
  INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY
  FROM ZEA_PLKO   AS A
  JOIN ZEA_T001W  AS B
                  ON B~WERKS EQ A~WERKS
  JOIN ZEA_MMT020 AS C
                  ON C~MATNR EQ A~MATNR
                 AND C~SPRAS EQ SY-LANGU
 WHERE A~RTID   IN GR_RTID
   AND A~AUFNR  IN R_AUFNR
   AND B~PNAME1 IN R_PNAME1
   AND C~MAKTX  IN R_MAKTX .


  SORT GT_DISPLAY BY RTID.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_1_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT_1_0100 .

  CHECK SY-UNAME EQ 'ACA5-03'
       OR SY-UNAME EQ 'ACA5-07'
       OR SY-UNAME EQ 'ACA5-08'
       OR SY-UNAME EQ 'ACA5-10'
       OR SY-UNAME EQ 'ACA5-12'
       OR SY-UNAME EQ 'ACA5-15'
       OR SY-UNAME EQ 'ACA5-17'
       OR SY-UNAME EQ 'ACA5-23'
       OR SY-UNAME EQ 'ACA-05'.

  CREATE OBJECT GO_CONTAINER_1
    EXPORTING
      CONTAINER_NAME = 'CCON1'
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
*& Form SET_ALV_FIELDCAT_1_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_ALV_FIELDCAT_1_0100 .

  PERFORM GET_FIELDCAT2   USING    GT_DISPLAY2
                          CHANGING GT_FIELDCAT.
  PERFORM MAKE_FIELDCAT_0100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_LAYOUT_1_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_ALV_LAYOUT_1_0100 .

  CLEAR GS_LAYOUT_1.

  GS_LAYOUT_1-CWIDTH_OPT = 'A'.
  GS_LAYOUT_1-ZEBRA      = ABAP_ON.
  GS_LAYOUT_1-SEL_MODE   = 'D'.

  GS_LAYOUT_1-CTAB_FNAME = 'IT_FIELD_COLORS'. " 셀 별 색상


ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_EVENT_1_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_ALV_EVENT_1_0100 .

  SET HANDLER LCL_EVENT_HANDLER=>ON_TOOLBAR FOR GO_ALV_GRID_1.
  SET HANDLER LCL_EVENT_HANDLER=>ON_DOUBLE_CLICK FOR GO_ALV_GRID_1.
  SET HANDLER LCL_EVENT_HANDLER=>ON_USER_COMMAND FOR GO_ALV_GRID_1.
  SET HANDLER LCL_EVENT_HANDLER=>ON_HOTSPOT_CLICK FOR GO_ALV_GRID_1.
  SET HANDLER LCL_EVENT_HANDLER=>ON_BUTTON_CLICK FOR GO_ALV_GRID_1.
  SET HANDLER LCL_EVENT_HANDLER=>ON_FINISHED FOR GO_TIMER.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_TOOLBAR_1_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_TOOLBAR_1_0100 .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_1_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV_1_0100 .

  CALL METHOD GO_ALV_GRID_1->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
*     I_STRUCTURE_NAME              = ''
      IS_VARIANT                    = GS_VARIANT
      I_SAVE                        = GV_SAVE
      IS_LAYOUT                     = GS_LAYOUT_1
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
*& Form REFRESH_ALV_1_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM REFRESH_ALV_1_0100 .

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
*& Form MODIFY_DISPLAY_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM MODIFY_DISPLAY_DATA .

  DATA LS_STYLE TYPE LVC_S_STYL.



  LOOP AT GT_DISPLAY INTO GS_DISPLAY.

    CLEAR GS_DISPLAY-IT_FIELD_COLORS.

    IF GS_DISPLAY-RTST IS INITIAL.
      GS_DISPLAY-LIGHT = 1. " 빨간불
    ELSEIF GS_DISPLAY-RTET IS INITIAL.
      GS_DISPLAY-LIGHT = 2. " 초록불
    ELSE.
      GS_DISPLAY-LIGHT = 3.
    ENDIF.

    CASE GS_DISPLAY-RTSTEP.
      WHEN 1.
        CLEAR GS_FIELD_COLOR.
        GS_FIELD_COLOR-FNAME = 'RTSTEP'.
        GS_FIELD_COLOR-COLOR-COL = 6. " 빨강
        GS_FIELD_COLOR-COLOR-INT = 0.
        GS_FIELD_COLOR-COLOR-INV = 0.
        APPEND GS_FIELD_COLOR TO GS_DISPLAY-IT_FIELD_COLORS.
      WHEN 2.
        CLEAR GS_FIELD_COLOR.
        GS_FIELD_COLOR-FNAME = 'RTSTEP'.
        GS_FIELD_COLOR-COLOR-COL = 7. " 주황
        GS_FIELD_COLOR-COLOR-INT = 0.
        GS_FIELD_COLOR-COLOR-INV = 0.
        APPEND GS_FIELD_COLOR TO GS_DISPLAY-IT_FIELD_COLORS.
      WHEN 3.
        CLEAR GS_FIELD_COLOR.
        GS_FIELD_COLOR-FNAME = 'RTSTEP'.
        GS_FIELD_COLOR-COLOR-COL = 3. " 노랑
        GS_FIELD_COLOR-COLOR-INT = 0.
        GS_FIELD_COLOR-COLOR-INV = 0.
        APPEND GS_FIELD_COLOR TO GS_DISPLAY-IT_FIELD_COLORS.
      WHEN 4.
        CLEAR GS_FIELD_COLOR.
        GS_FIELD_COLOR-FNAME = 'RTSTEP'.
        GS_FIELD_COLOR-COLOR-COL = 4. " 파랑
        GS_FIELD_COLOR-COLOR-INT = 0.
        GS_FIELD_COLOR-COLOR-INV = 0.
        APPEND GS_FIELD_COLOR TO GS_DISPLAY-IT_FIELD_COLORS.
      WHEN 5.
        CLEAR GS_FIELD_COLOR.
        GS_FIELD_COLOR-FNAME = 'RTSTEP'.
        GS_FIELD_COLOR-COLOR-COL = 1. " 하늘
        GS_FIELD_COLOR-COLOR-INT = 0.
        GS_FIELD_COLOR-COLOR-INV = 0.
        APPEND GS_FIELD_COLOR TO GS_DISPLAY-IT_FIELD_COLORS.
      WHEN 6.
        CLEAR GS_FIELD_COLOR.
        GS_FIELD_COLOR-FNAME = 'RTSTEP'.
        GS_FIELD_COLOR-COLOR-COL = 5. " 초록
        GS_FIELD_COLOR-COLOR-INT = 0.
        GS_FIELD_COLOR-COLOR-INV = 0.
        APPEND GS_FIELD_COLOR TO GS_DISPLAY-IT_FIELD_COLORS.
    ENDCASE.

    MODIFY GT_DISPLAY FROM GS_DISPLAY.

  ENDLOOP.

  LOOP AT GT_DISPLAY2 INTO GS_DISPLAY2.
    CASE GS_DISPLAY2-RTSTEP.
      WHEN 1.
        CLEAR GS_FIELD_COLOR.
        GS_FIELD_COLOR-FNAME = 'RTSTEP'.
        GS_FIELD_COLOR-COLOR-COL = 6. " 빨강
        GS_FIELD_COLOR-COLOR-INT = 0.
        GS_FIELD_COLOR-COLOR-INV = 0.
        APPEND GS_FIELD_COLOR TO GS_DISPLAY2-IT_FIELD_COLORS.
      WHEN 2.
        CLEAR GS_FIELD_COLOR.
        GS_FIELD_COLOR-FNAME = 'RTSTEP'.
        GS_FIELD_COLOR-COLOR-COL = 7. " 주황
        GS_FIELD_COLOR-COLOR-INT = 0.
        GS_FIELD_COLOR-COLOR-INV = 0.
        APPEND GS_FIELD_COLOR TO GS_DISPLAY2-IT_FIELD_COLORS.
      WHEN 3.
        CLEAR GS_FIELD_COLOR.
        GS_FIELD_COLOR-FNAME = 'RTSTEP'.
        GS_FIELD_COLOR-COLOR-COL = 3. " 노랑
        GS_FIELD_COLOR-COLOR-INT = 0.
        GS_FIELD_COLOR-COLOR-INV = 0.
        APPEND GS_FIELD_COLOR TO GS_DISPLAY2-IT_FIELD_COLORS.
      WHEN 4.
        CLEAR GS_FIELD_COLOR.
        GS_FIELD_COLOR-FNAME = 'RTSTEP'.
        GS_FIELD_COLOR-COLOR-COL = 4. " 파랑
        GS_FIELD_COLOR-COLOR-INT = 0.
        GS_FIELD_COLOR-COLOR-INV = 0.
        APPEND GS_FIELD_COLOR TO GS_DISPLAY2-IT_FIELD_COLORS.
      WHEN 5.
        CLEAR GS_FIELD_COLOR.
        GS_FIELD_COLOR-FNAME = 'RTSTEP'.
        GS_FIELD_COLOR-COLOR-COL = 1. " 하늘
        GS_FIELD_COLOR-COLOR-INT = 0.
        GS_FIELD_COLOR-COLOR-INV = 0.
        APPEND GS_FIELD_COLOR TO GS_DISPLAY2-IT_FIELD_COLORS.
      WHEN 6.
        CLEAR GS_FIELD_COLOR.
        GS_FIELD_COLOR-FNAME = 'RTSTEP'.
        GS_FIELD_COLOR-COLOR-COL = 5. " 초록
        GS_FIELD_COLOR-COLOR-INT = 0.
        GS_FIELD_COLOR-COLOR-INV = 0.
        APPEND GS_FIELD_COLOR TO GS_DISPLAY2-IT_FIELD_COLORS.
    ENDCASE.

    MODIFY GT_DISPLAY2 FROM GS_DISPLAY2.
  ENDLOOP.

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
*& Form COMPLETE_FILTER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM COMPLETE_FILTER .

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
*& Form PROCESS_FILTER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM PROCESS_FILTER .

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
  GS_FILTER-LOW       = '1'.
  APPEND GS_FILTER TO GT_FILTER.

  PERFORM SET_ALV_FILTER.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DO_PROCESS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DO_PROCESS .

  CALL METHOD GO_ALV_GRID_1->GET_SELECTED_ROWS
    IMPORTING
      ET_INDEX_ROWS = GT_INDEX_ROWS     " Indexes of Selected Rows
*     ET_ROW_NO     =                  " Numeric IDs of Selected Rows
*    ALV REFERSH
    .

  GO_TIMER->RUN( ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GO_PROCESS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM GO_PROCESS .

  CALL METHOD GO_ALV_GRID->GET_SELECTED_ROWS
    IMPORTING
      ET_INDEX_ROWS = GT_INDEX_ROWS     " Indexes of Selected Rows
*     ET_ROW_NO     =                  " Numeric IDs of Selected Rows
    .

  IF GT_INDEX_ROWS[] IS INITIAL.
    " TEXT-M01: 라인을 선택하세요.
    MESSAGE S000 DISPLAY LIKE 'W' WITH '최소 한 행이상 선택하세요'.

  ELSE.

    GV_CHECK = ABAP_ON.

    REFRESH GR_RTID[].
    CLEAR GR_RTID.

    LOOP AT GT_INDEX_ROWS INTO GS_INDEX_ROWS WHERE ROWTYPE IS INITIAL.

      READ TABLE GT_DISPLAY INTO GS_DISPLAY INDEX GS_INDEX_ROWS-INDEX.

      GR_RTID-SIGN    = 'I'.
      GR_RTID-OPTION  = 'EQ'.
      GR_RTID-LOW     = GS_DISPLAY-RTID.
      APPEND GR_RTID.

    ENDLOOP.

    CASE  TABSTRIP-ACTIVETAB.
      WHEN 'TAB1'.
        PERFORM SELECT_STEP1.
      WHEN 'TAB2'.
        PERFORM SELECT_STEP2.
      WHEN 'TAB3'.
        PERFORM SELECT_STEP3.
      WHEN 'TAB4'.
        PERFORM SELECT_STEP4.
      WHEN 'TAB5'.
        PERFORM SELECT_STEP5.
      WHEN 'TAB6'.
        PERFORM SELECT_STEP6.
    ENDCASE.







  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_STEP1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SELECT_STEP1 .
  REFRESH GT_DISPLAY2.

*  REFRESH GR_RTID[].
*  CLEAR GR_RTID.
*
*  IF ZEA_PLKO-RTID IS NOT INITIAL.
*    GR_RTID-SIGN    = 'I'.
*    GR_RTID-OPTION  = 'EQ'.
*    GR_RTID-LOW     = ZEA_PLKO-RTID.
*    APPEND GR_RTID.
*  ENDIF.

  SELECT *
  INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY2
  FROM ZEA_PLPO
  WHERE RTSTEP EQ 1
    AND RTID IN GR_RTID.

  PERFORM MODIFY_DISPLAY_DATA.
  PERFORM REFRESH_ALV_1_0100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_STEP2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SELECT_STEP2 .

  REFRESH GT_DISPLAY2.

  SELECT *
  INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY2
  FROM ZEA_PLPO
  WHERE RTSTEP EQ 2
    AND RTID IN GR_RTID.

  PERFORM MODIFY_DISPLAY_DATA.
  PERFORM REFRESH_ALV_1_0100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_STEP2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SELECT_STEP3 .

  REFRESH GT_DISPLAY2.

  SELECT *
  INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY2
  FROM ZEA_PLPO
  WHERE RTSTEP EQ 3
    AND RTID IN GR_RTID.

  PERFORM MODIFY_DISPLAY_DATA.
  PERFORM REFRESH_ALV_1_0100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_STEP2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SELECT_STEP4.

  REFRESH GT_DISPLAY2.

  SELECT *
  INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY2
  FROM ZEA_PLPO
  WHERE RTSTEP EQ 4
    AND RTID IN GR_RTID.

  PERFORM MODIFY_DISPLAY_DATA.
  PERFORM REFRESH_ALV_1_0100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_STEP2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SELECT_STEP5.

  REFRESH GT_DISPLAY2.

  SELECT *
  INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY2
  FROM ZEA_PLPO
  WHERE RTSTEP EQ 5
    AND RTID IN GR_RTID.

  PERFORM MODIFY_DISPLAY_DATA.
  PERFORM REFRESH_ALV_1_0100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_STEP2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SELECT_STEP6.

  REFRESH GT_DISPLAY2.

  SELECT *
  INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY2
  FROM ZEA_PLPO
  WHERE RTSTEP EQ 6
    AND RTID IN GR_RTID.

  PERFORM MODIFY_DISPLAY_DATA.
  PERFORM REFRESH_ALV_1_0100.

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
*& Form SEARCH_ALL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SEARCH_ALL .

  CLEAR: ZEA_PLKO, ZEA_PLPO, ZEA_T001W, ZEA_MMT020.

  SELECT A~RTID
         A~RTSTEP
         A~AUFNR
         A~WERKS
*         C~PNAME1
         A~MATNR
         B~MAKTX
*         A~RTNAME
         A~QTY
         A~UNIT
         A~RTST
         A~RTET

    INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY
    FROM ZEA_PLKO   AS A
    JOIN ZEA_MMT020 AS B
                    ON B~MATNR EQ A~MATNR
                   AND B~SPRAS EQ SY-LANGU
    JOIN ZEA_T001W  AS C
                    ON C~WERKS EQ A~WERKS.


  SORT GT_DISPLAY BY RTID.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form CALC_BOM
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CALC_SUB_MAT .

  REFRESH GT_STPO.

  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE GT_STPO
    FROM ZEA_STPO AS A
    JOIN ZEA_MMT020 AS B ON B~MATNR EQ A~MATNR
                          AND B~SPRAS EQ SY-LANGU
    JOIN ZEA_MMT010 AS C ON C~MATNR EQ A~MATNR
    WHERE BOMID EQ GV_BOMID.

  PERFORM CAL_BOM.

  SELECT SINGLE TOT_QTY
    INTO GV_TOT_QTY
    FROM ZEA_AUFK
   WHERE AUFNR EQ GS_DISPLAY-AUFNR.

  LOOP AT GT_STPO INTO GS_STPO.
    GS_STPO-MENGE = GS_STPO-MENGE * GV_TOT_QTY * 4.
    MODIFY GT_STPO FROM GS_STPO.
  ENDLOOP.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form CALC_BOM
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LT_STPO
*&---------------------------------------------------------------------*
FORM CAL_BOM.

  LOOP AT GT_STPO INTO GS_STPO WHERE MATTYPE = '반제품'.

    SELECT SINGLE BOMID FROM ZEA_STKO
     WHERE MATNR EQ @GS_STPO-MATNR
       AND MENGE EQ @GS_STPO-MENGE
       AND MEINS EQ @GS_STPO-MEINS
      INTO @DATA(LV_BOMID).

    SELECT *
      FROM ZEA_STKO AS A
      JOIN ZEA_STPO AS B   ON B~BOMID EQ A~BOMID
      JOIN ZEA_MMT020 AS C ON C~MATNR EQ B~MATNR
                          AND C~SPRAS EQ SY-LANGU
      JOIN ZEA_MMT010 AS D ON D~MATNR EQ B~MATNR
      APPENDING CORRESPONDING FIELDS OF TABLE GT_STPO
      WHERE A~BOMID EQ LV_BOMID.

    DELETE GT_STPO. " 반제품인 현재 라인은 제거

  ENDLOOP.

ENDFORM.
