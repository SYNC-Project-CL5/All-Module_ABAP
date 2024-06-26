*&---------------------------------------------------------------------*
*& Include          ZEA_GW_TES_PAI
*&---------------------------------------------------------------------*
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
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.

*  CALL METHOD GO_ALV_GRID_1->CHECK_CHANGED_DATA.

  CASE OK_CODE.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'SAVE'.
*    WHEN 'BTN_MOVE'.
*      PERFORM MOVE_DATA_CDC_TO_RDC.

    WHEN 'BTN_TRANS1' OR 'BTN_TRANS2' OR 'BTN_TRANS3' OR 'BTN_TRANS4' OR
         'BTN_TRANS5' OR 'BTN_TRANS6' OR 'BTN_TRANS7' OR 'BTN_TRANS8' OR
         'BTN_TRANS9' OR 'BTN_TRANS10'.
*      IF GV_LIST1 IS INITIAL OR GV_LIST2 IS INITIAL OR GV_LIST3 IS INITIAL OR
*         GV_LIST4 IS INITIAL OR GV_LIST5 IS INITIAL OR GV_LIST6 IS INITIAL OR
*         GV_LIST7 IS INITIAL OR GV_LIST8 IS INITIAL OR GV_LIST9 IS INITIAL OR
*         GV_LIST10 IS INITIAL.
*          MESSAGE I000 DISPLAY LIKE 'E' WITH '운송할 타이어를 선택해주세요' .
*          LEAVE SCREEN.
*      ELSE.
      PERFORM TRANSPORT_TIRE.

*      ENDIF.
*    WHEN 'BTN_GET1' OR 'BTN_GET2' OR 'BTN_GET3' OR 'BTN_GET4' OR
*         'BTN_GET5' OR 'BTN_GET6' OR 'BTN_GET7' OR 'BTN_GET8' OR
*         'BTN_GET9' OR 'BTN_GET10'.
*      PERFORM GET_TIRE.

    WHEN OTHERS.
  ENDCASE.




ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0200 INPUT.

  CASE OK_CODE.
    WHEN 'CONC'.
      LEAVE TO SCREEN 0.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0300  INPUT
*&---------------------------------------------------------------------*
MODULE USER_COMMAND_0300 INPUT.

  CASE OK_CODE.
    WHEN 'SAVE'.



      IF ZEA_MMT100-PLANTTO IS INITIAL OR S0100-MENGET IS INITIAL.
        MESSAGE I074 DISPLAY LIKE 'W'.

      ELSE.
        _MC_POPUP_CONFIRM 'SAVE' '이전 하시겠습니까?' GV_ANSWER.
        CHECK GV_ANSWER = '1'.
*        IF S0100-MENGE1 IS NOT INITIAL.
*          PERFORM CAL_MENGE.
*        ELSE.
        PERFORM MOVE_TIRE_DATA_MMT190.
        PERFORM CHANGE_TIRE_BATCH_DATA_MMT070.
        ZEA_MMT190-ERDAT = SY-DATUM.
        ZEA_MMT190-ERZET = SY-UZEIT.
        PERFORM MM_FI_FUNCTION.


        PERFORM MODIFY_DISPLAY_0300.
        PERFORM REFRESH_ALV_0300 USING GO_ALV_GRID_4.

        PERFORM SELECT_DATA2_0300.
        PERFORM REFRESH2_ALV_0300 USING GO_ALV_GRID_5.
      ENDIF.



      LEAVE TO SCREEN 0300.


    WHEN 'CONT'.
*      PERFORM SELECT_PLANT.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0400  INPUT
*&---------------------------------------------------------------------*
MODULE USER_COMMAND_0400 INPUT.

  CASE OK_CODE.
    WHEN 'CONC'.
      LEAVE TO SCREEN 0.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F4HELP  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE F4HELP INPUT.

  PERFORM MMT190_F4_HELP.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_MENGE1  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE CHECK_MENGE1 INPUT.

  DATA : LT_MMT190 TYPE TABLE OF ZEA_MMT190,
         LS_MMT190 LIKE LINE OF LT_MMT190,
         LV_CALQTY TYPE ZEA_MMT190-CALQTY.

  CLEAR: LS_MMT190, LV_CALQTY.
  REFRESH LT_MMT190.

  SELECT CALQTY
    FROM ZEA_MMT190
    INTO CORRESPONDING FIELDS OF TABLE LT_MMT190
    WHERE WERKS EQ ZEA_MMT100-PLANTFR
      AND SCODE EQ ZEA_MMT100-LGORTFR
      AND MATNR EQ ZEA_MMT100-MATNR.

  LOOP AT LT_MMT190 INTO LS_MMT190.
    LV_CALQTY = LV_CALQTY + LS_MMT190-CALQTY.
  ENDLOOP.

  IF LV_CALQTY < S0100-MENGET.
    MESSAGE E000 WITH '보유한 재고 수량보다 입력한 수량이 많습니다. 알맞은 재고이전 수량을 입력해주세요'.
  ENDIF.

  CLEAR LV_CALQTY.
  LV_CALQTY = S0100-MENGET MOD 1.

  IF LV_CALQTY NE 0.
    MESSAGE E000 WITH '소수점은 입력할 수 없습니다'.
  ENDIF.



ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_PLANTFR_AND_MENGET  INPUT
*&---------------------------------------------------------------------*
MODULE CHECK_PLANTFR INPUT.

  IF ZEA_MMT100-PLANTFR IS INITIAL.
    MESSAGE E000 WITH '출고지를 선택해주세요.'.
  ELSEIF ZEA_MMT100-PLANTFR EQ ZEA_MMT100-PLANTTO.
    MESSAGE E000 WITH '출고지와 입고지가 같습니다. 다른 입고지를 선택해주세요.'.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_PLANTTO_AND_MENGET2  INPUT
*&---------------------------------------------------------------------*
MODULE CHECK_MENGET INPUT.

  IF S0100-MENGET IS INITIAL.
    MESSAGE E000 WITH '0개의 재고는 이전할 수 없습니다.'.
  ELSEIF S0100-MENGET EQ 0 OR S0100-MENGET LT 0.
    MESSAGE E000 WITH '0개의 이하의 재고는 이전할 수 없습니다.'.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT_0300  INPUT
*&---------------------------------------------------------------------*
MODULE EXIT_0300 INPUT.


  CASE OK_CODE.
    WHEN 'CANC'.
      CLEAR S0100.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
