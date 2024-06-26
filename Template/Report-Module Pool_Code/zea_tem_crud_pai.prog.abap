*&---------------------------------------------------------------------*
*& Include          ZALV_GRID_CRUD_PAI
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

    WHEN 'INSERT'.
      PERFORM DATA_INSERT.

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
*&      Module  EXIT_0110  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE EXIT_0110 INPUT.
  CASE OK_CODE.
    WHEN 'CANC'.
      MESSAGE S000 DISPLAY LIKE 'W' WITH '생성 작업이 취소되었습니다.'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Form DATA_INSERT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DATA_INSERT .

  " 데이터를 생성할 수 있는 팝업창을 호출
  CALL SCREEN 0110 STARTING AT 50 5.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0110  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0110 INPUT.

  CASE OK_CODE.
    WHEN 'SAVE'.

      CLEAR GS_DISPLAY.
      " 생성 관련 정보를 먼저 설정
*      ZPFLI_E23-ERDAT = SY-DATUM. " 생성일자를 오늘로
*      ZPFLI_E23-ERZET = SY-UZEIT. " 생성시간을 현재 시간으로
*      ZPFLI_E23-ERNAM = SY-UNAME. " 생성자를 현재 로그인한 사용자ID

      MOVE-CORRESPONDING ZPFLI_E23 TO GS_DISPLAY.

      " 키 값 체크
      IF ZPFLI_E23-CARRID IS INITIAL.
        MESSAGE S000 DISPLAY LIKE 'E' WITH 'CHECK KEY FIELD'.
        EXIT.
      ELSEIF ZPFLI_E23-CONNID IS INITIAL.
        MESSAGE S000 DISPLAY LIKE 'E' WITH 'CHECK KEY FIELD'.
        EXIT.
      ENDIF.

      INSERT ZPFLI_E23.

      IF SY-SUBRC EQ 0.
        COMMIT WORK AND WAIT.
        APPEND GS_DISPLAY TO GT_DISPLAY.
        MESSAGE S015.  " 데이터 성공적으로 저장되었습니다.
        LEAVE TO SCREEN 0.
      ELSE.
        ROLLBACK WORK. " 데이터 저장 중 오류가 발생했습니다.
        MESSAGE E016.
      ENDIF.

  ENDCASE.

ENDMODULE.
