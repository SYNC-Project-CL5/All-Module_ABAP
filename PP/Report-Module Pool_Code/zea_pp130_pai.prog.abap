*&---------------------------------------------------------------------*
*& Include          YE00_EX001_PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT_0100  INPUT
*&---------------------------------------------------------------------*
MODULE EXIT_0100 INPUT.

  CASE OK_CODE.
    WHEN 'EXIT'.
      LEAVE PROGRAM.      " 프로그램을 종료
    WHEN 'CANC'.
      LEAVE TO SCREEN 0.  " 이전 화면으로 이동
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.

  CASE OK_CODE.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.  " 이전 화면으로 이동

    WHEN 'REFRESH'.
       PERFORM REFRESH_ALV_0100.
*       LEAVE TO SCREEN 0100.

  ENDCASE.

ENDMODULE.
