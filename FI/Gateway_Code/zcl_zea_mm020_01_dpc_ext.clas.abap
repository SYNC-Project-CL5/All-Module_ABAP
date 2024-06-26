class ZCL_ZEA_MM020_01_DPC_EXT definition
  public
  inheriting from ZCL_ZEA_MM020_01_DPC
  create public .

public section.
protected section.

  methods ZEA_MM010SET_GET_ENTITYSET
    redefinition .
  methods ZEA_MM010SET_GET_ENTITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZEA_MM020_01_DPC_EXT IMPLEMENTATION.


  METHOD ZEA_MM010SET_GET_ENTITY.

* IT_KEY_TAB 은 EntitySet 의 ( ) 안의 값을 가지고 있다.
    DATA LS_KEY LIKE LINE OF IT_KEY_TAB.
    READ TABLE IT_KEY_TAB INTO LS_KEY INDEX 1.
*    READ TABLE IT_KEY_TAB INTO DATA(LS_KEY) INDEX 1.

    DATA LV_CHARG TYPE ZEA_MMT070-CHARG.
*    IF LS_KEY-NAME EQ 'Carrid'. " 어차피 키필드가 하나라서 비교할 필요가 없다.
    LV_CHARG = LS_KEY-VALUE.
*    ENDIF.

* 한 줄을 검색하기 위한 조건이 필요함
*    SELECT SINGLE *
*      FROM ZEA_AFRU AS A
*      JOIN ZEA_MMT020 AS B
*             ON B~MATNR EQ A~MATNR
*     INTO CORRESPONDING FIELDS OF ER_ENTITY
*     WHERE A~AUFNR EQ LV_AUFNR.


    SELECT SINGLE
          A~CHARG   " 배치 번호
          A~MATNR   " 자재코드
          B~MAKTX   " 자재명
          A~WERKS   " 플랜트ID
          A~SCODE   " 저장위치 코드
          C~PNAME1 AS SNAME   " 저장위치명
          A~CALQTY  " 수량
          A~REMQTY  " 잔여수량
          A~MEINS   " 단위
          A~ERDAT   " 레코드 생성일
          A~ERNAM   "오브젝트 생성자 이름
     FROM ZEA_MMT070 AS A      " [MM] 배치 테이블 : 자재코드
     JOIN ZEA_MMT020 AS B      " [MM] 자재명Text Table : 자재코드-자재명
       ON A~MATNR EQ B~MATNR
       AND B~SPRAS EQ SY-LANGU
     JOIN ZEA_T001W  AS C      " [PP] 플랜트
       ON C~WERKS EQ A~WERKS
   INTO CORRESPONDING FIELDS OF ER_ENTITY
     WHERE A~CHARG EQ LV_CHARG
       AND A~MATNR NE ''.


  ENDMETHOD.


  METHOD ZEA_MM010SET_GET_ENTITYSET.

    DATA: GS_MM010 TYPE ZEA_MM010,
          GT_MM010 TYPE TABLE OF ZEA_MM010.

    " 자재코드 연결 => 배치번호를 뽑아내면 모두 다 조회되도록.
    " 가정 :
*    - 배치번호 : 80000006 (=> DB에 있는 거 하나)
*    - 생산일자 : 레코드 생성일
*    - 위치 : 현재 잔여수량의 위치
*    - 잔여수량 : xx 개 (동일 배치번호의 잔여수량)

    SELECT
      A~CHARG   " 배치 번호
      A~MATNR   " 자재코드
      B~MAKTX   " 자재명
      A~WERKS   " 플랜트ID
      A~SCODE   " 저장위치 코드
      C~PNAME1 AS SNAME   " 저장위치명
      A~CALQTY  " 수량
      A~REMQTY  " 잔여수량
      A~MEINS   " 단위
      A~ERDAT   " 레코드 생성일
      A~ERNAM   "오브젝트 생성자 이름
      FROM ZEA_MMT070 AS A      " [MM] 배치 테이블 : 자재코드
      JOIN ZEA_MMT020 AS B      " [MM] 자재명Text Table : 자재코드-자재명
        ON A~MATNR EQ B~MATNR
        AND B~SPRAS EQ SY-LANGU
      JOIN ZEA_T001W  AS C      " [PP] 플랜트
        ON C~WERKS EQ A~WERKS
    INTO CORRESPONDING FIELDS OF TABLE ET_ENTITYSET
      WHERE A~CHARG EQ '80000019'
      AND A~MATNR NE ''

     ORDER BY A~WERKS.


*    LOOP AT GT_MM010 INTO GS_MM010.
*      IF GS_MM010-WERKS NE '10000' AND GS_MM010-WERKS NE '10001'.
*        GS_MM010-SALES = SY-TABIX * 5.
*      ELSE.
*        GS_MM010-SALES = 0.
*      ENDIF.
*
*      MODIFY GT_MM010 FROM GS_MM010 TRANSPORTING SALES.
*    ENDLOOP.
*
*    APPEND LINES OF GT_MM010 TO ET_ENTITYSET.

  ENDMETHOD.
ENDCLASS.
