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
        SAPNR       TYPE ALSMEX_TABLINE-VALUE,
        SP_YEAR     TYPE ALSMEX_TABLINE-VALUE,
        POSNR       TYPE ALSMEX_TABLINE-VALUE,
        WERKS       TYPE ALSMEX_TABLINE-VALUE,
        MATNR       TYPE ALSMEX_TABLINE-VALUE,
        SAPQU       TYPE ALSMEX_TABLINE-VALUE,
        MEINS       TYPE ALSMEX_TABLINE-VALUE,
        NETPR       TYPE ALSMEX_TABLINE-VALUE,
        WAERS       TYPE ALSMEX_TABLINE-VALUE,
        SPQTY1      TYPE ALSMEX_TABLINE-VALUE,
        SPQTY2      TYPE ALSMEX_TABLINE-VALUE,
        SPQTY3      TYPE ALSMEX_TABLINE-VALUE,
        SPQTY4      TYPE ALSMEX_TABLINE-VALUE,
        SPQTY5      TYPE ALSMEX_TABLINE-VALUE,
        SPQTY6      TYPE ALSMEX_TABLINE-VALUE,
        SPQTY7      TYPE ALSMEX_TABLINE-VALUE,
        SPQTY8      TYPE ALSMEX_TABLINE-VALUE,
        SPQTY9      TYPE ALSMEX_TABLINE-VALUE,
        SPQTY10     TYPE ALSMEX_TABLINE-VALUE,
        SPQTY11     TYPE ALSMEX_TABLINE-VALUE,
        SPQTY12     TYPE ALSMEX_TABLINE-VALUE,
        STATUS2     TYPE ALSMEX_TABLINE-VALUE,
        LOEKZ       TYPE ALSMEX_TABLINE-VALUE,
      END OF GS_EXCEL,

      GT_EXCEL LIKE TABLE OF GS_EXCEL.

DATA GT_SDT030  TYPE TABLE OF ZEA_SDT030.
DATA GS_SDT030  TYPE ZEA_SDT030.
