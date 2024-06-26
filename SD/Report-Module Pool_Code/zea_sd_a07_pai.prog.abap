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

  DATA LT_INDEX_ROWS TYPE LVC_T_ROW.
  DATA LS_INDEX_ROW LIKE LINE OF LT_INDEX_ROWS.

  CALL METHOD GO_ALV_GRID_1->GET_SELECTED_ROWS
    IMPORTING
      ET_INDEX_ROWS = LT_INDEX_ROWS     " Indexes of Selected Rows
*     ET_ROW_NO     =                  " Numeric IDs of Selected Rows
    .

  CASE OK_CODE.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'SAVE'.
    WHEN 'SEARCH'.
      PERFORM SELECT_DATA.
      PERFORM MAKE_DISPLAY_DATA.

    WHEN 'CREATE'.

      IF LT_INDEX_ROWS[] IS INITIAL.
        CALL SCREEN 0170 STARTING AT 20 7.
      ELSE.
        PERFORM MOVE_DATA.
        _MC_POPUP_CONFIRM '송장 생성' '송장을 생성하시겠습니까?' GV_ANSWER.
        CHECK GV_ANSWER = '1'.

        CALL SCREEN 0160 STARTING AT 50 5.

*      MESSAGE '송장을 생성하시겠습니까?' TYPE 'I'.
*      CALL SCREEN 0150 STARTING AT 20 7
*                        ENDING AT 60 10.
      ENDIF.
    WHEN 'LIST_VIEW'.
*       CALL TRANSACTION ''.
    WHEN 'ORDER'.
      CALL TRANSACTION 'ZEASDA04'.
      LEAVE PROGRAM.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0150  INPUT
*&---------------------------------------------------------------------*
MODULE USER_COMMAND_0150 INPUT.

  CASE OK_CODE.
    WHEN 'OKAY'.
      CALL SCREEN 160 STARTING AT 10 3
                      ENDING AT 150 30.
      PERFORM SELECT_DATA.
      PERFORM SELECT_DATA_2.
      PERFORM MAKE_DISPLAY_DATA.
      LEAVE SCREEN.
    WHEN 'CANCEL'.
      SET SCREEN 0.
      LEAVE SCREEN.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0160  INPUT
*&---------------------------------------------------------------------*
MODULE USER_COMMAND_0160 INPUT.

  CASE OK_CODE.
    WHEN 'SAVE'.
      _MC_POPUP_CONFIRM 'SAVE' '저장하시겠습니까?' GV_ANSWER.
      CHECK GV_ANSWER = '1'.

      PERFORM CREATE_DATA.
*      PERFORM MAKE_DISPLAY_DATA.
*      PERFORM REFRESH_ALV_0100.
    WHEN 'CANCEL'.
      LEAVE TO SCREEN 0.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0170  INPUT
*&---------------------------------------------------------------------*
MODULE USER_COMMAND_0170 INPUT.

  CASE OK_CODE.
    WHEN 'CHECK'.
      LEAVE TO SCREEN 0.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0180  INPUT
*&---------------------------------------------------------------------*
MODULE USER_COMMAND_0180 INPUT.

  CASE OK_CODE.
    WHEN 'CHECK'.
      LEAVE TO SCREEN 0100.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT_0170  INPUT
*&---------------------------------------------------------------------*
MODULE EXIT_0170 INPUT.

  CASE OK_CODE.
    WHEN 'CANCEL'.
      LEAVE TO SCREEN 0.
  ENDCASE.

ENDMODULE.
