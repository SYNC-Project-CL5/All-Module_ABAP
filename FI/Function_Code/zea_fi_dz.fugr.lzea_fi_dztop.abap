FUNCTION-POOL ZEA_FI_DZ.                    "MESSAGE-ID ..

* INCLUDE LZEA_FI_KZD...                     " Local class definition
TABLES: ZEA_BKPF, ZEA_BSEG, " FI 헤더/아이템
        ZEA_TVZBT,          " 지급조건
        ZEA_TCURR,          " 환율
        ZEA_SKB1,           "G/L 마스터 테이블
        ZEA_SDT040,         "판매오더 테이블
        ZEA_SDT070.         "대금청구 테이블

" FI 전표 헤더 테이블
DATA: GT_BKPF TYPE TABLE OF ZEA_BKPF,
      GS_BKPF TYPE ZEA_BKPF.

" FI 전표 아이템 테이블
DATA: GT_BSEG TYPE TABLE OF ZEA_BSEG,
      GS_BSEG TYPE ZEA_BSEG.

" FI 환율 테이블
DATA: GS_TUCRR TYPE ZEA_TCURR.
DATA: GV_COVT_AMOUNT TYPE ZEA_BSEG-WRBTR.

DATA: GV_BELNR_NUMBER TYPE ZEA_BKPF-BELNR.      " 전표번호(key)
DATA: GV_ITNUM TYPE N.                          " Item 라인번호


DATA : GT_FIT700 LIKE TABLE OF ZEA_FIT700,
       GS_FIT700 TYPE ZEA_FIT700,

       " 전기키
       GS_TBSL   TYPE ZEA_TBSL,
       GT_TBSL   TYPE TABLE OF ZEA_TBSL,

       GS_SKB1   TYPE ZEA_SKB1,
       GT_SKB1   LIKE TABLE OF ZEA_SKB1.

" A/R Recon 보관 변수
DATA : LV_ARRECON TYPE ZEA_SAKNR,
       " A/R Recon 을 찾기 위한 고객코드 보관 변수
       LV_CUSCODE TYPE ZEA_CUSCODE.

" 금액변환 함수
DATA : CV_COST   LIKE GS_BSEG-DMBTR,
       CS_AMOUNT LIKE GS_BSEG-DMBTR,
       CH_AMOUNT LIKE GS_BSEG-DMBTR.
