FUNCTION ZEA_FI_DZ.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_AR_RECON) TYPE  ZEA_SAKNR
*"     REFERENCE(IV_BUDAT) TYPE  ZEA_BUDAT
*"     REFERENCE(IV_PAY_AMOUNT) TYPE  ZEA_DMBTR
*"     REFERENCE(IV_WAERS) TYPE  ZEA_WAERS
*"     REFERENCE(IV_MBLNR) TYPE  ZEA_BELNR
*"     REFERENCE(IV_BANK_SAKNR) TYPE  ZEA_SAKNR
*"  EXPORTING
*"     REFERENCE(EV_BELNR) TYPE  ZEA_BELNR
*"----------------------------------------------------------------------
*& [MM-FI]        DZ 전표 함수 테스트 프로그램
*&---------------------------------------------------------------------*
*& [생성일자 : 2024-04-23] / [생성자 : 5반 1조 이세영]
*& 완성도 [00%]
*&---------------------------------------------------------------------*
*& [Memo]
*  1) 해당 함수 사용 이후, DA전표를 BELNR 로 찾아서 'X' 에서 표시 (O)
*  2) 함수를 통해 DZ 반제번호 Export. 이는 반제번호에 Insert      (O)
*  3) 아이템01 전기키 15에 반제 필요한 채권 인식                  (O)
*  4) 저장 테이블 확인 (FIT700/BSEG/BKPF)                         (O)
*&---------------------------------------------------------------------*
  CLEAR: GS_BKPF, GS_BSEG.
  REFRESH: GT_BKPF, GT_BSEG.

* -- 0. FI 전표번호 채번
  PERFORM NR_ZEA_BELNR CHANGING GV_BELNR_NUMBER.  " 전표번호 채번


* -- 1. FI A/R 레콘 계정 찾기
* 1) 받아온 DA전표의 전표번호(PK)를 활용하여 해당 고객 코드를 찾는다.
  SELECT SINGLE * FROM ZEA_BSEG INTO ZEA_BSEG
    WHERE BELNR EQ IV_MBLNR
    AND   BSCHL EQ '01'.

  LV_CUSCODE = ZEA_BSEG-BPCODE.
* 2) 고객코드를 활용하여 매출채권 계정(A/R) Recon 을 찾는다.

  CLEAR GS_SKB1.  "사용 전 초기화
  SELECT SINGLE * FROM ZEA_SKB1 INTO ZEA_SKB1
    WHERE BPCODE EQ LV_CUSCODE .

* 3) 찾은 값을 LV_ARRECON 보관 변수에 넣는다.
  LV_ARRECON = ZEA_SKB1-SAKNR.

* -- 2. Amount 환산
* -- 2-1. (S/H) 금액 변환
*  CASE IV_WAERS.
*    WHEN 'KRW'.
*      CALL FUNCTION 'BAPI_CURRENCY_CONV_TO_INTERNAL'
*        EXPORTING
*          AMOUNT_EXTERNAL      = IV_PAY_AMOUNT  " [SD] 반제 필요금액
*          CURRENCY             = IV_WAERS
*          MAX_NUMBER_OF_DIGITS = 23             "출력할 금액필드의 자릿수"
*        IMPORTING
*          AMOUNT_INTERNAL      = CS_AMOUNT.
*      ENDCASE.

  CS_AMOUNT  = IV_PAY_AMOUNT.
*----------------------------------------------------------------------
*                            IMPORTING
*----------------------------------------------------------------------
* -- 1. FI 전표 헤더 생성 ---------------------------------------------*

  GS_BKPF-BUKRS = '1000'.
  GS_BKPF-BELNR = GV_BELNR_NUMBER.
  GS_BKPF-GJAHR = '2024'.
  GS_BKPF-BLART = 'DZ'.         " A/R  입금 전표
  GS_BKPF-BUDAT = SY-DATUM.     " [FI] KA 전기일자 => [FI] 헤더 - 전기일자
  GS_BKPF-BLDAT = SY-DATUM.     " [FI] 증빙일자
  GS_BKPF-BLTXT = '[SD] 입금전표'.
  GS_BKPF-XBLNR = IV_MBLNR.     " [FI] DA전표 번호 => [FI] 헤더 - 참조문서

  " 생성 관련 정보
  GS_BKPF-ERDAT = SY-DATUM. " 생성일자를 오늘로
  GS_BKPF-ERZET = SY-UZEIT. " 생성시간을 현재 시간으로
  GS_BKPF-ERNAM = 'ACA5-17'. " 생성자를 현재 로그인한 사용자ID
  IF SY-SUBRC EQ 0 .
    INSERT  ZEA_BKPF FROM GS_BKPF.
    MODIFY ZEA_BKPF FROM ZEA_BKPF.
  ENDIF.

* -- 2. FI 전표 아이템 생성 -------------------------------------------*
* -- 2-1. FI 전표 아이템(차변: A/R 감소)

  DO 2 TIMES.
    GS_BSEG-ITNUM = SY-INDEX. " Item 번호

    CASE GS_BSEG-ITNUM.
      WHEN 1.
        "[15] (H) A/R 감소
        GS_BSEG-BUKRS = '1000'.
        GS_BSEG-BELNR = GV_BELNR_NUMBER.
        GS_BSEG-GJAHR = '2024'.
        GS_BSEG-BSCHL = '15'.                  " [FI] 전기키 (A/R 차변)
        GS_BSEG-SAKNR =  LV_ARRECON.           " [FI] G/L계정(A/R Recon)
        GS_BSEG-GLTXT = 'A/R 반제'.            " [FI] G/L계정명
        GS_BSEG-AUGBL = IV_MBLNR.              " [FI] DA전표 번호 => [FI] 아이템 - 반제번호
        GS_BSEG-AUGDT = 'X'.
        GS_BSEG-BPCODE = LV_CUSCODE.

        "국제(전표) 금액
        GS_BSEG-DMBTR   = CS_AMOUNT.           " [SD] 반제 필요금액
        GS_BSEG-D_WAERS = 'KRW'.

        "현지 금액
        GS_BSEG-WRBTR   = CS_AMOUNT.
        GS_BSEG-W_WAERS =  'KRW'.
        APPEND GS_BSEG TO GT_BSEG.


* -- 2-1. FI 전표 아이템(차변 : 예금 증가)
      WHEN 2.
        " [15] (S) 당좌예금 증가
        GS_BSEG-BUKRS = '1000'.
        GS_BSEG-BELNR = GV_BELNR_NUMBER.
        GS_BSEG-GJAHR = '2024'.
        GS_BSEG-BSCHL = '05'.               " [FI] 전기키 (B/S 계정 : 대변)
        GS_BSEG-SAKNR = IV_BANK_SAKNR.      " [FI] G/L계정 (Recon) - BANK CODE
        GS_BSEG-GLTXT = '당좌예금'.         " [FI] G/L계정명
        GS_BSEG-AUGBL = IV_MBLNR.           " [FI] DA전표 번호 => [FI] 아이템 - 반제번호
        GS_BSEG-AUGDT = 'X'.
        GS_BSEG-BPCODE = LV_CUSCODE.

        "국제(전표) 금액
        GS_BSEG-DMBTR   = CS_AMOUNT.           " [SD] 반제 필요금액
        GS_BSEG-D_WAERS = 'KRW'.

        "현지 금액
        GS_BSEG-WRBTR   = CS_AMOUNT.
        GS_BSEG-W_WAERS =  'KRW'.

        APPEND GS_BSEG TO GT_BSEG.

    ENDCASE.
  ENDDO.

*----------------------------------------------------------------------
*                  SAVE TO ZEA_BKPF / ZEA_BSEG
*----------------------------------------------------------------------
  MODIFY ZEA_BSEG FROM TABLE GT_BSEG.

  MESSAGE GV_BELNR_NUMBER && '번 전표가 생성되었습니다. ' TYPE 'S'.

  COMMIT WORK AND WAIT.
*----------------------------------------------------------------------
*                          EXPORTING
*----------------------------------------------------------------------
*                        <<  FI =>  SD  >>
  EV_BELNR =  GV_BELNR_NUMBER. "전표번호 Exporting

*----------------------------------------------------------------------
*                          DA 전표에 표시
*----------------------------------------------------------------------
*                      <<  FI(DZ) =>  FI(DA)  >>

*--- 3. DZ전표 생성 후 성공 Message 출력 및 DA전표에 체크

  IF SY-SUBRC EQ 0 .          "DZ 전표가 성공적으로 Posting 된 경우

    CLEAR GS_BSEG.            "사용을 위해 변수 초기화
    REFRESH GT_BSEG.

*--- BSEG ( 아이템 테이블 )
* DA유형 전표 - 반제여부 필드/반제번호 필드 채우기 위해 GT_BSEG에 담기
    SELECT * FROM ZEA_BSEG
    WHERE BELNR EQ @IV_MBLNR           "DA유형 전표번호
    INTO CORRESPONDING FIELDS OF TABLE @GT_BSEG.

    LOOP AT GT_BSEG INTO GS_BSEG.

      GS_BSEG-AUGDT = 'X'.
      GS_BSEG-AUGBL = EV_BELNR.         "DZ유형 전표번호
      MODIFY GT_BSEG FROM GS_BSEG.

    ENDLOOP.
    MODIFY  ZEA_BSEG FROM TABLE GT_BSEG.

*--- FIT700 ( 고객 원장 테이블 )

    SELECT * FROM ZEA_FIT700
    WHERE BELNR EQ @IV_MBLNR
    INTO CORRESPONDING FIELDS OF TABLE @GT_FIT700.

    LOOP AT GT_FIT700 INTO GS_FIT700.
      GS_FIT700-AUGDT = 'X'.
      GS_FIT700-AUGBL = EV_BELNR.
      GS_FIT700-CUSCODE = LV_CUSCODE.
      MODIFY GT_FIT700 FROM GS_FIT700.
    ENDLOOP.

    MODIFY  ZEA_FIT700 FROM TABLE GT_FIT700.

  ENDIF.

*----     ZEA_SDT040 (판매오더 테이블-수금필드)

  DATA LV_PAYNR TYPE ZEA_SDT070-PAYNR.
  DATA LV_VBELN TYPE ZEA_SDT040-VBELN.

  SELECT SINGLE * FROM ZEA_BKPF
    WHERE BELNR EQ @IV_MBLNR
    INTO @ZEA_BKPF.

  LV_PAYNR =  ZEA_BKPF-XBLNR.           "DA전표 내 참조 필드, 대금청구번호 Select

  "ZEA_SDT070(대금청구테이블) 에서 해당 대금청구문서 를 Select
  SELECT SINGLE * FROM ZEA_SDT070
    WHERE PAYNR EQ LV_PAYNR.

  LV_VBELN = ZEA_SDT070-VBELN.         "해당 대금청구 문서 내 판매오더를 Select

  UPDATE ZEA_SDT040 SET STATUS4 = 'X' WHERE VBELN EQ LV_VBELN .     "DB변경



ENDFUNCTION.
