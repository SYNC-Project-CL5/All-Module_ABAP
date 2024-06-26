*&---------------------------------------------------------------------*
*& Include          ZEA_FI050_TUCRR_PBO
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.
  SET PF-STATUS 'S0100'.
  SET TITLEBAR 'T0100'. " [FI] 환율 레포트
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE INIT_ALV_0100 OUTPUT.

  IF CCON1 IS INITIAL AND CCON2 IS INITIAL.
    PERFORM CREATE_OBJECT_O100.
    PERFORM SET_ALV_LAYOUT_0100.
    PERFORM SET_ALV_FIELDCAT_0100.
    PERFORM SET_ALV_EVENT_0100.
    PERFORM DISPLAY_ALV_0100.
  ENDIF.


*&-- INIT_DATA --------------------------------------------------------*
  " PARMETER 값 전달
  ZEA_TCURR-TCURR = PA_TCURR.

*&-- 그래프 구현  -----------------------------------------------------*

  DATA:
    LV_COUNTER    TYPE STRING,
    LV_FIELD_NAME TYPE FIELDNAME,
    LV_LAST_INDEX TYPE I.
  LV_COUNTER = 1. " 초기값 설정

  LOOP AT GT_TCURR ASSIGNING FIELD-SYMBOL(<FS_TCURR>).
*    CLEAR GRVALWA1. " --> 알 수 있는 점 : 가장 마지막 줄의 정보가 그래프에 나온다. 따라서 CLEAR하지 않는다.

    GRVALWA1-ROWTXT = <FS_TCURR>-TCURR. " 변경통화
    GRVALWA2-ROWTXT = 'AVG'.            " 평균환율

    " -- 아래에서는 'GRVALWA1-VAL+숫자'를 생성한다.
    CONCATENATE 'GRVALWA1-VAL' LV_COUNTER INTO LV_FIELD_NAME. " 필드 이름 생성
    ASSIGN (LV_FIELD_NAME) TO FIELD-SYMBOL(<FS_FIELD>). " 필드 기호로 접근

    IF SY-SUBRC = 0.
      <FS_FIELD> = <FS_TCURR>-UKURS.   " 필드 기호를 통한 환율 값 할당
    ENDIF.

    " -- 아래에서는 'GRVALWA1-VAL+숫자'를 생성한다.
    CONCATENATE 'GRVALWA2-VAL' LV_COUNTER INTO LV_FIELD_NAME. " 필드 이름 생성
    ASSIGN (LV_FIELD_NAME) TO FIELD-SYMBOL(<FS_FIELD2>). " 필드 기호로 접근

    IF SY-SUBRC = 0.
      <FS_FIELD2> = <FS_TCURR>-AVERAGE. " 필드 기호를 통한 평균환율 값 할당
    ENDIF.

    APPEND GRVALWA1 TO GRVAL1.
    APPEND GRVALWA2 TO GRVAL1.
    APPEND <FS_TCURR>-GDATU TO COL1_TEXTS.   " 효력 시작일을 COLUMN_TEXTS에 추가
    LV_COUNTER = LV_COUNTER + 1. " 카운터 값 증가
  ENDLOOP.


*Function module to display graph (ALV Cont 1)
  CALL FUNCTION 'GFW_PRES_SHOW_MULT'
    EXPORTING
      WIDTH             = 100
      PARENT            = CCON2
      PRESENTATION_TYPE = GFW_PRESTYPE_LINES
      SHOW              = GFW_TRUE
      X_AXIS_TITLE      = '한국수출입은행 고시환율'                " See GFW_PRES_SHOW
    TABLES
      VALUES            = GRVAL1
      COLUMN_TEXTS      = COL1_TEXTS
    EXCEPTIONS
      ERROR_OCCURRED    = 1.


** [ PRESENTATION_TYPE ]
**꺾은선형 차트 - gfw_prestype_lines
**면적 차트 -  gfw_prestype_area
**수평 막대 차트 - gfw_prestype_horizontal_bars
**수직 막대 차트 - gfw_prestype_vertical_bars
**원형 차트 - gfw_prestype_pie_chart
**시간축 차트. - gfw_prestype_time_axis


ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0150 OUTPUT
*&---------------------------------------------------------------------*
MODULE STATUS_0150 OUTPUT.
  SET PF-STATUS 'S0150'.
  SET TITLEBAR 'T0150'. " 환율 계산
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CLEAR_OK_CODE OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE CLEAR_OK_CODE OUTPUT.
  CLEAR OK_CODE.
ENDMODULE.
