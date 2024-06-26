*&---------------------------------------------------------------------*
*& Include MZEA_PP110TOP                            - Module Pool      SAPMZEA_PP110
*&---------------------------------------------------------------------*
PROGRAM SAPMZEA_PP110 MESSAGE-ID ZEA_MSG.

TABLES: ZEA_PLKO,
        ZEA_PLPO,
        ZEA_T001W,
        ZEA_MMT020.

CLASS LCL_EVENT_HANDLER DEFINITION DEFERRED.

*--------------------------------------------------------------------*
* CONSTANTS
*--------------------------------------------------------------------*

CONSTANTS: GC_NO_FILTER TYPE STRING VALUE 'NO_FILTER',
           GC_WAIT      TYPE STRING VALUE 'WAIT',
           GC_PROCESS   TYPE STRING VALUE 'PROCESS',
           GC_COMPLETE  TYPE STRING VALUE 'COMPLETE',
           GC_DOPROCESS TYPE STRING VALUE 'DOPROCESS',
           GC_GOPROCESS TYPE STRING VALUE 'GOPROCESS'.

RANGES GR_RTID   FOR ZEA_PLPO-RTID.

* 화면의 Tabstrip과 연동할 제어변수 선언방법
* CONTROLS : 화면의 TABSTRIP 과 동일한 이름: TYPE TABSTRIP.
CONTROLS TABSTRIP TYPE TABSTRIP.
DATA GV_DYNNR TYPE SY-DYNNR VALUE '0110'.

* Routing Header
DATA: BEGIN OF GS_DATA,
        RTID   TYPE ZEA_PLKO-RTID,
        RTSTEP TYPE ZEA_PLPO-RTSTEP,
        AUFNR  TYPE ZEA_PLKO-AUFNR,
        WERKS  TYPE ZEA_PLKO-WERKS,
*        PNAME1 TYPE ZEA_T001W-PNAME1,
        MATNR  TYPE ZEA_PLKO-MATNR,
        MAKTX  TYPE ZEA_MMT020-MAKTX,
        QTY    TYPE ZEA_PLKO-QTY,
        UNIT   TYPE ZEA_PLKO-UNIT,
*        RTNAME TYPE ZEA_PLKO-RTNAME,
        RTST   TYPE ZEA_PLKO-RTST,
        RTET   TYPE ZEA_PLKO-RTET,
*        LOEKZ  TYPE ZEA_PLKO-LOEKZ,
        ERNAM  TYPE ZEA_PLKO-ERNAM,
        ERDAT  TYPE ZEA_PLKO-ERDAT,
        ERZET  TYPE ZEA_PLKO-ERZET,
        AENAM  TYPE ZEA_PLKO-AENAM,
        AEDAT  TYPE ZEA_PLKO-AEDAT,
        AEZET  TYPE ZEA_PLKO-AEZET,
      END OF GS_DATA.

DATA: GT_DATA LIKE TABLE OF GS_DATA.

*DATA: GT_DATA TYPE TABLE OF SPFLI,
*      GS_DATA TYPE SPFLI.

DATA: BEGIN OF GS_DISPLAY.
        INCLUDE STRUCTURE GS_DATA.
DATA:   STATUS          LIKE ICON-ID, " 아이콘
        COLOR           TYPE C LENGTH 4, " 행 색상 정보
        LIGHT           TYPE C,          " 신호등 표시를 위한
        " EXCEPTION 필드
        " 0:비움 1:빨강 2:노랑 3:초록
        IT_FIELD_COLORS TYPE LVC_T_SCOL, " 셀 별 색상정보 인터널 테이블
        STYLE           TYPE LVC_T_STYL, " 셀 스타일(모양)
        MARK            TYPE CHAR1,      " 셀의 마킹 정보
      END OF GS_DISPLAY.

DATA: GT_DISPLAY LIKE TABLE OF GS_DISPLAY.

* Routing Item
DATA: BEGIN OF GS_DATA2,
        RTID    TYPE ZEA_PLPO-RTID,
        RTIDX   TYPE ZEA_PLPO-RTIDX,
        WCID    TYPE ZEA_PLPO-WCID,
        RTSTEP  TYPE ZEA_PLPO-RTSTEP,
        RTDNAME TYPE ZEA_PLPO-RTDNAME,
        RTPERC  TYPE ZEA_PLPO-RTPERC,
        RTST    TYPE ZEA_PLPO-RTST,
        RTET    TYPE ZEA_PLPO-RTET,
        ERNAM   TYPE ZEA_PLPO-ERNAM,
        ERDAT   TYPE ZEA_PLPO-ERDAT,
        ERZET   TYPE ZEA_PLPO-ERZET,
        AENAM   TYPE ZEA_PLPO-AENAM,
        AEDAT   TYPE ZEA_PLPO-AEDAT,
        AEZET   TYPE ZEA_PLPO-AEZET,
      END OF GS_DATA2.


DATA: GT_DATA2 LIKE TABLE OF GS_DATA2.

DATA: BEGIN OF GS_DISPLAY2.
        INCLUDE STRUCTURE GS_DATA2.
DATA:   STATUS          LIKE ICON-ID, " 아이콘
        COLOR           TYPE C LENGTH 4, " 행 색상 정보
        LIGHT           TYPE C,          " 신호등 표시를 위한
        " EXCEPTION 필드
        " 0:비움 1:빨강 2:노랑 3:초록
        IT_FIELD_COLORS TYPE LVC_T_SCOL, " 셀 별 색상정보 인터널 테이블
        STYLE           TYPE LVC_T_STYL, " 셀 스타일(모양)
        MARK            TYPE CHAR1,      " 셀의 마킹 정보
      END OF GS_DISPLAY2.

DATA: GT_DISPLAY2 LIKE TABLE OF GS_DISPLAY2.

DATA: GS_FIELD_COLOR TYPE LVC_S_SCOL.

DATA : BEGIN OF GS_STPO, "원자재 계산을 위한 인터널 테이블
          BOMID    TYPE ZEA_STPO-BOMID,
          BOMINDEX TYPE ZEA_STPO-BOMINDEX,
          MATNR    TYPE ZEA_STPO-MATNR,
          MAKTX    TYPE ZEA_MMT020-MAKTX,
          MATTYPE  TYPE ZEA_MMT010-MATTYPE,
          MENGE    TYPE ZEA_STPO-MENGE,
          MEINS    TYPE ZEA_STPO-MEINS,
        END OF GS_STPO.

  DATA: GT_STPO LIKE TABLE OF GS_STPO.

" 사진 업로드를 위한 변수 선언
DATA: URL              TYPE CNDP_URL,
      PIC1             TYPE REF TO CL_GUI_PICTURE,
      CONTAINER1       TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      GT_WWWTAB        LIKE WWWPARAMS OCCURS 0 WITH HEADER LINE,

      " TIMER 사용을 위한 변수 선언
      GO_TIMER         TYPE REF TO CL_GUI_TIMER,

      GO_CONTAINER     TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      GO_CONTAINER_1   TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      GO_ALV_GRID      TYPE REF TO CL_GUI_ALV_GRID,
      GO_ALV_GRID_1    TYPE REF TO CL_GUI_ALV_GRID,
      GO_EVENT_HANDLER TYPE REF TO LCL_EVENT_HANDLER.

DATA: GS_VARIANT    TYPE DISVARIANT,
      GV_SAVE       TYPE C,

      GT_FIELDCAT   TYPE LVC_T_FCAT,
      GS_FIELDCAT   TYPE LVC_S_FCAT,

      GS_LAYOUT     TYPE LVC_S_LAYO,
      GS_LAYOUT_1   TYPE LVC_S_LAYO,

      GT_FILTER     TYPE LVC_T_FILT,
      GS_FILTER     TYPE LVC_S_FILT,

      GT_INDEX_ROWS TYPE LVC_T_ROW,
      GS_INDEX_ROWS TYPE LVC_S_ROW,

      OK_CODE       TYPE SY-UCOMM,
      GV_LINES      TYPE SY-TFILL,
      GV_COUNT      TYPE I,
      GV_ANSWER     TYPE CHAR1,
      GV_TAB6       TYPE CHAR1,
      GV_CHANGED    TYPE CHAR1,
      GV_BOMID      TYPE ZEA_PPT020-BOMID,
      GV_TOT_QTY    TYPE ZEA_AUFK-TOT_QTY,
      GV_CHECK.

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
