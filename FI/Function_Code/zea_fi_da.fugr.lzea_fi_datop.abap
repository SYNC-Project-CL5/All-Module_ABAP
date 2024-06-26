FUNCTION-POOL ZEA_FI_DA.                    "MESSAGE-ID ..

* INCLUDE LZEA_FI_DAD...                     " Local class definition

*-- TABLES
TABLES ZEA_SKB1.


*-- WA, ITAB
DATA: " 전표 헤더
  GS_BKPF   TYPE ZEA_BKPF,
  GT_BKPF   TYPE TABLE OF ZEA_BKPF,

  " 전표 아이템
  GS_BSEG   TYPE ZEA_BSEG,
  GT_BSEG   TYPE TABLE OF ZEA_BSEG,


  " 고객 원장
  GS_FIT700 TYPE ZEA_FIT700,
  GT_FIT700 TYPE TABLE OF ZEA_FIT700,


  " 전기키
  GS_TBSL   TYPE ZEA_TBSL,
  GT_TBSL   TYPE TABLE OF ZEA_TBSL,

  GS_SKB1   TYPE ZEA_SKB1,
  GT_SKB1   LIKE TABLE OF ZEA_SKB1.

*--- MAKE Variant For Importing
DATA : GS_SDT070 TYPE ZEA_SDT070,   "대금청구 헤더 - 구조체
       GS_SDT120 TYPE ZEA_SDT120.   "대금청구 아이템 - 구조체


DATA : LV_PAYNR  TYPE ZEA_SDT070-PAYNR, "청구테이블-청구번호 보관 변수
       GV_RECON  TYPE ZEA_SKB1-SAKNR,   "고객별 매출채권 - 레콘 계정 보관 변수(A/R)
       GV_PRECON TYPE ZEA_SKB1-SAKNR.   "직영점별 매출   - 레콘 계정 (Profit)

*--- Range 변수 & Line Item 변수
DATA: GV_BELNR_NUMBER TYPE ZEA_BKPF-BELNR. " 전표번호
DATA: GV_ITNUM TYPE N.


" 금액변환 함수
DATA : CV_COST   LIKE GS_BSEG-DMBTR,
       CV_SALES LIKE GS_BSEG-DMBTR,
       CV_CHARGE LIKE GS_BSEG-DMBTR,
       CV_EATAX LIKE GS_BSEG-DMBTR.

*--- 매출원가
*    GV_COST = IV_NETPR * IV_AUQUA.          "매출원가 = 완제품 원가 * 수량
*
**--- 매출액
*    DATA LV_AMOUNT TYPE ZEA_BSEG-DMBTR.     "매출액
*    LV_AMOUNT = IV_CHARGE + IV_EATAX.       "매출액 = 공제액 +  세액
