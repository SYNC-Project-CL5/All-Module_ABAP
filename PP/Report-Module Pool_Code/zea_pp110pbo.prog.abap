*&---------------------------------------------------------------------*
*& Include          YE00_EX007PBO
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.
  SET PF-STATUS '0100'.
  SET TITLEBAR  '0100'. " [PP] 생산계획 생성 및 조회
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_OBJECT_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE INIT_OBJECT_0100 OUTPUT.

  IF GO_CON_TOP IS INITIAL.

    PERFORM CREATE_OBJECT_0100.

    " TREE 관련 Subroutines
    PERFORM CREATE_NODE_0100. " 판매계획 트리 노드 구성을 위한 Subroutines


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

*-- 2번째 ALV
  IF GO_CON_BOT IS INITIAL.

    PERFORM CREATE_OBJECT_2_0100.

    " TREE 관련 Subroutines
    PERFORM CREATE_NODE_0100_2. " 생산계획 트리 구성을 위한 Subroutines



    SORT GT_NODE_INFO2 BY NODE_KEY.

    CALL METHOD GO_SIMPLE_TREE2->ADD_NODES
      EXPORTING
        TABLE_STRUCTURE_NAME           = 'MTREESNODE'     " Name of Structure of Node Table
        NODE_TABLE                     = GT_NODE2          " Node table
      EXCEPTIONS
        ERROR_IN_NODE_TABLE            = 1                " Node Table Contains Errors
        FAILED                         = 2                " General error
        DP_ERROR                       = 3                " Error in Data Provider
        TABLE_STRUCTURE_NAME_NOT_FOUND = 4                " Unable to Find Structure in Dictionary
        OTHERS                         = 5.
    IF SY-SUBRC <> 0.
      MESSAGE E025. " TREE NODE 생성 중 오류가 발생했습니다.
    ENDIF.


    PERFORM EXPAND_ROOT_NODE_2_0100.
    PERFORM SET_TREE_EVENT_2_0100.

    " ALV 관련 Subroutines
    PERFORM SET_ALV_LAYOUT_2_0100.
    PERFORM SET_ALV_FIELDCAT_2_0100.
    PERFORM EDIT_ALV_FIELDCAT_2_0100.
    PERFORM SET_ALV_EVENT_2_0100.
    PERFORM DISPLAY_ALV_2_0100.

  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CLEAR_OK_CODE OUTPUT
*&---------------------------------------------------------------------*
MODULE CLEAR_OK_CODE OUTPUT.

  CLEAR OK_CODE.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0110 OUTPUT
*&---------------------------------------------------------------------*
MODULE STATUS_0110 OUTPUT.
  SET PF-STATUS '0110'.
  SET TITLEBAR '0110' WITH GS_NODE_INFO-SP_YEAR. " &년도 생산계획 생성
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0120 OUTPUT
*&---------------------------------------------------------------------*
MODULE STATUS_0120 OUTPUT.
  SET PF-STATUS '0120'.
  SET TITLEBAR '0120' WITH GS_NODE_INFO-SP_YEAR. " &년도 생산계획 생성
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_DATA_0120 OUTPUT
*&---------------------------------------------------------------------*
MODULE INIT_DATA_0120 OUTPUT.

  IF S0120 IS INITIAL.
    PERFORM INIT_DATA_0120.   " 화면 변수에 값을 이동시켜주는 로직
*    PERFORM CHECK_DATA_0120.  " 화면 변수에 들어간 값에 따라 인풋값을 열고 닫아주는 로직
  ELSE.
*    PERFORM OPEN_INPUT.
*    PERFORM REFRESH_ALV_0100.
  ENDIF.

*  PERFORM OPEN_INPUT.
  PERFORM OPEN_INPUT_TEST. " 화면 변수에 들어간 값에 따라 인풋값을 열고 닫아주는 로직



ENDMODULE.
