*&---------------------------------------------------------------------*
*& Include          ZEA_CHECK_MTTOP
*&---------------------------------------------------------------------*

TABLES: ZEA_T001W, ZEA_MMT020, ZEA_MMT060, ZEA_MMT190, ZEA_MMT010.

CLASS LCL_EVENT_HANDLER DEFINITION DEFERRED.

*--------------------------------------------------------------------*
*--------------------------재고량 조회-------------------------------*
*--------------------------------------------------------------------*
DATA: BEGIN OF GS_DISPLAY,
       STATUS TYPE ICON-ID,
        BUKRS  TYPE ZEA_T001W-BUKRS,       " 회사코드
        MATNR  TYPE ZEA_MMT190-MATNR,      " 자재코드
        MAKTX  TYPE ZEA_MMT020-MAKTX,      " 자재명
        WERKS  TYPE ZEA_MMT190-WERKS,      " 플랜트 ID
        PNAME1 TYPE ZEA_T001W-PNAME1,      " 플랜트명
        SCODE  TYPE ZEA_MMT190-SCODE,      " 저장위치
        SNAME  TYPE ZEA_MMT060-SNAME,      " 저장위치 명
        CALQTY TYPE ZEA_MMT190-CALQTY,     " 수량
        MEINS  TYPE ZEA_MMT190-MEINS,      " 단위
        WEIGHT TYPE ZEA_MMT190-WEIGHT,     "
        MEINS2 TYPE ZEA_MMT190-MEINS2,      " 통화코드
        SAFSTK TYPE ZEA_MMT190-SAFSTK,
        MEINS3 TYPE ZEA_MMT190-MEINS3,

      END OF GS_DISPLAY.

DATA GT_DISPLAY LIKE TABLE OF GS_DISPLAY.

DATA: BEGIN OF GS_DISPLAY2.
*        INCLUDE STRUCTURE GS_DISPLAY.
DATA:   STATUS LIKE ICON-ID, " 아이콘
*        COLOR           TYPE C LENGTH 4, " 행 색상 정보
*        LIGHT           TYPE C,          " 신호등 표시를 위한
        " EXCEPTION 필드
        " 0:비움 1:빨강 2:노랑 3:초록
*        IT_FIELD_COLORS TYPE LVC_T_SCOL, " 셀 별 색상정보 인터널 테이블
*        STYLE           TYPE LVC_T_STYL, " 셀 스타일(모양)
*        MARK            TYPE CHAR1,      " 셀의 마킹 정보
      END OF GS_DISPLAY2.

DATA: GT_DISPLAY2 LIKE TABLE OF GS_DISPLAY2.


*--------------------------------------------------------------------*
* 110번
*--------------------------------------------------------------------*
DATA: BEGIN OF GS_DISPLAY3,
       STATUS TYPE ICON-ID,
        BUKRS  TYPE ZEA_T001W-BUKRS,       " 회사코드
        MATNR  TYPE ZEA_MMT190-MATNR,      " 자재코드
        MAKTX  TYPE ZEA_MMT020-MAKTX,      " 자재명
        WERKS  TYPE ZEA_MMT190-WERKS,      " 플랜트 ID
        PNAME1 TYPE ZEA_T001W-PNAME1,      " 플랜트명
        SCODE  TYPE ZEA_MMT190-SCODE,      " 저장위치
        SNAME  TYPE ZEA_MMT060-SNAME,      " 저장위치 명
        CALQTY TYPE ZEA_MMT190-CALQTY,     " 수량
        MEINS  TYPE ZEA_MMT190-MEINS,      " 단위
        WEIGHT TYPE ZEA_MMT190-WEIGHT,     "
        MEINS2 TYPE ZEA_MMT190-MEINS2,      " 통화코드
        SAFSTK TYPE ZEA_MMT190-SAFSTK,
        MEINS3 TYPE ZEA_MMT190-MEINS3,

      END OF GS_DISPLAY3.

DATA GT_DISPLAY3 LIKE TABLE OF GS_DISPLAY3.
*--------------------------------------------------------------------*







DATA: GV_PNAME1 TYPE ZEA_T001W-PNAME1,
      GV_SNAME  TYPE ZEA_MMT060-SNAME,
      GV_MAKTX  TYPE ZEA_MMT020-MAKTX,
      GV_CALQTY TYPE ZEA_MMT190-CALQTY,
      GV_MEINS  TYPE  ZEA_MMT190-MEINS.



*DATA: BEGIN OF GS_DATA,
**       STATUS TYPE ICON-ID,
*        BUKRS  TYPE ZEA_T001W-BUKRS,       " 회사코드
*        MATNR  TYPE ZEA_MMT190-MATNR,      " 자재코드
*        MAKTX  TYPE ZEA_MMT020-MAKTX,      " 자재명
*        WERKS  TYPE ZEA_MMT190-WERKS,      " 플랜트 ID
*        PNAME1 TYPE ZEA_T001W-PNAME1,      " 플랜트명
*        SCODE  TYPE ZEA_MMT190-SCODE,      " 저장위치
*        SNAME  TYPE ZEA_MMT060-SNAME,      " 저장위치 명
*        CALQTY TYPE ZEA_MMT190-CALQTY,     " 수량
*        MEINS  TYPE ZEA_MMT190-MEINS,      " 단위
*        WEIGHT TYPE ZEA_MMT190-WEIGHT,     "
*        MEINS2 TYPE ZEA_MMT190-MEINS2,      " 통화코드
*
*      END OF GS_DATA.
*
*DATA GT_DATA LIKE TABLE OF GS_DATA.
*
*DATA: BEGIN OF GS_DISPLAY.
*        INCLUDE STRUCTURE GS_DATA.
*DATA:   STATUS LIKE ICON-ID, " 아이콘
**        COLOR           TYPE C LENGTH 4, " 행 색상 정보
**        LIGHT           TYPE C,          " 신호등 표시를 위한
*        " EXCEPTION 필드
*        " 0:비움 1:빨강 2:노랑 3:초록
**        IT_FIELD_COLORS TYPE LVC_T_SCOL, " 셀 별 색상정보 인터널 테이블
**        STYLE           TYPE LVC_T_STYL, " 셀 스타일(모양)
**        MARK            TYPE CHAR1,      " 셀의 마킹 정보
*      END OF GS_DISPLAY.
*
*DATA: GT_DISPLAY LIKE TABLE OF GS_DISPLAY.

DATA: URL              TYPE CNDP_URL,
      PIC1             TYPE REF TO CL_GUI_PICTURE,
      CONTAINER3       TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      GT_WWWTAB        LIKE WWWPARAMS OCCURS 0 WITH HEADER LINE.

CONSTANTS: GC_DANGER TYPE STRING VALUE 'DANGER'.
































*--------------------------------------------------------------------*
*DATA: BEGIN OF GS_DISPLAY2,
*        BUKRS  TYPE ZEA_T001W-BUKRS,       " 회사코드
*        MATNR  TYPE ZEA_MMT190-MATNR,      " 자재코드
*        MAKTX  TYPE ZEA_MMT020-MAKTX,      " 자재명
*        WERKS  TYPE ZEA_MMT190-WERKS,      " 플랜트 ID
*        PNAME1 TYPE ZEA_T001W-PNAME1,      " 플랜트명
*        SCODE  TYPE ZEA_MMT190-SCODE,      " 저장위치
*        SNAME  TYPE ZEA_MMT060-SNAME,      " 저장위치 명
*        CALQTY TYPE ZEA_MMT190-CALQTY,     " 수량
*        MEINS  TYPE ZEA_MMT190-MEINS,      " 단위
*        WEIGHT TYPE ZEA_MMT190-WEIGHT,  " 재고수량의 총금액
*        MEINS2 TYPE ZEA_MMT190-MEINS2,      " 통화코드
*      END OF GS_DISPLAY2.
*
*DATA GT_DISPLAY2 LIKE TABLE OF GS_DISPLAY2.
*CONSTANTS: GC_CUSTOM_CONTAINER_NAME2 TYPE SCRFNAME VALUE 'CCON2'.
*--------------------------------------------------------------------*






*--------------------------------------------------------------------*
*-----------------------트리를 위한 변수들---------------------------*
*--------------------------------------------------------------------*
*-- Database Table에서 조회 후 출력을 위한 Internal Tables
DATA: BEGIN OF GS_HEADER,
        BUKRS   LIKE ZEA_T001W-BUKRS,   " 회사코드
        MATTYPE LIKE ZEA_MMT010-MATTYPE,
*        WERKS  LIKE ZEA_MMT190-WERKS,  " 플랜트 ID
*        PNAME1 LIKE ZEA_T001W-PNAME1,  " 플랜트명
*        SCODE  LIKE ZEA_MMT190-SCODE,  " 저장위치 ID
*        SNAME  LIKE ZEA_MMT060-SNAME,  " 저장위치명
        MATNR   LIKE ZEA_MMT190-MATNR,  " 자재코드
        MAKTX   LIKE ZEA_MMT020-MAKTX,  " 자재명
      END OF GS_HEADER,
      GT_HEADER LIKE TABLE OF GS_HEADER.

CONSTANTS: GC_CUSTOM_CONTAINER_NAME TYPE SCRFNAME VALUE 'CCON'.


DATA: BEGIN OF GS_HEADER_2,
        WERKS  LIKE ZEA_MMT190-WERKS,
        PNAME1 LIKE ZEA_T001W-PNAME1,
        SCODE  LIKE ZEA_MMT190-SCODE,
        STYPE  LIKE ZEA_MMT060-STYPE,
      END OF GS_HEADER_2,
      GT_HEADER_2 LIKE TABLE OF GS_HEADER_2.

DATA: BEGIN OF GS_NODE_INFO_2,
        NODE_KEY LIKE MTREESNODE-NODE_KEY,
        WERKS    LIKE ZEA_MMT190-WERKS,
        SCODE    LIKE ZEA_MMT190-SCODE,
      END OF GS_NODE_INFO_2,

      GT_NODE_INFO_2 LIKE TABLE OF GS_NODE_INFO_2.

*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*

DATA: GO_DOCKING_CONTAINER TYPE REF TO CL_GUI_DOCKING_CONTAINER, " TREE용
      GO_DOCK              TYPE REF TO CL_GUI_DOCKING_CONTAINER, " ALV 세부 데이터용
      GT_DOCK              LIKE TABLE OF GO_DOCK,                " GO_DOCK을 쌓아둘 ITAB
      GO_CUSTOM_CONTAINER  TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      GCL_DOCUMENT         TYPE REF TO CL_DD_DOCUMENT,

      GO_SIMPLE_TREE       TYPE REF TO CL_GUI_SIMPLE_TREE,
      GO_ALV_GRID          TYPE REF TO CL_GUI_ALV_GRID,

      GO_CONTAINER_1       TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      GO_CONTAINER_2       TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      GO_CONTAINER_3       TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      GO_CONTAINER_4       TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      GO_ALV_GRID_1        TYPE REF TO CL_GUI_ALV_GRID,
      GO_ALV_GRID_2        TYPE REF TO CL_GUI_ALV_GRID,
      GO_ALV_GRID_3        TYPE REF TO CL_GUI_ALV_GRID,
      GO_ALV_GRID_4        TYPE REF TO CL_GUI_ALV_GRID.
*      GO_EVENT_HANDLER     TYPE REF TO LCL_EVENT_HANDLER.

DATA: GS_VARIANT    TYPE DISVARIANT,
      GV_SAVE       TYPE C,

      GT_FIELDCAT   TYPE LVC_T_FCAT,
      GS_FIELDCAT   TYPE LVC_S_FCAT,

      GT_FIELDCAT2  TYPE LVC_T_FCAT,
      GS_FIELDCAT2  TYPE LVC_S_FCAT,

      GT_FIELDCAT3  TYPE LVC_T_FCAT,
      GS_FIELDCAT3  TYPE LVC_S_FCAT,

      GT_FIELDCAT4  TYPE LVC_T_FCAT,
      GS_FIELDCAT4  TYPE LVC_S_FCAT,

      GS_LAYOUT     TYPE LVC_S_LAYO,

      GT_FILTER     TYPE LVC_T_FILT,
      GS_FILTER     TYPE LVC_S_FILT,

      GV_REPID      LIKE SY-REPID, " TEXT
      GV_DYNNR      LIKE SY-DYNNR, " TEXT

      GT_INDEX_ROWS TYPE LVC_T_ROW,
      GS_INDEX_ROWS TYPE LVC_S_ROW,

      OK_CODE       TYPE SY-UCOMM,
      GV_LINES      TYPE SY-TFILL,
      GV_SELECTED   TYPE I,
      GV_ANSWER     TYPE CHAR1,
      GV_SDATE      TYPE ZEA_PPT020-SDATE,
      GV_EDATE      TYPE ZEA_PPT020-EDATE,
      GV_CHANGED.

*-- TREE 관련 변수
DATA: GT_NODE     TYPE TABLE OF MTREESNODE,
      GS_NODE     LIKE LINE OF GT_NODE,
      GV_NODE_KEY TYPE N LENGTH 6.

DATA: BEGIN OF GS_NODE_INFO,
        NODE_KEY LIKE MTREESNODE-NODE_KEY,
        BUKRS    LIKE ZEA_T001W-BUKRS,   " 회사코드
        WERKS    LIKE ZEA_MMT190-WERKS,
        MATTYPE  LIKE ZEA_MMT010-MATTYPE,
        MATNR    LIKE ZEA_MMT190-MATNR,
        SCODE    LIKE ZEA_MMT190-SCODE,
      END OF GS_NODE_INFO,

      GT_NODE_INFO LIKE TABLE OF GS_NODE_INFO.

*----------------------------------------------------------------------*
* Common MACRO
*----------------------------------------------------------------------*
DEFINE _MC_POPUP_CONFIRM.
  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      TITLEBAR              = &1
*      DISPLAY_CANCEL_BUTTON = ''
      TEXT_QUESTION         = &2
      TEXT_BUTTON_1         = 'YES'
      ICON_BUTTON_1         = '@2K@'
      TEXT_BUTTON_2         = 'NO'
      ICON_BUTTON_2         = '@2O@ '
    IMPORTING
      ANSWER                = &3
    EXCEPTIONS
      TEXT_NOT_FOUND        = 1
      OTHERS                = 2.
END-OF-DEFINITION.
*** INCLUDE ZEA_MM090TOP
*** INCLUDE ZEA_MM090TOP
