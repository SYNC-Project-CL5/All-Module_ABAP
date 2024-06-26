class ZCL_ZEA_QRBATCH_DPC_EXT definition
  public
  inheriting from ZCL_ZEA_QRBATCH_DPC
  create public .

public section.
protected section.

  methods QRBATCHSET_GET_ENTITYSET
    redefinition .
  methods QRBATCHSET_GET_ENTITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZEA_QRBATCH_DPC_EXT IMPLEMENTATION.


  METHOD QRBATCHSET_GET_ENTITY.

* IT_KEY_TAB 은 EntitySet 의 ( ) 안의 값을 가지고 있다.
    DATA LS_KEY LIKE LINE OF IT_KEY_TAB.
    READ TABLE IT_KEY_TAB INTO LS_KEY INDEX 1.
*    READ TABLE IT_KEY_TAB INTO DATA(LS_KEY) INDEX 1.

    DATA LV_CHARG TYPE ZEA_MMT070-CHARG.
    IF LS_KEY-NAME EQ 'Charg'. " 어차피 키필드가 하나라서 비교할 필요가 없다.
      LV_CHARG = LS_KEY-VALUE.
*    elseif ls_key-name eq 'Matnr'.
*    lv_Matnr
    ENDIF.

* 한 줄을 검색하기 위한 조건이 필요함
    SELECT SINGLE
          A~CHARG
          A~MATNR
          B~MAKTX
          A~WERKS
          C~PNAME1
          A~CALQTY
          A~REMQTY
          A~MEINS
          D~TSDAT
          D~EMPCODE
          A~ERDAT
          A~ERNAM
     FROM ZEA_MMT070 AS A      " [MM] 배치 테이블 : 자재코드
     LEFT JOIN ZEA_MMT020 AS B      " [MM] 자재명Text Table : 자재코드-자재명
       ON A~MATNR EQ B~MATNR
      AND B~SPRAS EQ SY-LANGU
     JOIN ZEA_T001W  AS C      " [PP] 플랜트
       ON C~WERKS EQ A~WERKS
     JOIN ZEA_AFRU AS D
       ON D~CHARG EQ A~CHARG
      AND D~MATNR EQ A~MATNR
       INTO CORRESPONDING FIELDS OF ER_ENTITY
    WHERE A~CHARG EQ LV_CHARG.
*    ORDER BY A~WERKS.




  ENDMETHOD.


  METHOD QRBATCHSET_GET_ENTITYSET.

    " SIGN OPTION LOW HIGH 구조를 가진 Internal Table
    DATA R_CHARG TYPE RANGE OF ZEA_MMT070-CHARG.

    LOOP AT IT_FILTER_SELECT_OPTIONS INTO DATA(LS_FILTER).
      CASE LS_FILTER-PROPERTY.
        WHEN 'Charg'.
          MOVE-CORRESPONDING LS_FILTER-SELECT_OPTIONS TO R_CHARG.
      ENDCASE.
    ENDLOOP.


    DATA(LV_TOP) = IO_TECH_REQUEST_CONTEXT->GET_TOP( ).




    SELECT
    A~CHARG
    A~MATNR
    B~MAKTX
    A~WERKS
    C~PNAME1
    A~CALQTY
    A~REMQTY
    A~MEINS
    D~TSDAT
    D~EMPCODE
    A~ERDAT
    A~ERNAM
   FROM ZEA_MMT070 AS A      " [MM] 배치 테이블 : 자재코드
   LEFT JOIN ZEA_MMT020 AS B      " [MM] 자재명Text Table : 자재코드-자재명
     ON A~MATNR EQ B~MATNR
    AND B~SPRAS EQ SY-LANGU
   JOIN ZEA_T001W  AS C      " [PP] 플랜트
     ON C~WERKS EQ A~WERKS
   JOIN ZEA_AFRU AS D
     ON D~CHARG EQ A~CHARG
    AND D~MATNR EQ A~MATNR

   up to IS_PAGING-TOP rows
 INTO CORRESPONDING FIELDS OF TABLE ET_ENTITYSET
*  WHERE (IV_FILTER_STRING)
  WHERE A~CHARG IN R_CHARG
  ORDER BY A~WERKS.

  ENDMETHOD.
ENDCLASS.
