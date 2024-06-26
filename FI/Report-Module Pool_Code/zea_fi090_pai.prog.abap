*&---------------------------------------------------------------------*
*& Include          YE08_EX001_PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT_0100  INPUT
*&---------------------------------------------------------------------*
MODULE EXIT_0100 INPUT.

  CASE OK_CODE.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'CANC'.
      LEAVE TO SCREEN 0.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.
  CASE OK_CODE.
    WHEN 'CALL_BS'.
      SUBMIT ZEA_FI_BS_4.

    WHEN 'BACK'.
      LEAVE TO SCREEN 0.

    WHEN  'PDF'.
      MESSAGE 'PDF 파일 내려받기' TYPE 'S'.


      SELECT * FROM ZEA_PA0000 INTO TABLE I_T001 UP TO 100 ROWS.
      W_PRINT-PRINT = 'X'.

      CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
        EXPORTING
          I_CALLBACK_PROGRAM = G_PROGRAM
          I_STRUCTURE_NAME   = 'T001'
          IS_PRINT           = W_PRINT
        TABLES
          T_OUTTAB           = I_T001.

      G_SPOOL = SY-SPONO.

      IF G_SPOOL IS INITIAL.
        MESSAGE 'No spool job found' TYPE 'E'.
      ELSE.

        CALL FUNCTION 'CONVERT_ABAPSPOOLJOB_2_PDF'
          EXPORTING
            SRC_SPOOLID = G_SPOOL
          TABLES
            PDF         = PDF.
*
        IF SY-SUBRC = 0.
          CALL FUNCTION 'GUI_DOWNLOAD'
            EXPORTING
              FILENAME = '손익계산서.pdf'
              FILETYPE = 'BIN'
            TABLES
              DATA_TAB = PDF.
        ELSE.
          MESSAGE 'Failed to convert spool to PDF' TYPE 'E'.
        ENDIF.
      ENDIF.

  ENDCASE.
ENDMODULE.
