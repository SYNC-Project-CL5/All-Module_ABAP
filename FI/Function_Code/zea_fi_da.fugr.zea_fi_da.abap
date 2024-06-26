FUNCTION ZEA_FI_DA.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_PAYNR) TYPE  ZEA_PAYNR
*"     REFERENCE(IV_INVDT) TYPE  ZEA_INVDT
*"     REFERENCE(IV_CUSCODE) TYPE  ZEA_CUSCODE
*"     REFERENCE(IV_CHARGE) TYPE  ZEA_CHARGE
*"     REFERENCE(IV_EATAX) TYPE  ZEA_EATAX
*"     REFERENCE(IV_WAERS) TYPE  ZEA_WAERS
*"     REFERENCE(IV_NETPR) TYPE  ZEA_DMBTR
*"     REFERENCE(IV_AUQUA) TYPE  ZEA_AUQUA
*"     REFERENCE(IV_PLANT) TYPE  ZEA_WERKS
*"     REFERENCE(IV_CHECK) TYPE  C
*"  EXPORTING
*"     REFERENCE(EV_BELNR) TYPE  ZEA_BELNR
*"     REFERENCE(EV_BUKRS) TYPE  ZEA_BUKRS
*"     REFERENCE(EV_GJAHR) TYPE  ZEA_GJAHR
*"----------------------------------------------------------------------
*& [SD-FI]                DA 전표 생성 함수
*&---------------------------------------------------------------------*
*& [생성일자 : 2024-04-21] / [생성자 : 5반 1조 이세영]
*& [완료일자 : 2024-04-28]
*& 완성도 [100%]
*& 1. 검토 내역 : FIT700, BKPF, BSEG 테이블 내 저장 확인
*& 2. 검토 내역 : 도/소매 레콘 기록 테스트 완료
*----------------------------------------------------------------------
*--- 1. 회계문서 전표번호 채번
  PERFORM NR_ZEA_BELNR CHANGING GV_BELNR_NUMBER.

  "대금청구 헤더 구조체에 채번한 회계전표번호를 넣는다. => 함수 Exporting 으로 해결
  GS_BKPF-BELNR = GV_BELNR_NUMBER.   "회계전표 헤더 구조체에 채번한 회계전표번호를 넣는다.
  GS_BSEG-BELNR = GV_BELNR_NUMBER.   "회계전표 아이템 구조체에 채번한 회계전표를 넣는다.

*--- 2. A/R 인식을 위한 Recon Account 검색
*** 매출채권 계정 검색
*  1) 고객 Recon 검색을 위해 받아온 고객코드(=IV_CUSCODE)를 활용
*  2) A/R 인식을 위해 ZEA_SKB1 테이블 내 Recon Account를 Select
*  3) 검색에 성공하면, Recon Account(A/R) 를 GV_RECON 변수에 보관
  SELECT SINGLE * FROM ZEA_SKB1 INTO ZEA_SKB1
    WHERE BPCODE EQ IV_CUSCODE.
  MOVE-CORRESPONDING ZEA_SKB1 TO GS_SKB1.
  IF SY-SUBRC EQ 0.
    GV_RECON = GS_SKB1-SAKNR.     "A/R 매출채권 레콘계정
  ENDIF.

*** 매출액 계정 검색
  IF IV_CHECK EQ 'X'.  " IV_CHECK = 'X'일 경우에만 진행
*  1) 직영점 Recon 검색을 위해 받아온 직영점코드(=IV_PLANT)를 활용
*  2) 매출액 인식을 위해 ZEA_SKB1 테이블 내 Recon Account를 Select
*  3) 검색에 성공하면, Recon Account(A/R) 를 GV_PRECON 변수에 보관
* BREAK-POINT.
    CLEAR ZEA_SKB1.  "사용 전 초기화

    SELECT SINGLE * FROM ZEA_SKB1 INTO ZEA_SKB1
      WHERE GLTXT EQ '제품국내매출액'
        AND BPCODE EQ IV_PLANT.

    GV_PRECON = ZEA_SKB1-SAKNR.    "매출액 레콘계정

  ELSE.

    GV_PRECON = '410010'. "GLTXT : [제품국내매출액-소매]

  ENDIF.

*--- 3. 매출원가 계산
*  [예시] (ZEA_SDT120-NETPR X ZEA_SDT120-AUQUA) WAERS
*  [예시] ( GV_COST )                           WAERS
  DATA : GV_COST  TYPE ZEA_BSEG-DMBTR,          "매출원가
         GV_AUQUA TYPE N.                       "수량

  GV_COST = IV_NETPR * IV_AUQUA.          "매출원가 = 완제품 원가 * 수량

*
** -- 3-1. 금액 변환
*  CASE IV_WAERS.
*    WHEN 'KRW'.
*      CALL FUNCTION 'BAPI_CURRENCY_CONV_TO_INTERNAL'
*        EXPORTING
*          AMOUNT_EXTERNAL      = GV_COST   "매출원가
*          CURRENCY             = 'KRW'
*          MAX_NUMBER_OF_DIGITS = 23        "출력할 금액필드의 자릿수"
*        IMPORTING
*          AMOUNT_INTERNAL      = CV_COST.
*  ENDCASE.
*
*--- 4. 매출액 계산
  DATA LV_AMOUNT TYPE ZEA_BSEG-DMBTR.     "매출액
  LV_AMOUNT = IV_CHARGE + IV_EATAX.       "매출액 = 공제액 +  세액

**------ 4-1. 매출액 변환
*  CASE IV_WAERS.
*    WHEN 'KRW'.
*      CALL FUNCTION 'BAPI_CURRENCY_CONV_TO_INTERNAL'
*        EXPORTING
*          AMOUNT_EXTERNAL      = LV_AMOUNT
*          CURRENCY             = 'KRW'
*          MAX_NUMBER_OF_DIGITS = 23  "출력할 금액필드의 자릿수"
*        IMPORTING
*          AMOUNT_INTERNAL      = CV_SALES.  "매출액
*  ENDCASE.
*
**------ 4-2. 공제액 변환
*  CASE IV_WAERS.
*    WHEN 'KRW'.
*      CALL FUNCTION 'BAPI_CURRENCY_CONV_TO_INTERNAL'
*        EXPORTING
*          AMOUNT_EXTERNAL      = IV_CHARGE
*          CURRENCY             = 'KRW'
*          MAX_NUMBER_OF_DIGITS = 23  "출력할 금액필드의 자릿수"
*        IMPORTING
*          AMOUNT_INTERNAL      = CV_CHARGE.  "공제액
*  ENDCASE.
*
**------ 4-3. 세액 변환
*  CASE IV_WAERS.
*    WHEN 'KRW'.
*      CALL FUNCTION 'BAPI_CURRENCY_CONV_TO_INTERNAL'
*        EXPORTING
*          AMOUNT_EXTERNAL      = IV_EATAX
*          CURRENCY             = 'KRW'
*          MAX_NUMBER_OF_DIGITS = 23  "출력할 금액필드의 자릿수"
*        IMPORTING
*          AMOUNT_INTERNAL      = CV_EATAX.  "세액
*  ENDCASE.
*
**--- 5. 통화코드
*  DATA GV_WAERS TYPE ZEA_WAERS.           "통화코드
*  GV_WAERS = IV_WAERS.
*
***--- DB로 들어갈 때, 00개가 빠져서 나옴.
**  "곱하기 X 100 해야 함.
**
**  CV_COST = CV_COST * 100.
**  CV_CHARGE = CV_CHARGE * 100.
**  CV_EATAX = CV_EATAX * 100.
**  CV_SALES = CV_SALES * 100.

*  CV_COST = GV_COST.
  CV_SALES = LV_AMOUNT .
  CV_CHARGE = IV_CHARGE.
  CV_EATAX = IV_EATAX.
*----------------------------------------------------------------------
*                      IMPORTING 변수  활용
*----------------------------------------------------------------------

* -- 1. FI 전표 헤더 생성 ---------------------------------------------*
  GS_BKPF-BUKRS = 1000.             "회사번호
  GS_BKPF-BELNR = GV_BELNR_NUMBER.  "전표번호
  GS_BKPF-GJAHR = '2024'.           "회계연도
  GS_BKPF-BLART = 'DA'.             "전표유형 = DA
  GS_BKPF-BLDAT = IV_INVDT.         "증빙일자 = 청구일자
  GS_BKPF-BUDAT = SY-DATUM.         "전기일자 = 생성일자
  GS_BKPF-XBLNR = IV_PAYNR.         "참조번호 = 청구번호
  GS_BKPF-BLTXT = '매출전표' && '(고객:' && IV_CUSCODE && ' )'.
  "매출전표(고객: customer code)

  " 생성 관련 정보
  GS_BKPF-ERDAT = SY-DATUM. " 생성일자를 오늘로
  GS_BKPF-ERZET = SY-UZEIT. " 생성시간을 현재 시간으로
  GS_BKPF-ERNAM = 'ACA5-17'. " 생성자를 현재 로그인한 사용자ID

*-- SAVE TO ZEA_BKPF (전표 헤더)
  INSERT  ZEA_BKPF FROM GS_BKPF.

* -- 2. FI 전표 아이템 생성 -------------------------------------------*
* -- 2-1. FI 전표 아이템(차변: A/P 감소)

*--- 1. GT_BSEG 에 5줄의 ITEM라인 생성
*       [공통 정보 입력]

  DO 3 TIMES.                 " 총 5개의 Line이 생성
    GS_BSEG-ITNUM = SY-INDEX. " Item 번호

    CASE GS_BSEG-ITNUM.
*      WHEN 1.
*        BREAK-POINT.
*        "공통정보
*        GS_BSEG-BELNR = GV_BELNR_NUMBER. " 전표번호
*        GS_BSEG-BUKRS = 1000.            " 회사코드
*        GS_BSEG-GJAHR = 2024.            " 회계연도
*
*        "[40] 매출원가 - (ZEA_SDT120-NETPR X ZEA_SDT120-AUQUA) WAERS
*        GS_BSEG-BSCHL = '40'.              "차변
*        GS_BSEG-SAKNR = '501040'.          "매출원가(제품)
*        GS_BSEG-GLTXT = '매출원가(제품)'.  "G/L Text
*        GS_BSEG-BPCODE = IV_CUSCODE.       "BP CODE
*
*        "현지 금액
*        GS_BSEG-WRBTR =   GV_COST.         "Amount
*        GS_BSEG-W_WAERS = IV_WAERS.        "통화코드
*        "국제(전표) 금액
*        GS_BSEG-DMBTR = GV_COST.           "Amount
*        GS_BSEG-D_WAERS = IV_WAERS.        "통화코드
*
*
*        APPEND GS_BSEG TO GT_BSEG.
*
**
*      WHEN 2.
*        "공통정보
*        GS_BSEG-BELNR = GV_BELNR_NUMBER. " 전표번호
*        GS_BSEG-BUKRS = 1000.            " 회사코드
*        GS_BSEG-GJAHR = 2024.            " 회계연도
*
*        "[50] 제품 - Amount는 매출원가와 동일
*        GS_BSEG-BSCHL = '50'.                " 대변
*        GS_BSEG-SAKNR = '100760'.            " 제품
*        GS_BSEG-GLTXT = '제품'.              " G/L Text
*        GS_BSEG-BPCODE = IV_CUSCODE.         "BP CODE
*
*        "현지 금액
*        GS_BSEG-WRBTR =   GV_COST.          "Amount
*        GS_BSEG-W_WAERS = IV_WAERS.         "통화코드
*        "국제(전표) 금액
*        GS_BSEG-DMBTR = GV_COST.            "Amount
*        GS_BSEG-D_WAERS = IV_WAERS.         "통화코드
*
*        APPEND GS_BSEG TO GT_BSEG.

      WHEN 1.
        "공통정보
        GS_BSEG-BELNR = GV_BELNR_NUMBER. " 전표번호
        GS_BSEG-BUKRS = 1000.            " 회사코드
        GS_BSEG-GJAHR = 2024.            " 회계연도

        "[01] A/R (Recon) - Amount 는 (공제액 + 세액) IV_CHARGE + IV_EATAX
        GS_BSEG-BSCHL = '01'.                        "차변
        GS_BSEG-SAKNR = GV_RECON.                    "A/R
        GS_BSEG-GLTXT = '(A/R:' && IV_CUSCODE &&')'. "G/L Text
        GS_BSEG-BPCODE = IV_CUSCODE.                 "BP CODE

        "현지 금액
        GS_BSEG-WRBTR =   CV_SALES.                 "Amount
        GS_BSEG-W_WAERS = IV_WAERS.                 "통화코드

        "국제(전표) 금액
        GS_BSEG-DMBTR   = CV_SALES .                 "Amount
        GS_BSEG-D_WAERS = IV_WAERS.                  "통화코드

        APPEND GS_BSEG TO GT_BSEG.

      WHEN 2.
        "공통정보
        GS_BSEG-BELNR = GV_BELNR_NUMBER. " 전표번호
        GS_BSEG-BUKRS = 1000.            " 회사코드
        GS_BSEG-GJAHR = 2024.            " 회계연도

        "[50] 매출 계정   - 공제액 IV_CHARGE
        GS_BSEG-BSCHL = '50'.                         "대변
        GS_BSEG-SAKNR = GV_PRECON.                    "G/L 매출계정(직영점)
        GS_BSEG-GLTXT = '(매출' && IV_PLANT &&')'.    "G/L Text
        GS_BSEG-DMBTR =   IV_CHARGE.                  "Amount
        GS_BSEG-D_WAERS = IV_WAERS.                   "통화코드
        GS_BSEG-BPCODE =  IV_CUSCODE.                 "BP CODE


        "현지 금액
        GS_BSEG-WRBTR =   CV_CHARGE.                "Amount
        GS_BSEG-W_WAERS = IV_WAERS.                 "통화코드

        "국제(전표) 금액
        GS_BSEG-DMBTR   =  CV_CHARGE.                "Amount
        GS_BSEG-D_WAERS = IV_WAERS.                  "통화코드

        APPEND GS_BSEG TO GT_BSEG.

      WHEN 3.
        "공통정보
        GS_BSEG-BELNR = GV_BELNR_NUMBER. " 전표번호
        GS_BSEG-BUKRS = 1000.            " 회사코드
        GS_BSEG-GJAHR = 2024.            " 회계연도

        "[50] 부가세 예수금 - 세액  IV_EATAX
        GS_BSEG-BSCHL = '50'.                        "대변
        GS_BSEG-SAKNR = '210200'.                    "매출 부가세
        GS_BSEG-GLTXT = '부가세예수금'.                       "G/L Text
        GS_BSEG-BPCODE = IV_CUSCODE.                 "BP CODE

        "현지 금액
        GS_BSEG-WRBTR =   CV_EATAX.                 "Amount
        GS_BSEG-W_WAERS = IV_WAERS.                 "통화코드

        "국제(전표) 금액
        GS_BSEG-DMBTR   =  CV_EATAX.                "Amount
        GS_BSEG-D_WAERS = IV_WAERS.                  "통화코드

        APPEND GS_BSEG TO GT_BSEG.

    ENDCASE.
  ENDDO.

*----------------------------------------------------------------------
*                         SAVE TO ZEA_BSEG
*----------------------------------------------------------------------

  MODIFY ZEA_BSEG FROM TABLE GT_BSEG.

  MESSAGE GV_BELNR_NUMBER && '번 전표가 생성되었습니다. ' TYPE 'S'.

  COMMIT WORK AND WAIT.

*----------------------------------------------------------------------
*                     SAVE TO ZEA_FIT700
*----------------------------------------------------------------------

  MOVE-CORRESPONDING GT_BSEG TO GT_FIT700.

  LOOP AT GT_FIT700 INTO GS_FIT700 . "WHERE BSCHL EQ '01'.
    GS_FIT700-XBLNR = IV_PAYNR.
    GS_FIT700-BLDAT = IV_INVDT.
    GS_FIT700-BUDAT = SY-DATUM.
    GS_FIT700-CUSCODE = GS_BSEG-BPCODE.
    MODIFY GT_FIT700 FROM GS_FIT700 TRANSPORTING XBLNR CUSCODE BLDAT BUDAT.
  ENDLOOP.

  MODIFY ZEA_FIT700 FROM TABLE GT_FIT700.

  COMMIT WORK AND WAIT.
*----------------------------------------------------------------------
*                          EXPORTING
*----------------------------------------------------------------------
*                        << FI => SD >>
  EV_BELNR =  GV_BELNR_NUMBER. "전표번호 Exporting
  EV_BUKRS =  1000.
  EV_GJAHR =  2024.

ENDFUNCTION.
