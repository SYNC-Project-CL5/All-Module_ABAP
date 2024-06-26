class ZCL_ZEA_MM_002_01_DPC_EXT definition
  public
  inheriting from ZCL_ZEA_MM_002_01_DPC
  create public .

public section.
protected section.

  methods EMPINFOSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZEA_MM_002_01_DPC_EXT IMPLEMENTATION.


  method EMPINFOSET_GET_ENTITYSET.

  SELECT *
    FROM ZEA_PA0000
    INTO CORRESPONDING FIELDS OF TABLE @ET_ENTITYSET.

**    SORT ET_ENTITYSET BY EMPCODE.

  endmethod.
ENDCLASS.
