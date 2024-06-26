*&---------------------------------------------------------------------*
*& Include          MZ_ZEA_GL_DISPLAY_F01
*&---------------------------------------------------------------------*
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


  CALL METHOD GO_ALV_GRID->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
*     I_BUFFER_ACTIVE  =                  " Buffering Active
*     I_BYPASSING_BUFFER            =                  " Switch Off Buffer
*     I_CONSISTENCY_CHECK           =                  " Starting Consistency Check for Interface Error Recognition
      I_STRUCTURE_NAME = 'ZEA_BSEG'       " Internal Output Table Structure Name
    CHANGING
      IT_OUTTAB        = GT_DISPLAY      " Output Table
*     IT_FIELDCATALOG  =                  " Field Catalog
*     IT_SORT          =                  " Sort Criteria
*     IT_FILTER        =                  " Filter Criteria
*   EXCEPTIONS
*     INVALID_PARAMETER_COMBINATION = 1                " Wrong Parameter
*     PROGRAM_ERROR    = 2                " Program Errors
*     TOO_MANY_LINES   = 3                " Too many Rows in Ready for Input Grid
*     OTHERS           = 4
    .
  IF SY-SUBRC <> 0.
*  MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*    WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
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
*& Form GET_FIELDCAT2
*&---------------------------------------------------------------------*
FORM GET_FIELDCAT2  USING PT_TAB TYPE STANDARD TABLE
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
*& Form MAKE_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM MAKE_FIELDCAT_0100 .

  LOOP AT GT_FIELDCAT INTO GS_FIELDCAT.
*
    CASE GS_FIELDCAT-FIELDNAME.
**      WHEN 'STATUS'.
**        GS_FIELDCAT-COLTEXT = 'Status'.
**        GS_FIELDCAT-ICON    = ABAP_ON.
**        GS_FIELDCAT-KEY     = ABAP_OFF.
**        GS_FIELDCAT-NO_OUT  = ABAP_ON.
**      WHEN 'COLOR'.
**        GS_FIELDCAT-NO_OUT  = ABAP_ON.
**      WHEN 'LIGHT'.
**        GS_FIELDCAT-NO_OUT  = ABAP_ON.
**      WHEN 'MARK'.
**        GS_FIELDCAT-NO_OUT  = ABAP_ON.
**      WHEN 'MANDT'.
**        GS_FIELDCAT-NO_OUT  = ABAP_ON.
**
**      WHEN 'ITNUM'.
**        GS_FIELDCAT-COL_POS = 1.
**
      WHEN 'XBLNR'.
        GS_FIELDCAT-HOTSPOT =  ABAP_ON.
    ENDCASE.
*
    MODIFY GT_FIELDCAT FROM GS_FIELDCAT.
*
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
  " 'U' : 저장한 사용자만 사용가능
  " 'X' : Layout을 저장하면 모든 사용자가 사용 가능
  " 'A' : Layout을 저장할 때 'U'/'X' 선택 가능

  GS_LAYOUT-CWIDTH_OPT = ABAP_ON.
  GS_LAYOUT-ZEBRA      = ABAP_ON.
  GS_LAYOUT-SEL_MODE   = 'D'.
*
*  WHEN GS_DATA-AUGBL.
*    GS_LAYOUT
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
*& Form SET_ALV_EVENT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_EVENT_0100 .


  IF GCL_HANDLER IS NOT BOUND.

    CREATE OBJECT GCL_HANDLER.

  ENDIF.


  SET HANDLER : GCL_HANDLER->ON_HOTSPOT_CLICK FOR GO_ALV_GRID.


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
*& Form SELECT_DATA_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SELECT_DATA_0100 .

  REFRESH GT_DISPLAY.

  SELECT *
    FROM ZEA_BSEG
    INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY
    WHERE BELNR EQ ZEA_BKPF-BELNR
    ORDER BY ITNUM.


*---- 참조문서 / 플랜트 / 자재코드 값 넣기

  LOOP AT GT_DISPLAY INTO GS_DISPLAY.

    MOVE-CORRESPONDING ZEA_BSEG TO GS_DISPLAY.
    GS_DISPLAY-XBLNR = ZEA_BKPF-XBLNR.
    GS_DISPLAY-WERKS = ZEA_BSEG-WERKS.
    GS_DISPLAY-MATNR = ZEA_BSEG-MATNR.
    MODIFY GT_DISPLAY FROM GS_DISPLAY TRANSPORTING XBLNR.

  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_HOTSPOT_CLICK
*&---------------------------------------------------------------------*
FORM HANDLE_HOTSPOT_CLICK USING PS_ROW_ID TYPE LVC_S_ROW
                                PS_COLUMN_ID TYPE  LVC_S_COL
                                PO_SENDER    TYPE REF TO CL_GUI_ALV_GRID.



* 선택한 행이 인터널테이블에 있는 정상적인 데이터인지 체크
  CHECK PS_ROW_ID-ROWTYPE IS INITIAL.

  READ TABLE GT_DISPLAY INTO GS_DISPLAY INDEX PS_ROW_ID-INDEX.

  CASE PS_COLUMN_ID-FIELDNAME.

    WHEN 'XBLNR'.
      IF  ZEA_BKPF-BLART EQ 'KA'.

        SELECT SINGLE * FROM ZEA_MMT170
          INTO ZEA_MMT170
          WHERE BELNR EQ GS_DISPLAY-XBLNR.

        MESSAGE '참조문서 (송장:' &&  GS_DISPLAY-XBLNR && ')을 상세 조회합니다.'
        && '구매오더 번호 [' && ZEA_MMT170-PONUM && ']을 선택해 주세요.'   TYPE 'I'.

        CALL TRANSACTION 'ZEA_MM070'.

      ELSEIF ZEA_BKPF-BLART EQ 'DA'.

        SET PARAMETER ID 'ZEA_PAYNR' FIELD GS_DISPLAY-XBLNR.

        CALL FUNCTION 'POPUP_TO_CONFIRM'
          EXPORTING
            TITLEBAR       = '참조문서 조회'
            TEXT_QUESTION  = '참조문서 (세금계산서' && GS_DISPLAY-XBLNR && ') 조회 View를 선택하시오.'
            TEXT_BUTTON_1  = '세금계산서 상세조회'
            TEXT_BUTTON_2  = '채권회수 여부조회'

            START_COLUMN   = 25
            START_ROW      = 6

          IMPORTING
            ANSWER         = GV_ANSWER
          EXCEPTIONS
            TEXT_NOT_FOUND = 1
            OTHERS         = 2.

        IF GV_ANSWER NE '1'.    " - - -  매출채권 회수여부 조회

          MESSAGE ' 세금계산서 [' && GS_DISPLAY-XBLNR && ']의 판매오더를 조회합니다.' TYPE 'I'.
          CALL TRANSACTION 'ZEASD080' AND SKIP FIRST SCREEN .

        ELSE.

          MESSAGE '참조문서 (세금계산서' && GS_DISPLAY-XBLNR && ')을 상세 조회합니다.' TYPE 'I'.

          CALL TRANSACTION 'ZEASDA09' AND SKIP FIRST SCREEN .

        ENDIF.
      ENDIF.

  ENDCASE.

ENDFORM.
