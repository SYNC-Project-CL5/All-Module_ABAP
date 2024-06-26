*&---------------------------------------------------------------------*
*& Include          ZEA_GL_DISPLAY_PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.
  CASE OK_CODE.
*    WHEN 'BACK'.
*      LEAVE TO SCREEN 0200.

* --  Item itab 데이터 저장 / 엔터시에도 저장
*    WHEN 'FC_ADD'.
    WHEN ''.
      PERFORM SAVE_ITEM_DATA.

* -- 사용 설명
    WHEN 'INFO'.
      CALL SCREEN 0150 STARTING AT 5 5.

  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT_0200  INPUT
*&---------------------------------------------------------------------*
MODULE EXIT_0200 INPUT.
  CASE OK_CODE.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'CANC'.
      LEAVE TO SCREEN 0.
    WHEN 'AUTO'.
      CALL TRANSACTION 'ZEA_FI070'.
* -- 환율 조회
    WHEN 'UKURS'.
      CALL TRANSACTION 'ZEA_FI050_TCURR'.
* -- 사용 설명
    WHEN 'INFO'.
      CALL SCREEN 0250 STARTING AT 5 5.
* -- BP Master
    WHEN 'BP'.
      CALL SCREEN 0300 STARTING AT 5 5.

  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT_0100  INPUT
*&---------------------------------------------------------------------*
MODULE EXIT_0100 INPUT.
  CASE OK_CODE.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'CANC'.
      LEAVE TO SCREEN 0.

* --  ZEA_BSEG 테이블에 값 저장
    WHEN 'SAVE'.
      PERFORM SAVE_ALL_DATA.

* --  Item itab 데이터 삭제
    WHEN 'FC_DEL'.
      PERFORM DELETE_ITEM_DATA.

* -- 환율 조회
    WHEN 'UKURS'.
      CALL TRANSACTION 'ZEA_FI050_TCURR'.
* -- 사용 설명
    WHEN 'INFO'.
      CALL SCREEN 0150 STARTING AT 5 5.
* -- BP Master
    WHEN 'BP'.
      CALL SCREEN 0300 STARTING AT 5 5.

  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
MODULE USER_COMMAND_0200 INPUT.

  CASE OK_CODE.
    WHEN ''.
      " 여기서 RECON 입력 값은 해당 로직을 타지 않는다.
      MOVE-CORRESPONDING ZEA_BKPF TO GS_BKPF.
      PERFORM INPUT_CHECK. " 전기키 값 체크

    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
      " 현재화면에 머무르도록
      LEAVE TO SCREEN 200.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_BSCHL  INPUT
*&---------------------------------------------------------------------*
MODULE CHECK_BSCHL INPUT.
*  ZEA_TBSL-BSCHL " 전기키
  SELECT * FROM ZEA_TBSL
    INTO TABLE GT_TBSL
    WHERE BSCHL EQ ZEA_TBSL-BSCHL.

  IF GT_TBSL[] IS INITIAL.
    MESSAGE '올바른 전기키를 선택해주세요' TYPE 'E'.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_ENTER  INPUT
*&---------------------------------------------------------------------*
MODULE CHECK_ENTER INPUT.

  IF OK_CODE EQ 'SAVE'.
    PERFORM CHECK_BEFORE_SAVE.
  ENDIF.

  CHECK OK_CODE NE 'SAVE'.

  READ TABLE GT_DATA INTO GS_DATA INDEX 0. " 마지막 줄을 읽어와서,

  " 화면의 입력한 값이 마지막 줄 GL코드/전기키 다를때만 아래 로직이 실행되도록 CHECK
  CHECK GS_DATA-SAKNR NE ZEA_BSEG-SAKNR
    OR GS_DATA-BSCHL NE ZEA_TBSL-BSCHL
    AND OK_CODE EQ ''.


* -- 엔터 시, 0인 금액이 들어가지 않도록 Message
  IF ZEA_BSEG-DMBTR EQ 0 AND S0100-DIFFERENC EQ 0 AND OK_CODE = ''.
    MESSAGE '금액을 입력해주세요' TYPE 'E'.
  ENDIF.

* -- Tax 박스 체크 후 엔터 시,입력 값을 막음
  IF ZEA_BSEG-DMBTR EQ 0  AND S0100-TAX EQ ABAP_ON.
    MESSAGE '금액을 입력해주세요' TYPE 'E'.
    EXIT.
  ENDIF.

* -- 엔터 시, 다른 Indicator 에서만 차액 금액이 들어가도록 Message
  IF ZEA_BSEG-DMBTR EQ 0 AND S0100-DIFFERENC > 0 AND OK_CODE = '' . " 차변이 크다

    " 화면에 입력한 전기키가 대변이면
    " 엔터 시, 차액이 들어가도록 로직

    " 1. 화면에 입력한 전기키와 일치하는 한 줄의 데이터를 읽어온다.
    READ TABLE GT_TBSL INTO GS_TBSL WITH KEY BSCHL = ZEA_TBSL-BSCHL.

    " 2. 전기키가 H 이여야만 공백 입력 시, 차액 입력 가능하도록
    CASE GS_TBSL-INDI_CD.
      WHEN 'H'.
*        IF S0100-TAX EQ 'X'.
*          ZEA_BSEG-DMBTR = ABS( S0100-DIFFERENC * 9 / 10 ).
*        ELSE.
        ZEA_BSEG-DMBTR = ABS( S0100-DIFFERENC ).
*        ENDIF.
      WHEN 'S'.
        MESSAGE '금액을 입력해주세요' TYPE 'E'.
        EXIT.
    ENDCASE.

  ELSEIF ZEA_BSEG-DMBTR EQ '0' AND S0100-DIFFERENC < 0 AND OK_CODE = ''. " 대변이 크다

    READ TABLE GT_TBSL INTO GS_TBSL WITH KEY BSCHL = ZEA_TBSL-BSCHL.

    CASE GS_TBSL-INDI_CD.
      WHEN 'S'.
*        IF S0100-TAX EQ 'X'.
*          ZEA_BSEG-DMBTR = ABS( S0100-DIFFERENC * 9 / 10 ).
*        ELSE.
        ZEA_BSEG-DMBTR = ABS( S0100-DIFFERENC ).
*        ENDIF.
      WHEN 'H'.
        MESSAGE '금액을 입력해주세요' TYPE 'E'.
    ENDCASE.
    EXIT.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0150 OUTPUT
*&---------------------------------------------------------------------*
MODULE STATUS_0150 OUTPUT.
  SET PF-STATUS 'S0150'.
  SET TITLEBAR 'T0150'. " 전표 생성 프로그램 사용 설명서
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0150  INPUT
*&---------------------------------------------------------------------*
MODULE USER_COMMAND_0150 INPUT.
  CASE OK_CODE.
    WHEN 'OKAY'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT_0150  INPUT
*&---------------------------------------------------------------------*
MODULE EXIT_0150 INPUT.
  CASE OK_CODE.
    WHEN 'CANC'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F4_BSCHL  INPUT
*&---------------------------------------------------------------------*
MODULE F4_BSCHL INPUT.

  DATA LT_RETURN TYPE TABLE OF DDSHRETVAL.

  CALL FUNCTION 'F4IF_FIELD_VALUE_REQUEST'
    EXPORTING
      TABNAME           = 'ZEA_TBSL'                 " Table/structure name from Dictionary
      FIELDNAME         = 'BSCHL'                 " Field name from Dictionary
      SEARCHHELP        = 'ZEA_SHOW_BSTXT'        " Search help as screen field attribute
*     SHLPPARAM         = SPACE            " Search help parameter in screen field
*     DYNPPROG          = SPACE            " Current program
*     DYNPNR            = SPACE            " Screen number
*     DYNPROFIELD       = SPACE            " Name of screen field for value return
*     STEPL             = 0                " Steploop line of screen field
*     VALUE             = SPACE            " Field contents for F4 call
*     MULTIPLE_CHOICE   = SPACE            " Switch on multiple selection
*     DISPLAY           = SPACE            " Override readiness for input
*     SUPPRESS_RECORDLIST = SPACE            " Skip display of the hit list
*     CALLBACK_PROGRAM  = SPACE            " Program for callback before F4 start
*     CALLBACK_FORM     = SPACE            " Form for callback before F4 start (-> long docu)
*     CALLBACK_METHOD   =                  " Interface for Callback Routines
*     SELECTION_SCREEN  = SPACE            " Behavior as in Selection Screen (->Long Docu)
*    IMPORTING
*     USER_RESET        =                  " Single-Character Flag
    TABLES
      RETURN_TAB        = LT_RETURN                 " Return the selected value
    EXCEPTIONS
      FIELD_NOT_FOUND   = 1                " Field does not exist in the Dictionary
      NO_HELP_FOR_FIELD = 2                " No F4 help is defined for the field
      INCONSISTENT_HELP = 3                " F4 help for the field is inconsistent
      NO_VALUES_FOUND   = 4                " No values found
      OTHERS            = 5.

  IF SY-SUBRC EQ 0.

    READ TABLE LT_RETURN INTO DATA(LS_RETURN) INDEX 1.

    CLEAR ZEA_TBSL.

    SELECT SINGLE *
      FROM ZEA_TBSL
     WHERE BSCHL EQ LS_RETURN-FIELDVAL.

    LEAVE SCREEN.

  ELSE..
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_SAKNR  INPUT
*&---------------------------------------------------------------------*
MODULE CHECK_SAKNR INPUT.

* -- 전기키 점검
  " 채권(AR) 범위
  IF ZEA_TBSL-BSCHL BETWEEN '01' AND '19'.
    IF ZEA_BSEG-SAKNR NOT BETWEEN '20001' AND '20006'.
      " 오류
      MESSAGE '계정오류: 고객코드(20001 ~ 20006) 를 입력하세요.' TYPE 'E'.
    ELSE.
      " 성공 - GL코드는 매핑되는 GL계정을 넣어준다. 고객코드는 거래처코드에 넣어준다.
      SELECT SINGLE * FROM ZEA_SKB1
        INTO GS_SKB1
        WHERE BPCODE EQ ZEA_BSEG-SAKNR
          AND RECON_YN EQ 'X'.
      ZEA_BSEG-SAKNR = GS_SKB1-SAKNR.
      ZEA_BSEG-BPCODE = GS_SKB1-BPCODE.

      MOVE-CORRESPONDING ZEA_BKPF TO GS_BKPF.
      PERFORM INPUT_CHECK. " 전기키 값 체크
      LEAVE SCREEN.
    ENDIF.

    " 채권(AP) 범위
  ELSEIF ZEA_TBSL-BSCHL BETWEEN '20' AND '39'.
    IF ZEA_BSEG-SAKNR EQ '50000' OR
       ZEA_BSEG-SAKNR EQ '50100' OR
       ZEA_BSEG-SAKNR EQ '50200' OR
       ZEA_BSEG-SAKNR EQ '50300' OR
       ZEA_BSEG-SAKNR EQ '50400' OR
       ZEA_BSEG-SAKNR EQ '50500' OR
       ZEA_BSEG-SAKNR EQ '50600' OR
       ZEA_BSEG-SAKNR EQ '50700' OR
       ZEA_BSEG-SAKNR EQ '50800' OR
       ZEA_BSEG-SAKNR EQ '50900'.

      " 성공 - GL코드는 매핑되는 GL계정을 넣어준다. 고객코드는 거래처코드에 넣어준다.
      SELECT SINGLE * FROM ZEA_SKB1
        INTO GS_SKB1
        WHERE BPCODE EQ ZEA_BSEG-SAKNR
          AND RECON_YN EQ 'X'.
      ZEA_BSEG-SAKNR = GS_SKB1-SAKNR.
      ZEA_BSEG-BPCODE = GS_SKB1-BPCODE.

      MOVE-CORRESPONDING ZEA_BKPF TO GS_BKPF.
      PERFORM INPUT_CHECK. " 전기키 값 체크
      LEAVE SCREEN.

    ELSE.
      " 오류
      MESSAGE '계정오류: 벤더코드(50000 ~ 50900) 를 입력하세요. 벤더코드는 100번 단위로 증가합니다.' TYPE 'E'.
    ENDIF.

  ELSE.
    " 이 외 범위에서는 G/L코드만 들어갈 수 있도록.
    DATA: LV_SAKNR TYPE ZEA_BSEG-SAKNR.
    SELECT SINGLE SAKNR FROM ZEA_SKB1 INTO LV_SAKNR
      WHERE SAKNR EQ ZEA_BSEG-SAKNR.

    IF ZEA_BSEG-SAKNR EQ '10000'
      OR ZEA_BSEG-SAKNR EQ '10001'
      OR ZEA_BSEG-SAKNR EQ '10002'
      OR ZEA_BSEG-SAKNR EQ '10003'
      OR ZEA_BSEG-SAKNR EQ '10004'
      OR ZEA_BSEG-SAKNR EQ '10005'
      OR ZEA_BSEG-SAKNR EQ '10006'
      OR ZEA_BSEG-SAKNR EQ '10007'
      OR ZEA_BSEG-SAKNR EQ '10008'
      OR ZEA_BSEG-SAKNR EQ '10009'.

      CLEAR: GS_SKB1.
      SELECT * FROM ZEA_SKB1
        INTO TABLE GT_SKB1
        WHERE BPCODE EQ ZEA_BSEG-SAKNR
          AND RECON_YN EQ 'X'.

      READ TABLE GT_TBSL INTO GS_TBSL WITH KEY BSCHL = ZEA_TBSL-BSCHL.
      CASE GS_TBSL-INDI_CD.
          " 전기기카 차변이면, 제품 계정
        WHEN 'S'.
          CLEAR GS_SKB1.
          SELECT SINGLE * FROM ZEA_SKB1
           INTO GS_SKB1
           WHERE BPCODE EQ ZEA_BSEG-SAKNR
             AND XBILK EQ 'X'
             AND RECON_YN EQ 'X'.

          " 거래처 필드로 이동
          GS_DATA-WERKS = ZEA_BSEG-SAKNR.
          ZEA_BSEG-WERKS = ZEA_BSEG-SAKNR.
          ZEA_BSEG-SAKNR  = GS_SKB1-SAKNR.
          LEAVE SCREEN.

          " 전기키가 대변이면, 제품매출 계정
        WHEN 'H'.

          CLEAR GS_SKB1.
          SELECT SINGLE * FROM ZEA_SKB1
           INTO GS_SKB1
           WHERE BPCODE EQ ZEA_BSEG-SAKNR
             AND XBILK NE 'X'
             AND RECON_YN EQ 'X'.

          " 거래처 필드 X -> 플랜트 필드로 이동
          GS_DATA-WERKS = ZEA_BSEG-SAKNR.
          ZEA_BSEG-WERKS = ZEA_BSEG-SAKNR.
          ZEA_BSEG-SAKNR  = GS_SKB1-SAKNR.
          LEAVE SCREEN.

      ENDCASE.
      " 거래처 필드로 이동
      ZEA_BSEG-BPCODE = ZEA_BSEG-SAKNR.
      ZEA_BSEG-SAKNR  = GS_SKB1-SAKNR.
      LEAVE SCREEN.

    ELSEIF ( ZEA_BSEG-SAKNR NOT BETWEEN '10000' AND '10009' ) AND SY-SUBRC NE 0.
      " 오류
      MESSAGE '계정오류: 올바른 G/L 계정을 입력하세요.' TYPE 'E'.
    ENDIF.
  ENDIF.


*  -- GL코드 점검
  " 1. 입력한 GL코드가 BP코드가 연결된 GL코드이면은 막는다.
  " 대신 직영점 매출액 계정은 입력가능해야한다.
*  IF ZEA_BSEG-SAKNR BETWEEN '10000' AND '10009'.
*
*    CLEAR: GS_SKB1.
*    SELECT SINGLE * FROM ZEA_SKB1
*      INTO GS_SKB1
*      WHERE BPCODE NE ZEA_BSEG-SAKNR
*        AND RECON_YN EQ 'X'.
*
*    " 거래처 필드로 이동
*    ZEA_BSEG-BPCODE = ZEA_BSEG-SAKNR.
*    ZEA_BSEG-SAKNR  = GS_SKB1-SAKNR.
*    LEAVE SCREEN.
*
*  ELSE.

  CLEAR: GS_SKB1.
  SELECT SINGLE * FROM ZEA_SKB1
    INTO GS_SKB1
    WHERE SAKNR EQ ZEA_BSEG-SAKNR
      AND BPCODE NE ''
      AND RECON_YN EQ 'X'.

  " BP코드와 연결된 계정은 조회가 된다 : ZEA_BSEG-SAKNR
  IF GS_SKB1-SAKNR IS NOT INITIAL.
    MESSAGE '계정오류: 입력하신 계정은 AR/AP 관련 계정입니다. 계정을 변경해주세요.' TYPE 'E'.
  ENDIF.
*  ENDIF.

  " 2. 부가세 계정은 입력하지 못하게 막는다.
  CASE ZEA_BSEG-SAKNR.
    WHEN '210210' OR '210200'.
      MESSAGE '계정오류: 입력하신 계정은 부가세 계정입니다. 계정을 변경해주세요.' TYPE 'E'.
  ENDCASE.



ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_SAKNR_TAX  INPUT
*&---------------------------------------------------------------------*
MODULE CHECK_SAKNR_TAX INPUT.

  CHECK OK_CODE NE 'FC_DEL'.

  " 입력한 GL코드가 부가세 계정이라면 막는다.
  CASE ZEA_BSEG-SAKNR.
    WHEN '210200'.
      CLEAR ZEA_BSEG-SAKNR.
      MESSAGE '계정오류: 입력하신 계정은 부가세 계정입니다. 계정을 변경하여 Tax를 선택해주세요.' TYPE 'S' DISPLAY LIKE 'E'.
    WHEN '210210'.
      CLEAR ZEA_BSEG-SAKNR.
      MESSAGE '계정오류: 입력하신 계정은 부가세 계정입니다. 계정을 변경하여 Tax를 선택해주세요.' TYPE 'S' DISPLAY LIKE 'E'.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_BLDAT  INPUT
*&---------------------------------------------------------------------*
MODULE CHECK_BLDAT INPUT.

  IF ZEA_TCURR-GDATU NE SY-DATUM.
    ZEA_BKPF-BLDAT = ZEA_TCURR-GDATU. " 증빙일자 = 환산일자
    MESSAGE '환율기준일에 따라 증빙일자가 변경되었습니다.' TYPE 'S'.
  ENDIF.

ENDMODULE.
