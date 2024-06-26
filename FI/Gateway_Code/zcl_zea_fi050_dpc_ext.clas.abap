class ZCL_ZEA_FI050_DPC_EXT definition
  public
  inheriting from ZCL_ZEA_FI050_DPC
  create public .

public section.
protected section.

  methods TCURRSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZEA_FI050_DPC_EXT IMPLEMENTATION.


  METHOD TCURRSET_GET_ENTITYSET.


    DATA: GT_TCURR TYPE TABLE OF ZEA_FI050,
          GS_TCURR TYPE ZEA_FI050,
          LV_TOTAL TYPE P LENGTH 9 DECIMALS 5.

    SELECT * FROM ZEA_TCURR
      INTO CORRESPONDING FIELDS OF TABLE GT_TCURR
      ORDER BY GDATU.

    LOOP AT GT_TCURR INTO GS_TCURR.
      LV_TOTAL = LV_TOTAL + GS_TCURR-UKURS.

      GS_TCURR-AVERAGE = LV_TOTAL / SY-TABIX. " <== 환율 평균
      MODIFY GT_TCURR FROM GS_TCURR TRANSPORTING AVERAGE.
    ENDLOOP.

    APPEND LINES OF GT_TCURR TO ET_ENTITYSET.

  ENDMETHOD.
ENDCLASS.
