*&---------------------------------------------------------------------*
*& Include          ZEA_SD110_TOP
*&---------------------------------------------------------------------*
TABLES: ZEA_SDT040, ZEA_SDT050, ZEA_SDT060, ZEA_SDT110, ZEA_KNA1,
        ZEA_MMT190, ZEA_MMT020.

DATA: BEGIN OF GS_DATA,
        SBELNR  TYPE ZEA_SDT060-SBELNR,
        VBELN   TYPE ZEA_SDT060-VBELN,
        CUSCODE TYPE ZEA_SDT060-CUSCODE,
        ADRNR   TYPE ZEA_SDT060-ADRNR,
        WERKS   TYPE ZEA_SDT060-WERKS,
        RETSU   TYPE ZEA_SDT060-RETSU,   "출고 상태
        RQDAT   TYPE ZEA_SDT060-RQDAT,   "출고 요청일
        REDAT   TYPE ZEA_SDT060-REDAT,   "출고일
        DQDAT   TYPE ZEA_SDT060-DQDAT,   "예상납기일(배송요청일)
        DADAT   TYPE ZEA_SDT060-DADAT,   "배송 도착예정일
        DESTU   TYPE ZEA_SDT060-DESTU,   "배송 상태
        STATUS  TYPE ZEA_SDT060-STATUS,
        STATUS2 TYPE ZEA_SDT060-STATUS, "X I O
      END OF GS_DATA.

DATA: GT_DATA LIKE TABLE OF GS_DATA.

DATA: BEGIN OF GS_DATA2,
        VBELN  TYPE ZEA_SDT050-VBELN,
        POSNR  TYPE ZEA_SDT050-POSNR,
        MATNR  TYPE ZEA_SDT050-MATNR,
        AUQUA  TYPE ZEA_SDT050-AUQUA,
        MEINS  TYPE ZEA_SDT050-MEINS,
        NETPR  TYPE ZEA_SDT050-NETPR,
        AUAMO  TYPE ZEA_SDT050-AUAMO,
        WAERS  TYPE ZEA_SDT050-WAERS,
        MAKTX  TYPE ZEA_MMT020-MAKTX,
        STATUS TYPE ZEA_SDT050-STATUS,
        SBELNR TYPE ZEA_SDT060-SBELNR,
      END OF GS_DATA2.

DATA: GT_DATA2 LIKE TABLE OF GS_DATA2.

DATA: BEGIN OF GS_DISPLAY2.
        INCLUDE STRUCTURE GS_DATA2.
DATA:
        ICON LIKE ICON-ID, " 아이콘
*        COLOR           TYPE C LENGTH 4, " 행 색상 정보
*        LIGHT           TYPE C,          " 신호등 표시를 위한
*        " EXCEPTION 필드
*        " 0:비움 1:빨강 2:노랑 3:초록
*        IT_FIELD_COLORS TYPE LVC_T_SCOL, " 셀 별 색상정보 인터널 테이블
*        STYLE           TYPE LVC_T_STYL, " 셀 스타일(모양)
*        MARK            TYPE CHAR1,      " 셀의 마킹 정보
      END OF GS_DISPLAY2.

DATA: GT_DISPLAY2 LIKE TABLE OF GS_DISPLAY2.

**--------------------------------------------------------------------*
**--------------------------재고 테이블-------------------------------*
**--------------------------------------------------------------------*
*DATA: GT_MMT190 TYPE TABLE OF ZEA_MMT190,
*      GS_MMT190 LIKE LINE OF  GT_MMT190.
*
**--------------------------------------------------------------------*
**--------------------------배치 테이블-------------------------------*
**--------------------------------------------------------------------*
*
*DATA: GT_MMT070 TYPE TABLE OF ZEA_MMT070,
*      GS_MMT070 LIKE LINE OF  GT_MMT070.
**&---------------------------------------------------------------------*
**&---------------------------------------------------------------------*
*
*DATA: BEGIN OF GS_DATA4,
*        MATNR     TYPE ZEA_MMT190-MATNR,
*        WERKS     TYPE ZEA_MMT190-WERKS,
*        SCODE     TYPE ZEA_MMT190-SCODE,
*        CALQTY    TYPE ZEA_MMT190-CALQTY,
*        MEINS     TYPE ZEA_MMT190-MEINS,
*        SUM_VALUE TYPE ZEA_MMT190-SUM_VALUE,
*        WAERS     TYPE ZEA_MMT190-WAERS,
*        PNAME1    TYPE ZEA_T001W-PNAME1,
*        MAKTX     TYPE ZEA_MMT020-MAKTX,
*      END OF GS_DATA4.
*
*DATA GT_DATA4 LIKE TABLE OF GS_DATA4.
