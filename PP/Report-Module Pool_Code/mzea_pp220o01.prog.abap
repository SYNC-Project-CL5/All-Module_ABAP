*&---------------------------------------------------------------------*
*& Include          SAPMZEA_03O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.
  SET PF-STATUS '0100'.
  SET TITLEBAR '0100'.

  " SY-UNAME 현재 사용자
  " SY-DATUM 현재 날짜
  " SY-UZEIT 현재 시간

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CLEAR_OK_CODE OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE CLEAR_OK_CODE OUTPUT.
  CLEAR OK_CODE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ALV_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE INIT_ALV_0100 OUTPUT.

  IF GO_CONTAINER IS INITIAL.
*    PERFORM SELECT_DATA_PPT020.
    PERFORM SELECT_DATA_AUFK.
    PERFORM MAKE_DISPLAY_DATA.
    PERFORM MAKE_DISPLAY_DATA2.

    PERFORM CREATE_OBJECT_0100.
    PERFORM SET_ALV_LAYOUT_0100.
    PERFORM SET_ALV_EVENT_0100.
    PERFORM SET_ALV_FIELDCAT_0100.
    PERFORM DISPLAY_ALV_0100.
  ELSE.
    PERFORM REFRESH_ALV_0100 USING GO_ALV_GRID.
  ENDIF.

  IF GO_CONTAINER2 IS INITIAL.
*    PERFORM SELECT_DATA_AFRU.
    PERFORM MAKE_DISPLAY_DATA3.
    PERFORM CREATE_OBJECT_0110.
    PERFORM SET_ALV_FIELDCAT_0110.
    PERFORM SET_ALV_LAYOUT_0100.
*    PERFORM SET_ALV_EVENT_0100_2.
    PERFORM DISPLAY_ALV_0110.
  ELSE.
    PERFORM REFRESH_ALV_0110 USING GO_ALV_GRID_2.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_LISTBOX OUTPUT
*&---------------------------------------------------------------------*
MODULE INIT_LISTBOX OUTPUT.

* 미사용

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module FILL_DYNNR_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE FILL_DYNNR_0100 OUTPUT.

  PERFORM INIT_VAL.

  CASE TABSTRIP-ACTIVETAB.
    WHEN 'TAB1'.
      GV_PRESSEDTAB = 'TAB1'.
      GV_SUBSCREEN = '0110'.


    WHEN 'TAB2'.
      GV_PRESSEDTAB = 'TAB2'.
      GV_SUBSCREEN = '0120'.

      PERFORM CAL_FNPD_1_6.

    WHEN 'TAB3'.
      GV_PRESSEDTAB = 'TAB3'.
      GV_SUBSCREEN = '0130'.

      PERFORM CAL_FNPD_7_12.

    WHEN 'TAB4'.
      GV_PRESSEDTAB = 'TAB4'.
      GV_SUBSCREEN = '0140'.

      PERFORM CAL_FNPD_13_18.

    WHEN 'TAB5'.
      GV_PRESSEDTAB = 'TAB5'.
      GV_SUBSCREEN = '0150'.

      PERFORM CAL_FNPD_19_24.

    WHEN OTHERS.
      TABSTRIP-ACTIVETAB = 'TAB1'.
      GV_SUBSCREEN = '0110'.
  ENDCASE.

***  *  " 각 탭스트립에서 불량품 수를 가져옴
***  CASE TABSTRIP-ACTIVETAB.
***
***    WHEN 'TAB2'.
***      GS_DATA3-FNPD = GV_FNPD1.
***
***    WHEN 'TAB3'.
***      GS_DATA3-FNPD = GV_FNPD2.
***
***    WHEN 'TAB4'.
***      GS_DATA3-FNPD = GV_FNPD3.
***
***    WHEN 'TAB5'.
***      GS_DATA3-FNPD = GV_FNPD4.
***  ENDCASE.

*  PERFORM MAKE_DISPLAY_DATA_3.

  IF ZEA_MMT010-MATNR IS INITIAL.
    CLEAR ZEA_MMT020-MAKTX.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module MODIFY_SCREEN_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE MODIFY_SCREEN_0100 OUTPUT.

  GO_CONTAINER3->SET_VISIBLE( GV_SHOW_APPROVAL ).
*  GO_EDITOR->SET_VISIBLE( GV_SHOW_APPROVAL ).

  CHECK GV_SHOW_APPROVAL IS INITIAL.

  LOOP AT SCREEN.
    IF SCREEN-GROUP1 = 'MOD'.
      SCREEN-ACTIVE = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

ENDMODULE.
