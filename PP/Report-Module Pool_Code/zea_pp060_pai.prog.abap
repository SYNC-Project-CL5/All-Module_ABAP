*&---------------------------------------------------------------------*
*& Include          ZALV_GRID_DISPLAY_PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
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
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.

  CALL METHOD GO_ALV_GRID->CHECK_CHANGED_DATA.

  CASE OK_CODE.
    WHEN 'SEARCH_BTN'.
      PERFORM SELECT_DATA_CONDITION.
    WHEN 'REFRESH'.
      PERFORM REFRESH_ALV_0100.
      PERFORM REFRESH_ALV2_0100.
    WHEN 'RUD'.
      CALL TRANSACTION 'ZEA_PP050'.
*      LEAVE PROGRAM.
    WHEN 'CREATE'.
      _mc_popup_confirm 'SAVE' '생산계획을 생성하시겠습니까?' gv_answer.
      CHECK gv_answer = '1'.
      PERFORM CREATE_DATA.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'SAVE'.
      _MC_POPUP_CONFIRM 'SAVE' '변경된 생산계획을 저장하시겠습니까?' GV_ANSWER.
      CHECK GV_ANSWER = '1'.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
