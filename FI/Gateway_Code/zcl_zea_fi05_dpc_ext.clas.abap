class ZCL_ZEA_FI05_DPC_EXT definition
  public
  inheriting from ZCL_ZEA_FI05_DPC
  create public .

public section.
protected section.

  methods INVENTORYSET_GET_ENTITY
    redefinition .
  methods INVENTORYSET_GET_ENTITYSET
    redefinition .
  methods INVENTORYSET_UPDATE_ENTITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZEA_FI05_DPC_EXT IMPLEMENTATION.


  method INVENTORYSET_GET_ENTITY.


 DATA LS_KEY LIKE LINE OF IT_KEY_TAB.
 READ TABLE IT_KEY_TAB INTO LS_KEY INDEX 1.

 DATA LV_MOVID TYPE ZEA_MMT200-MOVID.

 LV_MOVID = LS_KEY-VALUE.

  SELECT SINGLE * FROM ZEA_MMT200
    WHERE MOVID EQ @LV_MOVID
    INTO CORRESPONDING FIELDS OF @ER_ENTITY.

  endmethod.


  METHOD INVENTORYSET_GET_ENTITYSET.

    SELECT * FROM
            ZEA_MMT200 AS A
            JOIN ZEA_T001W AS B
            ON  A~PLANTTO EQ B~WERKS

            LEFT JOIN ZEA_MMT020 AS C
            ON A~MATNR EQ C~MATNR
            AND C~SPRAS EQ @SY-LANGU

     INTO CORRESPONDING FIELDS OF TABLE @ET_ENTITYSET.


  ENDMETHOD.


  METHOD INVENTORYSET_UPDATE_ENTITY.
*어떠한 데이터를 찾아서 그 데이터의 내용을 변경한다.
*IT_KEY_TAB이 반드시 입력 되어야 함.
* ㄴ 이유 : 변경할 대상을 지정해야 하므로,

    READ TABLE IT_KEY_TAB INTO DATA(LS_KEY) INDEX 1.

    DATA LV_MOVID TYPE ZEA_MMT200-MOVID. "Key Field 선택
    LV_MOVID = LS_KEY-VALUE. " ( )안의 키필드 값을 LV_BELNR에 보관

*    어떤 내용으로 변경하는지 가져옴
*    HTTP Request Body 의 내용을 가져옴 (Key Field 를 기준으로 변경)
    CALL METHOD IO_DATA_PROVIDER->READ_ENTRY_DATA
      IMPORTING
        ES_DATA = ER_ENTITY.

*  CATCH /IWBEP/CX_MGW_TECH_EXCEPTION. " mgw technical exception
*     그리고 이 때, 수정일자, 수정시간, 수정자에 대한 필드가 있다면 함께 작성

    "키 값을 가진 ER_ENTITY
    "Database Table ZEA_MMT200 수정에 사용
      ER_ENTITY-AEDAT = SY-DATUM.
      ER_ENTITY-AENAM = SY-UNAME.
      ER_ENTITY-AEZET = SY-UZEIT.
*      ER_ENTITY-STAUTS = 'X'.

   DATA LS_MMT200 TYPE ZEA_MMT200.

    MOVE-CORRESPONDING ER_ENTITY TO LS_MMT200 .

    UPDATE ZEA_MMT200 FROM LS_MMT200. "UPDATE

    IF  SY-SUBRC EQ 0.
      COMMIT WORK AND WAIT.

      DATA: IS_HEAD TYPE ZEA_MMT090,
            IT_ITEM TYPE ZEA_MMY100.

      CALL FUNCTION 'ZEA_MM_TRF'
        EXPORTING
          IV_PLANTFR  = ER_ENTITY-PLANTFR " 플랜트ID(시작)
          IV_PLANTTO  = ER_ENTITY-PLANTTO " 플랜트ID(도착)
          IV_MATNR    = ER_ENTITY-MATNR   " 자재코드
          IV_QUANTITY = ER_ENTITY-MENGE  " 이동 수량
        IMPORTING
          ES_HEAD     = IS_HEAD                 " [MM] 자재문서 Header
          ET_ITEM     = IT_ITEM.                 " 자재문서 ITEM 테이블타입

      CALL FUNCTION 'ZEA_FI_WL'
        EXPORTING
          IS_HEAD = IS_HEAD   " [MM] 자재문서 Header
          IT_ITEM = IT_ITEM.   " 자재문서 ITEM 테이블타입

    ELSE.
      CLEAR ER_ENTITY.
      "에러메세지

    ENDIF.

  ENDMETHOD.
ENDCLASS.
