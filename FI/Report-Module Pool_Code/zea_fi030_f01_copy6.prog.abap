*&---------------------------------------------------------------------*
*& Include          ZEA_GL_DISPLAY_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT .
***  CREATE OBJECT GO_CONTAINER
***    EXPORTING
***      CONTAINER_NAME = 'CCON_ITEM'.
***  IF SY-SUBRC <> 0.
***    " 메세지 구현 필요
***  ENDIF.
***
***  CREATE OBJECT GO_ALV_GRID
***    EXPORTING
***      I_PARENT = GO_CONTAINER.
***  IF SY-SUBRC <> 0.
***    " 메세지 구현 필요
***  ENDIF.

*-- Create Container
  CREATE OBJECT GO_CONTAINER
    EXPORTING
      REPID = SY-REPID
      DYNNR = SY-DYNNR
      SIDE  = GO_CONTAINER->DOCK_AT_RIGHT
      RATIO = 60.


  CREATE OBJECT GO_ALV_GRID
    EXPORTING
      I_PARENT      = GO_CONTAINER
      I_APPL_EVENTS = 'X'. " Register Events as Application Events

*-- Create TOP-Document
  CREATE OBJECT GO_DYNDOC_ID
    EXPORTING
      STYLE = 'ALV_GRID'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form ALV_LAYOUT_0100
*&---------------------------------------------------------------------*
FORM ALV_LAYOUT_0100 .

  GV_SAVE = 'A'.
  GS_VARIANT-REPORT = SY-REPID.

  GS_LAYOUT-ZEBRA      = ABAP_ON. " 얼룩 색상 처리
  GS_LAYOUT-CWIDTH_OPT = 'A'. " 열 넓이 최적화
  GS_LAYOUT-SEL_MODE   = 'D'. " D: 셀 단위 선택
  GS_LAYOUT-GRID_TITLE = '임시 전표 항목'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form ALV_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM ALV_FIELDCAT_0100 .

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'ITNUM'.
  GS_FIELDCAT-REF_TABLE = 'ZEA_BSEG'.
  GS_FIELDCAT-REF_FIELD = 'ITNUM'.
  GS_FIELDCAT-COLTEXT   = '항목'.
  GS_FIELDCAT-OUTPUTLEN = 10.
  GS_FIELDCAT-KEY = ABAP_ON.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'BSCHL'.
  GS_FIELDCAT-REF_TABLE = 'ZEA_BSEG'.
  GS_FIELDCAT-REF_FIELD = 'BSCHL'.
  GS_FIELDCAT-OUTPUTLEN = 5.
  GS_FIELDCAT-KEY = ABAP_ON.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'GLTXT'.
  GS_FIELDCAT-REF_TABLE = 'ZEA_BSEG'.
  GS_FIELDCAT-REF_FIELD = 'GLTXT'.
  GS_FIELDCAT-OUTPUTLEN = 30.
  GS_FIELDCAT-KEY = ABAP_ON.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'DMBTR'.
  GS_FIELDCAT-REF_TABLE = 'ZEA_BSEG'.
  GS_FIELDCAT-REF_FIELD = 'DMBTR'.
  GS_FIELDCAT-EMPHASIZE = 'C311'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'D_WAERS'.
  GS_FIELDCAT-REF_TABLE = 'ZEA_BSEG'.
  GS_FIELDCAT-REF_FIELD = 'D_WAERS'.
  GS_FIELDCAT-EMPHASIZE = 'C311'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'WRBTR'.
  GS_FIELDCAT-REF_TABLE = 'ZEA_BSEG'.
  GS_FIELDCAT-REF_FIELD = 'WRBTR'.
  GS_FIELDCAT-EMPHASIZE = 'C311'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'W_WAERS'.
  GS_FIELDCAT-REF_TABLE = 'ZEA_BSEG'.
  GS_FIELDCAT-REF_FIELD = 'W_WAERS'.
  GS_FIELDCAT-EMPHASIZE = 'C311'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'INDI_CD'.
  GS_FIELDCAT-REF_TABLE = 'ZEA_TBSL'.
  GS_FIELDCAT-REF_FIELD = 'INDI_CD'.
  GS_FIELDCAT-COLTEXT   = '차대'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form ALV_EVENT_0100
*&---------------------------------------------------------------------*
FORM ALV_EVENT_0100 .
  SET HANDLER LCL_EVENT_HANDLER=>ON_TOOLBAR FOR GO_ALV_GRID.
  SET HANDLER LCL_EVENT_HANDLER=>ON_USER_COMMAND FOR GO_ALV_GRID.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form ALV_DISPLAY_0100
*&---------------------------------------------------------------------*
FORM ALV_DISPLAY_0100 .

  GO_ALV_GRID->SET_TABLE_FOR_FIRST_DISPLAY(
    EXPORTING
      I_STRUCTURE_NAME              = 'ZEA_BSEG'
      IS_VARIANT                    = GS_VARIANT
      I_SAVE                        = 'A'
      I_DEFAULT                     = 'X'
      IS_LAYOUT                     = GS_LAYOUT
*      IT_TOOLBAR_EXCLUDING          = GT_UI_FUNCTIONS
    CHANGING
      IT_OUTTAB                     = GT_DATA
      IT_FIELDCATALOG               = GT_FIELDCAT
*      IT_SORT                       =
*      IT_FILTER                     =
*    EXCEPTIONS
*      INVALID_PARAMETER_COMBINATION = 1
*      PROGRAM_ERROR                 = 2
*      TOO_MANY_LINES                = 3
*      OTHERS                        = 4
  ).
  IF SY-SUBRC <> 0.
    " 메세지 구현 필요
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_DATA
*&---------------------------------------------------------------------*
FORM SELECT_DATA .

  " 전기키
  SELECT * FROM ZEA_TBSL INTO TABLE GT_TBSL.

  " 환율
  SELECT * FROM ZEA_TCURR INTO TABLE GT_TCURR.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM MAKE_DISPLAY_DATA .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM DISPLAY_DATA .
*  DESCRIBE TABLE GT_BSEG.
*  MESSAGE S005 WITH SY-TFILL.

  CALL SCREEN 200.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form INIT_DATA
*& ZEA_BKPF : 헤더 / ZEA_BSEG : 아이템
*&---------------------------------------------------------------------*
FORM INIT_DATA .

* -- 200 번 화면 (Header) --------------------------
  ZEA_BSEG-D_WAERS = 'KRW'. " 통화코드 초기설정


* --  200번 화면의 disable 입력필드에 값 전달
  ZEA_BKPF-BUKRS = 1000.
  ZEA_BKPF-GJAHR = SY-DATUM+0(4).
  ZEA_BKPF-BLDAT = SY-DATUM.        " 증빙일자 = 오늘날짜
  ZEA_BKPF-BUDAT = SY-DATUM.        " 전기일자 = 오늘날짜
  ZEA_BKPF-ERDAT = SY-DATUM.
  ZEA_BKPF-ERZET = SY-UZEIT.
  ZEA_TCURR-GDATU = SY-DATUM.

  " 200번 헤더에서 입력한 전기키를 Search Help를 사용하기 위해 값 전달
  ZEA_BSEG-BSCHL = ZEA_TBSL-BSCHL.

  " 200번 화면에서 전기키, 계정코드를 입력하기 위한 초기 조건
  ZEA_BSEG-BUKRS = 1000.
  ZEA_BSEG-GJAHR = SY-DATUM+0(4).
  ZEA_BKPF-ERNAM = SY-UNAME.
*  CASE SY-UNAME.
*    WHEN 'ACA5-03'.
*      ZEA_BKPF-ERNAM = '김건우'.
*    WHEN 'ACA5-07'.
*      ZEA_BKPF-ERNAM = '김연범'.
*    WHEN 'ACA5-08'.
*      ZEA_BKPF-ERNAM = '김예리'.
*    WHEN 'ACA5-10'.
*      ZEA_BKPF-ERNAM = '김혜진'.
*    WHEN 'ACA5-12'.
*      ZEA_BKPF-ERNAM = '박지영'.
*    WHEN 'ACA5-15'.
*      ZEA_BKPF-ERNAM = '유연수'.
*    WHEN 'ACA5-17'.
*      ZEA_BKPF-ERNAM = '이세영'.
*    WHEN 'ACA5-23'.
*      ZEA_BKPF-ERNAM = '조병석'.
*    WHEN 'ACA-05'.
*      ZEA_BKPF-ERNAM = '정훈영'.
*  ENDCASE.

*  글씨 색상변경
  LOOP AT SCREEN.
    IF SCREEN-GROUP1 = 'BLU'.  "해당 파라미터 text 의 스크린네임
      SCREEN-INTENSIFIED = '1'.    "1 값이면 활성화 (파란색)
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SAVE_HEADER_DATA
*&---------------------------------------------------------------------*
FORM SAVE_HEADER_DATA .

  CLEAR GS_BKPF.
  REFRESH GT_BKPF.

  GS_BKPF-AEDAT = SY-DATUM.
  GS_BKPF-AENAM = SY-UNAME.
  GS_BKPF-AEZET = SY-UZEIT.

  " ZEA_BKPF 화면에 입력한 값을 내부 변수에 전달
  MOVE-CORRESPONDING ZEA_BKPF TO GS_BKPF.
  APPEND GS_BKPF TO GT_BKPF.

  GV_ITNUM = 0.  " 전표Line 번호 초기화
  ZEA_BSEG-BELNR = GS_BKPF-BELNR. " 전표번호 Item 에 전달
  ZEA_BSEG-BUKRS = GS_BKPF-BUKRS. " 회계연도 Item 에 전달


ENDFORM.
*&---------------------------------------------------------------------*
*& Form SAVE_ITEM_DATA
*&---------------------------------------------------------------------*
FORM SAVE_ITEM_DATA .

  CLEAR GS_DATA.
  CLEAR GS_BSEG.
*  REFRESH GT_BSEG. <== REFRESH 시, ALV에 신규 데이터 1줄만 보인다.
  DATA: LV_INDI_CD TYPE ZEA_TBSL-INDI_CD.

* -- G/L 계정, 전기키가 같으면 입력방지

  " GS_DATA 에 값이 안들어오는 경우가 있음. 전기키가 00 이라고 보임.
  READ TABLE GT_DATA INTO GS_DATA WITH KEY SAKNR = ZEA_BSEG-SAKNR
                                           BSCHL = ZEA_TBSL-BSCHL.

*  IF GS_DATA-BSCHL EQ ZEA_TBSL-BSCHL AND GS_DATA-SAKNR EQ ZEA_BSEG-SAKNR. (GT_DATA로 변경)
  IF GS_DATA-BSCHL EQ ZEA_TBSL-BSCHL AND GS_DATA-SAKNR EQ ZEA_BSEG-SAKNR.
    MESSAGE S122 DISPLAY LIKE 'W'. " 동일한 데이터가 존재합니다.

    " 입력 가능
  ELSE.
    SELECT SINGLE GLTXT FROM ZEA_SKB1 INTO LV_GLTXT
      WHERE SAKNR EQ ZEA_BSEG-SAKNR
        AND BUKRS EQ 1000.

    " CHECK
    CASE ZEA_BSEG-GLTXT.
      WHEN LV_GLTXT.
      WHEN OTHERS.
        SELECT SINGLE GLTXT FROM ZEA_SKB1 INTO LV_GLTXT
      WHERE SAKNR EQ ZEA_BSEG-SAKNR
        AND BUKRS EQ 1000.
        ZEA_BSEG-GLTXT = LV_GLTXT.
    ENDCASE.

* -- 1. item line 부여 ------------------------------------------------*
    GV_ITNUM = GV_ITNUM + 1. " 전표Line
    ZEA_BSEG-ITNUM = GV_ITNUM.

* -- 2. ZEA_BSEG 화면에 입력한 값을 내부 변수에 전달 ------------------*

    ZEA_BSEG-BSCHL = ZEA_TBSL-BSCHL. " 전기키 전달

    " ZEA_BSEG-DMBTR = * 값 입력 시, 차액 금액이 자동으로 입력되도록
    " 문제점 : 마지막 라인이 세금 코드 인경우, 차액 / 1.1 한 금액을 반영해줘야함. (2024.05.12 - 해결완료)
    IF ZEA_BSEG-DMBTR EQ '' AND S0100-TAX EQ ABAP_OFF.
      ZEA_BSEG-DMBTR = ABS( S0100-DIFFERENC ).
      ZEA_BSEG-WRBTR = ABS( S0100-DIFFERENC ).

    ELSEIF ZEA_BSEG-DMBTR EQ '' AND S0100-TAX EQ ABAP_ON.

      ZEA_BSEG-DMBTR = ABS( S0100-DIFFERENC * 10 / 11 ).
      ZEA_BSEG-WRBTR = ABS( S0100-DIFFERENC  * 10 / 11 ).
      " Line Item 에 tax 가 반영되어 있는지

*      READ TABLE GT_DATA INTO GS_DATA WITH KEY SAKNR = '210200' BINARY SEARCH. " 부가세 예수금
*      IF GS_DATA-SAKNR IS NOT INITIAL.
*        ZEA_BSEG-DMBTR = ABS( S0100-DIFFERENC * 10 / 11 ).
*        ZEA_BSEG-WRBTR = ABS( S0100-DIFFERENC  * 10 / 11 ).
*        CLEAR GS_DATA.
*      ENDIF.
*
*      READ TABLE GT_DATA INTO GS_DATA WITH KEY SAKNR = '210210' BINARY SEARCH . "  부가세 대급금
*      IF GS_DATA-SAKNR IS NOT INITIAL.
*        ZEA_BSEG-DMBTR = ABS( S0100-DIFFERENC * 10 / 11 ).
*        ZEA_BSEG-WRBTR = ABS( S0100-DIFFERENC  * 10 / 11 ).
*        CLEAR GS_DATA.
*      ENDIF.
    ENDIF.


* -- 3. 전표통화금액 -> 환율계산 --------------------------------------*
    CASE ZEA_BSEG-D_WAERS.
        " 1) KRW -> KRW
      WHEN 'KRW'.
        " ZEA_BSEG-DMBTR = 금액을 입력하는 입력필드
        ZEA_BSEG-WRBTR   = ZEA_BSEG-DMBTR.
        ZEA_BSEG-W_WAERS = ZEA_BSEG-D_WAERS. " KRW 전달

      WHEN OTHERS.
        ZEA_BSEG-WRBTR   = ZEA_BSEG-DMBTR * GS_TCURR-UKURS / 100.
        ZEA_BSEG-W_WAERS = 'KRW'.

    ENDCASE.


    MOVE-CORRESPONDING ZEA_BSEG TO GS_DATA.
    APPEND GS_DATA TO GT_DATA.

* -- 4. 세금 계산 & 차/대변 합계 계산 & STATUS ICON 설정
    PERFORM CALCULATION_DATA.

* -- 5. 화면변수(GT_DATA)로 값 전달
*    MOVE-CORRESPONDING GT_BSEG TO GT_DATA.

    " 전기키 테이블로 S/H 구분
    LOOP AT GT_DATA INTO GS_DATA.
      READ TABLE GT_TBSL INTO GS_TBSL WITH KEY BSCHL = GS_DATA-BSCHL.

      GS_DATA-INDI_CD = GS_TBSL-INDI_CD.
      MODIFY GT_DATA FROM GS_DATA.
    ENDLOOP.

    " ALV Refresh
    PERFORM REFRESH_TABLE.


* -- 금액 필드 초기화
    CLEAR: ZEA_BSEG-DMBTR. " 금액필드 초기화
*    CLEAR: ZEA_BSEG-SAKNR. " GL계정
*    CLEAR: ZEA_TBSL-BSCHL. " 전기키 초기화
*    " ==> 얘네 TXT 초기화 안됨....
*    ZEA_BSEG-GLTXT = ''. " GLTXT 초기화
*    ZEA_TBSL-BSTXT = ''. " BSTXT 초기화
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form NUMBER_ZEA_BELNR
*& 전표번호 RANGE 변수 생성
*&---------------------------------------------------------------------*
FORM NR_ZEA_BELNR CHANGING CV_BELNR_NUMBER.

  DATA: LV_RC TYPE INRI-RETURNCODE.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      NR_RANGE_NR             = '01'          " NR에 지정한 No
      OBJECT                  = 'ZEA_BELNR'   " number range obj 명
    IMPORTING
      NUMBER                  = CV_BELNR_NUMBER
      RETURNCODE              = LV_RC         " 저장할 변수.
    EXCEPTIONS
      INTERVAL_NOT_FOUND      = 1
      NUMBER_RANGE_NOT_INTERN = 2
      OBJECT_NOT_FOUND        = 3
      QUANTITY_IS_0           = 4
      QUANTITY_IS_NOT_1       = 5
      INTERVAL_OVERFLOW       = 6
      BUFFER_OVERFLOW         = 7
      OTHERS                  = 8.
  IF SY-SUBRC <> 0.
  ENDIF.
*  WRITE: CV_BELNR_NUMBER.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CALCULATION_DATA
*&---------------------------------------------------------------------*
FORM CALCULATION_DATA .

  REFRESH GT_TBSL.
  CLEAR GS_TBSL.

  SELECT * FROM ZEA_TBSL INTO TABLE GT_TBSL.

* -- 전기키 테이블로 차/대 구분
  READ TABLE GT_TBSL INTO GS_TBSL WITH KEY BSCHL = ZEA_BSEG-BSCHL.

* -- 세금 계산 (KRW, 외화코드 반영 O)
  IF S0100-TAX EQ ABAP_ON AND ZEA_BSEG-D_WAERS EQ 'KRW'. " 10% 부가세 라인을 한 줄 더 생성한다.
    CASE GS_TBSL-INDI_CD.
      WHEN 'S'.
        " 전표Line 추가
        GV_ITNUM = GV_ITNUM + 1.
        GS_DATA-ITNUM = GV_ITNUM.
        GS_DATA-BSCHL = ZEA_BSEG-BSCHL.
        GS_DATA-SAKNR = '210200'. " 부가세 예수금 (매출 - S)
        GS_DATA-GLTXT = '부가세 예수금'.
        GS_DATA-DMBTR = ZEA_BSEG-DMBTR / 10.
        GS_DATA-D_WAERS = ZEA_BSEG-D_WAERS.
        GS_DATA-WRBTR = ZEA_BSEG-DMBTR / 10.
        GS_DATA-W_WAERS = 'KRW'.
        APPEND GS_DATA TO GT_DATA.

      WHEN 'H'.
        " 전표Line 추가
        GV_ITNUM = GV_ITNUM + 1.
        GS_DATA-ITNUM = GV_ITNUM.
        GS_DATA-BSCHL = ZEA_BSEG-BSCHL.
        GS_DATA-SAKNR = '210210'. " 부가세 대급금 (매입 - H)
        GS_DATA-GLTXT = '부가세 대급금'.
        GS_DATA-DMBTR = ZEA_BSEG-DMBTR / 10.
        GS_DATA-D_WAERS = ZEA_BSEG-D_WAERS.
        GS_DATA-WRBTR = ZEA_BSEG-DMBTR / 10.
        GS_DATA-W_WAERS = 'KRW'.
        APPEND GS_DATA TO GT_DATA.
    ENDCASE.

    " 통화코드가 KRW 가 아닐 경우, 세금도 원화환산이 필요하다.
  ELSEIF S0100-TAX EQ ABAP_ON AND ZEA_BSEG-D_WAERS NE 'KRW'.

    CASE GS_TBSL-INDI_CD.
      WHEN 'S'.
        " 전표Line 추가
        GV_ITNUM = GV_ITNUM + 1.
        GS_DATA-ITNUM = GV_ITNUM.
        GS_DATA-BSCHL = ZEA_BSEG-BSCHL.
        GS_DATA-SAKNR = '210200'. " 부가세 예수금 (매출 - S)
        GS_DATA-GLTXT = '부가세 예수금'.
        GS_DATA-DMBTR = ZEA_BSEG-DMBTR / 10.
        GS_DATA-D_WAERS = ZEA_BSEG-D_WAERS.
        GS_DATA-WRBTR = ( ZEA_BSEG-DMBTR * GS_TCURR-UKURS / 100 ) / 10.
        GS_DATA-W_WAERS = 'KRW'.
        APPEND GS_DATA TO GT_DATA.

      WHEN 'H'.
        " 전표Line 추가
        GV_ITNUM = GV_ITNUM + 1.
        GS_DATA-ITNUM = GV_ITNUM.
        GS_DATA-BSCHL = ZEA_BSEG-BSCHL.
        GS_DATA-SAKNR = '210210'. " 부가세 대급금 (매입 - H)
        GS_DATA-GLTXT = '부가세 대급금'.
        GS_DATA-DMBTR = ZEA_BSEG-DMBTR / 10.
        GS_DATA-D_WAERS = ZEA_BSEG-D_WAERS.
        GS_DATA-WRBTR = ( ZEA_BSEG-DMBTR * GS_TCURR-UKURS / 100 ) / 10.
        GS_DATA-W_WAERS = 'KRW'.
        APPEND GS_DATA TO GT_DATA.
    ENDCASE.
  ENDIF.

  " 차변합계 / 대변합계 구하는 로직
  CASE GS_TBSL-INDI_CD.
    WHEN 'S'.
      CASE S0100-TAX.
        WHEN ABAP_ON.
          S0100-SUM_S = S0100-SUM_S + ( ZEA_BSEG-DMBTR * 11 / 10 ).
        WHEN OTHERS.
          S0100-SUM_S = S0100-SUM_S + ZEA_BSEG-DMBTR.
      ENDCASE.
    WHEN 'H'.
      CASE S0100-TAX.
        WHEN ABAP_ON.
          S0100-SUM_H = S0100-SUM_H + ( ZEA_BSEG-DMBTR * 11 / 10 ).
        WHEN OTHERS.
          S0100-SUM_H = S0100-SUM_H + ZEA_BSEG-DMBTR.
      ENDCASE.
  ENDCASE.

  S0100-DIFFERENC = S0100-SUM_S - S0100-SUM_H.

* -- icon 설정
  IF  S0100-DIFFERENC = 0.
    CALL FUNCTION 'ICON_CREATE'
      EXPORTING
        NAME                  = ICON_LED_GREEN
        TEXT                  = '대차 일치'
      IMPORTING
        RESULT                = STATUS_ICON
      EXCEPTIONS
        ICON_NOT_FOUND        = 1 " Icon name unknown to system
        OUTPUTFIELD_TOO_SHORT = 2 " Length of field 'RESULT' is too small
        OTHERS                = 3.

  ELSE.
    CALL FUNCTION 'ICON_CREATE'
      EXPORTING
        NAME                  = ICON_LED_RED
        TEXT                  = '대차 불일치'
      IMPORTING
        RESULT                = STATUS_ICON
      EXCEPTIONS
        ICON_NOT_FOUND        = 1 " Icon name unknown to system
        OUTPUTFIELD_TOO_SHORT = 2. " Length of field 'RESULT' is too small
  ENDIF.

  MODIFY SCREEN.
  PERFORM REFRESH_TABLE.

**  -- 전표 자동 저장
*  IF S0100-SUM_S NE 0 AND S0100-SUM_H NE 0 AND S0100-DIFFERENC = 0.
*    OK_CODE = 'SAVE'.
*    PERFORM SAVE_ALL_DATA.
*  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH_TABLE
*&---------------------------------------------------------------------*
FORM REFRESH_TABLE .
  CALL METHOD GO_ALV_GRID->REFRESH_TABLE_DISPLAY( ).
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SAVE_TABLE
*& 차/대변 일치 시에만 저장이 가능하다.
*&---------------------------------------------------------------------*
FORM SAVE_TABLE .

  CALL METHOD GO_ALV_GRID->CHECK_CHANGED_DATA. " 바뀐 데이터 여부 체크

  MOVE-CORRESPONDING GT_DATA TO GT_BSEG.

  PERFORM NR_ZEA_BELNR CHANGING GV_BELNR_NUMBER. " NR_전표번호 부여

  " 100번 스크린에 값을 전달
  ZEA_BKPF-BELNR = GV_BELNR_NUMBER. " 전표번호 Range
  ZEA_BSEG-BELNR = GV_BELNR_NUMBER. " 전표번호 Range

  " 내부 변수에 채번된 전표번호 값 전달
  GS_BKPF-BELNR = GV_BELNR_NUMBER. " 헤더
  LOOP AT GT_BSEG INTO GS_BSEG.    " 아이템
    GS_BSEG-BELNR = GV_BELNR_NUMBER.
    MODIFY GT_BSEG FROM GS_BSEG.
  ENDLOOP.

  MODIFY ZEA_BKPF FROM GS_BKPF.       " 헤더 테이블
  MODIFY ZEA_BSEG FROM TABLE GT_BSEG. " 아이템 테이블

* --  전표유형에 따라 고객원장/벤더원장 테이블로 데이터 저장
* ZEA_FIT700 : 'D*'.
* ZEA_FIT800 : 'K*'.
  CASE GS_BKPF-BLART.
    WHEN 'DA' OR 'DG' OR 'DR' OR 'DX' OR 'DZ'.
      LOOP AT GT_BSEG INTO GS_BSEG.
        MOVE-CORRESPONDING GS_DATA TO GS_FIT700.
        GS_FIT700-CUSCODE = GS_BSEG-BPCODE.
        GS_FIT700-BLART   = GS_BKPF-BLART.
        GS_FIT700-BLDAT   = GS_BKPF-BLDAT.
        GS_FIT700-BUDAT   = GS_BKPF-BUDAT.
        MODIFY ZEA_FIT700 FROM GS_FIT700. " 아이템 테이블 => 고객원장'
      ENDLOOP.

    WHEN 'KA' OR 'KG' OR 'KN' OR 'KP' OR 'KR' OR 'KX' OR 'KZ'.
      LOOP AT GT_BSEG INTO GS_BSEG.
        MOVE-CORRESPONDING GS_DATA TO GS_FIT800.
        GS_FIT800-VENCODE = GS_BSEG-BPCODE.
        GS_FIT700-BLART   = GS_BKPF-BLART.
        GS_FIT700-BLDAT   = GS_BKPF-BLDAT.
        GS_FIT700-BUDAT   = GS_BKPF-BUDAT.
        MODIFY ZEA_FIT800 FROM GS_FIT800. " 아이템 테이블 => 벤더원장'
      ENDLOOP.
  ENDCASE.

  IF SY-SUBRC EQ 0.
    COMMIT WORK AND WAIT.
    MESSAGE S123 WITH GV_BELNR_NUMBER.
*
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CLEAR_ALV
*&---------------------------------------------------------------------*
FORM CLEAR_ALV .
*  CALL METHOD GO_ALV_GRID->FREE.
*  CALL METHOD GO_CONTAINER->FREE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHECK_BEFORE_SAVE
*&---------------------------------------------------------------------*
FORM CHECK_BEFORE_SAVE .

  IF S0100-DIFFERENC NE 0.
    " MESSAGE 를 띄우면 로직이 EXIT. 됨.
    MESSAGE 'Error : 대차 불일치로 전표 전기가 불가합니다. 전표를 추가 입력해주세요.' TYPE 'I' DISPLAY LIKE 'E'.
    LEAVE SCREEN.

**    " MESSAGE -> 강제로 PBO를 돌린다.
    CALL METHOD CL_GUI_CFW=>SET_NEW_OK_CODE
      EXPORTING
        NEW_CODE = ''.  " New OK_CODE

  ELSEIF S0100-DIFFERENC EQ 0 AND S0100-SUM_S EQ 0 AND S0100-SUM_H EQ 0.
    MESSAGE 'Error : 전표를 입력해주세요.' TYPE 'I' DISPLAY LIKE 'E'.
    CLEAR : OK_CODE.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DELETE_ITEM_DATA
*&---------------------------------------------------------------------*
FORM DELETE_ITEM_DATA.

  ZEA_BSEG-DMBTR = 0.
* -- 1. itab에 마지막 라인을 읽어온다.
*  READ TABLE GT_BSEG INTO GS_DATA INDEX 1. " <== 첫 번째 행을 가져옴
*  READ TABLE GT_BSEG INTO GS_DATA INDEX 0. " <== 마지막 행을 가져옴

* -- 2. 삭제하시겠습니까? 팝업창?
  _MC_POPUP_CONFIRM '전표 항목 삭제' '입력한 항목을 삭제하시겠습니까?' GV_ANSWER.
  CHECK GV_ANSWER = '1'.

* -- 3. itab에서도 삭제 & 삭제 > 라인-1 반영

  " 방법1. itab : 가장 마지막 라인 삭제 구현
*  SORT GT_BSEG BY ITNUM DESCENDING.

  " 방법2. itab : 내가 선택한 라인 삭제 구현
  DATA: BEGIN OF LS_DEL_KEYS,
          BUKRS   TYPE ZEA_BSEG-BUKRS,
          GJAHR   TYPE ZEA_BSEG-GJAHR,
          ITNUM   TYPE ZEA_BSEG-ITNUM,
*         -- 금액을 삭제해주기 위해 추가한 필드
          DMBTR   TYPE ZEA_BSEG-DMBTR,
          BSCHL   TYPE ZEA_TBSL-BSCHL,   " 전기키
          INDI_CD TYPE ZEA_TBSL-INDI_CD, " 차대구분자
        END OF LS_DEL_KEYS.

  DATA LT_DEL_KEYS LIKE TABLE OF LS_DEL_KEYS.


  DATA LT_INDEX_ROWS TYPE LVC_T_ROW.
  DATA LS_INDEX_ROW LIKE LINE OF LT_INDEX_ROWS.

  CALL METHOD GO_ALV_GRID->GET_SELECTED_ROWS
    IMPORTING
      ET_INDEX_ROWS = LT_INDEX_ROWS     " Indexes of Selected Rows
*     ET_ROW_NO     =                  " Numeric IDs of Selected Rows
    .

  DATA LV_SUBRC TYPE I.
  DATA LV_COUNT TYPE I.
  DATA LV_INDI_CD TYPE C.

  IF LT_INDEX_ROWS[] IS INITIAL.
    MESSAGE S000 DISPLAY LIKE 'W' WITH '최소 한 행이상 선택하세요'.
  ELSE.

    LOOP AT LT_INDEX_ROWS INTO LS_INDEX_ROW WHERE ROWTYPE IS INITIAL.

      READ TABLE GT_DATA INTO GS_DATA INDEX LS_INDEX_ROW-INDEX.

      IF SY-SUBRC EQ 0.
        CLEAR LS_DEL_KEYS.
        MOVE-CORRESPONDING GS_DATA TO LS_DEL_KEYS.
        APPEND LS_DEL_KEYS TO LT_DEL_KEYS.
      ENDIF.
    ENDLOOP.

    " LT_DEL_KEYS : 금액 필드도 함께 담긴다.
    LOOP AT LT_DEL_KEYS INTO LS_DEL_KEYS.
* -- 삭제한 행 읽어오기

      READ TABLE GT_DATA INTO GS_DATA WITH KEY ITNUM = LS_DEL_KEYS-ITNUM.
      MOVE-CORRESPONDING GS_DATA TO ZEA_BSEG.

* -- 전기키 테이블로 S/H 구분

      " 여기서 GS_TBSL 로 삭제되는 전기키 값이 삭제하는 라인이 아닌 값이 들어감 (2024.05.12)
*      READ TABLE GT_TBSL INTO GS_TBSL WITH KEY BSCHL = LS_DEL_KEYS-BSCHL
*                                               BSTXT = LS_DEL_KEYS-BSTXT
*                                               INDI_CD = LS_DEL_KEYS-INDI_CD.
*
*      CASE GS_TBSL-INDI_CD.
*        WHEN 'S'.
*          S0100-SUM_S = S0100-SUM_S - LS_DEL_KEYS-DMBTR.
*        WHEN 'H'.
*          S0100-SUM_H = S0100-SUM_H - LS_DEL_KEYS-DMBTR.
*      ENDCASE.

      " GT_DATA로 변경하여 삭제 테스트 (2024.05.13 - 확인)
      READ TABLE GT_DATA INTO GS_DATA WITH KEY BSCHL = LS_DEL_KEYS-BSCHL " 전기키
                                               INDI_CD = LS_DEL_KEYS-INDI_CD.

      CASE GS_DATA-INDI_CD.
        WHEN 'S'.
          S0100-SUM_S = S0100-SUM_S - LS_DEL_KEYS-DMBTR.
        WHEN 'H'.
          S0100-SUM_H = S0100-SUM_H - LS_DEL_KEYS-DMBTR.
      ENDCASE.


* -- 선택한 행 GT_BSEG itab 에서 삭제
      DELETE GT_DATA
      WHERE BUKRS EQ LS_DEL_KEYS-BUKRS
        AND GJAHR EQ LS_DEL_KEYS-GJAHR
        AND ITNUM EQ LS_DEL_KEYS-ITNUM.

      IF SY-SUBRC NE 0.
        ADD SY-SUBRC TO LV_SUBRC.
      ELSE.
        LV_COUNT += 1.
      ENDIF.
    ENDLOOP.

    " 차액 계산
    S0100-DIFFERENC = S0100-SUM_S - S0100-SUM_H.

    IF LV_SUBRC EQ 0.
      MESSAGE S000 WITH LV_COUNT '건의 데이터가 삭제되었습니다.'.
      GV_ITNUM -= LV_COUNT.
      ZEA_BSEG-SAKNR = GS_DATA-SAKNR.
      PERFORM ICON_CREATE.
      PERFORM REFRESH_TABLE.
    ELSE.
      MESSAGE S000 DISPLAY LIKE 'W' WITH '데이터 삭제를 실패하였습니다.'.
    ENDIF.
  ENDIF.

  CLEAR GS_DATA.
  LOOP AT GT_DATA INTO GS_DATA.
    GS_DATA-ITNUM = SY-TABIX.
    MODIFY GT_DATA FROM GS_DATA TRANSPORTING ITNUM.
  ENDLOOP.



** --   비세그랑 티비랑 조인해가지고 LV_INDI_CD에 값을 가져온다.
*
*    SELECT * FROM ZEA_BSEG AS A
*      JOIN ZEA_TBSL AS B ON B~BSCHL EQ A~BSCHL
*      INTO CORRESPONDING FIELDS OF TABLE GT_TBSL.

* -- 삭제한 행 읽어오기
***  READ TABLE GT_BSEG INTO GS_DATA INDEX LS_INDEX_ROW-INDEX.
***
***  MOVE-CORRESPONDING GS_DATA TO ZEA_BSEG.
***
**** -- 전기키 테이블로 S H 구분
***  READ TABLE GT_TBSL INTO GS_TBSL WITH KEY BSCHL = ZEA_BSEG-BSCHL.
***
***    READ TABLE GT_TBSL INTO GS_TBSL WITH KEY BSCHL = GS_DATA-BSCHL.
***    LV_INDI_CD = GS_TBSL-INDI_CD.
***
***    CASE LV_INDI_CD.
***    WHEN 'S'.
***      S0100-SUM_S = S0100-SUM_S - GS_DATA-DMBTR - GS_DATA-EATAX.
***    WHEN 'H'.
***      S0100-SUM_H = S0100-SUM_H - GS_DATA-DMBTR - GS_DATA-EATAX.
***  ENDCASE.
***



* -- 방법1. 마지막 행 삭제 로직
*  READ TABLE GT_BSEG INTO GS_DATA INDEX 1. " 마지막 행이 담긴다.
*
*  LOOP AT GT_BSEG INTO GS_DATA.
*    IF SY-TABIX = 1. " GS_DATA의 첫 번째 레코드일 경우
*      DELETE GT_BSEG INDEX SY-TABIX.
*      EXIT. " 루프를 종료합니다.
*    ENDIF.
*  ENDLOOP.

* -- 4. 삭제한 라인(마지막 행)은 금액합계에서 차감시켜야 한다.
*  PERFORM CARCULATION_DATA_MINUS_INDEX.


  " 삭제 > 라인-1
*  GV_ITNUM = GV_ITNUM - 1.

  " 금액 초기화
  CLEAR ZEA_BSEG-DMBTR.
  S0100-TAX = ABAP_OFF.

* -- 5. refresh -  ALV Refresh
  PERFORM REFRESH_TABLE.


*  -- 6. PBO 돌리기
  CALL METHOD CL_GUI_CFW=>SET_NEW_OK_CODE
    EXPORTING
      NEW_CODE = 'ENTER'.               " New OK_CODE

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_SAVE_DATA
*&---------------------------------------------------------------------*
FORM DISPLAY_SAVE_DATA .
* --  데이터가 저장이 되었는지 확인 ( 미저장된 상태에서는 조회불가 )
  IF GV_ANSWER NE '1'.
    MESSAGE '전표를 저장한 후 조회가 가능합니다.' TYPE 'I' DISPLAY LIKE 'E'.
  ENDIF.

  CHECK GV_ANSWER = '1'.

* -- ZEA_GL_DIS 트랜잭션 호출 - 전달 값은 ? 회사코드 전표번호
*      CALL TRANSACTION ZEA_GL_DIS.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CARCULATION_DATA_MINUS_INDEX
*&---------------------------------------------------------------------*
FORM CARCULATION_DATA_MINUS_INDEX .
****
****  " 차/대변 합계 계산 & STATUS ICON 설정
****  PERFORM CALCULATION_DATA.

* -- 삭제한 행 읽어오기
  READ TABLE GT_BSEG INTO GS_DATA INDEX 1.

  MOVE-CORRESPONDING GS_DATA TO ZEA_BSEG.

* -- 전기키 테이블로 S H 구분
  READ TABLE GT_TBSL INTO GS_TBSL WITH KEY BSCHL = ZEA_BSEG-BSCHL.

  " 부가세도 함께 빼줘야한다.
  CASE GS_TBSL-INDI_CD.
    WHEN 'S'.
      S0100-SUM_S = S0100-SUM_S - ZEA_BSEG-DMBTR.
    WHEN 'H'.
      S0100-SUM_H = S0100-SUM_H - ZEA_BSEG-DMBTR.
  ENDCASE.
**  CASE ZEA_BSEG-BSCHL.
**    WHEN '40'.
**      S0100-SUM_S = S0100-SUM_S + ZEA_BSEG-DMBTR.
**    WHEN '50'.
**      S0100-SUM_H = S0100-SUM_H + ZEA_BSEG-DMBTR.
**  ENDCASE.

  IF S0100-DIFFERENC NE 0.

    CALL FUNCTION 'ICON_CREATE'
      EXPORTING
        NAME                  = ICON_LED_RED
        TEXT                  = '대차 불일치'
      IMPORTING
        RESULT                = STATUS_ICON
      EXCEPTIONS
        ICON_NOT_FOUND        = 1 " Icon name unknown to system
        OUTPUTFIELD_TOO_SHORT = 2. " Length of field 'RESULT' is too small

  ELSE.

    CALL FUNCTION 'ICON_CREATE'
      EXPORTING
        NAME                  = ICON_LED_GREEN
        TEXT                  = '대차 일치'
      IMPORTING
        RESULT                = STATUS_ICON
      EXCEPTIONS
        ICON_NOT_FOUND        = 1 " Icon name unknown to system
        OUTPUTFIELD_TOO_SHORT = 2 " Length of field 'RESULT' is too small
        OTHERS                = 3.
  ENDIF.
  MODIFY SCREEN.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH_0100
*&---------------------------------------------------------------------*
FORM REFRESH_0100 .
  CLEAR: ZEA_BKPF, ZEA_BSEG, ZEA_SKB1, ZEA_TBSL, S0100.
  REFRESH: GT_BKPF[], GT_BSEG[], GT_TBSL[].

  LOOP AT SCREEN.
    CASE SCREEN-GROUP1.
      WHEN 'GR1'. " INPUT 필드
        SCREEN-INPUT = 1.
      WHEN 'GR2'. " INPUT & REQUIRE 필드
        SCREEN-INPUT = 1.
        SCREEN-REQUIRED = 1.
    ENDCASE.
    MODIFY SCREEN.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form ON_DELETE_DATA
*&---------------------------------------------------------------------*
FORM ON_DELETE_DATA  USING    PO_UCOMM.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SAVE_ALL_DATA
*&---------------------------------------------------------------------*
FORM SAVE_ALL_DATA .

*  -- 발행된 전표번호가가 있는지 확인
  " 전표번호가 발행되었다면 저장버튼을 누른것
  IF ZEA_BKPF-BELNR IS NOT INITIAL.
    MESSAGE '전표가 이미 발행되었습니다. 이전단계에서 전표를 다시 생성해주세요.' TYPE 'I' DISPLAY LIKE 'E'.
*    LEAVE PROGRAM.
  ENDIF.

*  -- 전표번호가 발행되지 않았다면, 신규 생성 데이터.
  CHECK ZEA_BKPF-BELNR IS INITIAL.

* --  차/대변 불일치 시, 에러메세지 (TYEP 'I')
  PERFORM CHECK_BEFORE_SAVE.

* --  합계 일치인지 점검 ( 합계 일치해야만 아래 로직 실행됨 )
  CHECK S0100-SUM_S NE 0 AND S0100-SUM_H NE 0 AND S0100-DIFFERENC EQ 0.

* --  저장여부 팝업창 호출
  _MC_POPUP_CONFIRM 'SAVE' '전표를 발행하시겠습니까?' GV_ANSWER.
  CASE GV_ANSWER.
    WHEN '1'. " YES
* -- 차/대변 일치할 때만  헤더&아이템 테이블 저장
      PERFORM SAVE_TABLE.
      READ TABLE GT_BKPF INTO GS_BKPF INDEX 1.

      SET PARAMETER ID 'ZEA_BELNR' FIELD GS_BSEG-BELNR.
      CALL TRANSACTION 'ZEA_FI020'.
*                  AND SKIP FIRST SCREEN.
    WHEN '2'. " NO

    WHEN OTHERS. " Cancel 일때.

  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form ICON_CREATE
*&---------------------------------------------------------------------*
FORM ICON_CREATE.

  IF S0100-DIFFERENC NE 0.

    CALL FUNCTION 'ICON_CREATE'
      EXPORTING
        NAME                  = ICON_LED_RED
        TEXT                  = '대차 불일치'
      IMPORTING
        RESULT                = STATUS_ICON
      EXCEPTIONS
        ICON_NOT_FOUND        = 1 " Icon name unknown to system
        OUTPUTFIELD_TOO_SHORT = 2. " Length of field 'RESULT' is too small

  ELSE.

    CALL FUNCTION 'ICON_CREATE'
      EXPORTING
        NAME                  = ICON_LED_GREEN
        TEXT                  = '대차 일치'
      IMPORTING
        RESULT                = STATUS_ICON
      EXCEPTIONS
        ICON_NOT_FOUND        = 1 " Icon name unknown to system
        OUTPUTFIELD_TOO_SHORT = 2 " Length of field 'RESULT' is too small
        OTHERS                = 3.
  ENDIF.
  MODIFY SCREEN.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form AMT_CONV_TO_EXTERNAL
*&---------------------------------------------------------------------*
FORM AMT_CONV_TO_EXTERNAL  USING    P_W_WAERS " KRW
                           CHANGING P_DMBTR.  " 금액

***  DATA: L_INTERNAL TYPE BAPICURR-BAPICURR,
***        L_EXTERNAL TYPE BAPICURR-BAPICURR.
***
***  L_INTERNAL = P_DMBTR.  "금액이 들어간다.
***
***  CALL FUNCTION 'BAPI_CURRENCY_CONV_TO_EXTERNAL'
***    EXPORTING
***      CURRENCY        = P_W_WAERS   "통화가 들어간다. KRW 겠지
***      AMOUNT_INTERNAL = L_INTERNAL "100.00이 들어간다.
***    IMPORTING
***      AMOUNT_EXTERNAL = L_INTERNAL. "10000이 나온다.
***
***  P_DMBTR = L_INTERNAL / 100. " 다시 원래 INTERFACE 할 필드에 넣은것이다.



  DATA: L_INTERNAL TYPE BAPICURR-BAPICURR,
        L_EXTERNAL TYPE BAPICURR-BAPICURR.

  L_INTERNAL = P_DMBTR.  " 입력된 금액

  " KRW(대한민국 원)의 경우 소수점 이하 자리를 사용하지 않으므로 * 100 처리하지 않음
  IF P_W_WAERS = 'KRW'.
    CALL FUNCTION 'BAPI_CURRENCY_CONV_TO_EXTERNAL'
      EXPORTING
        CURRENCY        = P_W_WAERS   " 통화 코드 (예: KRW)
        AMOUNT_INTERNAL = L_INTERNAL " 입력된 금액
      IMPORTING
        AMOUNT_EXTERNAL = L_INTERNAL. " 외부 통화로 변환된 금액
  ELSE.
    " 기타 통화는 * 100 처리
    L_INTERNAL = L_INTERNAL * 100.
    CALL FUNCTION 'BAPI_CURRENCY_CONV_TO_EXTERNAL'
      EXPORTING
        CURRENCY        = P_W_WAERS   " 통화 코드
        AMOUNT_INTERNAL = L_INTERNAL " 입력된 금액
      IMPORTING
        AMOUNT_EXTERNAL = L_INTERNAL. " 외부 통화로 변환된 금액
  ENDIF.

  " 외부 통화로 변환된 금액을 원래 인터페이스 필드에 할당
  P_DMBTR = L_INTERNAL.




ENDFORM.                                          " AMT_CONV_TO_EXTERNAL
*&---------------------------------------------------------------------*
*& Form BACK
*&---------------------------------------------------------------------*
FORM BACK .
  IF GV_CHANGED EQ ABAP_ON.
    _MC_POPUP_CONFIRM 'SAVE' '변경된 데이터를 저장하시겠습니까?' GV_ANSWER.

    " YES를 누른 경우 DATA_SAVE를 수행
    IF GV_ANSWER EQ '1'.
      PERFORM SAVE_TABLE.
      LEAVE TO SCREEN 0. " 100번 프로그램

      " CANCEL을 누른 경우 로직을 수행하지 않는다.
    ELSEIF GV_ANSWER EQ 'A'.
    ELSE.
      " NO를 누른경우 이전 화면으로 돌아간다.
      LEAVE TO SCREEN 0.
    ENDIF.

  ELSE.
    LEAVE TO SCREEN 0.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form INPUT_CHECK
*&---------------------------------------------------------------------*
FORM INPUT_CHECK .

  DATA : LV_BSCHL TYPE ZEA_TBSL-BSCHL.

  SELECT SINGLE BSCHL FROM ZEA_TBSL INTO LV_BSCHL
    WHERE BSCHL EQ ZEA_TBSL-BSCHL.

  " 현재 떠있는 화면에서 특정 필드의 값을 읽어오는 함수 및 방법
*  CALL FUNCTION 'DYNP_VALUES_READ'
*    EXPORTING
*      DYNAME     = 'ZEA_FI030'         " 화면이 소속된 프로그램 명
*      DYNUMB     = SY-DYNNR            " 화면 번호
*    TABLES
*      DYNPFIELDS = ZEA_TBSL-BSCHL       " export : 읽어들일 필드 명
*      " import : 준 필드 명의 값
*    EXCEPTIONS
*      OTHERS     = 01.

*  IF LV_BSCHL IS INITIAL.
*    MESSAGE '올바른 전기키를 입력해주세요' TYPE 'E'.
*
*    CALL FUNCTION 'SAPGUI_SET_FUNCTIONCODE'
*      EXPORTING
*        FUNCTIONCODE           = ''
*      EXCEPTIONS
*        FUNCTION_NOT_SUPPORTED = 1
*        OTHERS                 = 2.
*
*  ENDIF.

  " 화면 : ZEA_TBSL-BSCHL

ENDFORM. " INPUT_CHECK= 전기키 값 체크
*&---------------------------------------------------------------------*
*& Form HANDLE_TOOLBAR
*&---------------------------------------------------------------------*
FORM HANDLE_TOOLBAR  USING PO_OBJECT TYPE REF TO CL_ALV_EVENT_TOOLBAR_SET
                           PO_SENDER TYPE REF TO CL_GUI_ALV_GRID.

  DATA LS_TOOLBAR LIKE LINE OF PO_OBJECT->MT_TOOLBAR.


  CASE PO_SENDER.
    WHEN GO_ALV_GRID.

      " 구분자
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 3.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

      " 버튼 추가
*      CLEAR LS_TOOLBAR.
*      LS_TOOLBAR-BUTN_TYPE = 0.
*      LS_TOOLBAR-FUNCTION = 'FC_ADD'.
*      LS_TOOLBAR-TEXT = TEXT-L01. " 항목 추가
*      LS_TOOLBAR-ICON = ICON_INSERT_ROW. " 항목 추가
*      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 0.
      LS_TOOLBAR-FUNCTION = 'FC_DEL'.
      LS_TOOLBAR-TEXT = TEXT-L02. " 항목 삭제
      LS_TOOLBAR-ICON = ICON_DELETE_ROW. " 항목 삭제
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

  ENDCASE.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_USER_COMMAND
*&---------------------------------------------------------------------*
FORM HANDLE_USER_COMMAND USING PV_UCOMM  TYPE SY-UCOMM
                               PO_SENDER TYPE REF TO CL_GUI_ALV_GRID.

  CASE PO_SENDER.
    WHEN GO_ALV_GRID.
      CASE PV_UCOMM.
*        WHEN 'FC_ADD'.
*          PERFORM SAVE_ITEM_DATA.
        WHEN 'FC_DEL'.
          OK_CODE = 'FC_DEL'.
          PERFORM DELETE_ITEM_DATA.
      ENDCASE.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_300
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT_300 .

  CREATE OBJECT GO_CONTAINER300
    EXPORTING
      CONTAINER_NAME = 'CCON'
    EXCEPTIONS
      OTHERS         = 1.
  IF SY-SUBRC <> 0.
  ENDIF.

  CREATE OBJECT GO_ALV_GRID300
    EXPORTING
      I_PARENT = GO_CONTAINER300
    EXCEPTIONS
      OTHERS   = 1.
  IF SY-SUBRC <> 0.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_300
*&---------------------------------------------------------------------*
FORM DISPLAY_300 .

  GS_VARIANT-REPORT = SY-REPID.
  GV_SAVE = 'A'.

  GO_ALV_GRID300->SET_TABLE_FOR_FIRST_DISPLAY(
    EXPORTING
      I_STRUCTURE_NAME              = 'ZEA_SKA1'
      I_SAVE          = GV_SAVE                 " Save Layout
      IS_LAYOUT       = GS_LAYOUT                 " Layout
    CHANGING
      IT_OUTTAB                     = GT_SKA1                 " Output Table
*      IT_FIELDCATALOG               =                  " Field Catalog
    EXCEPTIONS
      OTHERS                        = 1
  ).
  IF SY-SUBRC <> 0.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_LAYOUT_300
*&---------------------------------------------------------------------*
FORM SET_ALV_LAYOUT_300 .
  GS_LAYOUT-ZEBRA = ABAP_ON.
  GS_LAYOUT-SEL_MODE = 'D'.
  GS_LAYOUT-CWIDTH_OPT = ABAP_ON.
ENDFORM.
