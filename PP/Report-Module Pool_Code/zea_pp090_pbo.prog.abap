*&---------------------------------------------------------------------*
*& Include          YE00_EX007PBO
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.
  SET PF-STATUS '0100'.
  SET TITLEBAR  '0100'. "[PP] 생산오더 생성
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

  ENDIF.

  IF GO_CONTAINER IS INITIAL.
    PERFORM CREATE_OBJECT_SPLIT_0100.
    PERFORM SET_ALV_FIELDCAT_SPLIT_0100.
    PERFORM SET_ALV_LIST_SPLIT_0100.
    PERFORM SET_ALV_LAYOUT_SPLIT_0100.
    PERFORM SET_ALV_EVENT_SPLIT_0100.
    PERFORM DISPLAY_ALV_SPLIT_0100.
  ELSE.
    PERFORM REFRESH_ALV_SPLIT_0100.
*    PERFORM MODIFY_DISPLAY_DATA.
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
  SET TITLEBAR '0110'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_DATA_0110 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE INIT_DATA_0110 OUTPUT.

  READ TABLE GT_DISPLAY INTO GS_DISPLAY INDEX GS_INDEX_ROW-INDEX.

*     이미 존재하는 생산오더가 있으면 존재하는 월의 체크필드를 잠군다.
*  REFRESH GT_PPT020.
*
*  SELECT *
*    FROM ZEA_PPT020 AS A
*    JOIN ZEA_AUFK   AS B ON B~AUFNR EQ A~AUFNR
*    JOIN ZEA_MMT020 AS C ON C~MATNR EQ A~MATNR
*                        AND C~SPRAS EQ SY-LANGU
*    JOIN ZEA_T001W  AS D ON D~WERKS EQ A~WERKS
*    INTO CORRESPONDING FIELDS OF TABLE GT_PPT020
*    WHERE B~PLANID EQ GS_DISPLAY-PLANID
*      AND A~MATNR  EQ GS_DISPLAY-MATNR.

*  LOOP AT GT_PPT020 INTO GS_PPT020.
*    CASE GS_PPT020-EXPSDATE+0(6).
*      WHEN S0110-EXPSDATE1+0(6).
*        LOOP AT SCREEN.
*          CASE SCREEN-NAME.
*            WHEN 'S0110-1MONTH'.
*              SCREEN-INPUT = 0.
*          ENDCASE.
*          MODIFY SCREEN.
*        ENDLOOP.
*      WHEN S0110-EXPSDATE2+0(6).
*        LOOP AT SCREEN.
*          CASE SCREEN-NAME.
*            WHEN 'S0110-2MONTH'.
*              SCREEN-INPUT = 0.
*          ENDCASE.
*          MODIFY SCREEN.
*        ENDLOOP.
*      WHEN S0110-EXPSDATE3+0(6).
*        LOOP AT SCREEN.
*          CASE SCREEN-NAME.
*            WHEN 'S0110-3MONTH'.
*              SCREEN-INPUT = 0.
*          ENDCASE.
*          MODIFY SCREEN.
*        ENDLOOP.
*      WHEN S0110-EXPSDATE4+0(6).
*        LOOP AT SCREEN.
*          CASE SCREEN-NAME.
*            WHEN 'S0110-4MONTH'.
*              SCREEN-INPUT = 0.
*          ENDCASE.
*          MODIFY SCREEN.
*        ENDLOOP.
*      WHEN S0110-EXPSDATE5+0(6).
*        LOOP AT SCREEN.
*          CASE SCREEN-NAME.
*            WHEN 'S0110-5MONTH'.
*              SCREEN-INPUT = 0.
*          ENDCASE.
*          MODIFY SCREEN.
*        ENDLOOP.
*      WHEN S0110-EXPSDATE6+0(6).
*        LOOP AT SCREEN.
*          CASE SCREEN-NAME.
*            WHEN 'S0110-6MONTH'.
*              SCREEN-INPUT = 0.
*          ENDCASE.
*          MODIFY SCREEN.
*        ENDLOOP.
*      WHEN S0110-EXPSDATE7+0(6).
*        LOOP AT SCREEN.
*          CASE SCREEN-NAME.
*            WHEN 'S0110-7MONTH'.
*              SCREEN-INPUT = 0.
*          ENDCASE.
*          MODIFY SCREEN.
*        ENDLOOP.
*      WHEN S0110-EXPSDATE8+0(6).
*        LOOP AT SCREEN.
*          CASE SCREEN-NAME.
*            WHEN 'S0110-8MONTH'.
*              SCREEN-INPUT = 0.
*          ENDCASE.
*          MODIFY SCREEN.
*        ENDLOOP.
*      WHEN S0110-EXPSDATE9+0(6).
*        LOOP AT SCREEN.
*          CASE SCREEN-NAME.
*            WHEN 'S0110-9MONTH'.
*              SCREEN-INPUT = 0.
*          ENDCASE.
*          MODIFY SCREEN.
*        ENDLOOP.
*      WHEN S0110-EXPSDATE10+0(6).
*        LOOP AT SCREEN.
*          CASE SCREEN-NAME.
*            WHEN 'S0110-10MONTH'.
*              SCREEN-INPUT = 0.
*          ENDCASE.
*          MODIFY SCREEN.
*        ENDLOOP.
*      WHEN S0110-EXPSDATE11+0(6).
*        LOOP AT SCREEN.
*          CASE SCREEN-NAME.
*            WHEN 'S0110-11MONTH'.
*              SCREEN-INPUT = 0.
*          ENDCASE.
*          MODIFY SCREEN.
*        ENDLOOP.
*      WHEN S0110-EXPSDATE12+0(6).
*        LOOP AT SCREEN.
*          CASE SCREEN-NAME.
*            WHEN 'S0110-12MONTH'.
*              SCREEN-INPUT = 0.
*          ENDCASE.
*          MODIFY SCREEN.
*        ENDLOOP.
*    ENDCASE.
*
*
*  ENDLOOP.


* 체크버튼 토글 버튼 구현
  FIELD-SYMBOLS <FS>.

  DATA LV_CHECK TYPE C.

  LOOP AT SCREEN.
    CASE SCREEN-NAME+7(3).
      WHEN 'MON' OR '0MO' OR '1MO' OR '2MO'.
*        ASSIGN COMPONENT SCREEN-NAME+6 OF STRUCTURE S0110 TO <FS>.
*        IF SY-SUBRC EQ 0.
*          LV_CHECK = <FS>.
*          UNASSIGN <FS>.
*        ENDIF.

        ASSIGN (SCREEN-NAME) TO <FS>.
        IF <FS> IS ASSIGNED.
          GV_CHECK = <FS>.
          UNASSIGN <FS>.
        ENDIF.

      WHEN 'XPS' OR 'XPE' OR 'XPQ'.
        IF GV_CHECK EQ ABAP_ON.
          SCREEN-INPUT = 1.
          MODIFY SCREEN.
        ELSE.

        ENDIF.
    ENDCASE.
  ENDLOOP.

  DATA LV_MONTH TYPE C LENGTH 2.
  LV_MONTH = SY-DATUM+4(2).

  CASE LV_MONTH.
    WHEN '01'.
    WHEN '02'.
      LOOP AT SCREEN.
        CASE SCREEN-NAME.
          WHEN 'S0110-1MONTH'.
            SCREEN-INPUT = 0.
        ENDCASE.
        MODIFY SCREEN.
      ENDLOOP.
    WHEN '03'.
      LOOP AT SCREEN.
        CASE SCREEN-NAME.
          WHEN 'S0110-1MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-2MONTH'.
            SCREEN-INPUT = 0.
        ENDCASE.
        MODIFY SCREEN.
      ENDLOOP.
    WHEN '04'.
      LOOP AT SCREEN.
        CASE SCREEN-NAME.
          WHEN 'S0110-1MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-2MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-3MONTH'.
            SCREEN-INPUT = 0.
        ENDCASE.
        MODIFY SCREEN.
      ENDLOOP.
    WHEN '05'.
      LOOP AT SCREEN.
        CASE SCREEN-NAME.
          WHEN 'S0110-1MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-2MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-3MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-4MONTH'.
            SCREEN-INPUT = 0.
        ENDCASE.
        MODIFY SCREEN.
      ENDLOOP.
    WHEN '06'.
      LOOP AT SCREEN.
        CASE SCREEN-NAME.
          WHEN 'S0110-1MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-2MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-3MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-4MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-5MONTH'.
            SCREEN-INPUT = 0.
        ENDCASE.
        MODIFY SCREEN.
      ENDLOOP.
    WHEN '07'.
      LOOP AT SCREEN.
        CASE SCREEN-NAME.
          WHEN 'S0110-1MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-2MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-3MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-4MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-5MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-6MONTH'.
            SCREEN-INPUT = 0.
        ENDCASE.
        MODIFY SCREEN.
      ENDLOOP.
    WHEN '08'.
      LOOP AT SCREEN.
        CASE SCREEN-NAME.
          WHEN 'S0110-1MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-2MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-3MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-4MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-5MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-6MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-7MONTH'.
            SCREEN-INPUT = 0.
        ENDCASE.
        MODIFY SCREEN.
      ENDLOOP.
    WHEN '09'.
      LOOP AT SCREEN.
        CASE SCREEN-NAME.
          WHEN 'S0110-1MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-2MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-3MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-4MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-5MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-6MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-7MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-8MONTH'.
            SCREEN-INPUT = 0.
        ENDCASE.
        MODIFY SCREEN.
      ENDLOOP.
    WHEN '10'.
      LOOP AT SCREEN.
        CASE SCREEN-NAME.
          WHEN 'S0110-1MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-2MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-3MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-4MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-5MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-6MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-7MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-8MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-9MONTH'.
            SCREEN-INPUT = 0.
        ENDCASE.
        MODIFY SCREEN.
      ENDLOOP.
    WHEN '11'.
      LOOP AT SCREEN.
        CASE SCREEN-NAME.
          WHEN 'S0110-1MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-2MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-3MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-4MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-5MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-6MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-7MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-8MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-9MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-10MONTH'.
            SCREEN-INPUT = 0.
        ENDCASE.
        MODIFY SCREEN.
      ENDLOOP.
    WHEN '12'.
      LOOP AT SCREEN.
        CASE SCREEN-NAME.
          WHEN 'S0110-1MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-2MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-3MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-4MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-5MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-6MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-7MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-8MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-9MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-10MONTH'.
            SCREEN-INPUT = 0.
          WHEN 'S0110-11MONTH'.
            SCREEN-INPUT = 0.
        ENDCASE.
        MODIFY SCREEN.
      ENDLOOP.
  ENDCASE.

ENDMODULE.
