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

      PERFORM SELECT_BACK_SAVE CHANGING GV_KR_BELNR GV_EV_BELNR.

**---- 2. STATUS 변경
      IF GV_EV_BELNR IS NOT INITIAL.
        LOOP AT GT_DATA INTO GS_DATA WHERE BELNR EQ  GV_EV_BELNR.
          GS_DATA-STATUS = '3'.
          GS_DATA-AUGDT =  'X'.
          GS_DATA-AUGBL = GV_KR_BELNR.
          MODIFY GT_DATA  FROM GS_DATA .
        ENDLOOP.

        LOOP AT GT_DATA2 INTO GS_DATA2 WHERE BELNR EQ  GV_EV_BELNR.
          GS_DATA2-STATUS = '3'.
          GS_DATA2-AUGDT =  'X'.
          MODIFY GT_DATA2  FROM GS_DATA2 .
        ENDLOOP.

*---- 3. ALV REFRESH
        PERFORM REFRESH_ALV2_0100.
        PERFORM REFRESH_ALV_0100.

      ENDIF.

      LEAVE TO SCREEN 0.      "팝업창 종료

    WHEN 'CACN'.
      LEAVE TO SCREEN 0.

      PERFORM REFRESH_ALV2_0100.
      PERFORM REFRESH_ALV_0100.

  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Form SELECT_BACK_SAVE
*&---------------------------------------------------------------------*
FORM SELECT_BACK_SAVE CHANGING   C_EV_BELNR TYPE ZEA_FIT800-BELNR
                                 C_KR_BELNR TYPE ZEA_FIT800-BELNR.
  BREAK-POINT.

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

**--- 1) A/P Recon 계정 찾기

  SELECT SINGLE * FROM
    ZEA_SKB1 INTO ZEA_SKB1 WHERE BPCODE EQ VENCODE. "A/P계정 찾음.

  LV_S_SAKNR = ZEA_SKB1-SAKNR.  "Vendor 의 A/P계정

  LV_H_SAKNR = ZEA_BKNA-SAKNR.  "Screen 200의 BP_Recon

*--- 2) 화면 변수와 소통(0200)
  LV_BANK = ZEA_BKNA-ACCNT.       "Bank Account
  LV_DATE = POST_DATE.            "Posting Date

  OPEN_AMOUNT2 = GS_DATA2-DMBTR.
  USD_AMOUNT = OPEN_AMOUNT2.         " 총 미결 금액
  USD_CURKY  = ZEA_FIT800-D_WAERS.   " 전표 통화키 (USD또는KRW)


  OPEN_AMOUNT = GS_FIT800-WRBTR.
  KRW_AMOUNT = OPEN_AMOUNT.            " 총 미결 금액
  KRW_CURKY  = ZEA_FIT800-W_WAERS.     " 현지 통화키 (=무조건 KRW)

  KR_BELNR = ZEA_FIT800-BELNR.     "KA 유형 전표번호

  LV_DATE = SY-DATUM.       "오늘날

  CALL FUNCTION 'ZEA_FI_KZ'
    EXPORTING
      IV_AP_RECON   = LV_S_SAKNR             "  G/L 계정 (Recon)
      IV_BUDAT      = LV_DATE                " 전기일자
      IV_PAY_AMOUNT = ZEA_FIT800-DMBTR       " 전표 내 기록된 매입채무 총액(USD또는KRW)
      IV_D_WAERS    = ZEA_FIT800-D_WAERS     " 전표 기록 통화코드 (USD또는KRW)
      IV_KRW_AMOUNT = ZEA_FIT800-WRBTR       " 통화금액(KRW)
      IV_WAERS      = ZEA_FIT800-W_WAERS     " 현지통화코드 (KRW)
      IV_MBLNR      = KR_BELNR               " 참조문서(KA전표번호)
      IV_BANK_SAKNR = LV_H_SAKNR             " G/L 계정 (BANK Recon)
    IMPORTING
      EV_BELNR      = EV_BELNR.      " 전표번호

  IF SY-SUBRC EQ 0 .
*--- 3) KZ전표 생성 후 성공 Message 출력 및 KA전표에 체크
    MESSAGE '(전표번호 :' && EV_BELNR && ')' &&
    '지급 처리가 완료되었습니다.' TYPE 'S'.

*--- BSEG ( 아이템 테이블 )
* KA유형 전표 - 반제여부 필드/반제번호 필드 채우기 위해 GT_BSEG에 담기
    SELECT * FROM ZEA_BSEG
    WHERE BELNR EQ @KR_BELNR
    INTO CORRESPONDING FIELDS OF TABLE @GT_BSEG.

    LOOP AT GT_BSEG INTO GS_BSEG.

      GS_BSEG-AUGDT = 'X'.
      GS_BSEG-AUGBL = EV_BELNR.
      MODIFY GT_BSEG FROM GS_BSEG.

    ENDLOOP.
    MODIFY  ZEA_BSEG FROM TABLE GT_BSEG.

*--- FIT800 ( 벤더원장 테이블 )

    SELECT * FROM ZEA_FIT800
    WHERE BELNR EQ @KR_BELNR
    INTO CORRESPONDING FIELDS OF TABLE @GT_FIT800.

    LOOP AT GT_FIT800 INTO GS_FIT800.
      GS_FIT800-AUGDT = 'X'.
      GS_FIT800-AUGBL = EV_BELNR.
      MODIFY GT_FIT800 FROM GS_FIT800.
    ENDLOOP.

    MODIFY  ZEA_FIT800 FROM TABLE GT_FIT800.

  ENDIF.

  C_EV_BELNR = EV_BELNR.
  C_KR_BELNR = KR_BELNR.

ENDFORM.
