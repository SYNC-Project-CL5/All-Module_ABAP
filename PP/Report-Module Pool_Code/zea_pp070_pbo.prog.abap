*&---------------------------------------------------------------------*
*& Include          YE00_EX007PBO
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.
  SET PF-STATUS '0100'.
  SET TITLEBAR  '0100'. "[PP] MRP 계산
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_OBJECT_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE INIT_OBJECT_0100 OUTPUT.

  IF GO_CUSTOM_CONTAINER IS INITIAL.

    PERFORM CREATE_OBJECT_0100.

*    " TREE 관련 Subroutines
    PERFORM CREATE_NODE_0100.   " 1 ~ 50
**    PERFORM CREATE_NODE_0100_2. " 1 ~ 50

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

*    " ALV 관련 Subroutines
    PERFORM SET_ALV_LAYOUT_0100.
    PERFORM SET_ALV_FIELDCAT_0100.
    PERFORM SET_ALV_EVENT_0100.
    PERFORM DISPLAY_ALV_0100.
  ELSE.
    PERFORM REFRESH_ALV_0100.
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
*&
*&---------------------------------------------------------------------*
MODULE STATUS_0110 OUTPUT.
 SET PF-STATUS '0110'.
 SET TITLEBAR '0110'. " 자재소요량 계산
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0120 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE STATUS_0120 OUTPUT.
 SET PF-STATUS '0120'.
 SET TITLEBAR '0120'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_OBJECT_0120 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE INIT_OBJECT_0120 OUTPUT.

  IF GO_CUSTOM_CONTAINER4 IS INITIAL.
    PERFORM CREATE_OBJECT_0120.
    PERFORM SET_ALV_LAYOUT_0120.
    PERFORM SET_ALV_FIELDCAT_0120.
    PERFORM DISPLAY_ALV_0120.
  ELSE.
    PERFORM REFRESH_ALV_0120.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_0120
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT_0120 .

    CREATE OBJECT GO_CUSTOM_CONTAINER4
    EXPORTING
      CONTAINER_NAME = GC_CUSTOM_CONTAINER_NAME4
    EXCEPTIONS
      OTHERS         = 1.

  IF SY-SUBRC NE 0.
    MESSAGE E020. " Custom Container 생성 중 오류가 발생했습니다.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.


  CREATE OBJECT GO_ALV_GRID4
    EXPORTING
      I_PARENT = GO_CUSTOM_CONTAINER4
    EXCEPTIONS
      OTHERS   = 1.

  IF SY-SUBRC NE 0.
    MESSAGE E021. " ALV Grid 생성 중 오류가 발생했습니다.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.


ENDFORM.
