class ZCL_ZEA_FI04_DPC_EXT definition
  public
  inheriting from ZCL_ZEA_FI04_DPC
  create public .

public section.
protected section.

*  methods BSEGSET_GET_ENTITYSET
*    redefinition .
  methods BSEG002SET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZEA_FI04_DPC_EXT IMPLEMENTATION.


  method BSEG002SET_GET_ENTITYSET.

DATA : LS_DATA TYPE ZEA_FS020,
       LT_DATA TYPE TABLE OF ZEA_FS020.

 SELECT A~SAKNR
        A~BPCODE
        B~BPNAME
       SUM( A~WRBTR ) AS  WRBTR
   FROM ZEA_BSEG AS A
   JOIN ZEA_SKA1 AS B
   ON A~BPCODE EQ B~BPCODE
   INTO CORRESPONDING FIELDS OF TABLE LT_DATA
   GROUP BY A~SAKNR A~BPCODE B~BPNAME.

LOOP AT LT_DATA INTO  LS_DATA
   WHERE BPCODE CP '2*'
    AND SAKNR BETWEEN 100310 AND 100360 .

  LS_DATA-WRBTR = LS_DATA-WRBTR * 100.
  LS_DATA-WAERS = 'KRW'.

  APPEND LS_DATA TO ET_ENTITYSET.

ENDLOOP.

  endmethod.
ENDCLASS.