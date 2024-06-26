"FUNCTION ZEA_MM_MMFG .
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_PONUM) TYPE  ZEA_MMT140-PONUM
*"  EXPORTING
*"     REFERENCE(EV_MBLNR) TYPE  ZEA_MMT090-MBLNR
*"     REFERENCE(EV_RETURN) TYPE  CHAR1
*"----------------------------------------------------------------------
FUNCTION ZEA_MM_MMFG.


  " 7번 넘버레인지 자재문서 번호


  SELECT SINGLE *
    INTO @DATA(LS_DATA)
    FROM ZEA_MMT100
    WHERE PONUM EQ @IV_PONUM.
  IF SY-SUBRC EQ 0.
    RETURN.
  ENDIF.


  CLEAR: EV_MBLNR, EV_RETURN.
  CLEAR : GT_MMT140[], GT_MMT150[].


  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE  @GT_MMT140 "1건
    FROM ZEA_MMT140
    WHERE PONUM EQ @IV_PONUM.
  IF SY-SUBRC NE 0.
    EV_RETURN = 'E'.
    RETURN.
  ENDIF.


  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE @GT_MMT150
    FROM ZEA_MMT150
         FOR ALL ENTRIES IN @GT_MMT140
    WHERE PONUM EQ @GT_MMT140-PONUM.


  CLEAR: GT_MMT090[], GT_MMT100[].
  CLEAR: ZEA_MMT090-MBLNR.


  LOOP  AT  GT_MMT140  INTO  GS_MMT140.


        "구매오더 헤더를 읽으면서 자재문서 헤더데이터 생성
         PERFORM MAKE_MBLNR_HEADER_DATA TABLES GT_MMT090
                                        USING GS_MMT140
                                        CHANGING ZEA_MMT090-MBLNR.


         LOOP  AT  GT_MMT150  INTO  GS_MMT150
                              WHERE  PONUM  EQ  GS_MMT140-PONUM.


             "구매오더 아이템을 읽으면서 자재문서 아이템데이터 생성
              PERFORM MAKE_MBLNR_ITEM_DATA TABLES GT_MMT100
                                           USING GS_MMT150
                                                 ZEA_MMT090-MBLNR.


         ENDLOOP.


  ENDLOOP.


* Save Data
  IF GT_MMT090[] IS NOT INITIAL.
    INSERT ZEA_MMT090 FROM TABLE GT_MMT090 ACCEPTING DUPLICATE KEYS.
    IF SY-SUBRC NE 0.
      ROLLBACK WORK.
    ENDIF.
  ENDIF.
  IF GT_MMT100[] IS NOT INITIAL.
    INSERT ZEA_MMT100 FROM TABLE GT_MMT100 ACCEPTING DUPLICATE KEYS.
    IF SY-SUBRC NE 0.
      ROLLBACK WORK.
    ENDIF.
  ENDIF.


  EV_MBLNR  = ZEA_MMT090-MBLNR.
  EV_RETURN = 'S'.


ENDFUNCTION.
