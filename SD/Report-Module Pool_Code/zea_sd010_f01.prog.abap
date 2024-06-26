*&---------------------------------------------------------------------*
*& Include          YE12_PJ020_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form SELECT_DATA
*&---------------------------------------------------------------------*
FORM SELECT_DATA .

  SELECT *
    FROM ZEA_SDT020 AS A INNER JOIN ZEA_T001W AS B ON A~WERKS EQ B~WERKS
*                         LEFT JOIN ZEA_SDT090 AS C ON B~MATNR EQ C~MATNR
    INTO CORRESPONDING FIELDS OF TABLE GT_DATA
   WHERE A~WERKS EQ ZEA_SDT020-WERKS.

  SORT GT_DATA BY SAPNR SP_YEAR DESCENDING.

  REFRESH GT_DATA2.

*** 리스트 박스에서 보여줄 데이터
  SELECT *
      FROM ZEA_T001W
      INTO CORRESPONDING FIELDS OF TABLE GT_LIST.


**** 판매계획 ITEM ALV
*  SELECT *
*    FROM ZEA_SDT030 AS A
*   INNER JOIN ZEA_MMT020 AS B
*      ON A~MATNR EQ B~MATNR
*    INTO CORRESPONDING FIELDS OF TABLE GT_DATA2.

***** 팝업
**REFRESH GT_DISPLAY3.
**SELECT *
**  FROM ZEA_SDT030
**  INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY3
** WHERE SP_YEAR EQ 2023 AND WERKS EQ GV_LIST.

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
*     I_STRUCTURE_NAME              = 'ZEA_SDT020'
      IS_VARIANT                    = GS_VARIANT
      I_SAVE                        = GV_SAVE
      IS_LAYOUT                     = GS_LAYOUT
*     IT_TOOLBAR_EXCLUDING          = GT_TOOLBAR[]
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
  ENDIF.

  IF SY-SUBRC <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.


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

*--------------------------------------------------------------------*
    APPEND GS_DISPLAY TO GT_DISPLAY.

  ENDLOOP.




  REFRESH GT_DISPLAY2.

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


*** -->> 이부분 메세지 처음 시작부터 뜨길래 지움 .

**  DESCRIBE TABLE GT_DISPLAY LINES GV_LINES.

**  IF GT_DISPLAY IS INITIAL.
**    MESSAGE S013 DISPLAY LIKE 'W'. " 해당 조건의 데이터가 존재하지 않습니다.
**  ELSE.
**    MESSAGE S006 WITH GV_LINES.
**  ENDIF.


*  DESCRIBE TABLE GT_DISPLAY2 LINES GV_LINES.
*
*  IF GT_DISPLAY2 IS INITIAL.
*    MESSAGE S013 DISPLAY LIKE 'W'.
*  ELSE.
*    MESSAGE S006 WITH GV_LINES.
*  ENDIF.

* 만약 현재 프로그램이 배치 모드에서 실행 중이라면 프로그램을 종료합니다.
  IF NOT SY-BATCH IS INITIAL. EXIT. ENDIF.

  CALL SCREEN 0100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_FIELDCAT_0100 .

  REFRESH GT_FIELDCAT.


*  CLEAR GS_FIELDCAT.
*  GS_FIELDCAT-FIELDNAME = 'STATUS'.
*  GS_FIELDCAT-COL_POS   = 0.
*  GS_FIELDCAT-REF_TABLE = 'ICON'.
*  GS_FIELDCAT-ICON      = ABAP_ON.
*  GS_FIELDCAT-REF_FIELD = 'ID'.
*  GS_FIELDCAT-COLTEXT   = TEXT-F09. " 상세계획여부
*  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-COL_POS   = 0.
  GS_FIELDCAT-FIELDNAME = 'SAPNR'.
  GS_FIELDCAT-COLTEXT    = TEXT-F01. " 판매계획번호
  GS_FIELDCAT-HOTSPOT    = ABAP_ON.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-COL_POS   = 1.
  GS_FIELDCAT-FIELDNAME = 'SP_YEAR'.
  GS_FIELDCAT-COLTEXT    = TEXT-F02. " 판매계획 년도
  GS_FIELDCAT-JUST      = 'C'.

  GS_FIELDCAT-OUTPUTLEN = 4.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-COL_POS   = 2.
  GS_FIELDCAT-FIELDNAME = 'WERKS'.
  GS_FIELDCAT-COLTEXT    = TEXT-F03. "  플랜트ID
  GS_FIELDCAT-OUTPUTLEN = 5.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-COL_POS   = 3.
  GS_FIELDCAT-FIELDNAME = 'PNAME1'.
  GS_FIELDCAT-COLTEXT    = TEXT-F10. "  플랜트명
  GS_FIELDCAT-OUTPUTLEN = 16.
**  GS_FIELDCAT-JUIST      = 'C'. " C / R / L
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-COL_POS   = 4.
  GS_FIELDCAT-FIELDNAME = 'SAPQU'.
  GS_FIELDCAT-COLTEXT    = TEXT-F04. "  판매계획 수량
  GS_FIELDCAT-QFIELDNAME    = 'MEINS'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-COL_POS   = 5.
  GS_FIELDCAT-FIELDNAME = 'MEINS'.
  GS_FIELDCAT-COLTEXT    = TEXT-F05. "  단위
  GS_FIELDCAT-OUTPUTLEN = 4.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-COL_POS   = 6.
  GS_FIELDCAT-FIELDNAME = 'TOTREV'.
  GS_FIELDCAT-COLTEXT    = TEXT-F06. "  목표 매출
  GS_FIELDCAT-EMPHASIZE  = 'C311'.
  GS_FIELDCAT-CFIELDNAME    = 'WAERS'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-COL_POS   = 7.
  GS_FIELDCAT-FIELDNAME = 'WAERS'.
  GS_FIELDCAT-COLTEXT    = TEXT-F07. "  통화코드
  GS_FIELDCAT-OUTPUTLEN = 4.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-COL_POS   = 8.
  GS_FIELDCAT-FIELDNAME = 'LOEKZ'.
  GS_FIELDCAT-COLTEXT    = TEXT-F08. "  삭제여부
  GS_FIELDCAT-NO_OUT  = ABAP_ON.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

*--------------------------------------------------------------------*

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-COL_POS   = 9.
  GS_FIELDCAT-FIELDNAME = 'ERNAM'.
  GS_FIELDCAT-COLTEXT    = '생성자'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-COL_POS   = 10.
  GS_FIELDCAT-FIELDNAME = 'ERDAT'.
  GS_FIELDCAT-COLTEXT    = '생성일'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-COL_POS   = 11.
  GS_FIELDCAT-FIELDNAME = 'ERZET'.
  GS_FIELDCAT-COLTEXT    = '입력시간'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-COL_POS   = 12.
  GS_FIELDCAT-FIELDNAME = 'AENAM'.
  GS_FIELDCAT-COLTEXT    = '변경자'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-COL_POS   = 13.
  GS_FIELDCAT-FIELDNAME = 'AEDAT'.
  GS_FIELDCAT-COLTEXT    = '변경일'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-COL_POS   = 14.
  GS_FIELDCAT-FIELDNAME = 'AEZET'.
  GS_FIELDCAT-COLTEXT    = '변경시간'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.



* 신규 필드 추가
*  CLEAR GS_FIELDCAT.
*  GS_FIELDCAT-FIELDNAME = 'RATE'.
*  GS_FIELDCAT-COL_POS   = 100.
*  GS_FIELDCAT-COLTEXT   = TEXT-F02. " Rate
*  APPEND GS_FIELDCAT TO GT_FIELDCAT.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_LAYOUT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_LAYOUT_0100 .

  CLEAR GS_LAYOUT.
  CLEAR GS_VARIANT.
  CLEAR GV_SAVE.

  GS_VARIANT-REPORT = SY-REPID.
  GV_SAVE = 'A'.   " '' : Layout 저장불가
  " 'U' : 저장한 사용자만 사용가능
  " 'X' : Layout을 저장하면 모든 사용자가 사용 가능
  " 'A' : Layout을 저장할 때 'U'/'X' 선택 가능

*  GS_LAYOUT-CWIDTH_OPT = ABAP_ON.
  GS_LAYOUT-ZEBRA      = ABAP_ON.
  GS_LAYOUT-SEL_MODE   = 'B'.

*  GS_LAYOUT-GRID_TITLE = TEXT-T10.          " ALV TITLE TEXT
  GS_LAYOUT-INFO_FNAME = 'COLOR'.           " 행 색상
*  GS_LAYOUT-EXCP_FNAME = 'LIGHT'.           " 신호등
*  GS_LAYOUT-EXCP_LED = ABAP_ON.             " 신호등 모양 변경
*  GS_LAYOUT-CTAB_FNAME = 'IT_FIELD_COLORS'. " 셀 별 색상
  GS_LAYOUT-STYLEFNAME  = 'STYLE'.          " 스타일

  GS_LAYOUT-NO_TOOLBAR = 'X'.
  GS_LAYOUT-NO_ROWINS  = 'X'.
  GS_LAYOUT-NO_ROWMOVE = 'X'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_EVENT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_EVENT_0100 .

  SET HANDLER LCL_EVENT_HANDLER=>ON_DOUBLE_CLICK FOR GO_ALV_GRID.
  SET HANDLER LCL_EVENT_HANDLER=>ON_HOTSPOT_CLICK FOR GO_ALV_GRID.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_DOUBLE_CLICK
*&---------------------------------------------------------------------*
FORM HANDLE_DOUBLE_CLICK  USING PS_ROW     TYPE LVC_S_ROW
                                PS_COL     TYPE  LVC_S_COL
                                PO_SENDER  TYPE REF TO CL_GUI_ALV_GRID.

  DATA LV_MSG TYPE STRING.

* TOP 에서 더블 클릭한 라인의 SAPNR 를 가져와서
* 해당 CARRID 와 관련있는 ZEA_SDT030 만 조회한 후
* GO_ALV_GRID2 에 가져온 결과를 출력한다.

  " TOP의 데이터 중 더블 클릭한 데이터를 GS_DATA 에 전달한다.
*  READ TABLE GT_SDT020 INTO GS_SDT020 INDEX PS_ROW-INDEX.
  READ TABLE GT_DISPLAY INTO GS_DISPLAY INDEX PS_ROW-INDEX.

  " 더블클릭한 GO_ALV_GIRD의 SAPNR와 관련있는 정보만 취급하기 위해
  " 기존에 갖고 있던 데이터를 전부 지우고, 새롭게 데이터를 조회한다.
  REFRESH GT_DISPLAY2.

  SELECT *
    FROM ZEA_SDT030 AS A LEFT JOIN ZEA_MMT020 AS B
                                ON A~MATNR EQ B~MATNR
                               AND B~SPRAS EQ SY-LANGU
                         LEFT JOIN ZEA_T001W AS C
                                ON A~WERKS EQ C~WERKS
    INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY2
   WHERE SAPNR   EQ GS_DISPLAY-SAPNR
     AND SP_YEAR EQ GS_DISPLAY-SP_YEAR.


  SORT GT_DISPLAY2 BY POSNR MATNR ASCENDING.

*** 검색된 수 말해주기.
  DESCRIBE TABLE GT_DISPLAY2 LINES GV_LINES.
  IF GT_DISPLAY2 IS INITIAL.
    MESSAGE S013 DISPLAY LIKE 'W'. " 해당 조건의 데이터가 존재하지 않습니다.
  ELSE.
    MESSAGE S006 WITH GV_LINES.
  ENDIF.

  PERFORM REFRESH_ALV_0100.
*--------------------------------------------------------------------*

*  REFRESH GT_DISPLAY2.
*
*  LOOP AT GT_DATA2 INTO GS_DATA2.
*    CLEAR GS_DISPLAY2.
*    MOVE-CORRESPONDING GS_DATA2 TO GS_DISPLAY2.
*    APPEND GS_DISPLAY2 TO GT_DISPLAY2.
*  ENDLOOP.
*
*  SELECT *
*    FROM GT_DISPLAY2
*    INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY2
*   WHERE SAPNR EQ GS_DISPLAY-SAPNR
*     AND SP_YEAR EQ GS_DISPLAY-SP_YEAR.
*
*      SORT GT_DISPLAY2 BY SAPNR SP_YEAR.

*--------------------------------------------------------------------*


*  GS_SDT020_2 = GS_DISPLAY.

  ZEA_SDT020-SAPNR = GS_DISPLAY-SAPNR.
  ZEA_SDT020-SP_YEAR = GS_DISPLAY-SP_YEAR.
  ZEA_SDT020-SAPQU = GS_DISPLAY-SAPQU.
*  ZEA_SDT020-WERKS = GS_DISPLAY-WERKS.
  GV_LIST = GS_DISPLAY-WERKS.
  ZEA_SDT020-TOTREV = GS_DISPLAY-TOTREV.
  ZEA_SDT020-MEINS = GS_DISPLAY-MEINS.
  ZEA_SDT020-WAERS = GS_DISPLAY-WAERS.

  GV_MODE1 = ABAP_ON.

  CALL METHOD CL_GUI_CFW=>SET_NEW_OK_CODE
    EXPORTING
      NEW_CODE = 'ENTER'.                 " New OK_CODE


*  " GT_DATA2 의 데이터가 변경되었으므로,
*  " 변경된 데이터를 ALV에 출력하기 위해 ALV를 새로고침 한다.
*  CALL METHOD GO_ALV_GRID2->REFRESH_TABLE_DISPLAY
**    EXPORTING
**      IS_STABLE      =                  " With Stable Rows/Columns
**      I_SOFT_REFRESH =                  " Without Sort, Filter, etc.
*    EXCEPTIONS
*      FINISHED = 1                " Display was Ended (by Export)
*      OTHERS   = 2.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_DETAIL_0100
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT_DETAIL_0100 .

  CREATE OBJECT GO_CONTAINER2
    EXPORTING
      CONTAINER_NAME = 'CCON2'
    EXCEPTIONS
      OTHERS         = 1.

  IF SY-SUBRC NE 0.
    MESSAGE E020. " Custom Container 생성 중 오류가 발생했습니다.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  CREATE OBJECT GO_ALV_GRID2
    EXPORTING
      I_PARENT = GO_CONTAINER2
    EXCEPTIONS
      OTHERS   = 1.

  IF SY-SUBRC NE 0.
    MESSAGE E021. " ALV Grid 생성 중 오류가 발생했습니다.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_LAYOUT_DETAIL_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_LAYOUT_DETAIL_0100 .

  CLEAR GS_LAYOUT.
  CLEAR GS_VARIANT2.
  CLEAR GV_SAVE2.

*  GS_LAYOUT-CWIDTH_OPT = ABAP_ON.
  GS_LAYOUT-ZEBRA      = ABAP_ON.
  GS_LAYOUT-SEL_MODE   = 'B'.


*  GS_VARIANT2-REPORT = SY-REPID.
  GV_SAVE2 = 'A'.   " '' : Layout 저장불가
  " 'U' : 저장한 사용자만 사용가능
  " 'X' : Layout을 저장하면 모든 사용자가 사용 가능
  " 'A' : Layout을 저장할 때 'U'/'X' 선택 가능

*  GS_LAYOUT-GRID_TITLE = TEXT-T10.          " ALV TITLE TEXT
  GS_LAYOUT-INFO_FNAME = 'COLOR'.           " 행 색상
*  GS_LAYOUT-EXCP_FNAME = 'LIGHT'.           " 신호등
*  GS_LAYOUT-EXCP_LED = ABAP_ON.             " 신호등 모양 변경
*  GS_LAYOUT-CTAB_FNAME = 'IT_FIELD_COLORS'. " 셀 별 색상
  GS_LAYOUT-STYLEFNAME  = 'STYLE'.          " 스타일

*  GS_LAYOUT-NO_TOOLBAR = 'X'.
  GS_LAYOUT-NO_ROWINS  = 'X'.
  GS_LAYOUT-NO_ROWMOVE = 'X'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_DETAIL_0100
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV_DETAIL_0100 .

  CALL METHOD GO_ALV_GRID2->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
*     I_STRUCTURE_NAME              = 'ZEA_SDT030'
      IS_VARIANT                    = GS_VARIANT2
      I_SAVE                        = GV_SAVE2
      IS_LAYOUT                     = GS_LAYOUT
      IT_TOOLBAR_EXCLUDING          = GT_TOOLBAR[]
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
    " ALV Grid2 에 데이터를 전달하는 중 오류가 발생했습니다.
    MESSAGE E023.
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
*& Form REFRESH_ALV_DETAIL_0100
*&---------------------------------------------------------------------*
FORM REFRESH_ALV_DETAIL_0100 .
  DATA LS_STABLE TYPE LVC_S_STBL.
  LS_STABLE-ROW = ABAP_ON.
  LS_STABLE-COL = ABAP_ON.

  CALL METHOD GO_ALV_GRID2->REFRESH_TABLE_DISPLAY
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
*& Form SET_ALV_EVENT_DETAIL_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_EVENT_DETAIL_0100 .

*  CALL METHOD GO_ALV_GRID2->SET_READY_FOR_INPUT
*    EXPORTING
*      I_READY_FOR_INPUT = 1.

  CALL METHOD GO_ALV_GRID2->REGISTER_EDIT_EVENT  " EDIT 이벤트 등록
    EXPORTING
      I_EVENT_ID = CL_GUI_ALV_GRID=>MC_EVT_MODIFIED " Event ID
    EXCEPTIONS
      ERROR      = 1                " Error
      OTHERS     = 2.

  SET HANDLER LCL_EVENT_HANDLER=>ON_TOOLBAR       FOR GO_ALV_GRID2.
  SET HANDLER LCL_EVENT_HANDLER=>ON_USER_COMMAND  FOR GO_ALV_GRID2.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_SP_DATA
*&---------------------------------------------------------------------*
FORM CREATE_SP_DATA .


*** 맨 처음에 입력필드 확인하기
  IF
*    ZEA_SDT020-SAPNR IS INITIAL
  ZEA_SDT020-SP_YEAR  IS INITIAL
*  OR ZEA_SDT020-WERKS IS INITIAL.
  OR GV_LIST IS INITIAL.
    MESSAGE E000 WITH '값을 입력해주세요.'.
*    GV_MODE1 = ABAP_OFF.
    EXIT.
*  ELSE.
*    GV_MODE1 = ABAP_ON.
  ENDIF.

*** 이미 생성된 판매계획이 있는지 확인하는 과정
  SELECT COUNT(*)
    FROM ZEA_SDT020
   WHERE SP_YEAR EQ ZEA_SDT020-SP_YEAR
*     AND WERKS   EQ ZEA_SDT020-WERKS. " 아이템의 판매계획번호를 GT_CHECK 라는 인터널 테이블에 넣음
     AND WERKS EQ GV_LIST.

*** 없으면 신규생성하기.
  IF SY-SUBRC EQ 0.
    MESSAGE S034 DISPLAY LIKE 'E' . "이미 생성된 판매운영계획입니다.
  ELSE.
    PERFORM CREATE_DATA_CASE2.  " 판매계획을 한번도 사용안했으면 해당 로직을 탐
*    PERFORM CREATE_DATA_CASE1. " 판매계획번호를 한번이라도 사용되지 않으면 해당 로직을 탐

  ENDIF.

  CALL METHOD GO_ALV_GRID2->SET_READY_FOR_INPUT
    EXPORTING
      I_READY_FOR_INPUT = 1.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FIELDCAT_DETAIL_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_FIELDCAT_DETAIL_0100 .


  PERFORM GET_FIELDCAT2   USING    GT_DISPLAY2
                          CHANGING GT_FIELDCAT.
  PERFORM MAKE_FIELDCAT_0100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_TOOLBAR_DETAIL_0100
*&---------------------------------------------------------------------*
FORM SET_TOOLBAR_DETAIL_0100 .

*  GT_TOOLBAR[] = VALUE #(
*                              ( CL_GUI_ALV_GRID=>MC_FC_LOC_APPEND_ROW )
**                              ( CL_GUI_ALV_GRID=>MC_FC_LOC_COPY )
**                              ( CL_GUI_ALV_GRID=>MC_FC_LOC_COPY_ROW )
**                              ( CL_GUI_ALV_GRID=>MC_FC_LOC_CUT )
*                              ( CL_GUI_ALV_GRID=>MC_FC_LOC_DELETE_ROW )
*                              ( CL_GUI_ALV_GRID=>MC_FC_LOC_INSERT_ROW )
**                              ( CL_GUI_ALV_GRID=>MC_FC_LOC_MOVE_ROW )
**                              ( CL_GUI_ALV_GRID=>MC_FC_LOC_PASTE )
**                              ( CL_GUI_ALV_GRID=>MC_FC_LOC_PASTE_NEW_ROW )
**                              ( CL_GUI_ALV_GRID=>MC_FC_LOC_UNDO )
**                              ( CL_GUI_ALV_GRID=>MC_FC_REFRESH )
**                              ( CL_GUI_ALV_GRID=>MC_FC_CHECK )
**                              ( CL_GUI_ALV_GRID=>MC_FC_GRAPH )
**                              ( CL_GUI_ALV_GRID=>MC_FC_HELP )
**                              ( CL_GUI_ALV_GRID=>MC_FC_INFO )
**                              ( CL_GUI_ALV_GRID=>MC_FC_VIEWS )
**                              ( CL_GUI_ALV_GRID=>MC_FC_PRINT )
*                           ).
*
**  MC_FC_DATA_SAVE

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLER_TOOLBAR
*&---------------------------------------------------------------------*
FORM HANDLER_TOOLBAR USING PO_OBJECT TYPE REF TO CL_ALV_EVENT_TOOLBAR_SET
                           PO_SENDER TYPE REF TO CL_GUI_ALV_GRID.

  " Internal Table PO_OBJECT->MT_TOOLBAR 를 위한 작업공간
  " PO_OBJECT->MT_TOOLBAR >>> 클래스의 Attribute ( Public , Instance )

  DATA LS_TOOLBAR LIKE LINE OF PO_OBJECT->MT_TOOLBAR.

  CASE PO_SENDER.
    WHEN GO_ALV_GRID2.
* 구분자 =>> |
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 3. " 구분자
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 행추가
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 0. " 행추가
*      LS_TOOLBAR-FUNCTION = GC_INSERT.
      LS_TOOLBAR-ICON = ICON_REPORT_CALL.
      LS_TOOLBAR-TEXT = TEXT-L01.
      LS_TOOLBAR-FUNCTION = 'PAST_DATA'.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_USER_COMMAND
*&---------------------------------------------------------------------*
FORM HANDLE_USER_COMMAND  USING PV_UCOMM TYPE SY-UCOMM
                                PO_SENDER  TYPE REF TO CL_GUI_ALV_GRID.

  CASE PO_SENDER.
    WHEN GO_ALV_GRID2.
      CASE PV_UCOMM.
        WHEN 'PAST_DATA'.
          CALL SCREEN 0110 STARTING AT 35 6.


      ENDCASE.

  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_DATA_CASE2
*&---------------------------------------------------------------------*
FORM CREATE_DATA_CASE2 .

  DATA LV_SUBRC TYPE I.
*  DATA LT_SDT020 TYPE TABLE OF ZEA_SDT020.
*  DATA LS_SDT020 TYPE ZEA_SDT020.
  DATA LV_YEAR TYPE N LENGTH 4.

  _MC_POPUP_CONFIRM '판매운영계획 작성'
'판매운영계획이 생성되었습니다. 내용을 작성하시겠습니까?' GV_ANSWER.
  CHECK GV_ANSWER = '1'.
***
***
***  CALL FUNCTION 'NUMBER_GET_NEXT' " 채번 과정
***    EXPORTING
***      NR_RANGE_NR             = '01'             " Number range number
***      OBJECT                  = 'ZEA_SAPNR'      " Name of number range object
***    IMPORTING
***      NUMBER                  = ZEA_SDT020-SAPNR  " free number
***    EXCEPTIONS
***      INTERVAL_NOT_FOUND      = 1                " Interval not found
***      NUMBER_RANGE_NOT_INTERN = 2                " Number range is not internal
***      OBJECT_NOT_FOUND        = 3                " Object not defined in TNRO
***      QUANTITY_IS_0           = 4                " Number of numbers requested must be > 0
***      QUANTITY_IS_NOT_1       = 5                " Number of numbers requested must be 1
***      INTERVAL_OVERFLOW       = 6                " Interval used up. Change not possible.
***      BUFFER_OVERFLOW         = 7                " Buffer is full
***      OTHERS                  = 8.
***  IF SY-SUBRC <> 0.
***    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
***      WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
***  ENDIF.
***
***  REPLACE FIRST OCCURRENCE OF '00' IN ZEA_SDT020-SAPNR WITH 'SP'.
***  REPLACE FIRST OCCURRENCE OF '000000' IN ZEA_SDT020-SAPNR WITH ZEA_SDT020-SP_YEAR.
***
***
***  READ TABLE LIST INTO VALUE WITH KEY KEY = GV_LIST.
***  IF SY-SUBRC = 0.
***    GV_LIST_TEXT = VALUE-TEXT.
***  ENDIF.


  CLEAR GS_DISPLAY.
  GS_DISPLAY-SP_YEAR = ZEA_SDT020-SP_YEAR.
*  GS_DISPLAY-WERKS   = ZEA_SDT020-WERKS.
  GS_DISPLAY-WERKS   = GV_LIST.
  GS_DISPLAY-PNAME1  = GV_LIST_TEXT.
  GS_DISPLAY-SAPNR   = ZEA_SDT020-SAPNR.
  GS_DISPLAY-ERNAM   = SY-UNAME.  " 생성일자를 오늘로
  GS_DISPLAY-ERDAT   = SY-DATUM.  " 생성시간을 현재 시간으로
  GS_DISPLAY-ERZET   = SY-UZEIT.  " 생성자를 현재 로그인한 사용자ID
  GS_DISPLAY-MEINS   = 'PKG'.
  GS_DISPLAY-WAERS   = 'KRW'.
  APPEND GS_DISPLAY TO GT_DISPLAY.

*-아이템 테이블 생성-------------------------------------------------*
  PERFORM CREATE_ITEM_NUMBER.

*  LEAVE TO SCREEN 0.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form PLANT_SEARCH_SELECT
*&---------------------------------------------------------------------*
FORM PLANT_SEARCH_SELECT .

*RANGES R_WERKS FOR ZEA_T001W-WERKS.
*
*  REFRESH R_WERKS[].
*  CLEAR R_WERKS.
*  R_WERKS-SIGN    = 'I'.
*  R_WERKS-OPTION  = 'EQ'.
*  R_WERKS-LOW     = ZEA_SDT020-WERKS.
*  R_WERKS-HIGH    = ''.
*  APPEND R_WERKS.
*
*  IF ZEA_SDT020-WERKS IS INITIAL.
*    REFRESH R_WERKS[].
*    CLEAR R_WERKS.
*  ENDIF.
*
*  SELECT *
*    FROM ZEA_SDT020
*    INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY
*    WHERE WERKS IN R_WERKS.

  RANGES R_WERKS FOR ZEA_T001W-WERKS.

  IF ZEA_T001W-WERKS IS INITIAL.
    " WERKS가 초기값이면 모든 데이터를 선택
    SELECT *
      FROM ZEA_SDT020 AS A LEFT JOIN ZEA_T001W AS B
      ON A~WERKS EQ B~WERKS
      INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY.
    SORT GT_DISPLAY BY SAPNR DESCENDING.
  ELSE.
    " WERKS 값이 있으면 해당 범위만 선택
    REFRESH R_WERKS[].
    CLEAR R_WERKS.
    R_WERKS-SIGN    = 'I'.
    R_WERKS-OPTION  = 'EQ'.
    R_WERKS-LOW     = ZEA_T001W-WERKS.
    APPEND R_WERKS.


*SAPNR   TYPE ZEA_SDT020-SAPNR,
*        SP_YEAR TYPE ZEA_SDT020-SP_YEAR,
*        WERKS   TYPE ZEA_SDT020-WERKS,
*        PNAME1  TYPE ZEA_T001W-PNAME1, " 플랜트명 새로 추가.
*        SAPQU   TYPE ZEA_SDT020-SAPQU,
*        MEINS   TYPE ZEA_SDT020-MEINS,
*        TOTREV  TYPE ZEA_SDT020-TOTREV,
*        WAERS   TYPE ZEA_SDT020-WAERS,
*        LOEKZ   TYPE ZEA_SDT020-LOEKZ,
*        ERNAM   TYPE ZEA_SDT020-ERNAM,
*        ERDAT   TYPE ZEA_SDT020-ERDAT,
*        ERZET   TYPE ZEA_SDT020-ERZET,
*        AENAM   TYPE ZEA_SDT020-AENAM,
*        AEDAT   TYPE ZEA_SDT020-AEDAT,
*        AEZET   TYPE ZEA_SDT020-AEZET,

    SELECT  A~SAPNR
            A~SP_YEAR
            A~WERKS
            B~PNAME1
            A~SAPQU
            A~MEINS
            A~TOTREV
            A~WAERS
            A~LOEKZ
            A~ERNAM
            A~ERDAT
            A~ERZET
            A~AENAM
            A~AEDAT
            A~AEZET

       FROM ZEA_SDT020 AS A  JOIN ZEA_T001W AS B
       ON A~WERKS EQ B~WERKS
       INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY
       WHERE A~WERKS IN R_WERKS.
    SORT GT_DISPLAY BY SAPNR DESCENDING.

    SELECT SINGLE *
      FROM ZEA_SDT020 AS A INNER JOIN ZEA_T001W AS B """
      ON A~WERKS EQ B~WERKS
      INTO CORRESPONDING FIELDS OF GS_DISPLAY
     WHERE A~WERKS EQ ZEA_T001W-WERKS.

    ZEA_T001W-PNAME1 = GS_DISPLAY-PNAME1.
  ENDIF.

  DESCRIBE TABLE GT_DISPLAY LINES GV_LINES.


  IF GT_DISPLAY IS INITIAL.
    MESSAGE S013 DISPLAY LIKE 'W'. " 해당 조건의 데이터가 존재하지 않습니다.
  ELSE.
    MESSAGE S006 WITH GV_LINES.
  ENDIF.

*--------------------------------------------------------------------*
* 플랜트 이름 출력

** SELECT SINGLE *
**   FROM ZEA_T001W AS A
**  INNER JOIN ZEA_SDT020 AS B
**     ON A~WERKS EQ B~WERKS
**   INTO CORRESPONDING FIELDS OF GS_PNAME
**  WHERE A~WERKS EQ B~WERKS.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_FIELDCAT2
*&---------------------------------------------------------------------*
FORM GET_FIELDCAT2  USING    PT_TAB  TYPE STANDARD TABLE
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



    CASE GS_FIELDCAT-FIELDNAME.
      WHEN 'SAPNR'.
        GS_FIELDCAT-KEY       = ABAP_ON.
        GS_FIELDCAT-NO_OUT  = ABAP_ON.
      WHEN 'SP_YEAR'.
        GS_FIELDCAT-KEY       = ABAP_ON.
        GS_FIELDCAT-NO_OUT  = ABAP_ON.
      WHEN 'POSNR'.
        GS_FIELDCAT-KEY       = ABAP_ON.
      WHEN 'WERKS'.
        GS_FIELDCAT-KEY       = ABAP_ON.
        GS_FIELDCAT-NO_OUT  = ABAP_ON.
      WHEN 'PNAME1'.
        GS_FIELDCAT-OUTPUTLEN = 12.
        GS_FIELDCAT-NO_OUT  = ABAP_ON.
      WHEN 'MATNR'.
        GS_FIELDCAT-KEY       = ABAP_ON.
        GS_FIELDCAT-OUTPUTLEN = 8.
      WHEN 'MAKTX'.
        GS_FIELDCAT-OUTPUTLEN = 26.
        GS_FIELDCAT-EMPHASIZE  = 'C500'.
        GS_FIELDCAT-JUST      = 'C'.
      WHEN 'SAPQU'.
        GS_FIELDCAT-QFIELDNAME    = 'MEINS'.
        GS_FIELDCAT-OUTPUTLEN = 9.
        GS_FIELDCAT-COLTEXT = '총 계획 수량'.
        GS_FIELDCAT-EMPHASIZE  = 'C311'.
      WHEN 'MEINS'.
      WHEN 'NETPR'.
        GS_FIELDCAT-CFIELDNAME    = 'WAERS'.
        GS_FIELDCAT-OUTPUTLEN = 8.
      WHEN 'WAERS'.
        GS_FIELDCAT-OUTPUTLEN = 6.
      WHEN 'SPQTY1'.
        GS_FIELDCAT-QFIELDNAME    = 'MEINS'.
        GS_FIELDCAT-EDIT      = ABAP_ON.
        GS_FIELDCAT-OUTPUTLEN = 8.
        GS_FIELDCAT-COLTEXT = '1월 계획수량'.
      WHEN 'SPQTY2'.
        GS_FIELDCAT-QFIELDNAME    = 'MEINS'.
        GS_FIELDCAT-EDIT      = ABAP_ON.
        GS_FIELDCAT-OUTPUTLEN = 8.
        GS_FIELDCAT-COLTEXT = '2월 계획수량'.
      WHEN 'SPQTY3'.
        GS_FIELDCAT-QFIELDNAME    = 'MEINS'.
        GS_FIELDCAT-EDIT      = ABAP_ON.
        GS_FIELDCAT-OUTPUTLEN = 8.
        GS_FIELDCAT-COLTEXT = '3월 계획수량'.
      WHEN 'SPQTY4'.
        GS_FIELDCAT-QFIELDNAME    = 'MEINS'.
        GS_FIELDCAT-EDIT      = ABAP_ON.
        GS_FIELDCAT-OUTPUTLEN = 8.
        GS_FIELDCAT-COLTEXT = '4월 계획수량'.
      WHEN 'SPQTY5'.
        GS_FIELDCAT-QFIELDNAME    = 'MEINS'.
        GS_FIELDCAT-EDIT      = ABAP_ON.
        GS_FIELDCAT-OUTPUTLEN = 8.
        GS_FIELDCAT-COLTEXT = '5월 계획수량'.
      WHEN 'SPQTY6'.
        GS_FIELDCAT-QFIELDNAME    = 'MEINS'.
        GS_FIELDCAT-EDIT      = ABAP_ON.
        GS_FIELDCAT-OUTPUTLEN = 8.
        GS_FIELDCAT-COLTEXT = '6월 계획수량'.
      WHEN 'SPQTY7'.
        GS_FIELDCAT-QFIELDNAME    = 'MEINS'.
        GS_FIELDCAT-EDIT      = ABAP_ON.
        GS_FIELDCAT-OUTPUTLEN = 8.
        GS_FIELDCAT-COLTEXT = '7월 계획수량'.
      WHEN 'SPQTY8'.
        GS_FIELDCAT-QFIELDNAME    = 'MEINS'.
        GS_FIELDCAT-EDIT      = ABAP_ON.
        GS_FIELDCAT-OUTPUTLEN = 8.
        GS_FIELDCAT-COLTEXT = '8월 계획수량'.
      WHEN 'SPQTY9'.
        GS_FIELDCAT-QFIELDNAME    = 'MEINS'.
        GS_FIELDCAT-EDIT      = ABAP_ON.
        GS_FIELDCAT-OUTPUTLEN = 8.
        GS_FIELDCAT-COLTEXT = '9월 계획수량'.
      WHEN 'SPQTY10'.
        GS_FIELDCAT-QFIELDNAME    = 'MEINS'.
        GS_FIELDCAT-EDIT      = ABAP_ON.
        GS_FIELDCAT-OUTPUTLEN = 9.
        GS_FIELDCAT-COLTEXT = '10월 계획수량'.
      WHEN 'SPQTY11'.
        GS_FIELDCAT-QFIELDNAME    = 'MEINS'.
        GS_FIELDCAT-EDIT      = ABAP_ON.
        GS_FIELDCAT-OUTPUTLEN = 9.
        GS_FIELDCAT-COLTEXT = '11월 계획수량'.
      WHEN 'SPQTY12'.
        GS_FIELDCAT-QFIELDNAME    = 'MEINS'.
        GS_FIELDCAT-EDIT      = ABAP_ON.
        GS_FIELDCAT-OUTPUTLEN = 9.
        GS_FIELDCAT-COLTEXT = '12월 판매수량'.
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
      WHEN OTHERS.
        GS_FIELDCAT-NO_OUT  = ABAP_ON.

    ENDCASE.


    CASE ABAP_ON.
      WHEN GS_FIELDCAT-KEY.
        GS_FIELDCAT-EDIT = ABAP_OFF.  " 키필드는 수정 불가능
      WHEN OTHERS.
*        GS_FIELDCAT-EDIT = ABAP_ON.   " 이외 필드 수정 가능
    ENDCASE.

    MODIFY GT_FIELDCAT FROM GS_FIELDCAT.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_ITEM_NUMBER
*&---------------------------------------------------------------------*
FORM CREATE_ITEM_NUMBER.

  DATA LV_SUBRC TYPE I.
*  DATA LV_SBELNR TYPE ZEA_SDT060-SBELNR.
*  DATA LT_SDT020 TYPE TABLE OF ZEA_SDT020.
*  DATA LS_SDT020 TYPE ZEA_SDT020.
*
*  DATA LT_SDT030 TYPE TABLE OF ZEA_SDT030.
*  DATA LS_SDT030 TYPE ZEA_SDT030.


*--- 아이템 테이블에 저장

*--------------------------------------------------------------------*
  DATA: LS_DISPLAY2 LIKE LINE OF GT_DATA2,
        LT_MMT010   TYPE TABLE OF ZEA_MMT010,
        LS_MMT010   LIKE LINE OF LT_MMT010,
        LT_DISPLAY2 LIKE TABLE OF GT_DATA2,

        LV_INDEX    TYPE SY-TABIX. " POSNR 설정위한 인덱스 변수 선언

*        LS_DATA2 LIKE LINE OF GT_DATA2  ,
*        LT_DATA2 TYPE TABLE OF LS_DATA2.

*** 내가 데이터로 만들고싶은 자재들을 가져옴(조인필요)
*  SELECT *
*    FROM ZEA_MMT010
*    INTO CORRESPONDING FIELDS OF TABLE LT_MMT010
*   WHERE MATTYPE EQ '완제품'.
*
*  REFRESH GT_DISPLAY2.
*
*  LOOP AT LT_MMT010 INTO LS_MMT010.
*
*    CLEAR GS_DISPLAY2.
*    MOVE-CORRESPONDING LS_MMT010 TO GS_DISPLAY2.
*    APPEND GS_DISPLAY2 TO GT_DISPLAY2.
*
*  ENDLOOP.


  SELECT *
    FROM ZEA_MMT010 AS A
    LEFT JOIN ZEA_SDT090 AS B ON A~MATNR EQ B~MATNR
    LEFT JOIN ZEA_MMT020 AS C ON A~MATNR EQ C~MATNR AND C~SPRAS EQ @SY-LANGU

*    LEFT JOIN ZEA_T001W  AS C ON B~WERKS EQ C~WERKS
    INTO CORRESPONDING FIELDS OF TABLE @GT_DATA2
   WHERE MATTYPE EQ '완제품' AND B~LOEKZ NE 'X'.


*** 드롭다운 리스트 사용
  READ TABLE LIST INTO VALUE WITH KEY KEY = GV_LIST.
  IF SY-SUBRC = 0.
    GV_LIST_TEXT = VALUE-TEXT.
  ENDIF.



  REFRESH GT_DISPLAY2.


* 2. 가장 최신 날짜의 레코드 찾기
*    루프를 사용하여 각 MATNR에 대해 가장 최신의 VALID_EN 날짜를 가진 레코드를 선택합니다.
  SORT GT_DATA2 BY MATNR VALID_EN ASCENDING.

  LOOP AT GT_DATA2 INTO GS_DATA2.

    CLEAR GS_DISPLAY2.
    ON CHANGE OF GS_DATA2-MATNR.   " 자재별 가격 1개만 뜨도록 설정
      MOVE-CORRESPONDING GS_DATA2 TO GS_DISPLAY2.

      LV_INDEX = LV_INDEX + 1.

      GS_DISPLAY2-SAPNR   = ZEA_SDT020-SAPNR.
      GS_DISPLAY2-SP_YEAR = ZEA_SDT020-SP_YEAR.
      GS_DISPLAY2-POSNR   = LV_INDEX * 10.
*    GS_DISPLAY2-WERKS   = ZEA_SDT020-WERKS.
      GS_DISPLAY2-WERKS   = GV_LIST.
      GS_DISPLAY2-PNAME1   = GV_LIST_TEXT.

      GS_DISPLAY2-MEINS = 'PKG'.
      GS_DISPLAY2-NETPR = GS_DATA2-NETPR.
      GS_DISPLAY2-WAERS = 'KRW'.
      GS_DISPLAY2-ERNAM   = SY-UNAME.
      GS_DISPLAY2-ERDAT   = SY-DATUM.
      GS_DISPLAY2-ERZET   = SY-UZEIT.
      APPEND GS_DISPLAY2 TO GT_DISPLAY2.
    ENDON.
  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form MSG_DATA_MISS
*&---------------------------------------------------------------------*
FORM MSG_DATA_MISS .


*  GT_DISPLAY의 라인수와 ZEA_SDT020의 라인수가 다르면(DB저장이 안된상황)
* 나가기 전에 '저장되지 않은 데이터는 삭제됩니다. 저장하시겠습니까?'
*  팝업과 함께 저장 OR 나가기 버튼 만들기.
  " 라인 수 계산
  DATA: LV_LINES_DISPLAY TYPE I,
        LV_LINES_DB      TYPE I,
        LV_ANSWER        TYPE C.

  DATA: IT_ZEA_SDT020 TYPE TABLE OF ZEA_SDT020.
*        IT_GT_DISPLAY TYPE TABLE OF GT_DISPLAY.

**
**  " 데이터베이스 테이블 ZEA_SDT020에서 데이터를 읽어옵니다.
**  SELECT * FROM ZEA_SDT020 INTO TABLE IT_ZEA_SDT020.
***
***  SELECT * FROM GT_DISPLAY INTO TABLE IT_GT_DISPLAY.
*--------------------------------------------------------------------*

  DATA: LT_SDT020 TYPE TABLE OF ZEA_SDT020,
        LS_SDT020 TYPE ZEA_SDT020.

*  LOOP AT GT_DISPLAY INTO GS_DISPLAY.
*    MOVE-CORRESPONDING GS_DISPLAY TO LS_SDT020.
*    INSERT ZEA_SDT020 FROM LS_SDT020.
*    MOVE-CORRESPONDING LS_SDT020 TO LT_SDT020.
*  ENDLOOP.

  MOVE-CORRESPONDING GT_DATA TO LT_SDT020.
*  MOVE-CORRESPONDING GT_DISPLAY TO LT_SDT020.




  DESCRIBE TABLE LT_SDT020 LINES LV_LINES_DISPLAY.
  DESCRIBE TABLE IT_ZEA_SDT020 LINES LV_LINES_DB.

  " 라인 수가 다르면 팝업 생성
  IF LV_LINES_DISPLAY > LV_LINES_DB.
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        TITLEBAR       = '판매운영계획 저장'
        TEXT_QUESTION  = '저장되지 않은 데이터는 삭제됩니다. 저장하시겠습니까?'
        TEXT_BUTTON_1  = '저장'
        ICON_BUTTON_1  = '@2L@'
        TEXT_BUTTON_2  = '나가기'
        ICON_BUTTON_2  = '@2O@'
        DEFAULT_BUTTON = '1'
*       DISPLAY_CANCEL = 'X'
      IMPORTING
        ANSWER         = LV_ANSWER.
    CASE LV_ANSWER.
      WHEN '1'. " 저장
*        PERFORM SAVE_DATA.
        MESSAGE S000 WITH '저장에 성공했습니다.'.
      WHEN '2'. " 나가기
        LEAVE PROGRAM.
      WHEN OTHERS.
*        LEAVE PROGRAM.
    ENDCASE.

  ELSE.
    CASE OK_CODE.
      WHEN 'CANC'.
        LEAVE PROGRAM.
      WHEN 'EXIT'.
        LEAVE PROGRAM.
      WHEN 'BACK'.
        LEAVE TO SCREEN 0.
      WHEN OTHERS.
    ENDCASE.


  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form COMFIRM_SAVE
*&---------------------------------------------------------------------*
FORM COMFIRM_SAVE .

**--- 저장 메시지 띄우기

  DATA: LV_LINES_DISPLAY TYPE I,
        LV_LINES_DB      TYPE I,
        LV_ANSWER        TYPE C.

  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      TITLEBAR       = '판매운영계획 저장'
      TEXT_QUESTION  = '저장하시겠습니까?'
      TEXT_BUTTON_1  = '저장'
      ICON_BUTTON_1  = '@2K@'
*     TEXT_BUTTON_2  = '나가기'
*     ICON_BUTTON_2  = 'ICON_EXIT'
      DEFAULT_BUTTON = '1'
*     DISPLAY_CANCEL = 'X'
    IMPORTING
      ANSWER         = LV_ANSWER.

  CASE LV_ANSWER.
    WHEN '1'. " 저장
      PERFORM SAVE_DATA.
      MESSAGE S000 WITH '저장에 성공했습니다.'.
    WHEN '2'. " 나가기
*        LEAVE PROGRAM.
    WHEN OTHERS.
*        LEAVE PROGRAM.
  ENDCASE.

  CALL METHOD GO_ALV_GRID2->SET_READY_FOR_INPUT
    EXPORTING
      I_READY_FOR_INPUT = 0.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form SAVE_DATA
*&---------------------------------------------------------------------*
FORM SAVE_DATA .

  GO_ALV_GRID2->CHECK_CHANGED_DATA( ).

  DATA: LT_SDT020 TYPE TABLE OF ZEA_SDT020,
        LS_SDT020 TYPE ZEA_SDT020,
        LT_SDT030 TYPE TABLE OF ZEA_SDT030,
        LS_SDT030 TYPE ZEA_SDT030.

  DATA: LV_SUBRC TYPE I.

  DATA: LV_SUM   TYPE I, " 총 판매수량
        LV_SUM_2 TYPE F. " 총 목표 매출

*  DATA LT_SDT020 TYPE TABLE OF ZEA_SDT020.
*  DATA LS_SDT020 TYPE ZEA_SDT020.
  DATA LV_YEAR TYPE N LENGTH 4.

*    _MC_POPUP_CONFIRM '판매운영계획 작성'
*  '판매운영계획이 생성되었습니다. 내용을 작성하시겠습니까?' GV_ANSWER.
*  CHECK GV_ANSWER = '1'.


  CALL FUNCTION 'NUMBER_GET_NEXT' " 채번 과정
    EXPORTING
      NR_RANGE_NR             = '01'             " Number range number
      OBJECT                  = 'ZEA_SAPNR'      " Name of number range object
    IMPORTING
      NUMBER                  = ZEA_SDT020-SAPNR  " free number
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

  REPLACE FIRST OCCURRENCE OF '00' IN ZEA_SDT020-SAPNR WITH 'SP'.
  REPLACE FIRST OCCURRENCE OF '000000' IN ZEA_SDT020-SAPNR WITH ZEA_SDT020-SP_YEAR.


  READ TABLE LIST INTO VALUE WITH KEY KEY = GV_LIST.
  IF SY-SUBRC = 0.
    GV_LIST_TEXT = VALUE-TEXT.
  ENDIF.









*--------------------------------------------------------------------*
  LOOP AT GT_DISPLAY2 INTO GS_DISPLAY2.
*   총 판매 수량
    GS_DISPLAY2-SAPQU   = (
    GS_DISPLAY2-SPQTY1 +
    GS_DISPLAY2-SPQTY2 +
    GS_DISPLAY2-SPQTY3 +
    GS_DISPLAY2-SPQTY4 +
    GS_DISPLAY2-SPQTY5 +
    GS_DISPLAY2-SPQTY6 +
    GS_DISPLAY2-SPQTY7 +
    GS_DISPLAY2-SPQTY8 +
    GS_DISPLAY2-SPQTY9 +
    GS_DISPLAY2-SPQTY10 +
    GS_DISPLAY2-SPQTY11 +
    GS_DISPLAY2-SPQTY12 ).
    GS_DISPLAY2-SAPNR = ZEA_SDT020-SAPNR.
    MODIFY GT_DISPLAY2 FROM GS_DISPLAY2.
    MOVE-CORRESPONDING GS_DISPLAY2 TO LS_SDT030.
    APPEND LS_SDT030 TO LT_SDT030.

    INSERT ZEA_SDT030 FROM LS_SDT030.
    IF SY-SUBRC NE 0.
      ADD SY-SUBRC TO LV_SUBRC.
      ROLLBACK WORK.
    ENDIF.
  ENDLOOP.




  LOOP AT LT_SDT030 INTO LS_SDT030.
    LV_SUM = LV_SUM + LS_SDT030-SAPQU.
    LV_SUM_2 = LV_SUM_2 + ( LS_SDT030-SAPQU * LS_SDT030-NETPR ).
*    LS_SDT030-SAPNR = ZEA_SDT020-SAPNR. """
  ENDLOOP.





  READ TABLE GT_DISPLAY INTO GS_DISPLAY WITH KEY SAPNR = ZEA_SDT020-SAPNR
*                                                 WERKS = ZEA_SDT020-WERKS.
                                                 WERKS = GV_LIST.
  GS_DISPLAY-SAPNR = ZEA_SDT020-SAPNR.
  GS_DISPLAY-SAPQU = LV_SUM.
  GS_DISPLAY-TOTREV = LV_SUM_2.
  MOVE-CORRESPONDING GS_DISPLAY TO LS_SDT020.
*  INSERT ZEA_SDT020 FROM LS_SDT020.
*  UPDATE ZEA_SDT020 FROM LS_SDT020.
  MOVE-CORRESPONDING LS_SDT020 TO ZEA_SDT020.
  INSERT ZEA_SDT020.

*    UPDATE ZEA_SDT020 SET SAPQU = LV_SUM WHERE SAPNR EQ ZEA_SDT020-SAPNR.


  REFRESH GT_DISPLAY2.
  REFRESH GT_DISPLAY.

  SELECT FROM ZEA_SDT030 AS A
         JOIN ZEA_MMT020 AS B
           ON B~MATNR EQ A~MATNR
       FIELDS *
        WHERE SAPNR EQ @ZEA_SDT020-SAPNR
*          AND WERKS EQ @ZEA_SDT020-WERKS
          AND WERKS EQ @GV_LIST
         INTO CORRESPONDING FIELDS OF TABLE @GT_DISPLAY2.


**  SELECT FROM ZEA_SDT020
**       FIELDS *
**        WHERE SAPNR EQ @ZEA_SDT020-SAPNR
***          AND WERKS EQ @ZEA_SDT020-WERKS
**          AND WERKS EQ @GV_LIST
**         INTO CORRESPONDING FIELDS OF TABLE @GT_DISPLAY.

  SELECT FROM ZEA_SDT020 AS A
         JOIN ZEA_T001W  AS B
           ON B~WERKS EQ A~WERKS
     FIELDS a~*, b~pname1
      WHERE SAPNR EQ @ZEA_SDT020-SAPNR
*          AND WERKS EQ @ZEA_SDT020-WERKS
        AND A~WERKS EQ @GV_LIST
       INTO CORRESPONDING FIELDS OF TABLE @GT_DISPLAY.

  PERFORM REFRESH_ALV_0100 .
  PERFORM REFRESH_ALV_DETAIL_0100.



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
FORM F4_HELP .

  DATA: LT_RETURN_TAB TYPE DDSHRETVAL OCCURS 0,
        LS_RETURN_TAB LIKE LINE OF LT_RETURN_TAB.

  DATA: LT_DSELC TYPE DSELC OCCURS 0,
        LS_DSELC LIKE LINE OF LT_DSELC.

  DATA: LS_VALUE  TYPE SEAHLPRES,
        LT_VALUE  TYPE TABLE OF SEAHLPRES,
        LS_FIELD  TYPE DFIES,
        LT_FIELDS TYPE TABLE OF DFIES.

  DATA : BEGIN OF LT_WERKS OCCURS 0,
           WERKS  TYPE ZEA_STKO-WERKS,
           PNAME1 TYPE ZEA_T001W-PNAME1,
         END OF LT_WERKS.

  DATA: LT_MAP TYPE TABLE OF DSELC WITH HEADER LINE.

  CLEAR : LT_WERKS, LT_WERKS[],
          LT_VALUE, LT_VALUE[],
          LT_FIELDS, LT_FIELDS[].

  SELECT WERKS, PNAME1
    INTO CORRESPONDING FIELDS OF TABLE @LT_WERKS
    FROM ZEA_T001W
*   WHERE WERKS BETWEEN '10002' AND '10009'.
   WHERE WERKS NE '10001'
     AND WERKS NE ''.


  SORT LT_WERKS BY WERKS.


*** 필드 카탈로그 부분

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      RETFIELD        = 'WERKS'           " Name of return field in FIELD_TAB
      DYNPPROG        = SY-REPID          " Current program
      DYNPNR          = SY-DYNNR          " Screen number
*     DYNPROFIELD     = 'ZEA_STKO-BOMID'
      WINDOW_TITLE    = '직영점'        " Title for the hit list
      VALUE_ORG       = 'S'               " Value return: C: cell by cell, S: structured
    TABLES
*     FIELD_TAB       = LT_FIELDS[]
      VALUE_TAB       = LT_WERKS[]                 " Table of values: entries cell by cell
      RETURN_TAB      = LT_RETURN_TAB[]
*     DYNPFLD_MAPPING = LT_MAP
    EXCEPTIONS
      PARAMETER_ERROR = 1                " Incorrect parameter
      NO_VALUES_FOUND = 2                " No values found
      OTHERS          = 3.

  IF SY-SUBRC EQ 0.
    READ TABLE LT_RETURN_TAB INTO LS_RETURN_TAB INDEX 1.
    IF SY-SUBRC EQ 0.
      ZEA_T001W-WERKS = LS_RETURN_TAB-FIELDVAL.

      READ TABLE LT_WERKS WITH KEY WERKS = ZEA_T001W-WERKS BINARY SEARCH.
      IF SY-SUBRC EQ 0.
        ZEA_T001W-WERKS      = LT_WERKS-WERKS.
        ZEA_T001W-PNAME1      = LT_WERKS-PNAME1.
        LEAVE SCREEN.
      ENDIF.
    ENDIF.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_0110
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT_0110 .

  CREATE OBJECT GO_CONTAINER3
    EXPORTING
      CONTAINER_NAME = 'CCON3' " Name of the Screen CustCtrl Name to Link Container To
    EXCEPTIONS
      OTHERS         = 1.

  IF SY-SUBRC NE 0.
    MESSAGE '컨테이너 생성에 실패했습니다.' TYPE 'E'.
  ENDIF.


  CREATE OBJECT GO_ALV_GRID3
    EXPORTING
      I_PARENT = GO_CONTAINER3.   " Parent Container

  IF SY-SUBRC <> 0.
    MESSAGE 'ALV 생성에 실패했습니다.' TYPE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FIELDCAT_0110
*&---------------------------------------------------------------------*
FORM SET_ALV_FIELDCAT_0110 .

  PERFORM GET_FIELDCAT3   USING    GT_DISPLAY3
                        CHANGING GT_FIELDCAT.
  PERFORM MAKE_FIELDCAT_0110.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_0110
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV_0110 .

  " 판매계획 아이템 테이블
  CALL METHOD GO_ALV_GRID3->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
*     I_STRUCTURE_NAME = 'ZEA_SDT010'     " Internal Output Table Structure Name
*     IS_VARIANT      = GS_VARIANT  " Layout
*     I_SAVE          = GV_SAVE     " Save Layout
      IS_LAYOUT       = GS_LAYOUT3   " Layout
    CHANGING
      IT_OUTTAB       = GT_DISPLAY3 " Output Table
      IT_FIELDCATALOG = GT_FIELDCAT        " Field Catalog
    EXCEPTIONS
      OTHERS          = 1.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_FIELDCAT_0110
*&---------------------------------------------------------------------*
FORM MAKE_FIELDCAT_0110 .

  LOOP AT GT_FIELDCAT INTO GS_FIELDCAT.



    CASE GS_FIELDCAT-FIELDNAME.
      WHEN 'SP_YEAR'.
        GS_FIELDCAT-KEY       = ABAP_ON.
        GS_FIELDCAT-NO_OUT  = ABAP_ON.
      WHEN 'WERKS'.
        GS_FIELDCAT-KEY       = ABAP_ON.
        GS_FIELDCAT-NO_OUT  = ABAP_ON.
      WHEN 'MATNR'.
        GS_FIELDCAT-KEY       = ABAP_ON.
        GS_FIELDCAT-OUTPUTLEN = 8.
      WHEN 'MAKTX'.
        GS_FIELDCAT-OUTPUTLEN = 26.
        GS_FIELDCAT-EMPHASIZE  = 'C500'.
        GS_FIELDCAT-JUST      = 'C'.
      WHEN 'SAVQU'.
        GS_FIELDCAT-QFIELDNAME    = 'MEINS'.
        GS_FIELDCAT-OUTPUTLEN = 9.
        GS_FIELDCAT-COLTEXT = '총 판매 수량'.
        GS_FIELDCAT-EMPHASIZE  = 'C311'.
      WHEN 'MEINS'.
      WHEN 'TOTSAL'.
        GS_FIELDCAT-NO_OUT  = ABAP_ON.
      WHEN 'NETPR'.
        GS_FIELDCAT-CFIELDNAME    = 'WAERS'.
        GS_FIELDCAT-OUTPUTLEN = 8.
      WHEN 'WAERS'.
*        GS_FIELDCAT-OUTPUTLEN = 6.
      WHEN 'SVQTY1'.
        GS_FIELDCAT-QFIELDNAME    = 'MEINS'.
        GS_FIELDCAT-OUTPUTLEN = 8.
        GS_FIELDCAT-COLTEXT = '1월 판매수량'.
      WHEN 'SVQTY2'.
        GS_FIELDCAT-QFIELDNAME    = 'MEINS'.
        GS_FIELDCAT-OUTPUTLEN = 8.
        GS_FIELDCAT-COLTEXT = '2월 판매수량'.
      WHEN 'SVQTY3'.
        GS_FIELDCAT-QFIELDNAME    = 'MEINS'.
        GS_FIELDCAT-OUTPUTLEN = 8.
        GS_FIELDCAT-COLTEXT = '3월 판매수량'.
      WHEN 'SVQTY4'.
        GS_FIELDCAT-QFIELDNAME    = 'MEINS'.
        GS_FIELDCAT-OUTPUTLEN = 8.
        GS_FIELDCAT-COLTEXT = '4월 판매수량'.
      WHEN 'SVQTY5'.
        GS_FIELDCAT-QFIELDNAME    = 'MEINS'.
        GS_FIELDCAT-OUTPUTLEN = 8.
        GS_FIELDCAT-COLTEXT = '5월 판매수량'.
      WHEN 'SVQTY6'.
        GS_FIELDCAT-QFIELDNAME    = 'MEINS'.
        GS_FIELDCAT-OUTPUTLEN = 8.
        GS_FIELDCAT-COLTEXT = '6월 판매수량'.
      WHEN 'SVQTY7'.
        GS_FIELDCAT-QFIELDNAME    = 'MEINS'.
        GS_FIELDCAT-OUTPUTLEN = 8.
        GS_FIELDCAT-COLTEXT = '7월 판매수량'.
      WHEN 'SVQTY8'.
        GS_FIELDCAT-QFIELDNAME    = 'MEINS'.
        GS_FIELDCAT-OUTPUTLEN = 8.
        GS_FIELDCAT-COLTEXT = '8월 판매수량'.
      WHEN 'SVQTY9'.
        GS_FIELDCAT-QFIELDNAME    = 'MEINS'.
        GS_FIELDCAT-OUTPUTLEN = 8.
        GS_FIELDCAT-COLTEXT = '9월 판매수량'.
      WHEN 'SVQTY10'.
        GS_FIELDCAT-QFIELDNAME    = 'MEINS'.
        GS_FIELDCAT-OUTPUTLEN = 9.
        GS_FIELDCAT-COLTEXT = '10월 판매수량'.
      WHEN 'SVQTY11'.
        GS_FIELDCAT-QFIELDNAME    = 'MEINS'.
        GS_FIELDCAT-OUTPUTLEN = 9.
        GS_FIELDCAT-COLTEXT = '11월 판매수량'.
      WHEN 'SVQTY12'.
        GS_FIELDCAT-QFIELDNAME    = 'MEINS'.
        GS_FIELDCAT-OUTPUTLEN = 9.
        GS_FIELDCAT-COLTEXT = '12월 판매수량'.
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
      WHEN OTHERS.
        GS_FIELDCAT-NO_OUT  = ABAP_ON.

    ENDCASE.

    MODIFY GT_FIELDCAT FROM GS_FIELDCAT.

  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_FIELDCAT3
*&---------------------------------------------------------------------*
FORM GET_FIELDCAT3  USING    PT_TAB  TYPE STANDARD TABLE
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
*& Form GET_PAST_DATA
*&---------------------------------------------------------------------*
FORM GET_PAST_DATA .

  DATA LV_INDEX    TYPE SY-TABIX. " POSNR 설정위한 인덱스 변수 선언
  " 이전년도 데이터를 가져오기
***      REFRESH GT_DISPLAY.
***
***      SELECT *
****        SPQTY1 SPQTY2 SPQTY3 SPQTY4 SPQTY5 SPQTY6 SPQTY7 SPQTY8
****        SPQTY9 SPQTY10 SPQTY11 SPQTY12
***      FROM ZEA_SDT030 AS A LEFT JOIN ZEA_MMT020 AS B ON A~MATNR EQ B~MATNR
***                                                    AND B~SPRAS EQ SY-LANGU
***      INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY2
***              WHERE SP_YEAR EQ 2023 AND WERKS EQ ZEA_SDT020-WERKS.
***
***
***      LOOP AT GT_DISPLAY2 INTO GS_DISPLAY2.
***        GS_DISPLAY2-SAPNR = ZEA_SDT020-SAPNR.
***        GS_DISPLAY2-SP_YEAR = ZEA_SDT020-SP_YEAR.
***        GS_DISPLAY2-WERKS = ZEA_SDT020-WERKS.
***        MODIFY TABLE GT_DISPLAY2 FROM GS_DISPLAY2.
***      ENDLOOP.

  REFRESH GT_DISPLAY2.

*      SELECT *
**        SV_YEAR AS SP_YEAR
**        WERKS
**        A~MATNR
**        MAKTX
**        SAVQU AS SAPQU
**        MEINS
**       SVQTY1  AS SPQTY1
**       SVQTY2  AS SPQTY2
**       SVQTY3  AS SPQTY3
**       SVQTY4  AS SPQTY4
**       SVQTY5  AS SPQTY5
**       SVQTY6  AS SPQTY6
**       SVQTY7  AS SPQTY7
**       SVQTY8  AS SPQTY8
**       SVQTY9  AS SPQTY9
**       SVQTY10 AS SPQTY10
**       SVQTY11 AS SPQTY11
**       SVQTY12 AS SPQTY12
*
*        FROM ZEA_SDT030 AS A LEFT JOIN ZEA_MMT020 AS B ON A~MATNR EQ B~MATNR
*                                                      AND B~SPRAS EQ SY-LANGU
*        INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY2
*       WHERE SP_YEAR EQ 2023 AND WERKS EQ ZEA_SDT030-WERKS.
*      SORT GT_DISPLAY2 BY MATNR.
*

*** 이게 오리지날
**      SELECT *
**      FROM ZEA_SDT030 AS A
**       JOIN ZEA_SDT020 AS B ON A~SP_YEAR EQ B~SP_YEAR
**                           AND A~SAPNR EQ B~SAPNR
**      INTO CORRESPONDING FIELDS OF TABLE @GT_DISPLAY2
**              WHERE A~SP_YEAR EQ 2023 AND A~WERKS EQ @GV_LIST.
**      SORT GT_DISPLAY2 BY MATNR.

** 1. 전년도 판매데이터 불러오기
*  SELECT
*   SV_YEAR AS SP_YEAR,
*   A~WERKS,
*   A~MATNR,
*   MAKTX,
*   SAVQU AS SAPQU,
*   MEINS,
*   C~NETPR,
*   C~WAERS,
*   C~VALID_EN,
*   SVQTY1  AS SPQTY1,
*   SVQTY2  AS SPQTY2,
*   SVQTY3  AS SPQTY3,
*   SVQTY4  AS SPQTY4,
*   SVQTY5  AS SPQTY5,
*   SVQTY6  AS SPQTY6,
*   SVQTY7  AS SPQTY7,
*   SVQTY8  AS SPQTY8,
*   SVQTY9  AS SPQTY9,
*   SVQTY10 AS SPQTY10,
*   SVQTY11 AS SPQTY11,
*   SVQTY12 AS SPQTY12
*  FROM ZEA_SDT010 AS A
*  LEFT JOIN ZEA_MMT020 AS B ON A~MATNR EQ B~MATNR AND B~SPRAS EQ @SY-LANGU
*  LEFT JOIN ZEA_SDT090 AS C ON A~MATNR EQ C~MATNR
*  INTO CORRESPONDING FIELDS OF TABLE @GT_DATA2
*  WHERE SV_YEAR EQ 2023 AND A~WERKS EQ @GV_LIST AND C~LOEKZ NE 'X'.
*
*  SORT GT_DATA2 BY MATNR.


* 1. 전년도 판매데이터 불러오기
  SELECT
   SV_YEAR AS SP_YEAR,
   B~WERKS,
   B~MATNR,
   MAKTX,
   SAVQU AS SAPQU,
   MEINS,
   D~NETPR,
   D~WAERS,
   D~VALID_EN,
   SVQTY1  AS SPQTY1,
   SVQTY2  AS SPQTY2,
   SVQTY3  AS SPQTY3,
   SVQTY4  AS SPQTY4,
   SVQTY5  AS SPQTY5,
   SVQTY6  AS SPQTY6,
   SVQTY7  AS SPQTY7,
   SVQTY8  AS SPQTY8,
   SVQTY9  AS SPQTY9,
   SVQTY10 AS SPQTY10,
   SVQTY11 AS SPQTY11,
   SVQTY12 AS SPQTY12
  FROM ZEA_MMT010 AS A
  LEFT JOIN ZEA_SDT010 AS B ON A~MATNR EQ B~MATNR
  LEFT JOIN ZEA_MMT020 AS C ON A~MATNR EQ C~MATNR AND C~SPRAS EQ @SY-LANGU
  LEFT JOIN ZEA_SDT090 AS D ON A~MATNR EQ D~MATNR
*  RIGHT JOIN ZEA_MMT010 AS D ON A~MATNR EQ D~MATNR
  INTO CORRESPONDING FIELDS OF TABLE @GT_DATA2
  WHERE SV_YEAR EQ 2023
    AND B~WERKS EQ @GV_LIST
    AND D~LOEKZ NE 'X'
    AND A~MATTYPE EQ '완제품'.

  SORT GT_DATA2 BY MATNR.




* 2. 가장 최신 날짜의 레코드 찾고 데이터 변경해주기
  SORT GT_DATA2 BY MATNR VALID_EN ASCENDING.

  LOOP AT GT_DATA2 INTO GS_DATA2.

    CLEAR GS_DISPLAY2.
    ON CHANGE OF GS_DATA2-MATNR.   " 자재별 가격 1개만 뜨도록 설정
      MOVE-CORRESPONDING GS_DATA2 TO GS_DISPLAY2.

      LV_INDEX = LV_INDEX + 1.

      GS_DISPLAY2-SAPNR   = ZEA_SDT020-SAPNR.
      GS_DISPLAY2-SP_YEAR = ZEA_SDT020-SP_YEAR.
      GS_DISPLAY2-POSNR   = LV_INDEX * 10.
*      GS_DISPLAY2-WERKS   = ZEA_SDT020-WERKS.
*      GS_DISPLAY2-WERKS   = GV_LIST.
      GS_DISPLAY2-PNAME1   = GV_LIST_TEXT.
*
*      GS_DISPLAY2-MEINS = 'PKG'.
*      GS_DISPLAY2-NETPR = GS_DATA2-NETPR.
*      GS_DISPLAY2-WAERS = 'KRW'.
      GS_DISPLAY2-ERNAM   = SY-UNAME.
      GS_DISPLAY2-ERDAT   = SY-DATUM.
      GS_DISPLAY2-ERZET   = SY-UZEIT.
      APPEND GS_DISPLAY2 TO GT_DISPLAY2.
    ENDON.
  ENDLOOP.





  PERFORM REFRESH_ALV_DETAIL_0100.
  LEAVE TO SCREEN 0.



ENDFORM.
