*&---------------------------------------------------------------------*
*& Include          ZALV_GRID_DISPLAY_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form MAKE_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM MAKE_FIELDCAT_0100 .

  LOOP AT GT_FIELDCAT INTO GS_FIELDCAT.

    CASE GS_FIELDCAT-FIELDNAME.
      WHEN 'MRPID'.
        GS_FIELDCAT-HOTSPOT = ABAP_ON.
      WHEN 'LOEKZ'.
        GS_FIELDCAT-NO_OUT  = ABAP_ON.
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

  LOOP AT GT_FIELDCAT2 INTO GS_FIELDCAT2.

    CASE GS_FIELDCAT2-FIELDNAME.
      WHEN 'LOEKZ'.
        GS_FIELDCAT2-NO_OUT     = ABAP_ON.
      WHEN 'STOCK'.
        GS_FIELDCAT2-QFIELDNAME = 'MEINS'.
      WHEN 'USEQTY'.
        GS_FIELDCAT2-QFIELDNAME = 'MEINS'.
      WHEN 'REQQTY'.
        GS_FIELDCAT2-QFIELDNAME = 'MEINS'.
      WHEN 'MEINS'.
        GS_FIELDCAT2-COLTEXT    = '단위'.
      WHEN 'STATUS'.
        GS_FIELDCAT2-COLTEXT = 'Status'.
        GS_FIELDCAT2-ICON    = ABAP_ON.
        GS_FIELDCAT2-KEY     = ABAP_OFF.
        GS_FIELDCAT2-NO_OUT  = ABAP_ON.
      WHEN 'COLOR'.
        GS_FIELDCAT2-NO_OUT  = ABAP_ON.
      WHEN 'LIGHT'.
        GS_FIELDCAT2-COLTEXT = '구매 요청 상태'.
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
  CLEAR GS_LAYOUT2.
  CLEAR GS_VARIANT.
  CLEAR GV_SAVE.

  GS_VARIANT-REPORT = SY-REPID.
  GV_SAVE = 'A'.   " '' : Layout 저장불가

  GS_LAYOUT-CWIDTH_OPT = 'A'.
  GS_LAYOUT-ZEBRA      = ABAP_ON.
  GS_LAYOUT-SEL_MODE   = 'D'.

  GS_LAYOUT2-CWIDTH_OPT = 'A'.
  GS_LAYOUT2-ZEBRA      = ABAP_ON.
  GS_LAYOUT2-SEL_MODE   = 'D'.

  GS_LAYOUT2-EXCP_FNAME = 'LIGHT'.           " 신호등
  GS_LAYOUT2-EXCP_LED = ABAP_ON.             " 신호등 모양 변경
  GS_LAYOUT2-CTAB_FNAME = 'IT_FIELD_COLORS'. " 셀 별 색상
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_DATA
*&---------------------------------------------------------------------*
FORM SELECT_DATA .

  REFRESH GT_DATA.
  REFRESH GT_DATA2.

  SELECT *
    FROM ZEA_MDKP
    INTO CORRESPONDING FIELDS OF TABLE GT_DATA
    WHERE MRPID IN SO_MRPID
      AND PDPDAT IN SO_PDAT
      AND PDPMON IN SO_PMON
      AND LOEKZ NE 'X'.

  SORT GT_DATA BY MRPID.

*  SELECT *
*  FROM ZEA_MDTB AS A
*  JOIN ZEA_MMT020 AS B ON B~MATNR EQ A~MATNR
*                      AND B~SPRAS EQ SY-LANGU
*  INTO CORRESPONDING FIELDS OF TABLE GT_DATA2
*  WHERE MRPID IN SO_MRPID.
*
*  SORT GT_DATA2 BY MRPID MATNR.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM MAKE_DISPLAY_DATA .

  REFRESH GT_DISPLAY.
  REFRESH GT_DISPLAY2.

  DATA: LT_MMT130 TYPE TABLE OF ZEA_MMT130,
        LS_MMT130 TYPE ZEA_MMT130.

  SELECT MRPID
    FROM ZEA_MMT130
    INTO CORRESPONDING FIELDS OF TABLE LT_MMT130.

  LOOP AT GT_DATA INTO GS_DATA.

    CLEAR GS_DISPLAY.

    MOVE-CORRESPONDING GS_DATA TO GS_DISPLAY.

*신규 필드------------------------------------------------------------*


*--------------------------------------------------------------------*
    APPEND GS_DISPLAY TO GT_DISPLAY.

  ENDLOOP.

  LOOP AT GT_DATA2 INTO GS_DATA2.

    CLEAR GS_DISPLAY2.

    MOVE-CORRESPONDING GS_DATA2 TO GS_DISPLAY2.

*신규 필드------------------------------------------------------------*

    IF GS_DISPLAY2-REQQTY NE 0.
      CLEAR GS_FIELD_COLOR.
      GS_FIELD_COLOR-FNAME = 'REQQTY'.
      GS_FIELD_COLOR-COLOR-COL = 6. " 빨강
      GS_FIELD_COLOR-COLOR-INT = 0.
      GS_FIELD_COLOR-COLOR-INV = 0.
      APPEND GS_FIELD_COLOR TO GS_DISPLAY2-IT_FIELD_COLORS.
    ENDIF.

    READ TABLE LT_MMT130 INTO LS_MMT130 WITH KEY MRPID = GS_DISPLAY2-MRPID.

    IF SY-SUBRC EQ 0.
      GS_DISPLAY2-LIGHT = 3.
    ELSE.
      GS_DISPLAY2-LIGHT = 2.
    ENDIF.

*--------------------------------------------------------------------*
    APPEND GS_DISPLAY2 TO GT_DISPLAY2.

  ENDLOOP.

  DESCRIBE TABLE GT_DISPLAY LINES GV_LINES.

  IF GT_DISPLAY IS INITIAL.
    MESSAGE S013 DISPLAY LIKE 'W'.
  ELSE.
    MESSAGE S006 WITH GV_LINES.
  ENDIF.

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

*  " CLASSIC 한 메소드 호출 방법
*  CALL METHOD GO_SPLIT->GET_CONTAINER
*    EXPORTING
*      ROW       = 1 " Row
*      COLUMN    = 1 " Column
*    RECEIVING
*      CONTAINER = GO_CON_TOP. " Container
*
*  CALL METHOD GO_SPLIT->GET_CONTAINER
*    EXPORTING
*      ROW       = 2 " Row
*      COLUMN    = 1 " Column
*    RECEIVING
*      CONTAINER = GO_CON_BOT. " Container

  " 신문법 중 하나
  GO_CONTAINER_1 = GO_SPLIT->GET_CONTAINER( ROW = 1 COLUMN = 1 ).
  GO_CONTAINER_2 = GO_SPLIT->GET_CONTAINER( ROW = 2 COLUMN = 1 ).

  CALL METHOD GO_SPLIT->SET_ROW_HEIGHT
    EXPORTING
      ID                = 1                 " Row ID
      HEIGHT            = 33                 " Height
    .

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
*& Form DISPLAY_ALV_0100
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV_0100 .

  CALL METHOD GO_ALV_GRID_1->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
      I_STRUCTURE_NAME              = 'ZEA_MDKP'
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

  CALL METHOD GO_ALV_GRID_2->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
      I_STRUCTURE_NAME              = 'ZEA_MDTB'
      IS_VARIANT                    = GS_VARIANT
      I_SAVE                        = GV_SAVE
      IS_LAYOUT                     = GS_LAYOUT2
    CHANGING
      IT_OUTTAB                     = GT_DISPLAY2
      IT_FIELDCATALOG               = GT_FIELDCAT2
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
  PERFORM GET_FIELDCAT2   USING    GT_DISPLAY2
                          CHANGING GT_FIELDCAT2.
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

  SET HANDLER LCL_EVENT_HANDLER=>ON_TOOLBAR FOR GO_ALV_GRID_2.
  SET HANDLER LCL_EVENT_HANDLER=>ON_DOUBLE_CLICK FOR GO_ALV_GRID_2.
  SET HANDLER LCL_EVENT_HANDLER=>ON_USER_COMMAND FOR GO_ALV_GRID_2.
  SET HANDLER LCL_EVENT_HANDLER=>ON_HOTSPOT_CLICK FOR GO_ALV_GRID_2.

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
*& Form HANDLER_TOOLBAR
*&---------------------------------------------------------------------*
FORM HANDLER_TOOLBAR
  USING PO_OBJECT TYPE REF TO CL_ALV_EVENT_TOOLBAR_SET
        PO_SENDER TYPE REF TO CL_GUI_ALV_GRID.

  " Internal Table PO_OBJECT->MT_TOOLBAR 를 위한 작업공간
  " PO_OBJECT->MT_TOOLBAR >>> 클래스의 Attribute ( Public , Instance )
  DATA LS_TOOLBAR LIKE LINE OF PO_OBJECT->MT_TOOLBAR.

  CASE PO_SENDER.
    WHEN GO_ALV_GRID_2.

      DATA LV_TOTAL TYPE I.
      DATA LV_RED TYPE I.
      DATA LV_GREEN TYPE I.
      DATA LV_YELLOW TYPE I.

      DESCRIBE TABLE GT_DISPLAY2.

      LOOP AT GT_DISPLAY2 INTO GS_DISPLAY2.
        ADD 1 TO LV_TOTAL.

        IF GS_DISPLAY2-REQQTY GT 0.
          ADD 1 TO LV_RED.
        ENDIF.

        CASE GS_DISPLAY2-LIGHT.
          WHEN 3.
            ADD 1 TO LV_GREEN.
          WHEN 2.
            ADD 1 TO LV_YELLOW.
        ENDCASE.

      ENDLOOP.

*     구분자 =>> |
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 3. " 구분자
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 전체조회
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-FUNCTION = GC_NO_FILTER.
      LS_TOOLBAR-TEXT = | 전체조회 : { SY-TFILL } |.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 승인
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-FUNCTION = GC_LACK.
      LS_TOOLBAR-ICON = ICON_LED_RED.
      LS_TOOLBAR-TEXT = | 부족한 자재 : { LV_RED }  |.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

*     구분자 =>> |
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 3. " 구분자
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 구매 요청 대기
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-FUNCTION = GC_PO_WAIT.
      LS_TOOLBAR-ICON = ICON_LED_YELLOW.
      LS_TOOLBAR-TEXT = | 구매 요청 대기건 : { LV_YELLOW } |.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 구매 요청 건
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-FUNCTION = GC_PO.
      LS_TOOLBAR-ICON = ICON_LED_GREEN.
      LS_TOOLBAR-TEXT = | 구매 요청건 : { LV_GREEN }  |.
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
    WHEN GO_ALV_GRID_1. "PO_SENDER 가 GO_ALV_GRID1 일 때
    WHEN GO_ALV_GRID_2. "PO_SENDER 가 GO_ALV_GRID2 일 때
      CASE PV_UCOMM.  " 선택한 버튼 (PV_UCOMM은 SY-UCOMM 타입)

        WHEN GC_NO_FILTER.
          PERFORM NO_FILTER.

        WHEN GC_LACK.
          PERFORM LACK_FILTER.

        WHEN GC_PO_WAIT.
          PERFORM PO_WAIT_FILTER.

        WHEN GC_PO.
          PERFORM PO_FILTER.

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

*   HOTSPOT 옵션이 적용된 필드들 중에서
  CASE PO_SENDER.
    WHEN GO_ALV_GRID_1.
      CASE PS_COLUMN_ID-FIELDNAME.
        WHEN 'MRPID'.
          READ TABLE GT_DISPLAY INTO GS_DISPLAY INDEX PS_ROW_ID-INDEX.

          SELECT A~MRPID
                 A~MATNR
                 B~MAKTX
                 A~STOCK
                 A~USEQTY
                 A~REQQTY
                 A~MEINS
                 A~PLANSDATE
                 A~PLANEDATE
                 A~LOEKZ
                 A~ERNAM
                 A~ERDAT
                 A~ERZET
                 A~AENAM
                 A~AEDAT
                 A~AEZET

            INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY2
            FROM ZEA_MDTB AS A
            JOIN ZEA_MMT020 AS B ON B~MATNR EQ A~MATNR
                      AND B~SPRAS EQ SY-LANGU
            WHERE A~MRPID EQ GS_DISPLAY-MRPID.

          DATA: LT_MMT130 TYPE TABLE OF ZEA_MMT130,
                LS_MMT130 TYPE ZEA_MMT130.

          SELECT MRPID
            FROM ZEA_MMT130
            INTO CORRESPONDING FIELDS OF TABLE LT_MMT130.

          LOOP AT GT_DISPLAY2 INTO GS_DISPLAY2.

            IF GS_DISPLAY2-REQQTY GT 0.
              CLEAR GS_FIELD_COLOR.
              GS_FIELD_COLOR-FNAME = 'REQQTY'.
              GS_FIELD_COLOR-COLOR-COL = 6. " 빨강
              GS_FIELD_COLOR-COLOR-INT = 0.
              GS_FIELD_COLOR-COLOR-INV = 0.
              APPEND GS_FIELD_COLOR TO GS_DISPLAY2-IT_FIELD_COLORS.
            ENDIF.

            READ TABLE LT_MMT130 INTO LS_MMT130 WITH KEY MRPID = GS_DISPLAY2-MRPID.

            IF SY-SUBRC EQ 0.
              GS_DISPLAY2-LIGHT = 3.
            ELSE.
              GS_DISPLAY2-LIGHT = 2.
            ENDIF.

            MODIFY GT_DISPLAY2 FROM GS_DISPLAY2.

          ENDLOOP.

          PERFORM REFRESH_ALV_0100.

      ENDCASE.
  ENDCASE.

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

  READ TABLE GT_DISPLAY INTO GS_DISPLAY INDEX PS_ROW-INDEX.


  PERFORM REFRESH_ALV_0100.


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
*& Form LACK_FILTER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM LACK_FILTER .

  REFRESH GT_FILTER.

  CLEAR GS_FILTER.
  GS_FILTER-FIELDNAME = 'REQQTY'.
  GS_FILTER-SIGN      = 'I'.
  GS_FILTER-OPTION    = 'GT'.
  GS_FILTER-LOW       = '0'.
  APPEND GS_FILTER TO GT_FILTER.

  PERFORM SET_ALV_FILTER.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form PO_WAIT_FILTER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM PO_WAIT_FILTER .

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
*& Form PO_FILTER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM PO_FILTER .

  REFRESH GT_FILTER.

  CLEAR GS_FILTER.
  GS_FILTER-FIELDNAME = 'LIGHT'.
  GS_FILTER-SIGN      = 'I'.
  GS_FILTER-OPTION    = 'EQ'.
  GS_FILTER-LOW       = '3'.
  APPEND GS_FILTER TO GT_FILTER.

  PERFORM SET_ALV_FILTER.

ENDFORM.
