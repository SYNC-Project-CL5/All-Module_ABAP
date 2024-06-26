class ZCL_ZEA_BATCH_01_DPC_EXT definition
  public
  inheriting from ZCL_ZEA_BATCH_01_DPC
  create public .

public section.
protected section.

  methods BATCHSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZEA_BATCH_01_DPC_EXT IMPLEMENTATION.


  method BATCHSET_GET_ENTITYSET.

    SELECT
      A~CHARG
      A~MATNR
      B~MAKTX
      A~WERKS
      C~PNAME1
      A~CALQTY
      A~REMQTY
      A~MEINS
      A~ERDAT
      A~ERZET
         FROM ZEA_MMT070 AS A      " [MM] 배치 테이블 : 자재코드
         JOIN ZEA_MMT020 AS B      " [MM] 자재명Text Table : 자재코드-자재명
           ON A~MATNR EQ B~MATNR
*           AND B~SPRAS EQ SY-LANGU
         JOIN ZEA_T001W  AS C      " [PP] 플랜트
           ON C~WERKS EQ A~WERKS
       INTO CORRESPONDING FIELDS OF TABLE ET_ENTITYSET

        ORDER BY A~CHARG.

  endmethod.
ENDCLASS.
