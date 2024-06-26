*&---------------------------------------------------------------------*
*& Include          YE00_EX005_TOP
*&---------------------------------------------------------------------*
TABLES: SSCRFIELDS, " Selection Screen Fields
        ZEA_SDT020.

" 엑셀파일을 읽어올 때 사용되는 스트럭쳐 구조
" 해당 구조로 데이터를 읽어와 Internal Table에 적재
DATA: GT_INTERN TYPE TABLE OF ALSMEX_TABLINE.

" 읽어온 엑셀 데이터를 행/열 구조로 재배치 ( 전부 대소문자 구별되는 50자리 문자열 )
" 7개의 필드가 존재하는 Internal Table


DATA: BEGIN OF GS_EXCEL,
        SAPNR   TYPE ALSMEX_TABLINE-VALUE,
        SP_YEAR TYPE ALSMEX_TABLINE-VALUE,
        WERKS   TYPE ALSMEX_TABLINE-VALUE,
        SAPQU   TYPE ALSMEX_TABLINE-VALUE,
        MEINS   TYPE ALSMEX_TABLINE-VALUE,
        TOTREV  TYPE ALSMEX_TABLINE-VALUE,
        WAERS   TYPE ALSMEX_TABLINE-VALUE,

      END OF GS_EXCEL,

      GT_EXCEL LIKE TABLE OF GS_EXCEL.

* 저장하기 위한 인터널 테이블 선언
DATA GT_SDT020 TYPE TABLE OF ZEA_SDT020.
DATA GS_SDT020 TYPE ZEA_SDT020.
