class ZCL_ZEA_SD080_DPC_EXT definition
  public
  inheriting from ZCL_ZEA_SD080_DPC
  create public .

public section.
protected section.

  methods BOOKSET_GET_ENTITYSET
    redefinition .
  methods ONLINEBOOKSET_GET_ENTITYSET
    redefinition .
  methods ONLINEBOOKSET_GET_ENTITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZEA_SD080_DPC_EXT IMPLEMENTATION.


  method BOOKSET_GET_ENTITYSET.

      SELECT *
      FROM ZEA_SDT080
      ORDER BY PRIMARY KEY
      INTO TABLE @ET_ENTITYSET.

  endmethod.


  METHOD ONLINEBOOKSET_GET_ENTITY.

    DATA LV_BOOKID TYPE ZEA_SDS080-BOOKID.

    LOOP AT IT_KEY_TAB INTO DATA(LS_KEY).
      CASE LS_KEY-NAME.
        WHEN 'Bookid'.
          LV_BOOKID = LS_KEY-VALUE.
      ENDCASE.
    ENDLOOP.

    SELECT SINGLE *
    FROM ZEA_SDT080 AS A
    LEFT OUTER JOIN ZEA_MMT020 AS B
      ON A~MATNR EQ B~MATNR
     AND B~SPRAS EQ @SY-LANGU
    JOIN ZEA_T001W  AS C
      ON A~WERKS EQ C~WERKS
      INTO CORRESPONDING FIELDS OF @ER_ENTITY
       WHERE BOOKID EQ @LV_BOOKID.

  ENDMETHOD.


  method ONLINEBOOKSET_GET_ENTITYSET.

 DATA : LS_080 TYPE ZEA_SDS080,
        LT_080 TYPE TABLE OF ZEA_SDS080.

      SELECT A~BOOKID, A~CUSTNAME, A~TELNO, A~VISITDAT, A~WERKS,
             C~PNAME1, B~MATNR, B~MAKTX, A~AUQUA, A~MEINS, A~NETPR,
             A~WAERS
      FROM ZEA_SDT080 AS A
      LEFT OUTER JOIN ZEA_MMT020 AS B
        ON A~MATNR EQ B~MATNR
       AND B~SPRAS EQ @SY-LANGU
      JOIN ZEA_T001W  AS C
        ON A~WERKS EQ C~WERKS
      INTO CORRESPONDING FIELDS OF TABLE @LT_080.

    LOOP AT LT_080 INTO LS_080.
      LS_080-TOAMT = LS_080-AUQUA * LS_080-NETPR.
      APPEND LS_080 to ET_ENTITYSET.
    ENDLOOP.




  endmethod.
ENDCLASS.