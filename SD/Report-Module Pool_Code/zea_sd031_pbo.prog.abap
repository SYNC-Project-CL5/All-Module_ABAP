*&---------------------------------------------------------------------*
*& Include          YE12_PJ034_PBO
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.
  SET PF-STATUS 'S0100'.
  SET TITLEBAR 'T0100'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CLEAR_OK_CODE OUTPUT
*&---------------------------------------------------------------------*
MODULE CLEAR_OK_CODE OUTPUT.
  CLEAR OK_CODE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ALV_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE INIT_ALV_0100 OUTPUT.

  IF GO_CONTAINER1 IS INITIAL.
    PERFORM CREATE_OBJECT_0100.
    PERFORM SET_ALV_FIELDCAT_0100.
    PERFORM SET_ALV_LAYOUT_0100.
    PERFORM SET_ALV_EVENT_0100.
    PERFORM DISPLAY_ALV_0100.
  ELSE.
*    PERFORM SELECT_DATA_CONDITION.
    PERFORM REFRESH_ALV_0100.
  ENDIF.


  IF GO_CONTAINER2 IS INITIAL.
    PERFORM CREATE_OBJECT_0100_2.
    PERFORM SET_ALV_FIELDCAT_0100_2.
    PERFORM SET_ALV_LAYOUT_0100_2.
    PERFORM SET_ALV_EVENT_0100_2.
    PERFORM DISPLAY_ALV_0100_2.
  ELSE.
    PERFORM REFRESH_ALV_0100_2.
  ENDIF.


ENDMODULE.
*&---------------------------------------------------------------------*
*& Module SET_SCREEN OUTPUT
*&---------------------------------------------------------------------*
MODULE SET_SCREEN OUTPUT.

  CASE GV_MODE.
    WHEN GC_MODE_CREATE.
      GV_PRESSEDTAB = 'TAB2'.
      GV_SUBSCREEN = '0120'.
      GO_TAB-%_SCROLLPOSITION = 'TAB2'.
  ENDCASE.

* activetab 에는 해당tab의 function code값이 들어간다
  GO_TAB-ACTIVETAB = GV_PRESSEDTAB.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module MODIFY_SCREEN OUTPUT
*&---------------------------------------------------------------------*
MODULE MODIFY_SCREEN_0100 OUTPUT.

  CASE GV_MODE.
    WHEN GC_MODE_DISPLAY.
      " 조회모드 = 모든 화면이 전부 읽기 전용, 저장관련 버튼 제거
      PERFORM MODIFY_SCREEN_DISPLAY.
    WHEN GC_MODE_CREATE.
      " 생성모드 = 판매오더에 대한 헤더 쓰기가능, 아이템으로 이동하는 버튼 출력
      PERFORM MODIFY_SCREEN_CREATE_0100.
    WHEN GC_MODE_CREATE_ITEM.
      " 생성모드 = 판매오더에 대한 아이템 필드가 쓰기가능
      PERFORM MODIFY_SCREEN_CREATE_ITEM_0100.
    WHEN GC_MODE_SAVED.
      " 저장까지 완료했을 때 판매오더에 대한 수정이 불가능
      PERFORM MODIFY_SCREEN_SAVED_0100.
  ENDCASE.


*** 3개 추가했음
**** 탭스트립 보였다 가렸다
****  LOOP AT SCREEN.
*****    IF SCREEN-NAME = GO_TAB.
****    IF SCREEN-GROUP1 = 'T01' AND GV_SHOW = ABAP_OFF.
****      SCREEN-ACTIVE = 0.
*****      SCREEN-INVISIBLE = 0.
****    ELSEIF SCREEN-GROUP1 = 'T01'." AND GV_SHOW = 'X'.
****      SCREEN-ACTIVE = 1.
****    ENDIF.
****    MODIFY SCREEN.
****  ENDLOOP.
***
****--------------------------------------------------------------------*
***  LOOP AT SCREEN.
***
***    CASE GV_SHOW.
***      WHEN ABAP_OFF.
***        IF SCREEN-GROUP1 EQ 'T01' .
***          SCREEN-ACTIVE = 0.
***        ENDIF.
***
***      WHEN ABAP_ON.
***        IF SCREEN-GROUP1 EQ 'T01'.
***          SCREEN-ACTIVE = 1.
***          SCREEN-INVISIBLE = 0.
****          IF SCREEN-NAME EQ 'TAB1'.
****            SCREEN-ACTIVE = 0.
****          ENDIF.
***        ENDIF.
***
****        IF SCREEN-NAME EQ 'ZEA_KNA1-CUSCODE'. """ 이 필드 왜 잠그는거지 ? 일단 주석.
****          SCREEN-INPUT = 0.
****        ENDIF.
***
***    ENDCASE.
***
***    CASE GV_SHOW_BUTTON.
***      WHEN ABAP_OFF.
***        IF SCREEN-NAME EQ 'NEW_ORDER'.
***          SCREEN-ACTIVE = 0.
***        ENDIF.
***
***      WHEN ABAP_ON.
***        IF SCREEN-NAME EQ 'NEW_ORDER'.
***          SCREEN-ACTIVE = 1.
***        ENDIF.
***
****        IF SCREEN-NAME EQ 'ZEA_KNA1-CUSCODE'.  """ 이 필드 왜 잠그는거지 ? 일단 주석.
****          SCREEN-INPUT = 0.
****        ENDIF.
***    ENDCASE.
***
***    CASE GV_SHOW_TAB.
***      WHEN ABAP_OFF.
***        IF SCREEN-NAME EQ 'TAB1'.
***          SCREEN-ACTIVE = 0.
***        ENDIF.
***      WHEN ABAP_ON.
***        IF SCREEN-NAME EQ 'TAB1'.
***          SCREEN-ACTIVE = 1.
***        ENDIF.
****        IF SCREEN-NAME EQ '0110'.
****          SCREEN-ACTIVE =
****        ENDIF.
***        IF SCREEN-NAME EQ 'ZEA_KNA1-ODDAT'.
***          SCREEN-INPUT = 0.
***        ENDIF.
***        IF SCREEN-NAME EQ 'ZEA_KNA1-VDATU'.
***          SCREEN-INPUT = 0.
***        ENDIF.
***    ENDCASE.
****
****    CASE GV_MODE1. " -->> 이거 120화면에 있는거라 거기로 옮김.
****      WHEN ABAP_ON.
****        IF SCREEN-NAME EQ 'ZEA_SDT040-ODDAT'.
****          SCREEN-INPUT = 0.
****        ENDIF.
****        IF SCREEN-NAME EQ 'ZEA_SDT040-SADDR'.
****          SCREEN-INPUT = 0.
****        ENDIF.
****        IF SCREEN-NAME EQ 'ZEA_SDT040-VDATU'.
****          SCREEN-INPUT = 0.
****        ENDIF.
****        IF SCREEN-NAME EQ 'SAVE'.
****          SCREEN-ACTIVE = 0.
****        ENDIF.
****    ENDCASE.
***    CASE GV_MODE2.
***      WHEN ABAP_ON.
***        IF SCREEN-GROUP1 EQ 'T01' .
***          SCREEN-ACTIVE = 1.
***        ENDIF.
***        IF SCREEN-NAME EQ 'TAB1'.
***          SCREEN-ACTIVE = 1.
***        ENDIF.
***        IF SCREEN-NAME EQ 'MAKE_DATA' .
***          SCREEN-ACTIVE = 0.
***        ENDIF.
***
***      WHEN ABAP_OFF.
****        IF SCREEN-GROUP1 EQ 'T01' .
****          SCREEN-ACTIVE = 0.
****        ENDIF.
****        IF SCREEN-NAME EQ 'TAB1'.
****          SCREEN-ACTIVE = 0.
****        ENDIF.
***        IF SCREEN-NAME EQ 'MAKE_DATA' .
***          SCREEN-ACTIVE = 1.
***        ENDIF.
***
***    ENDCASE.
***
***
***    MODIFY SCREEN.
***  ENDLOOP.
****--------------------------------------------------------------------*


ENDMODULE.

*  ZEA_SDT040-VBELN = GS_DATA1-VBELN.
*  ZEA_SDT040-CUSCODE = GS_DATA1-CUSCODE.
*  ZEA_SDT040-SADDR = GS_DATA1-SADDR.
*  ZEA_SDT040-VDATU = GS_DATA1-VDATU.
*  ZEA_SDT040-ADATU = GS_DATA1-ADATU.
*  ZEA_SDT040-ODDAT = GS_DATA1-ODDAT.
*  ZEA_SDT040-TOAMT = GS_DATA1-TOAMT.
*  ZEA_SDT040-WAERS = GS_DATA1-WAERS.
*&---------------------------------------------------------------------*
*& Module MODIFY_SCREEN_0120 OUTPUT
*&---------------------------------------------------------------------*
MODULE MODIFY_SCREEN_0120 OUTPUT.

  CASE GV_MODE.
    WHEN GC_MODE_DISPLAY.
      " 아이템으로 넘어가는 버튼만 숨김
      LOOP AT SCREEN.
        IF SCREEN-NAME = 'MAKE_DATA'.
          SCREEN-ACTIVE = 0.
          MODIFY SCREEN.
        ENDIF.
      ENDLOOP.

    WHEN GC_MODE_CREATE
      OR GC_MODE_CREATE_ITEM.

      LOOP AT SCREEN.
        IF SCREEN-GROUP1 = 'MOD'.
          SCREEN-INPUT = 1.
          MODIFY SCREEN.
        ENDIF.
      ENDLOOP.


  ENDCASE.


****  LOOP AT SCREEN.
****
****    CASE GV_MODE1. " -->> 이거 120화면에 있는거라 여기로 옮김.
****      WHEN ABAP_ON.
****        IF SCREEN-NAME EQ 'ZEA_SDT040-ODDAT'.
****          SCREEN-INPUT = 0.
****        ENDIF.
****        IF SCREEN-NAME EQ 'ZEA_SDT040-SADDR'.
****          SCREEN-INPUT = 0.
****        ENDIF.
****        IF SCREEN-NAME EQ 'ZEA_SDT040-VDATU'.
****          SCREEN-INPUT = 0.
****        ENDIF.
****        IF SCREEN-NAME EQ 'SAVE'.
****          SCREEN-ACTIVE = 0.
****        ENDIF.
****    ENDCASE.
****
*****    CASE GV_MODE2.
*****      WHEN ABAP_ON.
*****        IF SCREEN-GROUP1 EQ 'T01' .
*****          SCREEN-ACTIVE = 1.
*****        ENDIF.
*****        IF SCREEN-NAME EQ 'TAB1'.
*****          SCREEN-ACTIVE = 1.
*****        ENDIF.
*****        IF SCREEN-NAME EQ 'MAKE_DATA' .
*****          SCREEN-ACTIVE = 0.
*****        ENDIF.
*****
*****      WHEN ABAP_OFF.
*****        IF SCREEN-GROUP1 EQ 'T01' .
*****          SCREEN-ACTIVE = 0.
*****        ENDIF.
*****        IF SCREEN-NAME EQ 'TAB1'.
*****          SCREEN-ACTIVE = 0.
*****        ENDIF.
*****    ENDCASE.
****    MODIFY SCREEN.
****  ENDLOOP.



ENDMODULE.
*&---------------------------------------------------------------------*
*& Module MODIFY_SCREEN_0110 OUTPUT
*&---------------------------------------------------------------------*
*MODULE MODIFY_SCREEN_0110 OUTPUT.
*
*  DATA: LT_SDT040 TYPE ZEA_SDT040,
*        LS_SDT040 LIKE LINE OF LT_SDT040.
*
*  SELECT SINGLE *
*    FROM ZEA_SDT040
*    INTO CORRESPONDING FIELDS OF GS_DATA1
*   WHERE VBELN EQ GS_DISPLAY1-VBELN.
*  ZEA_SDT040-TOAMT =
*
*ENDMODULE.
