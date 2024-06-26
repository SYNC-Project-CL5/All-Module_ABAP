FUNCTION-POOL ZEA_FI_PP.                    "MESSAGE-ID ..

* INCLUDE LZEA_FI_PPD...                     " Local class definition
*"----------------------------------------------------------------------
*                   Variant About Function Module
*"----------------------------------------------------------------------
  TABLES: ZEA_BKPF, ZEA_BSEG,       " FI 헤더/ 아이템
          ZEA_MMT010, ZEA_MMT020 .  " MM 자재/ 자재 Text

  " FI 전표 헤더 테이블
  DATA: GT_BKPF TYPE TABLE OF ZEA_BKPF,
        GS_BKPF TYPE ZEA_BKPF.

  " FI 전표 아이템 테이블
  DATA: GT_BSEG TYPE TABLE OF ZEA_BSEG,
        GS_BSEG TYPE ZEA_BSEG.


*-- Variant
* --FI 전표번호 채번
  DATA: GV_BELNR_NUMBER TYPE ZEA_BKPF-BELNR.      " 전표번호(key)
  DATA: GV_ITNUM TYPE N.
