*&---------------------------------------------------------------------*
*& Include          YE00_EX005_TOP
*&---------------------------------------------------------------------*
TABLES SSCRFIELDS. " Selection Screen Fields

" 엑셀파일을 읽어올 때 사용되는 스트럭쳐 구조
" 해당 구조로 데이터를 읽어와 Internal Table에 적재
DATA: GT_INTERN TYPE TABLE OF ALSMEX_TABLINE.

" 읽어온 엑셀 데이터를 행/열 구조로 재배치 ( 전부 대소문자 구별되는 50자리 문자열 )
" 5개의 필드가 존재하는 Internal Table


DATA: BEGIN OF GS_EXCEL,
        BOMID    TYPE ALSMEX_TABLINE-VALUE,
        BOMINDEX TYPE ALSMEX_TABLINE-VALUE,
        MATNR    TYPE ALSMEX_TABLINE-VALUE,
        MENGE    TYPE ALSMEX_TABLINE-VALUE,
        MEINS    TYPE ALSMEX_TABLINE-VALUE,
      END OF GS_EXCEL,

      GT_EXCEL LIKE TABLE OF GS_EXCEL.


* BOM ID  플랜트ID 자재코드  수량  단위

* 저장하기 위한 인터널 테이블 선언
DATA GT_STPO TYPE TABLE OF ZEA_STPO.
DATA GS_STPO TYPE ZEA_STPO.
