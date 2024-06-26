*&---------------------------------------------------------------------*
*& Include SAPMZEA_03TOP                            - Module Pool      SAPMZEA_03
*&---------------------------------------------------------------------*

PROGRAM SAPMZEA_03 MESSAGE-ID ZEA_MSG.

TABLES: ZEA_AUFK, ZEA_AFRU, ZEA_T001W, ZEA_MMT020, ZEA_PPT020, ZEA_PA0000,
        ZEA_MMT070, ZEA_MMT010, ZEA_HRT010.

CLASS LCL_EVENT_HANDLER DEFINITION DEFERRED.

CONSTANTS: GC_NO_FILTER  TYPE STRING VALUE 'NO_FILTER',
           GC_TRANSPORT    TYPE STRING VALUE 'USE_FILTER'.

*--------------------------------------------------------------------*
*--------------------------헤더--------------------------------------*
*--------------------------------------------------------------------*
DATA: BEGIN OF GS_DATA,
        AUFNR    TYPE ZEA_AUFK-AUFNR,     " 생산오더 ID
        WERKS    TYPE ZEA_AUFK-WERKS,     " 플랜트 ID
        PNAME1   TYPE ZEA_T001W-PNAME1,   " 플랜트명
        PLANID   TYPE ZEA_AUFK-PLANID,    " 생산계획 ID
        MATNR    TYPE ZEA_AUFK-MATNR,     " 자재코드
        MAKTX    TYPE ZEA_MMT020-MAKTX,   " 자재명
        TOT_QTY  TYPE ZEA_AUFK-TOT_QTY,   " 총 오더 수량
        MEINS    TYPE ZEA_AUFK-MEINS,     " 단위
        APPROVAL TYPE ZEA_AUFK-APPROVAL,  " 승인여부
        APPROVER TYPE ZEA_AUFK-APPROVER,  " 결재자
        SDATE    TYPE ZEA_PPT020-SDATE,   " 생산 시작일자
        EDATE    TYPE ZEA_PPT020-EDATE,   " 생산 종료일자
        ISPDATE  TYPE ZEA_PPT020-ISPDATE, " 검수완료일자
        REPQTY   TYPE ZEA_PPT020-REPQTY,  " 임시 검수수량,
        RQTY     TYPE ZEA_PPT020-RQTY,    " 최종 생산량
        UNIT     TYPE ZEA_PPT020-UNIT,    " 단위
        LOEKZ    TYPE ZEA_PPT020-LOEKZ,    " 삭제플래그
      END OF GS_DATA.

DATA GT_DATA LIKE TABLE OF GS_DATA.

DATA: BEGIN OF GS_DISPLAY.
        INCLUDE STRUCTURE GS_DATA.
DATA:   STATUS  LIKE ICON-ID, " 아이콘
        STATUS2 LIKE ICON-ID, " 아이콘
        " COLOR           TYPE C LENGTH 4, " 행 색상 정보
        LIGHT   TYPE C,          " 신호등 표시를 위한
        " EXCEPTION 필드
        " 0:비움 1:빨강 2:노랑 3:초록
        " IT_FIELD_COLORS TYPE LVC_T_SCOL, " 셀 별 색상정보 인터널 테이블
        " STYLE           TYPE LVC_T_STYL, " 셀 스타일(모양)
        " MARK            TYPE CHAR1,      " 셀의 마킹 정보
      END OF GS_DISPLAY.

DATA: GT_DISPLAY LIKE TABLE OF GS_DISPLAY.

*--------------------------------------------------------------------*
*--------------------------아이템------------------------------------*
*--------------------------------------------------------------------*

DATA: BEGIN OF GS_DATA2,
        AUFNR   TYPE ZEA_PPT020-AUFNR,   " 생산오더 ID
        ORDIDX  TYPE ZEA_PPT020-ORDIDX,  " 생산오더 Index
        MATNR   TYPE ZEA_PPT020-MATNR,   " 자재코드
        MAKTX   TYPE ZEA_MMT020-MAKTX,   " 자재명
        BOMID   TYPE ZEA_PPT020-BOMID,   " BOM ID
        WERKS   TYPE ZEA_PPT020-WERKS,   " 플랜트 ID
        PNAME1  TYPE ZEA_T001W-PNAME1,   " 플랜트명
        EXPQTY  TYPE ZEA_PPT020-EXPQTY,  " 예상 생산수량
        SDATE   TYPE ZEA_PPT020-SDATE,   " 생산 시작일자
        EDATE   TYPE ZEA_PPT020-EDATE,   " 생산 종료일자
        ISPDATE TYPE ZEA_PPT020-ISPDATE, " 검수완료 일자
        REPQTY  TYPE ZEA_PPT020-REPQTY,  " 임시검수 수량
        RQTY    TYPE ZEA_PPT020-RQTY,    " 생산완료 수량
        UNIT    TYPE ZEA_PPT020-UNIT,    " 단위
        LOEKZ   TYPE ZEA_PPT020-LOEKZ,   " 삭제 플래그
      END OF GS_DATA2.

DATA GT_DATA2 LIKE TABLE OF GS_DATA2.

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

*--------------------------------------------------------------------*
*--------------------------생산실적----------------------------------*
*--------------------------------------------------------------------*
DATA: BEGIN OF GS_DATA3,
        AUFNR     TYPE ZEA_AFRU-AUFNR,    " 생산오더 ID
        CHARG     TYPE ZEA_AFRU-CHARG,    " 배치번호
        MATNR     TYPE ZEA_AFRU-MATNR,    " 자재코드
        MAKTX     TYPE ZEA_MMT020-MAKTX,  " 자재명
        BOMID     TYPE ZEA_AFRU-BOMID,    " BOM ID
        EMPCODE   TYPE ZEA_AFRU-EMPCODE,  " 사원코드
        TSDAT     TYPE ZEA_AFRU-TSDAT,    " 생산 검수일자
        PDQUAN    TYPE ZEA_AFRU-PDQUAN,   " 생산량 (생산계획 수량)
        PDBAN     TYPE ZEA_AFRU-PDBAN,    " 폐기량 (검수불합격 수량)
        FNPD      TYPE ZEA_AFRU-FNPD,     " 최종생산량 (검수합격 수량)
        MEINS     TYPE ZEA_AFRU-MEINS,    " 단위
        DEFREASON TYPE ZEA_AFRU-DEFREASON,    " 불량 사유
        LOEKZ     TYPE ZEA_AFRU-LOEKZ,    " 삭제 플래그
      END OF GS_DATA3.

DATA GT_DATA3 LIKE TABLE OF GS_DATA3.

DATA: BEGIN OF GS_DISPLAY3.
        INCLUDE STRUCTURE GS_DATA3.
DATA:   STATUS LIKE ICON-ID, " 아이콘
*        COLOR           TYPE C LENGTH 4, " 행 색상 정보
*        LIGHT           TYPE C,          " 신호등 표시를 위한
        " EXCEPTION 필드
        " 0:비움 1:빨강 2:노랑 3:초록
*        IT_FIELD_COLORS TYPE LVC_T_SCOL, " 셀 별 색상정보 인터널 테이블
*        STYLE           TYPE LVC_T_STYL, " 셀 스타일(모양)
*        MARK            TYPE CHAR1,      " 셀의 마킹 정보
      END OF GS_DISPLAY3.

DATA: GT_DISPLAY3 LIKE TABLE OF GS_DISPLAY3.

DATA: GV_COMMENT TYPE ZEA_AFRU-DEFREASON. " TEXT 값 입력 받기 위해 선언

*--------------------------------------------------------------------*
*--------------------------재고 테이블-------------------------------*
*--------------------------------------------------------------------*
DATA: GT_MMT190 TYPE TABLE OF ZEA_MMT190,
      GS_MMT190 LIKE LINE OF  GT_MMT190.


*--------------------------------------------------------------------*
*------------------------자재마스터 테이블---------------------------*
*--------------------------------------------------------------------*
DATA: GT_MMT010 TYPE TABLE OF ZEA_MMT010,
      GS_MMT010 LIKE LINE OF  GT_MMT010.


*--------------------------------------------------------------------*
* 화면 구조 선언
*--------------------------------------------------------------------*

DATA: BEGIN OF S0100,
        PDQUAN1  TYPE ZEA_AFRU-PDQUAN,
        PDQUAN2  TYPE ZEA_AFRU-PDQUAN,
        PDQUAN3  TYPE ZEA_AFRU-PDQUAN,
        PDQUAN4  TYPE ZEA_AFRU-PDQUAN,
        PDQUAN5  TYPE ZEA_AFRU-PDQUAN,
        PDQUAN6  TYPE ZEA_AFRU-PDQUAN,
        PDQUAN7  TYPE ZEA_AFRU-PDQUAN,
        PDQUAN8  TYPE ZEA_AFRU-PDQUAN,
        PDQUAN9  TYPE ZEA_AFRU-PDQUAN,
        PDQUAN10 TYPE ZEA_AFRU-PDQUAN,
        PDQUAN11 TYPE ZEA_AFRU-PDQUAN,
        PDQUAN12 TYPE ZEA_AFRU-PDQUAN,
        PDQUAN13 TYPE ZEA_AFRU-PDQUAN,
        PDQUAN14 TYPE ZEA_AFRU-PDQUAN,
        PDQUAN15 TYPE ZEA_AFRU-PDQUAN,
        PDQUAN16 TYPE ZEA_AFRU-PDQUAN,
        PDQUAN17 TYPE ZEA_AFRU-PDQUAN,
        PDQUAN18 TYPE ZEA_AFRU-PDQUAN,
        PDQUAN19 TYPE ZEA_AFRU-PDQUAN,
        PDQUAN20 TYPE ZEA_AFRU-PDQUAN,
        PDQUAN21 TYPE ZEA_AFRU-PDQUAN,
        PDQUAN22 TYPE ZEA_AFRU-PDQUAN,
        PDQUAN23 TYPE ZEA_AFRU-PDQUAN,
        PDQUAN24 TYPE ZEA_AFRU-PDQUAN,
        PDBAN1   TYPE ZEA_AFRU-PDBAN,
        PDBAN2   TYPE ZEA_AFRU-PDBAN,
        PDBAN3   TYPE ZEA_AFRU-PDBAN,
        PDBAN4   TYPE ZEA_AFRU-PDBAN,
        PDBAN5   TYPE ZEA_AFRU-PDBAN,
        PDBAN6   TYPE ZEA_AFRU-PDBAN,
        PDBAN7   TYPE ZEA_AFRU-PDBAN,
        PDBAN8   TYPE ZEA_AFRU-PDBAN,
        PDBAN9   TYPE ZEA_AFRU-PDBAN,
        PDBAN10  TYPE ZEA_AFRU-PDBAN,
        PDBAN11  TYPE ZEA_AFRU-PDBAN,
        PDBAN12  TYPE ZEA_AFRU-PDBAN,
        PDBAN13  TYPE ZEA_AFRU-PDBAN,
        PDBAN14  TYPE ZEA_AFRU-PDBAN,
        PDBAN15  TYPE ZEA_AFRU-PDBAN,
        PDBAN16  TYPE ZEA_AFRU-PDBAN,
        PDBAN17  TYPE ZEA_AFRU-PDBAN,
        PDBAN18  TYPE ZEA_AFRU-PDBAN,
        PDBAN19  TYPE ZEA_AFRU-PDBAN,
        PDBAN20  TYPE ZEA_AFRU-PDBAN,
        PDBAN21  TYPE ZEA_AFRU-PDBAN,
        PDBAN22  TYPE ZEA_AFRU-PDBAN,
        PDBAN23  TYPE ZEA_AFRU-PDBAN,
        PDBAN24  TYPE ZEA_AFRU-PDBAN,
        FNPD1    TYPE ZEA_AFRU-FNPD,
        FNPD2    TYPE ZEA_AFRU-FNPD,
        FNPD3    TYPE ZEA_AFRU-FNPD,
        FNPD4    TYPE ZEA_AFRU-FNPD,
        FNPD5    TYPE ZEA_AFRU-FNPD,
        FNPD6    TYPE ZEA_AFRU-FNPD,
        FNPD7    TYPE ZEA_AFRU-FNPD,
        FNPD8    TYPE ZEA_AFRU-FNPD,
        FNPD9    TYPE ZEA_AFRU-FNPD,
        FNPD10   TYPE ZEA_AFRU-FNPD,
        FNPD11   TYPE ZEA_AFRU-FNPD,
        FNPD12   TYPE ZEA_AFRU-FNPD,
        FNPD13   TYPE ZEA_AFRU-FNPD,
        FNPD14   TYPE ZEA_AFRU-FNPD,
        FNPD15   TYPE ZEA_AFRU-FNPD,
        FNPD16   TYPE ZEA_AFRU-FNPD,
        FNPD17   TYPE ZEA_AFRU-FNPD,
        FNPD18   TYPE ZEA_AFRU-FNPD,
        FNPD19   TYPE ZEA_AFRU-FNPD,
        FNPD20   TYPE ZEA_AFRU-FNPD,
        FNPD21   TYPE ZEA_AFRU-FNPD,
        FNPD22   TYPE ZEA_AFRU-FNPD,
        FNPD23   TYPE ZEA_AFRU-FNPD,
        FNPD24   TYPE ZEA_AFRU-FNPD,
        UNIT1    TYPE ZEA_AFRU-MEINS,
        UNIT2    TYPE ZEA_AFRU-MEINS,
        UNIT3    TYPE ZEA_AFRU-MEINS,
        UNIT4    TYPE ZEA_AFRU-MEINS,
        UNIT5    TYPE ZEA_AFRU-MEINS,
        UNIT6    TYPE ZEA_AFRU-MEINS,
        UNIT7    TYPE ZEA_AFRU-MEINS,
        UNIT8    TYPE ZEA_AFRU-MEINS,
        UNIT9    TYPE ZEA_AFRU-MEINS,
        UNIT10   TYPE ZEA_AFRU-MEINS,
        UNIT11   TYPE ZEA_AFRU-MEINS,
        UNIT12   TYPE ZEA_AFRU-MEINS,
        UNIT13   TYPE ZEA_AFRU-MEINS,
        UNIT14   TYPE ZEA_AFRU-MEINS,
        UNIT15   TYPE ZEA_AFRU-MEINS,
        UNIT16   TYPE ZEA_AFRU-MEINS,
        UNIT17   TYPE ZEA_AFRU-MEINS,
        UNIT18   TYPE ZEA_AFRU-MEINS,
        UNIT19   TYPE ZEA_AFRU-MEINS,
        UNIT20   TYPE ZEA_AFRU-MEINS,
        UNIT21   TYPE ZEA_AFRU-MEINS,
        UNIT22   TYPE ZEA_AFRU-MEINS,
        UNIT23   TYPE ZEA_AFRU-MEINS,
        UNIT24   TYPE ZEA_AFRU-MEINS,
      END OF S0100.

DATA: GV_FNPD1 TYPE ZEA_AFRU-FNPD,
      GV_FNPD2 TYPE ZEA_AFRU-FNPD,
      GV_FNPD3 TYPE ZEA_AFRU-FNPD,
      GV_FNPD4 TYPE ZEA_AFRU-FNPD,
      GV_FNPD5 TYPE ZEA_AFRU-FNPD,
      GV_FNPD6 TYPE ZEA_AFRU-FNPD.

*--------------------------------------------------------------------*
*--------------------------------------------------------------------*
DATA: GO_CONTAINER    TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      GO_CONTAINER2   TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      GO_CONTAINER3   TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      GO_EDITOR       TYPE REF TO CL_GUI_TEXTEDIT, " TEXT
      GO_ALV_GRID     TYPE REF TO CL_GUI_ALV_GRID,
      GO_ALV_GRID_2   TYPE REF TO CL_GUI_ALV_GRID,
      GO_SPLIT        TYPE REF TO CL_GUI_SPLITTER_CONTAINER,
      GO_CON_TOP      TYPE REF TO CL_GUI_CONTAINER,
      GO_CON_BOT      TYPE REF TO CL_GUI_CONTAINER,
      GO_ALV_GRID_TOP TYPE REF TO CL_GUI_ALV_GRID,
      GO_ALV_GRID_BOT TYPE REF TO CL_GUI_ALV_GRID.
*      GO_EVENT_HANDLER TYPE REF TO LCL_EVENT_HANDLER.

DATA: GS_VARIANT    TYPE DISVARIANT,
      GV_SAVE       TYPE C,

      GT_FIELDCAT   TYPE LVC_T_FCAT,
      GS_FIELDCAT   TYPE LVC_S_FCAT,

      GT_FIELDCAT2  TYPE LVC_T_FCAT,
      GS_FIELDCAT2  TYPE LVC_S_FCAT,

      GT_FIELDCAT3  TYPE LVC_T_FCAT,
      GS_FIELDCAT3  TYPE LVC_S_FCAT,

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

*----------------------------------------------------------------------*
* TEXT 에디터를 위한 변수
*----------------------------------------------------------------------*
CONSTANTS: C_LENGTH TYPE I VALUE 256.


TYPES: BEGIN OF TY_LINE,
         LINE(C_LENGTH) TYPE C,
       END OF TY_LINE.

DATA GT_LINES   TYPE TABLE OF TY_LINE. " TEXT

DATA : READ_MODE TYPE I. " TEXT

DATA GV_SHOW_APPROVAL VALUE 'X'.

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


*** TAB STRIP 에 사용할 변수들
" GV_SUBSCREEN  변수는 화면 번호를 저장 - 초기값으로 0101 설정
" GV_PRESSEDTAB 변수는 눌린 탭을 저장
" GO_TAB        변수는 TAB STRIP 컨트롤을 사용할 때 필요한 변수

DATA : GV_SUBSCREEN  TYPE SY-DYNNR VALUE '0110',
       GV_PRESSEDTAB TYPE SY-UCOMM VALUE 'TAB1'. "TABSTRIP FUCTION CODE

" 화면의 Tabstrip과 연동할 제어변수 선언방법
" CONTROLS : 화면의 TABSTRIP 과 동일한 이름: TYPE TABSTRIP.
CONTROLS: TABSTRIP TYPE TABSTRIP.

DATA: GV_SHOW        TYPE C,        "탭스트립 제어하는 변수
      GV_SHOW_BUTTON TYPE C, "생성버튼 제어하는 변수
      GV_SHOW_TAB    TYPE C,    "탭스트립 탭 제어하는 변수
      GV_MODE1       TYPE C.       "헤더 입력필드 제어하는 변수
* 라디오버튼 제어하는 변수
DATA: BEGIN OF GS_RBGROUP,
        RA1(1) TYPE C,
        RA2(1) TYPE C,
      END OF GS_RBGROUP.


*--------------------------------------------------------------------*
*ListBox 변수 선언
DATA: GV_LIST TYPE CHAR50,
      GT_LIST TYPE TABLE OF ZEA_MMT020,
      GS_LIST LIKE LINE OF GT_LIST.

*리스트 박스 구현
DATA: LIST  TYPE VRM_VALUES,
      VALUE LIKE LINE OF LIST.
