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

  CALL METHOD GO_ALV_GRID->CHECK_CHANGED_DATA. " 바뀐 데이터 여부 체크

  CASE OK_CODE.
    WHEN 'BACK'.
      IF GV_CHANGED EQ ABAP_ON.
        _MC_POPUP_CONFIRM 'SAVE' '변경된 데이터를 저장하시겠습니까?' GV_ANSWER.

        IF GV_ANSWER EQ '1'.      " YES를 누른 경우 DATA_SAVE를 수행
          PERFORM DATA_SAVE.
          LEAVE TO SCREEN 0.
        ELSEIF GV_ANSWER EQ 'A'.  " CANCEL을 누른 경우 로직을 수행하지 않는다.
        ELSE.                     " NO를 누른경우 이전 화면으로 돌아간다.
          LEAVE TO SCREEN 0.
        ENDIF.

      ELSE.
        LEAVE TO SCREEN 0.
      ENDIF.
    WHEN 'SAVE'.
      _MC_POPUP_CONFIRM 'SAVE' '저장하시겠습니까?' GV_ANSWER.
      CHECK GV_ANSWER = '1'.

      PERFORM DATA_SAVE.


    WHEN 'REFRESH'.
      PERFORM REFRESH_ALV_0100.
    WHEN 'CREATE'.
      PERFORM CREATE_DATA.
    WHEN 'BTN_SEARCH'.
      PERFORM SEARCH_DATA.
    WHEN 'EDIT'.
      PERFORM EDIT_MODE.

    WHEN 'DELETE'.
      _MC_POPUP_CONFIRM 'DELETE' '정말 삭제하시겠습니까?' GV_ANSWER.
      CHECK GV_ANSWER = '1'.

      PERFORM DATA_DELETE.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0110  INPUT
*&---------------------------------------------------------------------*
MODULE USER_COMMAND_0110 INPUT.

  CASE OK_CODE.
    WHEN 'SAVE'.
      _MC_POPUP_CONFIRM 'SAVE' '판매단가를 생성하시겠습니까?' GV_ANSWER.
      CHECK GV_ANSWER = '1'.

      PERFORM SAVE_DATA.




  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT_0110  INPUT
*&---------------------------------------------------------------------*
MODULE EXIT_0110 INPUT.

  CASE OK_CODE.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'CANC'.
      LEAVE TO SCREEN 0.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F4HELP  INPUT
*&---------------------------------------------------------------------*
MODULE F4HELP INPUT.

  PERFORM F4_HELP.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  SDT090_F4HELP  INPUT
*&---------------------------------------------------------------------*
MODULE SDT090_F4HELP INPUT.

  PERFORM SDT090_F4_HELP.

ENDMODULE.
