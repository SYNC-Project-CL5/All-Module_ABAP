*&---------------------------------------------------------------------*
*& Include          ZEA_SD160_F01
*&---------------------------------------------------------------------*
FORM SELECT_DATA .

*  SELECT *
*    FROM ZEA_KNA1
*    INTO CORRESPONDING FIELDS OF TABLE GT_DATA
*   WHERE CUSCODE EQ PA_CUS.

*** 고객정보, 여신정보 가져와서 보여주기
  SELECT SINGLE *
      FROM ZEA_KNA1 AS A
      LEFT JOIN ZEA_KNKK AS B ON A~CUSCODE EQ B~CUSCODE
      INTO CORRESPONDING FIELDS OF GS_DATA
     WHERE A~CUSCODE EQ PA_CUS.

  CLEAR ZEA_KNA1.
  ZEA_KNA1-CUSCODE  = PA_CUS.
  ZEA_KNA1-SAKNR    = GS_DATA-SAKNR.
  ZEA_KNA1-BPCUS    = GS_DATA-BPCUS.
  ZEA_KNA1-BPCSNR   = GS_DATA-BPCSNR.
  ZEA_KNA1-BPHAED   = GS_DATA-BPHAED.
  ZEA_KNA1-BPSTAT   = GS_DATA-BPSTAT.
  ZEA_KNA1-ZLSCH    = GS_DATA-ZLSCH.
  ZEA_KNA1-LAND1    = GS_DATA-LAND1.
  ZEA_KNA1-BPADRR   = GS_DATA-BPADRR.

  CLEAR ZEA_KNKK.
  ZEA_KNKK-KLIMK    = GS_DATA-KLIMK.
  ZEA_KNKK-WAERS    = GS_DATA-WAERS.
  ZEA_KNKK-STATUS_K   = GS_DATA-STATUS_K.

*    GET PARAMETER ID 'ZEA_KNKK' FIELD ZEA_SDT040-CUSCODE.

*** A/R 정보 가져와서 계산하기
*- 승인된 판매오더중 STATUS4에 'X' 값이 입력되지 않은 건(수금완료되지 않은 건들) 만 조회하여 총 구매금액(TOAMT) 을 합산한다.
*- 합산된 금액을 고객여신 테이블(ZEA_KNKK)에서 여신 한도(KLIMK)필드에서 차액을 구하고 여신 잔액으로 입력한다.
*- 잔액의 비율에 따라 LED로 표시한다.(잔액이 30%부터 노란색 LED, 5%부터 빨간색 LED 표시)
*- SCR에서 고객을 검색하고 검색된 고객의 데이터(ZEA_KNA1)와 함께 여신데이터(ZEA_KNKK)를 보여준다.

  DATA: LS_ODAMT TYPE ZEA_SDT040-TOAMT,
        LT_ODAMT LIKE TABLE OF LS_ODAMT.


  SELECT TOAMT
    FROM ZEA_SDT040
    INTO TABLE LT_ODAMT
   WHERE STATUS4 NE 'X'.

  LOOP AT LT_ODAMT INTO LS_ODAMT.
    GV_ODAMT = GV_ODAMT + LS_ODAMT.
  ENDLOOP.


  AR          = GV_ODAMT.                               " A/R 잔액
  KLIMK_EXTRA = ZEA_KNKK-KLIMK - AR.                    " 여신 잔액

  IF KLIMK_EXTRA > 0.
      KLIMK_PERC  = ( KLIMK_EXTRA / ZEA_KNKK-KLIMK ) * 100. " 잔액 비율
  ELSE.
    KLIMK_PERC = 0.
    KLIMK_EXTRA = 0.
  ENDIF.



*  IF KLIMK_PERC LT 30. " 여신현황(ZEA_KNKK-STATUS_K)
*    ZEA_KNKK-STATUS_K = 'Y'.
*    ICON = ICON_YELLOW_LIGHT.
*  ELSEIF KLIMK_PERC LT 5.
*    ZEA_KNKK-STATUS_K = 'R'.
*    ICON = ICON_RED_LIGHT.
*  ELSE.
*    ZEA_KNKK-STATUS_K = 'G'.
*    ICON = ICON_GREEN_LIGHT.
*  ENDIF.

  IF KLIMK_PERC LT 5.
    ZEA_KNKK-STATUS_K = 'R'.
    ICON = ICON_RED_LIGHT.
  ELSEIF KLIMK_PERC LT 30. " 여신현황(ZEA_KNKK-STATUS_K)
    ZEA_KNKK-STATUS_K = 'Y'.
    ICON = ICON_YELLOW_LIGHT.
  ELSE.
    ZEA_KNKK-STATUS_K = 'G'.
    ICON = ICON_GREEN_LIGHT.
  ENDIF.


*** 고객 A/R 현황 ALV 에 데이터 전달

  SELECT *
    FROM ZEA_SDT040
    INTO CORRESPONDING FIELDS OF TABLE GT_DATA2
   WHERE STATUS4 NE 'X'
     AND LOEKZ NE 'X'
     AND CUSCODE EQ PA_CUS.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM DISPLAY_DATA .

*** 고객 A/R 현황 ALV 에 데이터 전달
  LOOP AT GT_DATA2 INTO GS_DATA2.
    CLEAR GS_DISPLAY2.
    MOVE-CORRESPONDING GS_DATA2 TO GS_DISPLAY2.
    APPEND GS_DISPLAY2 TO GT_DISPLAY2.
  ENDLOOP.



  CALL SCREEN 0100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_0110
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT_0110 .

  CREATE OBJECT GO_CONTAINER
    EXPORTING
      CONTAINER_NAME = 'CCON' " Name of the Screen CustCtrl Name to Link Container To
    EXCEPTIONS
      OTHERS         = 1.

  IF SY-SUBRC NE 0.
    MESSAGE '컨테이너 생성에 실패했습니다.' TYPE 'E'.
  ENDIF.


  CREATE OBJECT GO_ALV_GRID
    EXPORTING
      I_PARENT = GO_CONTAINER.   " Parent Container

  IF SY-SUBRC <> 0.
    MESSAGE 'ALV 생성에 실패했습니다.' TYPE 'E'.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_0110
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV_0110 .

  CALL METHOD GO_ALV_GRID->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
*     I_STRUCTURE_NAME = 'ZEA_SDT010'     " Internal Output Table Structure Name
      IS_VARIANT      = GS_VARIANT  " Layout
      I_SAVE          = GV_SAVE     " Save Layout
      IS_LAYOUT       = GS_LAYOUT   " Layout
    CHANGING
      IT_OUTTAB       = GT_DISPLAY2 " Output Table
      IT_FIELDCATALOG = GT_FIELDCAT        " Field Catalog
    EXCEPTIONS
      OTHERS          = 1.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FIELDCAT_0110
*&---------------------------------------------------------------------*
FORM SET_ALV_FIELDCAT_0110 .

  PERFORM GET_FIELDCAT    USING    GT_DISPLAY2
                          CHANGING GT_FIELDCAT.
  PERFORM MAKE_FIELDCAT_0110.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_FIELDCAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_DISPLAY2
*&      <-- GT_FIELDCAT
*&---------------------------------------------------------------------*
FORM GET_FIELDCAT   USING    PT_TAB  TYPE STANDARD TABLE
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
*& Form MAKE_FIELDCAT_0110
*&---------------------------------------------------------------------*
FORM MAKE_FIELDCAT_0110 .

  LOOP AT GT_FIELDCAT INTO GS_FIELDCAT.

    CASE GS_FIELDCAT-FIELDNAME.
      WHEN 'VBELN'.
        GS_FIELDCAT-KEY       = ABAP_ON.
      WHEN 'TOAMT'.
        GS_FIELDCAT-EMPHASIZE  = 'C311'.
        GS_FIELDCAT-CFIELDNAME    = 'WAERS'.
      WHEN 'SADDR'.
        GS_FIELDCAT-OUTPUTLEN = 25.
      WHEN 'STATUS4'.
        GS_FIELDCAT-NO_OUT = 'X'.
      WHEN 'LOEKZ'.
        GS_FIELDCAT-NO_OUT = 'X'.
    ENDCASE.
    MODIFY GT_FIELDCAT FROM GS_FIELDCAT.
  ENDLOOP.

*VBELN   TYPE ZEA_SDT040-VBELN,
*        SADDR   TYPE ZEA_SDT040-SADDR,
*        VDATU   TYPE ZEA_SDT040-VDATU,
*        ODDAT   TYPE ZEA_SDT040-ODDAT,
*        TOAMT   TYPE ZEA_SDT040-TOAMT,
*        WAERS   TYPE ZEA_SDT040-WAERS,
*        STATUS4 TYPE ZEA_SDT040-STATUS4,
*        LOEKZ   TYPE ZEA_SDT040-LOEKZ,


ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_LAYOUT_0110
*&---------------------------------------------------------------------*
FORM SET_ALV_LAYOUT_0110 .

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
  GS_LAYOUT-SEL_MODE   = 'D'.

*  GS_LAYOUT-GRID_TITLE = TEXT-T10.          " ALV TITLE TEXT
  GS_LAYOUT-INFO_FNAME = 'COLOR'.           " 행 색상
*  GS_LAYOUT-EXCP_FNAME = 'LIGHT'.           " 신호등
*  GS_LAYOUT-EXCP_LED = ABAP_ON.             " 신호등 모양 변경
*  GS_LAYOUT-CTAB_FNAME = 'IT_FIELD_COLORS'. " 셀 별 색상
  GS_LAYOUT-STYLEFNAME  = 'STYLE'.          " 스타일

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MODIFY_DATA
*&---------------------------------------------------------------------*
FORM MODIFY_DATA .

  DATA: LS_KNKK TYPE ZEA_KNKK.

*  LOOP AT GT_DATA INTO GS_DATA.
    GS_DATA-STATUS_K = ZEA_KNKK-STATUS_K.
*    MODIFY GS_DATA.
    MOVE-CORRESPONDING GS_DATA TO LS_KNKK.
    UPDATE ZEA_KNKK FROM LS_KNKK.
*ENDLOOP.

IF SY-SUBRC EQ 0.
  COMMIT WORK AND WAIT. "저장성공
ELSE.
  ROLLBACK WORK. "저장실패
ENDIF.

ENDFORM.
