class ZCL_ZEA_SD_001_DPC_EXT definition
  public
  inheriting from ZCL_ZEA_SD_001_DPC
  create public .

public section.
protected section.

  methods SALES001SET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZEA_SD_001_DPC_EXT IMPLEMENTATION.


  method SALES001SET_GET_ENTITYSET.
    SELECT *
      FROM ZEA_SDT010 AS A LEFT JOIN ZEA_T001W  AS B ON A~WERKS EQ B~WERKS
                           LEFT JOIN ZEA_MMT020 AS C ON A~MATNR EQ C~MATNR
                                                    AND C~SPRAS EQ @SY-LANGU
      INTO CORRESPONDING FIELDS OF TABLE @ET_ENTITYSET
     WHERE A~WERKS BETWEEN 10002 AND 10009.

    SORT ET_ENTITYSET BY SV_YEAR WERKS MATNR.
  endmethod.
ENDCLASS.
