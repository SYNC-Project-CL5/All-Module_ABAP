*&---------------------------------------------------------------------*
*& Include          SAPMZEA_MM060
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.

  CASE OK_CODE.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'REFRESH' OR 'ENTR'.
      PERFORM REFRESH_RTN.
    WHEN 'CREATE_PR'.
      PERFORM CREATE_RTN.
    WHEN 'GOPO'.
      CALL TRANSACTION 'ZEA_MM070'.
  ENDCASE.
  CLEAR: OK_CODE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE EXIT_0100 INPUT.

  CASE OK_CODE.
    WHEN 'EXIT' OR 'CANC'.
      LEAVE TO SCREEN 0.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT_0110  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE EXIT_0110 INPUT.

  CASE OK_CODE.
    WHEN 'BACK' OR 'EXIT' OR 'CANC'.
      LEAVE TO SCREEN 0.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE EXIT_0200 INPUT.

  CASE OK_CODE.
    WHEN 'BACK' OR 'EXIT' OR 'CANC'.
      IF GO_GRID2 IS NOT INITIAL.
        CALL METHOD GO_GRID2->FREE.
        CALL METHOD GO_CON2->FREE.
        CLEAR: GO_GRID2, GO_CON2.
      ENDIF.
      LEAVE TO SCREEN 0.
  ENDCASE.
  CLEAR: OK_CODE.

ENDMODULE.
