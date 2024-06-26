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

  CASE OK_CODE.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'SAVE'.
      _MC_POPUP_CONFIRM 'SAVE' '저장하시겠습니까?' GV_ANSWER.
      CHECK GV_ANSWER = '1'.

      PERFORM DATA_SAVE.
    WHEN 'REFRESH'.
      PERFORM REFRESH_ALV_0100.
*      PERFORM REFRESH_ALV2_0100.
    WHEN 'APR'.
      PERFORM APPROVE_DATA.
    WHEN 'VBELN'.
      CALL TRANSACTION 'ZEASD030'.
    WHEN 'LIST_VIEW'.
      CALL TRANSACTION 'ZEASD060'.

    WHEN 'KNKK'.
      CALL TRANSACTION 'ZEASD160'.

    WHEN 'EDIT'.
      PERFORM EDIT_MODE.

    WHEN 'DELETE'.
      PERFORM DATA_DELETE.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
