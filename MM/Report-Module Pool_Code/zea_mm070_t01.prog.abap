*&---------------------------------------------------------------------*
*& Include          ZEA_MM070_T01
*&---------------------------------------------------------------------*
*&----------------------------------------------------------------------
*&
*&  TYPE-POOL
*&----------------------------------------------------------------------
TYPE-POOLS : SLIS,
             ABAP,
             ICON.

*&----------------------------------------------------------------------
*&
*&  TABLES
*&----------------------------------------------------------------------
TABLES: ZEA_MMT130,"[MM] 구매요청 테이블
        ZEA_MMT140,"[MM] 구매오더 Header
        ZEA_MMT150,"[MM] 구매오더 Item
        ZEA_LFA1,  "[FI] 벤더 테이블
        ZEA_TVZBT. "[FI] 지급조건 테이블

*&--------------------------------------------------------------------*
*&
*&  SCREEN VARIABLE
*&--------------------------------------------------------------------*
DATA : OK_CODE LIKE SY-UCOMM.

DATA: BEGIN OF GT_EXCLUDE OCCURS 0,"
        STATUS_NAME(30),
      END OF GT_EXCLUDE.

*&--------------------------------------------------------------------*
*&
*&  INTERNAL TABLE
*&--------------------------------------------------------------------*
DATA: BEGIN OF GT_DISP1 OCCURS 0.
DATA:   ICON       LIKE ICON-ID,
        PONUM      LIKE ZEA_MMT140-PONUM,
        EBELP      LIKE ZEA_MMT150-EBELP,
        BANFN      LIKE ZEA_MMT150-BANFN,
        MATNR      LIKE ZEA_MMT150-MATNR,
        INFO_NO    LIKE ZEA_MMT150-INFO_NO,
        WERKS      LIKE ZEA_MMT150-WERKS,
        SCODE      LIKE ZEA_MMT150-SCODE,
        CALQTY     LIKE ZEA_MMT150-CALQTY,
        MEINS      LIKE ZEA_MMT150-MEINS,
        DMBTR      LIKE ZEA_MMT150-DMBTR,
        WAERS      LIKE ZEA_MMT150-WAERS.
DATA: SELECTED TYPE C."선택된 ROW
DATA: END OF GT_DISP1.

DATA: BEGIN OF GT_DISP2 OCCURS 0.
DATA:  ICON   LIKE ICON-ID.
       INCLUDE STRUCTURE ZEA_MMT130.
DATA:  SELECTED TYPE C.
DATA: END OF GT_DISP2.

DATA: BEGIN OF GT_DISP3 OCCURS 0.
DATA:  LIGHT LIKE ZEA_MMT050-LOEKZ.
DATA:  LV_PERCENT LIKE ZEA_MMT050-MATNR.
       INCLUDE STRUCTURE ZEA_MMT190.
DATA:  MAKTX  LIKE ZEA_MMT020-MAKTX.
DATA:  SELECTED TYPE C.
DATA: END OF GT_DISP3.

DATA: BEGIN OF GT_DISP4 OCCURS 0,
        TEXT    LIKE ZEA_MMT090-MBLNR,   "내역
        ZLSCHYN LIKE ICON-ID,            "지급여부
        GJAHR   LIKE ZEA_MMT100-GJAHR,   "회계연도
        MBLNR   LIKE ZEA_MMT090-MBLNR,   "자재문서, 송장 같이사용
        MBGNO   LIKE ZEA_MMT100-MBGNO,   "문서 항목
        BWART   LIKE ZEA_MMT100-BWART,   "이동유형
        MATNR   LIKE ZEA_MMT100-MATNR,   "자재코드
        PONUM   LIKE ZEA_MMT100-PONUM,   "구매오더
        PLANTFR LIKE ZEA_MMT100-PLANTFR, "From 플랜트
        LGORTFR LIKE ZEA_MMT100-LGORTFR, "From 저장위치
        PLANTTO LIKE ZEA_MMT100-PLANTTO, "To 플랜트
        LGORTTO LIKE ZEA_MMT100-LGORTTO, "To 저장위치
        MENGE   LIKE ZEA_MMT100-MENGE,   "수량
        MEINS   LIKE ZEA_MMT100-MEINS,   "단위
        DMBTR   LIKE ZEA_MMT100-DMBTR,   "금액
        WAERS1  LIKE ZEA_MMT100-WAERS1,  "통화
        GRUND   LIKE ZEA_MMT100-GRUND,   "텍스트
      END OF GT_DISP4.

*&--------------------------------------------------------------------*
*&
*&  ALV VARIABLE
*&--------------------------------------------------------------------*
DATA : GO_CONTAINER1 TYPE REF TO CL_GUI_CUSTOM_CONTAINER.
DATA : GO_CONTAINER2 TYPE REF TO CL_GUI_CUSTOM_CONTAINER.
DATA : GO_CONTAINER3 TYPE REF TO CL_GUI_CUSTOM_CONTAINER.
DATA : GO_CONTAINER4 TYPE REF TO CL_GUI_CUSTOM_CONTAINER.

DATA : GO_GRID1     TYPE REF TO CL_GUI_ALV_GRID.
DATA : GO_GRID2     TYPE REF TO CL_GUI_ALV_GRID.
DATA : GO_GRID3     TYPE REF TO CL_GUI_ALV_GRID.
DATA : GO_GRID4     TYPE REF TO CL_GUI_ALV_GRID.

DATA : GT_FCAT1 TYPE LVC_T_FCAT.
DATA : GT_FCAT2 TYPE LVC_T_FCAT.
DATA : GT_FCAT3 TYPE LVC_T_FCAT.
DATA : GT_FCAT4 TYPE LVC_T_FCAT.

DATA : GS_LAYO1 TYPE LVC_S_LAYO.
DATA : GS_LAYO2 TYPE LVC_S_LAYO.
DATA : GS_LAYO3 TYPE LVC_S_LAYO.
DATA : GS_LAYO4 TYPE LVC_S_LAYO.

DATA : GT_SORT1 TYPE LVC_T_SORT.
DATA : GT_SORT2 TYPE LVC_T_SORT.
DATA : GT_SORT3 TYPE LVC_T_SORT.
DATA : GT_SORT4 TYPE LVC_T_SORT.

DATA : GO_CONTAINER TYPE REF TO CL_GUI_CUSTOM_CONTAINER.
DATA : GO_SPLITTER  TYPE REF TO CL_GUI_SPLITTER_CONTAINER.
DATA : GO_ALV_CON2  TYPE REF TO CL_GUI_CONTAINER.
DATA : GO_ALV_CON3  TYPE REF TO CL_GUI_CONTAINER.

*&--------------------------------------------------------------------*
*&
*&  CLASS
*&--------------------------------------------------------------------*
CLASS LCL_EVENT_RECEIVER DEFINITION.
  PUBLIC SECTION.

  METHODS:
       HANDLE_HOTSPOT_CLICK1
       FOR EVENT HOTSPOT_CLICK  OF CL_GUI_ALV_GRID
       IMPORTING E_ROW_ID
                 E_COLUMN_ID
                 ES_ROW_NO,
       HANDLE_USER_COMMAND1
       FOR EVENT USER_COMMAND   OF CL_GUI_ALV_GRID
       IMPORTING E_UCOMM,

       HANDLE_TOOLBAR1
       FOR EVENT TOOLBAR        OF CL_GUI_ALV_GRID
       IMPORTING E_OBJECT
                 E_INTERACTIVE,


       HANDLE_USER_COMMAND2
       FOR EVENT USER_COMMAND   OF CL_GUI_ALV_GRID
       IMPORTING E_UCOMM,

       HANDLE_TOOLBAR2
       FOR EVENT TOOLBAR        OF CL_GUI_ALV_GRID
       IMPORTING E_OBJECT
                 E_INTERACTIVE,

       HANDLE_USER_COMMAND3
       FOR EVENT USER_COMMAND   OF CL_GUI_ALV_GRID
       IMPORTING E_UCOMM,

       HANDLE_TOOLBAR3
       FOR EVENT TOOLBAR        OF CL_GUI_ALV_GRID
       IMPORTING E_OBJECT
                 E_INTERACTIVE,

       HANDLE_TOOLBAR4
       FOR EVENT TOOLBAR        OF CL_GUI_ALV_GRID
       IMPORTING E_OBJECT
                 E_INTERACTIVE.

ENDCLASS.
CLASS LCL_EVENT_RECEIVER IMPLEMENTATION.
  METHOD HANDLE_HOTSPOT_CLICK1.
    PERFORM HANDLE_HOTSPOT_CLICK1 USING E_ROW_ID
                                        E_COLUMN_ID
                                        ES_ROW_NO.
  ENDMETHOD.
  METHOD HANDLE_TOOLBAR1.
    PERFORM HANDLE_TOOLBAR1 USING E_OBJECT
                                  E_INTERACTIVE.
  ENDMETHOD.
  METHOD HANDLE_USER_COMMAND1.
    PERFORM HANDLE_USER_COMMAND1 USING E_UCOMM.
  ENDMETHOD.

  METHOD HANDLE_TOOLBAR2.
    PERFORM HANDLE_TOOLBAR2 USING E_OBJECT
                                  E_INTERACTIVE.
  ENDMETHOD.
  METHOD HANDLE_USER_COMMAND2.
    PERFORM HANDLE_USER_COMMAND2 USING E_UCOMM.
  ENDMETHOD.

  METHOD HANDLE_TOOLBAR3.
    PERFORM HANDLE_TOOLBAR3 USING E_OBJECT
                                  E_INTERACTIVE.
  ENDMETHOD.
  METHOD HANDLE_USER_COMMAND3.
    PERFORM HANDLE_USER_COMMAND3 USING E_UCOMM.
  ENDMETHOD.

  METHOD HANDLE_TOOLBAR4.
    PERFORM HANDLE_TOOLBAR4 USING E_OBJECT
                                  E_INTERACTIVE.
  ENDMETHOD.

ENDCLASS.
DATA : LCL_EVENT_RECEIVER TYPE REF TO LCL_EVENT_RECEIVER.
