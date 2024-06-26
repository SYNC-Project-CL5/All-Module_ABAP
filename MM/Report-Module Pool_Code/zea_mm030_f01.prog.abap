*&---------------------------------------------------------------------*
*& Include          ZEA_MM030_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form REFRESH_RTN
*&---------------------------------------------------------------------*
FORM REFRESH_RTN.

  REFRESH GT_MMT050.

  SELECT *
    FROM ZEA_MMT050
    WHERE INFO_NO IN @SO_INFON
    AND   VENCODE IN @SO_VENCO
    AND   WERKS   IN @SO_WERKS
    AND   MATNR   IN @SO_MATNR
    INTO CORRESPONDING FIELDS OF TABLE @GT_MMT050.

  SORT GT_MMT050 BY INFO_NO VENCODE ASCENDING.

  IF GT_MMT050[] IS NOT INITIAL.

    SELECT MATNR,
           MAKTX
      INTO CORRESPONDING FIELDS OF TABLE @GT_MMT020
      FROM ZEA_MMT020
           FOR ALL ENTRIES IN @GT_MMT050
      WHERE MATNR EQ @GT_MMT050-MATNR
      AND   SPRAS EQ @SY-LANGU."시스템 변수(로그온 언어)
    SORT GT_MMT020 BY MATNR.

    SELECT VENCODE,
           BPVEN
      INTO CORRESPONDING FIELDS OF TABLE @GT_LFA1
      FROM ZEA_LFA1
           FOR ALL ENTRIES IN @GT_MMT050
      WHERE VENCODE EQ @GT_MMT050-VENCODE.
    SORT GT_LFA1 BY VENCODE.

    SELECT WERKS,
           PNAME1
      INTO CORRESPONDING FIELDS OF TABLE @GT_T001W
      FROM ZEA_T001W
           FOR ALL ENTRIES IN @GT_MMT050
      WHERE WERKS EQ @GT_MMT050-WERKS.
    SORT GT_T001W BY WERKS.

  ENDIF.

  LOOP  AT  GT_MMT050.

        DATA(LV_TABIX) = SY-TABIX.

       "ZEA_MMT020 데이터를 읽은 후 찾으면 넣어준다
       "자재명 가져오기
        READ TABLE GT_MMT020 INTO GS_MMT020
        WITH KEY MATNR = GT_MMT050-MATNR BINARY SEARCH.
        IF SY-SUBRC EQ 0."참, 거짓
          GT_MMT050-MAKTX = GS_MMT020-MAKTX.
        ENDIF.

       "ZEA_LFA1 데이터를 읽은 후 찾으면 넣어준다
       "공급업체명 가져오기
        READ TABLE GT_LFA1 INTO GS_LFA1
        WITH KEY VENCODE = GT_MMT050-VENCODE BINARY SEARCH.
        IF SY-SUBRC EQ 0."참, 거짓
          GT_MMT050-BPVEN = GS_LFA1-BPVEN.
        ENDIF.

       "ZEA_T001W 데이터를 읽은 후 찾으면 넣어준다
       "플랜트명 가져오기
        READ TABLE GT_T001W INTO GS_T001W
        WITH KEY WERKS = GT_MMT050-WERKS BINARY SEARCH.
        IF SY-SUBRC EQ 0."참, 거짓
          GT_MMT050-PNAME1 = GS_T001W-PNAME1.
        ENDIF.

       "삭제플래그 EQ 'X'는 빨간색
        CASE GT_MMT050-LOEKZ.
          WHEN 'X'.
            GT_MMT050-ICON = '@11@'.
          WHEN OTHERS.
            GT_MMT050-ICON = '@5B@'.
        ENDCASE.

        MODIFY GT_MMT050 INDEX LV_TABIX.

  ENDLOOP.

  IF OK_CODE NE 'DISPLAY'.
   "Message
    DATA(LV_CNT) = LINES( GT_MMT050 ).
    MESSAGE '조회건수: ' && LV_CNT && '건' TYPE 'S'.
  ELSE.
    MESSAGE '조회모드 변경 완료' TYPE 'S'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM DISPLAY_DATA .

  "처음 실행모드는 조회모드로 설정
   GV_MODE = 'D'.
   CALL SCREEN 0100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_0100
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT_0100 .

   CREATE OBJECT GO_CONTAINER
    EXPORTING
      CONTAINER_NAME  = 'CCON'
    EXCEPTIONS
      OTHERS          = 1.

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
FORM SET_ALV_LAYOUT_0100 .

  CLEAR GS_LAYOUT.

*  GS_LAYOUT-ZEBRA      = 'X'.
  GS_LAYOUT-SEL_MODE   = 'D'.
  GS_LAYOUT-NO_TOOLBAR = ' '.
*  GS_LAYOUT-EDIT       = 'X'.
  GS_LAYOUT-NO_ROWINS = 'X'. " 라인에 대한 변화를 막아버린다.
  GS_LAYOUT-NO_ROWMOVE = 'X'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_0100
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV_0100 .

  CLEAR GS_VARIANT.
  GS_VARIANT-REPORT = SY-REPID.
  GV_SAVE = 'A'.

  CALL METHOD GO_ALV_GRID->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
      IS_VARIANT                    = GS_VARIANT                 " Layout
      I_SAVE                        = GV_SAVE                 " Save Layout
      IS_LAYOUT                     = GS_LAYOUT                " Layout
    CHANGING
      IT_FIELDCATALOG               = GT_FIELDCAT
      IT_OUTTAB                     = GT_MMT050[]              " Output Table
    EXCEPTIONS
      OTHERS                        = 1.

  IF SY-SUBRC NE 0.
    MESSAGE 'ALV 에 데이터를 설정하는 과정 중 오류가 발생하였습니다.' TYPE 'E'.
  ENDIF.

  CALL METHOD GO_ALV_GRID->SET_READY_FOR_INPUT
  EXPORTING I_READY_FOR_INPUT = 0.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form TOGGLE_RTN
*&---------------------------------------------------------------------*
FORM TOGGLE_RTN .

  DATA(LV_RESULT) = GO_ALV_GRID->IS_READY_FOR_INPUT( ).

  CASE LV_RESULT.
    WHEN 0.  "Display 모드인 경우, Change로 변경
      CALL METHOD GO_ALV_GRID->SET_READY_FOR_INPUT
      EXPORTING I_READY_FOR_INPUT = 1.

    WHEN 1.  "Change 모드인 경우, Display로 변경

      "변경 데이터가 있을 경우
       READ TABLE GT_MMT050 WITH KEY ICON = '@5D@' TRANSPORTING NO FIELDS.
       IF SY-SUBRC EQ 0.
         LV_ANSWER = 'X'.
       ENDIF.

      "오류 데이터가 있을 경우
       READ TABLE GT_MMT050 WITH KEY ICON = '@5C@' TRANSPORTING NO FIELDS.
       IF SY-SUBRC EQ 0.
         LV_ANSWER = 'X'.
       ENDIF.

      "신규 데이터가 있을 경우
       READ TABLE GT_MMT050 WITH KEY ICON = SPACE  TRANSPORTING NO FIELDS.
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
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_FIELDCATALOG_0100
*&---------------------------------------------------------------------*
FORM SET_FIELDCATALOG_0100 .

  DATA : LS_FCAT TYPE LVC_S_FCAT.

  CLEAR: LS_FCAT.
  LS_FCAT-COL_POS   = 1.
  LS_FCAT-FIELDNAME = 'ICON'.
  LS_FCAT-COLTEXT   = '상태'.
  LS_FCAT-EDIT      = SPACE. " or ' '
  LS_FCAT-JUST      = 'C'.
  LS_FCAT-OUTPUTLEN = 5.
  APPEND LS_FCAT TO GT_FIELDCAT.

  CLEAR: LS_FCAT.
  LS_FCAT-COL_POS   = 2.
  LS_FCAT-FIELDNAME = 'INFO_NO'.
  LS_FCAT-COLTEXT   = '정보레코드'.
  LS_FCAT-KEY       = 'X'.
  APPEND LS_FCAT TO GT_FIELDCAT.

  CLEAR: LS_FCAT.
  LS_FCAT-COL_POS   = 3.
  LS_FCAT-FIELDNAME = 'VENCODE'.
  LS_FCAT-COLTEXT   = '공급업체'.
  LS_FCAT-KEY       = 'X'.
  LS_FCAT-EDIT      = 'X'.
  LS_FCAT-JUST      = 'C'.
  LS_FCAT-OUTPUTLEN = 5.
  APPEND LS_FCAT TO GT_FIELDCAT.

  CLEAR: LS_FCAT.
  LS_FCAT-COL_POS   = 4.
  LS_FCAT-FIELDNAME = 'BPVEN'.
  LS_FCAT-COLTEXT   = '공급업체명'.
  LS_FCAT-OUTPUTLEN = 25.
  APPEND LS_FCAT TO GT_FIELDCAT.

  CLEAR: LS_FCAT.
  LS_FCAT-COL_POS   = 5.
  LS_FCAT-FIELDNAME = 'MATNR'.
  LS_FCAT-COLTEXT   = '자재번호'.
  LS_FCAT-EDIT      = 'X'.
  APPEND LS_FCAT TO GT_FIELDCAT.

  CLEAR: LS_FCAT.
  LS_FCAT-COL_POS   = 6.
  LS_FCAT-FIELDNAME = 'MAKTX'.
  LS_FCAT-COLTEXT   = '자재명'.
  APPEND LS_FCAT TO GT_FIELDCAT.

***  CLEAR: LS_FCAT.
***  LS_FCAT-COL_POS   = 7.
***  LS_FCAT-FIELDNAME = 'EKORG'.
***  LS_FCAT-COLTEXT   = '구매조직'.
***  LS_FCAT-EDIT      = 'X'.
***  LS_FCAT-OUTPUTLEN = 5.
***  LS_FCAT-JUST      = 'C'.
***  APPEND LS_FCAT TO GT_FIELDCAT.

  CLEAR: LS_FCAT.
  LS_FCAT-COL_POS   = 7.
  LS_FCAT-FIELDNAME = 'WERKS'.
  LS_FCAT-COLTEXT   = '플랜트'.
  LS_FCAT-JUST      = 'C'.
  LS_FCAT-OUTPUTLEN = 5.
  LS_FCAT-EDIT      = 'X'.
  APPEND LS_FCAT TO GT_FIELDCAT.

  CLEAR: LS_FCAT.
  LS_FCAT-COL_POS   = 8.
  LS_FCAT-FIELDNAME = 'PNAME1'.
  LS_FCAT-COLTEXT   = '플랜트 내역'.
  APPEND LS_FCAT TO GT_FIELDCAT.

  CLEAR: LS_FCAT.
  LS_FCAT-COL_POS    = 9.
  LS_FCAT-FIELDNAME  = 'BSTME'.
  LS_FCAT-COLTEXT    = '가격단위수량'.
  LS_FCAT-JUST       = 'C'.
  LS_FCAT-EDIT       = 'X'.
  LS_FCAT-DECIMALS_O = 0.
  APPEND LS_FCAT TO GT_FIELDCAT.

  CLEAR: LS_FCAT.
  LS_FCAT-COL_POS   = 10.
  LS_FCAT-FIELDNAME = 'MEINS'.
  LS_FCAT-COLTEXT   = '가격단위'.
  LS_FCAT-JUST      = 'C'.
  LS_FCAT-EDIT      = 'X'.
  APPEND LS_FCAT TO GT_FIELDCAT.

  CLEAR: LS_FCAT.
  LS_FCAT-COL_POS    = 11.
  LS_FCAT-FIELDNAME  = 'MATCOST'.
  LS_FCAT-COLTEXT    = '자재단가'.
  LS_FCAT-EDIT       = 'X'.
  LS_FCAT-CFIELDNAME = 'WAERS1'.
*  LS_FCAT-CURRENCY   = 'KRW'.
  LS_FCAT-EMPHASIZE  = 'C311'.
  APPEND LS_FCAT TO GT_FIELDCAT.

  CLEAR: LS_FCAT.
  LS_FCAT-COL_POS   = 12.
  LS_FCAT-FIELDNAME = 'WAERS1'.
  LS_FCAT-COLTEXT   = '통화'.
  LS_FCAT-JUST      = 'C'.
  LS_FCAT-OUTPUTLEN = 4.
  LS_FCAT-EDIT      = 'X'.
  APPEND LS_FCAT TO GT_FIELDCAT.

  CLEAR: LS_FCAT.
  LS_FCAT-COL_POS   = 13.
  LS_FCAT-FIELDNAME = 'FDATU'.
  LS_FCAT-COLTEXT   = '레코드 효력 시작일'.
  LS_FCAT-EDIT      = 'X'.
  LS_FCAT-JUST      = 'C'.
  LS_FCAT-OUTPUTLEN = 15.
  APPEND LS_FCAT TO GT_FIELDCAT.

  CLEAR: LS_FCAT.
  LS_FCAT-COL_POS   = 14.
  LS_FCAT-FIELDNAME = 'BDATU'.
  LS_FCAT-COLTEXT   = '레코드 효력 종료일'.
  LS_FCAT-JUST      = 'C'.
  LS_FCAT-OUTPUTLEN = 15.
  APPEND LS_FCAT TO GT_FIELDCAT.

  CLEAR: LS_FCAT.
  LS_FCAT-COL_POS   = 15.
  LS_FCAT-FIELDNAME = 'LOEKZ'.
  LS_FCAT-COLTEXT   = '삭제플래그'.
  LS_FCAT-JUST      = 'C'.
  LS_FCAT-EDIT      = 'X'.
  LS_FCAT-CHECKBOX  = 'X'.
  APPEND LS_FCAT TO GT_FIELDCAT.

  CLEAR: LS_FCAT.
  LS_FCAT-COL_POS   = 16.
  LS_FCAT-FIELDNAME = 'ERNAM'.
  LS_FCAT-COLTEXT   = '생성자 이름'.
  APPEND LS_FCAT TO GT_FIELDCAT.

  CLEAR: LS_FCAT.
  LS_FCAT-COL_POS   = 17.
  LS_FCAT-FIELDNAME = 'ERDAT'.
  LS_FCAT-COLTEXT   = '생성일'.
  APPEND LS_FCAT TO GT_FIELDCAT.

***  CLEAR: LS_FCAT.
***  LS_FCAT-COL_POS   = 17.
***  LS_FCAT-FIELDNAME = 'ERZET'.
***  LS_FCAT-COLTEXT   = '입력시간'.
***  APPEND LS_FCAT TO GT_FIELDCAT.
***
***  CLEAR: LS_FCAT.
***  LS_FCAT-COL_POS   = 18.
***  LS_FCAT-FIELDNAME = 'AENAM'.
***  LS_FCAT-COLTEXT   = '변경자 이름'.
***  APPEND LS_FCAT TO GT_FIELDCAT.
***
***  CLEAR: LS_FCAT.
***  LS_FCAT-COL_POS   = 19.
***  LS_FCAT-FIELDNAME = 'AEDAT'.
***  LS_FCAT-COLTEXT   = '최종 변경일'.
***  APPEND LS_FCAT TO GT_FIELDCAT.
***
***  CLEAR: LS_FCAT.
***  LS_FCAT-COL_POS   = 20.
***  LS_FCAT-FIELDNAME = 'AEZET'.hylw
***  LS_FCAT-COLTEXT   = '변경시간'.
***  APPEND LS_FCAT TO GT_FIELDCAT.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_USER_COMMAND
*&---------------------------------------------------------------------*
*&      --> E_UCOMM
*&---------------------------------------------------------------------*
FORM HANDLE_USER_COMMAND  USING C_UCOMM.

***  CASE C_UCOMM.
***    WHEN ' '.
***  ENDCASE.
***  CLEAR: C_UCOMM.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_TOOLBAR
*&---------------------------------------------------------------------*
*&      --> E_OBJECT
*&      --> E_INTERACTIVE
*&---------------------------------------------------------------------*
FORM HANDLE_TOOLBAR USING P_OBJECT TYPE REF TO
                                   CL_ALV_EVENT_TOOLBAR_SET
                          P_INTERACTIVE TYPE CHAR1.

  DATA : LS_TOOLBAR TYPE STB_BUTTON.
  CLEAR LS_TOOLBAR.
  LS_TOOLBAR-BUTN_TYPE = 3.
  APPEND LS_TOOLBAR TO P_OBJECT->MT_TOOLBAR.

*  CHECK GV_MODE EQ 'C'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH_TABLE_DISPLAY_0100
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
*& Form INSERT_RTN
*&---------------------------------------------------------------------*
FORM INSERT_RTN .

  APPEND INITIAL LINE TO GT_MMT050.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DELETE_RTN
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
  ELSE.
    SORT LT_ROWS BY INDEX DESCENDING.
  ENDIF.

  DATA : LV_CNT TYPE I.

  LOOP AT LT_ROWS INTO LS_ROWS.

    READ TABLE GT_MMT050 INDEX LS_ROWS-INDEX.
    CHECK SY-SUBRC EQ 0.
    ADD 1 TO LV_CNT.
    DATA(LV_TABIX) = SY-TABIX.

   "기존에 저장되어 있던 데이터는 'X'표시
    IF GT_MMT050-ICON  IS NOT INITIAL.
      GT_MMT050-ICON  = '@5D@'.
      GT_MMT050-LOEKZ = 'X'.

   "신규 Insert 데이터이고, 변경하지않은 ROW는 ALV에서 삭제
    ELSE.
      DELETE GT_MMT050 INDEX LV_TABIX.
    ENDIF.

   "테이블에 저장되지 않은 신규 Insert 데이터는 ALV에서 삭제
    IF GT_MMT050-ERNAM IS INITIAL.
      DELETE GT_MMT050 INDEX LV_TABIX.
    ENDIF.

    GT_MMT050-FDATU = SPACE.
    GT_MMT050-BDATU = SPACE.
    MODIFY GT_MMT050 INDEX LV_TABIX.

  ENDLOOP.

  MESSAGE '삭제되었습니다.' && '(' && LV_CNT && '건' && ')'  TYPE 'S'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SAVE_RTN
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
    READ TABLE GT_MMT050 INDEX LS_ROWS-INDEX.
    CHECK SY-SUBRC EQ 0.

   "ALV GRID 데이터 확인
    IF GT_MMT050-ICON NE '@5D@'.
       MESSAGE '변경하지 않은 데이터는 저장이 불가합니다.' TYPE 'I' DISPLAY LIKE 'E'.
       EXIT.
    ENDIF.

   "공급업체, 자재코드 중 하나라도 미입력시 에러처리
    IF GT_MMT050-VENCODE IS INITIAL OR
       GT_MMT050-MATNR   IS INITIAL.
      MESSAGE '공급업체, 자재코드는 필수값입니다.' TYPE 'I' DISPLAY LIKE 'E'.
      GT_MMT050-ICON = '@5C@'.
      GT_MMT050-VENCODE = SPACE.
      GT_MMT050-MATNR   = SPACE.
      GT_MMT050-BPVEN   = SPACE.
      GT_MMT050-MAKTX   = SPACE.
      MODIFY GT_MMT050 INDEX LS_ROWS-INDEX.
      EXIT.
    ENDIF.

    IF GT_MMT050-BSTME IS INITIAL OR
       GT_MMT050-MEINS IS INITIAL.
      MESSAGE '오더수량, 가격단위는 필수값입니다.' TYPE 'I' DISPLAY LIKE 'E'.
      GT_MMT050-ICON = '@5C@'.
      MODIFY GT_MMT050 INDEX LS_ROWS-INDEX.
      EXIT.
    ENDIF.

  ENDLOOP.

  CHECK SY-MSGTY NE 'E'.

  DATA : LV_CNT   TYPE I.
  DATA : LV_TABIX TYPE SY-TABIX."시스템 변수

 "선택된 ROW의 INDEX로 ALV GRID의 데이터를 읽는다.
  LOOP AT LT_ROWS INTO LS_ROWS.

   "선택된 INDEX로 ALV GRID의 INDEX를 읽는다.
    READ TABLE GT_MMT050 INDEX LS_ROWS-INDEX.
    CHECK SY-SUBRC EQ 0.
    LV_TABIX = SY-TABIX.
    ADD 1 TO LV_CNT.

    IF GT_MMT050-ERDAT IS INITIAL."신규
      GT_MMT050-ERNAM = GT_MMT050-AENAM = SY-UNAME.
      GT_MMT050-ERDAT = GT_MMT050-AEDAT = SY-DATUM.
      GT_MMT050-ERZET = GT_MMT050-AEZET = SY-UZEIT.

     "신규생성시 자동 채번
      PERFORM GET_INFO_NUMBERRANGE CHANGING GT_MMT050-INFO_NO.

    ELSE."변경
      GT_MMT050-AENAM = SY-UNAME.
      GT_MMT050-AEDAT = SY-DATUM.
      GT_MMT050-AEZET = SY-UZEIT.
    ENDIF.

*   테이블 데이터 업데이트
    MOVE-CORRESPONDING GT_MMT050 TO ZEA_MMT050.
    MODIFY ZEA_MMT050.

    CASE GT_MMT050-LOEKZ.
      WHEN 'X'.    GT_MMT050-ICON = '@11@'.
      WHEN OTHERS. GT_MMT050-ICON = '@5B@'.
    ENDCASE.

    MODIFY GT_MMT050 INDEX LV_TABIX.

   "-----------------------------"
   " 자재마스터 원가 필드 Update "
   "-----------------------------"
    SELECT SINGLE MATNR, "자재마스터 데이터 Select
                  WEIGHT,
                  MEINS1
      INTO @DATA(LS_MMT010)
      FROM ZEA_MMT010
      WHERE MATNR EQ @GT_MMT050-MATNR.
    IF SY-SUBRC EQ 0.
      DATA(LV_COST) = GT_MMT050-MATCOST / LS_MMT010-WEIGHT.

      UPDATE ZEA_MMT010 "1KG 원가 업데이트
      SET STPRS = LV_COST
      WHERE MATNR EQ GT_MMT050-MATNR.
      COMMIT WORK.
    ENDIF.

  ENDLOOP.

  MESSAGE '저장되었습니다' && '(' && LV_CNT && '건)' TYPE 'S'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_DATA_CHANGED
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

        CLEAR: GT_MMT050.
        READ TABLE GT_MMT050 INDEX LS_MOD-ROW_ID.
        CHECK SY-SUBRC EQ 0.
        DATA(LV_TABIX) = SY-TABIX.

       "ROW 데이터가 변경되면 ICON_LED_YELLOW 표시
        CALL METHOD PR_DATA_CHANGED->MODIFY_CELL
        EXPORTING I_ROW_ID    = LV_TABIX
                  I_FIELDNAME = 'ICON'
                  I_VALUE     = '@5D@'.

       "자재코드 입력시 자재명 가져오기.
        CASE LS_MOD-FIELDNAME.
*        ---------------
          WHEN 'MATNR'.
*        ---------------
            SELECT SINGLE MAKTX
              INTO @DATA(LV_MAKTX)
              FROM ZEA_MMT020
              WHERE MATNR EQ @LS_MOD-VALUE
              AND   SPRAS EQ @SY-LANGU.
            CASE SY-SUBRC.
              WHEN 0.
                PR_DATA_CHANGED->MODIFY_CELL( EXPORTING
                                                I_ROW_ID    = LV_TABIX
                                                I_FIELDNAME = 'MAKTX'
                                                I_VALUE     = LV_MAKTX ).
              WHEN OTHERS.
                PR_DATA_CHANGED->MODIFY_CELL( EXPORTING
                                                I_ROW_ID    = LV_TABIX
                                                I_FIELDNAME = 'MAKTX'
                                                I_VALUE     = SPACE    ).
            ENDCASE.

            SELECT SINGLE MATNR, BSTME, MEINS2
              INTO @DATA(LS_MMT010)
              FROM ZEA_MMT010
              WHERE MATNR EQ @LS_MOD-VALUE.
            CASE SY-SUBRC.
              WHEN 0.
                PR_DATA_CHANGED->MODIFY_CELL( EXPORTING
                                                I_ROW_ID    = LV_TABIX
                                                I_FIELDNAME = 'BSTME'
                                                I_VALUE     = LS_MMT010-BSTME ).
                PR_DATA_CHANGED->MODIFY_CELL( EXPORTING
                                                I_ROW_ID    = LV_TABIX
                                                I_FIELDNAME = 'MEINS'
                                                I_VALUE     = LS_MMT010-MEINS2 ).
              WHEN OTHERS.
            ENDCASE.

*        ---------------
          WHEN 'VENCODE'.
*        ---------------
            SELECT SINGLE BPVEN
              INTO @DATA(LV_BPVEN)
              FROM ZEA_LFA1
              WHERE VENCODE EQ @LS_MOD-VALUE.
            IF SY-SUBRC EQ 0.
              CALL METHOD PR_DATA_CHANGED->MODIFY_CELL
              EXPORTING I_ROW_ID    = LV_TABIX
                        I_FIELDNAME = 'BPVEN'
                        I_VALUE     = LV_BPVEN.
            ELSE.
              CALL METHOD PR_DATA_CHANGED->MODIFY_CELL
              EXPORTING I_ROW_ID    = LV_TABIX
                        I_FIELDNAME = 'BPVEN'
                        I_VALUE     = SPACE.
            ENDIF.

*        ---------------
          WHEN 'FDATU'.
*        ---------------
            IF LS_MOD-VALUE IS NOT INITIAL.
              CALL METHOD PR_DATA_CHANGED->MODIFY_CELL
              EXPORTING I_ROW_ID    = LV_TABIX
                        I_FIELDNAME = 'BDATU'
                        I_VALUE     = '99991231'.
            ELSE.
              CALL METHOD PR_DATA_CHANGED->MODIFY_CELL
              EXPORTING I_ROW_ID    = LV_TABIX
                        I_FIELDNAME = 'BDATU'
                        I_VALUE     = SPACE.
            ENDIF.

*        ---------------
          WHEN 'WERKS'.
*        ---------------
            SELECT SINGLE PNAME1
              INTO @DATA(LV_PNAME1)
              FROM ZEA_T001W
              WHERE WERKS EQ @LS_MOD-VALUE.
            IF SY-SUBRC EQ 0.
              CALL METHOD PR_DATA_CHANGED->MODIFY_CELL
              EXPORTING I_ROW_ID    = LV_TABIX
                        I_FIELDNAME = 'PNAME1'
                        I_VALUE     = LV_PNAME1.
            ENDIF.

*        ---------------
          WHEN 'MATCOST'.
*        ---------------
            IF GT_MMT050-WAERS1 IS INITIAL.
              MESSAGE '통화를 입력하세요.' TYPE 'I' DISPLAY LIKE 'E'.
              CALL METHOD PR_DATA_CHANGED->MODIFY_CELL
              EXPORTING I_ROW_ID    = LV_TABIX
                        I_FIELDNAME = 'MATCOST'
                        I_VALUE     = SPACE.
            ENDIF.

*        ---------------
          WHEN 'LOEKZ'.
*        ---------------
            IF LS_MOD-VALUE IS NOT INITIAL.
              CALL METHOD PR_DATA_CHANGED->MODIFY_CELL
              EXPORTING I_ROW_ID    = LV_TABIX
                        I_FIELDNAME = 'BDATU'
                        I_VALUE     = SPACE.
              CALL METHOD PR_DATA_CHANGED->MODIFY_CELL
              EXPORTING I_ROW_ID    = LV_TABIX
                        I_FIELDNAME = 'FDATU'
                        I_VALUE     = SPACE.

            ENDIF.

        ENDCASE.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_EVENT_RECEIVER_0100
*&---------------------------------------------------------------------*
FORM SET_EVENT_RECEIVER_0100 .

  CREATE OBJECT LCL_EVENT_RECEIVER.

  SET HANDLER:
          "Data Changed
           LCL_EVENT_RECEIVER->HANDLE_DATA_CHANGED  FOR GO_ALV_GRID.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_REGISTER_EVENT_0100
*&---------------------------------------------------------------------*
FORM SET_REGISTER_EVENT_0100 .

  GO_ALV_GRID->REGISTER_EDIT_EVENT(
  EXPORTING I_EVENT_ID = CL_GUI_ALV_GRID=>MC_EVT_ENTER    ).

  GO_ALV_GRID->REGISTER_EDIT_EVENT(
  EXPORTING I_EVENT_ID = CL_GUI_ALV_GRID=>MC_EVT_MODIFIED ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form BACK_RTN
*&---------------------------------------------------------------------*
FORM BACK_RTN .

  "----------------------------
  " 종료하기전 ALV 데이터 체크
  "----------------------------
  "변경 데이터가 있을 경우
   READ TABLE GT_MMT050 WITH KEY ICON = '@5D@' TRANSPORTING NO FIELDS.
   IF SY-SUBRC EQ 0.
     LV_ANSWER = 'X'.
   ENDIF.

  "오류 데이터가 있을 경우
   READ TABLE GT_MMT050 WITH KEY ICON = '@5C@' TRANSPORTING NO FIELDS.
   IF SY-SUBRC EQ 0.
     LV_ANSWER = 'X'.
   ENDIF.

  "신규 데이터가 있을 경우
   READ TABLE GT_MMT050 WITH KEY ICON = SPACE  TRANSPORTING NO FIELDS.
   IF SY-SUBRC EQ 0.
     LV_ANSWER = 'X'.
   ENDIF.

  "팝업
   IF LV_ANSWER EQ 'X'.
     CLEAR: LV_ANSWER.
     CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
        EXPORTING
          DEFAULTOPTION  = 'N'
          TEXTLINE1      = '저장되지 않은 데이터가 있습니다.'
          TEXTLINE2      = '종료하시겠습니까?'
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

   PERFORM PROGRAM_UNLOCKED.
   LEAVE TO SCREEN 0.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form PROGRAM_LOCKED
*&---------------------------------------------------------------------*
FORM PROGRAM_LOCKED .

  DATA : LT_ENQ   TYPE TABLE OF SEQG3.
  DATA : LV_GNAME TYPE          SEQG3-GNAME.
  DATA : LV_GARG  TYPE          SEQG3-GARG.

  DATA : LV_MSG   TYPE          STRING.

  CLEAR: LV_GNAME.
  LV_GNAME = 'TRDIR'.

  CLEAR: LV_GARG.
  LV_GARG = SY-REPID.

  CLEAR: LT_ENQ[].
  CALL FUNCTION 'ENQUEUE_READ'
    EXPORTING
      GNAME                 = LV_GNAME
      GARG                  = LV_GARG
      GUNAME                = SY-UNAME
    TABLES
      ENQ                   = LT_ENQ
    EXCEPTIONS
      COMMUNICATION_FAILURE = 1
      SYSTEM_FAILURE        = 2
      OTHERS                = 3.

  IF LT_ENQ[] IS INITIAL.
    PERFORM SET_ENQUEUE.
    EXIT.
  ENDIF.

  READ TABLE LT_ENQ INTO DATA(LS_ENQ) INDEX 1.
  CHECK SY-SUBRC EQ 0.

  SELECT SINGLE NAME_TEXT
    INTO @DATA(LV_TEXT)
    FROM ADRP  AS A
    JOIN USR21 AS B
                  ON A~PERSNUMBER EQ B~PERSNUMBER
    WHERE B~BNAME EQ @LS_ENQ-GUNAME.

  CLEAR: LV_MSG.
  LV_MSG = |( { LS_ENQ-GUNAME } { '-' } { LV_TEXT })|.
  MESSAGE 'Program Locked!!' && LV_MSG TYPE 'I' DISPLAY LIKE 'E'.
  LEAVE LIST-PROCESSING.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ENQUEUE
*&---------------------------------------------------------------------*
FORM SET_ENQUEUE .

  DATA : LV_NAME TYPE SY-REPID.
  LV_NAME = SY-REPID.

  CALL FUNCTION 'ENQUEUE_E_TRDIR'
   EXPORTING
     MODE_TRDIR           = 'X'"E
     NAME                 = LV_NAME
     X_NAME               = ' '
     _SCOPE               = '2'
     _WAIT                = ' '
     _COLLECT             = ' '
   EXCEPTIONS
     FOREIGN_LOCK         = 1
     SYSTEM_FAILURE       = 2
     OTHERS               = 3.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form PROGRAM_UNLOCKED
*&---------------------------------------------------------------------*
FORM PROGRAM_UNLOCKED .

  DATA : LV_NAME TYPE SY-REPID.
  LV_NAME = SY-REPID.

  CALL FUNCTION 'DEQUEUE_E_TRDIR'
   EXPORTING
     MODE_TRDIR   = 'X'
     NAME         = LV_NAME
     X_NAME       = ' '
     _SCOPE       = '3'
     _SYNCHRON    = ' '
     _COLLECT     = ' '.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_INFO_NUMBERRANGE
*&---------------------------------------------------------------------*
FORM GET_INFO_NUMBERRANGE CHANGING C_NUMBER.

  DATA : NR_RANGE_NR  LIKE  INRI-NRRANGENR.
  DATA : OBJECT       LIKE  INRI-OBJECT.
  DATA : QUANTITY     LIKE  INRI-QUANTITY.
  DATA : LV_NUM       TYPE  I.

  CLEAR: NR_RANGE_NR, OBJECT, QUANTITY.
  NR_RANGE_NR = '04'.
  OBJECT      = 'ZEA_MMNR'.
  QUANTITY    = 1.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      NR_RANGE_NR                   = NR_RANGE_NR
      OBJECT                        = OBJECT
      QUANTITY                      = QUANTITY
    IMPORTING
      NUMBER                        = LV_NUM
    EXCEPTIONS
      INTERVAL_NOT_FOUND            = 1
      NUMBER_RANGE_NOT_INTERN       = 2
      OBJECT_NOT_FOUND              = 3
      QUANTITY_IS_0                 = 4
      QUANTITY_IS_NOT_1             = 5
      INTERVAL_OVERFLOW             = 6
      BUFFER_OVERFLOW               = 7
      OTHERS                        = 8.
  IF SY-SUBRC EQ 0.
    C_NUMBER = LV_NUM.
  ENDIF.

ENDFORM.
