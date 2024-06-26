*&---------------------------------------------------------------------*
*& Include          YE00_EX007PBO
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.
  SET PF-STATUS '0100'.
  SET TITLEBAR  '0100'. " [샘플] 항공사 예약 정보 조회
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_OBJECT_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE INIT_OBJECT_0100 OUTPUT.

  IF GO_CUSTOM_CONTAINER IS INITIAL.

    PERFORM CREATE_OBJECT_0100.

    " TREE 관련 Subroutines
    PERFORM CREATE_NODE_0100.   " 1 ~ 50
    PERFORM CREATE_NODE_0100_2. " 1 ~ 50



    SORT GT_NODE_INFO BY NODE_KEY.

    CALL METHOD GO_SIMPLE_TREE->ADD_NODES
      EXPORTING
        TABLE_STRUCTURE_NAME           = 'MTREESNODE'     " Name of Structure of Node Table
        NODE_TABLE                     = GT_NODE          " Node table
      EXCEPTIONS
        ERROR_IN_NODE_TABLE            = 1                " Node Table Contains Errors
        FAILED                         = 2                " General error
        DP_ERROR                       = 3                " Error in Data Provider
        TABLE_STRUCTURE_NAME_NOT_FOUND = 4                " Unable to Find Structure in Dictionary
        OTHERS                         = 5.
    IF SY-SUBRC <> 0.
      MESSAGE E025. " TREE NODE 생성 중 오류가 발생했습니다.
    ENDIF.



    PERFORM EXPAND_ROOT_NODE_0100.
    PERFORM SET_TREE_EVENT_0100.

    " ALV 관련 Subroutines
    PERFORM SET_ALV_LAYOUT_0100.
    PERFORM SET_ALV_FIELDCAT_0100.
    PERFORM SET_ALV_EVENT_0100.
    PERFORM DISPLAY_ALV_0100.

  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CLEAR_OK_CODE OUTPUT
*&---------------------------------------------------------------------*
MODULE CLEAR_OK_CODE OUTPUT.

  CLEAR OK_CODE.
ENDMODULE.
