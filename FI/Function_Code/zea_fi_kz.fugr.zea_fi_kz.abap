FUNCTION ZEA_FI_KZ.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_AP_RECON) TYPE  ZEA_SAKNR
*"     REFERENCE(IV_BUDAT) TYPE  ZEA_BUDAT
*"     REFERENCE(IV_PAY_AMOUNT) TYPE  ZEA_DMBTR
*"     REFERENCE(IV_D_WAERS) TYPE  ZEA_WAERS
*"     REFERENCE(IV_KRW_AMOUNT) TYPE  ZEA_DMBTR
*"     REFERENCE(IV_WAERS) TYPE  ZEA_WAERS
*"     REFERENCE(IV_MBLNR) TYPE  ZEA_BELNR
*"     REFERENCE(IV_BANK_SAKNR) TYPE  ZEA_SAKNR
*"  EXPORTING
*"     REFERENCE(EV_BELNR) TYPE  ZEA_BELNR
*"----------------------------------------------------------------------
*& [MM-FI]                KZ 전표 생성 함수
*&---------------------------------------------------------------------*
*& [생성일자 : 2024-04-21] / [생성자 : 5반 1조 이세영]
*& [완료일자 : 2024-04-29] - 활용프로그램 [ZEA_FI070]
*& 1. 검토 내역 : FIT7800, BKPF, BSEG 테이블 내 저장 확인 (완료)
*& 2. 검토 내역 : 도/소매 레콘 기록 테스트 (완료)
*& 3. 고도화    : 환율 적용 (진행중)
*----------------------------------------------------------------------
*& [ CASE ]
  "STEP 0. KA유형 전표에서 IV_WAERS와 IV_D_WAERS가 둘다 KRW인 경우,
*          즉, 국내 매입건인 경우는 차이없이 지급

  "STEP 1. USD로 기록된 AP를 전기일(=환율기준일) 기준 환율을 불러와 환산

  "STEP 2. 지급일 기준 환율로 환산된 AP(KRW)와 매입 시 인식한 AP(KRW)를 비교
  "        단, 이 때 USD 기준 AP는 동일하다.

  "STEP 3. 비교한 이후 아래와 같은 라인아이템을 생성한다.
*& 1. KA(KRW) > KZ(KRW)
*     [25] AP  [50] 예금
*              [50] 외환차익(710020)
*& 2.  KA(KRW) < KZ(KRW)
*     [25] AP  [50] 예금
*     [40] 외환차손(730030)
*& 3.  KA(KRW) = KZ(KRW)
*     [25] AP  [50] 예금

*& 4. <CASE : 국내 매입건>
*     KA(KRW) = KZ(KRW)
*     [25] AP  [50] 예금
*----------------------------------------------------------------------
  CLEAR: GS_BKPF, GS_BSEG.
  REFRESH: GT_BKPF, GT_BSEG.
*----------------------------------------------------------------------
* -- 0. FI 전표번호 채번
  PERFORM NR_ZEA_BELNR CHANGING GV_BELNR_NUMBER.  " 전표번호 채번

*----------------------------------------------------------------------
* -- 1-1. 금액 변환(AP 지급 금액)
* ----- IV_PAY_AMOUNT => LV_AP_AMOUNT 옮김.
* 1000원으로 입력하는 경우 => 100,000 원으로 저장되는 경우가 있음. 그래서 00개를 떨궈줌.
*
*  CASE IV_WAERS.
*    WHEN 'KRW'.
*      CALL FUNCTION 'BAPI_CURRENCY_CONV_TO_INTERNAL'
*        EXPORTING
*          AMOUNT_EXTERNAL      = IV_PAY_AMOUNT   "총 미결금액( USD나 이런 애들을 넣어주면)
*          CURRENCY             = IV_WAERS
*          MAX_NUMBER_OF_DIGITS = 23              "출력할 금액필드의 자릿수
*        IMPORTING
*          AMOUNT_INTERNAL      = LV_AP_AMOUNT.   "여기서 (KRW마냥, .00을 없애줌)
*  ENDCASE.
*
** -- 1-2. 이외 저장 값 변환(AP 지급 금액)
*  CALL FUNCTION 'BAPI_CURRENCY_CONV_TO_INTERNAL'
*    EXPORTING
*      AMOUNT_EXTERNAL      = IV_KRW_AMOUNT   "총 미결금액
*      CURRENCY             = IV_WAERS
*      MAX_NUMBER_OF_DIGITS = 23        "출력할 금액필드의 자릿수"
*    IMPORTING
*      AMOUNT_INTERNAL      = GV_KAAP_AMT.

*----------------------------------------------------------------------
*                        [FI 전표 헤더 생성]
*----------------------------------------------------------------------
  GS_BKPF-BUKRS = '1000'.
  GS_BKPF-BELNR = GV_BELNR_NUMBER.
  GS_BKPF-GJAHR = '2024'.
  GS_BKPF-BLART = 'KZ'.         " A/P 대금지급 전표
  GS_BKPF-BUDAT = SY-DATUM.     " [FI] KA 전기일자 => [FI] 헤더 - 전기일자
  GS_BKPF-BLDAT = SY-DATUM.     " [FI] 증빙일자
  GS_BKPF-BLTXT = '[MM] 지급전표'.
  GS_BKPF-XBLNR = IV_MBLNR.     " [FI] KA전표 번호 => [FI] 헤더 - 참조문서

  " 생성 관련 정보
  GS_BKPF-ERDAT = SY-DATUM. " 생성일자를 오늘로
  GS_BKPF-ERZET = SY-UZEIT. " 생성시간을 현재 시간으로
  GS_BKPF-ERNAM = 'ACA5-17'. " 생성자를 현재 로그인한 사용자ID

*-- SAVE ZEA_BKPF(전표헤더)
  IF SY-SUBRC EQ 0 .
    INSERT  ZEA_BKPF FROM GS_BKPF.
    MODIFY ZEA_BKPF FROM   ZEA_BKPF.
  ENDIF.
*----------------------------------------------------------------------
* -- 2. 환율 불러와  A/P(USD)를 원화로 환산

* -- 2-1. KA전표 내 AP(KRW) 값 찾기
  SELECT  SINGLE * FROM ZEA_BSEG INTO ZEA_BSEG
    WHERE BELNR EQ IV_MBLNR "KA유형 전표번호
    AND   BSCHL EQ '31'.    "A/P 인식 시 사용하는 전기키

* -- [통화코드 확인]
  "만약, A/P 인식 통화가 모두 KRW라면, 굳이 환산하지 않아도 됨.
  IF ZEA_BSEG-D_WAERS EQ 'USD'. "전표 표시 통화가 USD인 경우

    CLEAR ZEA_TCURR.
    CLEAR GT_TCURR.
    CLEAR GS_TCURR.
    CLEAR C_RATIO.

*------- 오늘 환율 읽어오기
    SELECT SINGLE * FROM ZEA_TCURR INTO  ZEA_TCURR
       WHERE GDATU EQ SY-DATUM
       AND FCURR EQ 'KRW'
       AND TCURR EQ 'USD'.

      GV_COVT_AMOUNT  = ZEA_BSEG-DMBTR * ZEA_TCURR-UKURS / 100.   "당일 환율 활용
      ZEA_BSEG-W_WAERS = 'KRW'.
      C_RATIO = ZEA_TCURR-UKURS. "환율 보관 변수에 보관

    IF SY-SUBRC NE 0.                 " 가장 마지막 환율 값을 읽어와야 한다.
*      IF GS_TCURR-GDATU EQ '00000000'.
      SELECT * FROM ZEA_TCURR INTO TABLE GT_TCURR
        WHERE TCURR = 'USD'
          AND FCURR = 'KRW'
          ORDER BY GDATU DESCENDING.


      READ TABLE GT_TCURR INTO GS_TCURR INDEX 1.

*       환산금액(KRW) = 총 매입금액 / 환율
      GV_COVT_AMOUNT  = ZEA_BSEG-DMBTR * GS_TCURR-UKURS / 100 .    "주말인 경우, 환율 활용
      C_RATIO = GS_TCURR-UKURS. "환율 보관 변수에 보관
      ZEA_BSEG-W_WAERS = 'KRW'.

   ENDIF.


* -- [통화코드 확인]
  ELSE.      "그렇지 않으면 (=즉, 둘다 모두 'KRW'통화키 인 경우에는 환산하지 않음)
    "그냥 아래 변수 그대로 사용하면 됨.  IV_PAY_AMOUNT, IV_KRW_AMOUNT

    DATA LV_X TYPE C.     "해외 매입건인 경우 ' ', 국내 매입건인 경우 'X'
    LV_X = 'X'.
  ENDIF.

*----------------------------------------------------------------------
*                     [FI 전표 아이템 생성]
  CASE LV_X.
    WHEN ' '.   " D = USD, W = KRW
*----------------------------------------------------------------------
*  GV_COVT_AMOUNT 와 IV_KRW_AMOUNT 값 중 비교   => 외환차손/외환차익 인식
* -- 1.  환산A/P(GV_COVT_AMOUNT) 와 매입시 인식한 A/P(KRW)비교
*     [25] AP  [50] 예금
*              [50] 외환차익(710020)
      IF IV_KRW_AMOUNT > GV_COVT_AMOUNT.     "[KA] A/P(KRW) > [KZ] A/P(KRW) =>> 외환차익 인식

        DO 3 TIMES.
          GS_BSEG-ITNUM = SY-INDEX.  " Item 번호

          CASE GS_BSEG-ITNUM.

* -- 1.1.1.
* FI 전표 아이템(차변: A/P 감소)  [25] AP
            WHEN 1.
              GS_BSEG-BUKRS = '1000'.
              GS_BSEG-BELNR = GV_BELNR_NUMBER.
              GS_BSEG-GJAHR = '2024'.
              GS_BSEG-BSCHL = '25'.                  " [FI] 전기키
              GS_BSEG-SAKNR =  IV_AP_RECON.          " [FI] G/L계정 (Recon)
              GS_BSEG-GLTXT = 'A/P 반제'.            " [FI] G/L계정명
              GS_BSEG-AUGBL =  IV_MBLNR.             " [FI] KA전표 번호
              GS_BSEG-BPCODE = ZEA_BSEG-BPCODE.
              GS_BSEG-AUGDT = 'X'.

              "국제(전표) 금액
              GS_BSEG-DMBTR   = IV_PAY_AMOUNT.       " 반제 필요금액(USD)
              GS_BSEG-D_WAERS = IV_D_WAERS.          " USD

              "현지 금액(KRW)
              GS_BSEG-WRBTR   = IV_KRW_AMOUNT.
*              GS_BSEG-WRBTR    = GV_COVT_AMOUNT.

              GS_BSEG-W_WAERS =  IV_WAERS.
              GS_BSEG-WERKS = '10000'.

              APPEND GS_BSEG TO GT_BSEG.

* -- 1.1.2.
* FI 전표 아이템(대변 : 예금 감소) [50] 예금

            WHEN 2.
              GS_BSEG-BUKRS = '1000'.
              GS_BSEG-BELNR = GV_BELNR_NUMBER.
              GS_BSEG-GJAHR = '2024'.
              GS_BSEG-BSCHL = '50'.               " [FI] 전기키
              GS_BSEG-SAKNR = IV_BANK_SAKNR.      " [FI] G/L계정 (Recon) - BANK CODE
              GS_BSEG-GLTXT = '당좌예금'.         " [FI] G/L계정명
              GS_BSEG-AUGBL =  IV_MBLNR.          " [FI] KA전표 번호
              GS_BSEG-BPCODE = ZEA_BSEG-BPCODE.
              GS_BSEG-AUGDT = 'X'.

              "국제(전표) 금액
              GS_BSEG-DMBTR   =  IV_PAY_AMOUNT.                " 반제 필요금액(USD)
              GS_BSEG-D_WAERS = IV_D_WAERS.

              "현지 금액(KRW)
*              GS_BSEG-WRBTR   = IV_PAY_AMOUNT * C_RATIO / 100.  " 기준일 환율 환산금액(KRW)
              GS_BSEG-WRBTR   =  GV_COVT_AMOUNT  . "<== 오늘 일자로 환산된 금액이 들어가야 함.
              GS_BSEG-W_WAERS =  IV_WAERS.
              GS_BSEG-WERKS = '10000'.
              APPEND GS_BSEG TO GT_BSEG.

* -- 1.1.3.
* FI 전표 아이템(대변: 외환차익 인식)  [50] 외환차익(710020)

            WHEN 3.
              GS_BSEG-BUKRS = '1000'.
              GS_BSEG-BELNR = GV_BELNR_NUMBER.
              GS_BSEG-GJAHR = '2024'.
              GS_BSEG-BSCHL = '50'.                  " [FI] 전기키
              GS_BSEG-SAKNR = '710020' .             " [FI] G/L계정 (Recon)
              GS_BSEG-GLTXT = '외환차익'.            " [FI] G/L계정명
              GS_BSEG-AUGBL =  IV_MBLNR.             " [FI] KA전표 번호
              GS_BSEG-BPCODE = ZEA_BSEG-BPCODE.
              GS_BSEG-AUGDT = 'X'.

              "국제(전표) 금액
              GS_BSEG-DMBTR
              "                     KRW 금액         /   환율  = USD
              = ( IV_KRW_AMOUNT - GV_COVT_AMOUNT )  / C_RATIO  * 100 .   "차액
              GS_BSEG-D_WAERS = IV_D_WAERS.

              "현지 금액(KRW)
              GS_BSEG-WRBTR = IV_KRW_AMOUNT -  GV_COVT_AMOUNT . "차액
              GS_BSEG-W_WAERS =  IV_WAERS.
              GS_BSEG-WERKS = '10000'.
              APPEND GS_BSEG TO GT_BSEG.



          ENDCASE.
        ENDDO.


*----------------------------------------------------------------------
*                     [FI 전표 아이템 생성]
*----------------------------------------------------------------------

      ELSEIF IV_KRW_AMOUNT < GV_COVT_AMOUNT.
        "[KA] A/P(KRW) < [KZ] A/P(KRW) =>> 외환차손 인식
*      KA(KRW) < KZ(KRW)
*     [25] AP  [50] 예금
*     [40] 외환차손(730030)

        DO 3 TIMES.
          GS_BSEG-ITNUM = SY-INDEX.  " Item 번호

          CASE GS_BSEG-ITNUM.

* -- 3.2.1.  FI 전표 아이템(차변: A/P 감소)  [25] AP
            WHEN 1.
              GS_BSEG-BUKRS = '1000'.
              GS_BSEG-BELNR = GV_BELNR_NUMBER.
              GS_BSEG-GJAHR = '2024'.
              GS_BSEG-BSCHL = '25'.                  " [FI] 전기키
              GS_BSEG-SAKNR =  IV_AP_RECON.          " [FI] G/L계정 (Recon)
              GS_BSEG-GLTXT = 'A/P 반제'.            " [FI] G/L계정명
              GS_BSEG-AUGBL =  IV_MBLNR.             " [FI] KA전표 번호
              GS_BSEG-BPCODE = ZEA_BSEG-BPCODE.
              GS_BSEG-AUGDT = 'X'.

              "국제(전표) 금액
              GS_BSEG-DMBTR   = IV_PAY_AMOUNT.        " 반제 필요금액(USD)
              GS_BSEG-D_WAERS = IV_D_WAERS.                " USD

              "현지 금액(KRW)
              GS_BSEG-WRBTR   = IV_KRW_AMOUNT.
              GS_BSEG-W_WAERS = IV_WAERS.
              GS_BSEG-WERKS = '10000'.
              APPEND GS_BSEG TO GT_BSEG.


* -- 3.2.2. FI 전표 아이템(대변 : 예금 감소) [50] 예금
            WHEN 2.
              GS_BSEG-BUKRS = '1000'.
              GS_BSEG-BELNR = GV_BELNR_NUMBER.
              GS_BSEG-GJAHR = '2024'.
              GS_BSEG-BSCHL = '50'.               " [FI] 전기키
              GS_BSEG-SAKNR = IV_BANK_SAKNR.      " [FI] G/L계정 (Recon) - BANK CODE
              GS_BSEG-GLTXT = '당좌예금'.         " [FI] G/L계정명
              GS_BSEG-AUGBL =  IV_MBLNR.          " [FI] KA전표 번호
              GS_BSEG-BPCODE = ZEA_BSEG-BPCODE.
              GS_BSEG-AUGDT = 'X'.

              "국제(전표) 금액
              GS_BSEG-DMBTR   = IV_PAY_AMOUNT   .  " 반제 필요금액(USD)
              GS_BSEG-D_WAERS = IV_D_WAERS.

              "현지 금액(KRW)
              GS_BSEG-WRBTR   =  GV_COVT_AMOUNT  .     "기준일 환율 환산금액(KRW)
              GS_BSEG-W_WAERS = IV_WAERS.
              GS_BSEG-WERKS = '10000'.
              APPEND GS_BSEG TO GT_BSEG.

* -- 3.2.3.FI 전표 아이템(대변: 외환차손 인식)  [40] 외환차손(730030)
            WHEN 3.
              GS_BSEG-BUKRS = '1000'.
              GS_BSEG-BELNR = GV_BELNR_NUMBER.
              GS_BSEG-GJAHR = '2024'.
              GS_BSEG-BSCHL = '40'.                  " [FI] 전기키
              GS_BSEG-SAKNR =  '730030' .            " [FI] G/L계정 (Recon)
              GS_BSEG-GLTXT = '외환차손'.            " [FI] G/L계정명
              GS_BSEG-AUGBL =  IV_MBLNR.             " [FI] KA전표 번호
              GS_BSEG-BPCODE = ZEA_BSEG-BPCODE.
              GS_BSEG-AUGDT = 'X'.

              "국제(전표) 금액
              GS_BSEG-DMBTR   = ( GV_COVT_AMOUNT  -  IV_KRW_AMOUNT )  / C_RATIO   .   "차액
              GS_BSEG-D_WAERS = IV_D_WAERS.

              "현지 금액(KRW)
              GS_BSEG-WRBTR   =  GV_COVT_AMOUNT  -  IV_KRW_AMOUNT . "차액
              GS_BSEG-W_WAERS =   IV_WAERS.

              GS_BSEG-WERKS = '10000'.
              APPEND GS_BSEG TO GT_BSEG.

          ENDCASE.
        ENDDO.

*----------------------------------------------------------------------
*                     [FI 전표 아이템 생성]
*----------------------------------------------------------------------
      ELSE.       " KA(KRW) = KZ(KRW)
*                   [25] AP  [50] 예금
        DO 2 TIMES.
          GS_BSEG-ITNUM = SY-INDEX.  " Item 번호

* -- 3-1. FI 전표 아이템 (차) A/P 감소
          CASE GS_BSEG-ITNUM.
            WHEN 1.
              GS_BSEG-BUKRS = '1000'.
              GS_BSEG-BELNR = GV_BELNR_NUMBER.
              GS_BSEG-GJAHR = '2024'.
              GS_BSEG-BSCHL = '25'.                  " [FI] 전기키
              GS_BSEG-SAKNR =  IV_AP_RECON.          " [FI] G/L계정 (Recon)
              GS_BSEG-GLTXT = 'A/P 반제'.            " [FI] G/L계정명
              GS_BSEG-AUGBL =  IV_MBLNR.             " [FI] KA전표 번호
              GS_BSEG-BPCODE = ZEA_BSEG-BPCODE.
              GS_BSEG-AUGDT = 'X'.

              "국제(전표) 금액
              GS_BSEG-DMBTR    = IV_PAY_AMOUNT.       "매입 시 계약했던 A/P(USD)
              GS_BSEG-D_WAERS =  IV_D_WAERS.

              "현지 금액
              GS_BSEG-WRBTR   =  IV_KRW_AMOUNT.

              GS_BSEG-W_WAERS =  IV_WAERS.
              GS_BSEG-WERKS = '10000'.
              APPEND GS_BSEG TO GT_BSEG.


* -- 3-2. FI 전표 아이템 (대) 예금 감소
            WHEN 2.
              GS_BSEG-BUKRS = '1000'.
              GS_BSEG-BELNR = GV_BELNR_NUMBER.
              GS_BSEG-GJAHR = '2024'.
              GS_BSEG-BSCHL = '50'.               " [FI] 전기키
              GS_BSEG-SAKNR = IV_BANK_SAKNR.      " [FI] G/L계정 (Recon) - BANK CODE
              GS_BSEG-GLTXT = '당좌예금'.         " [FI] G/L계정명
              GS_BSEG-AUGBL =  IV_MBLNR.          " [FI] KA전표 번호
              GS_BSEG-BPCODE = ZEA_BSEG-BPCODE.
              GS_BSEG-AUGDT = 'X'.

              "국제(전표) 금액
              GS_BSEG-DMBTR   =  IV_PAY_AMOUNT.    " ZEA_TCURR-UKURS
              GS_BSEG-D_WAERS = IV_D_WAERS.        " 환율 기준일에 해당하는 USD의 환율을 보관

              "현지 금액
              GS_BSEG-WRBTR   =  GV_COVT_AMOUNT.

              GS_BSEG-WERKS = '10000'.
              GS_BSEG-W_WAERS =  IV_WAERS.
              APPEND GS_BSEG TO GT_BSEG.
          ENDCASE.
        ENDDO.
      ENDIF.

*----------------------------------------------------------------------
*                     [FI 전표 아이템 생성]
*----------------------------------------------------------------------
    WHEN 'X'.  " D = KRW, W = KRW

      DO 2 TIMES.                   " [25] AP  [50] 예금
        GS_BSEG-ITNUM = SY-INDEX.   " Item 번호

* -- 3-1. FI 전표 아이템 (차) A/P 감소

        CASE GS_BSEG-ITNUM.
          WHEN 1.
            GS_BSEG-BUKRS = '1000'.
            GS_BSEG-BELNR = GV_BELNR_NUMBER.
            GS_BSEG-GJAHR = '2024'.
            GS_BSEG-BSCHL = '25'.                  " [FI] 전기키
            GS_BSEG-SAKNR =  IV_AP_RECON.          " [FI] G/L계정 (Recon)
            GS_BSEG-GLTXT = 'A/P 반제'.            " [FI] G/L계정명
            GS_BSEG-AUGBL =  IV_MBLNR.             " [FI] KA전표 번호
            GS_BSEG-BPCODE = ZEA_BSEG-BPCODE.
            GS_BSEG-AUGDT = 'X'.

            "국제(전표) 금액
            GS_BSEG-DMBTR    = IV_PAY_AMOUNT.  "매입 시 계약했던 A/P(USD)
            GS_BSEG-D_WAERS = IV_D_WAERS.

            "현지 금액
            GS_BSEG-WRBTR   =  IV_KRW_AMOUNT.

            GS_BSEG-W_WAERS =  IV_WAERS.
            GS_BSEG-WERKS = '10000'.
            APPEND GS_BSEG TO GT_BSEG.


* -- 3-2. FI 전표 아이템 (대) 예금 감소
          WHEN 2.
            GS_BSEG-BUKRS = '1000'.
            GS_BSEG-BELNR = GV_BELNR_NUMBER.
            GS_BSEG-GJAHR = '2024'.
            GS_BSEG-BSCHL = '50'.               " [FI] 전기키
            GS_BSEG-SAKNR = IV_BANK_SAKNR.      " [FI] G/L계정 (Recon) - BANK CODE
            GS_BSEG-GLTXT = '당좌예금'.         " [FI] G/L계정명
            GS_BSEG-AUGBL =  IV_MBLNR.          " [FI] KA전표 번호
            GS_BSEG-BPCODE = ZEA_BSEG-BPCODE.
            GS_BSEG-AUGDT = 'X'.

            "국제(전표) 금액
            GS_BSEG-DMBTR   =  IV_PAY_AMOUNT.    " ZEA_TCURR-UKURS
            GS_BSEG-D_WAERS =  IV_D_WAERS.       " 환율 기준일에 해당하는 USD의 환율을 보관

            "현지 금액
            GS_BSEG-WRBTR   =  IV_KRW_AMOUNT.
            GS_BSEG-W_WAERS =  IV_WAERS.

            GS_BSEG-WERKS = '10000'.
            APPEND GS_BSEG TO GT_BSEG.
        ENDCASE.
      ENDDO.

*----------------------------------------------------------------------
  ENDCASE.
*                       SAVE TO ZEA_BSEG
*----------------------------------------------------------------------
  MODIFY ZEA_BSEG FROM TABLE GT_BSEG.

  MESSAGE GV_BELNR_NUMBER && '번 전표가 생성되었습니다. ' TYPE 'S'.

  COMMIT WORK AND WAIT.

*----------------------------------------------------------------------
*                     SAVE TO ZEA_FIT800
*----------------------------------------------------------------------

  MOVE-CORRESPONDING GT_BSEG TO GT_FIT800.
  MODIFY ZEA_FIT800 FROM TABLE GT_FIT800.

  COMMIT WORK AND WAIT.
*----------------------------------------------------------------------
*                          EXPORTING
*----------------------------------------------------------------------
*                        << FI => MM >>
  EV_BELNR =  GV_BELNR_NUMBER. "전표번호 Exporting

ENDFUNCTION.
