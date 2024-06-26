FUNCTION ZEA_MM_PP_OFG.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_AUFNR) TYPE  ZEA_AFRU-AUFNR
*"----------------------------------------------------------------------




  " 7번 넘버레인지 자재문서 번호
  DATA: GT_AFRU TYPE TABLE OF ZEA_AFRU,
        GS_AFRU LIKE LINE OF GT_AFRU.

* ZEA_MMT090 따라서 만든 itab wa 선언
  DATA : GT_MMT090 TYPE TABLE OF ZEA_MMT090,
         GS_MMT090 TYPE ZEA_MMT090.
* ZEA_MMT100 따라서 만든 itab wa를 선언
  DATA : GT_MMT100 TYPE TABLE OF ZEA_MMT100,
         GS_MMT100 LIKE LINE OF GT_MMT100.



  CLEAR: GS_AUFK, GS_PPT020, GS_AFRU.
  REFRESH: GT_AUFK, GT_PPT020, GT_AFRU.


*  DATA: GT_STPO TYPE TABLE OF ZEA_STPO,
*        GS_STPO LIKE LINE OF GT_STPO.

  DATA: GT_MMT070 TYPE TABLE OF ZEA_MMT070,
        GS_MMT070 LIKE LINE OF GT_MMT070.

  SELECT *
  FROM ZEA_MMT070  AS A
  JOIN ZEA_AFRU AS B
    ON B~CHARG EQ A~CHARG  "생산실적
   AND B~MATNR EQ A~MATNR
  INTO CORRESPONDING FIELDS OF TABLE @GT_DATA
  WHERE AUFNR EQ @IV_AUFNR.

  READ TABLE GT_DATA INTO GS_DATA INDEX 1.

*SELECT *
*  FROM ZEA_AFRU
*  INTO CORRESPONDING FIELDS OF TABLE @GT_AFRU
*  WHERE AUFNR EQ @IV_AUFNR.

  SELECT SINGLE *
    FROM ZEA_AUFK "생산오더
    INTO CORRESPONDING FIELDS OF @GS_AUFK
    WHERE AUFNR EQ @IV_AUFNR.

  SELECT *
    FROM ZEA_PPT020 "생산오더 아이템
    INTO CORRESPONDING FIELDS OF TABLE @GT_PPT020
    WHERE AUFNR EQ @IV_AUFNR.

  SELECT SINGLE STPRS
    FROM ZEA_MMT010
    INTO @DATA(LV_STPRS)
    WHERE MATNR EQ @GS_DATA-MATNR.

*  SELECT *
*    FROM ZEA_MMT070
*    INTO CORRESPONDING FIELDS OF TABLE GT_MMT070.




*--------------------------------------------------------------------*
* 자재문서 헤더 생성
*--------------------------------------------------------------------*
* MBLNR	자재문서 번호 KEY    AUFNR      생산오더 ID KEY
* GJAHR	회계연도             WERKS      플랜트ID
* WERKS	플랜트ID             PLANID     생산계획 ID
* VGART	트랜잭션 유형        MATNR      자재코드
* BUDAT	전기일자             TOT_QTY    총 오더수량
*                            MEINS      단위
*                            APPROVAL   승인여부
*                            APPROVER   결재자
*                            REJREASON  반려사유
*                            LOEKZ      삭제플래그

  PERFORM NUMR.

  GS_MMT090-MBLNR = ZEA_MMT100-MBLNR.
  GS_MMT090-GJAHR = GS_DATA-TSDAT(4).
  GS_MMT090-WERKS = GS_DATA-WERKS.
  GS_MMT090-VGART = ' '.
  GS_MMT090-BUDAT = GS_DATA-TSDAT.
  GS_MMT090-ERNAM = SY-UNAME.
  GS_MMT090-ERDAT = SY-DATUM.
  GS_MMT090-ERZET = SY-UZEIT.

  INSERT ZEA_MMT090 FROM GS_MMT090.

*--------------------------------------------------------------------*
* 자재문서 아이템 생성
*--------------------------------------------------------------------*
* MBLNR	자재문서 번호         AUFNR     생산오더 ID
* GJAHR	회계연도              ORDIDX    생산오더 Index
* MBGNO	자재문서 품목번호     MATNR     자재코드
* MATNR	자재코드              BOMID     BOM ID
* BWART	이동유형              WERKS     플랜트ID
* CHARG	배치 번호             EXPQTY    예상 생산수량
* PLANTFR	시작정보(플랜트)    SDATE     생산 시작일자
* PLANTTO	도착정보(플랜트)    EDATE     생산 종료일자
* LGORTFR	저장위치(시작)      ISPDATE   검수완료 일자
* LGORTTO	저장위치(도착)      REPQTY    임시 검수수량
* DMBTR	통화금액(KRW)         RQTY      생산완료 수량
* WAERS1 통화코드             UNIT      단위
* MENGE	수량                  LOEKZ     삭제플래그
* MEINS	단위
* GRUND	자재 이동사유
* VENCODE	[BP] 벤더코드
* CUSCODE [BP]고객코드

  REFRESH GT_MMT100.

  LOOP AT GT_DATA INTO GS_DATA.


    GS_MMT100-MBLNR = GS_MMT090-MBLNR.
    GS_MMT100-GJAHR = GS_DATA-TSDAT.
    GS_MMT100-MBGNO = SY-TABIX.
    GS_MMT100-MATNR = GS_DATA-MATNR.
    GS_MMT100-PONUM   = SPACE.
    GS_MMT100-AUFNR   = GS_AUFK-AUFNR.
    GS_MMT100-SBELNR   = SPACE.
    GS_MMT100-BWART = '131'. " 검수 완료된 완제품 입고
    GS_MMT100-CHARG = GS_DATA-CHARG.
    GS_MMT100-PLANTFR = GS_DATA-WERKS.
    GS_MMT100-PLANTTO = GS_DATA-WERKS.
    GS_MMT100-LGORTFR = GS_DATA-SCODE. " GS_AUFK-WERKS 의 원자재 저장위치 코드
    GS_MMT100-LGORTTO = GS_DATA-SCODE.

    GS_MMT100-MENGE   = GS_DATA-FNPD.
    GS_MMT100-MEINS   = 'PKG'.
*--------------------------------------------------------------------*
    GS_MMT100-DMBTR   = LV_STPRS * GS_DATA-FNPD * 100.
*--------------------------------------------------------------------*
    GS_MMT100-WAERS1  = 'KRW'.

    GS_MMT100-GRUND   = | { GS_DATA-WERKS } 검수 완료된 완제품 입고 유형|.
    GS_MMT100-VENCODE = '1000'.
    GS_MMT100-CUSCODE = SPACE.
    GS_MMT100-ERNAM = SY-UNAME.
    GS_MMT100-ERDAT = SY-DATUM.
    GS_MMT100-ERZET = SY-UZEIT.
*    APPEND GS_MMT090 TO GT_MMT090.
    APPEND GS_MMT100 TO GT_MMT100.

  ENDLOOP.
*  BREAK-POINT.
*--------------------------------------------------------------------*
* DB 저장하는 과정
*--------------------------------------------------------------------*


  INSERT ZEA_MMT100 FROM TABLE GT_MMT100.

  IF SY-SUBRC EQ 0.
    COMMIT WORK.
    "메세지
  ELSE.
    ROLLBACK WORK.
    "메세지
  ENDIF.







ENDFUNCTION.
