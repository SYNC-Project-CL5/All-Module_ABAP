*&---------------------------------------------------------------------*
*& Include          SAPMZEA_03I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE EXIT_0100 INPUT.

  CASE OK_CODE.
    WHEN 'EXIT'.

*      PERFORM CHECK_TRANSPORT.
      LEAVE PROGRAM.
    WHEN 'CANC'.
*      PERFORM CHECK_TRANSPORT.
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

  DATA LT_INDEX_ROWS TYPE LVC_T_ROW.
  DATA LS_INDEX_ROW LIKE LINE OF LT_INDEX_ROWS.

  CASE OK_CODE.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'SAVE'.

    WHEN 'BTN_SHOW'.

      IF ZEA_PPT020-AUFNR IS INITIAL.
        _MC_POPUP_CONFIRM '확인' '생산 실적을 조회하시겠습니까?' GV_ANSWER.
        IF GV_ANSWER = '1'.
          CALL TRANSACTION 'ZEAPP130'.
        ELSE.
          LEAVE TO SCREEN 0100.
        ENDIF.
      ELSE.
        _MC_POPUP_CONFIRM '확인' '선택된 생산오더 ID로 조회하시겠습니까?' GV_ANSWER.
        IF GV_ANSWER = '1'.
          SUBMIT ZEA_PP130 WITH SO_AUF = ZEA_PPT020-AUFNR.

        ELSEIF GV_ANSWER = '2'.
          CALL TRANSACTION 'ZEAPP130'.
        ELSEIF GV_ANSWER = 'A'.
          LEAVE TO SCREEN 0100.
        ENDIF.
      ENDIF.

    WHEN 'BTN_SAVE'.
      _MC_POPUP_CONFIRM 'SAVE' '폐기사유를 저장하시겠습니까?' GV_ANSWER.
      CHECK GV_ANSWER = '1'.
      PERFORM SAVE_DATA.
      MESSAGE S066. " 폐기사유가 저장되었습니다. 결재를 수행해주세요.

    WHEN 'LOAD'.
      PERFORM LOAD_DATA.

    WHEN 'ENAB'.
      PERFORM ENABLE_DATA.

    WHEN 'PROT'.
      PERFORM PROTECT_LINE.

    WHEN 'BTN_SEARCH'.
      PERFORM SELECT_DATA_CONDITION.

    WHEN 'REFRESH'.
      PERFORM REFRESH_ALV.


    WHEN 'BTN_APPROVAL'.

      IF ZEA_AFRU-TSDAT IS INITIAL OR ZEA_PA0000-EMPCODE IS INITIAL.
        MESSAGE S000 DISPLAY LIKE 'E' WITH '검수자 또는 검수일자를 확인해주세요'.
      ELSEIF ZEA_AFRU-TSDAT IS INITIAL.
        MESSAGE S000 DISPLAY LIKE 'E' WITH '검수자 확인해주세요'.
      ELSEIF ZEA_PA0000-EMPCODE IS INITIAL.
        MESSAGE S000 DISPLAY LIKE 'E' WITH '검수일자 확인해주세요'.
      ELSE.
        _MC_POPUP_CONFIRM 'SAVE' '결재하시겠습니까?' GV_ANSWER.
        CHECK GV_ANSWER = '1'.
*      PERFORM APPROVE_DATA.
        PERFORM MAKE_DISPLAY_DATA3_BTN.
        MESSAGE S065. " 결재가 완료되었습니다.
      ENDIF.


    WHEN 'APR'. " 검수 승인
      REFRESH LT_INDEX_ROWS.
      CLEAR LS_INDEX_ROW.
      CALL METHOD GO_ALV_GRID_2->GET_SELECTED_ROWS
        IMPORTING
          ET_INDEX_ROWS = LT_INDEX_ROWS     " Indexes of Selected Rows
*         ET_ROW_NO     =                  " Numeric IDs of Selected Rows
        .
      IF LT_INDEX_ROWS[] IS INITIAL.
        " TEXT-M01: 라인을 선택하세요.
        MESSAGE S000 DISPLAY LIKE 'W' WITH '라인을 선택하세요'.

      ELSE.
        CLEAR GS_DISPLAY3.
        READ TABLE GT_DISPLAY3 INTO GS_DISPLAY3 INDEX 1.
        DATA LV_AFRU TYPE C.

        SELECT SINGLE
          FROM ZEA_AFRU
          FIELDS AUFNR
          WHERE AUFNR EQ @GS_DISPLAY3-AUFNR
          INTO @LV_AFRU.

       IF SY-SUBRC EQ 0.
         MESSAGE S000 DISPLAY LIKE 'W' WITH '이미 검수 승인이 완료된 건 입니다.'.

       ELSE.

        IF ZEA_AFRU-TSDAT IS INITIAL OR ZEA_PA0000-EMPCODE IS INITIAL.
          MESSAGE S067 DISPLAY LIKE 'E'. " 미결재 건입니다. 결재를 진행해주세요.
        ELSE.
          _MC_POPUP_CONFIRM 'SAVE' '검수 승인하시겠습니까?' GV_ANSWER.
          CHECK GV_ANSWER = '1'.
          PERFORM APPROVE_FINAL.  " 생산 실적 테이블에 값 INSERT
          " 생산 오더 테이블에 최종 생산량 값 UPDATE
          MESSAGE S000 WITH '검수 승인이 완료되었습니다. 입고를 진행해주세요'.
        ENDIF.
       ENDIF.
      ENDIF.



    WHEN 'SHIP'. " 입고

      REFRESH LT_INDEX_ROWS.
      CLEAR LS_INDEX_ROW.
      CALL METHOD GO_ALV_GRID_2->GET_SELECTED_ROWS
        IMPORTING
          ET_INDEX_ROWS = LT_INDEX_ROWS     " Indexes of Selected Rows
*         ET_ROW_NO     =                  " Numeric IDs of Selected Rows
        .
      IF LT_INDEX_ROWS[] IS INITIAL.
        " TEXT-M01: 라인을 선택하세요.
        MESSAGE S000 DISPLAY LIKE 'W' WITH '라인을 선택하세요'.

      ELSE.
        CLEAR GS_DISPLAY3.
        READ TABLE GT_DISPLAY3 INTO GS_DISPLAY3 INDEX 1.

        IF GS_DISPLAY3-TSDAT IS NOT INITIAL.
          _MC_POPUP_CONFIRM 'SAVE' '입고하시겠습니까?' GV_ANSWER.
          CHECK GV_ANSWER = '1'.
          PERFORM UPDATE_STOCK_MMT190. " 재고 테이블 재고량 증가
          PERFORM CREATE_BATCH_NUMBER. " 배치번호 채번 후 배치테이블에 반영
          PERFORM CREATE_MMT090_MMT100. " 자재문서 및 회계문서 터짐
          MESSAGE S071 WITH ZEA_MMT070-CHARG.  " 입고신청이 완료되었습니다. 생성된 배치번호는 & 입니다.

        ELSE.

          IF ZEA_AFRU-TSDAT IS INITIAL.
            MESSAGE S070 DISPLAY LIKE 'E'.  " 검수가 진행되지 않은 실적입니다.
          ELSE.
            _MC_POPUP_CONFIRM 'SAVE' '입고하시겠습니까?' GV_ANSWER.
            CHECK GV_ANSWER = '1'.
            PERFORM UPDATE_STOCK_MMT190. " 재고 테이블 재고량 증가
            PERFORM CREATE_BATCH_NUMBER. " 배치번호 채번 후 배치테이블에 반영
            PERFORM CREATE_MMT090_MMT100. " 자재문서 및 회계문서 터짐
            MESSAGE S071 WITH ZEA_MMT070-CHARG.  " 입고신청이 완료되었습니다. 생성된 배치번호는 & 입니다.
          ENDIF.
        ENDIF.
      ENDIF.

    WHEN 'BTN_CHECK'.

      GV_SHOW_APPROVAL = COND #( WHEN GV_SHOW_APPROVAL IS INITIAL
                                 THEN ABAP_ON
                                 ELSE ABAP_OFF ).
**      IF GV_HIDE_APPROVAL = ''.
**        GV_HIDE_APPROVAL = 'X'.
**      ELSE.
**        GV_HIDE_APPROVAL = ''.
**      ENDIF.
      " TAB STRIP 바꾸기 위해 선언.
    WHEN 'TAB1' OR 'TAB2' OR 'TAB3' OR 'TAB4' OR 'TAB5'.
      TABSTRIP-ACTIVETAB = OK_CODE.

    WHEN 'LIST_MAKTX'.
      PERFORM CHANGE_TAB.

      CALL FUNCTION 'SAPGUI_SET_FUNCTIONCODE'
        EXPORTING
          FUNCTIONCODE           = 'ENTE'
        EXCEPTIONS
          FUNCTION_NOT_SUPPORTED = 1
          OTHERS                 = 2.



    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_PDBAN1  INPUT
*&---------------------------------------------------------------------*
MODULE CHECK_PDBAN1 INPUT.

  " 생산수량보다 불량수량이 높은 경우
  CHECK S0100-PDQUAN1 < S0100-PDBAN1.

  " 불량수량이 생산수량보다 크면 안됩니다.
  MESSAGE E069.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_PDBAN2  INPUT
*&---------------------------------------------------------------------*
MODULE CHECK_PDBAN2 INPUT.

  " 생산수량보다 불량수량이 높은 경우
  CHECK S0100-PDQUAN2 < S0100-PDBAN2.

  " 불량수량이 생산수량보다 크면 안됩니다.
  MESSAGE E069.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_PDBAN3  INPUT
*&---------------------------------------------------------------------*
MODULE CHECK_PDBAN3 INPUT.

  " 생산수량보다 불량수량이 높은 경우
  CHECK S0100-PDQUAN3 < S0100-PDBAN3.

  " 불량수량이 생산수량보다 크면 안됩니다.
  MESSAGE E069.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_PDBAN4  INPUT
*&---------------------------------------------------------------------*
MODULE CHECK_PDBAN4 INPUT.

  " 생산수량보다 불량수량이 높은 경우
  CHECK S0100-PDQUAN4 < S0100-PDBAN4.

  " 불량수량이 생산수량보다 크면 안됩니다.
  MESSAGE E069.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_PDBAN5  INPUT
*&---------------------------------------------------------------------*
MODULE CHECK_PDBAN5 INPUT.

  " 생산수량보다 불량수량이 높은 경우
  CHECK S0100-PDQUAN5 < S0100-PDBAN5.

  " 불량수량이 생산수량보다 크면 안됩니다.
  MESSAGE E069.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_PDBAN6  INPUT
*&---------------------------------------------------------------------*
MODULE CHECK_PDBAN6 INPUT.

  " 생산수량보다 불량수량이 높은 경우
  CHECK S0100-PDQUAN6 < S0100-PDBAN6.

  " 불량수량이 생산수량보다 크면 안됩니다.
  MESSAGE E069.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_PDBAN7  INPUT
*&---------------------------------------------------------------------*
MODULE CHECK_PDBAN7 INPUT.

  " 생산수량보다 불량수량이 높은 경우
  CHECK S0100-PDQUAN7 < S0100-PDBAN7.

  " 불량수량이 생산수량보다 크면 안됩니다.
  MESSAGE E069.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_PDBAN8  INPUT
*&---------------------------------------------------------------------*
MODULE CHECK_PDBAN8 INPUT.

  " 생산수량보다 불량수량이 높은 경우
  CHECK S0100-PDQUAN8 < S0100-PDBAN8.

  " 불량수량이 생산수량보다 크면 안됩니다.
  MESSAGE E069.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_PDBAN9  INPUT
*&---------------------------------------------------------------------*
MODULE CHECK_PDBAN9 INPUT.

  " 생산수량보다 불량수량이 높은 경우
  CHECK S0100-PDQUAN9 < S0100-PDBAN9.

  " 불량수량이 생산수량보다 크면 안됩니다.
  MESSAGE E069.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_PDBAN10  INPUT
*&---------------------------------------------------------------------*
MODULE CHECK_PDBAN10 INPUT.

  " 생산수량보다 불량수량이 높은 경우
  CHECK S0100-PDQUAN10 < S0100-PDBAN10.

  " 불량수량이 생산수량보다 크면 안됩니다.
  MESSAGE E069.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_PDBAN11  INPUT
*&---------------------------------------------------------------------*
MODULE CHECK_PDBAN11 INPUT.

  " 생산수량보다 불량수량이 높은 경우
  CHECK S0100-PDQUAN11 < S0100-PDBAN11.

  " 불량수량이 생산수량보다 크면 안됩니다.
  MESSAGE E069.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_PDBAN12  INPUT
*&---------------------------------------------------------------------*
MODULE CHECK_PDBAN12 INPUT.

  " 생산수량보다 불량수량이 높은 경우
  CHECK S0100-PDQUAN12 < S0100-PDBAN12.

  " 불량수량이 생산수량보다 크면 안됩니다.
  MESSAGE E069.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_PDBAN13  INPUT
*&---------------------------------------------------------------------*
MODULE CHECK_PDBAN13 INPUT.

  " 생산수량보다 불량수량이 높은 경우
  CHECK S0100-PDQUAN13 < S0100-PDBAN13.

  " 불량수량이 생산수량보다 크면 안됩니다.
  MESSAGE E069.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_PDBAN14  INPUT
*&---------------------------------------------------------------------*
MODULE CHECK_PDBAN14 INPUT.

  " 생산수량보다 불량수량이 높은 경우
  CHECK S0100-PDQUAN14 < S0100-PDBAN14.

  " 불량수량이 생산수량보다 크면 안됩니다.
  MESSAGE E069.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_PDBAN15  INPUT
*&---------------------------------------------------------------------*
MODULE CHECK_PDBAN15 INPUT.

  " 생산수량보다 불량수량이 높은 경우
  CHECK S0100-PDQUAN15 < S0100-PDBAN15.

  " 불량수량이 생산수량보다 크면 안됩니다.
  MESSAGE E069.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_PDBAN16  INPUT
*&---------------------------------------------------------------------*
MODULE CHECK_PDBAN16 INPUT.

  " 생산수량보다 불량수량이 높은 경우
  CHECK S0100-PDQUAN16 < S0100-PDBAN16.

  " 불량수량이 생산수량보다 크면 안됩니다.
  MESSAGE E069.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_PDBAN17  INPUT
*&---------------------------------------------------------------------*
MODULE CHECK_PDBAN17 INPUT.

  " 생산수량보다 불량수량이 높은 경우
  CHECK S0100-PDQUAN17 < S0100-PDBAN17.

  " 불량수량이 생산수량보다 크면 안됩니다.
  MESSAGE E069.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_PDBAN18  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE CHECK_PDBAN18 INPUT.

  " 생산수량보다 불량수량이 높은 경우
  CHECK S0100-PDQUAN18 < S0100-PDBAN18.

  " 불량수량이 생산수량보다 크면 안됩니다.
  MESSAGE E069.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_PDBAN20  INPUT
*&---------------------------------------------------------------------*
MODULE CHECK_PDBAN20 INPUT.

  " 생산수량보다 불량수량이 높은 경우
  CHECK S0100-PDQUAN20 < S0100-PDBAN20.

  " 불량수량이 생산수량보다 크면 안됩니다.
  MESSAGE E069.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_PDBAN21  INPUT
*&---------------------------------------------------------------------*
MODULE CHECK_PDBAN21 INPUT.

  " 생산수량보다 불량수량이 높은 경우
  CHECK S0100-PDQUAN21 < S0100-PDBAN21.

  " 불량수량이 생산수량보다 크면 안됩니다.
  MESSAGE E069.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_PDBAN22  INPUT
*&---------------------------------------------------------------------*
MODULE CHECK_PDBAN22 INPUT.

  " 생산수량보다 불량수량이 높은 경우
  CHECK S0100-PDQUAN22 < S0100-PDBAN22.

  " 불량수량이 생산수량보다 크면 안됩니다.
  MESSAGE E069.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_PDBAN23  INPUT
*&---------------------------------------------------------------------*
MODULE CHECK_PDBAN23 INPUT.

  " 생산수량보다 불량수량이 높은 경우
  CHECK S0100-PDQUAN23 < S0100-PDBAN23.

  " 불량수량이 생산수량보다 크면 안됩니다.
  MESSAGE E069.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_PDBAN24  INPUT
*&---------------------------------------------------------------------*
MODULE CHECK_PDBAN24 INPUT.

  " 생산수량보다 불량수량이 높은 경우
  CHECK S0100-PDQUAN24 < S0100-PDBAN24.

  " 불량수량이 생산수량보다 크면 안됩니다.
  MESSAGE E069.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_INPUT  INPUT
*&---------------------------------------------------------------------*
MODULE CHECK_INPUT INPUT.

  " 검수일자가 오늘 보다 전일 경우
  CHECK ZEA_AFRU-TSDAT NE SY-DATUM.

  MESSAGE E079. "DISPLAY LIKE 'E'.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_EMPCODE  INPUT
*&---------------------------------------------------------------------*
MODULE CHECK_EMPCODE INPUT.

  DATA: BEGIN OF LS_DATA.
          INCLUDE STRUCTURE S0100.
DATA  END OF LS_DATA.

  DATA: LV_EMPCODE TYPE ZEA_PA0000-EMPCODE,
        LV_EMPNAME TYPE ZEA_PA0000-EMPNAME,
        LV_DPTCO   TYPE ZEA_PA0000-DPTCO,
        LT_DISPLAY LIKE TABLE OF LS_DATA.

  SELECT SINGLE
    FROM ZEA_PA0000
  FIELDS EMPCODE, EMPNAME, DPTCO
  WHERE EMPCODE EQ @ZEA_PA0000-EMPCODE
    AND DPTCO EQ '0500'
   INTO (@ZEA_PA0000-EMPCODE, @ZEA_PA0000-EMPNAME, @ZEA_PA0000-DPTCO).

  IF SY-SUBRC EQ 0.
    GS_DATA3-EMPCODE = ZEA_PA0000-EMPCODE.
  ELSE.
    MESSAGE E026.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F4HELP  INPUT
*&---------------------------------------------------------------------*
MODULE F4HELP INPUT.

  PERFORM F4HELP.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_MATNR  INPUT
*&---------------------------------------------------------------------*
MODULE CHECK_MATNR INPUT.

*  SELECT SINGLE
*    FROM ZEA_MMT010
*    FIELDS MATNR
*    WHERE MATNR LIKE '30%'
*    INTO @ZEA_MMT010-MATNR.
*
*  IF SY-SUBRC EQ 0.
*
*  ELSEIF ZEA_MMT010-MATNR IS INITIAL.
*    CLEAR ZEA_MMT020-MAKTX.
*    MESSAGE E027.
*  ELSE.
*    MESSAGE E027.
*  ENDIF.


ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F4HELP2  INPUT
*&---------------------------------------------------------------------*
MODULE F4HELP2 INPUT.

  PERFORM F4HELP2.

ENDMODULE.
