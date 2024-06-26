*&---------------------------------------------------------------------*
*& Include          ZMEETROOMO01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.
  SET PF-STATUS 'S0100'.
  SET TITLEBAR 'T0100'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_PROCESS_CONTROL OUTPUT
*&---------------------------------------------------------------------*
MODULE INIT_PROCESS_CONTROL OUTPUT.

*--- Docking Container
  IF GO_CONTAINER IS INITIAL.

    PERFORM CREATE_OBJECT_0100.
    PERFORM SET_ALV_LAYOUT_0100 .
    PERFORM SET_ALV_FIELDCAT_0100.
    PERFORM SET_ALV_EVENT_0100.
    PERFORM DISPLAY_ALV_0100.

  ELSE.

    PERFORM REFRESH_ALV_0100.

  ENDIF.


*--- Screen Container
  IF GO_CONTAINER_2 IS INITIAL.
    PERFORM CREATE_OBJECT2_0100.
    PERFORM SET_ALV_FIELDCAT2_0100.
    PERFORM SET_ALV_LAYOUT2_0100.
    PERFORM SET_ALV_EVENT2_0100.
    PERFORM DISPLAY_ALV2_0100.

  ELSE.

    PERFORM REFRESH_ALV2_0100.

  ENDIF.



ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0200 OUTPUT
*&---------------------------------------------------------------------*
MODULE STATUS_0200 OUTPUT.
 SET PF-STATUS 'S0200'.
 SET TITLEBAR 'T0200'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CLEAR_OK_CODE OUTPUT
*&---------------------------------------------------------------------*
MODULE CLEAR_OK_CODE OUTPUT.
* 화면이 나오기 전 OK_CODE 를 CLEAR 한다.
  CLEAR OK_CODE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module SET_DATA_200 OUTPUT
*&---------------------------------------------------------------------*
MODULE SET_DATA_200 OUTPUT.
*
**  환율 불러와  A/P(USD)를 원화로 환산
*  " 환율 기준일 : 전기일자(IV_BUDAT) 에 해당하는 'USD' 의 환율 값을 전표에 넣어준다
*
*  SELECT SINGLE * FROM ZEA_TCURR INTO ZEA_TCURR
*     WHERE GDATU EQ  SY-DATUM " 환율 기준일(KZ유형 전표-전기일)
*     AND   TCURR EQ  'USD'.   " 통화코드   (USD=IV_WAERS)
*
*
*  " 주말의 경우 환율 값이 없기 때문에 가장 마지막 환율 값을 읽어와야 한다.
*  IF GS_TCURR-GDATU EQ '00000000'.
*
*    SELECT * FROM ZEA_TCURR INTO TABLE GT_TCURR
*      WHERE TCURR = 'USD'
*        AND GDATU <= ZEA_TCURR-GDATU   " HEADER에 입력한 환산일
*        ORDER BY GDATU DESCENDING.
*
*    READ TABLE GT_TCURR INTO GS_TCURR INDEX 1.
*    " [환산금액] 통화금액(KRW) = 현지통화금액 * 환율 / 100 을 해야 .00 이 인식되지 않고 정확한 계산 값이 들어간다.
*    ZEA_BSEG-WRBTR   = ZEA_BSEG-DMBTR * GS_TCURR-UKURS / 100.
*    ZEA_BSEG-W_WAERS = 'KRW'.
**  ENDIF.
*
*  IF GS_DATA2-D_WAERS NE 'KRW'.
*
*
*    OPEN_AMOUNT =  GS_DATA2-WRBTR * 100.
*    OPEN_AMOUNT2 = GS_DATA2-WRBTR * 100.
*
*  ELSE.
*
**      ZEA_TCURR-UKURS " 환율 기준일에 해당하는 USD의 환율을 가지고 있음.
**     환산금액(KRW) = 총 매입금액 / 환율
*    OPEN_AMOUNT2 =  OPEN_AMOUNT / ZEA_TCURR-UKURS.
*  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module FILL_200 OUTPUT
*&---------------------------------------------------------------------*
MODULE FILL_200 OUTPUT.

ZEA_BKPF-BUKRS = 1000. "회사코드
ZEA_BKPF-GJAHR = 2024. "회계연도

*--- Fill Screen 0200. 반제 팝업(다이올로그)
    PERFORM FILL_SCREEN_0200 CHANGING CV_BN.

ENDMODULE.
