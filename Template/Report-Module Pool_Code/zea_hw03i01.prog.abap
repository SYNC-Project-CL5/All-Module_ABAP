*&---------------------------------------------------------------------*
*& Include          ZMEETROOMI01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE gv_okcode.
    WHEN 'SAVE'.
      PERFORM data_save.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.

*-- Lock 해제
  CALL FUNCTION 'DEQUEUE_E_TABLE'
    EXPORTING
      mode_rstable = 'E'
      tabname      = 'ZTMEETROOM'.

  CALL METHOD : go_alv_grid->free,
                go_container->free,
                go_html_cntrl->free,
                go_top_container->free.

  FREE : go_alv_grid, go_container,
         go_html_cntrl, go_top_container.

  LEAVE TO SCREEN 0.

ENDMODULE.
