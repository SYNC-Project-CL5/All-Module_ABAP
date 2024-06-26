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

  CALL METHOD GO_ALV_GRID_1->CHECK_CHANGED_DATA.

  CASE OK_CODE.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'SAVE'.
      _MC_POPUP_CONFIRM 'SAVE' '저장하시겠습니까?' GV_ANSWER.
      CHECK GV_ANSWER = '1'.

      PERFORM DATA_SAVE.
    WHEN 'REFRESH'.
      PERFORM REFRESH_ALV_0100.
      PERFORM REFRESH_ALV_DETAIL_0100.
    WHEN 'PG_CREATE'.
      CALL TRANSACTION 'ZEAPP010'.
      LEAVE PROGRAM.
    WHEN 'BTN_SEARCH'.
      PERFORM SEARCH_BOM.
    WHEN 'BTN_ALL'.
      PERFORM SEARCH_ALL.

  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT_0110  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE EXIT_0110 INPUT.
  CASE OK_CODE.
    WHEN 'CANC'.
      MESSAGE S000 DISPLAY LIKE 'W' WITH '생성 작업이 취소되었습니다.'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0110  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0110 INPUT.
  CASE OK_CODE.


    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F4HELP  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE F4HELP INPUT.

  PERFORM F4_HELP.

ENDMODULE.
