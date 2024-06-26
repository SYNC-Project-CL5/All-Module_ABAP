class ZCL_ZEA_SD090_DPC_EXT definition
  public
  inheriting from ZCL_ZEA_SD090_DPC
  create public .

public section.
protected section.

  methods PRICESET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZEA_SD090_DPC_EXT IMPLEMENTATION.


  method PRICESET_GET_ENTITYSET.


    SELECT *
      FROM ZEA_SDT090 AS A
      JOIN ZEA_MMT020 AS B
        ON A~MATNR EQ B~MATNR
      INTO CORRESPONDING FIELDS OF TABLE @ET_ENTITYSET.

*      SORT ET_ENTITYSET BY VALID_EN.



  endmethod.
ENDCLASS.
