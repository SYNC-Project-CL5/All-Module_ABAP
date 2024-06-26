class ZCL_ZEA_SD080GW_DPC_EXT definition
  public
  inheriting from ZCL_ZEA_SD080GW_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CHANGESET_BEGIN
    redefinition .
protected section.

  methods MATSET_GET_ENTITY
    redefinition .
  methods ORDERHISTORYSET_GET_ENTITY
    redefinition .
  methods ORDERSET_CREATE_ENTITY
    redefinition .
  methods ORDERSET_GET_ENTITYSET
    redefinition .
  methods PSTOCKSET_GET_ENTITY
    redefinition .
  methods PSTOCKSET_GET_ENTITYSET
    redefinition .
  methods STOCKSET_GET_ENTITY
    redefinition .
  methods STOCKSET_GET_ENTITYSET
    redefinition .
  methods ORDERHISTORYSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZEA_SD080GW_DPC_EXT IMPLEMENTATION.


  method /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CHANGESET_BEGIN.
**TRY.
*CALL METHOD SUPER->/IWBEP/IF_MGW_APPL_SRV_RUNTIME~CHANGESET_BEGIN
*  EXPORTING
*    IT_OPERATION_INFO =
**  CHANGING
**    CV_DEFER_MODE     =
*    .
**  CATCH /IWBEP/CX_MGW_BUSI_EXCEPTION.
**  CATCH /IWBEP/CX_MGW_TECH_EXCEPTION.
**ENDTRY.
  endmethod.


  METHOD MATSET_GET_ENTITY.

* IT_KEY_TAB 은 EntitySet 의 ( ) 안의 값을 가지고 있다.
    DATA LS_KEY LIKE LINE OF IT_KEY_TAB.
    READ TABLE IT_KEY_TAB INTO LS_KEY INDEX 1.
*    READ TABLE IT_KEY_TAB INTO DATA(LS_KEY) INDEX 1.

    DATA LV_MATNR TYPE ZEA_MMT010-MATNR.
*    IF LS_KEY-NAME EQ 'Carrid'. " 어차피 키필드가 하나라서 비교할 필요가 없다.
    LV_MATNR = LS_KEY-VALUE.
*    ENDIF.

* 한 줄을 검색하기 위한 조건이 필요함
    SELECT SINGLE A~MATNR
                  B~MAKTX
                  A~NETPR
                  A~WAERS
                  C~MEINS2
      FROM ZEA_SDT090 AS A
      JOIN ZEA_MMT020 AS B ON B~MATNR EQ A~MATNR
                          AND B~SPRAS EQ SY-LANGU
      JOIN ZEA_MMT010 AS C ON C~MATNR EQ A~MATNR
      INTO ER_ENTITY
      WHERE A~MATNR EQ LV_MATNR.

  ENDMETHOD.


  METHOD ORDERHISTORYSET_GET_ENTITY.

* IT_KEY_TAB 은 EntitySet 의 ( ) 안의 값을 가지고 있다.
    DATA LS_KEY LIKE LINE OF IT_KEY_TAB.
    READ TABLE IT_KEY_TAB INTO LS_KEY INDEX 1.
*    READ TABLE IT_KEY_TAB INTO DATA(LS_KEY) INDEX 1.

    DATA LV_TELNO TYPE ZEA_SDT080-TELNO.
*    IF LS_KEY-NAME EQ 'Carrid'. " 어차피 키필드가 하나라서 비교할 필요가 없다.
      LV_TELNO = LS_KEY-VALUE.
*    ENDIF.

* 한 줄을 검색하기 위한 조건이 필요함
    SELECT SINGLE *
      FROM ZEA_SDT080
      INTO CORRESPONDING FIELDS OF ER_ENTITY
      WHERE TELNO EQ LV_TELNO.

  ENDMETHOD.


  method ORDERHISTORYSET_GET_ENTITYSET.
    DATA R_TELNO TYPE RANGE OF ZEA_SDT080-TELNO.

     LOOP AT IT_FILTER_SELECT_OPTIONS INTO DATA(LS_FILTER).
      CASE LS_FILTER-PROPERTY.
        WHEN 'Telno'.
          MOVE-CORRESPONDING LS_FILTER-SELECT_OPTIONS TO R_TELNO.
      ENDCASE.
    ENDLOOP.

    DATA(LV_TOP) = IO_TECH_REQUEST_CONTEXT->GET_TOP( ).

* $filter, $orderby, $top, $skip, $expand 등등 다 안됨
    SELECT *
      FROM ZEA_SDT080
      UP TO IS_PAGING-TOP ROWS
      INTO CORRESPONDING FIELDS OF TABLE ET_ENTITYSET
      WHERE TELNO IN R_TELNO
      ORDER BY PRIMARY KEY.

  endmethod.


  method ORDERSET_CREATE_ENTITY.

*  HTTP Request Body 를 가져오기 위한 작업
    CALL METHOD IO_DATA_PROVIDER->READ_ENTRY_DATA
      IMPORTING
        ES_DATA = ER_ENTITY.
*    CATCH /IWBEP/CX_MGW_TECH_EXCEPTION. " mgw technical exception

    DATA LS_SDT080 TYPE ZEA_SDT080.

    MOVE-CORRESPONDING ER_ENTITY TO LS_SDT080.

    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        NR_RANGE_NR             = '1'                 " Number range number
        OBJECT                  = 'ZEA_BOOKID'                 " Name of number range object
      IMPORTING
        NUMBER                  = LS_SDT080-BOOKID                 " free number
      EXCEPTIONS
        INTERVAL_NOT_FOUND      = 1                " Interval not found
        NUMBER_RANGE_NOT_INTERN = 2                " Number range is not internal
        OBJECT_NOT_FOUND        = 3                " Object not defined in TNRO
        QUANTITY_IS_0           = 4                " Number of numbers requested must be > 0
        QUANTITY_IS_NOT_1       = 5                " Number of numbers requested must be 1
        INTERVAL_OVERFLOW       = 6                " Interval used up. Change not possible.
        BUFFER_OVERFLOW         = 7                " Buffer is full
        OTHERS                  = 8
      .
    IF SY-SUBRC <> 0.
     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
       WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.


    LS_SDT080-BOOKID(2) = 'SC'.

*    LS_SDT080-BOOKID = 'SC0004'.

    " 생성일자, 생성시간, 생성자 관련 필드가 있으면
    LS_SDT080-ERDAT = SY-DATUM. " 현재 일자
    LS_SDT080-ERZET = SY-UZEIT. " 현재 시간
    LS_SDT080-ERNAM = SY-UNAME. " 현재 사용자

    INSERT ZEA_SDT080 FROM LS_SDT080.

    IF SY-SUBRC EQ 0.
      " 생성 성공
*      COMMIT WORK AND WAIT.

      MOVE-CORRESPONDING LS_SDT080 TO ER_ENTITY.
    ELSE.
      " 생성 실패 => 중복
      CLEAR ER_ENTITY.
      " 에러메시지 -> 생성할 데이터 중복
      MO_CONTEXT->GET_MESSAGE_CONTAINER( )->ADD_MESSAGE_TEXT_ONLY(
   EXPORTING
     IV_MSG_TYPE               = 'E'                 " Message Type - defined by GCS_MESSAGE_TYPE
     IV_MSG_TEXT               = '생성할 오더가 이미 존재합니다.'                 " Message Text
 ).

      RAISE EXCEPTION TYPE /IWBEP/CX_MGW_BUSI_EXCEPTION
        EXPORTING
          MESSAGE_CONTAINER = MO_CONTEXT->GET_MESSAGE_CONTAINER( ).
    ENDIF.

  endmethod.


  METHOD ORDERSET_GET_ENTITYSET.

* $filter, $orderby, $top, $skip, $expand 등등 다 안됨
*    SELECT *
*      FROM ZEA_SDT180
*      INTO CORRESPONDING FIELDS OF TABLE ET_ENTITYSET
*      ORDER BY PRIMARY KEY.

    DATA : LS_180 TYPE ZEA_SDS180,
           LT_180 TYPE TABLE OF ZEA_SDS180.

    SELECT *
    FROM ZEA_SDT080 AS A
    JOIN ZEA_MMT020 AS B
      ON A~MATNR EQ B~MATNR
     AND B~SPRAS EQ @SY-LANGU
    JOIN ZEA_T001W  AS C
      ON A~WERKS EQ C~WERKS
    INTO CORRESPONDING FIELDS OF TABLE @LT_180.

    LOOP AT LT_180 INTO LS_180.
      LS_180-TOAMT = LS_180-AUQUA * LS_180-NETPR.
      APPEND LS_180 TO ET_ENTITYSET.
    ENDLOOP.
  ENDMETHOD.


  method PSTOCKSET_GET_ENTITY.
**TRY.
*CALL METHOD SUPER->PSTOCKSET_GET_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    IO_REQUEST_OBJECT       =
**    IO_TECH_REQUEST_CONTEXT =
*    IT_NAVIGATION_PATH      =
**  IMPORTING
**    ER_ENTITY               =
**    ES_RESPONSE_CONTEXT     =
*    .
**  CATCH /IWBEP/CX_MGW_BUSI_EXCEPTION.
**  CATCH /IWBEP/CX_MGW_TECH_EXCEPTION.
**ENDTRY.
  endmethod.


  METHOD PSTOCKSET_GET_ENTITYSET.

* $filter, $orderby, $top, $skip, $expand 등등 다 안됨
    SELECT *
      FROM ZEA_MMT190
      INTO CORRESPONDING FIELDS OF TABLE ET_ENTITYSET
      WHERE MATNR EQ '30000000'
      ORDER BY PRIMARY KEY.

  ENDMETHOD.


  method STOCKSET_GET_ENTITY.

* IT_KEY_TAB 은 EntitySet 의 ( ) 안의 값을 가지고 있다.
    DATA LS_KEY LIKE LINE OF IT_KEY_TAB.
    READ TABLE IT_KEY_TAB INTO LS_KEY INDEX 1.
*    READ TABLE IT_KEY_TAB INTO DATA(LS_KEY) INDEX 1.

    DATA LV_WERKS TYPE ZEA_MMT190-WERKS.
*    IF LS_KEY-NAME EQ 'Carrid'. " 어차피 키필드가 하나라서 비교할 필요가 없다.
      LV_WERKS = LS_KEY-VALUE.
*    ENDIF.

* 한 줄을 검색하기 위한 조건이 필요함
    SELECT SINGLE A~MATNR
                  A~WERKS
                  B~PNAME1
                  A~SCODE
                  A~CALQTY
                  A~MEINS
                  A~WEIGHT
                  A~MEINS2
                  A~SAFSTK
                  A~MEINS3
      FROM ZEA_MMT190 AS A
      JOIN ZEA_T001W AS B ON B~WERKS EQ A~WERKS
      INTO CORRESPONDING FIELDS OF ER_ENTITY
      WHERE MATNR EQ '30000000'
        AND A~WERKS EQ LV_WERKS.

  endmethod.


  method STOCKSET_GET_ENTITYSET.
* $filter, $orderby, $top, $skip, $expand 등등 다 안됨
    SELECT A~MATNR
           A~WERKS
           B~PNAME1
           A~SCODE
           A~CALQTY
           A~MEINS
           A~WEIGHT
           A~MEINS2
           A~SAFSTK
           A~MEINS3
      FROM ZEA_MMT190 AS A
      JOIN ZEA_T001W AS B ON B~WERKS EQ A~WERKS
      INTO CORRESPONDING FIELDS OF TABLE ET_ENTITYSET
      WHERE MATNR EQ '30000000'
        AND PNAME1 NE 'CDC'
        AND PNAME1 NE 'RDC'.

      SORT ET_ENTITYSET BY MATNR.

  endmethod.
ENDCLASS.
