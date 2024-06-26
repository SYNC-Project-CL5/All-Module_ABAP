FUNCTION-POOL ZEA_NI.                       "MESSAGE-ID ..

* INCLUDE LZEA_NID...                        " Local class definition

* -- SELECT * 데이터
DATA: BEGIN OF GS_DATA.
        INCLUDE TYPE ZEA_BSEG.           " 회사코드 / 회계연도 / G/L코드 / GLTXT / 금액/ 세금
DATA:   BUDAT    TYPE ZEA_BKPF-BUDAT,
        XBILK    TYPE ZEA_SKB1-XBILK,    " G/L코드 타입 (NE 'X')
        RECON_YN TYPE ZEA_SKB1-RECON_YN, " 레콘계정 여부
      END OF GS_DATA,
      GT_DATA LIKE TABLE OF GS_DATA.

" 각 계정의 SUM값을 보관하는 변수
DATA: DMBTR_4 TYPE ZEA_BSEG-DMBTR.
DATA: DMBTR_5 TYPE ZEA_BSEG-DMBTR.
DATA: DMBTR_6 TYPE ZEA_BSEG-DMBTR.
DATA: DMBTR_7P TYPE ZEA_BSEG-DMBTR.
DATA: DMBTR_7L TYPE ZEA_BSEG-DMBTR.
DATA: DMBTR_A TYPE ZEA_BSEG-DMBTR.
DATA: DMBTR_B TYPE ZEA_BSEG-DMBTR.
DATA: DMBTR_C TYPE ZEA_BSEG-DMBTR.

* -- 범위값을 가져오는  Range 변수
RANGES: R_SAKNR_4  FOR ZEA_SKB1-SAKNR. " GL계정
RANGES: R_SAKNR_5  FOR ZEA_SKB1-SAKNR. " GL계정
RANGES: R_SAKNR_6  FOR ZEA_SKB1-SAKNR. " GL계정
RANGES: R_SAKNR_7P FOR ZEA_SKB1-SAKNR. " GL계정
RANGES: R_SAKNR_7L FOR ZEA_SKB1-SAKNR. " GL계정
