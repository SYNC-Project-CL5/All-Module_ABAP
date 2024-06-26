*&---------------------------------------------------------------------*
*& Include ZMEETROOMTOP                             - Report ZMEETROOM
*&---------------------------------------------------------------------*
REPORT zmeetroom MESSAGE-ID k5.

**********************************************************************
* Macro
**********************************************************************
DEFINE _popup_confirm.

  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      titlebar              = 'Data save'
      text_question         = 'Are you sure?'
      icon_button_1         = 'ICON_OKAY'
      icon_button_2         = 'ICON_CANCEL'
      default_button        = '1'
      display_cancel_button = 'X'
    IMPORTING
      answer                = &1
    EXCEPTIONS
      text_not_found        = 1
      OTHERS                = 2.

END-OF-DEFINITION.

DEFINE _init.

  REFRESH &1.
  CLEAR &1.

END-OF-DEFINITION.

DEFINE _add_toolbar.

  CLEAR gs_toolbar.
  MOVE : &1 TO gs_toolbar-butn_type,
         &2 TO gs_toolbar-function,
         &3 TO gs_toolbar-icon,
         &4 TO gs_toolbar-quickinfo,
         &5 TO gs_toolbar-text,
         &6 TO gs_toolbar-disabled.
  APPEND gs_toolbar TO po_object->mt_toolbar.

END-OF-DEFINITION.

DEFINE _last_day.

  CALL FUNCTION 'LAST_DAY_OF_MONTHS'
    EXPORTING
      day_in            = &1
    IMPORTING
      last_day_of_month = &1.

END-OF-DEFINITION.

**********************************************************************
* TABLES
**********************************************************************
TABLES : bkpf, bseg, ztmeetroom.

**********************************************************************
* Class instance
**********************************************************************
DATA : go_container     TYPE REF TO cl_gui_docking_container,
       go_alv_grid      TYPE REF TO cl_gui_alv_grid,
*-- For Top-of-page -------------------------------------------------*
       go_top_container TYPE REF TO cl_gui_docking_container,
       go_dyndoc_id     TYPE REF TO cl_dd_document,
       go_html_cntrl    TYPE REF TO cl_gui_html_viewer.

**********************************************************************
* Internal table and Work area
**********************************************************************
DATA : BEGIN OF gs_body.
         include structure ztmeetroom.
DATA :   status           TYPE icon-id,
         gtext            TYPE tgsbt-gtext,
         cell_tab         TYPE lvc_t_styl,
         drop_down_handle TYPE int4,
         new_yn,
       END OF gs_body.

DATA : gt_body LIKE TABLE OF gs_body,
       gt_delt TYPE TABLE OF ztmeetroom,
       gs_delt TYPE ztmeetroom.

*-- For ALV
DATA : gt_fcat   TYPE lvc_t_fcat,
       gs_fcat   TYPE lvc_s_fcat,
       gs_layout TYPE lvc_s_layo.

*-- ALV Toolbar
DATA : gs_toolbar      TYPE stb_button,   " For ALV Toolbar button
       gt_ui_functions TYPE ui_functions, " Exclude ALV Standard button
       gs_stable       TYPE lvc_s_stbl.   " Stable when ALV refresh

*-- For ALV List box
DATA : gt_drop TYPE lvc_t_drop,
       gs_drop TYPE lvc_s_drop.

*-- For select box
DATA : gs_vrm_name  TYPE vrm_id,
       gs_vrm_posi  TYPE vrm_values,
       gs_vrm_value LIKE LINE OF gs_vrm_posi.
DATA : gt_value LIKE t093t OCCURS 0 WITH HEADER LINE.

**********************************************************************
* Common variable
**********************************************************************
RANGES gr_group FOR ztmeetroom-team.

DATA : gv_okcode TYPE sy-ucomm,
       gv_date   TYPE ztmeetroom-rsv_date,
       gv_mode   VALUE 'D'.
