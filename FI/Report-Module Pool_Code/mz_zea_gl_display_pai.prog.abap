*&---------------------------------------------------------------------*
*& Include          MZ_ZEA_GL_DISPLAY_PAI
*&---------------------------------------------------------------------*
MODULE CHECK_BESG_0100 INPUT.

  SELECT SINGLE *
           FROM ZEA_BKPF
           INTO ZEA_BKPF
          WHERE BELNR EQ ZEA_BKPF-BELNR.

  IF SY-SUBRC EQ 0.

  ELSE.
    " 모든 화면입력필드 초기화를 위한 전역변수 초기화
    CLEAR GT_DISPLAY.
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

      " APPLICATION TOOLBAR 의 FUNCTION CODE인 TIME 을 누른 경우
      " OK_CODE 에 'TIME' 이라는 코드값이 저장되고,
      " 0150 화면이 팝업으로 출력된다.
      " 출력되는 팝업의 시작위치는 좌로 20칸 간격으로 두고
      " 위로 7줄 간격을 둔다.
      " 팝업의 종료되는 위치는 좌로 100칸, 위로 30줄이다.
      CALL SCREEN 0150 STARTING AT 20 7
                       ENDING AT   100 30.

    WHEN 'BACK'. " OK_CODE에 'BACK' 문자열이 기록되려면
      " 사용자가 Standard Toolbar 에 있는
      " 뒤로가기(F3) 버튼을 눌러야만 한다.
*        CASE .

      " 사용자가 뒤로가기 눌렀으면 이전 화면으로 이동하자
      LEAVE TO SCREEN 0.  " 이전화면으로 이동

      " 또는
    WHEN 'EXIT'.
      SET SCREEN 0. " 다음 화면을 이전 화면으로 등록
      LEAVE SCREEN. " 다음 화면으로 이동

  ENDCASE.

ENDMODULE.
*  CASE COMM.
*    WHEN GC_EXIT_PROGRAM. "'X'.
*      LEAVE PROGRAM.

*    WHEN GC_CURRENT_TIME. "'T'.
*      CALL SCREEN 150. " 전체 화면으로 호출
*      CALL SCREEN 150 STARTING AT 20 7. " 좌로 20칸 간격두고,
" 위로 7줄 간격두고 팝업 출력

*  ENDCASE.

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
*&---------------------------------------------------------------------*
*&      Module  EXIT_0100  INPUT
*&---------------------------------------------------------------------*
MODULE EXIT_0100 INPUT.
  CASE OK_CODE.
    WHEN 'CANC'.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.
