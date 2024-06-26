*&---------------------------------------------------------------------*
*& Include          ZEA_GL_DISPLAY_PBO
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.
  SET PF-STATUS 'S0100'.
  SET TITLEBAR 'T0100'. " G/L 계정 전표 입력
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CLEAR_OK_CODE OUTPUT
*&---------------------------------------------------------------------*
MODULE CLEAR_OK_CODE OUTPUT.
  CLEAR OK_CODE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_DATA OUTPUT
*&---------------------------------------------------------------------*
MODULE INIT_DATA OUTPUT.

  " 전표번호는 전표 생성 버튼을 누르기 이전에 존재하면 안된다.
  CHECK ZEA_BKPF-BELNR IS INITIAL.
  PERFORM INIT_DATA.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ALV_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE INIT_ALV_0100 OUTPUT.
  IF GO_CONTAINER IS INITIAL.
    PERFORM CREATE_OBJECT.
    PERFORM ALV_LAYOUT_0100.
    PERFORM ALV_FIELDCAT_0100.
    PERFORM ALV_EVENT_0100.
    PERFORM ALV_DISPLAY_0100.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0200 OUTPUT
*&---------------------------------------------------------------------*
MODULE STATUS_0200 OUTPUT.
  SET PF-STATUS 'T0200'.
  SET TITLEBAR 'S0200'.  " 전표 전기: 헤더 데이터
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_DATA_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE INIT_DATA_0100 OUTPUT.

* -- 200 번 화면에서 입력한 값 => 100번 화면 (BSEG) 로 전달 -----------*
  IF ZEA_BKPF-BUKRS IS NOT INITIAL.
    ZEA_BSEG-BUKRS = ZEA_BKPF-BUKRS. " 회사코드
    ZEA_BSEG-GJAHR = ZEA_BKPF-GJAHR. " 회계연도
    ZEA_BSEG-BSCHL = ZEA_TBSL-BSCHL. " 전기키
    S0100-S_WAERS  = ZEA_BSEG-D_WAERS. " 통화코드
    S0100-H_WAERS  = ZEA_BSEG-D_WAERS. " 통화코드
  ELSE.
    " ZEA_BSEG 에 필요한 데이터를 직접 전달한다.
    ZEA_BSEG-BUKRS = 1000.
    ZEA_BSEG-GJAHR = SY-DATUM+0(4).
    ZEA_BSEG-GJAHR = ZEA_BKPF-GJAHR. " 회계연도 전달
    ZEA_BSEG-BSCHL = ZEA_TBSL-BSCHL. " 전기키
    S0100-S_WAERS  = ZEA_BSEG-D_WAERS. " 통화코드
    S0100-H_WAERS  = ZEA_BSEG-D_WAERS. " 통화코드
  ENDIF.

* -- 환율
* -- ZEA_TCURR-UKURS = 환율 입력 (Disable 입력필드)
  SELECT * FROM ZEA_TCURR INTO TABLE GT_TCURR
    WHERE TCURR EQ ZEA_BSEG-D_WAERS
      AND GDATU <= ZEA_TCURR-GDATU
  ORDER BY GDATU DESCENDING.
  READ TABLE GT_TCURR INTO GS_TCURR INDEX 1.

  ZEA_TCURR-UKURS = GS_TCURR-UKURS.

  IF ZEA_BSEG-D_WAERS EQ 'IDR'.

    SELECT * FROM ZEA_TCURR INTO TABLE GT_TCURR
      WHERE TCURR EQ 'IDR(1'
        AND GDATU <= ZEA_TCURR-GDATU
    ORDER BY GDATU DESCENDING.
    READ TABLE GT_TCURR INTO GS_TCURR INDEX 1.

    ZEA_TCURR-UKURS = GS_TCURR-UKURS.

  ELSEIF ZEA_BSEG-D_WAERS EQ 'JPY'.

    SELECT * FROM ZEA_TCURR INTO TABLE GT_TCURR
      WHERE TCURR EQ 'JPY(1'
        AND GDATU <= ZEA_TCURR-GDATU
    ORDER BY GDATU DESCENDING.
    READ TABLE GT_TCURR INTO GS_TCURR INDEX 1.

    ZEA_TCURR-UKURS = GS_TCURR-UKURS.

  ENDIF.


* -- 엔터 이벤트 => G/L코드가 바뀐다.
  DATA LV_GLTXT TYPE ZEA_BSEG-GLTXT.

  SELECT SINGLE GLTXT
    FROM ZEA_SKB1
    INTO LV_GLTXT
    WHERE SAKNR EQ ZEA_BSEG-SAKNR.

  ZEA_BSEG-GLTXT = LV_GLTXT.

* -- 엔터 이벤트 => 전기키 TXT 가 바뀐다.
  DATA LV_TBSL TYPE ZEA_TBSL-BSTXT.

  SELECT SINGLE BSTXT
    FROM ZEA_TBSL
    INTO LV_TBSL
    WHERE BSCHL EQ ZEA_TBSL-BSCHL.

  ZEA_TBSL-BSTXT = LV_TBSL.

**** -- 엔터 이벤트 => 차대 구분 (서치헬프로 입력 시 구분 불가)
  DATA LV_INDI_CD TYPE ZEA_TBSL-INDI_CD.

  SELECT SINGLE INDI_CD
    FROM ZEA_TBSL
    INTO LV_INDI_CD
    WHERE BSCHL EQ ZEA_TBSL-BSCHL.

  CASE LV_INDI_CD.
    WHEN 'S'.
      ZEA_TBSL-INDI_CD = '차변 입력'.
    WHEN 'H'.
      ZEA_TBSL-INDI_CD = '대변 입력'.
  ENDCASE.


*  -- 글씨 색상변경
  LOOP AT SCREEN.
    IF SCREEN-GROUP2 = 'BLU'.  "해당 파라미터 text 의 스크린네임
      SCREEN-INTENSIFIED = '1'.    "1 값이면 활성화 (파란색)
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.

**  -- 금액 필드 초기화
*  CLEAR: ZEA_BSEG-DMBTR. " 금액필드 초기화
*  CLEAR: ZEA_BSEG-SAKNR. " GL계정
*  CLEAR: ZEA_TBSL-BSCHL. " 전기키 초기화
*  CLEAR: ZEA_BSEG-GLTXT. " GLTXT 초기화
*  ZEA_BSEG-BPCODE = ZEA_BSEG-BPCODE.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_DATA_0250 OUTPUT
*&---------------------------------------------------------------------*
MODULE INIT_DATA_0250 OUTPUT.

  CLEAR : GT_WWWTAB.
  SELECT SINGLE *
    INTO GT_WWWTAB
    FROM WWWPARAMS
   WHERE RELID  =  'MI'
     AND OBJID  =  'ZEA_FI030_3'.

  CALL FUNCTION 'DP_PUBLISH_WWW_URL'
    EXPORTING
      OBJID    = GT_WWWTAB-OBJID
      LIFETIME = 'T'
    IMPORTING
      URL      = URL
    EXCEPTIONS
      OTHERS   = 1.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ALV_0250 OUTPUT
*&---------------------------------------------------------------------*
MODULE INIT_ALV_0250 OUTPUT.
  CREATE OBJECT CONTAINER1
    EXPORTING
      CONTAINER_NAME = 'LOGO'.


  CREATE OBJECT PIC1
    EXPORTING
      PARENT = CONTAINER1.

  CALL METHOD PIC1->SET_DISPLAY_MODE
    EXPORTING
      DISPLAY_MODE = CL_GUI_PICTURE=>DISPLAY_MODE_NORMAL.





* 컨테이너 영역크기에 맞춰 보여주기
*  CALL METHOD pic1->set_display_mode
*    EXPORTING
*      display_mode = cl_gui_picture=>display_mode_stretch.





  CALL FUNCTION 'DP_PUBLISH_WWW_URL'
    EXPORTING
      OBJID    = GT_WWWTAB-OBJID
      LIFETIME = 'T'
    IMPORTING
      URL      = URL
    EXCEPTIONS
      OTHERS   = 1.


  IF SY-SUBRC = 0.
    CALL METHOD PIC1->LOAD_PICTURE_FROM_URL_ASYNC
      EXPORTING
        URL = URL.
  ENDIF.




ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CHECK_SAKNR OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE CHECK_SAKNR OUTPUT.
*ZEA_BSEG-SAKNR " GL코드

  IF ZEA_TBSL-BSCHL BETWEEN '01' AND '39'.
    " BP코드를 입력하면 입력한 BP코드와
    SELECT SINGLE * FROM ZEA_SKB1
      INTO GS_SKB1
      WHERE BPCODE EQ ZEA_BSEG-SAKNR
        AND RECON_YN EQ 'X'.

    IF GS_SKB1-BPCODE IS NOT INITIAL.
      ZEA_BSEG-SAKNR = GS_SKB1-SAKNR.
      ZEA_BSEG-GLTXT = GS_SKB1-GLTXT.
      ZEA_BSEG-BPCODE = GS_SKB1-BPCODE.
    ENDIF.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ALV_0300 OUTPUT
*&---------------------------------------------------------------------*
MODULE INIT_ALV_0300 OUTPUT.

  REFRESH GT_SKA1[].

  SELECT * FROM ZEA_SKA1 INTO TABLE GT_SKA1
    WHERE BPROLE EQ 'V'
      OR BPROLE EQ 'C'
    ORDER BY BPCODE.

  IF GO_ALV_GRID300 IS INITIAL.
    PERFORM CREATE_OBJECT_300.
    PERFORM SET_ALV_LAYOUT_300 .
    PERFORM DISPLAY_300.
  ENDIF.

ENDMODULE.
