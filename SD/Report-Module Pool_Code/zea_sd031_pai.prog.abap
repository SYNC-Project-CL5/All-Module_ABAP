*&---------------------------------------------------------------------*
*& Include          YE12_PJ034_PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT_0100  INPUT
*&---------------------------------------------------------------------*
MODULE EXIT_0100 INPUT.

  CASE OK_CODE.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'CANC'.
      LEAVE TO SCREEN 0.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.

  CALL METHOD GO_ALV_GRID2->CHECK_CHANGED_DATA. " 엔터 안치고도 데이터 저장

  CASE OK_CODE.

    WHEN 'KLIMK'.

      SUBMIT ZEA_SD160 WITH PA_CUS = ZEA_KNA1-CUSCODE AND RETURN.

    WHEN 'SAVE'.
      PERFORM CONFIRM_SAVE.

    WHEN 'BACK'.
      LEAVE TO SCREEN 0.

    WHEN 'REFRESH'.
      PERFORM REFRESH_ALV_0100.

    WHEN 'SO_MANAGE'.
      CALL TRANSACTION 'ZEASDA04'.
      LEAVE PROGRAM.

    WHEN 'CREATE'.
*      PERFORM CREATE_SP_DATA.

* gv_pressedtab 에는 해당 tab 의 functioncode 가 들어가야 한다
    WHEN 'TAB1'.
      GV_PRESSEDTAB = 'TAB1'.
      GV_SUBSCREEN = '0110'.
    WHEN 'TAB2'.
      GV_PRESSEDTAB = 'TAB2'.
      GV_SUBSCREEN = '0120'.

*   신규생성시 탭스트립 활성화
    WHEN 'NEW_ORDER'.
      IF GS_BPDATA IS INITIAL.
        " 판매오더를 생성할 고객코드를 입력해주세요.
        MESSAGE S033 DISPLAY LIKE 'E'.
      ELSE.
        GV_MODE = GC_MODE_CREATE.

        CLEAR GS_RBGROUP.
        GS_RBGROUP-RA1 = ABAP_ON.
        CLEAR ZEA_SDT040.
        ZEA_SDT040-ODDAT = SY-DATUM.
        REFRESH GT_DISPLAY2.
        CALL METHOD GO_ALV_GRID2->REFRESH_TABLE_DISPLAY.
      ENDIF.


    WHEN 'DISPLAY'.
      PERFORM SELECT_DATA_CONDITION.


***    WHEN 'MAKE_DATA'.
***      PERFORM SAVE_HEADER.
***      PERFORM REFRESH_ALV_0100.
****      PERFORM REFRESH_BPDATA.
***      GV_SHOW = ABAP_OFF.

    WHEN 'MAKE_DATA'.
      GV_MODE = GC_MODE_CREATE_ITEM.

      PERFORM MAKE_DATA.

      _MC_POPUP_CONFIRM '판매오더 작성'
      '판매오더가 생성되었습니다. 내용을 작성하시겠습니까?' GV_ANSWER.
      IF GV_ANSWER = '1'.
        " 더블클릭할 때 탭의 포지션이 자꾸 바뀌어서 그거 고정시켜줌.
        " 근데 계속 고정 탭스트립이 바뀔 필요가 없으니까 더블클릭 할때만 작동하게.
        GV_PRESSEDTAB = 'TAB1'.
        GV_SUBSCREEN = '0110'.
        GO_TAB-%_SCROLLPOSITION  = 'TAB2'.
      ENDIF.

      PERFORM REFRESH_ALV_0100_2.
  ENDCASE.

*  IF GT_DISPLAY1 IS INITIAL.
*    MESSAGE S033 .
**    DISPLAY LIKE 'I'.
*  ELSEIF GT_DISPLAY1 IS INITIAL AND ZEA_KNA1-CUSCODE IS NOT INITIAL.
*    MESSAGE S013 DISPLAY LIKE 'W'.
*  ELSEIF GT_DISPLAY1 IS NOT INITIAL.
*    MESSAGE S006 WITH GV_LINES.
*  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EDIT_ITEM_TABLE  INPUT
*&---------------------------------------------------------------------*
MODULE EDIT_ITEM_TABLE INPUT.
*    DATA LV_CHECK TYPE I.
*
*  LV_CHECK = GO_ALV_GRID2->IS_READY_FOR_INPUT( ).
*
*  IF LV_CHECK EQ 0.
*    LV_CHECK = 1.
*  ELSE.
*    LV_CHECK = 0.
*  ENDIF.
*
*  CALL METHOD GO_ALV_GRID2->SET_READY_FOR_INPUT
*    EXPORTING
*      I_READY_FOR_INPUT = LV_CHECK. " Ready for Input Status

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_KNA1  INPUT
*&---------------------------------------------------------------------*
MODULE CHECK_KNA1 INPUT.

  CLEAR GS_BPDATA.
*CLEAR ZEA_KNA1.

*  IF ZEA_KNA1-CUSCODE IS INITIAL.
*    MESSAGE E033. " 판매오더를 생성할 고객코드를 입력해주세요..
*  ENDIF.

  SELECT SINGLE *
    FROM ZEA_KNA1
    INTO CORRESPONDING FIELDS OF GS_BPDATA
   WHERE CUSCODE EQ ZEA_KNA1-CUSCODE.

*  IF SY-SUBRC NE 0.
*    MESSAGE E036. " 해당 고객을 찾을 수 없습니다.
*  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_INPUT  INPUT
*&---------------------------------------------------------------------*
MODULE CHECK_INPUT INPUT.

    IF ZEA_SDT040-VDATU < ZEA_SDT040-ODDAT.
    MESSAGE E000 WITH '주문일자 이전 날짜는 입력할 수 없습니다.'.
  ENDIF.

ENDMODULE.
