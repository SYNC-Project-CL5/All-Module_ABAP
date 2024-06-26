*&---------------------------------------------------------------------*
*& Include          YE00_EX005_TOP
*&---------------------------------------------------------------------*

TABLES SSCRFIELDS. " Selection SCReen FEIDLS

" 엑셀파일을 읽어올 때 사용되는 스트럭쳐 구조
" 해당 구조로 데이터를 읽어와 Internal Table에 적재
DATA: GT_INTERN TYPE TABLE OF ALSMEX_TABLINE.

" 읽어온 엑셀 데이터를 행/열 구조로 재배치 ( 전부 대소문자 구별되는 50자리 문자열 )
" 9개의 필드가 존재하는 Internal Table


DATA: BEGIN OF GS_EXCEL,
        MATNR   TYPE ALSMEX_TABLINE-VALUE,
        MAKTX   TYPE ALSMEX_TABLINE-VALUE,
        MATTYPE TYPE ALSMEX_TABLINE-VALUE,
        MATGRP  TYPE ALSMEX_TABLINE-VALUE,
        BSTME   TYPE ALSMEX_TABLINE-VALUE,
        MEINS2  TYPE ALSMEX_TABLINE-VALUE,
        WEIGHT  TYPE ALSMEX_TABLINE-VALUE,
        MEINS1  TYPE ALSMEX_TABLINE-VALUE,
        STPRS   TYPE ALSMEX_TABLINE-VALUE,
        WAERS   TYPE ALSMEX_TABLINE-VALUE,
      END OF GS_EXCEL,

GT_EXCEL LIKE TABLE OF GS_EXCEL.

*      자재코드 자재유형  자재단위  자재설명  길이  단위  무게  단위  취급시작일자

* 저장하기 위한 Internal Table과 Work Area 선언
DATA GT_MARA TYPE TABLE OF ZEA_MMT010.
DATA GS_MARA TYPE ZEA_MMT010.

DATA GT_MAKT TYPE TABLE OF ZEA_MMT020.
DATA GS_MAKT TYPE ZEA_MMT020.
