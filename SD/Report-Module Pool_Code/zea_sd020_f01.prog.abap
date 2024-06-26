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
      WHEN 'MATNR'.
*        GS_FIELDCAT-KEY     = ABAP_ON.
        GS_FIELDCAT-EDIT = ABAP_OFF.

      WHEN 'VALID_EN'.
        GS_FIELDCAT-KEY     = ABAP_ON.
        GS_FIELDCAT-EDIT = ABAP_OFF.
        GS_FIELDCAT-COL_POS = 6.
      WHEN 'VALID_ST'.
        GS_FIELDCAT-REF_TABLE = 'ZEA_SDT090'.
      WHEN 'MAKTX'.
        GS_FIELDCAT-FIELDNAME = 'MAKTX'.
        GS_FIELDCAT-COLTEXT   = '자재명'.
        GS_FIELDCAT-COL_POS   = 3.
        GS_FIELDCAT-EDIT = ABAP_OFF.
        GS_FIELDCAT-EMPHASIZE = 'C500'.
      WHEN 'WERKS'.
        GS_FIELDCAT-NO_OUT = ABAP_ON.
      WHEN 'WAERS'.
        GS_FIELDCAT-EDIT   = ABAP_OFF.
      WHEN 'NETPR'.
        GS_FIELDCAT-EMPHASIZE = 'C310'.
*        GS_FIELDCAT-CFIELDNAME = 'WAERS'.
*        GS_FIELDCAT-CURRENCY = 'KRW'.
      WHEN 'STATUS'.
        GS_FIELDCAT-COLTEXT = 'Status'.
        GS_FIELDCAT-ICON    = ABAP_ON.
        GS_FIELDCAT-KEY     = ABAP_OFF.  " ALVGRID 에서 STRUCTURE 선언 안해주면 KEY값을 여기서 설정해주면서 EDIT MODE 바뀌는 정보 설정한다.
        GS_FIELDCAT-NO_OUT  = ABAP_ON.
      WHEN 'COLOR'.
        GS_FIELDCAT-NO_OUT  = ABAP_ON.
      WHEN 'LIGHT'.
        GS_FIELDCAT-NO_OUT  = ABAP_ON.
      WHEN 'MARK'.
        GS_FIELDCAT-NO_OUT  = ABAP_ON.
      WHEN 'LOEKZ'.
        GS_FIELDCAT-JUST      = 'C'.
        GS_FIELDCAT-EDIT    = ABAP_OFF.
      WHEN 'ERNAM'.
        GS_FIELDCAT-EDIT    = ABAP_OFF.
      WHEN 'ERDAT'.
        GS_FIELDCAT-EDIT    = ABAP_OFF.
      WHEN 'ERZET'.
        GS_FIELDCAT-EDIT    = ABAP_OFF.
      WHEN 'AENAM'.
        GS_FIELDCAT-NO_OUT  = ABAP_ON.
      WHEN 'AEDAT'.
        GS_FIELDCAT-NO_OUT  = ABAP_ON.
      WHEN 'AEZET'.
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

  SELECT A~MATNR
         B~MAKTX
         A~WERKS
         A~VALID_EN
         A~VALID_ST
         A~NETPR
         A~WAERS
         A~LOEKZ
         A~ERNAM
         A~ERDAT
         A~ERZET
         A~AENAM
         A~AEDAT
         A~AEZET
    FROM ZEA_SDT090 AS A
    JOIN ZEA_MMT020 AS B
                    ON B~MATNR EQ A~MATNR
                   AND B~SPRAS EQ SY-LANGU
    INTO CORRESPONDING FIELDS OF TABLE GT_DATA.

  SORT GT_DATA BY MATNR VALID_EN.


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

    IF GS_DISPLAY-VALID_EN < SY-DATUM.
      GS_DISPLAY-LOEKZ = 'X'.
    ENDIF.

*--------------------------------------------------------------------*
    APPEND GS_DISPLAY TO GT_DISPLAY.

  ENDLOOP.

  SORT GT_DISPLAY BY MATNR.

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
      I_STRUCTURE_NAME              = 'ZEA_SDT090'
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

  CALL METHOD GO_ALV_GRID->SET_READY_FOR_INPUT
    EXPORTING
      I_READY_FOR_INPUT = 0.                " 처음 실행했을때 조회상태로 설정 ( 0으로 설정 )

  CALL METHOD GO_ALV_GRID->REGISTER_EDIT_EVENT
    EXPORTING
     I_EVENT_ID = CL_GUI_ALV_GRID=>MC_EVT_MODIFIED " Event ID
*      I_EVENT_ID = CL_GUI_ALV_GRID=>MC_EVT_ENTER   " ENTER 눌렀을때 작용하도록 설정.
    EXCEPTIONS
      ERROR      = 1                " Error
      OTHERS     = 2.

  SET HANDLER LCL_EVENT_HANDLER=>ON_TOOLBAR FOR GO_ALV_GRID.
  SET HANDLER LCL_EVENT_HANDLER=>ON_DOUBLE_CLICK FOR GO_ALV_GRID.
  SET HANDLER LCL_EVENT_HANDLER=>ON_USER_COMMAND FOR GO_ALV_GRID.
  SET HANDLER LCL_EVENT_HANDLER=>ON_HOTSPOT_CLICK FOR GO_ALV_GRID.
  SET HANDLER LCL_EVENT_HANDLER=>ON_BUTTON_CLICK FOR GO_ALV_GRID.
  SET HANDLER LCL_EVENT_HANDLER=>ON_DATA_CHANGED FOR GO_ALV_GRID.

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
*      CASE PV_UCOMM.  " 선택한 버튼 (PV_UCOMM은 SY-UCOMM 타입)

*       WHEN GC_BOOKING_CANCEL.
*          " 예약 취소
*          PERFORM BOOKING_CANCEL USING PO_SENDER.

*      ENDCASE.

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

  DATA: LS_LVC_MODI TYPE LVC_S_MODI,
        LS_STABLE   TYPE LVC_S_STBL.
  DATA: LV_ERROR.

  DATA(LT_MOD) = PR_DATA_CHANGED->MT_MOD_CELLS[].

  IF LT_MOD[] IS NOT INITIAL.
    GV_CHANGED = ABAP_ON.
  ENDIF.


*** 추가
*  LOOP AT PR_DATA_CHANGED->MT_GOOD_CELLS INTO LS_LVC_MODI.
*    CHECK LS_LVC_MODI-VALUE IS NOT INITIAL.
*    READ TABLE GT_DISPLAY INTO DATA(LS_ITAB) INDEX LS_LVC_MODI-ROW_ID.
*    CHECK SY-SUBRC = 0.
*
*    CASE LS_LVC_MODI-FIELDNAME. "입력시 점검
*
*      WHEN 'NETPR'.
*
*    ENDCASE.
*
*  ENDLOOP.


*  CALL METHOD CL_GUI_CFW=>SET_NEW_OK_CODE
*    EXPORTING
*      NEW_CODE = 'DYNP'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_DATA
*&---------------------------------------------------------------------*
FORM CREATE_DATA .


  CLEAR ZEA_MMT010-MATNR.
  CLEAR ZEA_MMT020-MAKTX.
  CLEAR ZEA_MMT010-STPRS.
  CLEAR ZEA_SDT090-NETPR.
  CLEAR ZEA_MMT010-WAERS.
  CLEAR ZEA_SDT090-WAERS.

  ZEA_SDT090-VALID_ST = SY-DATUM.
  ZEA_SDT090-VALID_EN = '99991231'.


  CALL SCREEN 0110  STARTING AT 20  7
                      ENDING AT 100 20.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form F4_HELP
*&---------------------------------------------------------------------*
FORM F4_HELP .

  " 연수야 힘내
  " 오늘 미친듯이 기억을 살려보는거야
  " -화이팅입니다!!

  DATA: LT_RETURN_TAB TYPE DDSHRETVAL OCCURS 0,
        LS_RETURN_TAB LIKE LINE OF LT_RETURN_TAB.

  DATA: LT_DSELC TYPE DSELC OCCURS 0,
        LS_DSELC LIKE LINE OF LT_DSELC.

  DATA: LS_VALUE  TYPE SEAHLPRES,
        LT_VALUE  TYPE TABLE OF SEAHLPRES,
        LS_FIELD  TYPE DFIES,
        LT_FIELDS TYPE TABLE OF DFIES.

  DATA : BEGIN OF LT_MATNR OCCURS 0,
           MATNR TYPE ZEA_MMT010-MATNR,
           MAKTX TYPE ZEA_MMT020-MAKTX,
           STPRS TYPE ZEA_STPRS_I,
*           STPRS TYPE ZEA_MMT010-STPRS,
           WAERS TYPE ZEA_MMT010-WAERS,
*           NETPR   TYPE ZEA_SDT090-NETPR,
         END OF LT_MATNR.


  DATA : BEGIN OF LT_DATA OCCURS 0,
           MATNR TYPE ZEA_MMT010-MATNR,
           MAKTX TYPE ZEA_MMT020-MAKTX,
           STPRS TYPE ZEA_MMT010-STPRS,
           WAERS TYPE ZEA_MMT010-WAERS,
*           NETPR   TYPE ZEA_SDT090-NETPR,
         END OF LT_DATA.

  DATA: LT_MAP TYPE TABLE OF DSELC WITH HEADER LINE.

  CLEAR : LT_MATNR, LT_MATNR[],
          LT_VALUE, LT_VALUE[],
          LT_FIELDS, LT_FIELDS[].


  SELECT A~MATNR
         B~MAKTX
         A~STPRS
         A~WAERS
        INTO TABLE LT_DATA
        FROM ZEA_MMT010 AS A
        JOIN ZEA_MMT020 AS B
          ON B~MATNR EQ A~MATNR
         AND B~SPRAS EQ SY-LANGU
       WHERE A~MATTYPE EQ '완제품'.

  SORT LT_DATA BY MATNR.

  LOOP AT LT_DATA.
    LT_MATNR-MATNR = LT_DATA-MATNR.
    LT_MATNR-MAKTX = LT_DATA-MAKTX.

*    LT_MATNR-STPRS = LT_DATA-STPRS.
    WRITE LT_DATA-STPRS TO LT_MATNR-STPRS CURRENCY LT_DATA-WAERS.  " 타입을 CHAR로 바꿨기 때문에 가능.
    " 정수로 주면 DUMP
    LT_MATNR-WAERS = LT_DATA-WAERS.

    APPEND LT_MATNR.

  ENDLOOP.

*  CLEAR LS_FIELD.
*  LS_FIELD-FIELDNAME = 'MATNR'.
*  LS_FIELD-INTLEN = 20.
*  LS_FIELD-LENG = 20.
*  LS_FIELD-OUTPUTLEN = 20.
*  LS_FIELD-REPTEXT = '자재코드'.
*  APPEND LS_FIELD TO LT_FIELDS.

*  CLEAR LS_FIELD.
*  LS_FIELD-FIELDNAME = 'MAKTX'.
*  LS_FIELD-INTLEN = 20.
*  LS_FIELD-LENG = 20.
*  LS_FIELD-OUTPUTLEN = 20.
*  LS_FIELD-REPTEXT = '자재명'.
*  APPEND LS_FIELD TO LT_FIELDS.
*
*  CLEAR LS_FIELD.
*  LS_FIELD-FIELDNAME = 'STPRS'.
*  LS_FIELD-INTLEN = 20.
*  LS_FIELD-LENG = 20.
*  LS_FIELD-OUTPUTLEN = 20.
*  LS_FIELD-REPTEXT = '완제품 원가'.
*  LS_FIELD-
*  APPEND LS_FIELD TO LT_FIELDS.
*
*  CLEAR LS_FIELD.
*  LS_FIELD-FIELDNAME = 'NETPR'.
*  LS_FIELD-INTLEN = 20.
*  LS_FIELD-LENG = 20.
*  LS_FIELD-OUTPUTLEN = 20.
*  LS_FIELD-REPTEXT = '판매 단가'.
*  APPEND LS_FIELD TO LT_FIELDS.
*
*  CLEAR LS_FIELD.
*  LS_FIELD-FIELDNAME = 'WAERS'.
*  LS_FIELD-INTLEN = 20.
*  LS_FIELD-LENG = 20.
*  LS_FIELD-OUTPUTLEN = 20.
*  LS_FIELD-REPTEXT = '통화 코드'.
*  APPEND LS_FIELD TO LT_FIELDS.

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
      VALUE_TAB       = LT_MATNR[]                 " Table of values: entries cell by cell
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

      READ TABLE LT_DATA WITH KEY MATNR = ZEA_MMT010-MATNR BINARY SEARCH.
      IF SY-SUBRC EQ 0.
        ZEA_MMT010-MATNR        = LT_DATA-MATNR.
        ZEA_MMT020-MAKTX        = LT_DATA-MAKTX.
        ZEA_MMT010-STPRS        = LT_DATA-STPRS.
        ZEA_SDT090-NETPR        = LT_DATA-STPRS * 17 / 10.
        ZEA_MMT010-WAERS        = LT_DATA-WAERS.
        ZEA_SDT090-WAERS        = LT_DATA-WAERS.

        LEAVE SCREEN.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SAVE_DATA
*&---------------------------------------------------------------------*
FORM SAVE_DATA .


  CLEAR GS_DISPLAY.
  " 생성 관련 정보를 먼저 설정
*      ZPFLI_E23-ERDAT = SY-DATUM. " 생성일자를 오늘로
*      ZPFLI_E23-ERZET = SY-UZEIT. " 생성시간을 현재 시간으로
*      ZPFLI_E23-ERNAM = SY-UNAME. " 생성자를 현재 로그인한 사용자ID

*  MOVE-CORRESPONDING ZEA_SDT090 TO GS_DISPLAY.
*  MOVE-CORRESPONDING ZEA_MMT010 TO GS_DISPLAY.
*  MOVE-CORRESPONDING ZEA_MMT020 TO GS_DISPLAY.

  GS_DISPLAY-MATNR = ZEA_MMT010-MATNR.
  GS_DISPLAY-MAKTX = ZEA_MMT020-MAKTX.
*    GS_DISPLAY-STPRS = ZEA_MMT010-STPRS.
  GS_DISPLAY-NETPR = ZEA_SDT090-NETPR.
  GS_DISPLAY-WAERS = ZEA_MMT010-WAERS.
  GS_DISPLAY-VALID_ST = ZEA_SDT090-VALID_ST.
  GS_DISPLAY-VALID_EN = ZEA_SDT090-VALID_EN.
  GS_DISPLAY-ERNAM = SY-UNAME.
  GS_DISPLAY-ERDAT = SY-DATUM.
  GS_DISPLAY-ERZET = SY-UZEIT.

*  LOOP AT GT_DATA INTO GS_DATA.
*    IF GS_DATA-MATNR IS INITIAL.
*      MESSAGE E000 WITH 'CHECK KEY FIELD.'.
*    ELSEIF GS_DATA-VALID_EN IS INITIAL.
*      MESSAGE E000 WITH 'CHECK KEY FIELD.'.
*    ENDIF.
*  ENDLOOP.
*  1) maktx '일반' '프리미엄' 문자가 들어있는지 구분해서 넣어준다?
*  2) 자재를 구분해주는 데이터 (matnr 이 3, 4)

  ZEA_SDT090-MATNR = ZEA_MMT010-MATNR.
  IF ZEA_SDT090-NETPR EQ ZEA_MMT010-STPRS * 17 / 10.
  ZEA_SDT090-NETPR = ZEA_MMT010-STPRS * 17 / 10.
  ELSE.
    ZEA_SDT090-NETPR = ZEA_SDT090-NETPR.
    ENDIF.
  ZEA_SDT090-WAERS = ZEA_MMT010-WAERS.
  ZEA_SDT090-ERNAM = SY-UNAME.
  ZEA_SDT090-ERDAT = SY-DATUM.
  ZEA_SDT090-ERZET = SY-UZEIT.

*   SELECT SINGLE A~VALID_EN
*     FROM ZEA_SDT090 AS A
*     INTO  CORRESPONDING FIELDS OF ZEA_SDT090
*     WHERE A~MATNR EQ ZEA_SDT090-MATNR
*       AND A~NETPR EQ ZEA_SDT090-NETPR.8

  INSERT ZEA_SDT090 FROM ZEA_SDT090 .

  IF SY-SUBRC EQ 0.
    COMMIT WORK AND WAIT.   " DB 구문 끝나고 확정
    APPEND GS_DISPLAY TO GT_DISPLAY.
    SORT GT_DISPLAY BY MATNR.

    MESSAGE S015.  " 데이터 성공적으로 저장되었습니다.
    LEAVE TO SCREEN 0.

    ELSE.
    ROLLBACK WORK. " 데이터 저장 중 오류가 발생했습니다.
    MESSAGE W016.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SEARCH_DATA
*&---------------------------------------------------------------------*
FORM SEARCH_DATA .

  RANGES R_MATNR FOR ZEA_SDT090-MATNR.

  REFRESH R_MATNR[].
  CLEAR R_MATNR.


  IF ZEA_SDT090-MATNR IS NOT INITIAL.
    R_MATNR-SIGN    = 'I'.
    R_MATNR-OPTION  = 'EQ'.
    R_MATNR-LOW     = ZEA_SDT090-MATNR.
*  R_MATNR-HIGH    = ''.
    APPEND R_MATNR.
  ENDIF.

*  IF ZEA_SDT090-MATNR IS INITIAL.
*    REFRESH R_MATNR[].
*    CLEAR R_MATNR.
*  ENDIF.

  SELECT A~MATNR
         B~MAKTX
         A~VALID_EN
         A~VALID_ST
         A~NETPR
         A~WAERS
         A~LOEKZ
         A~ERNAM
         A~ERDAT
         A~ERZET
    FROM ZEA_SDT090 AS A
    INNER JOIN ZEA_MMT020 AS B
    ON A~MATNR EQ B~MATNR
    AND B~SPRAS EQ SY-LANGU
    INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY
    WHERE A~MATNR IN R_MATNR.

  SORT GT_DISPLAY BY MATNR.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form DATA_SAVE
*&---------------------------------------------------------------------*
FORM DATA_SAVE .

  DATA: LS_SDT090 TYPE ZEA_SDT090,
        LT_SDT090 TYPE TABLE OF ZEA_SDT090.

  MOVE-CORRESPONDING GT_DISPLAY TO LT_SDT090.

  LOOP AT LT_SDT090 INTO LS_SDT090.
    IF LS_SDT090-MATNR IS INITIAL.
      MESSAGE E000 WITH 'CHECK KEY FIELD.'.
    ELSEIF LS_SDT090-VALID_EN IS INITIAL.
      MESSAGE E000 WITH 'CHECK KEY FIELD.'.
    ENDIF.
  ENDLOOP.

  MODIFY ZEA_SDT090 FROM TABLE LT_SDT090.

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
*& Form EDIT_MODE
*&---------------------------------------------------------------------*
FORM EDIT_MODE .
  DATA LV_CHECK TYPE I.

  LV_CHECK = GO_ALV_GRID->IS_READY_FOR_INPUT( ).

  IF LV_CHECK EQ 0.
    LV_CHECK = 1.
  ELSE.
    LV_CHECK = 0.
  ENDIF.

  CALL METHOD GO_ALV_GRID->SET_READY_FOR_INPUT
    EXPORTING
      I_READY_FOR_INPUT = LV_CHECK. " Ready for Input Status

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DATA_DELETE
*&---------------------------------------------------------------------*
FORM DATA_DELETE .

  DATA LT_INDEX_ROWS TYPE LVC_T_ROW.
  DATA LS_INDEX_ROW LIKE LINE OF LT_INDEX_ROWS.

  CALL METHOD GO_ALV_GRID->GET_SELECTED_ROWS
    IMPORTING
      ET_INDEX_ROWS = LT_INDEX_ROWS     " Indexes of Selected Rows
*     ET_ROW_NO     =                  " Numeric IDs of Selected Rows
    .

  IF LT_INDEX_ROWS[] IS INITIAL.
    " TEXT-M01: 라인을 선택하세요.
    MESSAGE S000 DISPLAY LIKE 'W' WITH '최소 한 행이상 선택하세요'.

  ELSE.

    DATA LV_SUBRC TYPE I.
    DATA LV_COUNT TYPE I.

    LOOP AT LT_INDEX_ROWS INTO LS_INDEX_ROW WHERE ROWTYPE IS INITIAL.

      READ TABLE GT_DISPLAY INTO GS_DISPLAY INDEX LS_INDEX_ROW-INDEX.

      IF SY-SUBRC EQ 0.

        " DATABASE TABLE 의 RECORD 삭제
*        DELETE FROM ZEA_SDT090
*          WHERE MATNR EQ GS_DISPLAY-MATNR
*            AND VALID_EN EQ GS_DISPLAY-VALID_EN.

*        UPDATE ZEA_SDT090 SET LOEKZ = 'X'
*                WHERE INDEX EQ LS_INDEX_ROW-INDEX.

*        IF SY-SUBRC EQ 0.
*          LV_COUNT += 1.
*        ENDIF.

        " ITAB 변경로직
*        DELETE GT_DISPLAY INDEX LS_INDEX_ROW-INDEX.
        LOOP AT LT_INDEX_ROWS INTO LS_INDEX_ROW.
          READ TABLE GT_DISPLAY INTO GS_DISPLAY INDEX LS_INDEX_ROW-INDEX.
          GS_DISPLAY-LOEKZ = 'X'.
          MODIFY GT_DISPLAY FROM GS_DISPLAY
          INDEX LS_INDEX_ROW TRANSPORTING LOEKZ LIGHT.
        ENDLOOP.

        UPDATE ZEA_SDT090 SET LOEKZ ='X'
                              AENAM  = SY-UNAME
                              AEDAT  = SY-DATUM
                              AEZET  = SY-UZEIT
                WHERE MATNR EQ GS_DISPLAY-MATNR
                  AND VALID_EN EQ GS_DISPLAY-VALID_EN.

        IF SY-SUBRC EQ 0.
          LV_COUNT += 1.
        ENDIF.

        "실행된 결과를 LV_SUBRC에 누적합산
        ADD SY-SUBRC TO LV_SUBRC.

      ENDIF.

    ENDLOOP.

    IF LV_SUBRC EQ 0.
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

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SDT090_F4_HELP
*&---------------------------------------------------------------------*
FORM SDT090_F4_HELP .


  DATA: LT_RETURN_TAB TYPE DDSHRETVAL OCCURS 0,
        LS_RETURN_TAB LIKE LINE OF LT_RETURN_TAB.

  DATA: LT_DSELC TYPE DSELC OCCURS 0,
        LS_DSELC LIKE LINE OF LT_DSELC.

  DATA: LS_VALUE  TYPE SEAHLPRES,
        LT_VALUE  TYPE TABLE OF SEAHLPRES,
        LS_FIELD  TYPE DFIES,
        LT_FIELDS TYPE TABLE OF DFIES.

  DATA : BEGIN OF LT090_MATNR OCCURS 0,
           MATNR TYPE ZEA_SDT090-MATNR,
           MAKTX TYPE ZEA_MMT020-MAKTX,
         END OF LT090_MATNR.

  DATA: LT_MAP TYPE TABLE OF DSELC WITH HEADER LINE.

  CLEAR : LT090_MATNR, LT090_MATNR[],
          LT_VALUE, LT_VALUE[],
          LT_FIELDS, LT_FIELDS[].


  SELECT DISTINCT A~MATNR
         B~MAKTX
         INTO TABLE LT090_MATNR
        FROM ZEA_SDT090 AS A
        JOIN ZEA_MMT020 AS B
          ON B~MATNR EQ A~MATNR
         AND B~SPRAS EQ SY-LANGU.

*        WHERE A~MATTYPE EQ '완제품'.  " 이거 안줘도 잘 완제품만 나오네
  " 다른 F4HELP에서 써서 그런가
  " --> 그거슨 SDT090에 완제품만 있어서 그런것이었구요~

  SORT LT090_MATNR BY MATNR.

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
      VALUE_TAB       = LT090_MATNR[]                 " Table of values: entries cell by cell
      RETURN_TAB      = LT_RETURN_TAB[]
*     DYNPFLD_MAPPING = LT_MAP
    EXCEPTIONS
      PARAMETER_ERROR = 1                " Incorrect parameter
      NO_VALUES_FOUND = 2                " No values found
      OTHERS          = 3.

  IF SY-SUBRC EQ 0.
    READ TABLE LT_RETURN_TAB INTO LS_RETURN_TAB INDEX 1.
    IF SY-SUBRC EQ 0.
      ZEA_SDT090-MATNR = LS_RETURN_TAB-FIELDVAL.

      READ TABLE LT090_MATNR WITH KEY MATNR = ZEA_SDT090-MATNR BINARY SEARCH.
      IF SY-SUBRC EQ 0.
        ZEA_SDT090-MATNR        = LT090_MATNR-MATNR.
        ZEA_MMT020-MAKTX        = LT090_MATNR-MAKTX.

        LEAVE SCREEN.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.
