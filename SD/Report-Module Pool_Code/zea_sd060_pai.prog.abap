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

  CALL METHOD GO_ALV_GRID_4->CHECK_CHANGED_DATA.

  CASE OK_CODE.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'SAVE'.
    WHEN 'SEARCH'.
      PERFORM SELECT_DATA.
      PERFORM MAKE_DISPLAY_DATA.

    WHEN 'CREATE'.
      PERFORM CREATE_DATA_0100.

    WHEN 'LIST_VIEW'.
      CALL TRANSACTION 'ZEASD070'.

    WHEN 'MANAGE'.
      CALL TRANSACTION 'ZEASDA04'.

    WHEN 'SEARCH_BTN'.
      PERFORM SELECT_DATA_CONDITION.

    WHEN 'SEARCH_BTN2'.
      PERFORM SELECT_DATA_SDT040.
      PERFORM MAKE_DISPLAY_DATA2.

    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
***&---------------------------------------------------------------------*
***&      Module  USER_COMMAND_0150  INPUT
***&---------------------------------------------------------------------*
**MODULE USER_COMMAND_0150 INPUT.
**
**  CASE OK_CODE.
**    WHEN 'OKAY'.
**      CALL SCREEN 160 STARTING AT 10 3
**                      ENDING AT 150 30.
**      PERFORM SELECT_DATA.
**      PERFORM SELECT_DATA_2.
**      PERFORM MAKE_DISPLAY_DATA.
**      LEAVE SCREEN.
**    WHEN 'CANCEL'.
**      SET SCREEN 0.
**      LEAVE SCREEN.
**  ENDCASE.
**ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0160  INPUT
*&---------------------------------------------------------------------*
MODULE USER_COMMAND_0160 INPUT.

  CASE OK_CODE.
    WHEN 'SAVE'.

     IF ZEA_SDT060-RQDAT LT SY-DATUM.
       MESSAGE  I038 DISPLAY LIKE 'W'.  " 출고 예정일을 어제 날짜 이후로 설정하세요.

       ELSE.
      _MC_POPUP_CONFIRM 'SAVE' '저장하시겠습니까?' GV_ANSWER.
      CHECK GV_ANSWER = '1'.

      PERFORM CHECK_DATA.

*      PERFORM MODIFY_DISPLAY_DATA.
*      PERFORM MAKE_DISPLAY_DATA.
*      PERFORM REFRESH_ALV_0100.
      IF ZEA_SDT060-RQDAT EQ SY-DATUM.
      PERFORM DEC_TABLE_DATA.
      PERFORM DEC_BATCH_DATA.
      ENDIF.
      ENDIF.
*      CLEAR ZEA_SDT040-VDATU.
*      CLEAR ZEA_SDT040-CUSCODE.
    WHEN 'CANCEL'.
      LEAVE TO SCREEN 0.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0170  INPUT
*&----------------------------------------------------------------------*
MODULE USER_COMMAND_0170 INPUT.

  CASE OK_CODE.
    WHEN 'SAVE'.
*      IF
*      CALL SCREEN 160 STARTING AT 10 3
*                      ENDING AT 150 30
*       ELSE
*      ENDIF.
      PERFORM CREATE_DATA.
    WHEN 'CANCEL'.
      LEAVE TO SCREEN 0.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0180  INPUT
*&---------------------------------------------------------------------*
MODULE USER_COMMAND_0180 INPUT.

  CASE OK_CODE.
    WHEN 'CHECK'.
      LEAVE TO SCREEN 0.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F4HELP  INPUT
*&---------------------------------------------------------------------*
MODULE F4HELP INPUT.

  PERFORM MMT190_F4_HELP.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  T001W_F4HELP  INPUT
*&---------------------------------------------------------------------*
MODULE T001W_F4HELP INPUT.
  PERFORM T001W_F4HELP.

ENDMODULE.
