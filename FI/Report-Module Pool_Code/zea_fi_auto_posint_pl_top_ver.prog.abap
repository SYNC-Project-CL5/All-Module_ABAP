*&---------------------------------------------------------------------*
*& Include          ZEA_FI_AUTO_POSINT_PL_TOP
*&---------------------------------------------------------------------*

TABLES: ZEA_BKPF, ZEA_BSEG, " FI 헤더/아이템
        ZEA_TCURR,          " 환율
        ZEA_SKB1.           " G/L 마스터 테이블

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


DATA : " 전기키
  GS_TBSL TYPE ZEA_TBSL,
  GT_TBSL TYPE TABLE OF ZEA_TBSL,

  " GL마스터
  GS_SKB1 TYPE ZEA_SKB1,
  GT_SKB1 LIKE TABLE OF ZEA_SKB1.


*-- 매크로

DEFINE _MC_HEAD.
  GS_BKPF-MANDT = 100.
  GS_BKPF-BUKRS = 1000.
  GS_BKPF-BELNR = GV_BELNR_NUMBER.
  GS_BKPF-GJAHR = 2024.
  GS_BKPF-BLART = 'SA'.
  GS_BKPF-BLDAT = &1.
  GS_BKPF-BUDAT = &1.
  GS_BKPF-BLTXT = &2.
  GS_BKPF-XBLNR = ''.
END-OF-DEFINITION.

DEFINE _MC_ITEM.
  GS_BSEG-MANDT = 100.
  GS_BSEG-BUKRS = 1000.
  GS_BSEG-BELNR = GV_BELNR_NUMBER.
  GS_BSEG-GJAHR = 2024.
  GS_BSEG-ITNUM = &1. " 1, 2 ... 값 넣어주기
  GS_BSEG-BSCHL = &2. " 전기키 : 40/50 으로만
  GS_BSEG-SAKNR = &3. " GL코드
  GS_BSEG-GLTXT = &4. " GLTXT
  GS_BSEG-DMBTR = &5. " 금액
GS_BSEG-D_WAERS = 'KRW'.
  GS_BSEG-WRBTR = &5.
GS_BSEG-W_WAERS = 'KRW'.
 GS_BSEG-BPCODE = &6.
  GS_BSEG-AUGDT = ''.
  GS_BSEG-AUGBL = ''.
  GS_BSEG-MATNR = &7.
  GS_BSEG-WERKS = ''.
END-OF-DEFINITION.
