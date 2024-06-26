*&---------------------------------------------------------------------*
*& Include MZEA_PP100TOP                            - Module Pool      SAPMZEA_PPT100
*&---------------------------------------------------------------------*
PROGRAM SAPMZEA_PPT100 MESSAGE-ID ZEA_MSG.

TABLES: ZEA_AUFK, ZEA_T001W, ZEA_MMT020.

CLASS LCL_EVENT_HANDLER DEFINITION DEFERRED.

*--------------------------------------------------------------------*
* CONSTANTS
*--------------------------------------------------------------------*

CONSTANTS: GC_NO_FILTER TYPE STRING VALUE 'NO_FILTER',
           GC_APPROVE   TYPE STRING VALUE 'APPROVE',
           GC_REJECT    TYPE STRING VALUE 'REJECT',
           GC_WAIT      TYPE STRING VALUE 'WAIT'.

DATA: BEGIN OF GS_DATA,
        AUFNR     TYPE ZEA_AUFK-AUFNR,
        WERKS     TYPE ZEA_AUFK-WERKS,
        PLANID    TYPE ZEA_AUFK-PLANID,
        PNAME1    TYPE ZEA_T001W-PNAME1,
        MATNR     TYPE ZEA_AUFK-MATNR,
        MAKTX     TYPE ZEA_MMT020-MAKTX,
        TOT_QTY   TYPE ZEA_AUFK-TOT_QTY,
        MEINS     TYPE ZEA_AUFK-MEINS,
        APPROVAL  TYPE ZEA_AUFK-APPROVAL,
        APPROVER  TYPE ZEA_AUFK-APPROVER,
        REJREASON TYPE ZEA_AUFK-REJREASON,
        LOEKZ     TYPE ZEA_AUFK-LOEKZ,
        ERNAM     TYPE ZEA_AUFK-ERNAM,
        ERDAT     TYPE ZEA_AUFK-ERDAT,
        ERZET     TYPE ZEA_AUFK-ERZET,
        AENAM     TYPE ZEA_AUFK-AENAM,
        AEDAT     TYPE ZEA_AUFK-AEDAT,
        AEZET     TYPE ZEA_AUFK-AEZET,
      END OF GS_DATA.

DATA GT_DATA LIKE TABLE OF GS_DATA.

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

DATA: BEGIN OF GS_DATA2,
        AUFNR    TYPE ZEA_PPT020-AUFNR,
        ORDIDX   TYPE ZEA_PPT020-ORDIDX,
        MATNR    TYPE ZEA_PPT020-MATNR,
        MAKTX    TYPE ZEA_MMT020-MAKTX,
        BOMID    TYPE ZEA_PPT020-BOMID,
        WERKS    TYPE ZEA_PPT020-WERKS,
        PNAME1  TYPE ZEA_T001W-PNAME1,
        EXPQTY   TYPE ZEA_PPT020-EXPQTY,
        EXPSDATE TYPE ZEA_PPT020-EXPSDATE,
        EXPEDATE TYPE ZEA_PPT020-EXPEDATE,
        SDATE    TYPE ZEA_PPT020-SDATE,
        EDATE    TYPE ZEA_PPT020-EDATE,
        ISPDATE  TYPE ZEA_PPT020-ISPDATE,
        REPQTY   TYPE ZEA_PPT020-REPQTY,
        RQTY     TYPE ZEA_PPT020-RQTY,
        UNIT     TYPE ZEA_PPT020-UNIT,
        LOEKZ    TYPE ZEA_PPT020-LOEKZ,
        ERNAM    TYPE ZEA_PPT020-ERNAM,
        ERDAT    TYPE ZEA_PPT020-ERDAT,
        ERZET    TYPE ZEA_PPT020-ERZET,
        AENAM    TYPE ZEA_PPT020-AENAM,
        AEDAT    TYPE ZEA_PPT020-AEDAT,
        AEZET    TYPE ZEA_PPT020-AEZET,
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

DATA: GO_CONTAINER     TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      GO_SPLIT         TYPE REF TO CL_GUI_SPLITTER_CONTAINER,
      GO_CON_TOP       TYPE REF TO CL_GUI_CONTAINER,
      GO_CON_BOT       TYPE REF TO CL_GUI_CONTAINER,
      GO_ALV_GRID_TOP  TYPE REF TO CL_GUI_ALV_GRID,
      GO_ALV_GRID_BOT  TYPE REF TO CL_GUI_ALV_GRID,
      GO_EVENT_HANDLER TYPE REF TO LCL_EVENT_HANDLER.

DATA: GS_VARIANT    TYPE DISVARIANT,
      GV_SAVE       TYPE C,

      GT_FIELDCAT   TYPE LVC_T_FCAT,
      GS_FIELDCAT   TYPE LVC_S_FCAT,
      GT_FIELDCAT2  TYPE LVC_T_FCAT,
      GS_FIELDCAT2  TYPE LVC_S_FCAT,

      GS_LAYOUT     TYPE LVC_S_LAYO,
      GS_LAYOUT2    TYPE LVC_S_LAYO,

      GT_FILTER     TYPE LVC_T_FILT,
      GS_FILTER     TYPE LVC_S_FILT,

      GT_INDEX_ROWS TYPE LVC_T_ROW,
      GS_INDEX_ROWS TYPE LVC_S_ROW,

      GT_DROPDOWN   TYPE LVC_T_DROP,
      GS_DROPDOWN   TYPE LVC_S_DROP,

      OK_CODE       TYPE SY-UCOMM,
      GV_LINES      TYPE SY-TFILL,
      GV_ANSWER     TYPE CHAR1,
      GV_CHANGED.





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
