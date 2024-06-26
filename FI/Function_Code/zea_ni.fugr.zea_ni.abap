FUNCTION ZEA_NI.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  EXPORTING
*"     REFERENCE(EV_INCOME) TYPE  ZEA_BSEG-DMBTR
*"---------------------------------------------------------------------*
*  Range 변수
*"---------------------------------------------------------------------*
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

*"---------------------------------------------------------------------*
* 손익계정 ( ALL)
*"---------------------------------------------------------------------*
  SELECT
    A~BUDAT
    B~GJAHR   " 회계연도
    B~SAKNR   " G/L계정 (Recon)
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
    GROUP BY A~BUDAT B~GJAHR B~SAKNR.


*"---------------------------------------------------------------------*
* 계산
* -- 1. 매출/ 매출원가 ------------------------------------------------*
  CLEAR: GS_DATA.

  " 매출 계정 (4*)
  LOOP AT GT_DATA INTO GS_DATA WHERE SAKNR IN R_SAKNR_4.
    DMBTR_4 = DMBTR_4 + GS_DATA-DMBTR. " 계정별 누적합
  ENDLOOP.

  " 매출원가 계정 (5*)
  CLEAR GS_DATA.
  LOOP AT GT_DATA INTO GS_DATA WHERE SAKNR IN R_SAKNR_5.
    DMBTR_5 = DMBTR_5 + GS_DATA-DMBTR. " 계정별 누적합
  ENDLOOP.

* -- 2. 매출총이익 = 매출 - 매출원가 ----------------------------------*
  DMBTR_A = DMBTR_4 - DMBTR_5.

* -- 3. 판관비 --------------------------------------------------------*
  CLEAR GS_DATA.
  LOOP AT GT_DATA INTO GS_DATA WHERE SAKNR IN R_SAKNR_6.
    DMBTR_6 = DMBTR_6 + GS_DATA-DMBTR. " 계정별 누적합
  ENDLOOP.

* -- 4. 영업이익 = 매출총이익 - 판관비 --------------------------------*
  DMBTR_B = DMBTR_A - DMBTR_6.

* -- 5. 영업외이익 / 손실 ---------------------------------------------*
  CLEAR GS_DATA.
  LOOP AT GT_DATA INTO GS_DATA WHERE SAKNR IN R_SAKNR_7P.
    DMBTR_7P = DMBTR_7P + GS_DATA-DMBTR. " 계정별 누적합
  ENDLOOP.

  CLEAR GS_DATA.
  LOOP AT GT_DATA INTO GS_DATA WHERE SAKNR IN R_SAKNR_7L.
    DMBTR_7L = DMBTR_7L + GS_DATA-DMBTR. " 계정별 누적합
  ENDLOOP.

* -- 6. 당기순이익 = 영업이익 + 영업외이익 - 영업외비용 ---------------*
  DMBTR_C = DMBTR_B + DMBTR_7P - DMBTR_7L.


*"----------------------------------------------------------------------
*                        당기순이익 Exporting
*"----------------------------------------------------------------------
  EV_INCOME = DMBTR_C.

ENDFUNCTION.
