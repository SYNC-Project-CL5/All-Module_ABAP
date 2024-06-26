*&---------------------------------------------------------------------*
*& Include          YE12_PJ020_PBO
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
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
MODULE CLEAR_OK_CODE OUTPUT.
  CLEAR OK_CODE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ALV_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE INIT_ALV_0100 OUTPUT.

  IF GO_CONTAINER IS INITIAL.
    PERFORM CREATE_OBJECT_0100.
    PERFORM SET_ALV_FIELDCAT_0100.
    PERFORM SET_ALV_LAYOUT_0100.
    PERFORM SET_ALV_EVENT_0100.
    PERFORM DISPLAY_ALV_0100.
  ELSE.
    PERFORM REFRESH_ALV_0100.
  ENDIF.

  IF GO_CONTAINER2 IS INITIAL.
    PERFORM CREATE_OBJECT_DETAIL_0100.
    PERFORM SET_ALV_FIELDCAT_DETAIL_0100.
    PERFORM SET_ALV_LAYOUT_DETAIL_0100.
    PERFORM SET_ALV_EVENT_DETAIL_0100.
    PERFORM SET_TOOLBAR_DETAIL_0100.
    PERFORM DISPLAY_ALV_DETAIL_0100.
  ELSE.
    PERFORM REFRESH_ALV_DETAIL_0100.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module MODIFY_SCREEN_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE MODIFY_SCREEN_0100 OUTPUT.

  LOOP AT SCREEN.
    CASE GV_MODE1. " 헤더 더블클릭 한 경우
      WHEN ABAP_OFF. "새로고침과 처음시작
**        IF SCREEN-NAME EQ 'ZEA_SDT020-SP_YEAR'.
**          SCREEN-INPUT = 1.
**        ENDIF.
***        IF SCREEN-NAME EQ 'ZEA_SDT020-WERKS'.
**        IF SCREEN-NAME EQ 'GV_LIST_TEXT'.
**          SCREEN-INPUT = 1.
**        ENDIF.
      WHEN ABAP_ON. " 헤더 라인 더블클릭
        IF SCREEN-NAME EQ 'ZEA_SDT020-SP_YEAR'.
          SCREEN-INPUT = 0.
        ENDIF.
*        IF SCREEN-NAME EQ 'ZEA_SDT020-WERKS'.
        IF SCREEN-NAME EQ 'GV_LIST'.
          SCREEN-INPUT = 0.
        ENDIF.
    ENDCASE.

  ENDLOOP.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_LISTBOX_0101 OUTPUT
*&---------------------------------------------------------------------*
*&
MODULE INIT_LISTBOX_0101 OUTPUT.

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
*&---------------------------------------------------------------------*
*& Module STATUS_0110 OUTPUT
*&---------------------------------------------------------------------*
MODULE STATUS_0110 OUTPUT.
  SET PF-STATUS 'S0110'.
  SET TITLEBAR 'T0110'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ALV_0110 OUTPUT
*&---------------------------------------------------------------------*
MODULE INIT_ALV_0110 OUTPUT.

  IF GO_CONTAINER3 IS INITIAL.


    PERFORM CREATE_OBJECT_0110.

*    PERFORM SET_ALV_LAYOUT_0110. " layout 2 사용
*
    PERFORM SET_ALV_FIELDCAT_0110.
*
*    PERFORM SET_ALV_EVENT_0100.

    PERFORM DISPLAY_ALV_0110.

  ELSE.

    CALL METHOD GO_ALV_GRID3->REFRESH_TABLE_DISPLAY.

  ENDIF.


ENDMODULE.
*&---------------------------------------------------------------------*
*& Module MODIFY_DATA OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE MODIFY_DATA OUTPUT.
* 세번 별표침
*** 팝업
  REFRESH GT_DISPLAY3.
  SELECT *
    FROM ZEA_SDT030 AS A
*    LEFT JOIN ZEA_SDT020 AS C ON A~SAPNR EQ C~SAPNR
*                                                  AND A~SP_YEAR EQ C~SP_YEAR
*                                                  AND A~WERKS EQ C~WERKS
    LEFT JOIN ZEA_T001W AS B ON A~WERKS EQ B~WERKS

    INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY3
   WHERE A~SP_YEAR EQ 2023 AND A~WERKS EQ GV_LIST.



  SELECT SINGLE PNAME1
    FROM ZEA_SDT030 AS A LEFT JOIN ZEA_T001W AS B
                           ON A~WERKS EQ B~WERKS
    INTO (ZEA_T001W-PNAME1)
   WHERE A~WERKS EQ GV_LIST.


* LEAVE SCREEN.
*  SELECT SINGLE *
*    FROM ZEA_SDT020 AS A LEFT JOIN ZEA_SDT030 AS B ON A~SP_YEAR EQ B~SP_YEAR
*                                                  AND A~WERKS EQ B~WERKS
*    INTO CORRESPONDING FIELDS OF @ZEA_SDT020
*   WHERE A~SAPNR EQ B~SAPNR.

*REFRESH GT_DISPLAY3.
*
*SELECT *
*  FROM ZEA_SDT010
*  INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY3
* WHERE SV_YEAR EQ 2023 AND WERKS EQ GV_LIST.




ENDMODULE.
