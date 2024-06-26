*&---------------------------------------------------------------------*
*& Include          MZEA_PP100I01
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

  CALL METHOD GO_ALV_GRID_TOP->CHECK_CHANGED_DATA.

  CASE OK_CODE.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'SAVE'.
    WHEN 'BTN_SEARCH'.
      PERFORM SELECT_DATA_CONDITION.
    WHEN 'REFRESH'.
      PERFORM REFRESH_ALV_0100.
    WHEN 'APR'.
      PERFORM APPROVE_DATA.
    WHEN 'REJ'.
      PERFORM REJECT_DATA.
    WHEN 'PROCESS'.
      PERFORM LEAVE_TO_PROCESS.

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
