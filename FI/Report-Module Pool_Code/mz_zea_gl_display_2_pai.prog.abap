*&---------------------------------------------------------------------*
*& Include          MZ_ZEA_GL_DISPLAY_2_PAI
*&---------------------------------------------------------------------*
MODULE CHECK_BESG_0100 INPUT.


  SELECT SINGLE *
           FROM zea_bkpf
           INTO zea_bkpf
          WHERE belnr EQ zea_bkpf-belnr.

  IF SY-SUBRC EQ 0.

  ELSE.
    " 모든 화면입력필드 초기화를 위한 전역변수 초기화
    CLEAR gt_display.

    " 메시지 클래스 BC410 의 007 을 정보성으로 출력
*    MESSAGE I007(BC410).
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.

  CASE OK_CODE.
    WHEN 'TIME'.

      CALL SCREEN 0150 STARTING AT 20 7
                       ENDING AT   100 30.

    WHEN 'BACK'. " OK_CODE에 'BACK' 문자열이 기록되려면
                 " 사용자가 Standard Toolbar 에 있는
                 " 뒤로가기(F3) 버튼을 눌러야만 한다.

      " 사용자가 뒤로가기 눌렀으면 이전 화면으로 이동하자
      LEAVE TO SCREEN 0.  " 이전화면으로 이동

      " 또는
    WHEN 'EXIT'.
      SET SCREEN 0. " 다음 화면을 이전 화면으로 등록
      LEAVE SCREEN. " 다음 화면으로 이동

  ENDCASE.

ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0150  INPUT
*&---------------------------------------------------------------------*
MODULE USER_COMMAND_0150 INPUT.

  CASE OK_CODE.
    WHEN 'OKAY'.

      SET SCREEN 0.
      LEAVE SCREEN.

  ENDCASE.

ENDMODULE.
