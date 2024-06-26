*&---------------------------------------------------------------------*
*& Report ZEA_TEST_AR_FUNCTION
*&---------------------------------------------------------------------*
*& [SD-FI]        DA 전표 함수 테스트 프로그램
*&---------------------------------------------------------------------*
*& [생성일자 : 2024-04-19] / [생성자 : 5반 1조 이세영]
*& 완성도 [80%]
*&---------------------------------------------------------------------*
*& [수정이력]
*& 1. 전표 헤더 생성 (이상 무)
*& 2. 전표 아이템 생성 - 금액/계정만 잘 들어감 (이상 무)
*& 3. 저장 확인 테이블
*& FIT700
*& ZEA_BSEG
*& ZEA_BKFP
*& 4. 도매/ 소매 인 경우 테스트 진행
*&---------------------------------------------------------------------*
REPORT ZEA_TEST_AR_FUNCTION.

TABLES : ZEA_SDT070, ZEA_SDT120.
DATA : TY_SDT070 TYPE TABLE OF ZEA_SDT070,
       GT_SDT070 LIKE  TY_SDT070,
       GS_SDT070 TYPE ZEA_SDT070.

DATA : TY_SDT120 TYPE TABLE OF ZEA_SDT120,
       GT_SDT120 LIKE TY_SDT120,
       GS_SDT120 TYPE ZEA_SDT120.

*&---------------------------------------------------------------------*
*                        청구문서 헤더  생성
*&---------------------------------------------------------------------*

DATA : LV_PAYNR   LIKE GS_SDT070-PAYNR,
       LV_INVDT   LIKE GS_SDT070-INVDT,
       LV_CUSCODE LIKE GS_SDT070-CUSCODE,
       LV_CHARGE  LIKE GS_SDT070-CHARGE,
       LV_EATAX   LIKE GS_SDT070-EATAX,
       LV_WAERS   LIKE GS_SDT070-WAERS,

       LV_BELNR   TYPE ZEA_BELNR,
       LV_BUKRS   TYPE ZEA_BUKRS,
       LV_GJAHR   TYPE ZEA_GJAHR,
       LV_NETPR   TYPE  ZEA_NETPR,
       LV_AUQUA   TYPE  ZEA_AUQUA,
       LV_PLANT   TYPE  ZEA_WERKS.
*&---------------------------------------------------------------------*
*&                  [TEST] SD 대금 청구 헤더 생성
*&---------------------------------------------------------------------*
*--comment : 실제 sd가 생성 시에는 아래는 임의 값이 아닌 변수를 넣어주세요.

ZEA_SDT070-PAYNR   = 'PAY455587'.
ZEA_SDT070-CUSCODE = '20002'.
ZEA_SDT070-ZLSCH   ='D000'.
ZEA_SDT070-CHARGE  ='9000'.     "공제액  "라인아이템 2의 계정으로 들어가야함
ZEA_SDT070-WAERS   ='KRW'.      "금액   "라인아이템 3 ''
"                               "FI 라인아이템 1로는  매출채권 계정(고객별 레콘)
ZEA_SDT070-EATAX    = '1000'.   "세금
ZEA_SDT070-INVDT    = SY-DATUM. "청구일자

" 생성 관련 정보
ZEA_SDT070-ERDAT = SY-DATUM. " 생성일자를 오늘로
ZEA_SDT070-ERZET = SY-UZEIT. " 생성시간을 현재 시간으로
ZEA_SDT070-ERNAM = SY-UNAME. " 생성자를 현재 로그인한 사용자ID

INSERT ZEA_SDT070.          "청구 헤더 테이블에 한줄 추가

SELECT SINGLE *
  FROM ZEA_SDT070
  INTO CORRESPONDING FIELDS OF ZEA_SDT070
  WHERE VBELN EQ 'PAY455587'.  "실제 SD가 전표 발행 시엔 변수로 체크하겠지.

*---- comment1 : Exporting 할 값들을 변수에 담아주세요.
" SD의 실제 대금청구 값이 들어간 변수를 전달해주세요.
" 단일값이어야 함( 구조체, 인터널테이블 불가능 )
" 위 LV 변수 선언 타입 참고
LV_PAYNR    = ZEA_SDT070-PAYNR.
LV_INVDT    = ZEA_SDT070-INVDT.
LV_CUSCODE  = ZEA_SDT070-CUSCODE.
LV_NETPR  = 1000.      "판매단가
LV_AUQUA  = 10.       "수량
LV_PLANT  =  ' '.    "직영점
*&---------------------------------------------------------------------*
*&                   DA 유형 전표 자동생성
*&---------------------------------------------------------------------*

*---[사용방법]
*            1. CALL FUNCTION
*                 대금청구 문서 발행이 끝나는 시점에
*                 FI의 DA유형 전표 자동 생성 함수를 호출해주세요.
*                 함수명 : [ CALL FUNCTION 'ZEA_FI_DA' ]
*            2. EXPORT
*                 아래 주석을 참고해 값이 들어간 EXP 변수를 넣어주세요.
*                 이를 받아가서 저희는 회계전표를 자동 생성합니다.
*                 Export 함수는 모두 필수값으로 한개라도 없으면 덤프에러 발생
*            3. IMPORT
*                 전표 번호/회사코드/회계연도를 IMPORTING 변수로 받아주세요.
*                 SD는 대금 청구 헤더 필드를 해당 변수 속 값으로 채워주세요.

CALL FUNCTION 'ZEA_FI_DA'
  EXPORTING
    IV_PAYNR   = LV_PAYNR               " 청구 문서 번호
    IV_INVDT   = LV_INVDT               " 청구 일자
    IV_CUSCODE = LV_CUSCODE             " [BP] 고객코드
    IV_CHARGE  = LV_CHARGE              " 공제액
    IV_EATAX   = LV_EATAX               " 부가 가치세
    IV_WAERS   = LV_WAERS               " 통화코드
    IV_NETPR   = LV_NETPR               " 판매 단가
    IV_AUQUA   = LV_AUQUA               " 주문 수량
    IV_CHECK   = ' '                    "도매일 경우 'X' 값, 소매일 경우 ' ' 공백 전달
    IV_PLANT   = LV_PLANT               "도매 판매여서 Plant 값이 있을 경우 전달
                                        "IV_CHECK 는 했는데, Plant 값이 전달되지 않을 경우
                                        "매출 계정이 빈 값으로 나와 꼭 전달 필요.
"도매인 경우 : IV_CHECK 'X', IV_PLANT : 직영점 코드 값 전달 필요
"소매인 경우 : IV_CHECK ' ', IV_PLANT : ' ' 빈 값 전달

  IMPORTING
    EV_BELNR   = LV_BELNR               " 전표 번호
    EV_BUKRS   = LV_BUKRS               " 회사코드
    EV_GJAHR   = LV_GJAHR.              " 회계연도

IF SY-SUBRC EQ 0 .
  MESSAGE 'DA 유형' && LV_BELNR && '전표가 Posting 되었습니다.' TYPE 'S'.
  UPDATE ZEA_SDT070 SET BELNR = LV_BELNR.
ENDIF.
