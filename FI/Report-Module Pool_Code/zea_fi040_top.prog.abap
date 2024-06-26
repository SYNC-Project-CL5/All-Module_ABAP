*&---------------------------------------------------------------------*
*& Include          YE00_EX001_TOP
*&---------------------------------------------------------------------*

" Dictionary Structure
" 전표 헤더, 전표 아이템
TABLES: ZEA_BKPF, ZEA_BSEG, ZEA_TBSL.

DATA: GS_BKPF TYPE ZEA_BKPF,
      GT_BKPF TYPE TABLE OF ZEA_BKPF. " 전표헤더

DATA: GS_BSEG TYPE ZEA_BSEG,
      GT_BSEG TYPE TABLE OF ZEA_BSEG. " 전표 item

DATA: GS_TBSL TYPE ZEA_TBSL,
      GT_TBSL TYPE TABLE OF ZEA_TBSL. " 전기키

* -- 전표 헤더& 아이템 테이블 형태 wa, itab
* -- ALV2 로 보여주는 데이터 ( 오른쪽 ALV )
DATA: BEGIN OF GS_ALL.
        INCLUDE STRUCTURE ZEA_BSEG.
DATA:
        BLART TYPE ZEA_BKPF-BLART, " 전표유형
        BLDAT TYPE ZEA_BKPF-BLDAT, " 증빙일
        BUDAT TYPE ZEA_BKPF-BUDAT, " 전기일
        BLTXT TYPE ZEA_BKPF-BLTXT,
      END OF GS_ALL,
      GT_ALL LIKE TABLE OF GS_ALL.

* -- 전표 헤더& 아이템 테이블로부터 값을 받아올 데이터
DATA: BEGIN OF GS_DATA,
        INDI_CD TYPE ZEA_TBSL-INDI_CD, " 전기키 테이블
        BUDAT   TYPE ZEA_BKPF-BUDAT,   " 전기일자
        DMBTR   TYPE ZEA_BSEG-DMBTR,   " 통화금액(KRW)
        BPCODE  TYPE ZEA_BSEG-BPCODE,  " BPCODE
      END OF GS_DATA,
      GT_DATA LIKE TABLE OF GS_DATA.

* -- ALV1 로 보여주는 데이터 ( 왼쪽 ALV )
DATA: BEGIN OF GS_DISP,
*        BELNR     TYPE ZEA_BKPF-BELNR, " 전표번호
        MONTH     TYPE NUMC2, " 월(MM)
        DMBTR_S   TYPE ZEA_BSEG-DMBTR, " 금액 - 차변
        DMBTR_H   TYPE ZEA_BSEG-DMBTR, " 금액 - 대변
        DMBTR_DIF TYPE ZEA_BSEG-DMBTR, " 금액 - 차이
      END OF GS_DISP,

      GT_DISP LIKE TABLE OF GS_DISP.


* -- 화면 관련 변수
DATA: OK_CODE      TYPE SY-UCOMM.

* -- 100번 화면에 데이터를 출력하기 위한 참조변수
DATA: GO_DOCK           TYPE REF TO CL_GUI_DOCKING_CONTAINER,
      GO_CONTAINER      TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      GO_SPLIT          TYPE REF TO CL_GUI_SPLITTER_CONTAINER,
      GO_CON_LEFT       TYPE REF TO CL_GUI_CONTAINER,
      GO_CON_RIGHT      TYPE REF TO CL_GUI_CONTAINER,
      GO_ALV_GRID_LEFT  TYPE REF TO CL_GUI_ALV_GRID,
      GO_ALV_GRID_RIGHT TYPE REF TO CL_GUI_ALV_GRID.

* ALV 관련 변수
DATA: GS_LAYOUT       TYPE LVC_S_LAYO,
      GS_FIELDCAT     TYPE LVC_S_FCAT,
      GT_FIELDCAT     TYPE LVC_T_FCAT,
      GS_FIELDCAT_ALL TYPE LVC_S_FCAT,
      GT_FIELDCAT_ALL TYPE LVC_T_FCAT,
      GS_VARIANT      TYPE DISVARIANT,
      GV_SAVE         TYPE C.

* ALV 툴바
DATA : GS_TOOLBAR      TYPE STB_BUTTON,   " For ALV Toolbar button
       GT_UI_FUNCTIONS TYPE UI_FUNCTIONS, " Exclude ALV Standard button
       GS_STABLE       TYPE LVC_S_STBL.   " Stable when ALV refresh

CLASS LCL_EVENT_HANDLER DEFINITION DEFERRED.
* ALV Handler
DATA: GO_HANDLER TYPE REF TO LCL_EVENT_HANDLER.
