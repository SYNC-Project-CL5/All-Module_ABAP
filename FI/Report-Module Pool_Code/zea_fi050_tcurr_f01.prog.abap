*&---------------------------------------------------------------------*
*& Include          ZEA_FI050_TUCRR_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form SELECT_DATA
*&---------------------------------------------------------------------*
FORM SELECT_DATA .
  DATA: LV_TOTAL TYPE P LENGTH 9 DECIMALS 5.
*  DATA: LV_INDEX TYPE I VALUE 1.

  SELECT * FROM ZEA_TCURR INTO TABLE GT_TCURR
    WHERE TCURR EQ PA_TCURR
      AND GDATU IN SO_GDATU
    ORDER BY GDATU.

  LOOP AT GT_TCURR INTO GS_TCURR.
    LV_TOTAL = LV_TOTAL + GS_TCURR-UKURS.

    GS_TCURR-AVERAGE = LV_TOTAL / SY-TABIX. " <== 환율 평균
    MODIFY GT_TCURR FROM GS_TCURR TRANSPORTING AVERAGE.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MOVE_DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM MOVE_DISPLAY_DATA .

*  LOOP AT GT_TCURR INTO GS_TCURR.
*    MOVE-CORRESPONDING GS_TCURR TO GS_DATA.
*
*    PERFORM CELL_COLOR.
**    APPEND GS_DATA TO GT_DATA.
*  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM DISPLAY_DATA .
  DESCRIBE TABLE GT_DISPLAY.
  MESSAGE S006 WITH SY-TFILL.

  CALL SCREEN 0100.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_O100
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT_O100 .
*Creating custom container
  CREATE OBJECT CCON1
    EXPORTING
      CONTAINER_NAME = 'CCON1'.

  CREATE OBJECT CCON2
    EXPORTING
      CONTAINER_NAME = 'CCON2'.

  CREATE OBJECT GO_ALV_GRID
    EXPORTING
      I_PARENT = CCON1. "G_CUSTOM_CONTAINER.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_LAYOUT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_LAYOUT_0100 .

  GV_SAVE = 'A'.
  GS_VARIANT-REPORT = SY-REPID.

  GS_LAYOUT-ZEBRA      = ABAP_ON. " 얼룩 색상 처리
  GS_LAYOUT-CWIDTH_OPT = ABAP_ON. " 열 넓이 최적화
  GS_LAYOUT-SEL_MODE   = 'B'. " B: 한 행 선택
  GS_LAYOUT-GRID_TITLE = '일자별 환율 정보 및 변동 그래프'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_FIELDCAT_0100 .
*&-- 평균 값 생성을 위한 FCAT  -------------------------*

  REFRESH GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'FCURR'.
  GS_FIELDCAT-COLTEXT   = TEXT-F02. " '기준통화'.
  GS_FIELDCAT-REF_FIELD = 'FCURR'.
  GS_FIELDCAT-REF_TABLE ='ZEA_TCURR'.
  GS_FIELDCAT-KEY       = 'X'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'TCURR'.
  GS_FIELDCAT-COLTEXT   = TEXT-F03. " '변경통화'.
  GS_FIELDCAT-REF_FIELD = 'TCURR'.
  GS_FIELDCAT-REF_TABLE ='ZEA_TCURR'.
  GS_FIELDCAT-KEY       = 'X'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'GDATU'.
  GS_FIELDCAT-COLTEXT   = TEXT-F04. " '효력시작일'.
  GS_FIELDCAT-REF_FIELD = 'GDATU'.
  GS_FIELDCAT-REF_TABLE ='ZEA_TCURR'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'UKURS'.
  GS_FIELDCAT-COLTEXT   = TEXT-F05. " '환율'.
  GS_FIELDCAT-REF_FIELD = 'UKURS'.
  GS_FIELDCAT-REF_TABLE ='ZEA_TCURR'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.


  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'AVERAGE'.
  GS_FIELDCAT-COLTEXT   = TEXT-F06. "'평균환율'.
  GS_FIELDCAT-REF_FIELD = 'UKURS'.
  GS_FIELDCAT-REF_TABLE ='ZEA_TCURR'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'STATUS'.  "( 아이콘 설정한 필드명 )
  GS_FIELDCAT-COL_POS = 2.
  GS_FIELDCAT-ICON = ABAP_ON.
  GS_FIELDCAT-COLTEXT = TEXT-F01. " 환율대비
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_EVENT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_EVENT_0100 .
  SET HANDLER : LCL_EVENT_HANDLER=>DOUBLE_CLICK FOR GO_ALV_GRID,
                LCL_EVENT_HANDLER=>ON_HOTSPOT_CLICK FOR GO_ALV_GRID.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_0100
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV_0100 .
  CALL METHOD GO_ALV_GRID->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
      IS_LAYOUT       = GS_LAYOUT
*     I_STRUCTURE_NAME = 'ZEA_TCURR'
    CHANGING
      IT_FIELDCATALOG = GT_FIELDCAT
      IT_OUTTAB       = GT_DISPLAY.

  REFRESH : GRVAL1,Col1_texts.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM MAKE_DISPLAY_DATA .
  REFRESH GT_DISPLAY.

  LOOP AT GT_TCURR INTO GS_TCURR.

    CLEAR GS_DISPLAY.

    MOVE-CORRESPONDING GS_TCURR TO GS_DISPLAY.

    " 환율 > 평균환율
    IF GS_DISPLAY-UKURS > GS_DISPLAY-AVERAGE.
      GS_DISPLAY-STATUS = ICON_LED_RED. " 빨간색
    ELSE.
      " 환율 <= 평균환율
      GS_DISPLAY-STATUS = ICON_LED_GREEN. " 초록색
    ENDIF.

    APPEND GS_DISPLAY TO GT_DISPLAY.

  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form INPUT_CHECK
*&---------------------------------------------------------------------*
FORM INPUT_CHECK .

  " 30일 이내 환율만 조회 가능하도록 설정하고 싶음
  " 라디오 버튼으로 구현해도 좋을 듯
  PERFORM RADIOBUTTON.
*  " 전체조회 - 당일기준 30일
*  IF SO_GDATU-LOW IS INITIAL AND SO_GDATU-HIGH IS INITIAL.
*    CLEAR SO_GDATU.
*    REFRESH SO_GDATU[].
*
*    SO_GDATU-SIGN = 'I'.
*    SO_GDATU-OPTION = 'BT'.
*    SO_GDATU-HIGH = SY-DATUM.
*    SO_GDATU-LOW = SY-DATUM - 30.
*    APPEND SO_GDATU.
*  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form RADIOBUTTON
*&---------------------------------------------------------------------*
FORM RADIOBUTTON .
  CASE ABAP_ON.
    WHEN RA_1. " 7일
      CLEAR SO_GDATU.
      REFRESH SO_GDATU[].
      SO_GDATU-SIGN = 'I'.
      SO_GDATU-OPTION = 'BT'.
      SO_GDATU-HIGH = SY-DATUM.
      SO_GDATU-LOW = SY-DATUM - 6.
      APPEND SO_GDATU.

    WHEN RA_2. " 15일
      CLEAR SO_GDATU.
      REFRESH SO_GDATU[].
      SO_GDATU-SIGN = 'I'.
      SO_GDATU-OPTION = 'BT'.
      SO_GDATU-HIGH = SY-DATUM.
      SO_GDATU-LOW = SY-DATUM - 14.
      APPEND SO_GDATU.

    WHEN RA_3. " 30일
      CLEAR SO_GDATU.
      REFRESH SO_GDATU[].
      SO_GDATU-SIGN = 'I'.
      SO_GDATU-OPTION = 'BT'.
      SO_GDATU-HIGH = SY-DATUM.
      SO_GDATU-LOW = SY-DATUM - 30.
      APPEND SO_GDATU.

    WHEN RA_4. " 전체조회
      CLEAR SO_GDATU.
      REFRESH SO_GDATU[].
      SO_GDATU-SIGN = 'I'.
      SO_GDATU-OPTION = 'BT'.
      SO_GDATU-HIGH = SY-DATUM.
      APPEND SO_GDATU.


  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CALCULATION_UKURS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_COLUMN
*&      --> E_ROW
*&---------------------------------------------------------------------*
FORM CALCULATION_UKURS  USING    PS_COLUMN  TYPE LVC_S_COL
                                 PS_ROW     TYPE LVC_S_ROW.

*--- READ TABLE - 선택한 Row
  READ TABLE GT_DISPLAY INTO GS_DISPLAY INDEX PS_ROW-INDEX.

*  MESSAGE I000 WITH GS_DISPLAY-AVERAGE. " <== '평균환율 읽어오기' 테스트 완료
  S0150-GDATU = GS_DISPLAY-GDATU.
  S0150-UKURS = GS_DISPLAY-UKURS.
  S0150-TCURR = GS_DISPLAY-TCURR. " To
  S0150-FCURR = GS_DISPLAY-FCURR. " From
  S0150-AVERAGE = GS_DISPLAY-AVERAGE. " 평균환율

  CALL SCREEN 0150 STARTING AT 5 5.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CAL_UKURS
*&---------------------------------------------------------------------*
FORM CAL_UKURS .
  CHECK S0150-INPUT_USD IS NOT INITIAL.
  S0150-OUTPUT_KRW = S0150-INPUT_USD * S0150-UKURS . " 입력한 금액 X 환율
  S0150-OUTPUT_DIF = ( S0150-INPUT_USD * GS_DISPLAY-AVERAGE ) - ( S0150-INPUT_USD * S0150-UKURS ) . " 입력한 금액 X 평균환율 - 입력한 금액 X 당일환율

  IF  S0150-OUTPUT_DIF < 0.
    CALL FUNCTION 'ICON_CREATE'
      EXPORTING
        NAME                  = ICON_LED_RED
        TEXT                  = '외환차손이 예상됩니다.'
      IMPORTING
        RESULT                = STATUS
      EXCEPTIONS
        ICON_NOT_FOUND        = 1 " Icon name unknown to system
        OUTPUTFIELD_TOO_SHORT = 2 " Length of field 'RESULT' is too small
        OTHERS                = 3.
  ELSE.
    CALL FUNCTION 'ICON_CREATE'
      EXPORTING
        NAME                  = ICON_LED_GREEN
        TEXT                  = '외환차익이 예상됩니다.'
      IMPORTING
        RESULT                = STATUS
      EXCEPTIONS
        ICON_NOT_FOUND        = 1 " Icon name unknown to system
        OUTPUTFIELD_TOO_SHORT = 2 " Length of field 'RESULT' is too small
        OTHERS                = 3.
  ENDIF.
ENDFORM.
