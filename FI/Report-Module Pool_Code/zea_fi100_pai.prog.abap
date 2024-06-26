*&---------------------------------------------------------------------*
*& Include          ZEA_TR_TEM_PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_0100 INPUT.

  CALL METHOD : gcl_tree->free( ), gcl_container->free( ).

  FREE : gcl_tree, gcl_container.

  LEAVE TO SCREEN 0.

    CASE ok_code.
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
MODULE user_command_0100 INPUT.

    CASE ok_code.
    WHEN 'CALL_PL'.
      SUBMIT ZEA_FI090.

    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
  ENDCASE.

ENDMODULE.
