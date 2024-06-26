*----------------------------------------------------------------------*
***INCLUDE LZEA_FI_KAF01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form NR_ZEA_BELNR
*&---------------------------------------------------------------------*
FORM NR_ZEA_BELNR  CHANGING CV_BELNR_NUMBER.

  DATA: LV_RC TYPE INRI-RETURNCODE.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      NR_RANGE_NR             = '01'          " NR에 지정한 No
      OBJECT                  = 'ZEA_BELNR'   " number range obj 명
    IMPORTING
      NUMBER                  = CV_BELNR_NUMBER
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
  ENDIF.

ENDFORM.
