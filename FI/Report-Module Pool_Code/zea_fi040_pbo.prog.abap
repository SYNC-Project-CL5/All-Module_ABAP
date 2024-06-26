*&---------------------------------------------------------------------*
*& Include          YE00_EX001_PBO
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.
  SET PF-STATUS '0100'.
  SET TITLEBAR  '0100'. " 잔액 조회: G/L 계정 원장
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ALV_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE INIT_ALV_0100 OUTPUT.

  " 이미 동일한 컨테이너 객체가 존재하는지 확인
  IF GO_CONTAINER IS INITIAL.

    " 커스텀 컨테이너 객체가 존재하지 않는 경우 ( 즉, 첫 실행 )
    PERFORM CREATE_OBJECT_0100.
    PERFORM SET_ALV_LAYOUT_0100.
    PERFORM SET_AVL_FIELDCAT_0100.
    PERFORM SET_ALV_EVENT_0100.
    PERFORM DISPLAY_ALV_0100.
  ELSE.
    " 존재하는 경우 (  첫 실행 이후 다시 실행된 경우 )
    PERFORM REFRESH_ALV_0100.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CLEAR_OK_CODE OUTPUT
*&---------------------------------------------------------------------*
MODULE CLEAR_OK_CODE OUTPUT.

  CLEAR OK_CODE.  " 출력될 화면의 사용자 이벤트 값을 기록하기 위해
                  " OK_CODE 의 값을 미리 비워둔다.

ENDMODULE.
