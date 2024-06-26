class ZCL_ZEA_MMGT_TRF_02_DPC_EXT definition
  public
  inheriting from ZCL_ZEA_MMGT_TRF_02_DPC
  create public .

public section.
protected section.

  methods BOOKINGIDSET_CREATE_ENTITY
    redefinition .
  methods BOOKINGIDSET_GET_ENTITYSET
    redefinition .
  methods BOOKINGIDSET_UPDATE_ENTITY
    redefinition .
  methods BOOKINGINFOSET_CREATE_ENTITY
    redefinition .
  methods BOOKINGINFOSET_GET_ENTITYSET
    redefinition .
  methods BOOKINGINFOSET_UPDATE_ENTITY
    redefinition .
  methods BOOKINGSET_GET_ENTITYSET
    redefinition .
  methods STORAGESET_GET_ENTITYSET
    redefinition .
  methods STORAGESET_UPDATE_ENTITY
    redefinition .
  methods BOOKINGIDSET_GET_ENTITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZEA_MMGT_TRF_02_DPC_EXT IMPLEMENTATION.


  method BOOKINGIDSET_CREATE_ENTITY.

    CALL METHOD IO_DATA_PROVIDER->READ_ENTRY_DATA
      IMPORTING
        ES_DATA = ER_ENTITY.

    DATA: LS_MMT200 TYPE ZEA_MMT200.

    MOVE-CORRESPONDING ER_ENTITY TO LS_MMT200.

    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        NR_RANGE_NR             = '10'                  " Number range number
        OBJECT                  = 'ZEA_MOVID'                 " Name of number range object
      IMPORTING
        NUMBER                  = LS_MMT200-MOVID                 " free number
      EXCEPTIONS
        INTERVAL_NOT_FOUND      = 1                " Interval not found
        NUMBER_RANGE_NOT_INTERN = 2                " Number range is not internal
        OBJECT_NOT_FOUND        = 3                " Object not defined in TNRO
        QUANTITY_IS_0           = 4                " Number of numbers requested must be > 0
        QUANTITY_IS_NOT_1       = 5                " Number of numbers requested must be 1
        INTERVAL_OVERFLOW       = 6                " Interval used up. Change not possible.
        BUFFER_OVERFLOW         = 7                " Buffer is full
        OTHERS                  = 8.
    IF SY-SUBRC <> 0.
*     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*       WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.






    INSERT ZEA_MMT200 FROM LS_MMT200.

    IF SY-SUBRC EQ 0.
      " 생성 성공
      MOVE-CORRESPONDING LS_MMT200 TO ER_ENTITY.
    ELSE.
      " 생성 실패 => 중복
      CLEAR ER_ENTITY.
      " 에러메시지 -> 생성할 데이터 중복
      MO_CONTEXT->GET_MESSAGE_CONTAINER( )->ADD_MESSAGE_TEXT_ONLY(
   EXPORTING
     IV_MSG_TYPE               = 'E'                 " Message Type - defined by GCS_MESSAGE_TYPE
     IV_MSG_TEXT               = '생성할 요청이 이미 존재합니다. (E23)'                 " Message Text
 ).

      RAISE EXCEPTION TYPE /IWBEP/CX_MGW_BUSI_EXCEPTION
        EXPORTING
          MESSAGE_CONTAINER = MO_CONTEXT->GET_MESSAGE_CONTAINER( ).
    ENDIF.

ENDMETHOD.


  METHOD BOOKINGIDSET_GET_ENTITY.

    DATA:LT_KEY_TAB TYPE /IWBEP/T_MGW_NAME_VALUE_PAIR,
         LS_KEY_TAB TYPE /IWBEP/S_MGW_NAME_VALUE_PAIR,
         LS_ENTITY  TYPE ZEA_MMV010,
         LV_BOOKID  TYPE ZEA_MMV010-BOOKID,
         LV_WERKS   TYPE ZEA_MMV010-WERKS.

    " IT_KEY_TAB 사용하여 키 필드 값을 추출합니다.
    LT_KEY_TAB = IT_KEY_TAB.
    LOOP AT LT_KEY_TAB INTO LS_KEY_TAB.
      CASE LS_KEY_TAB-NAME.
        WHEN 'Bookid'.
          LV_BOOKID = LS_KEY_TAB-VALUE.
        WHEN 'Werks'.
          LV_WERKS = LS_KEY_TAB-VALUE.
      ENDCASE.
    ENDLOOP.

    " 키 필드를 사용하여 데이터를 검색합니다.
    SELECT SINGLE * INTO @LS_ENTITY
      FROM ZEA_MMV010
      WHERE BOOKID = @LV_BOOKID
      AND WERKS = @LV_WERKS.

    IF SY-SUBRC = 0.
      ER_ENTITY = LS_ENTITY.
    ENDIF.
  ENDMETHOD.


  method BOOKINGIDSET_GET_ENTITYSET.
    SELECT *
      FROM ZEA_MMV010
     WHERE SPRAS EQ @SY-LANGU
       AND (IV_FILTER_STRING)
      INTO CORRESPONDING FIELDS OF TABLE @ET_ENTITYSET.

  endmethod.


  method BOOKINGIDSET_UPDATE_ENTITY.

    DATA: LS_ENTITY TYPE ZEA_SDT080,
          LT_ENTITY TYPE TABLE OF ZEA_SDT080.

    DATA: LV_BOOKID TYPE ZEA_SDT080-BOOKID.

    LOOP AT IT_KEY_TAB INTO DATA(LS_KEY) . " 괄호 안의 값들을 점검
      CASE LS_KEY-NAME.
        WHEN 'Bookid'.
          LV_BOOKID = LS_KEY-VALUE.
      ENDCASE.
    ENDLOOP.

    UPDATE ZEA_SDT080 SET STATUS = 'A'
        WHERE BOOKID = LV_BOOKID.

  endmethod.


  METHOD BOOKINGINFOSET_CREATE_ENTITY.

    CALL METHOD IO_DATA_PROVIDER->READ_ENTRY_DATA
      IMPORTING
        ES_DATA = ER_ENTITY.

    DATA: LS_MMT200 TYPE ZEA_MMT200,
          LS_MMT010 TYPE ZEA_MMT010,
          LS_MMT070 TYPE ZEA_MMT070.

    MOVE-CORRESPONDING ER_ENTITY TO LS_MMT200.

*    SELECT SINGLE *
*      FROM ZEA_MMT200 AS A
*      JOIN ZEA_MMT010 AS B
*        ON A~MATNR EQ B~MATNR
*      JOIN ZEA_MMT190 AS C
*        ON C~MATNR EQ A~MATNR
* LEFT JOIN ZEA_MMT070 AS D
*        ON D~MATNR EQ A~MATNR
**       AND D~WERKS EQ C~WERKS
*      INTO CORRESPONDING FIELDS OF @LS_MMT200.
*
*      MOVE-CORRESPONDING LS_MMT200 TO LS_MMT010.

    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        NR_RANGE_NR             = '10'                  " Number range number
        OBJECT                  = 'ZEA_MMNR'                 " Name of number range object
      IMPORTING
        NUMBER                  = LS_MMT200-MOVID                 " free number
      EXCEPTIONS
        INTERVAL_NOT_FOUND      = 1                " Interval not found
        NUMBER_RANGE_NOT_INTERN = 2                " Number range is not internal
        OBJECT_NOT_FOUND        = 3                " Object not defined in TNRO
        QUANTITY_IS_0           = 4                " Number of numbers requested must be > 0
        QUANTITY_IS_NOT_1       = 5                " Number of numbers requested must be 1
        INTERVAL_OVERFLOW       = 6                " Interval used up. Change not possible.
        BUFFER_OVERFLOW         = 7                " Buffer is full
        OTHERS                  = 8.
    IF SY-SUBRC <> 0.
      MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
        WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

*    LS_MMT200-DMBTR = LS_MMT200-DMBTR * LS_MMT200-MENGE.
*    LS_MMT200-CHARG = LS_MMT200-CHARG.
    LS_MMT200-ERDAT = SY-DATUM.
    LS_MMT200-ERZET = SY-UZEIT.
    LS_MMT200-ERNAM = SY-UNAME.
    LS_MMT200-STATUS = SPACE.


    INSERT ZEA_MMT200 FROM LS_MMT200.

    IF SY-SUBRC EQ 0.
      " 생성 성공
      MOVE-CORRESPONDING LS_MMT200 TO ER_ENTITY.
    ELSE.
      " 생성 실패 => 중복
      CLEAR ER_ENTITY.
      " 에러메시지 -> 생성할 데이터 중복
      MO_CONTEXT->GET_MESSAGE_CONTAINER( )->ADD_MESSAGE_TEXT_ONLY(
   EXPORTING
     IV_MSG_TYPE               = 'E'                 " Message Type - defined by GCS_MESSAGE_TYPE
     IV_MSG_TEXT               = '생성할 요청이 이미 존재합니다.'                 " Message Text
 ).

      RAISE EXCEPTION TYPE /IWBEP/CX_MGW_BUSI_EXCEPTION
        EXPORTING
          MESSAGE_CONTAINER = MO_CONTEXT->GET_MESSAGE_CONTAINER( ).
    ENDIF.

  ENDMETHOD.


  method BOOKINGINFOSET_GET_ENTITYSET.

    SELECT *
      FROM ZEA_MMT200 AS A
      JOIN ZEA_MMT020 AS B
        ON A~MATNR EQ B~MATNR
     WHERE SPRAS EQ @SY-LANGU
      INTO CORRESPONDING FIELDS OF TABLE @ET_ENTITYSET.

  endmethod.


  method BOOKINGINFOSET_UPDATE_ENTITY.

    DATA: LS_ENTITY TYPE ZEA_SDT080,
          LT_ENTITY TYPE TABLE OF ZEA_SDT080.

    DATA: LV_BOOKID TYPE ZEA_SDT080-BOOKID.

    LOOP AT IT_KEY_TAB INTO DATA(LS_KEY) . " 괄호 안의 값들을 점검
      CASE LS_KEY-NAME.
        WHEN 'Bookid'.
          LV_BOOKID = LS_KEY-VALUE.
      ENDCASE.
    ENDLOOP.

    UPDATE ZEA_SDT080 SET STATUS = 'A'
        WHERE BOOKID = LV_BOOKID.


  endmethod.


  method BOOKINGSET_GET_ENTITYSET.
" BOOKID ZEA_SDT080
" ELCDT  ZEA_SDT080
" WERKS  ZEA_SDT080
" PNAME1 ZEA_TW001
" MATNR  ZEA_SDT080
" MAKTX  ZEA_MMT020
" AUQUA  ZEA_SDT080
" MEINS  ZEA_SDT080
" STATUS ZEA_SDT080

    DATA LV_FILTER TYPE CHAR77.
    DATA LV_MAKTX TYPE ZEA_MMT020-MAKTX.

    LV_FILTER = IV_FILTER_STRING.


  SELECT *
    FROM ZEA_SDT080 AS A
    JOIN ZEA_T001W AS B
      ON A~WERKS EQ B~WERKS
    JOIN ZEA_MMT020 AS C
      ON A~MATNR EQ C~MATNR
    WHERE
    SPRAS EQ @SY-LANGU
      AND a~werks eq @IV_FILTER_STRING
    "  a~ 'Werks' 'e' '우리가누른id번호'

   INTO CORRESPONDING FIELDS OF TABLE @ET_ENTITYSET.

  endmethod.


  method STORAGESET_GET_ENTITYSET.


 "MATNR    ZEA_MMT190
 "MAKTX    ZEA_MMT020
 "WERKS    ZEA_MMT190
 "PNAME1   ZEA_TW001
 "SCODE    ZEA_MMT190
 "CALQTY   ZEA_MMT190
 "MEINS    ZEA_MMT190
 "CHARG    ZEA_MMT070

*  DATA: LV_WERKS TYPE ZEA_MMT190-WERKS,
*        LV_BOOKID TYPE ZEA_SDT080-BOOKID.
*
*     LOOP AT IT_KEY_TAB INTO DATA(LS_KEY).
*      CASE LS_KEY-NAME.
*        WHEN 'Werks'.
*          LV_WERKS = LS_KEY-VALUE.
*        WHEN 'Bookid'.
*          LV_BOOKID = LS_KEY-VALUE.
*      ENDCASE.

*      IF SY-SUBRC EQ 0.
        SELECT A~*,B~MAKTX, C~CHARG, D~PNAME1
          FROM ZEA_MMT190 AS A
          JOIN ZEA_MMT020 AS B
            ON B~MATNR EQ A~MATNR
          JOIN ZEA_MMT070 AS C
            ON C~MATNR EQ A~MATNR
          JOIN ZEA_T001W AS D
            ON D~WERKS EQ A~WERKS
          WHERE SPRAS EQ @SY-LANGU
          INTO CORRESPONDING FIELDS OF TABLE @ET_ENTITYSET.
*      ENDIF.
*    ENDLOOP.

  endmethod.


  method STORAGESET_UPDATE_ENTITY.
**어떠한 데이터를 찾아서 그 데이터의 내용을 변경한다.
**IT_KEY_TAB이 반드시 입력 되어야 함.
** ㄴ 이유 : 변경할 대상을 지정해야 하므로,
*
*    READ TABLE IT_KEY_TAB INTO DATA(LS_KEY) INDEX 1.
*
*    DATA LV_MOVID TYPE ZEA_MMT200-MOVID. "Key Field 선택
*    LV_MOVID = LS_KEY-VALUE. " ( )안의 키필드 값을 LV_BELNR에 보관
*
**    어떤 내용으로 변경하는지 가져옴
**    HTTP Request Body 의 내용을 가져옴 (Key Field 를 기준으로 변경)
*    CALL METHOD IO_DATA_PROVIDER->READ_ENTRY_DATA
*      IMPORTING
*        ES_DATA = ER_ENTITY.
*

**  CATCH /IWBEP/CX_MGW_TECH_EXCEPTION. " mgw technical exception
**     그리고 이 때, 수정일자, 수정시간, 수정자에 대한 필드가 있다면 함께 작성
*
*    "키 값을 가진 ER_ENTITY
*    "Database Table ZEA_MMT200 수정에 사용
*      ER_ENTITY-AEDAT = SY-DATUM.
*      ER_ENTITY-AENAM = SY-UNAME.
*      ER_ENTITY-AEZET = SY-UZEIT.
**      ER_ENTITY-STAUTS = 'X'.
*
*   DATA LS_MMT200 TYPE ZEA_MMT200.
*
*    MOVE-CORRESPONDING ER_ENTITY TO LS_MMT200 .
*
*    UPDATE ZEA_MMT200 FROM LS_MMT200. "UPDATE
*
*    IF  SY-SUBRC EQ 0.
*      COMMIT WORK AND WAIT.
*
*      DATA: IS_HEAD TYPE ZEA_MMT090,
*            IT_ITEM TYPE ZEA_MMY100.
*
*      CALL FUNCTION 'ZEA_MM_TRF'
*        EXPORTING
*          IV_PLANTFR  = ER_ENTITY-PLANTFR " 플랜트ID(시작)
*          IV_PLANTTO  = ER_ENTITY-PLANTTO " 플랜트ID(도착)
*          IV_MATNR    = ER_ENTITY-MATNR   " 자재코드
*          IV_QUANTITY = ER_ENTITY-MENGE  " 이동 수량
*        IMPORTING
*          ES_HEAD     = IS_HEAD                 " [MM] 자재문서 Header
*          ET_ITEM     = IT_ITEM.                 " 자재문서 ITEM 테이블타입
*
*      CALL FUNCTION 'ZEA_FI_WL'
*        EXPORTING
*          IS_HEAD = IS_HEAD   " [MM] 자재문서 Header
*          IT_ITEM = IT_ITEM.   " 자재문서 ITEM 테이블타입
*
*    ELSE.
*      CLEAR ER_ENTITY.
*      "에러메세지
*
*    ENDIF.















*    DATA: LS_ENTITY TYPE ZEA_MMT200,
*          LT_ENTITY TYPE TABLE OF ZEA_MMT200.
*
*    DATA: LV_MOVID TYPE ZEA_MMT200-MOVID.
*    DATA: LV_BOOKID TYPE ZEA_MMT200-BOOKID.
*
*    LOOP AT IT_KEY_TAB INTO DATA(LS_KEY) . " 괄호 안의 값들을 점검
*      CASE LS_KEY-NAME.
*        WHEN 'Movid'.
*          LV_MOVID = LS_KEY-VALUE.
*        WHEN 'Bookid'.
*          LV_BOOKID = LS_KEY-VALUE.
*      ENDCASE.
*    ENDLOOP.
*
**--- 선택한 라디오 버튼 값과 Plantfr 의 값이 일치하는 것만 필터링
*  DATA : LV_PLANTFR TYPE ZEA_MMT200-PLANTFR.
*
** DATA : IT_FLITER_SELECT_OPTIONS LIKE TABLE OF IT_FILTER_SELECT_OPTIONS.
*
*
*
*    " Get data for update based on key fields
*    CALL METHOD IO_DATA_PROVIDER->READ_ENTRY_DATA
*      IMPORTING
*        ES_DATA = ER_ENTITY.
*
*    " Update additional fields if necessary (e.g., modification date, time, and user)
**   ER_ENTITY-AEDAT = SY-DATUM.
**   ER_ENTITY-AENAM = SY-UNAME.
**    ER_ENTITY-AEZET = SY-UZEIT.
*
*    " Update database table using data from the entity
*
*    UPDATE ZEA_MMT200 SET STATUS = ER_ENTITY-Status
*    WHERE MOVID = LV_MOVID AND BOOKID = LV_BOOKID.
*
*    IF SY-SUBRC EQ 0.
*      COMMIT WORK AND WAIT.
*
*      DATA: LS_HEAD TYPE ZEA_MMT090,
*            LT_ITEM TYPE ZEA_MMY100.




  ENDMETHOD.
ENDCLASS.
