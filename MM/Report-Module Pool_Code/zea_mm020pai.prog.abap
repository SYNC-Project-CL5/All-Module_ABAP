*&---------------------------------------------------------------------*
*& Include          YE07_STROPAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT_COMMAND  INPUT
*----------------------------------------------------------------------*
MODULE EXIT_COMMAND INPUT.

  CASE OK_CODE.
    WHEN 'EXIT' OR 'CANCEL'.
*      LEAVE PROGRAM.
*    WHEN 'CANCEL'.
*      LEAVE TO SCREEN 0.

        DATA : LV_ANSWER TYPE C.

  CASE OK_CODE.
    WHEN 'EXIT' OR 'CANC'.

     "변경 데이터가 있을 경우
      READ TABLE GT_DISPLAY WITH KEY STATUS = ICON_PPE_PLINE
       TRANSPORTING NO FIELDS.
      IF SY-SUBRC EQ 0.
        LV_ANSWER = 'X'.
      ENDIF.

     "오류 데이터가 있을 경우
      READ TABLE GT_DISPLAY WITH KEY STATUS = ICON_TRANSPORT_POINT
       TRANSPORTING NO FIELDS.
      IF SY-SUBRC EQ 0.
        LV_ANSWER = 'X'.
      ENDIF.

     "신규 데이터가 있을 경우
      READ TABLE GT_DISPLAY WITH KEY STATUS = SPACE  TRANSPORTING NO FIELDS.
      IF SY-SUBRC EQ 0.
        LV_ANSWER = 'X'.
      ENDIF.

     "팝업
      IF LV_ANSWER EQ 'X'.
        CLEAR: LV_ANSWER.
        CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
           EXPORTING
             DEFAULTOPTION  = 'N'
             TEXTLINE1      = '저장되지 않은 데이터가 있습니다.'
             TEXTLINE2      = '종료하시겠습니까?'
             TITEL          = '메세지 팝업'
             CANCEL_DISPLAY = ' '
           IMPORTING
             ANSWER         = LV_ANSWER.
        IF LV_ANSWER NE 'J'.
          MESSAGE '취소되었습니다.' TYPE 'S'.
          EXIT.
        ENDIF.
      ENDIF.

      IF GO_ALV_GRID IS NOT INITIAL.
        CALL METHOD GO_ALV_GRID->FREE.
        CALL METHOD GO_CONTAINER->FREE.
        CLEAR: GO_ALV_GRID, GO_CONTAINER.
      ENDIF.

      PERFORM PROGRAM_UNLOCKED.
      LEAVE TO SCREEN 0.

  ENDCASE.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.

  CALL METHOD GO_ALV_GRID->CHECK_CHANGED_DATA.
  CASE OK_CODE.
    WHEN 'BACK'.
      PERFORM BACK_RTN.

    WHEN 'SAVE'.
      _MC_POPUP_CONFIRM 'SAVE' '저장하시겠습니까?' GV_ANSWER.
      CHECK GV_ANSWER = '1'.
      PERFORM DATA_SAVE.
      PERFORM MAKE_DISPLAY_DATA.
      PERFORM REFRESH_ALV_0100.
    WHEN 'SEARCH'.
      PERFORM SEARCH_MT.
*      PERFORM SELECT_DATA.
*      PERFORM MAKE_DISPLAY_DATA.
    WHEN 'EDIT'.
      PERFORM EDIT_MODE.
    WHEN 'INSERT'.
      PERFORM DATA_INSERT.
      PERFORM REFRESH_ALV_0100.

    WHEN 'DELETE'.
      _MC_POPUP_CONFIRM 'DELETE' '정말 삭제하시겠습니까?' GV_ANSWER.
      CHECK GV_ANSWER = '1'.
      PERFORM DELETE_DATA.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F4HELP  INPUT
*&---------------------------------------------------------------------*
MODULE F4HELP INPUT.
  PERFORM MMT060_F4_HELP.
ENDMODULE.
