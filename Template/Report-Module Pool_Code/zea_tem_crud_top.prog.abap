*&---------------------------------------------------------------------*
*& Include          ZALV_GRID_CRUD_TOP
*&---------------------------------------------------------------------*
TABLES: ZPFLI_E23.

CLASS LCL_EVENT_HANDLER DEFINITION DEFERRED.

DATA: GT_DATA TYPE TABLE OF ZPFLI_E23,
      GS_DATA TYPE ZPFLI_E23.

DATA: BEGIN OF GS_DISPLAY.
        INCLUDE STRUCTURE GS_DATA.
DATA: STATUS LIKE ICON-ID, " 아이콘
        COLOR           TYPE C LENGTH 4, " 행 색상 정보
        LIGHT           TYPE C,          " 신호등 표시를 위한
                                         " EXCEPTION 필드
                                         " 0:비움 1:빨강 2:노랑 3:초록
        IT_FIELD_COLORS TYPE LVC_T_SCOL, " 셀 별 색상정보 인터널 테이블
        STYLE           TYPE LVC_T_STYL, " 셀 스타일(모양)
        MARK            TYPE CHAR1,      " 셀의 마킹 정보
      END OF GS_DISPLAY.

DATA: GT_DISPLAY LIKE TABLE OF GS_DISPLAY.

DATA: GO_CONTAINER TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      GO_ALV_GRID      TYPE REF TO CL_GUI_ALV_GRID,
      GO_EVENT_HANDLER TYPE REF TO LCL_EVENT_HANDLER.

DATA: GS_VARIANT TYPE DISVARIANT,
      GV_SAVE     TYPE C,

      GT_FIELDCAT TYPE LVC_T_FCAT,
      GS_FIELDCAT TYPE LVC_S_FCAT,

      GS_LAYOUT   TYPE LVC_S_LAYO,

      GT_FILTER   TYPE LVC_T_FILT,
      GS_FILTER   TYPE LVC_S_FILT,

      GT_INDEX_ROWS      TYPE LVC_T_ROW,
      GS_INDEX_ROWS      TYPE LVC_S_ROW,

      OK_CODE     TYPE SY-UCOMM,
      GV_LINES    TYPE SY-TFILL,
      GV_ANSWER   TYPE CHAR1,
      GV_CHANGED.

*----------------------------------------------------------------------*
* Common MACRO
*----------------------------------------------------------------------*

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

*----------------------------------------------------------------------*
* Display Message
*----------------------------------------------------------------------*
* _mc_message '신고금액 확인' '확인바랍니다.'.
*----------------------------------------------------------------------*
DEFINE _mc_message.
  CALL FUNCTION 'POPUP_TO_DISPLAY_TEXT_LO'
    EXPORTING
      titel     = &1
      textline1 = &2.
END-OF-DEFINITION.

*----------------------------------------------------------------------*
* Pop-Up Message
*----------------------------------------------------------------------*
* _mc_popup_msg '삭제할 자료를' '선택하세요.'.
*----------------------------------------------------------------------*
DEFINE _mc_popup_msg.
  CALL FUNCTION 'MASS_MESSAGE_SHOW_LONGTEXT'
    EXPORTING
      arbgb = 'OO'        "MESSAGE CLASS
      msgnr = '000'       "MESSAGE NO
      msgv1 = &1          "MESSAGE 변수
      msgv2 = &2.         "MESSAGE 변수
END-OF-DEFINITION.

*----------------------------------------------------------------------*
* Icon Create
*----------------------------------------------------------------------*
* _mc_icon_create gv_icon_name gv_icon_text
*                 gv_icon_info gs_icon-request.
*----------------------------------------------------------------------*
DEFINE _mc_icon_create.
  CALL FUNCTION 'ICON_CREATE'
    EXPORTING
      name                  = &1
      text                  = &2
      info                  = &3
      add_stdinf            = 'X'
    IMPORTING
      result                = &4
    EXCEPTIONS
      icon_not_found        = 1
      outputfield_too_short = 2
      OTHERS                = 3.
END-OF-DEFINITION.
