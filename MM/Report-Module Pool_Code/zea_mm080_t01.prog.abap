*&---------------------------------------------------------------------*
*& Include         ZEA_MM080_T01
*&---------------------------------------------------------------------*
*&--------------------------------------------------------------------*
*&
*&  TABLES
*&--------------------------------------------------------------------*
TABLES: ZEA_LFA1,   "[FI] 벤더 테이블
        ZEA_TVZBT,  "[FI] 지급조건 테이블
        ZEA_FIT000, "[FI] 회사코드 테이블
        ZEA_BKNA,   "[FI] 은행 마스터 테이블
        ZEA_SKB1,   "[FI] G/L계정마스터

        ZEA_MMT140, "[MM] 구매오더 Header
        ZEA_MMT150, "[MM] 구매오더 Item
        ZEA_MMT090, "[MM] 자재문서 Header
        ZEA_MMT100, "[MM] 자재문서 Item
        ZEA_MMT160, "[MM] 송장검증 Header
        ZEA_MMT170. "[MM] 송장검증 Item

*&--------------------------------------------------------------------*
*&
*&  ALV VARIABLE
*&--------------------------------------------------------------------*
DATA : GO_CONTAINER1 TYPE REF TO CL_GUI_CUSTOM_CONTAINER.
DATA : GO_CONTAINER2 TYPE REF TO CL_GUI_CUSTOM_CONTAINER.

DATA : GO_GRID1     TYPE REF TO CL_GUI_ALV_GRID.
DATA : GO_GRID2     TYPE REF TO CL_GUI_ALV_GRID.

DATA : GT_FCAT1 TYPE LVC_T_FCAT.
DATA : GT_FCAT2 TYPE LVC_T_FCAT.

DATA : GS_LAYO1 TYPE LVC_S_LAYO.
DATA : GS_LAYO2 TYPE LVC_S_LAYO.

DATA : GT_SORT1 TYPE LVC_T_SORT.
DATA : GT_SORT2 TYPE LVC_T_SORT.

*&--------------------------------------------------------------------*
*&
*&  SCREEN VARIABLE
*&--------------------------------------------------------------------*
DATA : OK_CODE LIKE SY-UCOMM.

*&--------------------------------------------------------------------*
*&
*&  VARIABLE
*&--------------------------------------------------------------------*
DATA : INVOICE_TXT TYPE CHAR50.
DATA : GV_TOTCOST2 LIKE ZEA_MMT160-TOTCOST."지급완료
DATA : GV_TOTCOST3 LIKE ZEA_MMT160-TOTCOST."지급

DATA : GV_WAERS2   LIKE ZEA_MMT160-WAERS.
DATA : GV_WAERS3   LIKE ZEA_MMT160-WAERS.


*ZEA_MMT150-DMBRR.
*ZEA_MMT150-WAERS.

*&--------------------------------------------------------------------*
*&
*&  INTERNAL TABLE
*&--------------------------------------------------------------------*
DATA : BEGIN OF GT_DISP1 OCCURS 0.
DATA : CHKBOX TYPE C,                  "체크박스
       MATNR   LIKE ZEA_MMT010-MATNR,  "자재
       MAKTX   LIKE ZEA_MMT020-MAKTX,  "자재 내역
       MENGE   LIKE ZEA_MMT170-MENGE,  "수량
       MEINS   LIKE ZEA_MMT170-MEINS,  "단위
       TOTCOST LIKE ZEA_MMT160-TOTCOST,"금액
       WAERS   LIKE ZEA_MMT160-WAERS.  "통화
DATA : END OF GT_DISP1.

DATA : BEGIN OF GT_DISP2 OCCURS 0.
DATA :  PONUM    LIKE ZEA_MMT170-PONUM,   "구매오더 문서번호
        EBELP    LIKE ZEA_MMT170-EBELP,   "구매오더 품목번호
        ARIVDATE LIKE ZEA_MMT140-ARIVDATE,"입고예정일
        MATNR    LIKE ZEA_MMT170-MATNR,   "자재코드
        MAKTX    LIKE ZEA_MMT020-MAKTX,   "자재코드 내역
        WERKS    LIKE ZEA_MMT170-WERKS,   "플랜트
        MENGE    LIKE ZEA_MMT170-MENGE,   "수량
        MEINS    LIKE ZEA_MMT170-MEINS,   "단위
        WRBTR    LIKE ZEA_MMT170-WRBTR,   "구매 단가
        WAERS    LIKE ZEA_MMT170-WAERS,   "통화

        GJAHR    LIKE ZEA_MMT100-GJAHR,   "회계연도
        MBLNR    LIKE ZEA_MMT100-MBLNR,   "자재문서
        MBGNO    LIKE ZEA_MMT100-MBGNO,   "자재문서 품목번호
        BUDAT    LIKE ZEA_MMT090-BUDAT,   "입고일

        BELNR    LIKE ZEA_MMT170-BELNR,   "송장문서번호
        ICON     LIKE ICON-ID."생성상태
*        INCLUDE STRUCTURE ZEA_MMT170.
DATA : END OF GT_DISP2.

*구매오더
DATA : GT_MMT140 LIKE ZEA_MMT140 OCCURS 0 WITH HEADER LINE.
DATA: BEGIN OF GT_MMT150 OCCURS 0.
       INCLUDE STRUCTURE ZEA_MMT150.
DATA:  ARIVDATE LIKE ZEA_MMT140-ARIVDATE.
DATA : END OF GT_MMT150.
*자재문서
DATA : GT_MMT090 LIKE ZEA_MMT090 OCCURS 0 WITH HEADER LINE.
DATA: BEGIN OF GT_MMT100 OCCURS 0.
       INCLUDE STRUCTURE ZEA_MMT100.
DATA:  BUDAT LIKE ZEA_MMT090-BUDAT.
DATA : END OF GT_MMT100.

*송장문서
DATA : GT_MMT160 LIKE ZEA_MMT160 OCCURS 0 WITH HEADER LINE.
DATA : GT_MMT170 LIKE ZEA_MMT170 OCCURS 0 WITH HEADER LINE.

*&--------------------------------------------------------------------*
*&
*&  SELECTION SCREEN
*&--------------------------------------------------------------------*
PARAMETERS: P_BUKRS LIKE ZEA_FIT000-BUKRS    OBLIGATORY.
PARAMETERS: P_LIFNR LIKE ZEA_LFA1-VENCODE    OBLIGATORY.
SELECT-OPTIONS: S_WERKS FOR ZEA_MMT140-WERKS OBLIGATORY.
SELECT-OPTIONS: S_BUDAT FOR ZEA_MMT090-BUDAT.
SELECT-OPTIONS: S_PONUM FOR ZEA_MMT140-PONUM.
SELECT-OPTIONS: S_MATNR FOR ZEA_MMT150-MATNR.

SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-T01.
PARAMETERS: P_BLDAT TYPE ZEA_MMT160-BLDAT.
SELECTION-SCREEN END OF BLOCK B1.
