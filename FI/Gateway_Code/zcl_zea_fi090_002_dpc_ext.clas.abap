class ZCL_ZEA_FI090_002_DPC_EXT definition
  public
  inheriting from ZCL_ZEA_FI090_002_DPC
  create public .

public section.
protected section.

  methods ZEA_BKPFSET_GET_ENTITYSET
    redefinition .
  methods ZEA_BSEGSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZEA_FI090_002_DPC_EXT IMPLEMENTATION.


  method ZEA_BKPFSET_GET_ENTITYSET.
**TRY.
*CALL METHOD SUPER->ZEA_BKPFSET_GET_ENTITYSET
*  EXPORTING
*    IV_ENTITY_NAME           =
*    IV_ENTITY_SET_NAME       =
*    IV_SOURCE_NAME           =
*    IT_FILTER_SELECT_OPTIONS =
*    IS_PAGING                =
*    IT_KEY_TAB               =
*    IT_NAVIGATION_PATH       =
*    IT_ORDER                 =
*    IV_FILTER_STRING         =
*    IV_SEARCH_STRING         =
**    IO_TECH_REQUEST_CONTEXT  =
**  IMPORTING
**    ET_ENTITYSET             =
**    ES_RESPONSE_CONTEXT      =
*    .
**  CATCH /IWBEP/CX_MGW_BUSI_EXCEPTION.
**  CATCH /IWBEP/CX_MGW_TECH_EXCEPTION.
**ENDTRY.
  endmethod.


  method ZEA_BSEGSET_GET_ENTITYSET.
**TRY.
*CALL METHOD SUPER->ZEA_BSEGSET_GET_ENTITYSET
*  EXPORTING
*    IV_ENTITY_NAME           =
*    IV_ENTITY_SET_NAME       =
*    IV_SOURCE_NAME           =
*    IT_FILTER_SELECT_OPTIONS =
*    IS_PAGING                =
*    IT_KEY_TAB               =
*    IT_NAVIGATION_PATH       =
*    IT_ORDER                 =
*    IV_FILTER_STRING         =
*    IV_SEARCH_STRING         =
**    IO_TECH_REQUEST_CONTEXT  =
**  IMPORTING
**    ET_ENTITYSET             =
**    ES_RESPONSE_CONTEXT      =
*    .
**  CATCH /IWBEP/CX_MGW_BUSI_EXCEPTION.
**  CATCH /IWBEP/CX_MGW_TECH_EXCEPTION.
**ENDTRY.
  endmethod.
ENDCLASS.
