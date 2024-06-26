*&---------------------------------------------------------------------*
*& Include          ZMEETROOMI01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.

  CASE OK_CODE.

*--- Basic Button
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.

    WHEN 'CANC'.
      LEAVE TO SCREEN 0.

*--- financial Button

    WHEN 'ARCLEAR'.  "A/R 반제 처리

      PERFORM AR_PAY.

    WHEN 'AR_MAIL'.  "독촉장 생성

     PERFORM CHECK_ROWS_STATUS.

*--- Display Mail record
    WHEN 'SOST'.
      PERFORM CALL_SOST.

    ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE EXIT INPUT.

  CASE OK_CODE.

*--- Basic Button
    WHEN 'EXIT'.

      LEAVE PROGRAM.
  ENDCASE.

ENDMODULE.
