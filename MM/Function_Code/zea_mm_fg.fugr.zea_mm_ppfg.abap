FUNCTION ZEA_MM_PPFG.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_AUFNR) TYPE  ZEA_AUFK-AUFNR
*"     REFERENCE(IT_ITEM) TYPE  ZEA_MMY190
*"  EXPORTING
*"     REFERENCE(ES_HEAD) TYPE  ZEA_MMT090
*"     REFERENCE(ET_ITEM) TYPE  ZEA_MMY100
*"----------------------------------------------------------------------

*DATA: BEGIN OF TS_ZEA_AUFK,
*        AUFNR    TYPE ZEA_AUFK-AUFNR,
*        WERKS    TYPE ZEA_AUFK-WERKS,
*        MATNR    TYPE ZEA_AUFK-MATNR,
*        TOT_QTY  TYPE ZEA_AUFK-TOT_QTY,
*        MEINS    TYPE ZEA_AUFK-MEINS,
*        APPROVAL TYPE ZEA_AUFK-APPROVAL,
*        APPROVER TYPE ZEA_AUFK-APPROVER,
*      END OF TS_ZEA_AUFK.
*
*
***   7번 넘버레인지 자재문서 번호
***
*  CLEAR: GS_AUFK, GS_PPT020.
*  REFRESH: GT_AUFK, GT_PPT020.
*
*
*  DATA: GT_STPO TYPE TABLE OF ZEA_STPO,
*        GS_STPO LIKE LINE OF GT_STPO.
*  DATA: GT_MMT070 TYPE TABLE OF ZEA_MMT070,
*        GS_MMT070 LIKE LINE OF GT_MMT070.
*
*
*
*  SELECT *
*    FROM ZEA_AUFK AS A
*    JOIN ZEA_PPT020 AS B
*      ON A~AUFNR EQ B~AUFNR
*    JOIN ZEA_STPO AS C
*      ON C~BOMID EQ B~BOMID
*    JOIN ZEA_MMT070 AS D
*      ON D~MATNR EQ A~MATNR
*    INTO CORRESPONDING FIELDS OF TABLE @GT_AUFK
*    WHERE A~AUFNR EQ @IV_AUFNR.
*
*
*  SELECT SINGLE *
*    FROM ZEA_PPT020
*    INTO CORRESPONDING FIELDS OF @GS_PPT020
*    WHERE AUFNR  EQ @IV_AUFNR.
*
*  SELECT *
*    FROM ZEA_STPO AS A
*    INNER JOIN ZEA_STKO AS B
*      ON B~BOMID EQ A~BOMID
*    INTO CORRESPONDING FIELDS OF TABLE GT_STPO
*    WHERE B~MATNR EQ GS_PPT020-MATNR.
*
*  SELECT *
*    FROM ZEA_MMT070
*    INTO CORRESPONDING FIELDS OF TABLE GT_MMT070
*    WHERE MATNR EQ GS_MMT070-MATNR
*      AND WERKS EQ GS_MMT070-WERKS.
*    READ TABLE GT_PPT020 INTO GS_PPT020 INDEX 1.
*
*
*  SELECT SINGLE STPRS
*    FROM ZEA_MMT010
*   INTO @DATA(LV_STPRS)
*    WHERE MATNR EQ @GS_PPT020-MATNR.
*
*
* "ZEA_MMT090 따라서 만든 itab wa 선언
*  DATA : GT_MMT090 TYPE TABLE OF ZEA_MMT090,
*         GS_MMT090 TYPE ZEA_MMT090.
* "ZEA_MMT100 따라서 만든 itab wa를 선언
*  DATA : GT_MMT100 TYPE TABLE OF ZEA_MMT100,
*         GS_MMT100 LIKE LINE OF GT_MMT100.
***
***--------------------------------------------------------------------*
*** 자재문서 헤더 생성
***--------------------------------------------------------------------*
*** MBLNR  자재문서 번호 KEY    AUFNR      생산오더 ID KEY
*** GJAHR  회계연도             WERKS      플랜트ID
*** WERKS  플랜트ID             PLANID     생산계획 ID
*** VGART  트랜잭션 유형        MATNR      자재코드
*** BUDAT  전기일자             TOT_QTY    총 오더수량
***                            MEINS      단위
***                            APPROVAL   승인여부
***                            APPROVER   결재자
***                            REJREASON  반려사유
***                            LOEKZ      삭제플래그
***
***
*  PERFORM NUMR.
*
***
*  GS_MMT090-MBLNR = ZEA_MMT100-MBLNR.
*  GS_MMT090-GJAHR = SY-DATUM(4).
*  GS_MMT090-WERKS = GS_AUFK-WERKS.
*  GS_MMT090-VGART = ' '.
*  GS_MMT090-BUDAT = SY-DATUM.
***
***
***--------------------------------------------------------------------*
*** 자재문서 아이템 생성
***--------------------------------------------------------------------*
*** MBLNR  자재문서 번호         AUFNR     생산오더 ID
*** GJAHR  회계연도              ORDIDX    생산오더 Index
*** MBGNO  자재문서 품목번호     MATNR     자재코드
*** MATNR  자재코드              BOMID     BOM ID
*** BWART  이동유형              WERKS     플랜트ID
*** CHARG  배치 번호             EXPQTY    예상 생산수량
*** PLANTFR  시작정보(플랜트)    SDATE     생산 시작일자
*** PLANTTO  도착정보(플랜트)    EDATE     생산 종료일자
*** LGORTFR  저장위치(시작)      ISPDATE   검수완료 일자
*** LGORTTO  저장위치(도착)      REPQTY    임시 검수수량
*** DMBTR  통화금액(KRW)         RQTY      생산완료 수량
*** WAERS1 통화코드             UNIT      단위
*** MENGE  수량                  LOEKZ     삭제플래그
*** MEINS  단위
*** GRUND  자재 이동사유
*** VENCODE  [BP] 벤더코드
*** CUSCODE [BP]고객코드
***
***   4월 1일에 100$ 수입해옴 환율 1000원
***   4월 10일에 100$ 수입해옴 환율 1100원
***
***   KRW 표시 총 재고 가격은 210,000원
***   USD 표시 총 재고 가격은 200$.
**  REFRESH GT_MMT100.
***
*  LOOP AT GT_STPO INTO GS_STPO.
*
*  CLEAR GS_STPO.
*
*    CLEAR GS_MMT100.
*    GS_MMT100-MBLNR   = GS_MMT090-MBLNR.
*    GS_MMT100-GJAHR   = GS_MMT090-GJAHR.
*    GS_MMT100-MBGNO   = SY-TABIX.
*    GS_MMT100-MATNR   = GS_STPO-MATNR. " 원재료
*    GS_MMT100-PONUM   = SPACE.
*    GS_MMT100-AUFNR   = GS_AUFK-AUFNR.
*    GS_MMT100-SBELNR   = SPACE.
*    GS_MMT100-BWART   = '261'. " 생산승인되어 원자재공장->생산출고하는 유형
*    GS_MMT100-PLANTFR = GS_AUFK-WERKS.
*    GS_MMT100-PLANTTO = GS_AUFK-WERKS.
*    GS_MMT100-LGORTFR = '10000'. " GS_AUFK-WERKS 의 원자재 저장위치 코드
*    GS_MMT100-LGORTTO = '10000'.
*
*    GS_MMT100-MENGE   = GS_STPO-MENGE.
*    GS_MMT100-MEINS   = GS_STPO-MEINS.
***--------------------------------------------------------------------*
*    GS_MMT100-DMBTR   = LV_STPRS * GS_STPO-MENGE.
***--------------------------------------------------------------------*
*    GS_MMT100-WAERS1  = TEXT-U01.
*
*    GS_MMT100-GRUND   = | { GS_AUFK-WERKS } 생산승인되어 원자재공장->생산출고하는 유형 |.
*    GS_MMT100-VENCODE = SPACE.
*    GS_MMT100-CUSCODE = SPACE.
*
*
*    APPEND GS_MMT090 TO GT_MMT090.
*    APPEND GS_MMT100 TO GT_MMT100.
*  ENDLOOP.
***
***
*  BREAK-POINT.
***--------------------------------------------------------------------*
*** DB 저장하는 과정
***--------------------------------------------------------------------*
***
*  INSERT ZEA_MMT090 FROM GS_MMT090.
*  INSERT ZEA_MMT100 FROM TABLE GT_MMT100.
*
*
*    INSERT ZEA_MMT090 FROM TABLE GT_MMT090 ACCEPTING DUPLICATE KEYS.
*    IF SY-SUBRC NE 0.
*      ROLLBACK WORK.
*    ENDIF.
*
*    INSERT ZEA_MMT100 FROM TABLE GT_MMT100 ACCEPTING DUPLICATE KEYS.
*    IF SY-SUBRC NE 0.
*      ROLLBACK WORK.
*    ENDIF.
*BREAK-POINT.



  CLEAR: GT_AUFK[], GT_PPT020[].

  SELECT * INTO CORRESPONDING FIELDS OF TABLE @GT_AUFK
           FROM ZEA_AUFK
          WHERE AUFNR EQ @IV_AUFNR.
  IF SY-SUBRC NE 0.
  ELSE.

    SELECT * INTO CORRESPONDING FIELDS OF TABLE @GT_PPT020
             FROM ZEA_PPT020
                  FOR ALL ENTRIES IN @GT_AUFK
            WHERE AUFNR EQ @GT_AUFK-AUFNR.
            " AND ORDIDX EQ @IV_ORDIDX.
  ENDIF.

  CLEAR: GT_MMT090[], GT_MMT100[].
  CLEAR: ZEA_MMT090-MBLNR.

  LOOP AT GT_AUFK INTO GS_AUFK.

    PERFORM MAKE_MBLNR_HEADER_DATA_PP TABLES GT_MMT090
                                   USING GS_AUFK
                                   CHANGING ZEA_MMT090-MBLNR.

    LOOP AT GT_PPT020 INTO GS_PPT020
                      WHERE AUFNR EQ GS_AUFK-AUFNR.
      PERFORM MAKE_MBLNR_ITEM_DATA_PP TABLES GT_MMT100
                                             IT_ITEM  " 추가?
                                   USING GS_PPT020
                                         ZEA_MMT090-MBLNR.

    ENDLOOP.

  ENDLOOP.

* Save Data
  IF GT_MMT090[] IS NOT INITIAL.
    INSERT ZEA_MMT090 FROM TABLE GT_MMT090 ACCEPTING DUPLICATE KEYS.
    IF SY-SUBRC NE 0.
      ROLLBACK WORK.
    ENDIF.
  ENDIF.


  IF GT_MMT100[] IS NOT INITIAL.
    INSERT ZEA_MMT100 FROM TABLE GT_MMT100 ACCEPTING DUPLICATE KEYS.
    IF SY-SUBRC NE 0.
      ROLLBACK WORK.
    ENDIF.
  ENDIF.
*
*
  ENDFUNCTION.
