*&---------------------------------------------------------------------*
*& Include          YE00_EX005_TOP
*&---------------------------------------------------------------------*
TABLES: SSCRFIELDS, " Selection Screen Fields
        ZEA_STKO.

" 엑셀파일을 읽어올 때 사용되는 스트럭쳐 구조
" 해당 구조로 데이터를 읽어와 Internal Table에 적재
DATA: GT_INTERN TYPE TABLE OF ALSMEX_TABLINE.

" 읽어온 엑셀 데이터를 행/열 구조로 재배치 ( 전부 대소문자 구별되는 50자리 문자열 )
" 9개의 필드가 존재하는 Internal Table

* BOM ID
* 플랜트 ID
* 헤더 자재코드
* 헤더 기준수량
* 헤더 단위
* BOMINDEX
* 아이템
* 자재코드
* 아이템 무게
* 아이템 단위


DATA: BEGIN OF GS_EXCEL,
        BOMID        TYPE ALSMEX_TABLINE-VALUE,
        WERKS        TYPE ALSMEX_TABLINE-VALUE,
        MATNR_HEADER TYPE ALSMEX_TABLINE-VALUE,
        MENGE_HEADER TYPE ALSMEX_TABLINE-VALUE,
        MEINS_HEADER TYPE ALSMEX_TABLINE-VALUE,
        BOMINDEX     TYPE ALSMEX_TABLINE-VALUE,
        MATNR_ITEM   TYPE ALSMEX_TABLINE-VALUE,
        MENGE_ITEM   TYPE ALSMEX_TABLINE-VALUE,
        MEINS_ITEM   TYPE ALSMEX_TABLINE-VALUE,
      END OF GS_EXCEL,

      GT_EXCEL LIKE TABLE OF GS_EXCEL.

* 저장하기 위한 인터널 테이블 선언
DATA GT_STKO TYPE TABLE OF ZEA_STKO.
DATA GS_STKO TYPE ZEA_STKO.

DATA GT_STPO TYPE TABLE OF ZEA_STPO.
DATA GS_STPO TYPE ZEA_STPO.
