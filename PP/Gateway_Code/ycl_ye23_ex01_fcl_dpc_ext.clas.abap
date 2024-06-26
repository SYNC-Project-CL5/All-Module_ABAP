class YCL_YE23_EX01_FCL_DPC_EXT definition
  public
  inheriting from YCL_YE23_EX01_FCL_DPC
  create public .

public section.
protected section.

  methods CONNECTIONSET_GET_ENTITYSET
    redefinition .
  methods CARRIERSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS YCL_YE23_EX01_FCL_DPC_EXT IMPLEMENTATION.


  METHOD CARRIERSET_GET_ENTITYSET.

  " URL 경로 : /CarrierSet

    SELECT *
        FROM SCARR
        ORDER BY PRIMARY KEY
        INTO TABLE @ET_ENTITYSET.


  ENDMETHOD.


  method CONNECTIONSET_GET_ENTITYSET.

  " 항공사를 선택하면 해당 항공사의 항공편을 보여주기 위해
  " CarrierSet의 Navigation Property를 통해서 ConnectionSet에 접근한다.

  " URL : /CarrierSet('AA')/toConnection        "Key Fields가 1개인 경우
  " URL : /CarrierSet(Carrid='AA')/toConnection "Key Fields가 1개인 경우
  " URL : /CarrierSet(Carrid='AA',~~~='~~')/toConnection "Key Fields가 2개인 경우

  " URL : /ConnectionSet => IT_KEY_TAB 에 한줄도 없음
  DATA: LV_CARRID TYPE SPFLI-CARRID.

  LOOP AT IT_KEY_TAB INTO DATA(LS_KEY). " 괄호 안의 값들을 점검
    CASE LS_KEY-NAME.
      WHEN 'Carrid'.
        LV_CARRID = LS_KEY-VALUE.
    ENDCASE.
  ENDLOOP.

  IF SY-SUBRC EQ 0. " LOOP 가 한번이라도 작동했을 때
    SELECT *
    FROM SPFLI
    WHERE CARRID EQ @LV_CARRID " 괄호 안에 있던 Carrid의 값을 검색조건으로 사용
    ORDER BY PRIMARY KEY
    INTO TABLE @ET_ENTITYSET.
  ELSE. " LOOP 가 작동하지 않았을 때
    SELECT *
    FROM SPFLI
    ORDER BY PRIMARY KEY
    INTO TABLE @ET_ENTITYSET.
  ENDIF.


  endmethod.
ENDCLASS.
