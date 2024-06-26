*&---------------------------------------------------------------------*
*& Include          ZMEETROOMI01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.


  CALL METHOD GO_ALV_GRID->CHECK_CHANGED_DATA.
  CASE OK_CODE.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.

*--- About A/P Pay
    WHEN 'PAY_NOW'.   "지급 처리 버튼 선택 시
      PERFORM PAY.

*--- Send To Vendor, Clearing Mail
    WHEN 'SEND_MAIL'.
      PERFORM CHECK_LINE CHANGING VENCODE. "입력값 확인

*--- Display Mail record
    WHEN 'SOST'.
      PERFORM CALL_SOST.


    WHEN 'CALL_CRAT'.

      DATA PA_TCURR TYPE ZEA_TCURR-TCURR.
      PA_TCURR = 'USD'.
*      ZEA_TCURR-TCURR = 'USD'.

      SUBMIT ZEA_FI050_TCURR WITH PA_TCURR = PA_TCURR
       AND RETURN.

  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE EXIT INPUT.

*--- Back AND Cancel Button
  CASE OK_CODE.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'CANC'.
      LEAVE TO SCREEN 0.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT_0200  INPUT
*&---------------------------------------------------------------------*
MODULE EXIT_0200 INPUT.
  CASE OK_CODE.
    WHEN 'CANC'.

      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          TITLEBAR       = '대금 지급 처리'
          TEXT_QUESTION  = '팝업창을 닫으시겠습니까? '
          TEXT_BUTTON_1  = 'yes'
*         DISPLAY_CANCEL_BUTTON = 'X'
          START_COLUMN   = 25
          START_ROW      = 6
        IMPORTING
          ANSWER         = GV_ANSWER
        EXCEPTIONS
          TEXT_NOT_FOUND = 1
          OTHERS         = 2.
      IF GV_ANSWER EQ '1'.    " - - - - NO
*---- 취소 메세지
        MESSAGE S000 DISPLAY LIKE 'W' WITH '팝업창을 닫았습니다.'.
        CLEAR GT_DATA3.

        PERFORM REFRESH_ALV2_0100.
        PERFORM REFRESH_ALV_0100.
        PERFORM REFRESH_ALV_0200.
        LEAVE TO SCREEN 0.
      ENDIF.

  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
MODULE USER_COMMAND_0200 INPUT.

  CASE OK_CODE.


    WHEN 'SAVE'.

*---- 1. 지급 처리 진행
      PERFORM SELECT_BACK_SAVE CHANGING GV_EV_BELNR  GV_KR_BELNR.
*      PERFORM MODIFY_DISPLAY_CELL_COL CHANGING GV_EV_BELNR .  " CHANGING GV_EV_BELNR.

*---- 3. ALV REFRESH
      PERFORM REFRESH_ALV2_0100.
      PERFORM REFRESH_ALV_0100.

      LEAVE TO SCREEN 0.      "팝업창 종료

    WHEN 'CACN'.
      CLEAR GT_DATA3.

      PERFORM REFRESH_ALV2_0100.
      PERFORM REFRESH_ALV_0100.
      PERFORM REFRESH_ALV_0200.

      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Form SELECT_BACK_SAVE
*&---------------------------------------------------------------------*
FORM SELECT_BACK_SAVE CHANGING   C_EV_BELNR TYPE ZEA_FIT800-BELNR
                                 C_KR_BELNR TYPE ZEA_FIT800-BELNR.

  " FI 전표 아이템 테이블
  DATA: GT_BSEG TYPE TABLE OF ZEA_BSEG,
        GS_BSEG TYPE ZEA_BSEG.

  DATA :LV_S_SAKNR TYPE ZEA_FIT800-SAKNR,
        LV_H_SAKNR TYPE ZEA_FIT800-SAKNR,
        EV_BELNR   TYPE ZEA_FIT800-BELNR,
        LV_BANK    TYPE ZEA_BKNA-ACCNT,
        LV_DATE    TYPE ZEA_FIT800-BLDAT,    "전기일
        USD_AMOUNT TYPE  ZEA_FIT800-DMBTR,   "USD - 금액
        USD_CURKY  TYPE ZEA_FIT800-D_WAERS,  "USD - CUKY
        KRW_AMOUNT TYPE ZEA_FIT800-WRBTR,    "KRW - 금액
        KRW_CURKY  TYPE ZEA_FIT800-W_WAERS,  "KRW - CUKY
        KR_BELNR   TYPE ZEA_XBLNR .          "KA 전표 번호

  LOOP AT GT_DATA3 INTO GS_DATA3.

**--- 1) A/P Recon 계정
    SELECT SINGLE * FROM ZEA_SKB1 INTO ZEA_SKB1
      WHERE BPCODE EQ GS_DATA3-BPCODE
      AND GLTXT EQ '외상매입금'.

    LV_S_SAKNR = ZEA_SKB1-SAKNR.  "Vendor 의 A/P_Recon
    LV_H_SAKNR = ZEA_BKNA-SAKNR.  "Screen 200의 BP_Recon

*--- 2) 화면 변수와 소통(0200)
    LV_BANK = ZEA_BKNA-ACCNT.       "Bank Account
    LV_DATE = POST_DATE.            "Posting Date

    LV_DATE = SY-DATUM.       "오늘날

    CALL FUNCTION 'ZEA_FI_KZ'
      EXPORTING
        IV_AP_RECON   = LV_S_SAKNR           " G/L 계정 (Recon)
        IV_BUDAT      = LV_DATE              " 전기일자
        IV_PAY_AMOUNT = GS_DATA3-DMBTR       " 전표 내 기록된 매입채무 총액(USD또는KRW)
        IV_D_WAERS    = GS_DATA3-D_WAERS     " 전표 기록 통화코드 (USD또는KRW)
        IV_KRW_AMOUNT = GS_DATA3-WRBTR       " 통화금액(KRW)
        IV_WAERS      = GS_DATA3-W_WAERS     " 현지통화코드 (KRW)
        IV_MBLNR      = GS_DATA3-BELNR       " 참조문서(KA전표번호)
        IV_BANK_SAKNR = LV_H_SAKNR           " G/L 계정 (BANK Recon)
      IMPORTING
        EV_BELNR      = EV_BELNR.            " 전표번호

    IF SY-SUBRC EQ 0 .

*--- 3) KZ전표 생성 후 성공 Message 출력 및 KA전표에 체크
      MESSAGE
      "'(전표번호 :' && EV_BELNR && ')' &&
      '지급 처리가 완료되었습니다.' TYPE 'S'.

*--- BSEG ( 아이템 테이블 )
* KA유형 전표 - 반제여부 필드/반제번호 필드 채우기 위해 GT_BSEG에 담기

      SELECT * FROM ZEA_BSEG
      WHERE BELNR EQ @GS_DATA3-BELNR
      INTO CORRESPONDING FIELDS OF TABLE @GT_BSEG.

      LOOP AT GT_BSEG INTO GS_BSEG.
        GS_BSEG-AUGDT = 'X'.
        GS_BSEG-AUGBL = EV_BELNR.
        MODIFY GT_BSEG FROM GS_BSEG.

      ENDLOOP.

      MODIFY  ZEA_BSEG FROM TABLE GT_BSEG.

*--- FIT800 ( 벤더원장 테이블 )
CLEAR GS_BSEG.
CLEAR GT_BSEG.

      SELECT * FROM ZEA_FIT800
      WHERE BELNR EQ @GS_DATA3-BELNR
      INTO TABLE @GT_FIT800.

      LOOP AT GT_FIT800 INTO GS_FIT800.
        GS_FIT800-AUGDT = 'X'.
        GS_FIT800-AUGBL = EV_BELNR.
        MODIFY GT_FIT800 FROM GS_FIT800.
      ENDLOOP.
      MODIFY  ZEA_FIT800 FROM TABLE GT_FIT800.

      C_EV_BELNR = EV_BELNR.
      C_KR_BELNR = GS_DATA3-BELNR.

**---- 2. STATUS 변경
      LOOP AT GT_DATA INTO GS_DATA WHERE BELNR EQ   GS_DATA3-BELNR.
        GS_DATA-STATUS = '3'.
        GS_DATA-AUGDT =  'X'.
        GS_DATA-AUGBL =  EV_BELNR.
        MODIFY GT_DATA  FROM GS_DATA .
      ENDLOOP.

      LOOP AT GT_DATA2 INTO GS_DATA2 WHERE BELNR EQ   GS_DATA3-BELNR.
        GS_DATA2-STATUS = '3'.
        GS_DATA2-AUGDT =  'X'.
        MODIFY GT_DATA2  FROM GS_DATA2 .
      ENDLOOP.

*-------3. ZEA_MMT170 , ZEA_MMT160 송장검증 테이블 내 지급여부 필드 값 주기
      " 송장 문서 번호 찾기

      DATA LV_MBELNR TYPE ZEA_MMT170-BELNR.

      SELECT SINGLE * FROM ZEA_BKPF
             WHERE BELNR EQ @GS_DATA3-BELNR
             INTO @ZEA_BKPF.

      LV_MBELNR = ZEA_BKPF-XBLNR.  "KA전표 내 참조 필드, 송장문서번호  Select

      " 송장 헤더 변경
      UPDATE ZEA_MMT160 SET ZLSCHYN = 'X' WHERE BELNR EQ LV_MBELNR.

      " 송장 아이템 변경
      SELECT * FROM ZEA_MMT170  WHERE BELNR EQ @LV_MBELNR
        INTO TABLE @GT_MMT170.

      LOOP AT GT_MMT170 INTO GS_MMT170.
        GS_MMT170-ZLSCHYN = 'X'.
        MODIFY GT_MMT170 FROM GS_MMT170.
      ENDLOOP.
      MODIFY ZEA_MMT170 FROM TABLE GT_MMT170.

*--- 값 주기
*   PERFORM MODIFY_DISPLAY_CELL_COL CHANGING GS_DATA3-BELNR .
  LOOP AT GT_DATA INTO GS_DATA.

    IF GS_DATA-BELNR EQ GS_DATA3-BELNR.
      CLEAR GS_FIELD_COLOR.
      GS_FIELD_COLOR-FNAME = 'BELNR'.
      GS_FIELD_COLOR-COLOR-COL = 3. " 노랑
      GS_FIELD_COLOR-COLOR-INT = 1.
      GS_FIELD_COLOR-COLOR-INV = 0.
      APPEND GS_FIELD_COLOR TO GS_DATA-IT_FIELD_COLORS.
    ENDIF.

    MODIFY GT_DATA FROM GS_DATA.

  ENDLOOP.

    ENDIF.

  ENDLOOP.    "지급 처리 끝

ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  CHECK_BANKCODE_0200  INPUT
*&---------------------------------------------------------------------*
MODULE CHECK_BANKCODE_0200 INPUT.

  SELECT SINGLE *
    FROM ZEA_BKNA
   WHERE BANKCODE EQ ZEA_BKNA-BANKCODE.

  IF SY-SUBRC NE 0.
    MESSAGE E007. " 은행코드가 올바르지 않습니다.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_AUGDT  INPUT
*&---------------------------------------------------------------------*
MODULE CHECK_AUGDT INPUT.

ENDMODULE.
