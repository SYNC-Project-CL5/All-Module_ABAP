*&---------------------------------------------------------------------*
*& Include          ZALV_GRID_DISPLAY_PBO
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.
  SET PF-STATUS 'S0100'.
  SET TITLEBAR 'T0100'.

  " SY-UNAME 현재 사용자
  " SY-DATUM 현재 날짜
  " SY-UZEIT 현재 시간

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CLEAR_OK_CODE OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE CLEAR_OK_CODE OUTPUT.
  CLEAR OK_CODE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ALV_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE INIT_ALV_0100 OUTPUT.

  IF GO_CONTAINER_1 IS INITIAL.
    PERFORM CREATE_OBJECT_0100.
    PERFORM SET_ALV_FIELDCAT_0100.
    PERFORM SET_ALV_LAYOUT_0100.
    PERFORM SET_ALV_EVENT_0100.
    PERFORM DISPLAY_ALV_0100.
  ELSE.
*    PERFORM REFRESH_ALV_0100.
    GO_ALV_GRID_1->REFRESH_TABLE_DISPLAY( ).
  ENDIF.

  IF GO_CONTAINER_2 IS INITIAL.
    PERFORM CREATE_OBJECT2_0100.
    PERFORM SET_ALV_FIELDCAT2_0100.
    PERFORM SET_ALV_LAYOUT2_0100.
*    PERFORM SET_ALV_EVENT2_0100.
    PERFORM DISPLAY_ALV2_0100.
  ELSE.
*    PERFORM REFRESH_ALV_0100.
    GO_ALV_GRID_2->REFRESH_TABLE_DISPLAY( ).
  ENDIF.

    IF GO_CONTAINER_4 IS INITIAL.
    PERFORM CREATE_OBJECT4_0100.
    PERFORM SET_ALV_FIELDCAT4_0100.
    PERFORM SET_ALV_LAYOUT4_0100.
*    PERFORM SET_ALV_EVENT2_0100.
    PERFORM DISPLAY_ALV4_0100.
  ELSE.
*    PERFORM REFRESH_ALV_0100.
    GO_ALV_GRID_4->REFRESH_TABLE_DISPLAY( ).
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0150 OUTPUT
*&---------------------------------------------------------------------*
MODULE STATUS_0150 OUTPUT.
  SET PF-STATUS '0150'.
  SET TITLEBAR '0150'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0160 OUTPUT
*&---------------------------------------------------------------------*
MODULE STATUS_0160 OUTPUT.
  SET PF-STATUS '0160'.
  SET TITLEBAR '0160'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0170 OUTPUT
*&---------------------------------------------------------------------*
MODULE STATUS_0170 OUTPUT.
  SET PF-STATUS '0170'.
  SET TITLEBAR '0170'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ALV_0160 OUTPUT
*&---------------------------------------------------------------------*
MODULE INIT_ALV_0160 OUTPUT.

  IF GO_CONTAINER_3 IS INITIAL.
    PERFORM CREATE_OBJECT_0160.
    PERFORM SET_ALV_FIELDCAT_0160.
    PERFORM SET_ALV_LAYOUT_0160.
    PERFORM SET_ALV_EVENT_0100.
    PERFORM DISPLAY_ALV_0160.
  ELSE.
    PERFORM REFRESH_ALV_0160.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0180 OUTPUT
*&---------------------------------------------------------------------*
MODULE STATUS_0180 OUTPUT.
  SET PF-STATUS '0180'.
  SET TITLEBAR '0180'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_LISTBOX_0160 OUTPUT
*&---------------------------------------------------------------------*
MODULE INIT_LISTBOX_0160 OUTPUT.

  TYPE-POOLS VRM.

  CLEAR: LIST.

  LOOP AT GT_LIST INTO GS_LIST.
    VALUE-KEY = GS_LIST-WERKS.
    VALUE-TEXT = GS_LIST-PNAME1.
    APPEND VALUE TO LIST.
    CLEAR: GS_LIST, VALUE.
  ENDLOOP.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      ID     = 'GV_LIST'
      VALUES = LIST
*   EXCEPTIONS
*     ID_ILLEGAL_NAME       = 1
*     OTHERS = 2
    .
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

ENDMODULE.
