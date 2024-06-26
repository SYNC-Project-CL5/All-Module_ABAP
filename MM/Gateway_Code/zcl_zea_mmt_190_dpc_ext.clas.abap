class ZCL_ZEA_MMT_190_DPC_EXT definition
  public
  inheriting from ZCL_ZEA_MMT_190_DPC
  create public .

public section.
protected section.

  methods PLANTSET_GET_ENTITY
    redefinition .
  methods PLANTSET_GET_ENTITYSET
    redefinition .
  methods STORAGEMAKTXSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZEA_MMT_190_DPC_EXT IMPLEMENTATION.


  method PLANTSET_GET_ENTITY.

  DATA: LV_WERKS TYPE ZEA_T001W-WERKS.

  LOOP AT IT_KEY_TAB INTO DATA(LS_KEY).
    CASE LS_KEY-NAME.
      WHEN 'Werks'.
        LV_WERKS = LS_KEY-VALUE.
    ENDCASE.
  ENDLOOP.

  SELECT SINGLE *
    FROM ZEA_T001W
    WHERE WERKS EQ @LV_WERKS
    INTO @ER_ENTITY.


  endmethod.


  method PLANTSET_GET_ENTITYSET.

*  SELECT *
*    FROM ZEA_T001W
*    ORDER BY PRIMARY KEY
*    INTO TABLE @ET_ENTITYSET.

SELECT *
  FROM ZEA_T001W
*  WHERE WERKS BETWEEN '10002' AND '10009'
  ORDER BY PRIMARY KEY
  INTO TABLE @ET_ENTITYSET.

  endmethod.


METHOD STORAGEMAKTXSET_GET_ENTITYSET.

    DATA: LV_WERKS TYPE ZEA_MMT190-WERKS.

    LOOP AT IT_KEY_TAB INTO DATA(LS_KEY).
      CASE LS_KEY-NAME.
        WHEN 'Werks'.
          LV_WERKS = LS_KEY-VALUE.
      ENDCASE.
    ENDLOOP.

**    IF LV_WERKS IS NOT INITIAL.
   IF SY-SUBRC EQ 0.
      SELECT A~* ,B~MAKTX
        FROM ZEA_MMT190 AS A
        LEFT OUTER JOIN ZEA_MMT020 AS B
          ON A~MATNR EQ B~MATNR
        WHERE A~WERKS EQ @LV_WERKS
          AND A~MATNR BETWEEN '30000000' AND '30000023'
          AND B~SPRAS EQ 'E'
        INTO CORRESPONDING FIELDS OF TABLE @ET_ENTITYSET.
    ELSE.

      SELECT A~*,B~MAKTX
        FROM ZEA_MMT190 AS A
        LEFT OUTER JOIN ZEA_MMT020 AS B
          ON A~MATNR EQ B~MATNR
        WHERE A~MATNR BETWEEN '30000000' AND '30000023'
          AND B~SPRAS EQ 'E'
        INTO CORRESPONDING FIELDS OF TABLE @ET_ENTITYSET.
    ENDIF.

ENDMETHOD.
ENDCLASS.
