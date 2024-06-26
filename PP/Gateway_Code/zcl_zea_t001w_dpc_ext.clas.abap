class ZCL_ZEA_T001W_DPC_EXT definition
  public
  inheriting from ZCL_ZEA_T001W_DPC
  create public .

public section.
protected section.

  methods STORESET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZEA_T001W_DPC_EXT IMPLEMENTATION.


  METHOD STORESET_GET_ENTITYSET.

    SELECT
      FROM ZEA_T001W  AS A
      JOIN ZEA_MMT060 AS B
        ON B~WERKS EQ A~WERKS
      FIELDS *
      INTO CORRESPONDING FIELDS OF TABLE @ET_ENTITYSET.

    SORT ET_ENTITYSET BY WERKS.

  ENDMETHOD.
ENDCLASS.
