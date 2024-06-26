FUNCTION ZEA_BELNR_NR.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  EXPORTING
*"     REFERENCE(EV_NUMBER) TYPE  ZEA_BELNR
*"----------------------------------------------------------------------
*&---------------------------------------------------------------------*
*& Form NUMBER_ZEA_BELNR
*& 전표번호 RANGE 변수 생성
*&---------------------------------------------------------------------*

  DATA: LV_RC TYPE INRI-RETURNCODE.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      NR_RANGE_NR             = '01'          " NR에 지정한 No
      OBJECT                  = 'ZEA_BELNR'   " number range obj 명
    IMPORTING
      NUMBER                  = EV_NUMBER
      RETURNCODE              = LV_RC         " 저장할 변수.
    EXCEPTIONS
      INTERVAL_NOT_FOUND      = 1
      NUMBER_RANGE_NOT_INTERN = 2
      OBJECT_NOT_FOUND        = 3
      QUANTITY_IS_0           = 4
      QUANTITY_IS_NOT_1       = 5
      INTERVAL_OVERFLOW       = 6
      BUFFER_OVERFLOW         = 7
      OTHERS                  = 8.
  IF SY-SUBRC <> 0.
    MESSAGE '전표번호 채번이 실패하였습니다' TYPE 'I' DISPLAY LIKE 'E'.
  ENDIF.

ENDFUNCTION.
