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
      WHEN 'PLANID'.
        GS_FIELDCAT-NO_OUT    = ABAP_ON.
      WHEN 'PDPDAT'.
        GS_FIELDCAT-JUST      = 'C'.
        GS_FIELDCAT-OUTPUTLEN = 10.
        GS_FIELDCAT-COLTEXT   = '생산계획 년도'.
      WHEN 'WERKS'.
        GS_FIELDCAT-OUTPUTLEN = 15.
      WHEN 'MATNR'.
        GS_FIELDCAT-OUTPUTLEN = 15.
        GS_FIELDCAT-F4AVAILABL = ABAP_ON.
      WHEN 'MAKTX'.
        GS_FIELDCAT-COLTEXT   = '자재명'.
        GS_FIELDCAT-JUST      = 'C'.
        GS_FIELDCAT-OUTPUTLEN = 22.
      WHEN 'PLANQTY1'.
        GS_FIELDCAT-COLTEXT = '1월 생산계획 수량'.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
      WHEN 'PLANQTY2'.
        GS_FIELDCAT-COLTEXT = '2월 생산계획 수량'.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
      WHEN 'PLANQTY3'.
        GS_FIELDCAT-COLTEXT = '3월 생산계획 수량'.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
      WHEN 'PLANQTY4'.
        GS_FIELDCAT-COLTEXT = '4월 생산계획 수량'.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
      WHEN 'PLANQTY5'.
        GS_FIELDCAT-COLTEXT = '5월 생산계획 수량'.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
      WHEN 'PLANQTY6'.
        GS_FIELDCAT-COLTEXT = '6월 생산계획 수량'.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
      WHEN 'PLANQTY7'.
        GS_FIELDCAT-COLTEXT = '7월 생산계획 수량'.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
      WHEN 'PLANQTY8'.
        GS_FIELDCAT-COLTEXT = '8월 생산계획 수량'.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
      WHEN 'PLANQTY9'.
        GS_FIELDCAT-COLTEXT = '9월 생산계획 수량'.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
      WHEN 'PLANQTY10'.
        GS_FIELDCAT-COLTEXT = '10월 생산계획 수량'.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
      WHEN 'PLANQTY11'.
        GS_FIELDCAT-COLTEXT = '11월 생산계획 수량'.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
      WHEN 'PLANQTY12'.
        GS_FIELDCAT-COLTEXT = '12월 생산계획 수량'.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
      WHEN 'MEINS'.
        GS_FIELDCAT-COLTEXT = '단위'.
        GS_FIELDCAT-JUST      = 'L'.
        GS_FIELDCAT-OUTPUTLEN = 5.
      WHEN 'COLOR'.
        GS_FIELDCAT-NO_OUT  = ABAP_ON.
      WHEN 'LIGHT'.
        GS_FIELDCAT-NO_OUT  = ABAP_ON.
      WHEN 'MARK'.
        GS_FIELDCAT-NO_OUT  = ABAP_ON.
      WHEN 'STATUS'.
        GS_FIELDCAT-NO_OUT  = ABAP_ON.
      WHEN 'BOMID'.
        GS_FIELDCAT-NO_OUT  = ABAP_ON.
      WHEN 'STATUS2'.
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
  GS_LAYOUT-NO_ROWINS = 'X'.
  GS_LAYOUT-CWIDTH_OPT = 'A'.
  GS_LAYOUT-ZEBRA      = ABAP_ON.
  GS_LAYOUT-SEL_MODE   = 'B'.
  GS_LAYOUT-GRID_TITLE = TEXT-T10.          " ALV TITLE TEXT
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_DATA
*&---------------------------------------------------------------------*
FORM SELECT_DATA .

  REFRESH GT_DATA.
  REFRESH GT_DATA2.

  " 판매계획 조회
  SELECT A~SAPNR A~WERKS A~MATNR A~SAPQU
         A~SPQTY1 A~SPQTY2 A~SPQTY3 A~SPQTY4
         A~SPQTY5 A~SPQTY6 A~SPQTY7 A~SPQTY8
         A~SPQTY9 A~SPQTY10 A~SPQTY11 A~SPQTY12
         B~MAKTX  A~MEINS A~STATUS2
    FROM ZEA_SDT030 AS A
    INNER JOIN ZEA_MMT020 AS B ON A~MATNR EQ B~MATNR
    AND SPRAS EQ SY-LANGU
    INTO CORRESPONDING FIELDS OF TABLE GT_DATA2.

  SORT GT_DATA2 BY STATUS2 SAPNR WERKS MATNR.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM MAKE_DISPLAY_DATA .

  DATA LS_STYLE TYPE LVC_S_STYL.

  REFRESH GT_DISPLAY2.

  LOOP AT GT_DATA2 INTO GS_DATA2.

    CLEAR GS_DISPLAY2.

    MOVE-CORRESPONDING GS_DATA2 TO GS_DISPLAY2.

*&-------------------------아이콘 넣기 --------------------------------*

    IF GS_DISPLAY2-STATUS2 = ''.           " 상태 플러그 = ''
      GS_DISPLAY2-COLOR = 'C510'.          " 초록색
      GS_DISPLAY2-STATUS = ICON_LED_GREEN. " LED 등
    ELSEIF  GS_DISPLAY2-STATUS2 = 'X'.     " 상태 플러그 = 'X'
      GS_DISPLAY2-COLOR = 'C610'.          " 빨간색
      GS_DISPLAY2-STATUS = ICON_DELETE.    " 삭제
    ENDIF.
*&------------------------- 아이콘 넣기 -------------------------------*

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

  CALL SCREEN 0100.

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
  ENDIF.


  CREATE OBJECT GO_ALV_GRID
    EXPORTING
      I_PARENT = GO_CONTAINER
    EXCEPTIONS
      OTHERS   = 1.

  IF SY-SUBRC NE 0.
    MESSAGE E021. " ALV Grid 생성 중 오류가 발생했습니다.
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
    MESSAGE E023. " ALV Grid 에 데이터를 전달하는 중 오류가 발생했습니다.
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
*& Form SET_ALV_EVENT_0100 : 이벤트 핸들러 정의
*&---------------------------------------------------------------------*
FORM SET_ALV_EVENT_0100 .

  " 서치헬프 할 필드 지정
  GS_F4-FIELDNAME = 'MATNR'.
  GS_F4-REGISTER = 'X'.

  INSERT GS_F4 INTO TABLE GT_F4.

  CALL METHOD GO_ALV_GRID->REGISTER_F4_FOR_FIELDS
    EXPORTING
      IT_F4 = GT_F4.

  SET HANDLER LCL_EVENT_HANDLER=>ON_TOOLBAR FOR GO_ALV_GRID.
  SET HANDLER LCL_EVENT_HANDLER=>ON_USER_COMMAND FOR GO_ALV_GRID.
  SET HANDLER LCL_EVENT_HANDLER=>ON_BUTTON_CLICK FOR GO_ALV_GRID.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH_ALV_0100 : GO_ALV_GRID REFRESH
*&---------------------------------------------------------------------*
FORM REFRESH_ALV_0100 .

  DATA LS_STABLE TYPE LVC_S_STBL.
  LS_STABLE-ROW = ABAP_ON.
  LS_STABLE-COL = ABAP_ON.

  CALL METHOD GO_ALV_GRID->REFRESH_TABLE_DISPLAY
    EXPORTING
      IS_STABLE = LS_STABLE       " With Stable Rows/Columns
*     I_SOFT_REFRESH =            " Without Sort, Filter, etc.
    EXCEPTIONS
      FINISHED  = 1               " Display was Ended (by Export)
      OTHERS    = 2.

  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
      WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_FIELDCAT_0100_2. : 판매계획 필드 카탈로그
*&---------------------------------------------------------------------*
FORM GET_FIELDCAT_0100_2.

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
*& Form GET_FIELDCAT_0100 : 생산계획 필드 카탈로그
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
      IS_STABLE = LS_STABLE             " With Stable Rows/Columns
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
      LS_TOOLBAR-BUTN_TYPE = 3.                   " 구분자
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 행삭제
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 0.                   " 행삭제
      LS_TOOLBAR-FUNCTION = GC_DELETE.
      LS_TOOLBAR-ICON = ICON_DELETE_ROW.
      LS_TOOLBAR-TEXT = TEXT-L02.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

    WHEN GO_ALV_GRID_2.
* 구분자 =>> |
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 3.                   " 구분자
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

      DATA : LV_SEMI_RAW TYPE I,
             LV_SEMI     TYPE I,
             LV_RAW      TYPE I.

      LOOP AT  GT_DISPLAY2 INTO GS_DISPLAY2.

        CASE GS_DISPLAY2-STATUS2.
          WHEN 'X'.
            ADD 1 TO LV_SEMI_RAW.
            ADD 1 TO LV_SEMI.
          WHEN ''.
            ADD 1 TO LV_SEMI_RAW.
            ADD 1 TO LV_RAW.
        ENDCASE.
      ENDLOOP.

* 버튼 추가 =>> " 생산계획 지시
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 0.                   " 생산계획 지시
      LS_TOOLBAR-FUNCTION = GC_MAKE_PLAN.
      LS_TOOLBAR-ICON = ICON_CREATE.
      LS_TOOLBAR-TEXT = TEXT-L08.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 생산계획 수립완료/미수립
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 0.                   " 생산계획 수립완료/미수립
      LS_TOOLBAR-FUNCTION = GC_SEMI_RAW_SAPNR.
      LS_TOOLBAR-TEXT = TEXT-L03 && ':' && LV_SEMI_RAW.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 미수립
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 0.                   " 미수립
      LS_TOOLBAR-FUNCTION = GC_RAW_SAPNR.
      LS_TOOLBAR-ICON = ICON_LED_GREEN.
      LS_TOOLBAR-TEXT = TEXT-L05 && ':' && LV_RAW.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 수립완료
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 0.                   " 수립완료
      LS_TOOLBAR-FUNCTION = GC_SEMI_SAPNR.
      LS_TOOLBAR-ICON = ICON_DELETE.
      LS_TOOLBAR-TEXT = TEXT-L04 && ':' && LV_SEMI.
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

        WHEN GC_DELETE.
          PERFORM DELETE_ROW.
          PERFORM REFRESH_ALV_0100.
      ENDCASE.

    WHEN GO_ALV_GRID_2.

      DATA LV_INDEX TYPE I.
      DATA LV_DATE TYPE N LENGTH 4.

      DESCRIBE TABLE GT_DISPLAY LINES GV_LINES.

      CASE PV_UCOMM.
        WHEN GC_SEMI_RAW_SAPNR.
          PERFORM SEMI_RAW_FILTER.

        WHEN GC_SEMI_SAPNR.
          PERFORM SEMI_FILTER.

        WHEN GC_RAW_SAPNR.
          PERFORM RAW_FILTER.

        WHEN GC_MAKE_PLAN.
          PERFORM MAKE_PLAN.

      ENDCASE.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_BUTTON_CLICK
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
      DATA LV_DATE TYPE N LENGTH 4.


      DESCRIBE TABLE GT_DISPLAY LINES GV_LINES.


          IF SY-SUBRC EQ 0.
            LOOP AT GT_DISPLAY INTO GS_DISPLAY.

              IF GS_DISPLAY-SAPNR EQ GS_DISPLAY2-SAPNR.
                LV_INDEX = SY-TABIX.
                MESSAGE '동일한 판매계획은 추가할 수 없습니다.' TYPE 'S' DISPLAY LIKE 'E'.
              ENDIF.

            ENDLOOP.

            IF GS_DISPLAY2-STATUS2 EQ 'X'.
              MESSAGE '이미 생성된 생산계획입니다.' TYPE 'S' DISPLAY LIKE 'E'.

            ELSEIF LV_INDEX EQ 0.
              MESSAGE S000 WITH '생산계획이 성공적으로 추가되었습니다.'.

              " 판매 계획 대비 110%의 생산계획 수립
              MOVE-CORRESPONDING GS_DISPLAY2 TO GS_DISPLAY.
              LV_DATE = SY-DATUM+0(4).
              GS_DISPLAY-PDPDAT = LV_DATE.
              GS_DISPLAY-PLANQTY1 = GS_DISPLAY2-SPQTY1 + ( GS_DISPLAY2-SPQTY1 * 10 ) / 100 .
              GS_DISPLAY-PLANQTY2 = GS_DISPLAY2-SPQTY2 + ( GS_DISPLAY2-SPQTY2 * 10 ) / 100 .
              GS_DISPLAY-PLANQTY3 = GS_DISPLAY2-SPQTY3 + ( GS_DISPLAY2-SPQTY3 * 10 ) / 100 .
              GS_DISPLAY-PLANQTY4 = GS_DISPLAY2-SPQTY4 + ( GS_DISPLAY2-SPQTY4 * 10 ) / 100 .
              GS_DISPLAY-PLANQTY5 = GS_DISPLAY2-SPQTY5 + ( GS_DISPLAY2-SPQTY5 * 10 ) / 100 .
              GS_DISPLAY-PLANQTY6 = GS_DISPLAY2-SPQTY6 + ( GS_DISPLAY2-SPQTY6 * 10 ) / 100 .
              GS_DISPLAY-PLANQTY7 = GS_DISPLAY2-SPQTY7 + ( GS_DISPLAY2-SPQTY7 * 10 ) / 100 .
              GS_DISPLAY-PLANQTY8 = GS_DISPLAY2-SPQTY8 + ( GS_DISPLAY2-SPQTY8 * 10 ) / 100 .
              GS_DISPLAY-PLANQTY9 = GS_DISPLAY2-SPQTY9 + ( GS_DISPLAY2-SPQTY9 * 10 ) / 100 .
              GS_DISPLAY-PLANQTY10 = GS_DISPLAY2-SPQTY10 + ( GS_DISPLAY2-SPQTY10 * 10 ) / 100 .
              GS_DISPLAY-PLANQTY11 = GS_DISPLAY2-SPQTY11 + ( GS_DISPLAY2-SPQTY11 * 10 ) / 100 .
              GS_DISPLAY-PLANQTY12 = GS_DISPLAY2-SPQTY12 + ( GS_DISPLAY2-SPQTY12 * 10 ) / 100 .
              GS_DISPLAY-MEINS = GS_DISPLAY2-MEINS.

              APPEND GS_DISPLAY TO GT_DISPLAY.
            ELSE.
            ENDIF.
            PERFORM REFRESH_ALV_0100. " ALV REFRESH
          ENDIF.


      CALL METHOD CL_GUI_CFW=>SET_NEW_OK_CODE
        EXPORTING
          NEW_CODE = 'ENTER'.                 " New OK_CODE

  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_DATA_CHANGED : DATA 변경될 시, 해당 메소드 사용
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
*& Form DELETE_ROW
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DELETE_ROW .

  DATA LT_INDEX_ROWS TYPE LVC_T_ROW.
  DATA LS_INDEX_ROW LIKE LINE OF LT_INDEX_ROWS.

  CALL METHOD GO_ALV_GRID->GET_SELECTED_ROWS
    IMPORTING
      ET_INDEX_ROWS = LT_INDEX_ROWS     " Indexes of Selected Rows
*     ET_ROW_NO     =                   " Numeric IDs of Selected Rows
    .

  IF LT_INDEX_ROWS[] IS INITIAL.
    MESSAGE S061 DISPLAY LIKE 'W'.

  ELSE.

    LOOP AT LT_INDEX_ROWS INTO LS_INDEX_ROW WHERE ROWTYPE IS INITIAL.
      DELETE GT_DISPLAY INDEX LS_INDEX_ROW-INDEX.
    ENDLOOP.

  ENDIF.

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

  DATA LV_COUNT TYPE I.

  SELECT SAPNR
    FROM ZEA_PLAF
    INTO CORRESPONDING FIELDS OF TABLE GT_CHECK.

  " 생산계획 수 만큼 GV_LINES에 넣음
  DESCRIBE TABLE GT_CHECK LINES GV_LINES.

  LOOP AT GT_CHECK INTO GS_CHECK.

    " 사용한 생산계획이 존재하면
    IF GS_CHECK-SAPNR EQ GS_DISPLAY-SAPNR.
      MESSAGE S062 DISPLAY LIKE 'E'. " 이미 생성된 생산계획 번호입니다.

      " 사용한 적이 없다면 카운트 증가
    ELSEIF GS_CHECK-SAPNR NE GS_DISPLAY-SAPNR.
      LV_COUNT += 1.
    ELSE.

    ENDIF.

  ENDLOOP.

  " 사용한 판매 계획이 존재하지 않으면
  IF LV_COUNT EQ GV_LINES.
    PERFORM CREATE_DATA_CASE2. " 채번 + 인덱스 10 설정
  ELSE.
    PERFORM CREATE_DATA_CASE1. " 채번X + 인덱스만 증가
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT2_0100
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
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_ALV_FIELDCAT2_0100 .

  PERFORM GET_FIELDCAT_0100     USING    GT_DISPLAY2
                                CHANGING GT_FIELDCAT.

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
  GV_SAVE = 'A'.   " '' : Layout 저장불가

  GS_LAYOUT-CWIDTH_OPT = 'A'.               " 열 최적화
  GS_LAYOUT-ZEBRA      = ABAP_ON.           " ZEBRA
  GS_LAYOUT-SEL_MODE   = 'B'.               " 열 단위 선택
  GS_LAYOUT-GRID_TITLE = TEXT-T11.          " ALV TITLE TEXT
  GS_LAYOUT-INFO_FNAME = 'COLOR'.           " 행 색상
  GS_LAYOUT-STYLEFNAME = 'STYLE'.          " 스타일

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_EVENT2_0100
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_ALV_EVENT2_0100 .

  SET HANDLER LCL_EVENT_HANDLER=>ON_BUTTON_CLICK FOR GO_ALV_GRID_2.
  SET HANDLER LCL_EVENT_HANDLER=>ON_TOOLBAR FOR GO_ALV_GRID_2.
  SET HANDLER LCL_EVENT_HANDLER=>ON_USER_COMMAND FOR GO_ALV_GRID_2.
  SET HANDLER LCL_EVENT_HANDLER=>ON_DATA_CHANGED FOR GO_ALV_GRID_2.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV2_0100
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV2_0100 .

  CALL METHOD GO_ALV_GRID_2->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
      IS_VARIANT                    = GS_VARIANT
      I_SAVE                        = GV_SAVE
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
*& Form REFRESH_ALV2_0100
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
      IS_STABLE = LS_STABLE      " With Stable Rows/Columns
*     I_SOFT_REFRESH =           " Without Sort, Filter, etc.
    EXCEPTIONS
      FINISHED  = 1              " Display was Ended (by Export)
      OTHERS    = 2.

  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
      WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
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
      WHEN 'SAPNR'.
        GS_FIELDCAT-KEY        = ABAP_ON.
        GS_FIELDCAT-OUTPUTLEN  = 10.
      WHEN 'WERKS'.
        GS_FIELDCAT-OUTPUTLEN  = 7.
      WHEN 'MATNR'.
        GS_FIELDCAT-OUTPUTLEN  = 10.
        GS_FIELDCAT-NO_OUT     = ABAP_ON.
      WHEN 'MAKTX'.
        GS_FIELDCAT-OUTPUTLEN  = 22.
      WHEN 'SAPQU'.
        GS_FIELDCAT-OUTPUTLEN  = 12.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
        GS_FIELDCAT-COLTEXT    = '총 판매계획 수량'.
      WHEN 'SPQTY1'.
        GS_FIELDCAT-OUTPUTLEN  = 15.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
        GS_FIELDCAT-COLTEXT    = '1월 판매계획 수량'.
      WHEN 'SPQTY2'.
        GS_FIELDCAT-OUTPUTLEN  = 8.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
        GS_FIELDCAT-COLTEXT    = '2월 판매계획 수량'.
      WHEN 'SPQTY3'.
        GS_FIELDCAT-OUTPUTLEN  = 7.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
        GS_FIELDCAT-COLTEXT    = '3월 판매계획 수량'.
      WHEN 'SPQTY4'.
        GS_FIELDCAT-OUTPUTLEN  = 6.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
        GS_FIELDCAT-COLTEXT    = '4월 판매계획 수량'.
      WHEN 'SPQTY5'.
        GS_FIELDCAT-OUTPUTLEN  = 5.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
        GS_FIELDCAT-COLTEXT    = '5월 판매계획 수량'.
      WHEN 'SPQTY6'.
        GS_FIELDCAT-OUTPUTLEN  = 15.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
        GS_FIELDCAT-COLTEXT    = '6월 판매계획 수량'.
      WHEN 'SPQTY7'.
        GS_FIELDCAT-OUTPUTLEN  = 15.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
        GS_FIELDCAT-COLTEXT    = '7월 판매계획 수량'.
      WHEN 'SPQTY8'.
        GS_FIELDCAT-OUTPUTLEN  = 15.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
        GS_FIELDCAT-COLTEXT    = '8월 판매계획 수량'.
      WHEN 'SPQTY9'.
        GS_FIELDCAT-OUTPUTLEN  = 15.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
        GS_FIELDCAT-COLTEXT    = '9월 판매계획 수량'.
      WHEN 'SPQTY10'.
        GS_FIELDCAT-OUTPUTLEN  = 15.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
        GS_FIELDCAT-COLTEXT    = '10월 판매계획 수량'.
      WHEN 'SPQTY11'.
        GS_FIELDCAT-OUTPUTLEN  = 15.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
        GS_FIELDCAT-COLTEXT    = '11월 판매계획 수량'.
      WHEN 'SPQTY12'.
        GS_FIELDCAT-OUTPUTLEN  = 15.
        GS_FIELDCAT-QFIELDNAME = 'MEINS'.
        GS_FIELDCAT-COLTEXT    = '12월 판매계획 수량'.
      WHEN 'MEINS'.
        GS_FIELDCAT-COLTEXT    = '단위'.
        GS_FIELDCAT-JUST       = 'L'.
        GS_FIELDCAT-OUTPUTLEN  = 5.
      WHEN 'STATUS2'.
        GS_FIELDCAT-COLTEXT    = '수립여부1'.
        GS_FIELDCAT-COL_POS    = 1.
        GS_FIELDCAT-NO_OUT     = ABAP_ON.
      WHEN 'COLOR'.
        GS_FIELDCAT-NO_OUT     = ABAP_ON.
      WHEN 'LIGHT'.
        GS_FIELDCAT-NO_OUT     = ABAP_ON.
      WHEN 'MARK'.
        GS_FIELDCAT-NO_OUT     = ABAP_ON.
      WHEN 'LOEKZ'.
        GS_FIELDCAT-NO_OUT     = ABAP_ON.
      WHEN 'STATUS'.
        GS_FIELDCAT-COLTEXT    = '수립여부'.
        GS_FIELDCAT-ICON       = ABAP_ON.
        GS_FIELDCAT-JUST       = 'C'.
        GS_FIELDCAT-COL_POS    = 0.

    ENDCASE.

    MODIFY GT_FIELDCAT FROM GS_FIELDCAT.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_DATA_CONDITION
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SELECT_DATA_CONDITION .


  RANGES R_SAPNR FOR ZEA_SDT030-SAPNR.
  RANGES R_WERKS FOR ZEA_SDT030-WERKS.
  RANGES R_MATNR FOR ZEA_SDT030-MATNR.

  REFRESH R_SAPNR[].
  CLEAR R_SAPNR.
  REFRESH R_WERKS[].
  CLEAR R_WERKS.
  REFRESH R_MATNR[].
  CLEAR R_MATNR.



  IF ZEA_SDT030-SAPNR IS NOT INITIAL.
    R_SAPNR-SIGN    = 'I'.
    R_SAPNR-OPTION  = 'EQ'.
    R_SAPNR-LOW     = ZEA_SDT030-SAPNR.
    APPEND R_SAPNR.
  ENDIF.
  IF ZEA_SDT030-WERKS IS NOT INITIAL.
    R_WERKS-SIGN    = 'I'.
    R_WERKS-OPTION  = 'EQ'.
    R_WERKS-LOW     = ZEA_SDT030-WERKS.
    APPEND R_WERKS.
  ENDIF.
  IF ZEA_SDT030-MATNR IS NOT INITIAL.
    R_MATNR-SIGN    = 'I'.
    R_MATNR-OPTION  = 'EQ'.
    R_MATNR-LOW     = ZEA_SDT030-MATNR.
    APPEND R_MATNR.
  ENDIF.

  " 판매계획 ITEM & 자재마스터 ITEM & 판매계획 Header
  SELECT *
    FROM ZEA_SDT030 AS A
   INNER JOIN ZEA_MMT020 AS B
      ON B~MATNR EQ A~MATNR
   INNER JOIN ZEA_SDT020 AS C
      ON C~SAPNR EQ A~SAPNR
    INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY2
    WHERE A~SAPNR IN R_SAPNR
      AND A~WERKS IN R_WERKS
      AND B~MATNR IN R_MATNR
      AND SPRAS EQ SY-LANGU.

  SORT GT_DISPLAY2 BY STATUS2 SAPNR WERKS MATNR.

  DATA LS_STYLE TYPE LVC_S_STYL.

  LOOP AT GT_DISPLAY2 INTO GS_DISPLAY2.


*신규 필드------------------------------------------------------------*

    CLEAR LS_STYLE.
    LS_STYLE-FIELDNAME = 'ADD_ITEM'.
    LS_STYLE-STYLE     = CL_GUI_ALV_GRID=>MC_STYLE_BUTTON.
    APPEND LS_STYLE TO GS_DISPLAY2-STYLE.

    IF GS_DISPLAY2-STATUS2 = ''.
      GS_DISPLAY2-COLOR = 'C510'.
      GS_DISPLAY2-STATUS = ICON_LED_GREEN..
    ELSEIF  GS_DISPLAY2-STATUS2 = 'X'.
      GS_DISPLAY2-COLOR = 'C610'.
      GS_DISPLAY2-STATUS = ICON_DELETE.
    ENDIF.

*--------------------------------------------------------------------*
    MODIFY  GT_DISPLAY2 FROM GS_DISPLAY2.

  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FILTER2
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_ALV_FILTER2 .

  " ALV에 Filter 정보를 적용하는 과정
  CALL METHOD GO_ALV_GRID_2->SET_FILTER_CRITERIA
    EXPORTING
      IT_FILTER = GT_FILTER                       " Filter Conditions
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
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SEMI_RAW_FILTER .

  REFRESH GT_FILTER.

  CLEAR GS_FILTER.
  GS_FILTER-FIELDNAME = 'STATUS2'.
  GS_FILTER-SIGN      = 'I'.
  GS_FILTER-OPTION    = 'EQ'.
  GS_FILTER-LOW       = 'X'.
  APPEND GS_FILTER TO GT_FILTER.

  CLEAR GS_FILTER.
  GS_FILTER-FIELDNAME = 'STATUS2'.
  GS_FILTER-SIGN      = 'I'.
  GS_FILTER-OPTION    = 'EQ'.
  GS_FILTER-LOW       = ''.
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
  GS_FILTER-FIELDNAME = 'STATUS2'.
  GS_FILTER-SIGN      = 'I'.
  GS_FILTER-OPTION    = 'EQ'.
  GS_FILTER-LOW       = 'X'.
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
  GS_FILTER-FIELDNAME = 'STATUS2'.
  GS_FILTER-SIGN      = 'I'.
  GS_FILTER-OPTION    = 'EQ'.
  GS_FILTER-LOW       = ''.
  APPEND GS_FILTER TO GT_FILTER.

  PERFORM SET_ALV_FILTER2.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_DATA_CASE2 : 채번 + 인덱스 10
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CREATE_DATA_CASE2.

  DATA LV_SUBRC TYPE I.
  DATA LT_PPT010 TYPE TABLE OF ZEA_PPT010.
  DATA LS_PPT010 TYPE ZEA_PPT010.
  DATA LV_YEAR TYPE N LENGTH 4.
  DATA LV_BOMID TYPE ZEA_PPT010-BOMID.
  DATA LT_INDEX_ROWS TYPE LVC_T_ROW.
  DATA LS_INDEX_ROW LIKE LINE OF LT_INDEX_ROWS.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      NR_RANGE_NR             = '01'                 " Number range number
      OBJECT                  = 'ZEA_PLANID'         " Name of number range object
    IMPORTING
      NUMBER                  = ZEA_PLAF-PLANID      " free number
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

  REPLACE FIRST OCCURRENCE OF '0' IN ZEA_PLAF-PLANID WITH 'P'.

  " ZEA_PPT010 : 생산계획 아이템의 BOMID에 값을 넣기 위해 조회
  SELECT SINGLE BOMID
    INTO LV_BOMID
    FROM ZEA_STKO
    WHERE MATNR EQ GS_DISPLAY-MATNR
    AND WERKS EQ GS_DISPLAY-WERKS.

  ZEA_PPT010-BOMID = LV_BOMID.

  LV_YEAR = SY-DATUM+0(4).
  ZEA_PLAF-ERDAT = SY-DATUM.
  ZEA_PLAF-ERNAM = SY-UNAME.
  ZEA_PLAF-ERZET = SY-UZEIT.
  ZEA_PLAF-WERKS = GS_DISPLAY-WERKS.
  ZEA_PLAF-SAPNR = GS_DISPLAY-SAPNR.
  ZEA_PLAF-PDPLI = ZEA_PLAF-PDPLI.
  ZEA_MMT020-MAKTX = GS_DISPLAY-MAKTX.

  READ TABLE GT_DISPLAY INTO GS_DISPLAY INDEX 1.

  TOTAL =  GS_DISPLAY-PLANQTY1 + GS_DISPLAY-PLANQTY2 + GS_DISPLAY-PLANQTY3 +
           GS_DISPLAY-PLANQTY4 + GS_DISPLAY-PLANQTY5 + GS_DISPLAY-PLANQTY6 +
           GS_DISPLAY-PLANQTY7 + GS_DISPLAY-PLANQTY8 + GS_DISPLAY-PLANQTY9 +
           GS_DISPLAY-PLANQTY10 + GS_DISPLAY-PLANQTY11 + GS_DISPLAY-PLANQTY12.
  UNIT = 'EA'.
  ZEA_PLAF-PDPDAT = LV_YEAR.
  ZEA_PPT010-PLANINDEX = '0000000010'.

  INSERT ZEA_PLAF. " 생산계획 헤더에 Insert

  IF SY-SUBRC NE 0.
    LV_SUBRC = 4.
    ROLLBACK WORK.
  ENDIF.
*--------------------------------------------------------------------*

  LOOP AT GT_DISPLAY INTO GS_DISPLAY.

    MOVE-CORRESPONDING GS_DISPLAY TO LS_PPT010.

    LS_PPT010-ERDAT = SY-DATUM.
    LS_PPT010-ERNAM = SY-UNAME.
    LS_PPT010-ERZET = SY-UZEIT.
    LS_PPT010-PLANINDEX = '0000000010'. " 인덱스
    LS_PPT010-PLANID = ZEA_PLAF-PLANID.
    LS_PPT010-BOMID = ZEA_PPT010-BOMID. " 구조체의 값을 DB 테이블에

    INSERT ZEA_PPT010 FROM LS_PPT010. " 생산계획 아이템에 Insert

    IF SY-SUBRC NE 0.
      LV_SUBRC = 4.
      ROLLBACK WORK.
    ENDIF.

  ENDLOOP.

* SD 모듈 상태 플래그에 값 입력
  UPDATE ZEA_SDT030 SET STATUS2 = GC_STATUS WHERE SAPNR EQ GS_DISPLAY-SAPNR
  AND WERKS EQ GS_DISPLAY-WERKS AND MATNR EQ GS_DISPLAY-MATNR.

  REFRESH GT_DISPLAY2.
  CLEAR GS_DISPLAY2.

  " 판매계획 재 조회
  SELECT A~SAPNR A~WERKS A~MATNR A~SAPQU
         A~SPQTY1 A~SPQTY2 A~SPQTY3 A~SPQTY4
         A~SPQTY5 A~SPQTY6 A~SPQTY7 A~SPQTY8
         A~SPQTY9 A~SPQTY10 A~SPQTY11 A~SPQTY12
         B~MAKTX  A~MEINS A~STATUS2
    FROM ZEA_SDT030 AS A
    INNER JOIN ZEA_MMT020 AS B ON A~MATNR EQ B~MATNR
    AND SPRAS EQ SY-LANGU
    INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY2.

    SORT GT_DATA2 BY STATUS2 SAPNR WERKS MATNR.

    DATA LS_STYLE TYPE LVC_S_STYL.

  " 색상과 아이콘 삽입
  LOOP AT GT_DISPLAY2 INTO GS_DISPLAY2.

    IF GS_DISPLAY2-STATUS2 = ''.
      GS_DISPLAY2-COLOR = 'C510'.
      GS_DISPLAY2-STATUS = ICON_LED_GREEN..
    ELSEIF  GS_DISPLAY2-STATUS2 = 'X'.
      GS_DISPLAY2-COLOR = 'C610'.
      GS_DISPLAY2-STATUS = ICON_DELETE.
    ENDIF.

    MODIFY  GT_DISPLAY2 FROM GS_DISPLAY2.

  ENDLOOP.


  PERFORM REFRESH_ALV_0100.

  IF LV_SUBRC EQ 0.
    COMMIT WORK AND WAIT.
    MESSAGE S015. "데이터가 성공적으로 저장되었습니다.
  ELSE.
    ROLLBACK WORK.
    MESSAGE S016 DISPLAY LIKE 'E'. "데이터 저장 중 오류가 발생했습니다.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_DATA_CASE1 : 채번 X , 인덱스만 증가
*&---------------------------------------------------------------------*
FORM CREATE_DATA_CASE1 .

  DATA LV_PLANID TYPE ZEA_PLAF-PLANID.
  DATA LV_BOMID TYPE ZEA_PPT010-BOMID.
  DATA LV_LINES TYPE ZEA_PLAF-PLANID.
  DATA LT_INDEX_ROWS TYPE LVC_T_ROW.
  DATA LS_INDEX_ROW LIKE LINE OF LT_INDEX_ROWS.
  DATA LS_STYLE TYPE LVC_S_STYL.

  " 하나의 생산계획 번호를 LV_PLANID에 넣음
  SELECT SINGLE PLANID
    INTO LV_PLANID
    FROM ZEA_PLAF
    WHERE SAPNR EQ GS_DISPLAY-SAPNR.

  " 하나의 BOM ID를 LV_BOMID에 넣음
  SELECT SINGLE BOMID
    INTO LV_BOMID
    FROM ZEA_STKO
    WHERE MATNR EQ GS_DISPLAY-MATNR
    AND WERKS EQ GS_DISPLAY-WERKS.

  SELECT SINGLE PNAME1
    INTO GS_DISPLAY-PNAME1
    FROM ZEA_T001W
    WHERE WERKS EQ GS_DISPLAY-WERKS.

  ZEA_PLAF-PLANID = LV_PLANID.
  ZEA_PPT010-BOMID = LV_BOMID.
  ZEA_PLAF-PDPLI = |{ GS_DISPLAY-PDPDAT }-{ GS_DISPLAY-PNAME1 } 생산계획 |.

  " 생산계획 아이템에서 카운트해서 GV_LINES에 넣음
  SELECT COUNT(*)
    FROM ZEA_PPT010
    INTO GV_LINES
    WHERE PLANID EQ ZEA_PLAF-PLANID.

  ZEA_PPT010-PLANINDEX = ( GV_LINES + 1 ) * 10.

*&------------------------------------------------------------------&
  DATA LV_SUBRC TYPE I.
  DATA LT_PPT010 TYPE TABLE OF ZEA_PPT010.
  DATA LS_PPT010 TYPE ZEA_PPT010.
  DATA LV_YEAR TYPE N LENGTH 4.

  LV_YEAR = SY-DATUM+0(4).
  ZEA_PLAF-ERDAT = SY-DATUM.
  ZEA_PLAF-ERNAM = SY-UNAME.
  ZEA_PLAF-ERZET = SY-UZEIT.
  ZEA_PLAF-WERKS = GS_DISPLAY-WERKS.
  ZEA_PLAF-SAPNR = GS_DISPLAY-SAPNR.
  ZEA_PLAF-PDPLI = ZEA_PLAF-PDPLI.
  ZEA_MMT020-MAKTX = GS_DISPLAY-MAKTX.
  GS_DISPLAY-STATUS2 = GC_STATUS.

  READ TABLE GT_DISPLAY INTO GS_DISPLAY INDEX 1.

  TOTAL =  GS_DISPLAY-PLANQTY1 + GS_DISPLAY-PLANQTY2 + GS_DISPLAY-PLANQTY3 +
           GS_DISPLAY-PLANQTY4 + GS_DISPLAY-PLANQTY5 + GS_DISPLAY-PLANQTY6 +
           GS_DISPLAY-PLANQTY7 + GS_DISPLAY-PLANQTY8 + GS_DISPLAY-PLANQTY9 +
           GS_DISPLAY-PLANQTY10 + GS_DISPLAY-PLANQTY11 + GS_DISPLAY-PLANQTY12.
  UNIT = 'EA'.
  ZEA_PLAF-PDPDAT = LV_YEAR.
*--------------------------------------------------------------------*

  LOOP AT GT_DISPLAY INTO GS_DISPLAY.

    MOVE-CORRESPONDING GS_DISPLAY TO LS_PPT010.

    LS_PPT010-ERDAT = SY-DATUM.
    LS_PPT010-ERNAM = SY-UNAME.
    LS_PPT010-ERZET = SY-UZEIT.

    LS_PPT010-PLANID = ZEA_PLAF-PLANID.
    LS_PPT010-PLANINDEX = ZEA_PPT010-PLANINDEX.
    LS_PPT010-BOMID = ZEA_PPT010-BOMID.

    INSERT ZEA_PPT010 FROM LS_PPT010.

    IF SY-SUBRC NE 0.
      LV_SUBRC = 4.
      ROLLBACK WORK.
    ENDIF.

  ENDLOOP.

***   SD 모듈 상태 플래그에 값 입력
  UPDATE ZEA_SDT030 SET STATUS2 = GC_STATUS WHERE SAPNR EQ GS_DISPLAY-SAPNR
  AND WERKS EQ GS_DISPLAY-WERKS AND MATNR EQ GS_DISPLAY-MATNR.

  REFRESH GT_DISPLAY2.
  CLEAR GS_DISPLAY2.

  SELECT A~SAPNR A~WERKS A~MATNR A~SAPQU
         A~SPQTY1 A~SPQTY2 A~SPQTY3 A~SPQTY4
         A~SPQTY5 A~SPQTY6 A~SPQTY7 A~SPQTY8
         A~SPQTY9 A~SPQTY10 A~SPQTY11 A~SPQTY12
         B~MAKTX  A~MEINS A~STATUS2
    FROM ZEA_SDT030 AS A
    INNER JOIN ZEA_MMT020 AS B ON A~MATNR EQ B~MATNR
    AND SPRAS EQ SY-LANGU
    INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY2.

    SORT GT_DATA2 BY STATUS2 SAPNR WERKS MATNR.

  LOOP AT GT_DISPLAY2 INTO GS_DISPLAY2.

    IF GS_DISPLAY2-STATUS2 = ''.
      GS_DISPLAY2-COLOR = 'C510'.
      GS_DISPLAY2-STATUS = ICON_LED_GREEN..
    ELSEIF  GS_DISPLAY2-STATUS2 = 'X'.
      GS_DISPLAY2-COLOR = 'C610'.
      GS_DISPLAY2-STATUS = ICON_DELETE.
    ENDIF.

    MODIFY  GT_DISPLAY2 FROM GS_DISPLAY2.

  ENDLOOP.

  PERFORM REFRESH_ALV_0100.

  IF LV_SUBRC EQ 0.
    COMMIT WORK AND WAIT.
    MESSAGE S015. "데이터가 성공적으로 저장되었습니다.
  ELSE.
    ROLLBACK WORK.
    MESSAGE S016 DISPLAY LIKE 'E'. "데이터 저장 중 오류가 발생했습니다.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_PLAN
*&---------------------------------------------------------------------*
FORM MAKE_PLAN .

  DATA LT_INDEX_ROWS TYPE LVC_T_ROW.
  DATA LS_INDEX_ROW LIKE LINE OF LT_INDEX_ROWS.

  CALL METHOD GO_ALV_GRID_2->GET_SELECTED_ROWS
    IMPORTING
      ET_INDEX_ROWS = LT_INDEX_ROWS     " Indexes of Selected Rows
*     ET_ROW_NO     =                   " Numeric IDs of Selected Rows
    .

  IF LT_INDEX_ROWS[] IS INITIAL.
    " TEXT-M01: 라인을 선택하세요.
    MESSAGE S061 DISPLAY LIKE 'W'.

    ELSE.
  ENDIF.


  DATA LV_INDEX TYPE I.
  DATA LV_DATE TYPE N LENGTH 4.

  " 첫번째 인덱스 값
  READ TABLE LT_INDEX_ROWS INTO LS_INDEX_ROW INDEX 1.

  " GT_DISPLAY2의 첫번째 행의 값을 GS_DISPLAY2에 넣음
  READ TABLE GT_DISPLAY2 INTO GS_DISPLAY2 INDEX LS_INDEX_ROW-INDEX.

  DESCRIBE TABLE GT_DISPLAY.

  IF SY-TFILL EQ 0.

    IF SY-SUBRC EQ 0.
      LOOP AT GT_DISPLAY INTO GS_DISPLAY.

        IF GS_DISPLAY-SAPNR EQ GS_DISPLAY2-SAPNR.
          LV_INDEX = SY-TABIX.
          MESSAGE '동일한 판매계획은 추가할 수 없습니다.' TYPE 'S' DISPLAY LIKE 'E'.
        ENDIF.
      ENDLOOP.

      IF GS_DISPLAY2-STATUS2 EQ 'X'.
        MESSAGE '이미 생성된 생산계획입니다.' TYPE 'S' DISPLAY LIKE 'E'.

      ELSEIF LV_INDEX EQ 0.
        MESSAGE S000 WITH '생산계획이 성공적으로 추가되었습니다.'.

        " 생산계획 = 판매계획 대비 110%
        MOVE-CORRESPONDING GS_DISPLAY2 TO GS_DISPLAY.
        LV_DATE = SY-DATUM+0(4).                      " 해당 라인 수정 필요 판매계획의 날짜와 동일하게.
        GS_DISPLAY-PDPDAT = LV_DATE.
        GS_DISPLAY-PLANQTY1 = GS_DISPLAY2-SPQTY1 + ( GS_DISPLAY2-SPQTY1 * 10 ) / 100 .
        GS_DISPLAY-PLANQTY2 = GS_DISPLAY2-SPQTY2 + ( GS_DISPLAY2-SPQTY2 * 10 ) / 100 .
        GS_DISPLAY-PLANQTY3 = GS_DISPLAY2-SPQTY3 + ( GS_DISPLAY2-SPQTY3 * 10 ) / 100 .
        GS_DISPLAY-PLANQTY4 = GS_DISPLAY2-SPQTY4 + ( GS_DISPLAY2-SPQTY4 * 10 ) / 100 .
        GS_DISPLAY-PLANQTY5 = GS_DISPLAY2-SPQTY5 + ( GS_DISPLAY2-SPQTY5 * 10 ) / 100 .
        GS_DISPLAY-PLANQTY6 = GS_DISPLAY2-SPQTY6 + ( GS_DISPLAY2-SPQTY6 * 10 ) / 100 .
        GS_DISPLAY-PLANQTY7 = GS_DISPLAY2-SPQTY7 + ( GS_DISPLAY2-SPQTY7 * 10 ) / 100 .
        GS_DISPLAY-PLANQTY8 = GS_DISPLAY2-SPQTY8 + ( GS_DISPLAY2-SPQTY8 * 10 ) / 100 .
        GS_DISPLAY-PLANQTY9 = GS_DISPLAY2-SPQTY9 + ( GS_DISPLAY2-SPQTY9 * 10 ) / 100 .
        GS_DISPLAY-PLANQTY10 = GS_DISPLAY2-SPQTY10 + ( GS_DISPLAY2-SPQTY10 * 10 ) / 100 .
        GS_DISPLAY-PLANQTY11 = GS_DISPLAY2-SPQTY11 + ( GS_DISPLAY2-SPQTY11 * 10 ) / 100 .
        GS_DISPLAY-PLANQTY12 = GS_DISPLAY2-SPQTY12 + ( GS_DISPLAY2-SPQTY12 * 10 ) / 100 .
        GS_DISPLAY-MEINS = GS_DISPLAY2-MEINS.
        APPEND GS_DISPLAY TO GT_DISPLAY.
      ELSE.
      ENDIF.

      PERFORM REFRESH_ALV_0100.
    ENDIF.

  ELSE.
    MESSAGE S063 DISPLAY LIKE 'E'.
  ENDIF.

  CALL METHOD CL_GUI_CFW=>SET_NEW_OK_CODE
    EXPORTING
      NEW_CODE = 'ENTER'.                 " New OK_CODE

ENDFORM.
