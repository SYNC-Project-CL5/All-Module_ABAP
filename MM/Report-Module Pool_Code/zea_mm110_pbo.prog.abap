*&---------------------------------------------------------------------*
*& Include          ZEA_GW_TES_PBO
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.
  SET PF-STATUS 'S0100'.
  SET TITLEBAR 'T0100'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CLEAR_OK_CODE OUTPUT
*&---------------------------------------------------------------------*
MODULE CLEAR_OK_CODE OUTPUT.
  CLEAR OK_CODE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ALV_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE INIT_ALV_0100 OUTPUT.

  IF GO_DOCKING_CONTAINER IS INITIAL.
    PERFORM CREATE_OBJECT_0100.

    " TREE 관련 Subroutines
    PERFORM CREATE_NODE_0100.   " 1 ~ 50

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
*--------------------------------------------------------------------*
  IF GO_CONTAINER_2 IS INITIAL.
    PERFORM CREATE_OBJECT2_0100.
    PERFORM SET_DOCUMENT USING GCL_DOCUMENT.
*    PERFORM SET_ALV_FIELDCAT2_0100.
*    PERFORM SET_ALV_LAYOUT_0100.
**    PERFORM SET_ALV_EVENT2_0100.
*    PERFORM DISPLAY_ALV2_0100.
  ELSE.
    PERFORM SET_DOCUMENT USING GCL_DOCUMENT.
*    PERFORM REFRESH_ALV_0100.
*    GO_ALV_GRID_2->REFRESH_TABLE_DISPLAY( ).
  ENDIF.
*--------------------------------------------------------------------*


ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0200 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE STATUS_0200 OUTPUT.
  SET PF-STATUS '0200'.
  SET TITLEBAR '0200'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0300 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE STATUS_0300 OUTPUT.
  SET PF-STATUS '0300'.
  SET TITLEBAR '0300'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ALV_0300 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE INIT_ALV_0300 OUTPUT.

  IF GO_CONTAINER_4 IS INITIAL.
    PERFORM SELECT_DATA_0300.
    PERFORM MODIFY_DISPLAY_0300.
    PERFORM CREATE_OBJECT_0300.
    PERFORM SET_ALV_FIELDCAT_0300.
    PERFORM SET_ALV_LAYOUT_0300.
    PERFORM SET_ALV_EVENT_0300.
    PERFORM DISPLAY_ALV_0300.
  ELSE.
*    REFRESH GT_DISPLAY5.
    PERFORM SELECT_DATA_0300.
    PERFORM MODIFY_DISPLAY_0300.
    PERFORM REFRESH_ALV_0300 USING GO_ALV_GRID_4.
  ENDIF.

  IF GO_CONTAINER_5 IS INITIAL.
    PERFORM SELECT_DATA2_0300.
*    PERFORM MODIFY_DISPLAY_0300.
    PERFORM CREATE_OBJECT2_0300.
    PERFORM SET_ALV_FIELDCAT2_0300.
    PERFORM SET_ALV_LAYOUT2_0300.
*    PERFORM SET_ALV_EVENT_0300.
    PERFORM DISPLAY5_ALV_0300.
    ELSE.
    PERFORM SELECT_DATA2_0300.
    PERFORM REFRESH2_ALV_0300 USING GO_ALV_GRID_5.

  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0400 OUTPUT
*&---------------------------------------------------------------------*
MODULE STATUS_0400 OUTPUT.
  SET PF-STATUS '0400'.
  SET TITLEBAR '0400'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ALV_0400 OUTPUT
*&---------------------------------------------------------------------*
MODULE INIT_ALV_0400 OUTPUT.

  IF GO_CONTAINER_3 IS INITIAL.
    PERFORM CREATE_OBJECT3_0100.
    PERFORM SET_ALV_FIELDCAT3_0100.
    PERFORM SET_ALV_LAYOUT_0100.
*    PERFORM SET_ALV_EVENT2_0100.
    PERFORM DISPLAY_ALV3_0100.
  ELSE.
*    PERFORM REFRESH_ALV_0100.
    GO_ALV_GRID_3->REFRESH_TABLE_DISPLAY( ).
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_LISTBOX_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE INIT_LISTBOX_0100 OUTPUT.

  TYPE-POOLS VRM.

  CLEAR: LIST.

  LOOP AT GT_LIST INTO GS_LIST.
    VALUE-KEY = GS_LIST-MATNR.
    VALUE-TEXT = GS_LIST-MAKTX.
    APPEND VALUE TO LIST.
    CLEAR: GS_LIST, VALUE.
  ENDLOOP.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      ID     = 'GV_LIST1'
      VALUES = LIST
*   EXCEPTIONS
*     ID_ILLEGAL_NAME       = 1
*     OTHERS = 2
    .
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      ID     = 'GV_LIST2'
      VALUES = LIST
*   EXCEPTIONS
*     ID_ILLEGAL_NAME       = 1
*     OTHERS = 2
    .
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      ID     = 'GV_LIST3'
      VALUES = LIST
*   EXCEPTIONS
*     ID_ILLEGAL_NAME       = 1
*     OTHERS = 2
    .
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      ID     = 'GV_LIST4'
      VALUES = LIST
*   EXCEPTIONS
*     ID_ILLEGAL_NAME       = 1
*     OTHERS = 2
    .
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      ID     = 'GV_LIST5'
      VALUES = LIST
*   EXCEPTIONS
*     ID_ILLEGAL_NAME       = 1
*     OTHERS = 2
    .
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      ID     = 'GV_LIST6'
      VALUES = LIST
*   EXCEPTIONS
*     ID_ILLEGAL_NAME       = 1
*     OTHERS = 2
    .
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      ID     = 'GV_LIST7'
      VALUES = LIST
*   EXCEPTIONS
*     ID_ILLEGAL_NAME       = 1
*     OTHERS = 2
    .
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      ID     = 'GV_LIST8'
      VALUES = LIST
*   EXCEPTIONS
*     ID_ILLEGAL_NAME       = 1
*     OTHERS = 2
    .
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      ID     = 'GV_LIST9'
      VALUES = LIST
*   EXCEPTIONS
*     ID_ILLEGAL_NAME       = 1
*     OTHERS = 2
    .
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      ID     = 'GV_LIST10'
      VALUES = LIST
*   EXCEPTIONS
*     ID_ILLEGAL_NAME       = 1
*     OTHERS = 2
    .
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0500 OUTPUT
*&---------------------------------------------------------------------*
MODULE STATUS_0500 OUTPUT.
  SET PF-STATUS '0500'.
  SET TITLEBAR '0500'.
ENDMODULE.
