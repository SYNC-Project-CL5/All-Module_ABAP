*&---------------------------------------------------------------------*
*& Include          YE12_PJ034_TOP
*&---------------------------------------------------------------------*
TABLES: ZEA_SDT040, ZEA_SDT050, ZEA_KNA1, ZEA_KNKK.

CONSTANTS: GC_NO_FILTER TYPE STRING VALUE 'NO_FILTER',
           GC_GASOLINE   TYPE STRING VALUE 'GASOLINE',
           GC_ELECTRIC   TYPE STRING VALUE 'ELECTRIC'.


DATA ICON LIKE ICON-ID.

*** 고객정보를 출력할 데이터를 보관하는 Internal Table
DATA: BEGIN OF GS_BPDATA,
        CUSCODE TYPE ZEA_KNA1-CUSCODE,
        SAKNR   TYPE ZEA_KNA1-SAKNR,
        BPCUS   TYPE ZEA_KNA1-BPCUS,
        BPCSNR  TYPE ZEA_KNA1-BPCSNR,
        BPHAED  TYPE ZEA_KNA1-BPHAED,
        BPADRR  TYPE ZEA_KNA1-BPADRR,
        BPSTAT  TYPE ZEA_KNA1-BPSTAT,
        ZLSCH   TYPE ZEA_KNA1-ZLSCH,
        LAND1   TYPE ZEA_KNA1-LAND1,
      END OF GS_BPDATA.
DATA: GT_BPDATA LIKE TABLE OF GS_BPDATA.


*** 첫번째 ALV에 출력할 데이터를 보관하는 Internal Table
DATA: BEGIN OF GS_DATA1,
        VBELN   TYPE ZEA_SDT040-VBELN,
        CUSCODE TYPE ZEA_SDT040-CUSCODE,
        SADDR   TYPE ZEA_SDT040-SADDR,
        VDATU   TYPE ZEA_SDT040-VDATU,
        ADATU   TYPE ZEA_SDT040-ADATU,
        ODDAT   TYPE ZEA_SDT040-ODDAT,
        TOAMT   TYPE ZEA_SDT040-TOAMT,
        WAERS   TYPE ZEA_SDT040-WAERS,
        STATUS2  TYPE ZEA_SDT040-STATUS,
        ERNAM   TYPE ZEA_SDT040-ERNAM,
        ERDAT   TYPE ZEA_SDT040-ERDAT,
        ERZET   TYPE ZEA_SDT040-ERZET,
        AENAM   TYPE ZEA_SDT040-AENAM,
        AEDAT   TYPE ZEA_SDT040-AEDAT,
        AEZET   TYPE ZEA_SDT040-AEZET,
      END OF GS_DATA1.
DATA: GT_DATA1 LIKE TABLE OF GS_DATA1.

*DATA GS_DISPLAY1 LIKE LINE OF GT_DATA1.
*DATA: GT_DISPLAY1 LIKE TABLE OF GS_DISPLAY1.

DATA: BEGIN OF GS_DISPLAY1.
        INCLUDE STRUCTURE GS_DATA1.
DATA:
*        STATUS LIKE ICON-ID, " 아이콘
        COLOR           TYPE C LENGTH 4, " 행 색상 정보
*        LIGHT           TYPE C,          " 신호등 표시를 위한
*                                         " EXCEPTION 필드
                                         " 0:비움 1:빨강 2:노랑 3:초록
        CELL_COLOR TYPE LVC_T_SCOL, " 셀 별 색상정보 인터널 테이블
*        STYLE           TYPE LVC_T_STYL, " 셀 스타일(모양)
*        MARK            TYPE CHAR1,      " 셀의 마킹 정보
      END OF GS_DISPLAY1.
DATA: GT_DISPLAY1 LIKE TABLE OF GS_DISPLAY1.


*** 두번째 ALV에 출력할 데이터를 보관하는 Internal Table
DATA: BEGIN OF GS_DATA2,
        VBELN    TYPE ZEA_SDT050-VBELN,
        POSNR    TYPE ZEA_SDT050-POSNR,
        MATNR    TYPE ZEA_SDT050-MATNR,
        MAKTX    TYPE ZEA_MMT020-MAKTX,
        CALQTY   TYPE ZEA_MMT190-CALQTY, " 재고량
        AUQUA    TYPE ZEA_SDT050-AUQUA,
        MEINS    TYPE ZEA_SDT050-MEINS,
        NETPR    TYPE ZEA_SDT050-NETPR,
        AUAMO    TYPE ZEA_SDT050-AUAMO,
        VALID_EN TYPE ZEA_SDT090-VALID_EN, " 단가유효종료일
        WAERS    TYPE ZEA_SDT050-WAERS,
        ERNAM    TYPE ZEA_SDT050-ERNAM,
        ERDAT    TYPE ZEA_SDT050-ERDAT,
        ERZET    TYPE ZEA_SDT050-ERZET,
        AENAM    TYPE ZEA_SDT050-AENAM,
        AEDAT    TYPE ZEA_SDT050-AEDAT,
        AEZET    TYPE ZEA_SDT050-AEZET,
      END OF GS_DATA2.
DATA: GT_DATA2 LIKE TABLE OF GS_DATA2.

DATA: BEGIN OF GS_DISPLAY2.
        INCLUDE STRUCTURE GS_DATA2.
DATA:
*        STATUS LIKE ICON-ID, " 아이콘
        COLOR           TYPE C LENGTH 4, " 행 색상 정보
        LIGHT           TYPE C,          " 신호등 표시를 위한
*                                         " EXCEPTION 필드
                                         " 0:비움 1:빨강 2:노랑 3:초록
        IT_FIELD_COLORS TYPE LVC_T_SCOL, " 셀 별 색상정보 인터널 테이블
        STYLE           TYPE LVC_T_STYL, " 셀 스타일(모양)
        MARK            TYPE CHAR1,      " 셀의 마킹 정보
      END OF GS_DISPLAY2.
DATA: GT_DISPLAY2 LIKE TABLE OF GS_DISPLAY2.


*** ALV 변수들
DATA: GO_CONTAINER1 TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      GO_ALV_GRID1  TYPE REF TO CL_GUI_ALV_GRID,
      GO_CONTAINER2 TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      GO_ALV_GRID2  TYPE REF TO CL_GUI_ALV_GRID.
DATA: GS_VARIANT    TYPE DISVARIANT,
      GV_SAVE       TYPE C,
      GS_VARIANT2   TYPE DISVARIANT,
      GV_SAVE2      TYPE C,

      GT_FIELDCAT   TYPE LVC_T_FCAT,
      GS_FIELDCAT   TYPE LVC_S_FCAT,
*      GT_FIELDCAT2  TYPE LVC_T_FCAT,
*      GS_FIELDCAT2  TYPE LVC_S_FCAT,

      GS_LAYOUT     TYPE LVC_S_LAYO,
      GS_LAYOUT2    TYPE LVC_S_LAYO,

      GT_FILTER     TYPE LVC_T_FILT,
      GS_FILTER     TYPE LVC_S_FILT,

      GT_INDEX_ROWS TYPE LVC_T_ROW,
      GS_INDEX_ROWS TYPE LVC_S_ROW,

      GT_TOOLBAR    TYPE UI_FUNCTIONS,

      OK_CODE       TYPE SY-UCOMM,
      GV_LINES      TYPE SY-TFILL,
      GV_ANSWER     TYPE CHAR1,
      GV_CHANGED    TYPE CHAR1,
      GV_SCR_ON     TYPE CHAR1.


*** TAB STRIP 에 사용할 변수들
" GV_SUBSCREEN  변수는 화면 번호를 저장 - 초기값으로 0101 설정
" GV_PRESSEDTAB 변수는 눌린 탭을 저장
" GO_TAB        변수는 TAB STRIP 컨트롤을 사용할 때 필요한 변수

DATA : GV_SUBSCREEN  TYPE SY-DYNNR VALUE '0120',
       GV_PRESSEDTAB TYPE SY-UCOMM VALUE 'TAB2'. "TABSTRIP FUCTION CODE

" 화면의 Tabstrip과 연동할 제어변수 선언방법
" CONTROLS : 화면의 TABSTRIP 과 동일한 이름: TYPE TABSTRIP.
CONTROLS: GO_TAB TYPE TABSTRIP.

CONSTANTS: GC_MODE_DISPLAY VALUE 'D',
           GC_MODE_CREATE  VALUE 'C',
           GC_MODE_CREATE_ITEM VALUE 'I',
           GC_MODE_SAVED VALUE 'S'.
DATA: GV_MODE TYPE C VALUE GC_MODE_DISPLAY.

* 라디오버튼 제어하는 변수
DATA: BEGIN OF GS_RBGROUP,
      RA1(1) TYPE C,
      RA2(1) TYPE C,
      END OF GS_RBGROUP.

*----------------------------------------------------------------------*
* Confirm Pop-Up
*----------------------------------------------------------------------*
* _mc_confirm '수입신고 의뢰' '저장하시겠습니까?' gv_answer.
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
