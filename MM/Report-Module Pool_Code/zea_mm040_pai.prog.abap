*&---------------------------------------------------------------------*
*& Include          ZEA_MM040_PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE EXIT_0100 INPUT.

  DATA : LV_ANSWER TYPE C.

  CASE OK_CODE.
    WHEN 'EXIT' OR 'CANC'.

      " 변경 데이터가 있을 경우
      READ TABLE GT_MMT030 WITH KEY ICON = '@5D@' TRANSPORTING NO FIELDS.
      IF SY-SUBRC EQ 0.
        LV_ANSWER = 'X'.
      ENDIF.
       " 오류 데이터가 있을 경우
      READ TABLE GT_MMT030 WITH KEY ICON = '@5C@' TRANSPORTING NO FIELDS.
      IF SY-SUBRC EQ 0.
        LV_ANSWER = 'X'.
      ENDIF.

      " 신규 데이터가 있을 경우
      READ TABLE GT_MMT030 WITH KEY ICON  = SPACE TRANSPORTING NO FIELDS.
      IF SY-SUBRC EQ 0.
        LV_ANSWER = 'X'.
      ENDIF.

      " 팝업 띄우기
      IF LV_ANSWER EQ 'X'.
        CLEAR : LV_ANSWER.
        CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
          EXPORTING
            DEFAULTOPTION  = 'N'
            TEXTLINE1      = '저장되지 않은 데이터가 있습니다.'
            TEXTLINE2      = '종료하시겠습니까?'
            TITEL          = '메시지 팝업'
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
        CLEAR : GO_ALV_GRID, GO_CONTAINER.
      ENDIF.

      LEAVE TO SCREEN 0.

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
      PERFORM BACK_RTN.

    WHEN 'REFRESH' OR 'ENTR'.
      PERFORM REFRESH_RTN.

    WHEN 'CHANGE'.
      GV_MODE = 'C'.
      PERFORM TOGGLE_RTN.

    WHEN 'DISPLAY'.
      GV_MODE = 'D'.
      PERFORM TOGGLE_RTN.

    WHEN 'INSERT'.
      PERFORM INSERT_RTN.

    WHEN 'DELETE'.
      PERFORM DELETE_RTN.

    WHEN 'SAVE'.
      PERFORM SAVE_RTN.

  ENDCASE.

  CLEAR OK_CODE.

  ENDMODULE.
