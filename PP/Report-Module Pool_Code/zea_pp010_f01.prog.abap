*&---------------------------------------------------------------------*
*& Include          ZALV_GRID_DISPLAY_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form MAKE_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM MAKE_FIELDCAT_0100 .

  LOOP AT GT_FIELDCAT INTO GS_FIELDCAT.

    GS_FIELDCAT-EDIT = ABAP_ON.

    CASE GS_FIELDCAT-FIELDNAME.
      WHEN 'BOMINDEX'.
        GS_FIELDCAT-KEY = ABAP_ON.
        GS_FIELDCAT-JUST      = 'C'.
        GS_FIELDCAT-OUTPUTLEN = 10.
        GS_FIELDCAT-EDIT = ABAP_OFF.
      WHEN 'BOMID'.
        GS_FIELDCAT-NO_OUT = ABAP_ON.
      WHEN 'MATNR'.
*        GS_FIELDCAT-JUST      = 'C'.
        GS_FIELDCAT-OUTPUTLEN = 15.
        GS_FIELDCAT-F4AVAILABL = ABAP_ON.
      WHEN 'MAKTX'.
        GS_FIELDCAT-COLTEXT   = '자재명'.
*        GS_FIELDCAT-JUST      = 'C'.
        GS_FIELDCAT-OUTPUTLEN = 15.
        GS_FIELDCAT-EDIT = ABAP_OFF.
      WHEN 'MATTYPE'.
        GS_FIELDCAT-COLTEXT   = '자재유형'.
*        GS_FIELDCAT-JUST      = 'C'.
        GS_FIELDCAT-OUTPUTLEN = 15.
        GS_FIELDCAT-EDIT = ABAP_OFF.
      WHEN 'MENGE'.
        GS_FIELDCAT-COLTEXT   = '기준수량'.
*        GS_FIELDCAT-JUST     = 'C'.
        GS_FIELDCAT-OUTPUTLEN = 15.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
        GS_FIELDCAT-DO_SUM = ABAP_ON.
      WHEN 'MEINS'.
        GS_FIELDCAT-COLTEXT   = '단위'.
        GS_FIELDCAT-JUST      = 'L'.
*        GS_FIELDCAT-EDIT      = ABAP_OFF.
        GS_FIELDCAT-OUTPUTLEN = 5.
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
*& Form SET_ALV_LAYOUT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_LAYOUT_0100 .

  CLEAR GS_LAYOUT.
  CLEAR GS_VARIANT.
  CLEAR GV_SAVE.

  GS_VARIANT-REPORT = SY-REPID.
*  GS_VARIANT-VARIANT = PA_LAYO.
  GV_SAVE = 'A'.   " '' : Layout 저장불가

  GS_LAYOUT-CWIDTH_OPT = 'A'.
  GS_LAYOUT-ZEBRA      = ABAP_ON.
  GS_LAYOUT-SEL_MODE   = 'D'.
  GS_LAYOUT-GRID_TITLE = TEXT-T10.          " ALV TITLE TEXT

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_DATA
*&---------------------------------------------------------------------*
FORM SELECT_DATA .

  REFRESH GT_DATA.
  REFRESH GT_DATA2.

*  SELECT *
*    FROM ZEA_STKO
*    INTO CORRESPONDING FIELDS OF TABLE GT_DATA.


  SELECT A~MATNR
         A~MATTYPE
         B~MAKTX
*         A~WEIGHT
         A~MEINS1
    FROM ZEA_MMT010 AS A
     INNER JOIN ZEA_MMT020 AS B ON B~MATNR EQ A~MATNR
                               AND B~SPRAS EQ SY-LANGU
    INTO CORRESPONDING FIELDS OF TABLE GT_DATA2
    WHERE A~MATTYPE EQ '원자재'
       OR A~MATTYPE EQ '반제품'.

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


*--------------------------------------------------------------------*
    APPEND GS_DISPLAY TO GT_DISPLAY.

  ENDLOOP.

  LOOP AT GT_DATA2 INTO GS_DATA2.

    CLEAR GS_DISPLAY2.

    MOVE-CORRESPONDING GS_DATA2 TO GS_DISPLAY2.

*신규 필드------------------------------------------------------------*

    GS_DISPLAY2-ADD_ITEM = ICON_PAGE_LEFT.

    CLEAR LS_STYLE.
    LS_STYLE-FIELDNAME = 'ADD_ITEM'.
    LS_STYLE-STYLE     = CL_GUI_ALV_GRID=>MC_STYLE_BUTTON.
    APPEND LS_STYLE TO GS_DISPLAY2-STYLE.


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
        GS_FIELD_COLOR-COLOR-INT = 1.
        GS_FIELD_COLOR-COLOR-INV = 0.
        APPEND GS_FIELD_COLOR TO GS_DISPLAY2-IT_FIELD_COLORS.
    ENDCASE.

*    IF GS_DISPLAY2-MATTYPE = '원자재'.
*      GS_DISPLAY2-COLOR = 'C310'.
*    ELSEIF  GS_DISPLAY2-MATTYPE = '반제품'.
*      GS_DISPLAY2-COLOR = 'C510'.
*    ENDIF.

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

*  DESCRIBE TABLE GT_DISPLAY LINES GV_LINES.
*
*  IF GT_DISPLAY IS INITIAL.
*    MESSAGE S013 DISPLAY LIKE 'W'.
*  ELSE.
*    MESSAGE S006 WITH GV_LINES.
*  ENDIF.
*
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
*     I_STRUCTURE_NAME              = ''
      IS_VARIANT                    = GS_VARIANT
      I_SAVE                        = GV_SAVE
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

  CALL METHOD GO_ALV_GRID->REGISTER_F4_FOR_FIELDS
    EXPORTING
      IT_F4 = GT_F4.

  SET HANDLER LCL_EVENT_HANDLER=>ON_TOOLBAR FOR GO_ALV_GRID.
  SET HANDLER LCL_EVENT_HANDLER=>ON_DOUBLE_CLICK FOR GO_ALV_GRID.
  SET HANDLER LCL_EVENT_HANDLER=>ON_USER_COMMAND FOR GO_ALV_GRID.
  SET HANDLER LCL_EVENT_HANDLER=>ON_HOTSPOT_CLICK FOR GO_ALV_GRID.
  SET HANDLER LCL_EVENT_HANDLER=>ON_BUTTON_CLICK FOR GO_ALV_GRID.
  SET HANDLER LCL_EVENT_HANDLER=>ON_ONF4 FOR GO_ALV_GRID.
  SET HANDLER LCL_EVENT_HANDLER=>ON_DATA_CHANGED FOR GO_ALV_GRID.
  SET HANDLER LCL_EVENT_HANDLER=>ON_DATA_CHANGED_FINISHED FOR GO_ALV_GRID.


*  GO_ALV_GRID->REGISTER_EDIT_EVENT( I_EVENT_ID = CL_GUI_ALV_GRID=>MC_EVT_ENTER ).
*  GO_ALV_GRID->REGISTER_EDIT_EVENT( I_EVENT_ID = CL_GUI_ALV_GRID=>MC_EVT_MODIFIED ).

  CALL METHOD GO_ALV_GRID->REGISTER_EDIT_EVENT
    EXPORTING
      I_EVENT_ID = CL_GUI_ALV_GRID=>MC_EVT_MODIFIED.    " Event ID

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
FORM GET_FIELDCAT_0100_2.

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
* 구분자 =>> |
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 3. " 구분자
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.
*
* 버튼 추가 =>> 행추가
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 0. " 행추가
      LS_TOOLBAR-FUNCTION = GC_INSERT.
      LS_TOOLBAR-ICON = ICON_INSERT_ROW.
      LS_TOOLBAR-TEXT = TEXT-L01.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 행삭제
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 0. " 행삭제
      LS_TOOLBAR-FUNCTION = GC_DELETE.
      LS_TOOLBAR-ICON = ICON_DELETE_ROW.
      LS_TOOLBAR-TEXT = TEXT-L02.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

    WHEN GO_ALV_GRID_2.
* 구분자 =>> |
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 3. " 구분자
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

      DATA : LV_SEMI_RAW TYPE I,
             LV_SEMI     TYPE I,
             LV_RAW      TYPE I.

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
      LS_TOOLBAR-TEXT = TEXT-L03 && ':' && LV_SEMI_RAW.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 반제품
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 0. " 반제품
      LS_TOOLBAR-FUNCTION = GC_SEMI_MATERIALS.
      LS_TOOLBAR-ICON = ICON_LED_GREEN.
      LS_TOOLBAR-TEXT = TEXT-L04 && ':' && LV_SEMI.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 반제품
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 0. " 원자재
      LS_TOOLBAR-FUNCTION = GC_RAW_MATERIALS.
      LS_TOOLBAR-ICON = ICON_LED_YELLOW.
      LS_TOOLBAR-TEXT = TEXT-L05 && ':' && LV_RAW.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

  ENDCASE.



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

  CALL METHOD GO_ALV_GRID->CHECK_CHANGED_DATA.

  CASE PO_SENDER.
    WHEN GO_ALV_GRID. "PO_SENDER 가 GO_ALV_GRID 일 때
      CASE PV_UCOMM.  " 선택한 버튼 (PV_UCOMM은 SY-UCOMM 타입)

        WHEN GC_INSERT.
          PERFORM INSERT_ROW.
          PERFORM REFRESH_ALV_0100.

        WHEN GC_DELETE.
          PERFORM DELETE_ROW.
          PERFORM REFRESH_ALV_0100.
      ENDCASE.

    WHEN GO_ALV_GRID_2.
      CASE PV_UCOMM.
        WHEN GC_SEMI_RAW_MATERIALS.
          PERFORM SEMI_RAW_FILTER.

        WHEN GC_SEMI_MATERIALS.
          PERFORM SEMI_FILTER.

        WHEN GC_RAW_MATERIALS.
          PERFORM RAW_FILTER.

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
FORM HANDLE_BUTTON_CLICK USING     PS_ROW_NO TYPE LVC_S_ROID
                                   PS_COL_ID TYPE LVC_S_COL
                                   PO_SENDER TYPE REF TO CL_GUI_ALV_GRID.

  CALL METHOD PO_SENDER->CHECK_CHANGED_DATA.

  CASE PO_SENDER.
    WHEN GO_ALV_GRID_2.

      DATA LV_INDEX TYPE I.

      DESCRIBE TABLE GT_DISPLAY LINES GV_LINES.

      CASE PS_COL_ID-FIELDNAME.
        WHEN 'ADD_ITEM'. " 아이템 추가
          READ TABLE GT_DISPLAY2 INTO GS_DISPLAY2 INDEX PS_ROW_NO-ROW_ID.

          IF SY-SUBRC EQ 0.
*            LOOP AT GT_DISPLAY INTO GS_DISPLAY.
*              IF GS_DISPLAY-MATNR EQ GS_DISPLAY2-MATNR.
*                LV_INDEX = SY-TABIX.
*                GS_DISPLAY-MENGE += GS_DISPLAY2-WEIGHT.
*                MODIFY GT_DISPLAY FROM GS_DISPLAY TRANSPORTING MENGE.
*              ENDIF.
*            ENDLOOP.

            IF LV_INDEX EQ 0.
              MOVE-CORRESPONDING GS_DISPLAY2 TO GS_DISPLAY.
*              GS_DISPLAY-MENGE = GS_DISPLAY2-WEIGHT.
              GS_DISPLAY-MEINS = GS_DISPLAY2-MEINS1.
              GS_DISPLAY-BOMINDEX = ( 1 + GV_LINES ) * 10.
              APPEND GS_DISPLAY TO GT_DISPLAY.
            ELSE.

            ENDIF.

            PERFORM REFRESH_ALV_0100.
          ENDIF.

      ENDCASE.

      CALL METHOD CL_GUI_CFW=>SET_NEW_OK_CODE
        EXPORTING
          NEW_CODE = 'ENTER'.                 " New OK_CODE

  ENDCASE.

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

  CLEAR: LS_MOD_CELLS.

  DATA(LT_MOD) = PR_DATA_CHANGED->MT_MOD_CELLS[].

  LOOP AT LT_MOD INTO LS_MOD_CELLS.
    CASE LS_MOD_CELLS-FIELDNAME.
      WHEN 'MENGE'.
        GV_CHANGED = ABAP_ON.
      WHEN 'MATNR'.
        GV_MATNR_CHANGED = ABAP_ON.
    ENDCASE.
  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form INSERT_ROW
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM INSERT_ROW .

*  IF ZEA_STKO-MATNR IS INITIAL.
*    MESSAGE I000 WITH '자재코드를 입력하세요'.
*    EXIT.
*  ENDIF.

  DESCRIBE TABLE GT_DISPLAY LINES GV_LINES.

  CLEAR GS_DISPLAY.
  GS_DISPLAY-BOMID = ZEA_STKO-BOMID.
  GS_DISPLAY-BOMINDEX = ( GV_LINES + 1 ) * 10.
  APPEND GS_DISPLAY TO GT_DISPLAY.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DELETE_ROW
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DELETE_ROW .

  DATA: BEGIN OF LS_DEL_KEYS,
          BOMID    TYPE ZEA_STPO-BOMID,
          BOMINDEX TYPE ZEA_STPO-BOMINDEX,
        END OF LS_DEL_KEYS.

  DATA LT_DEL_KEYS LIKE TABLE OF LS_DEL_KEYS.

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

    LOOP AT LT_INDEX_ROWS INTO LS_INDEX_ROW WHERE ROWTYPE IS INITIAL.
      READ TABLE GT_DISPLAY INTO GS_DISPLAY INDEX LS_INDEX_ROW-INDEX.
      IF SY-SUBRC EQ 0.
        CLEAR LS_DEL_KEYS.
        MOVE-CORRESPONDING GS_DISPLAY TO LS_DEL_KEYS.
        APPEND LS_DEL_KEYS TO LT_DEL_KEYS.
      ENDIF.
    ENDLOOP.

    LOOP AT LT_DEL_KEYS INTO LS_DEL_KEYS.
      DELETE GT_DISPLAY
        WHERE BOMID    EQ LS_DEL_KEYS-BOMID
          AND BOMINDEX EQ LS_DEL_KEYS-BOMINDEX.
    ENDLOOP.

    LOOP AT GT_DISPLAY INTO GS_DISPLAY.
      GS_DISPLAY-BOMINDEX = ( SY-TABIX  ) * 10.
      MODIFY GT_DISPLAY FROM GS_DISPLAY TRANSPORTING BOMINDEX.
    ENDLOOP.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_BOMINDEX_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_BOMINDEX_0100 .


  LOOP AT GT_DISPLAY INTO GS_DISPLAY.
    GS_DISPLAY-BOMINDEX = ( SY-TABIX + 1 ) * 10.
    MODIFY GT_DISPLAY FROM GS_DISPLAY TRANSPORTING BOMINDEX.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CREATE_DATA .

  _MC_POPUP_CONFIRM 'SAVE' '저장하시겠습니까?' GV_ANSWER.
  CHECK GV_ANSWER = '1'.

  DATA LV_SUBRC TYPE I.
  DATA LT_STPO TYPE TABLE OF ZEA_STPO.
  DATA LS_STPO TYPE ZEA_STPO.

  SELECT SINGLE *
    FROM ZEA_T001W
    WHERE WERKS EQ ZEA_T001W-WERKS.

  IF SY-SUBRC NE 0.
    MESSAGE S000 DISPLAY LIKE 'E' WITH '해당 플랜트는 존재하지 않습니다.'.
    EXIT.
  ENDIF.

  SELECT SINGLE *
    FROM ZEA_MMT010
    WHERE MATNR EQ ZEA_STKO-MATNR.

  IF SY-SUBRC NE 0.
    MESSAGE S000 DISPLAY LIKE 'E' WITH '해당 자재는 존재하지 않습니다.'.
    EXIT.
  ENDIF.

  IF GT_DISPLAY[] IS INITIAL.
    MESSAGE S000 DISPLAY LIKE 'E' WITH 'BOM의 구성요소가 없습니다.'.
    EXIT.
  ENDIF.

  LOOP AT GT_DISPLAY INTO GS_DISPLAY.
    IF GS_DISPLAY-MATTYPE EQ '완제품'.
      MESSAGE S000 DISPLAY LIKE 'E' WITH '완제품은 구성요소가 될 수 없습니다'.
      LV_SUBRC = 4.
    ELSEIF GS_DISPLAY-MENGE <= 0.
      MESSAGE S000 DISPLAY LIKE 'E' WITH 'BOM 구성요소의 수량이 0 이하입니다.'.
      LV_SUBRC = 4.
    ENDIF.

    SELECT SINGLE *
      FROM ZEA_MMT010
      WHERE MATNR EQ GS_DISPLAY-MATNR.

    IF SY-SUBRC NE 0.
      MESSAGE S000 DISPLAY LIKE 'E' WITH '해당 자재코드는 존재하지 않습니다'.
      LV_SUBRC = 4.
    ENDIF.

  ENDLOOP.

  SELECT SINGLE *
    FROM ZEA_STKO
    WHERE MATNR EQ ZEA_STKO-MATNR
      AND WERKS EQ ZEA_T001W-WERKS
      AND MENGE EQ ZEA_STKO-MENGE
      AND MEINS EQ ZEA_STKO-MEINS.

  IF SY-SUBRC EQ 0.
    MESSAGE S000 DISPLAY LIKE 'E' WITH '동일한 BOM이 존재합니다'.
    LV_SUBRC = 4.
  ENDIF.


  IF LV_SUBRC NE 0.
    EXIT.
  ENDIF.

  CLEAR LV_SUBRC.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      NR_RANGE_NR             = '01'                 " Number range number
      OBJECT                  = 'ZEA_BOMID'                 " Name of number range object
    IMPORTING
      NUMBER                  = ZEA_STKO-BOMID                  " free number
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

  REPLACE FIRST OCCURRENCE OF '0' IN ZEA_STKO-BOMID WITH 'B'.

  ZEA_STKO-WERKS = ZEA_T001W-WERKS.

  ZEA_STKO-ERDAT = SY-DATUM.
  ZEA_STKO-ERNAM = SY-UNAME.
  ZEA_STKO-ERZET = SY-UZEIT.

  INSERT ZEA_STKO.

  IF SY-SUBRC NE 0.
    LV_SUBRC = 4.
    ROLLBACK WORK.
  ENDIF.

*--------------------------------------------------------------------*

  LOOP AT GT_DISPLAY INTO GS_DISPLAY.

    MOVE-CORRESPONDING GS_DISPLAY TO LS_STPO.

    LS_STPO-ERDAT = SY-DATUM.
    LS_STPO-ERNAM = SY-UNAME.
    LS_STPO-ERZET = SY-UZEIT.

    LS_STPO-BOMID = ZEA_STKO-BOMID.

    INSERT ZEA_STPO FROM LS_STPO.

    IF SY-SUBRC NE 0.
      LV_SUBRC = 4.
      ROLLBACK WORK.
    ENDIF.

  ENDLOOP.

  IF LV_SUBRC EQ 0.
    COMMIT WORK AND WAIT.
    MESSAGE S015. "데이터가 성공적으로 저장되었습니다.
  ELSE.
    ROLLBACK WORK.
    MESSAGE S016 DISPLAY LIKE 'E'. "데이터 저장 중 오류가 발생했습니다.
  ENDIF.




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
*                              ( CL_GUI_ALV_GRID=>MC_FC_LOC_COPY )
*                              ( CL_GUI_ALV_GRID=>MC_FC_LOC_COPY_ROW )
*                              ( CL_GUI_ALV_GRID=>MC_FC_LOC_CUT )
                              ( CL_GUI_ALV_GRID=>MC_FC_LOC_DELETE_ROW )
                              ( CL_GUI_ALV_GRID=>MC_FC_LOC_INSERT_ROW )
*                              ( CL_GUI_ALV_GRID=>MC_FC_LOC_MOVE_ROW )
*                              ( CL_GUI_ALV_GRID=>MC_FC_LOC_PASTE )
*                              ( CL_GUI_ALV_GRID=>MC_FC_LOC_PASTE_NEW_ROW )
*                              ( CL_GUI_ALV_GRID=>MC_FC_LOC_UNDO )
*                              ( CL_GUI_ALV_GRID=>MC_FC_REFRESH )
*                              ( CL_GUI_ALV_GRID=>MC_FC_CHECK )
*                              ( CL_GUI_ALV_GRID=>MC_FC_GRAPH )
*                              ( CL_GUI_ALV_GRID=>MC_FC_HELP )
*                              ( CL_GUI_ALV_GRID=>MC_FC_INFO )
*                              ( CL_GUI_ALV_GRID=>MC_FC_VIEWS )
*                              ( CL_GUI_ALV_GRID=>MC_FC_PRINT )
                           ).


ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT2_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT2_0100 .

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
*& Form SET_ALV_FIELDCAT2_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_ALV_FIELDCAT2_0100 .

  PERFORM GET_FIELDCAT_0100     USING    GT_DISPLAY2
                                CHANGING GT_FIELDCAT.
*  PERFORM GET_FIELDCAT2   USING    GT_DISPLAY2
*                          CHANGING GT_FIELDCAT.
  PERFORM MAKE_FIELDCAT2_0100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_LAYOUT2_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_ALV_LAYOUT2_0100 .

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
*  GS_LAYOUT-EXCP_FNAME = 'LIGHT'.           " 신호등
*  GS_LAYOUT-EXCP_LED = ABAP_ON.             " 신호등 모양 변경
  GS_LAYOUT-CTAB_FNAME = 'IT_FIELD_COLORS'. " 셀 별 색상
  GS_LAYOUT-STYLEFNAME  = 'STYLE'.          " 스타일

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_EVENT2_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_ALV_EVENT2_0100 .

  SET HANDLER LCL_EVENT_HANDLER=>ON_TOOLBAR FOR GO_ALV_GRID_2.
  SET HANDLER LCL_EVENT_HANDLER=>ON_DOUBLE_CLICK FOR GO_ALV_GRID_2.
  SET HANDLER LCL_EVENT_HANDLER=>ON_USER_COMMAND FOR GO_ALV_GRID_2.
  SET HANDLER LCL_EVENT_HANDLER=>ON_HOTSPOT_CLICK FOR GO_ALV_GRID_2.
  SET HANDLER LCL_EVENT_HANDLER=>ON_BUTTON_CLICK FOR GO_ALV_GRID_2.
  SET HANDLER LCL_EVENT_HANDLER=>ON_DATA_CHANGED FOR GO_ALV_GRID_2.
  SET HANDLER LCL_EVENT_HANDLER=>ON_DATA_CHANGED_FINISHED FOR GO_ALV_GRID_2.

  CALL METHOD GO_ALV_GRID_2->REGISTER_EDIT_EVENT
    EXPORTING
      I_EVENT_ID = CL_GUI_ALV_GRID=>MC_EVT_MODIFIED.    " Event ID

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV2_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV2_0100 .

  CALL METHOD GO_ALV_GRID_2->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
*     I_STRUCTURE_NAME              = ''
      IS_VARIANT                    = GS_VARIANT
      I_SAVE                        = GV_SAVE
      IS_LAYOUT                     = GS_LAYOUT
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

  GO_ALV_GRID_2->SET_VISIBLE( ABAP_FALSE ).

  LOOP AT SCREEN.
    IF SCREEN-GROUP1 EQ 'MOD'.
      SCREEN-ACTIVE = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH_ALV2_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM REFRESH_ALV2_0100 .

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

  IF GV_SCR_ON EQ ABAP_OFF.
    GO_ALV_GRID_2->SET_VISIBLE( ABAP_FALSE ).

    LOOP AT SCREEN.
      IF SCREEN-GROUP1 EQ 'MOD'.
        SCREEN-ACTIVE = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_FIELDCAT2_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM MAKE_FIELDCAT2_0100 .

  LOOP AT GT_FIELDCAT INTO GS_FIELDCAT.

    CASE GS_FIELDCAT-FIELDNAME.
      WHEN 'MATNR'.
        GS_FIELDCAT-KEY = ABAP_ON.
        GS_FIELDCAT-OUTPUTLEN = 15.
      WHEN 'MATTYPE'.
        GS_FIELDCAT-OUTPUTLEN = 15.
      WHEN 'MAKTX'.
        GS_FIELDCAT-OUTPUTLEN = 20.
      WHEN 'MEINS1'.
        GS_FIELDCAT-COLTEXT = '단위'.
      WHEN 'ADD_ITEM'.
        GS_FIELDCAT-COLTEXT = TEXT-F01.
        GS_FIELDCAT-JUST = 'C'.
        GS_FIELDCAT-ICON = ABAP_ON.
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
*& Form SELECT_DATA_CONDITION
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SELECT_DATA_CONDITION .

  RANGES R_MATNR   FOR ZEA_MMT010-MATNR.
  RANGES R_MAKTX   FOR ZEA_MMT020-MAKTX.
  RANGES R_MATTYPE FOR ZEA_MMT010-MATTYPE.

  REFRESH R_MATNR[].
  CLEAR R_MATNR.
  REFRESH R_MAKTX[].
  CLEAR R_MAKTX.
  REFRESH R_MATTYPE[].
  CLEAR R_MATTYPE.

  IF S0100-MATNR IS NOT INITIAL.
    R_MATNR-SIGN    = 'I'.
    R_MATNR-OPTION  = 'EQ'.
    R_MATNR-LOW     = S0100-MATNR.
    APPEND R_MATNR.
  ENDIF.
  IF S0100-MAKTX IS NOT INITIAL.
    R_MAKTX-SIGN    = 'I'.
    R_MAKTX-OPTION  = 'EQ'.
    R_MAKTX-LOW     = S0100-MAKTX.
    APPEND R_MAKTX.
  ENDIF.
  IF S0100-MATTYPE IS NOT INITIAL.
    R_MATTYPE-SIGN    = 'I'.
    R_MATTYPE-OPTION  = 'EQ'.
    R_MATTYPE-LOW     = S0100-MATTYPE.
    APPEND R_MATTYPE.
  ENDIF.

  SELECT *
  FROM ZEA_MMT010 AS A
   INNER JOIN ZEA_MMT020 AS B
    ON B~MATNR EQ A~MATNR
   AND B~SPRAS EQ SY-LANGU
  INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY2
    WHERE A~MATNR IN R_MATNR
      AND B~MAKTX IN R_MAKTX
      AND A~MATTYPE IN R_MATTYPE.


  PERFORM MODIFY_DISPLAY_DATA.



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

  PERFORM SET_ALV_FILTER2.

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

  PERFORM SET_ALV_FILTER2.

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

  PERFORM SET_ALV_FILTER2.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_ONF4
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
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

  DATA: LT_RETURN_TAB TYPE DDSHRETVAL OCCURS 0,
        LS_RETURN_TAB LIKE LINE OF LT_RETURN_TAB.

  DATA: LT_DSELC TYPE DSELC OCCURS 0,
        LS_DSELC LIKE LINE OF LT_DSELC.

  DATA: LS_VALUE  TYPE SEAHLPRES,
        LT_VALUE  TYPE TABLE OF SEAHLPRES,
        LS_FIELD  TYPE DFIES,
        LT_FIELDS TYPE TABLE OF DFIES.

  DATA : BEGIN OF LT_MATNR OCCURS 0,
           MATNR   TYPE ZEA_MMT010-MATNR,
           MAKTX   TYPE ZEA_MMT020-MAKTX,
           MATTYPE TYPE ZEA_MMT010-MATTYPE,
           MEINS1  TYPE ZEA_MMT010-MEINS1,
         END OF LT_MATNR.

  DATA: LT_MAP TYPE TABLE OF DSELC WITH HEADER LINE.

  CLEAR : LT_MATNR, LT_MATNR[],
          LT_VALUE, LT_VALUE[],
          LT_FIELDS, LT_FIELDS[].

  SELECT A~MATNR,
         B~MAKTX,
         A~MATTYPE,
         A~MEINS1
    INTO CORRESPONDING FIELDS OF TABLE @LT_MATNR
    FROM ZEA_MMT010 AS A JOIN ZEA_MMT020 AS B ON B~MATNR EQ A~MATNR
                                             AND B~SPRAS EQ @SY-LANGU
    WHERE A~MATTYPE NE '완제품'.

  SORT LT_MATNR BY MATNR.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      RETFIELD        = 'MATNR'           " Name of return field in FIELD_TAB
      DYNPPROG        = SY-REPID          " Current program
      DYNPNR          = SY-DYNNR          " Screen number
*     DYNPROFIELD     = 'ZEA_STKO-BOMID'
      WINDOW_TITLE    = '자재그룹'        " Title for the hit list
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

      READ TABLE LT_MATNR WITH KEY MATNR = LS_RETURN_TAB-FIELDVAL BINARY SEARCH.
      IF SY-SUBRC EQ 0.

        SELECT SINGLE *
          INTO CORRESPONDING FIELDS OF GS_DATA2
          FROM ZEA_MMT010 AS A
          INNER JOIN ZEA_MMT020 AS B
          ON A~MATNR EQ B~MATNR
          WHERE A~MATNR EQ LS_RETURN_TAB-FIELDVAL.

        GS_DISPLAY-BOMINDEX = PV_ROW_NO-ROW_ID * 10.
        GS_DISPLAY-MATNR = GS_DATA2-MATNR.
        GS_DISPLAY-MAKTX = GS_DATA2-MAKTX.
        GS_DISPLAY-MATTYPE = GS_DATA2-MATTYPE.
*        GS_DISPLAY-MENGE = GS_DATA2-WEIGHT.
        GS_DISPLAY-MEINS = GS_DATA2-MEINS1.
        MODIFY GT_DISPLAY FROM GS_DISPLAY INDEX PV_ROW_NO-ROW_ID.

        PERFORM REFRESH_ALV_0100.

*        LEAVE SCREEN.
      ENDIF.

    ENDIF.
  ENDIF.

***  ASSIGN PV_EVENT_DATA->M_DATA->* TO <F4TAB>.
***  LS_LVC_MODI-ROW_ID    = PV_ROW_NO-ROW_ID.
***  LS_LVC_MODI-FIELDNAME = PV_FIELDNAME.
***  LS_LVC_MODI-VALUE     =  LT_RETURN-FIELDVAL.
***  APPEND LS_LVC_MODI TO <F4TAB>.

*  CLEAR GS_DATA2.
*
*  SELECT SINGLE *
*    INTO CORRESPONDING FIELDS OF GS_DATA2
*    FROM ZEA_MMT010 AS A
*    INNER JOIN ZEA_MMT020 AS B
*    ON A~MATNR EQ B~MATNR
*    WHERE A~MATNR EQ LT_RETURN-FIELDVAL.
*
*  GS_DISPLAY-BOMINDEX = PV_ROW_NO-ROW_ID * 10.
*  GS_DISPLAY-MATNR = GS_DATA2-MATNR.
*  GS_DISPLAY-MAKTX = GS_DATA2-MAKTX.
*  GS_DISPLAY-MATTYPE = GS_DATA2-MATTYPE.
**  GS_DISPLAY-MENGE = GS_DATA2-WEIGHT.
*  GS_DISPLAY-MEINS = GS_DATA2-MEINS1.





ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_DATA_CHANGED_FINISHED
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ER_DATA_CHANGED
*&      --> SENDER
*&---------------------------------------------------------------------*
FORM HANDLE_DATA_CHANGED_FINISHED  USING    E_MODIFIED
                                            P_SENDER TYPE REF TO CL_GUI_ALV_GRID.

*  CHECK E_MODIFIED IS NOT INITIAL. "AND GV_MATNR_CHANGED EQ ABAP_ON.
  " 자재코드 중복값 체크
  DATA: L_CHK    LIKE GS_DISPLAY-MATNR,
        LV_SUBRC TYPE I.

  LOOP AT GT_DISPLAY INTO GS_DISPLAY.
    SELECT SINGLE *
      FROM ZEA_MMT010
      WHERE MATNR EQ GS_DISPLAY-MATNR.

    IF SY-SUBRC EQ 0.
      SELECT SINGLE MAKTX
        FROM ZEA_MMT020
        INTO GS_DISPLAY-MAKTX
        WHERE MATNR EQ GS_DISPLAY-MATNR.

      SELECT SINGLE MATTYPE
        FROM ZEA_MMT010
        INTO GS_DISPLAY-MATTYPE
        WHERE MATNR EQ GS_DISPLAY-MATNR.

      SELECT SINGLE MEINS1
        FROM ZEA_MMT010
        INTO GS_DISPLAY-MEINS
        WHERE MATNR EQ GS_DISPLAY-MATNR.

      IF GS_DISPLAY-MATTYPE EQ '완제품'.
        MESSAGE I000 DISPLAY LIKE 'W' WITH 'BOM 구성요소에 완제품이 올 수 없습니다.'.
        GS_DISPLAY-MAKTX = SPACE.
        GS_DISPLAY-MATTYPE = SPACE.
        GS_DISPLAY-MEINS   = SPACE.
      ENDIF.

    ELSE.
      GS_DISPLAY-MAKTX = SPACE.
      GS_DISPLAY-MATTYPE = SPACE.
      GS_DISPLAY-MEINS   = SPACE.
    ENDIF.

    MODIFY GT_DISPLAY FROM GS_DISPLAY TRANSPORTING MAKTX MATTYPE MEINS.
  ENDLOOP.

  MOVE-CORRESPONDING GT_DISPLAY TO GT_DATA.

  SORT GT_DATA BY MATNR.

  LOOP AT GT_DATA INTO GS_DATA.
    CHECK GS_DATA-MATNR IS NOT INITIAL.
    IF L_CHK EQ GS_DATA-MATNR.
      MESSAGE S000 DISPLAY LIKE 'E' WITH '자재코드가 중복되었습니다.'.

      SORT GT_DISPLAY BY MATNR .

      DELETE ADJACENT DUPLICATES FROM GT_DISPLAY COMPARING MATNR. " 선택한 필드 중복제거

      LOOP AT GT_DISPLAY INTO GS_DISPLAY.
        GS_DISPLAY-BOMINDEX = SY-TABIX * 10.
        MODIFY GT_DISPLAY FROM GS_DISPLAY.
      ENDLOOP.

      SORT GT_DISPLAY BY BOMINDEX.

      PERFORM REFRESH_ALV_0100.

      EXIT.
    ELSE.
      CHECK GS_DATA-MATNR IS NOT INITIAL.
      L_CHK = GS_DATA-MATNR.
    ENDIF.
  ENDLOOP.

  CHECK E_MODIFIED IS NOT INITIAL. "AND GV_CHANGED EQ ABAP_ON.

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
*&---------------------------------------------------------------------*
*& Form SELECT_ALL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SELECT_ALL .

  REFRESH GT_DISPLAY2.
  CLEAR S0100.

  SELECT A~MATNR
         A~MATTYPE
         B~MAKTX
*         A~WEIGHT
         A~MEINS1
    FROM ZEA_MMT010 AS A
     INNER JOIN ZEA_MMT020 AS B ON B~MATNR EQ A~MATNR
                               AND B~SPRAS EQ SY-LANGU
    INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY2.

  PERFORM MAKE_DISPLAY_DATA.

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

  LOOP AT GT_DISPLAY2 INTO GS_DISPLAY2.

    GS_DISPLAY2-ADD_ITEM = ICON_PAGE_LEFT.

    CLEAR LS_STYLE.
    LS_STYLE-FIELDNAME = 'ADD_ITEM'.
    LS_STYLE-STYLE     = CL_GUI_ALV_GRID=>MC_STYLE_BUTTON.
    APPEND LS_STYLE TO GS_DISPLAY2-STYLE.

    IF GS_DISPLAY2-MATTYPE = '원자재'.
      GS_DISPLAY2-COLOR = 'C310'.
    ELSEIF  GS_DISPLAY2-MATTYPE = '반제품'.
      GS_DISPLAY2-COLOR = 'C510'.
    ENDIF.

    MODIFY GT_DISPLAY2 FROM GS_DISPLAY2.

  ENDLOOP.

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
        GS_FIELD_COLOR-COLOR-INT = 1.
        GS_FIELD_COLOR-COLOR-INV = 0.
        APPEND GS_FIELD_COLOR TO GS_DISPLAY2-IT_FIELD_COLORS.
    ENDCASE.

    MODIFY GT_DISPLAY2 FROM GS_DISPLAY2.
  ENDLOOP.

ENDFORM.
