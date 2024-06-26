*&---------------------------------------------------------------------*
*& Include          ZEA_GL_DISPLAY_TOP
*&---------------------------------------------------------------------*
TABLES: ZEA_BKPF, ZEA_BSEG, ZEA_SKB1, ZEA_TBSL,
        ZEA_FIT700, ZEA_FIT800, ZEA_TCURR.

DATA: " 전표 헤더
  GS_BKPF TYPE ZEA_BKPF,
  GT_BKPF TYPE TABLE OF ZEA_BKPF,

  " 전표 아이템
  GS_BSEG TYPE ZEA_BSEG,
  GT_BSEG TYPE TABLE OF ZEA_BSEG,

  " 전기키
  GS_TBSL TYPE ZEA_TBSL,
  GT_TBSL TYPE TABLE OF ZEA_TBSL,

  " GL마스터
  GS_SKB1 TYPE ZEA_SKB1,
  GT_SKB1 TYPE TABLE OF ZEA_SKB1,

  " BP마스터
  GS_SKA1 TYPE ZEA_SKA1,
  GT_SKA1 TYPE TABLE OF ZEA_SKA1.

DATA: GS_FIT700 TYPE ZEA_FIT700,
      GT_FIT700 TYPE TABLE OF ZEA_FIT700,
      GS_FIT800 TYPE ZEA_FIT800,
      GT_FIT800 TYPE TABLE OF ZEA_FIT800.

DATA : GS_TCURR TYPE ZEA_TCURR,
       GT_TCURR TYPE TABLE OF ZEA_TCURR.

* -- JOIN - 헤더 아이템 + 전기키
DATA: BEGIN OF GS_DATA.
  INCLUDE TYPE ZEA_BSEG.
DATA:
      INDI_CD TYPE ZEA_TBSL-INDI_CD,
      END OF GS_DATA,
      GT_DATA LIKE TABLE OF GS_DATA.

* --  Line Item 변수
DATA: GV_ITNUM TYPE N3.

" 100번 화면 입력필드와 통신하기 위한 변수 선언
DATA: BEGIN OF S0100,
        SUM_S     TYPE ZEA_BSEG-DMBTR VALUE 0,
        SUM_H     TYPE ZEA_BSEG-DMBTR VALUE 0,
        DIFFERENC TYPE ZEA_BSEG-DMBTR VALUE 0,
        S_WAERS   TYPE ZEA_BSEG-D_WAERS,
        H_WAERS   TYPE ZEA_BSEG-D_WAERS,
        TAX       TYPE C,
      END OF S0100.


* --  100번 스크린 Status icon
DATA: STATUS_ICON TYPE C LENGTH 132." Status Icon은 항상 길이가 문자 132

* -- 팝업 매크로에 사용
DATA: GV_LINES  TYPE SY-TFILL,
      GV_ANSWER TYPE CHAR1,
      GV_CHANGED TYPE C.

* -- Range 변수
DATA: GV_BELNR_NUMBER TYPE ZEA_BKPF-BELNR. " 전표번호
*      GV_ITNUM_NUMBER TYPE ZEA_BSEG-ITNUM. " Line Item

* -- 100번 화면변수
DATA: OK_CODE TYPE SY-UCOMM.

* --
DATA: GS_DEL_KEYS TYPE LVC_S_ROW,
      GT_DEL_KEYS TYPE LVC_T_ROW.

* -- ALV 관련 변수
*DATA: GO_CONTAINER TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
*      GO_ALV_GRID  TYPE REF TO CL_GUI_ALV_GRID.

DATA : GO_CONTAINER     TYPE REF TO CL_GUI_DOCKING_CONTAINER,
       GO_ALV_GRID      TYPE REF TO CL_GUI_ALV_GRID,
       GO_RIGHT_CONTAINER TYPE REF TO CL_GUI_DOCKING_CONTAINER,
       GO_DYNDOC_ID     TYPE REF TO CL_DD_DOCUMENT,
       GO_HTML_CNTRL    TYPE REF TO CL_GUI_HTML_VIEWER.


DATA: GV_SAVE     TYPE C,
      GS_VARIANT  TYPE DISVARIANT,

      GS_LAYOUT   TYPE LVC_S_LAYO,
      GT_FIELDCAT TYPE LVC_T_FCAT,
      GS_FIELDCAT TYPE LVC_S_FCAT.


* -- 250번 팝업 : 사진 업로드를 위한 변수 선언
DATA: URL              TYPE CNDP_URL,
      PIC1             TYPE REF TO CL_GUI_PICTURE,
      CONTAINER1       TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      GT_WWWTAB        LIKE WWWPARAMS OCCURS 0 WITH HEADER LINE.


* -- 300번 팝업 : ALV
DATA : GO_CONTAINER300     TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
       GO_ALV_GRID300      TYPE REF TO CL_GUI_ALV_GRID.


*----------------------------------------------------------------------*
* Confirm Pop-Up [확인창]
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