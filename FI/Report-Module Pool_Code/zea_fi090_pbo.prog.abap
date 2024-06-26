*&---------------------------------------------------------------------*
*& Include          YE08_EX001_PBO
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.
  SET PF-STATUS 'S0100'.
  SET TITLEBAR 'T0100'. " 손익계산서 조회
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CLEAR_OK_CODE OUTPUT
*&---------------------------------------------------------------------*
MODULE CLEAR_OK_CODE OUTPUT.
  " 출력될 화면의 사용자 이벤트 값을 기록하기 위해 CLEAR
  CLEAR OK_CODE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_AVL OUTPUT
*&---------------------------------------------------------------------*
MODULE INIT_AVL OUTPUT.

  " 이미 동일한 컨테이너 객체가 존재하는지 확인
  IF GO_CONTAINER IS INITIAL.
    PERFORM CREATE_OBJECT_O100.
    PERFORM SET_ALV_LAYOUT_0100.
    PERFORM SET_ALV_FIELDCAT_0100.
    PERFORM SET_ALV_EVENT_0100.
    PERFORM DISPLAY_ALV_0100.
  ELSE.

  ENDIF.
ENDMODULE.
