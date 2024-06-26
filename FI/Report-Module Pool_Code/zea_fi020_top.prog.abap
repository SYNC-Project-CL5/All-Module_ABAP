*&---------------------------------------------------------------------*
*& Include          ZALV_GRID_DISPLAY_TOP
*&---------------------------------------------------------------------*
TABLES: zea_bkpf.

CLASS lcl_event_handler DEFINITION DEFERRED.

DATA: gt_data TYPE TABLE OF zea_bkpf,
      gs_data TYPE zea_bkpf.

DATA: BEGIN OF gs_display.
        INCLUDE STRUCTURE gs_data.
DATA: status LIKE icon-id, " 아이콘
        color           TYPE c LENGTH 4, " 행 색상 정보
        light           TYPE c,          " 신호등 표시를 위한
                                         " EXCEPTION 필드
                                         " 0:비움 1:빨강 2:노랑 3:초록
        it_field_colors TYPE lvc_t_scol, " 셀 별 색상정보 인터널 테이블
        style           TYPE lvc_t_styl, " 셀 스타일(모양)
        mark            TYPE char1,      " 셀의 마킹 정보
      END OF gs_display.

DATA: gt_display LIKE TABLE OF gs_display.

DATA: gt_data2 TYPE TABLE OF zea_bseg,
      gs_data2 TYPE zea_bseg.

DATA: BEGIN OF gs_display2.
        INCLUDE STRUCTURE gs_data2.
DATA: status LIKE icon-id, " 아이콘
        color           TYPE c LENGTH 4, " 행 색상 정보
        light           TYPE c,          " 신호등 표시를 위한
                                         " EXCEPTION 필드
                                         " 0:비움 1:빨강 2:노랑 3:초록
        it_field_colors TYPE lvc_t_scol, " 셀 별 색상정보 인터널 테이블
        style           TYPE lvc_t_styl, " 셀 스타일(모양)
        mark            TYPE char1,      " 셀의 마킹 정보
      END OF gs_display2.

DATA: gt_display2 LIKE TABLE OF gs_display2.

DATA: go_dock TYPE REF TO cl_gui_docking_container,
      go_split     TYPE REF TO cl_gui_splitter_container,
      go_container_1 TYPE REF TO cl_gui_custom_container,
      go_container_2 TYPE REF TO cl_gui_custom_container,
      go_alv_grid_1      TYPE REF TO cl_gui_alv_grid,
      go_alv_grid_2     TYPE REF TO cl_gui_alv_grid,
      go_event_handler TYPE REF TO lcl_event_handler.

DATA: gs_variant TYPE disvariant,
      gv_save     TYPE c,

      gt_fieldcat TYPE lvc_t_fcat,
      gs_fieldcat TYPE lvc_s_fcat,

      gs_layout   TYPE lvc_s_layo,

      gt_filter   TYPE lvc_t_filt,
      gs_filter   TYPE lvc_s_filt,

      gt_index_rows      TYPE lvc_t_row,
      gs_index_rows      TYPE lvc_s_row,

      ok_code     TYPE sy-ucomm,
      gv_lines    TYPE sy-tfill,
      gv_answer   TYPE char1,
      gv_changed.

DATA: BEGIN OF int_text OCCURS 0,
        text(100),
      END OF int_text.

*----------------------------------------------------------------------*
* Common MACRO
*----------------------------------------------------------------------*
DEFINE _mc_popup_confirm.
  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      titlebar              = &1
*      DISPLAY_CANCEL_BUTTON = ''
      text_question         = &2
      text_button_1         = 'YES'
      icon_button_1         = '@2K@'
      text_button_2         = 'NO'
      icon_button_2         = '@2O@ '
    IMPORTING
      answer                = &3
    EXCEPTIONS
      text_not_found        = 1
      OTHERS                = 2.
END-OF-DEFINITION.
