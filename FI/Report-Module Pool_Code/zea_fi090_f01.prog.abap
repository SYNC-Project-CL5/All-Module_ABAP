*&---------------------------------------------------------------------*
*& Include          YE08_EX001_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form SELECT_DATA
*& ---------------------------------------------------------------------*
*& Lv1. 대분류	구분
*& 4  매출
*& 5  매출원가
*& 6  판매비/관리비/재료비 > 판관비
*& 7  영업외수익/비용
*&---------------------------------------------------------------------*
FORM SELECT_DATA .


*  " 매출 : 4로 시작
  R_SAKNR_4-SIGN   = 'I'.
  R_SAKNR_4-OPTION = 'CP'.
  R_SAKNR_4-LOW = '4*'.
  APPEND R_SAKNR_4.

  " 매출원가: 5로 시작
  R_SAKNR_5-SIGN   = 'I'.
  R_SAKNR_5-OPTION = 'CP'.
  R_SAKNR_5-LOW = '5*'.
  APPEND R_SAKNR_5.

  " 판관비 : 6로 시작
  R_SAKNR_6-SIGN   = 'I'.
  R_SAKNR_6-OPTION = 'CP'.
  R_SAKNR_6-LOW = '6*'.
  APPEND R_SAKNR_6.

  " 영업외수익 : 71로 시작, 73으로 시작, 75로 시작
  R_SAKNR_7P-SIGN   = 'I'.
  R_SAKNR_7P-OPTION = 'CP'.
  R_SAKNR_7P-LOW = '71*'.
  R_SAKNR_7P-HIGH = '73*'.
  APPEND R_SAKNR_7P.

  " 영업외비용 : 72, 74, 79로 시작
  R_SAKNR_7L-SIGN   = 'I'.
  R_SAKNR_7L-OPTION = 'CP'.
  R_SAKNR_7L-LOW = '74*'.
  R_SAKNR_7L-HIGH = '79*'.
  APPEND R_SAKNR_7L.

  " 1분기
  R_1-SIGN = 'I'.
  R_1-OPTION = 'BT'. " Between (범위 내)
  R_1-LOW = '20240101'. " 시작 날짜
  R_1-HIGH = '20240331'. " 끝 날짜
  APPEND R_1.

  " 2분기
  R_2-SIGN = 'I'.
  R_2-OPTION = 'BT'.
  R_2-LOW = '20240401'.
  R_2-HIGH = '20240630'.
  APPEND R_2.

  " Internal Table의 내용을 전부 비워둠
  REFRESH GT_DATA[].

* --손익계정 ( ALL)
  SELECT
    A~BUDAT
    B~GJAHR   " 회계연도
    B~SAKNR   " G/L계정 (Recon)
    C~GLTXT   " G/L계정명
    B~BPCODE  " BP코드 "
    SUM( B~DMBTR ) AS DMBTR "  통화금액 합계
  INTO CORRESPONDING FIELDS OF TABLE GT_DATA
  FROM ZEA_BKPF AS A        " A: 전표 헤더
 INNER JOIN ZEA_BSEG AS B   " B: 전표 아이템
    ON A~BUKRS EQ B~BUKRS
   AND A~BELNR EQ B~BELNR
   AND A~GJAHR EQ B~GJAHR
 INNER JOIN ZEA_SKB1 AS C   " C: G/L계정마스터
    ON C~BUKRS EQ A~BUKRS
   AND C~SAKNR EQ B~SAKNR
   AND C~GLTXT EQ C~GLTXT
   AND C~XBILK NE 'X'       " G/L코드 Type - 'X': 대차대조 / '' : 손익계산
    GROUP BY A~BUDAT B~GJAHR B~SAKNR C~GLTXT B~BPCODE
    ORDER BY B~BPCODE ASCENDING.


* --손익계정 - 1분기 "----------------

*  SELECT
*    B~GJAHR   " 회계연도
*    B~SAKNR   " G/L계정 (Recon)
*    C~GLTXT   " G/L계정명
*    B~BPCODE  " BP코드 " <==== 추가함
*    SUM( B~DMBTR ) AS DMBTR "  통화금액 합계
*  INTO CORRESPONDING FIELDS OF TABLE GT_DATA1
*  FROM ZEA_BKPF AS A        " A: 전표 헤더
* INNER JOIN ZEA_BSEG AS B   " B: 전표 아이템
*    ON A~BUKRS EQ B~BUKRS
*   AND A~BELNR EQ B~BELNR
*   AND A~GJAHR EQ B~GJAHR
* INNER JOIN ZEA_SKB1 AS C   " C: G/L계정마스터
*    ON C~BUKRS EQ A~BUKRS
*   AND C~SAKNR EQ B~SAKNR
*   AND C~GLTXT EQ B~GLTXT
*   AND C~XBILK NE 'X'       " G/L코드 Type - 'X': 대차대조 / '' : 손익계산
*    WHERE A~BUDAT IN R_1
*    GROUP BY B~GJAHR B~SAKNR C~GLTXT B~BPCODE
*    ORDER BY B~BPCODE ASCENDING.

* -- 손익계정 - 2분기 " ----------------
*  SELECT
*    B~GJAHR   " 회계연도
*    B~SAKNR   " G/L계정 (Recon)
*    C~GLTXT   " G/L계정명
*    B~BPCODE  " BP코드 " <==== 추가함
*    SUM( B~DMBTR ) AS DMBTR "  통화금액 합계
*  INTO CORRESPONDING FIELDS OF TABLE GT_DATA2
*  FROM ZEA_BKPF AS A        " A: 전표 헤더
* INNER JOIN ZEA_BSEG AS B   " B: 전표 아이템
*    ON A~BUKRS EQ B~BUKRS
*   AND A~BELNR EQ B~BELNR
*   AND A~GJAHR EQ B~GJAHR
* INNER JOIN ZEA_SKB1 AS C   " C: G/L계정마스터
*    ON C~BUKRS EQ A~BUKRS
*   AND C~SAKNR EQ B~SAKNR
*   AND C~GLTXT EQ B~GLTXT
*   AND C~XBILK NE 'X'       " G/L코드 Type - 'X': 대차대조 / '' : 손익계산
*    WHERE A~BUDAT IN R_2
*    GROUP BY B~GJAHR B~SAKNR C~GLTXT B~BPCODE
*    ORDER BY B~BPCODE ASCENDING.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form MOVE_DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM MOVE_DISPLAY_DATA .

  " LS_SUM 은 매출총이익/ 영업이익/ 당기순이익을 계산하기 위함
  DATA: LS_SUM LIKE GS_DISPLAY.

  " LS_SUM을 계산하기 위해 각 계정의 SUM값을 보관하는 변수
  DATA: DMBTR_1A TYPE ZEA_BSEG-DMBTR.
  DATA: DMBTR_2A TYPE ZEA_BSEG-DMBTR.
  DATA: DMBTR_3A TYPE ZEA_BSEG-DMBTR.
  DATA: DMBTR_4A TYPE ZEA_BSEG-DMBTR.
  DATA: DMBTR_5A TYPE ZEA_BSEG-DMBTR.
  DATA: DMBTR_6A TYPE ZEA_BSEG-DMBTR.
  DATA: DMBTR_7A TYPE ZEA_BSEG-DMBTR.
  DATA: DMBTR_1B TYPE ZEA_BSEG-DMBTR.
  DATA: DMBTR_2B TYPE ZEA_BSEG-DMBTR.
  DATA: DMBTR_3B TYPE ZEA_BSEG-DMBTR.
  DATA: DMBTR_4B TYPE ZEA_BSEG-DMBTR.
  DATA: DMBTR_5B TYPE ZEA_BSEG-DMBTR.
  DATA: DMBTR_6B TYPE ZEA_BSEG-DMBTR.
  DATA: DMBTR_7B TYPE ZEA_BSEG-DMBTR.

  " 보여줄 itab의 순서를 지정하기 위해 임시공간 internal table
  DATA LT_DISPLAY LIKE GT_DISPLAY.
  DATA LS_DISPLAY LIKE LINE OF GT_DISPLAY.

  DATA: BEGIN OF LS_DISPLAY2.
  DATA:
    COLOR      TYPE C LENGTH 4,
    GLTXT      TYPE ZEA_SKB1-GLTXT, " 계정명
    BPCODE     TYPE ZEA_BSEG-BPCODE, " 계정명
    DMBTR_B    TYPE ZEA_BSEG-DMBTR, " 금액합계(2024-2분기)
    DMBTR_C    TYPE ZEA_BSEG-DMBTR, " 금액합계(2024-3분기)
    DMBTR_D    TYPE ZEA_BSEG-DMBTR, " 금액합계(2024-4분기)
    DMBTR_YEAR TYPE ZEA_BSEG-DMBTR, " 금액합계(2024-당기실적)
    DMBTR_PER  TYPE ZEA_BSEG-DMBTR, " 금액합계(2024-합계)
    END OF LS_DISPLAY2,
    LT_DISPLAY2 LIKE TABLE OF LS_DISPLAY2.

  REFRESH: GT_DISPLAY.

* -- 1. 매출 ----------------------------------------------------------*
  REFRESH LT_DISPLAY.
  CLEAR: LS_SUM, GS_DATA.
  LS_SUM-GLTXT = 'I. 매출액'.

  " 매출 계정 (4*)
  LOOP AT GT_DATA INTO GS_DATA WHERE SAKNR IN R_SAKNR_4.
    CLEAR GS_DISPLAY.
    MOVE-CORRESPONDING GS_DATA TO GS_DISPLAY. " 계정명/BP코드 옮겨짐.

    IF GS_DATA-BUDAT IN R_1. " 1분기
      GS_DISPLAY-DMBTR_A = GS_DATA-DMBTR.  " 통화금액
      LS_SUM-DMBTR_A = LS_SUM-DMBTR_A + GS_DATA-DMBTR. " 계정별 누적합

    ELSEIF GS_DATA-BUDAT IN R_2. " 2분기
      GS_DISPLAY-DMBTR_B = GS_DISPLAY-DMBTR_B + GS_DATA-DMBTR.  " 통화금액
      LS_SUM-DMBTR_B = LS_SUM-DMBTR_B + GS_DATA-DMBTR. " 계정별 누적합
    ENDIF.

    COLLECT GS_DISPLAY INTO LT_DISPLAY.
  ENDLOOP.

  DMBTR_1A = LS_SUM-DMBTR_A.
  DMBTR_1B = LS_SUM-DMBTR_B.
  LS_SUM-DMBTR_YEAR = LS_SUM-DMBTR_A + LS_SUM-DMBTR_B.
  APPEND LS_SUM TO GT_DISPLAY.              " 순서1. 계정별 누적합 금액
  APPEND LINES OF LT_DISPLAY TO GT_DISPLAY. " 순서2. 계정별 합계   금액


* -- 2. 매출원가 ------------------------------------------------------*
  REFRESH: GT_DATA1, GT_DATA2, LT_DISPLAY.
  CLEAR: LS_SUM, GS_DATA1, GS_DATA2.
*  REFRESH: LT_DISPLAY.
*  CLEAR: LS_SUM.

  LS_SUM-GLTXT = 'II. 매출원가'.

  " 매출원가 계정 (5*)
  LOOP AT GT_DATA INTO GS_DATA WHERE SAKNR IN R_SAKNR_5.
    CLEAR GS_DISPLAY.
    MOVE-CORRESPONDING GS_DATA TO GS_DISPLAY. " 계정명/BP코드 옮겨짐.

    IF GS_DATA-BUDAT IN R_1. " 1분기
      GS_DISPLAY-DMBTR_A = GS_DATA-DMBTR.  " 통화금액
      LS_SUM-DMBTR_A = LS_SUM-DMBTR_A + GS_DATA-DMBTR. " 계정별 누적합

    ELSEIF GS_DATA-BUDAT IN R_2. " 2분기
      GS_DISPLAY-DMBTR_B = GS_DISPLAY-DMBTR_B + GS_DATA-DMBTR.  " 통화금액
      LS_SUM-DMBTR_B = LS_SUM-DMBTR_B + GS_DATA-DMBTR. " 계정별 누적합
    ENDIF.

    COLLECT GS_DISPLAY INTO LT_DISPLAY.
  ENDLOOP.

  DMBTR_2A = LS_SUM-DMBTR_A.
  DMBTR_2B = LS_SUM-DMBTR_B.
  LS_SUM-DMBTR_YEAR = LS_SUM-DMBTR_A + LS_SUM-DMBTR_B.
  APPEND LS_SUM TO GT_DISPLAY.              " 순서1. 계정별 누적합 금액
  APPEND LINES OF LT_DISPLAY TO GT_DISPLAY. " 순서2. 계정별 합계   금액



* -- 3. 매출총이익 = 매출 - 매출원가 ----------------------------------*
  CLEAR: LS_SUM.
  LS_SUM-GLTXT = 'III. 매출총이익'.
  LS_SUM-DMBTR_A = DMBTR_1A - DMBTR_2A.
  LS_SUM-DMBTR_B = DMBTR_1B - DMBTR_2B.
  LS_SUM-DMBTR_YEAR = LS_SUM-DMBTR_A + LS_SUM-DMBTR_B.
  IF ( DMBTR_1A + DMBTR_1B ) NE 0.
    LS_SUM-DMBTR_PER = ( LS_SUM-DMBTR_YEAR / ( DMBTR_1A + DMBTR_1B ) ) * 100.
  ELSE.
  ENDIF.
  DMBTR_3A = LS_SUM-DMBTR_A.
  DMBTR_3B = LS_SUM-DMBTR_B.
  APPEND LS_SUM TO GT_DISPLAY.


* -- 4. 판관비 --------------------------------------------------------*
  REFRESH LT_DISPLAY.
  CLEAR: LS_SUM, GS_DATA.
  LS_SUM-GLTXT = 'IV. 판매비와관리비'.


  " 판관비 계정 (6*)
  LOOP AT GT_DATA INTO GS_DATA WHERE SAKNR IN R_SAKNR_6.
    CLEAR GS_DISPLAY.
    MOVE-CORRESPONDING GS_DATA TO GS_DISPLAY. " 계정명/BP코드 옮겨짐.

    IF GS_DATA-BUDAT IN R_1. " 1분기
      GS_DISPLAY-DMBTR_A = GS_DATA-DMBTR.  " 통화금액
      LS_SUM-DMBTR_A = LS_SUM-DMBTR_A + GS_DATA-DMBTR. " 계정별 누적합

    ELSEIF GS_DATA-BUDAT IN R_2. " 2분기
      GS_DISPLAY-DMBTR_B = GS_DISPLAY-DMBTR_B + GS_DATA-DMBTR.  " 통화금액
      LS_SUM-DMBTR_B = LS_SUM-DMBTR_B + GS_DATA-DMBTR. " 계정별 누적합
    ENDIF.

    COLLECT GS_DISPLAY INTO LT_DISPLAY.
  ENDLOOP.

  DMBTR_4A = LS_SUM-DMBTR_A.
  DMBTR_4B = LS_SUM-DMBTR_B.
  LS_SUM-DMBTR_YEAR = LS_SUM-DMBTR_A + LS_SUM-DMBTR_B.
  APPEND LS_SUM TO GT_DISPLAY.              " 순서1. 계정별 누적합 금액
  APPEND LINES OF LT_DISPLAY TO GT_DISPLAY. " 순서2. 계정별 합계   금액



* -- 5. 영업이익 = 매출총이익 - 판관비 --------------------------------*
  CLEAR: LS_SUM.
  LS_SUM-GLTXT = 'V. 영업이익'.
  LS_SUM-DMBTR_A = DMBTR_3A - DMBTR_4A.
  LS_SUM-DMBTR_B = DMBTR_3B - DMBTR_4B.
  LS_SUM-DMBTR_YEAR = LS_SUM-DMBTR_A + LS_SUM-DMBTR_B.
  IF ( DMBTR_1A + DMBTR_1B ) NE 0.
    LS_SUM-DMBTR_PER = ( LS_SUM-DMBTR_YEAR / ( DMBTR_1A + DMBTR_1B ) ) * 100.
  ELSE.
  ENDIF.
*  LS_SUM-DMBTR_PER = ( LS_SUM-DMBTR_YEAR / ( DMBTR_1A + DMBTR_1B ) ) * 100.
  DMBTR_5A = LS_SUM-DMBTR_A.
  DMBTR_5B = LS_SUM-DMBTR_B.
  APPEND LS_SUM TO GT_DISPLAY.


** -- 6. 영업외이익 ---------------------------------------------------*

  REFRESH LT_DISPLAY.
  CLEAR: LS_SUM, GS_DATA.
  LS_SUM-GLTXT = 'VI. 영업외이익'.

  " 영업외이익 계정 (7*)
  LOOP AT GT_DATA INTO GS_DATA WHERE SAKNR IN R_SAKNR_7P.
    CLEAR GS_DISPLAY.
    MOVE-CORRESPONDING GS_DATA TO GS_DISPLAY. " 계정명/BP코드 옮겨짐.

    IF GS_DATA-BUDAT IN R_1. " 1분기
      GS_DISPLAY-DMBTR_A = GS_DATA-DMBTR.  " 통화금액
      LS_SUM-DMBTR_A = LS_SUM-DMBTR_A + GS_DATA-DMBTR. " 계정별 누적합

    ELSEIF GS_DATA-BUDAT IN R_2. " 2분기
      GS_DISPLAY-DMBTR_B = GS_DISPLAY-DMBTR_B + GS_DATA-DMBTR.  " 통화금액
      LS_SUM-DMBTR_B = LS_SUM-DMBTR_B + GS_DATA-DMBTR. " 계정별 누적합
    ENDIF.

    COLLECT GS_DISPLAY INTO LT_DISPLAY.
  ENDLOOP.


  DMBTR_6A = LS_SUM-DMBTR_A.
  DMBTR_6B = LS_SUM-DMBTR_B.
  LS_SUM-DMBTR_YEAR = LS_SUM-DMBTR_A + LS_SUM-DMBTR_B.
  APPEND LS_SUM TO GT_DISPLAY.              " 순서1. 계정별 누적합 금액
  APPEND LINES OF LT_DISPLAY TO GT_DISPLAY. " 순서2. 계정별 합계   금액


*
** -- 7. 영업외손실 ---------------------------------------------------*
  REFRESH LT_DISPLAY.
  CLEAR: LS_SUM, GS_DATA.
  LS_SUM-GLTXT = 'VII. 영업외비용'.

  " 영업외손실 계정 (7*)
  LOOP AT GT_DATA INTO GS_DATA WHERE SAKNR IN R_SAKNR_7L.
    CLEAR GS_DISPLAY.
    MOVE-CORRESPONDING GS_DATA TO GS_DISPLAY. " 계정명/BP코드 옮겨짐.

    IF GS_DATA-BUDAT IN R_1. " 1분기
      GS_DISPLAY-DMBTR_A = GS_DATA-DMBTR.  " 통화금액
      LS_SUM-DMBTR_A = LS_SUM-DMBTR_A + GS_DATA-DMBTR. " 계정별 누적합

    ELSEIF GS_DATA-BUDAT IN R_2. " 2분기
      GS_DISPLAY-DMBTR_B = GS_DISPLAY-DMBTR_B + GS_DATA-DMBTR.  " 통화금액
      LS_SUM-DMBTR_B = LS_SUM-DMBTR_B + GS_DATA-DMBTR. " 계정별 누적합
    ENDIF.

    COLLECT GS_DISPLAY INTO LT_DISPLAY.
  ENDLOOP.

  DMBTR_7A = LS_SUM-DMBTR_A.
  DMBTR_7B = LS_SUM-DMBTR_B.
  LS_SUM-DMBTR_YEAR = LS_SUM-DMBTR_A + LS_SUM-DMBTR_B.
  APPEND LS_SUM TO GT_DISPLAY.              " 순서1. 계정별 누적합 금액
  APPEND LINES OF LT_DISPLAY TO GT_DISPLAY. " 순서2. 계정별 합계   금액

*
**  -- 8. 당기순이익 = 영업이익 + 영업외이익 - 영업외비용 -------------*
  CLEAR: LS_SUM.
  LS_SUM-GLTXT = 'VIII. 당기순이익'.
  LS_SUM-DMBTR_A = DMBTR_5A + DMBTR_6A - DMBTR_7A.
  LS_SUM-DMBTR_B = DMBTR_5B + DMBTR_6B - DMBTR_7B.
  LS_SUM-DMBTR_YEAR = LS_SUM-DMBTR_A + LS_SUM-DMBTR_B.
  IF ( DMBTR_1A + DMBTR_1B ) NE 0.
    LS_SUM-DMBTR_PER = ( LS_SUM-DMBTR_YEAR / ( DMBTR_1A + DMBTR_1B ) ) * 100.
  ELSE.
    MESSAGE '손익 계정의 전표를 확인해주세요.' TYPE 'S'.
  ENDIF.
*  LS_SUM-DMBTR_PER = ( LS_SUM-DMBTR_YEAR / ( DMBTR_1A + DMBTR_1B ) ) * 100.
  APPEND LS_SUM TO GT_DISPLAY.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM DISPLAY_DATA .

  " []는 인터널 테이블에 담겨있는 내용을 의미, 즉 쌓여있는 데이터
  IF GT_DISPLAY[] IS INITIAL. " => 한 줄도 없는지 검사
    MESSAGE '검색된 결과가 없습니다.' TYPE 'S' DISPLAY LIKE 'W'.
  ELSE.
    CALL SCREEN 0100.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_O100
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT_O100 .
*  CREATE OBJECT GO_CONTAINER
*    EXPORTING
*      CONTAINER_NAME = 'CCON'
*    EXCEPTIONS
*      OTHERS         = 1.
*  IF SY-SUBRC <> 0.
*
*  ENDIF.
*
*  CREATE OBJECT GO_ALV_GRID
*    EXPORTING
*      I_PARENT = GO_CONTAINER
*    EXCEPTIONS
*      OTHERS   = 1.
*  IF SY-SUBRC <> 0.
*  ENDIF.
  CREATE OBJECT GO_CONTAINER
    EXPORTING
      REPID = SY-REPID
      DYNNR = SY-DYNNR
      SIDE  = GO_CONTAINER->DOCK_AT_BOTTOM
      EXTENSION = 5000
      RATIO = 85.

  CREATE OBJECT GO_ALV_GRID
    EXPORTING
      I_PARENT      = GO_CONTAINER
      I_APPL_EVENTS = 'X'. " Register Events as Application Events

*-- Create TOP-Document
  CREATE OBJECT GO_DYNDOC_ID
    EXPORTING
      STYLE = 'ALV_GRID'.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_LAYOUT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_LAYOUT_0100 .
  CLEAR GS_LAYOUT.

  GS_LAYOUT-ZEBRA = ABAP_ON.
  GS_LAYOUT-SEL_MODE = 'D'.
*  GS_LAYOUT-CWIDTH_OPT = ABAP_ON.

  GS_LAYOUT-INFO_FNAME = 'COLOR'. " 행 색상

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_FIELDCAT_0100 .

  REFRESH GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'GLTXT'.
  GS_FIELDCAT-COLTEXT   = '계정명'.
  GS_FIELDCAT-REF_FIELD = 'GLTXT'.
  GS_FIELDCAT-REF_TABLE ='ZEA_SKB1'.
  GS_FIELDCAT-KEY       = 'X'.
  GS_FIELDCAT-OUTPUTLEN = 15.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'BPCODE'.
  GS_FIELDCAT-COLTEXT   = '거래처'.
  GS_FIELDCAT-REF_FIELD = 'BPCODE'.
  GS_FIELDCAT-REF_TABLE ='ZEA_BSEG'.
  GS_FIELDCAT-KEY       = 'X'.
  GS_FIELDCAT-OUTPUTLEN = 5.
  GS_FIELDCAT-HOTSPOT   = 'X'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'DMBTR_A'.
  GS_FIELDCAT-COLTEXT   = '1/4분기'.
  GS_FIELDCAT-REF_FIELD = 'ZEA_BSEG'.
  GS_FIELDCAT-REF_TABLE ='DMBTR'.
  GS_FIELDCAT-CFIELDNAME = 'DMBTR_A'.
  GS_FIELDCAT-CURRENCY  = 'KRW'.
  GS_FIELDCAT-OUTPUTLEN = 13.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'DMBTR_B'.
  GS_FIELDCAT-COLTEXT   = '2/4분기'.
  GS_FIELDCAT-REF_FIELD = 'ZEA_BSEG'.
  GS_FIELDCAT-REF_TABLE ='DMBTR'.
  GS_FIELDCAT-CFIELDNAME = 'DMBTR_B'.
  GS_FIELDCAT-CURRENCY  = 'KRW'.
  GS_FIELDCAT-OUTPUTLEN = 13.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.


  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'DMBTR_C'.
  GS_FIELDCAT-COLTEXT   = '3/4분기'.
  GS_FIELDCAT-REF_FIELD = 'ZEA_BSEG'.
  GS_FIELDCAT-REF_TABLE ='DMBTR'.
  GS_FIELDCAT-CFIELDNAME = 'DMBTR_C'.
  GS_FIELDCAT-CURRENCY  = 'KRW'.
  GS_FIELDCAT-OUTPUTLEN = 10.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.


  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'DMBTR_D'.
  GS_FIELDCAT-COLTEXT   = '4/4분기'.
  GS_FIELDCAT-REF_FIELD = 'ZEA_BSEG'.
  GS_FIELDCAT-REF_TABLE ='DMBTR'.
  GS_FIELDCAT-CFIELDNAME = 'DMBTR_D'.
  GS_FIELDCAT-CURRENCY  = 'KRW'.
  GS_FIELDCAT-OUTPUTLEN = 10.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'DMBTR_YEAR'.
  GS_FIELDCAT-COLTEXT   = '당기실적'.
  GS_FIELDCAT-REF_FIELD = 'ZEA_BSEG'.
  GS_FIELDCAT-REF_TABLE ='DMBTR'.
  GS_FIELDCAT-CFIELDNAME = 'DMBTR_YEAR'.
  GS_FIELDCAT-CURRENCY  = 'KRW'.
  GS_FIELDCAT-OUTPUTLEN = 13.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'DMBTR_PER'.
  GS_FIELDCAT-COLTEXT   = '이익률(%)'.
  GS_FIELDCAT-TOOLTIP   = '매출액 대비 이익률(%)'.
*  GS_FIELDCAT-REF_FIELD = 'ZEA_BSEG'.
*  GS_FIELDCAT-REF_TABLE ='DMBTR'.
*  GS_FIELDCAT-CFIELDNAME = 'DMBTR_YEAR'.
*  GS_FIELDCAT-CURRENCY  = 'KRW'.
  GS_FIELDCAT-OUTPUTLEN = 10.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.




ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_EVENT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_EVENT_0100 .
  SET HANDLER LCL_EVENT_HANDLER=>ON_HOTSPOT_CLICK FOR GO_ALV_GRID.
  SET HANDLER LCL_EVENT_HANDLER=>ON_DOUBLE_CLICK  FOR GO_ALV_GRID.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_0100
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV_0100 .

  DATA: LV_SAKNR TYPE ZEA_BSEG-SAKNR.

  CLEAR GS_VARIANT.
  GS_VARIANT-REPORT = SY-REPID.
  GV_SAVE = 'A'.

  CALL METHOD GO_ALV_GRID->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
      IS_VARIANT      = GS_VARIANT                 " Layout
      I_SAVE          = GV_SAVE                 " Save Layout
      IS_LAYOUT       = GS_LAYOUT                 " Layout
    CHANGING
      IT_OUTTAB       = GT_DISPLAY                " Output Table
      IT_FIELDCATALOG = GT_FIELDCAT                 " Field Catalog
    EXCEPTIONS
      OTHERS          = 1.
  IF SY-SUBRC <> 0.

  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_DISPLAY_DATA
*&---------------------------------------------------------------------*

FORM MAKE_DISPLAY_DATA .

  DATA LS_STYLE TYPE LVC_S_STYL.

*  REFRESH GT_DISPLAY.
*I. 매출액
*II. 매출원가
*III. 매출총이익
*IV. 판매비와관리비
*V. 영업이익
*VI. 영업외이익
*VII. 영업외비용
*VIII. 당기순이익

  LOOP AT GT_DISPLAY INTO GS_DISPLAY.
    CASE GS_DISPLAY-GLTXT.
      WHEN 'I. 매출액' OR 'II. 매출원가' OR 'IV. 판매비와관리비' OR 'VI. 영업외이익' OR 'VII. 영업외비용'. " 노란색
        GS_DISPLAY-COLOR = 'C300'.

      WHEN 'III. 매출총이익' OR 'V. 영업이익' OR 'VIII. 당기순이익'. " 빨간색
        GS_DISPLAY-COLOR = 'C600'.
    ENDCASE.

    MODIFY GT_DISPLAY FROM GS_DISPLAY.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form handle_hotspot_click
*&---------------------------------------------------------------------*
FORM HANDLE_HOTSPOT_CLICK  USING PS_ROW TYPE LVC_S_ROW
                                 PS_COL TYPE  LVC_S_COL
                                 PO_SENDER TYPE REF TO CL_GUI_ALV_GRID.

* 선택한 행이 인터널테이블에 있는 정상적인 데이터인지 체크
  CHECK PS_ROW-ROWTYPE IS INITIAL.


  DATA: GT_DATA1 LIKE TABLE OF GS_DATA,
        GT_DATA2 LIKE TABLE OF GS_DATA,
        GT_DATA3 LIKE TABLE OF GS_DATA,
        GT_DATA4 LIKE TABLE OF GS_DATA.

* itab 에서 클릭한 행의 데이터를 가져옴
  READ TABLE GT_DISPLAY INTO GS_DISPLAY INDEX PS_ROW-INDEX.

* 클릭한 행의 데이터를 사용
  IF SY-SUBRC = 0.
*   MESSAGE I000 WITH GS_DISPLAY-BPCODE. " <== 핫스팟 클릭한 값을 읽어옴

    " BPCODE 가 일치하는 모든 전표 데이터를 가져옴
    SELECT
      SUM( DMBTR ) AS DMBTR
      FROM ZEA_BSEG
      INTO CORRESPONDING FIELDS OF TABLE GT_BSEG
      WHERE BPCODE EQ GS_DISPLAY-BPCODE
        AND SAKNR  IN R_SAKNR_4. " <== 제품국내매출액 을 가져옴
*     => BPCODE 별 전체 매출액을 가져온다.
    READ TABLE GT_BSEG INTO DATA(LV_DATA) INDEX 1. "<== SUM 데이터는 한 줄.

********    " 1월 판매액은  :
********    SELECT
********          SUM( A~DMBTR ) AS DMBTR "  통화금액 합계
********          SUM( A~EATAX ) AS EATAX " 세금 합계
********      FROM ZEA_BSEG AS A
********      JOIN ZEA_BKPF AS B
********        ON A~BUKRS EQ B~BUKRS
********        AND A~BELNR EQ B~BELNR
********        AND A~GJAHR EQ B~GJAHR
********       INTO CORRESPONDING FIELDS OF TABLE GT_DATA1
********    WHERE BPCODE EQ GS_DISPLAY-BPCODE
*********      AND BUDAT  IN R_1 " 전기일자
********      AND SAKNR  IN R_SAKNR_4
********      GROUP BY A~DMBTR A~EATAX. " <== 제품국내매출액 을 가져옴
********
********    READ TABLE GT_DATA1 INTO DATA(LV_DATA1) INDEX 1.
********
********    " 2월 판매액은  :
********    SELECT
********          SUM( A~DMBTR ) AS DMBTR "  통화금액 합계
********          SUM( A~EATAX ) AS EATAX " 세금 합계
********      FROM ZEA_BSEG AS A
********      JOIN ZEA_BKPF AS B
********        ON A~BUKRS EQ B~BUKRS
********        AND A~BELNR EQ B~BELNR
********        AND A~GJAHR EQ B~GJAHR
********       INTO CORRESPONDING FIELDS OF TABLE GT_DATA2
********    WHERE BPCODE EQ GS_DISPLAY-BPCODE
*********      AND BUDAT  IN R_2" 전기일자
********      AND SAKNR  IN R_SAKNR_4
********      GROUP BY A~DMBTR A~EATAX. " <== 제품국내매출액 을 가져옴
********
********    READ TABLE GT_DATA1 INTO DATA(LV_DATA2) INDEX 1.
********
********    " 3월 판매액은  :
********    SELECT
********          SUM( A~DMBTR ) AS DMBTR "  통화금액 합계
********          SUM( A~EATAX ) AS EATAX " 세금 합계
********      FROM ZEA_BSEG AS A
********      JOIN ZEA_BKPF AS B
********        ON A~BUKRS EQ B~BUKRS
********        AND A~BELNR EQ B~BELNR
********        AND A~GJAHR EQ B~GJAHR
********       INTO CORRESPONDING FIELDS OF TABLE GT_DATA3
********    WHERE BPCODE EQ GS_DISPLAY-BPCODE
*********      AND BUDAT  IN R_3 " 전기일자
********      AND SAKNR  IN R_SAKNR_4
********      GROUP BY A~DMBTR A~EATAX. " <== 제품국내매출액 을 가져옴
********
********    READ TABLE GT_DATA1 INTO DATA(LV_DATA3) INDEX 1.
********
********    " 4월 판매액은  :
********    SELECT
********          SUM( A~DMBTR ) AS DMBTR "  통화금액 합계
********          SUM( A~EATAX ) AS EATAX " 세금 합계
********      FROM ZEA_BSEG AS A
********      JOIN ZEA_BKPF AS B
********        ON A~BUKRS EQ B~BUKRS
********        AND A~BELNR EQ B~BELNR
********        AND A~GJAHR EQ B~GJAHR
********       INTO CORRESPONDING FIELDS OF TABLE GT_DATA4
********    WHERE BPCODE EQ GS_DISPLAY-BPCODE
*********      AND BUDAT  IN R_4 " 전기일자
********      AND SAKNR  IN R_SAKNR_4
********      GROUP BY A~DMBTR A~EATAX. " <== 제품국내매출액 을 가져옴
********
********    READ TABLE GT_DATA1 INTO DATA(LV_DATA4) INDEX 1.
********
    ITAB_DATA-DATANAME = GS_DISPLAY-BPCODE.
    ITAB_DATA-QUANTITY1 = LV_DATA-DMBTR.
    APPEND ITAB_DATA.


    CALL FUNCTION 'GRAPH_MATRIX_3D'
      EXPORTING
        COL1   = 'Store'
        TITL   = 'Performance by store'
      TABLES
        DATA   = ITAB_DATA
        OPTS   = ITAB_OPTIONS
      EXCEPTIONS
        OTHERS = 1.

  ELSE.
    " 클릭한 행의 데이터를 읽을 수 없음
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DOUBLE_CLICK
*&---------------------------------------------------------------------*
FORM DOUBLE_CLICK  USING PS_ROW    TYPE LVC_S_ROW
                         PS_COLUMN TYPE LVC_S_COL
                         PO_SENDER TYPE REF TO CL_GUI_ALV_GRID.

  DATA: LV_SAKNR TYPE ZEA_SKB1-SAKNR.

* 선택한 행이 인터널테이블에 있는 정상적인 데이터인지 체크
  CHECK PS_ROW-ROWTYPE IS INITIAL.

* itab 에서 클릭한 행의 데이터를 가져옴
  READ TABLE GT_DISPLAY INTO GS_DISPLAY INDEX PS_ROW-INDEX.

* 클릭한 행의 데이터를 사용
  IF SY-SUBRC = 0.
*   MESSAGE I000 WITH GS_DISPLAY-DMBTR_A. " <== 더블 클릭한 DMBTR_A의 값을 읽어옴

    " 전표번호를 찾을 순 없다. 왜냐? 전표번호는 유일하기 때문에.
    " G/L코드가 일치하는 데이터 전부를 찾아서 계정과목 조회화면으로 연결시켜주자.

    " 나는 금액을 더블클릭한다.
    " 따라서 더블클릭한 금액의 항목 정보(GL코드)를 읽어와야 한다.

    SELECT SINGLE SAKNR FROM ZEA_SKB1 INTO LV_SAKNR
      WHERE BPCODE EQ GS_DISPLAY-BPCODE
        AND  GLTXT EQ GS_DISPLAY-GLTXT.

    " 조건1. GL계정에 매핑된 BPCODE가 2개 이상일 때는 조건1
    " 조건2. BPCODE가 가 1개 이하일 때는 GLTXT로만 매핑
    IF LV_SAKNR IS INITIAL.
      CLEAR: LV_SAKNR.
      SELECT SINGLE SAKNR FROM ZEA_SKB1 INTO LV_SAKNR
          WHERE GLTXT EQ GS_DISPLAY-GLTXT.
    ENDIF.


    SET PARAMETER ID 'ZEA_SAKNR' FIELD LV_SAKNR.

*  SUBMIT ZEA_FI040.
    CALL TRANSACTION 'ZEA_FI040' AND SKIP FIRST SCREEN.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form BAPI_CURRENCY_CONV_TO_INTERNAL
*&---------------------------------------------------------------------*
FORM BAPI_CURRENCY_CONV_TO_INTERNAL  CHANGING PV_CURRENCY.

** -- 금액 변환 (금액.00 -> itab 에서 x100 되어서 나오는 오류를 방지하기 위함)
*CALL FUNCTION 'BAPI_CURRENCY_CONV_TO_INTERNAL'
*  EXPORTING
*    AMOUNT_EXTERNAL      = LV_CURRENCY
*    CURRENCY             = 'KRW'
*    MAX_NUMBER_OF_DIGITS = 23  "출력할 금액필드의 자릿수"
*  IMPORTING
*    AMOUNT_INTERNAL      =  LV_CURRENCY.


ENDFORM.
