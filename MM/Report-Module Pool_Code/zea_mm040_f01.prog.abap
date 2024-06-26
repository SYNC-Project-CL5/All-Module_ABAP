*&---------------------------------------------------------------------*
*& Include          ZEA_MM040_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form REFRESH_RTN
*&---------------------------------------------------------------------*
FORM REFRESH_RTN .

  REFRESH GT_MMT030.

  SELECT *
    FROM ZEA_MMT030
    WHERE MATNR IN @SO_MATNR
    AND   WERKS IN @SO_WERKS
    INTO CORRESPONDING FIELDS OF TABLE @GT_MMT030.
  SORT GT_MMT030 BY MATNR WERKS ASCENDING.

  IF GT_MMT030[] IS NOT INITIAL.
    SELECT MATNR,
           MAKTX
      INTO CORRESPONDING FIELDS OF TABLE @GT_MMT020
      FROM ZEA_MMT020
           FOR ALL ENTRIES IN @GT_MMT030
      WHERE MATNR EQ @GT_MMT030-MATNR
      AND   SPRAS EQ @SY-LANGU."시스템 변수(로그온 언어)
    SORT GT_MMT020 BY MATNR.

    SELECT WERKS,
           PNAME1
      INTO CORRESPONDING FIELDS OF TABLE @GT_T001W
      FROM ZEA_T001W
           FOR ALL ENTRIES IN @GT_MMT030
      WHERE WERKS EQ @GT_MMT030-WERKS.
    SORT GT_T001W BY WERKS.
  ENDIF.

  LOOP AT GT_MMT030.

     DATA(LV_TABIX) = SY-TABIX.

    " 자재명 가져오기
     READ TABLE GT_MMT020 INTO GS_MMT020
     WITH KEY MATNR = GT_MMT030-MATNR BINARY SEARCH.
     IF SY-SUBRC EQ 0.
       GT_MMT030-MAKTX = GS_MMT020-MAKTX.
     ENDIF.

    " 플랜트명 가져오기
     READ TABLE GT_T001W INTO GS_T001W
     WITH KEY WERKS = GT_MMT030-WERKS BINARY SEARCH.
     IF SY-SUBRC EQ 0."참, 거짓
       GT_MMT030-PNAME1 = GS_T001W-PNAME1.
     ENDIF.

     IF GT_MMT030-USEYN EQ 'X'.
       GT_MMT030-ICON = '@11@'.
     ELSE.
       GT_MMT030-ICON = '@5B@'.
     ENDIF.

     MODIFY GT_MMT030 INDEX LV_TABIX.

  ENDLOOP.


  IF OK_CODE NE 'DISPLAY'.
   "Message
    DATA(LV_CNT) = LINES( GT_MMT030 ).
    MESSAGE '조회건수: ' && LV_CNT && '건' TYPE 'S'.
  ELSE.
    MESSAGE '조회모드 변경 완료' TYPE 'S'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DISPLAY_DATA .

  GV_MODE = 'D'.
  CALL SCREEN 0100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT_0100 .

  CREATE OBJECT GO_CONTAINER
    EXPORTING
      CONTAINER_NAME              = 'CCON'
    EXCEPTIONS
      OTHERS                      = 1.
  IF SY-SUBRC NE 0.
    MESSAGE '컨테이너 생성에 실패했습니다.' TYPE 'E'.
  ENDIF.

  CREATE OBJECT GO_ALV_GRID
    EXPORTING
      I_PARENT                = GO_CONTAINER
    EXCEPTIONS
      OTHERS                  = 1.
  IF SY-SUBRC NE 0.
    MESSAGE 'ALV 생성에 실패했습니다.' TYPE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_LAYOUT_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_ALV_LAYOUT_0100 .

  CLEAR GS_LAYOUT.

  GS_LAYOUT-SEL_MODE   = 'D'.
  GS_LAYOUT-NO_TOOLBAR = ''.
  GS_LAYOUT-NO_ROWINS  = 'X'.
  GS_LAYOUT-NO_ROWMOVE = 'X'.
***  GS_LAYOUT-CWIDTH_OPT = 'X'."열 너비 최적화

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV_0100 .

  CLEAR GS_VARIANT.
  GS_VARIANT-REPORT = SY-REPID.
  GV_SAVE = 'A'.

  CALL METHOD GO_ALV_GRID->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
      IS_VARIANT      = GS_VARIANT                 " Layout
      I_SAVE          = GV_SAVE                 " Save Layout
      IS_LAYOUT       = GS_LAYOUT                " Layout
    CHANGING
      IT_FIELDCATALOG = GT_FIELDCAT
      IT_OUTTAB       = GT_MMT030[]              " Output Table
    EXCEPTIONS
      OTHERS          = 1.

  IF SY-SUBRC NE 0.
    MESSAGE 'ALV 에 데이터를 설정하는 과정 중 오류가 발생하였습니다.' TYPE 'E'.
  ENDIF.

  CALL METHOD GO_ALV_GRID->SET_READY_FOR_INPUT
  EXPORTING I_READY_FOR_INPUT = 0.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form TOGGLE_RTN
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM TOGGLE_RTN .

  DATA(LV_RESULT) = GO_ALV_GRID->IS_READY_FOR_INPUT( ).

  CASE LV_RESULT.
*   ---------------------------------------------
    WHEN 0.   " 조회모드인 경우 수정모드로 변경
*   ---------------------------------------------
      CALL METHOD GO_ALV_GRID->SET_READY_FOR_INPUT
      EXPORTING I_READY_FOR_INPUT = 1.

*   ---------------------------------------------
    WHEN 1.   " 수정모드인 경우 조회모드로 변경
*   ---------------------------------------------

      " 변경 데이터가 있을 경우
      READ TABLE GT_MMT030 WITH KEY ICON = '@5D@' TRANSPORTING NO FIELDS.
      IF SY-SUBRC EQ 0.
        LV_ANSWER = 'X'.
      ENDIF.

      " 오류 데이터가 있을 경우
      READ TABLE GT_MMT030 WITH KEY ICON = '@5C@' TRANSPORTING NO FIELDS.
      IF SY-SUBRC EQ 0.
        LV_ANSWER = 'X'.
      ENDIF.

     "신규 데이터가 있을 경우
      READ TABLE GT_MMT030 WITH KEY ICON = SPACE  TRANSPORTING NO FIELDS.
      IF SY-SUBRC EQ 0.
        LV_ANSWER = 'X'.
      ENDIF.

     "팝업
      IF LV_ANSWER EQ 'X'.
        CLEAR: LV_ANSWER.
        CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
           EXPORTING
             DEFAULTOPTION  = 'N'
             TEXTLINE1      = '저장되지 않은 데이터는 삭제됩니다.'
             TEXTLINE2      = '조회모드로 변경하시겠습니까?'
             TITEL          = 'Cancel'
             CANCEL_DISPLAY = ' '
           IMPORTING
             ANSWER         = LV_ANSWER.
        IF LV_ANSWER NE 'J'.
          MESSAGE '취소되었습니다.' TYPE 'S'.
          EXIT.
        ENDIF.
      ENDIF.

      CALL METHOD GO_ALV_GRID->SET_READY_FOR_INPUT
      EXPORTING I_READY_FOR_INPUT = 0.
      PERFORM REFRESH_RTN.

*   ---------------------------------------------
    WHEN OTHERS.
*   ---------------------------------------------
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DELETE_RTN
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DELETE_RTN .

  DATA : LT_ROWS TYPE LVC_T_ROW.
  DATA : LS_ROWS TYPE LVC_S_ROW.

  CALL METHOD GO_ALV_GRID->GET_SELECTED_ROWS
  IMPORTING ET_INDEX_ROWS = LT_ROWS.

  IF LT_ROWS[] IS INITIAL.
    MESSAGE '삭제할 항목을 선택하세요.' TYPE 'I' DISPLAY LIKE 'E'.
    EXIT.
  ENDIF.

  DATA : LV_ANSWER TYPE C.

  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      TITLEBAR              = '삭제 팝업'
      TEXT_QUESTION         = '데이터를 삭제하시겠습니까?'
      TEXT_BUTTON_1         = 'Yes'
      TEXT_BUTTON_2         = 'No'
      DISPLAY_CANCEL_BUTTON = 'X'
      START_COLUMN          = 25
      START_ROW             = 6
    IMPORTING
      ANSWER                = LV_ANSWER
    EXCEPTIONS
      TEXT_NOT_FOUND        = 1
    OTHERS                = 2.
  IF LV_ANSWER NE '1'.
    MESSAGE '취소되었습니다.' TYPE 'S'.
    EXIT.
  ENDIF.

  SORT LT_ROWS BY INDEX DESCENDING.

  DATA : LV_CNT TYPE I.

  LOOP AT LT_ROWS INTO LS_ROWS.

    READ TABLE GT_MMT030 INDEX LS_ROWS-INDEX.
    CHECK SY-SUBRC EQ 0.
    ADD 1 TO LV_CNT.
    DATA(LV_TABIX) = SY-TABIX.

   "기존에 저장되어 있던 데이터는 'X'표시
    IF GT_MMT030-ICON  IS NOT INITIAL.
      GT_MMT030-ICON  = '@5D@'.
      GT_MMT030-USEYN = 'X'.

   "신규 Insert 데이터이고, 변경하지않은 ROW는 ALV에서 삭제
    ELSE.
      DELETE GT_MMT030 INDEX LV_TABIX.
    ENDIF.

   "테이블에 저장되지 않은 신규 Insert 데이터는 ALV에서 삭제
    IF GT_MMT030-ERNAM IS INITIAL.
      DELETE GT_MMT030 INDEX LV_TABIX.
    ENDIF.

    MODIFY GT_MMT030 INDEX LV_TABIX.

  ENDLOOP.

  MESSAGE '삭제되었습니다.' && '(' && LV_CNT && '건' && ')'  TYPE 'S'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SAVE_RTN
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SAVE_RTN .

  DATA: LV_VALID TYPE C.
  GO_ALV_GRID->CHECK_CHANGED_DATA( IMPORTING E_VALID = LV_VALID ).
  CHECK LV_VALID EQ 'X'.

  DATA : LT_ROWS TYPE LVC_T_ROW.
  DATA : LS_ROWS TYPE LVC_S_ROW.

 "ALV Grid 선택된 ROW Check
  CALL METHOD GO_ALV_GRID->GET_SELECTED_ROWS
  IMPORTING ET_INDEX_ROWS = LT_ROWS.
  IF LT_ROWS[] IS INITIAL.
     MESSAGE '저장할 항목을 선택하세요.' TYPE 'I' DISPLAY LIKE 'E'.
     EXIT.
  ENDIF.

  DATA : LV_ANSWER TYPE C.

  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
     TITLEBAR              = '저장 팝업'
     TEXT_QUESTION         = '저장하시겠습니까?'
     TEXT_BUTTON_1         = 'Yes'
     TEXT_BUTTON_2         = 'No'
     DISPLAY_CANCEL_BUTTON = 'X'
     START_COLUMN          = 25
     START_ROW             = 6
   IMPORTING
     ANSWER                = LV_ANSWER
   EXCEPTIONS
     TEXT_NOT_FOUND        = 1
     OTHERS                = 2.
  IF LV_ANSWER NE '1'.
    MESSAGE '취소되었습니다.' TYPE 'S'.
    EXIT.
  ENDIF.

  LOOP AT LT_ROWS INTO LS_ROWS.

  "선택된 INDEX로 ALV GRID의 INDEX를 읽는다.
    READ TABLE GT_MMT030 INDEX LS_ROWS-INDEX.
    CHECK SY-SUBRC EQ 0.

  "ALV GRID 데이터 확인
    IF GT_MMT030-ICON NE '@5D@'.
       MESSAGE '변경하지 않은 데이터는 저장이 불가합니다.' TYPE 'I' DISPLAY LIKE 'E'.
       EXIT.
    ENDIF.

  ENDLOOP.

  CHECK SY-MSGTY NE 'E'.

  DATA : LV_CNT   TYPE I.
  DATA : LV_TABIX TYPE SY-TABIX."시스템 변수

  LOOP AT LT_ROWS INTO LS_ROWS.

    READ TABLE GT_MMT030 INDEX LS_ROWS-INDEX.
    CHECK SY-SUBRC EQ 0.
    LV_TABIX = SY-TABIX.
    ADD 1 TO LV_CNT.

    IF GT_MMT030-ERDAT IS INITIAL."신규
       GT_MMT030-ERNAM = GT_MMT030-AENAM = SY-UNAME.
       GT_MMT030-ERDAT = GT_MMT030-AEDAT = SY-DATUM.
       GT_MMT030-ERZET = GT_MMT030-AEZET = SY-UZEIT.

    ELSE."변경
      GT_MMT030-AENAM = SY-UNAME.
      GT_MMT030-AEDAT = SY-DATUM.
      GT_MMT030-AEZET = SY-UZEIT.
    ENDIF.

   "테이블 데이터 업데이트
    MOVE-CORRESPONDING GT_MMT030 TO ZEA_MMT030.
    MODIFY ZEA_MMT030.

    IF GT_MMT030-USEYN EQ 'X'."삭제
      GT_MMT030-ICON = '@11@'.
    ELSE."정상
      GT_MMT030-ICON = '@5B@'.
    ENDIF.
    MODIFY GT_MMT030 INDEX LV_TABIX.

  ENDLOOP.

  MESSAGE '저장되었습니다' && '(' && LV_CNT && '건)' TYPE 'S'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_DATA_CHANGED
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ER_DATA_CHANGED
*&      --> E_ONF4
*&      --> E_ONF4_BEFORE
*&      --> E_ONF4_AFTER
*&      --> E_UCOMM
*&---------------------------------------------------------------------*
FORM HANDLE_DATA_CHANGED USING PR_DATA_CHANGED TYPE REF TO
                                               CL_ALV_CHANGED_DATA_PROTOCOL
                               PV_ONF4         TYPE  CHAR01
                               PV_ONF4_BEFORE  TYPE  CHAR01
                               PV_ONF4_AFTER   TYPE  CHAR01
                               P_E_UCOMM       TYPE  SY-UCOMM.

    DATA : LT_MOD  TYPE LVC_T_MODI.

    CLEAR: LT_MOD[].
    LT_MOD[] = PR_DATA_CHANGED->MT_MOD_CELLS.

    LOOP  AT  LT_MOD  INTO  DATA(LS_MOD).

          CLEAR: GT_MMT030.
          READ TABLE GT_MMT030 INDEX LS_MOD-ROW_ID.
          CHECK SY-SUBRC EQ 0.
          DATA(LV_TABIX) = SY-TABIX.

         "데이터 변경 시 노란색 아이콘 표시
          CALL METHOD PR_DATA_CHANGED->MODIFY_CELL
          EXPORTING I_ROW_ID    = LV_TABIX
                    I_FIELDNAME = 'ICON'
                    I_VALUE     = '@5D@'.

         " 자재코드 입력 시 자재명 가져오기.
        CASE LS_MOD-FIELDNAME.
          WHEN 'MATNR'.
            SELECT SINGLE MAKTX
              INTO @DATA(LV_MAKTX)
              FROM ZEA_MMT020
              WHERE MATNR EQ @LS_MOD-VALUE
              AND   SPRAS EQ @SY-LANGU.
            IF SY-SUBRC EQ 0.
              CALL METHOD PR_DATA_CHANGED->MODIFY_CELL
              EXPORTING I_ROW_ID    = LV_TABIX
                        I_FIELDNAME = 'MAKTX'
                        I_VALUE     = LV_MAKTX.
            ELSE.
              MESSAGE '자재코드를 확인하세요.' TYPE 'I' DISPLAY LIKE 'E'.
              CALL METHOD PR_DATA_CHANGED->MODIFY_CELL
              EXPORTING I_ROW_ID    = LV_TABIX
                        I_FIELDNAME = 'MATNR'
                        I_VALUE     = SPACE.
              CALL METHOD PR_DATA_CHANGED->MODIFY_CELL
              EXPORTING I_ROW_ID    = LV_TABIX
                        I_FIELDNAME = 'MAKTX'
                        I_VALUE     = SPACE.
            ENDIF.


          WHEN 'WERKS'.
            SELECT SINGLE PNAME1
              INTO @DATA(LV_PNAME1)
              FROM ZEA_T001W
              WHERE WERKS EQ @LS_MOD-VALUE.
            IF SY-SUBRC EQ 0.
              CALL METHOD PR_DATA_CHANGED->MODIFY_CELL
              EXPORTING I_ROW_ID    = LV_TABIX
                        I_FIELDNAME = 'PNAME1'
                        I_VALUE     = LV_PNAME1.
            ELSE.
              MESSAGE '플랜트를 확인하세요.' TYPE 'I' DISPLAY LIKE 'E'.
              CALL METHOD PR_DATA_CHANGED->MODIFY_CELL
              EXPORTING I_ROW_ID    = LV_TABIX
                        I_FIELDNAME = 'WERKS'
                        I_VALUE     = SPACE.
              CALL METHOD PR_DATA_CHANGED->MODIFY_CELL
              EXPORTING I_ROW_ID    = LV_TABIX
                        I_FIELDNAME = 'PNAME1'
                        I_VALUE     = SPACE.
            ENDIF.


        ENDCASE.
     ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form INSERT_RTN
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM INSERT_RTN .

  APPEND INITIAL LINE TO GT_MMT030.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_FIELDCATALOG_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_FIELDCATALOG_0100 .

  DATA : LS_FCAT TYPE LVC_S_FCAT.

  CLEAR: LS_FCAT.
  LS_FCAT-COL_POS   = 1.
  LS_FCAT-FIELDNAME = 'ICON'.
  LS_FCAT-COLTEXT   = '상태'.
  LS_FCAT-EDIT      = ''.
  LS_FCAT-JUST      = 'C'.
  LS_FCAT-OUTPUTLEN = 5.
  APPEND LS_FCAT TO GT_FIELDCAT.

  CLEAR: LS_FCAT.
  LS_FCAT-COL_POS   = 2.
  LS_FCAT-FIELDNAME = 'MATNR'.
  LS_FCAT-COLTEXT   = '자재코드'.
  LS_FCAT-JUST      = 'C'.
  LS_FCAT-KEY       = 'X'.
  LS_FCAT-EDIT      = 'X'.
  APPEND LS_FCAT TO GT_FIELDCAT.

  CLEAR: LS_FCAT.
  LS_FCAT-COL_POS   = 3.
  LS_FCAT-FIELDNAME = 'MAKTX'.
  LS_FCAT-COLTEXT   = '자재명'.
  APPEND LS_FCAT TO GT_FIELDCAT.

  CLEAR: LS_FCAT.
  LS_FCAT-COL_POS   = 4.
  LS_FCAT-FIELDNAME = 'WERKS'.
  LS_FCAT-COLTEXT   = '플랜트'.
  LS_FCAT-JUST      = 'C'.
  LS_FCAT-KEY       = 'X'.
  LS_FCAT-EDIT      = 'X'.
  APPEND LS_FCAT TO GT_FIELDCAT.

  CLEAR: LS_FCAT.
  LS_FCAT-COL_POS   = 5.
  LS_FCAT-FIELDNAME = 'PNAME1'.
  LS_FCAT-COLTEXT   = '플랜트명'.
  APPEND LS_FCAT TO GT_FIELDCAT.

**  CLEAR: LS_FCAT.
**  LS_FCAT-COL_POS   = 6.
**  LS_FCAT-FIELDNAME = 'EISBE'.
**  LS_FCAT-COLTEXT   = '안전재고'.
**  LS_FCAT-JUST      = 'R'.
**  LS_FCAT-EDIT      = 'X'.
**  LS_FCAT-OUTPUTLEN = 15.
**  APPEND LS_FCAT TO GT_FIELDCAT.

  CLEAR: LS_FCAT.
  LS_FCAT-COL_POS   = 7.
  LS_FCAT-FIELDNAME = 'MEINS1'.
  LS_FCAT-COLTEXT   = '단위'.
  LS_FCAT-EDIT      = 'X'.
  APPEND LS_FCAT TO GT_FIELDCAT.

  CLEAR: LS_FCAT.
  LS_FCAT-COL_POS   = 8.
  LS_FCAT-FIELDNAME = 'USEYN'.
  LS_FCAT-COLTEXT   = '삭제플래그'.
  LS_FCAT-JUST      = 'C'.
  LS_FCAT-CHECKBOX  = 'X'.
  LS_FCAT-EDIT      = 'X'.
  APPEND LS_FCAT TO GT_FIELDCAT.

  CLEAR: LS_FCAT.
  LS_FCAT-COL_POS   = 9.
  LS_FCAT-FIELDNAME = 'ERNAM'.
  LS_FCAT-COLTEXT   = '생성자 이름'.
  APPEND LS_FCAT TO GT_FIELDCAT.

  CLEAR: LS_FCAT.
  LS_FCAT-COL_POS   = 10.
  LS_FCAT-FIELDNAME = 'ERDAT'.
  LS_FCAT-COLTEXT   = '생성일'.
  APPEND LS_FCAT TO GT_FIELDCAT.

  CLEAR: LS_FCAT.
  LS_FCAT-COL_POS   = 11.
  LS_FCAT-FIELDNAME = 'ERZET'.
  LS_FCAT-COLTEXT   = '입력시간'.
  APPEND LS_FCAT TO GT_FIELDCAT.

  CLEAR: LS_FCAT.
  LS_FCAT-COL_POS   = 12.
  LS_FCAT-FIELDNAME = 'AENAM'.
  LS_FCAT-COLTEXT   = '변경자 이름'.
  APPEND LS_FCAT TO GT_FIELDCAT.

  CLEAR: LS_FCAT.
  LS_FCAT-COL_POS   = 13.
  LS_FCAT-FIELDNAME = 'AEDAT'.
  LS_FCAT-COLTEXT   = '최종 변경일'.
  APPEND LS_FCAT TO GT_FIELDCAT.

  CLEAR: LS_FCAT.
  LS_FCAT-COL_POS   = 14.
  LS_FCAT-FIELDNAME = 'AEZET'.
  LS_FCAT-COLTEXT   = '변경시간'.
  APPEND LS_FCAT TO GT_FIELDCAT.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_EVENT_RECEIVER_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_EVENT_RECEIVER_0100 .

  CREATE OBJECT LCL_EVENT_RECEIVER.

  SET HANDLER:
           LCL_EVENT_RECEIVER->HANDLE_DATA_CHANGED  FOR GO_ALV_GRID.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_REGISTER_EVENT_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_REGISTER_EVENT_0100 .

  GO_ALV_GRID->REGISTER_EDIT_EVENT(
  EXPORTING I_EVENT_ID = CL_GUI_ALV_GRID=>MC_EVT_ENTER    ).

  GO_ALV_GRID->REGISTER_EDIT_EVENT(
  EXPORTING I_EVENT_ID = CL_GUI_ALV_GRID=>MC_EVT_MODIFIED ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH_TABLE_DISPLAY_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM REFRESH_TABLE_DISPLAY_0100 .

  DATA : LS_STBL TYPE LVC_S_STBL.

  CHECK GO_ALV_GRID IS NOT INITIAL.

  CLEAR: LS_STBL.
  LS_STBL-ROW = 'X'.
  LS_STBL-COL = 'X'.

  CALL METHOD GO_ALV_GRID->REFRESH_TABLE_DISPLAY
    EXPORTING
      IS_STABLE = LS_STBL.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form BACK_RTN
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM BACK_RTN .

      " 변경 데이터가 있을 경우
      READ TABLE GT_MMT030 WITH KEY ICON = '@5D@' TRANSPORTING NO FIELDS.
      IF SY-SUBRC EQ 0.
        LV_ANSWER ='X'.
      ENDIF.

      " 오류 데이터가 있을 경우
      READ TABLE GT_MMT030 WITH KEY ICON = '@5C@' TRANSPORTING NO FIELDS.
      IF SY-SUBRC EQ 0.
        LV_ANSWER ='X'.
      ENDIF.

      " 신규 데이터가 있을 경우
      READ TABLE GT_MMT030 WITH KEY ICON = SPACE TRANSPORTING NO FIELDS.
      IF SY-SUBRC EQ 0.
        LV_ANSWER ='X'.
      ENDIF.

      "팝업을 띄운다.
     IF LV_ANSWER EQ 'X'.
       CLEAR: LV_ANSWER.
       CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
          EXPORTING
            DEFAULTOPTION  = 'N'
            TEXTLINE1      = '저장되지 않은 데이터가 있습니다.'
            TEXTLINE2      = '그래도 종료하시겠습니까?'
            TITEL          = 'Cancel'
            CANCEL_DISPLAY = ' '
          IMPORTING
            ANSWER         = LV_ANSWER.
       IF LV_ANSWER NE 'J'.
         MESSAGE '취소되었습니다.' TYPE 'S'.
         EXIT.
       ENDIF.
     ENDIF.

     IF GO_ALV_GRID IS NOT INITIAL.
       CALL METHOD GO_ALV_GRID->FREE.
       CALL METHOD GO_CONTAINER->FREE.
       CLEAR: GO_ALV_GRID, GO_CONTAINER.
     ENDIF.

***  PERFORM PROGRAM_UNLOCKED.
     LEAVE TO SCREEN 0.

ENDFORM.
