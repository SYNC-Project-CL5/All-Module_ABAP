*&---------------------------------------------------------------------*
*& Include          MZEA_PP110I01
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
    WHEN 'PG_INSP'.
      LEAVE TO TRANSACTION 'ZEAPP220'.
    WHEN 'SAVE'.
    WHEN 'BTN_SEARCH'.
      PERFORM SEARCH_DATA.
    WHEN 'BTN_ALL'.
      PERFORM SEARCH_ALL.

    WHEN 'TAB1'
      OR 'TAB2'
      OR 'TAB3'
      OR 'TAB4'
      OR 'TAB5'
      OR 'TAB6'.

      TABSTRIP-ACTIVETAB = OK_CODE.

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
