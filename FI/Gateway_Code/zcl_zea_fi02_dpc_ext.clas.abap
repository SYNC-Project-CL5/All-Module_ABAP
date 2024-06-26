class ZCL_ZEA_FI02_DPC_EXT definition
  public
  inheriting from ZCL_ZEA_FI02_DPC
  create public .

public section.
protected section.

  methods ZEA_BKPFSET_GET_ENTITY
    redefinition .
  methods ZEA_BKPFSET_GET_ENTITYSET
    redefinition .
  methods ZEA_BSEGSET_GET_ENTITYSET
    redefinition .
  methods ZEA_BSEGSET_GET_ENTITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZEA_FI02_DPC_EXT IMPLEMENTATION.


  METHOD ZEA_BKPFSET_GET_ENTITY.

* IT_KEY_TAB 은 EntitySet 의 ( ) 안의 값을 가지고 있다.
    DATA LS_KEY LIKE LINE OF IT_KEY_TAB.
    READ TABLE IT_KEY_TAB INTO LS_KEY INDEX 1.
*    READ TABLE IT_KEY_TAB INTO DATA(LS_KEY) INDEX 1.

        DATA : LV_belnr TYPE ZEA_BKPF-BELNR,
                LV_BUKRS TYPE ZEA_BKPF-BUKRS.

    LOOP AT IT_KEY_TAB INTO LS_KEY.
      CASE LS_KEY-NAME.
        WHEN 'BELNR'.
          LV_BELNR = LS_KEY-VALUE.
*        WHEN 'BUKRS'.
*          LV_BUKRS = LS_KEY-VALUE.
        WHEN OTHERS.
      ENDCASE.
    ENDLOOP.

**
    IF SY-SUBRC EQ 0. " LOOP 가 한번이라도 작동했을 때
      SELECT SINGLE *
        FROM ZEA_BKPF
      WHERE BELNR EQ  @LV_BELNR " 괄호 안에 있던 Carrid의 값을 검색조건으로 사용
        INTO  @ER_ENTITY.
    ELSE. " LOOP 가 작동하지 않았을 때
      SELECT SINGLE *
        FROM ZEA_BKPF
        INTO   @ER_ENTITY.
    ENDIF.



  ENDMETHOD.


  method ZEA_BKPFSET_GET_ENTITYSET.

* $filter, $orderby, $top, $skip, $expand 등등 다 안됨
    SELECT *
      FROM ZEA_BKPF
      INTO TABLE ET_ENTITYSET
      ORDER BY PRIMARY KEY.


  endmethod.


  method ZEA_BSEGSET_GET_ENTITY.
**
*
** IT_KEY_TAB 은 EntitySet 의 ( ) 안의 값을 가지고 있다.
*    DATA LS_KEY LIKE LINE OF IT_KEY_TAB.
*    READ TABLE IT_KEY_TAB INTO LS_KEY INDEX 1.
**    READ TABLE IT_KEY_TAB INTO DATA(LS_KEY) INDEX 1.
*
*        DATA : LV_belnr TYPE ZEA_BKPF-BELNR,
*                LV_BUKRS TYPE ZEA_BKPF-BUKRS.
*
*    LOOP AT IT_KEY_TAB INTO LS_KEY.
*      CASE LS_KEY-NAME.
*        WHEN 'BELNR'.
*          LV_BELNR = LS_KEY-VALUE.
**        WHEN 'BUKRS'.
**          LV_BUKRS = LS_KEY-VALUE.
*        WHEN OTHERS.
*      ENDCASE.
*    ENDLOOP.
*
***
*    IF SY-SUBRC EQ 0. " LOOP 가 한번이라도 작동했을 때
*      SELECT SINGLE *
*        FROM ZEA_BSEG
*      WHERE BELNR EQ  @LV_BELNR " 괄호 안에 있던 Carrid의 값을 검색조건으로 사용
*        INTO  @ER_ENTITY.
*    ELSE. " LOOP 가 작동하지 않았을 때
*      SELECT SINGLE *
*        FROM ZEA_BSEG
*        INTO   @ER_ENTITY.
*    ENDIF.


  endmethod.


  METHOD ZEA_BSEGSET_GET_ENTITYSET.

    " 항공사를 선택하면 해당 항공사의 항공편을 보여주기 위해
    " CarrierSet의 Navigation Property를 통해서 ConnectionSet에 접근한다.

    " URL : /CarrierSet('AA')/toConnection        " Key Fields가 1개인 경우
    " URL : /CarrierSet(Carrid='AA')/toConnection " Key Fields가 1개인 경우
    " URL : /CarrierSet(Carrid='AA',Key2='XX')/toConnection " Key Fields가 2개인 경우

    " URL : /ConnectionSet => IT_KEY_TAB 에 한줄도 없음
*    DATA: LV_BELNR TYPE ZEA_BKPF-BELNR.

*    LOOP AT IT_KEY_TAB INTO DATA(LS_KEY). " 괄호 안의 값들을 점검
*      CASE LS_KEY-NAME.
*        WHEN 'BELNR'.
*          LV_BELNR = LS_KEY-VALUE.
*      ENDCASE.
*    ENDLOOP.

*    IF SY-SUBRC EQ 0. " LOOP 가 한번이라도 작동했을 때
*      SELECT *
*        FROM ZEA_BSEG
*       WHERE BELNR EQ @LV_BELNR " 괄호 안에 있던 Carrid의 값을 검색조건으로 사용
*       ORDER BY PRIMARY KEY
*        INTO TABLE @ET_ENTITYSET.
*    ELSE. " LOOP 가 작동하지 않았을 때
*      SELECT *
*        FROM ZEA_BSEG
*       ORDER BY PRIMARY KEY
*        INTO TABLE @ET_ENTITYSET.
*    ENDIF.

*  SELECT SAKNR SUM( DMBTR ) BPCODE
*      FROM ZEA_BSEG
*      INTO TABLE ET_ENTITYSET
*      GROUP BY SAKNR BPCODE.



  ENDMETHOD.
ENDCLASS.
