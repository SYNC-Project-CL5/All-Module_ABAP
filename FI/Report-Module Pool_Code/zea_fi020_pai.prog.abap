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

  CASE OK_CODE.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'SAVE'.

    WHEN 'DISPLAY_D'. "고객 관련 전표
      PERFORM DISPLAY_D.
      PERFORM REFRESH_ALV_0100.
      PERFORM LINE_MESSAGE.

    WHEN 'DISPLAY_K'. "공급사 관련 전표
      PERFORM DISPLAY_K.
      PERFORM REFRESH_ALV_0100.
      PERFORM LINE_MESSAGE.


    WHEN 'DISPLAY_W'. "재고 관련 전표
      PERFORM DISPLAY_W.
      PERFORM REFRESH_ALV_0100.
      PERFORM LINE_MESSAGE.


    WHEN 'DISPLAY_S'. "일반 전표
      PERFORM DISPLAY_S.
      PERFORM REFRESH_ALV_0100.
      PERFORM LINE_MESSAGE.


    WHEN 'NO_FILT'. "고객관련 전표
      PERFORM NO_FILTER.
      PERFORM REFRESH_ALV_0100.
      PERFORM LINE_MESSAGE.


    WHEN 'CALL_CREAT'. "전표 생성 프로그램 호출
      SUBMIT ZEA_FI030 AND RETURN.

  ENDCASE.

ENDMODULE.
