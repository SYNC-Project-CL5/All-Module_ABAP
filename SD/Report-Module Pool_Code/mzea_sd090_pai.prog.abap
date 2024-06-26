*&---------------------------------------------------------------------*
*& Include          MZEA_SD090_PAI
*&---------------------------------------------------------------------*
MODULE CHECK_BESG_0100 INPUT.

  " 화면에서 사용자가 입력한 값을 기준으로
  " 테이블 SFLIGHT 의 조건으로 검색한다.

  " 검색된 데이터가 없으면, BC410 메시지 클래스의 007번 메시지를
  " 정보성 메시지로 출력하고, 화면의 입력조건을 초기화한다.

  " 화면의 입력필드의 값을 어떻게 이 프로그램 소스코드에서
  " 사용할 수 있는가???

  " 답. 화면의 입력필드의 이름과 동일한 변수를 만들면
  "     입력필드의 값을 서로 공유할 수 있다.

  " 우리가 화면에서 입력할 수 있는 필드는
  " SDYN_CONN-CARRID, SDYN_CONN-CONNID, SDYN_CONN-FLDATE 만 가능하다.

***
***  SELECT SINGLE * " PRICE
***                  " CURRENCY
***                  " PLANETYPE
***                  " SEATSMAX
***                  " SEATSOCC
***                  " PAYMENTSUM
***           FROM zea_bkpf
***           INTO zea_bkpf
***          WHERE belnr EQ zea_bkpf-belnr.
***
***  IF SY-SUBRC EQ 0.
***
***  ELSE.
***    " 모든 화면입력필드 초기화를 위한 전역변수 초기화
***    CLEAR gt_display.
***
***    " 메시지 클래스 BC410 의 007 을 정보성으로 출력
****    MESSAGE I007(BC410).
***  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.

  CASE OK_CODE.


    WHEN 'BACK'.
      LEAVE TO SCREEN 0.  " 이전화면으로 이동
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
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'CANC'.
      LEAVE TO SCREEN 0.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
