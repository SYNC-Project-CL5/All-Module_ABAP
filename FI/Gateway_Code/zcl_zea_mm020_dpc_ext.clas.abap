class ZCL_ZEA_MM020_DPC_EXT definition
  public
  inheriting from ZCL_ZEA_MM020_DPC
  create public .

public section.
protected section.

  methods ZEA_MM010SET_GET_ENTITYSET
    redefinition .
  methods ZEA_MM010SET_GET_ENTITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZEA_MM020_DPC_EXT IMPLEMENTATION.


  METHOD ZEA_MM010SET_GET_ENTITY.

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
      FROM ZEA_MMT070 AS A    " [MM] 배치 테이블 : 자재코드
      JOIN ZEA_MMT020 AS B    " [MM] 자재명Text Table : 자재코드-자재명
        ON A~MATNR EQ B~MATNR
      JOIN ZEA_T001W  AS C    " [PP] 플랜트
        ON C~WERKS EQ A~WERKS

    INTO ER_ENTITY
      WHERE A~CHARG EQ '80000019'
        AND A~MATNR NE ''
        AND A~SCODE EQ 'SL01'.

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
      JOIN ZEA_MMT020 AS B " [MM] 자재명Text Table : 자재코드-자재명
        ON A~MATNR EQ B~MATNR
      JOIN ZEA_T001W  AS C " [PP] 플랜트
        ON C~WERKS EQ A~WERKS

    INTO TABLE ET_ENTITYSET
      WHERE A~CHARG EQ '80000019'
        AND A~MATNR NE ''

     ORDER BY A~WERKS.


  ENDMETHOD.
ENDCLASS.
