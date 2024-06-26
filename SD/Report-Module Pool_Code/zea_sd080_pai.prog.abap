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

  CASE OK_CODE.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'SEARCH'.
      PERFORM SELECT_DATA.
      PERFORM MAKE_DISPLAY_DATA.
    WHEN 'SAVE'.
    WHEN 'SEARCH_BTN'.
      PERFORM SELECT_DATA_SDT040.
      PERFORM MAKE_DISPLAY_DATA2.

    WHEN 'CREATE'.
      PERFORM CREATE_DATA_0100.
    WHEN 'VIEW_LIST'.
      CALL TRANSACTION 'ZEASD090'.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT_COMMAND_0110  INPUT
*&---------------------------------------------------------------------*
MODULE EXIT_COMMAND_0110 INPUT.

  CASE OK_CODE.
    WHEN 'CANCEL'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0110  INPUT
*&---------------------------------------------------------------------*
MODULE USER_COMMAND_0110 INPUT.

  CASE OK_CODE.
    WHEN 'SAVE'.
      _MC_POPUP_CONFIRM 'SAVE' '생성하시겠습니까?' GV_ANSWER.
      CHECK GV_ANSWER = '1'.

      PERFORM CREATE_DATA.
  ENDCASE.

ENDMODULE.
