FUNCTION-POOL ZEA_FI_KZ.                    "MESSAGE-ID ..

*-- TABLES
TABLES: ZEA_BKPF, ZEA_BSEG, " FI 헤더/아이템
        ZEA_TVZBT, " 지급조건
        ZEA_TCURR. " 환율

*-- WA, ITAB
" FI 전표 헤더 테이블
DATA: GT_BKPF TYPE TABLE OF ZEA_BKPF,
      GS_BKPF TYPE ZEA_BKPF.

" FI 전표 아이템 테이블
DATA: GT_BSEG TYPE TABLE OF ZEA_BSEG,
      GS_BSEG TYPE ZEA_BSEG.

" FI 환율 테이블
DATA: GS_TCURR       TYPE ZEA_TCURR,
      GT_TCURR       TYPE TABLE OF ZEA_TCURR,
      GV_COVT_AMOUNT TYPE ZEA_BSEG-WRBTR,
      C_RATIO        TYPE ZEA_TCURR-UKURS.  "환율보관변수

* --FI 벤더 원장
DATA: GT_FIT800 TYPE TABLE OF ZEA_FIT800,
      GS_FIT800 TYPE ZEA_FIT800.

*-- Variant
* --FI 전표번호 채번
DATA: GV_BELNR_NUMBER TYPE ZEA_BKPF-BELNR.   " 전표번호(key)
DATA: GV_ITNUM TYPE N.

*-- Amount 변수
DATA : LV_AP_AMOUNT TYPE ZEA_BSEG-DMBTR,
       LV_BK_AMOUNT TYPE ZEA_BSEG-DMBTR,
       CVT_S_AMT    TYPE ZEA_BSEG-DMBTR,
       CVT_H_AMT    TYPE ZEA_BSEG-DMBTR,
       CVT_DIS_AMT  TYPE ZEA_BSEG-DMBTR.

DATA : GV_KAAP_AMT TYPE ZEA_BSEG-DMBTR.