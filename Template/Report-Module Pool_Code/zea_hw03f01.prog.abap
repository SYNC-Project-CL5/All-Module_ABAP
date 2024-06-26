*&---------------------------------------------------------------------*
*& Include          ZMEETROOMF01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_base_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_base_data .


  CHECK SY-UNAME EQ 'ACA5-03'
   OR SY-UNAME EQ 'ACA5-07'
   OR SY-UNAME EQ 'ACA5-08'
   OR SY-UNAME EQ 'ACA5-10'
   OR SY-UNAME EQ 'ACA5-12'
   OR SY-UNAME EQ 'ACA5-15'
   OR SY-UNAME EQ 'ACA5-17'
   OR SY-UNAME EQ 'ACA5-23'
   OR SY-UNAME EQ 'ACA-05'.

  DATA : lv_tabix TYPE sy-tabix,
         lv_id    TYPE sy-uname.

*-- 중복 사용 방지
  CALL FUNCTION 'ENQUEUE_E_TABLE'
    EXPORTING
      mode_rstable = 'E'
      tabname      = 'ZTMEETROOM'.

*-- Set group code
  CASE pa_group.
    WHEN 'A'.    " All
      _init gr_group.
    WHEN OTHERS. " Team
      gr_group[] = VALUE #( BASE gr_group[]
                            (
                              sign    = 'I'
                              option  = 'EQ'
                              low     = pa_group
                             )
                           ).
  ENDCASE.

*-- Get reservation data
  CLEAR gt_body.
  SELECT * INTO CORRESPONDING FIELDS OF TABLE gt_body
    FROM ztmeetroom
    WHERE rsv_date IN so_resdt
      AND team     IN gr_group
    ORDER BY rsv_date rsv_time_fr ASCENDING.

*-- Set team name
  LOOP AT gt_body INTO gs_body.

    lv_tabix = sy-tabix.

    CASE gs_body-team.
      WHEN 'B'.
        gs_body-gtext = TEXT-l01.
      WHEN 'C'.
        gs_body-gtext = TEXT-l02.
      WHEN 'D'.
        gs_body-gtext = TEXT-l03.
    ENDCASE.

    gs_body-status = icon_led_green.

    MODIFY gt_body FROM gs_body INDEX lv_tabix TRANSPORTING gtext status.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_screen
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_screen .

  DATA : ls_variant TYPE disvariant.

  ls_variant = VALUE #( report  = sy-repid
                        handle  = 'GRD1' ).

  IF go_container IS NOT BOUND.

    CLEAR : gt_fcat, gs_fcat.
    PERFORM set_field_catalog USING : 'X' 'STATUS'      'Status'       'C' ' ',
                                      'X' 'RSV_DATE'    '회의시작일'   'C' ' ',
                                      'X' 'RSV_TIME_FR' '회의시작시간' 'C' ' ',
                                      'X' 'RSV_TIME_TO' '회의종료시간' 'C' ' ',
                                      ' ' 'GTEXT'       'Team'         ' ' ' ',
                                      ' ' 'SUBJECT'     '회의주제'     ' ' ' '.
    gs_layout-cwidth_opt  = space.
    gs_layout-sel_mode    = 'D'.
    gs_layout-stylefname  = 'CELL_TAB'.

    PERFORM create_object.
    PERFORM exclude_button  USING gt_ui_functions.
    PERFORM set_alv_listbox.

    SET HANDLER : lcl_event_handler=>top_of_page  FOR go_alv_grid,
                  lcl_event_handler=>modify_value FOR go_alv_grid,
                  lcl_event_handler=>edit_toolbar FOR go_alv_grid,
                  lcl_event_handler=>user_command FOR go_alv_grid.

    CALL METHOD go_alv_grid->set_table_for_first_display
      EXPORTING
        is_variant           = ls_variant
        i_save               = 'A'
        i_default            = 'X'
        is_layout            = gs_layout
        it_toolbar_excluding = gt_ui_functions
      CHANGING
        it_outtab            = gt_body
        it_fieldcatalog      = gt_fcat.

    PERFORM register_event.

  ELSE.
    PERFORM refresh_table.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_field_catalog
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&---------------------------------------------------------------------*
FORM set_field_catalog  USING pv_key pv_field pv_text pv_just pv_emph.

  gs_fcat = VALUE #( key        = pv_key
                     fieldname  = pv_field
                     coltext    = pv_text
                     just       = pv_just
                     edit       = abap_true
                     emphasize  = pv_emph ).

  CASE pv_field.
    WHEN 'RSV_DATE'.
      gs_fcat-ref_table = 'BKPF'.
      gs_fcat-ref_field = 'BUDAT'.
    WHEN 'RSV_TIME_FR' OR 'RSV_TIME_TO'.
      gs_fcat-ref_table = 'ZTMEETROOM'.
      gs_fcat-ref_field = 'RSV_TIME_FR'.
    WHEN 'SUBJECT'.
      gs_fcat-outputlen = 30.
    WHEN 'GTEXT'.
      gs_fcat-drdn_field  = 'DROP_DOWN_HANDLE'.
      gs_fcat-drdn_hndl   = '1'.
      gs_fcat-drdn_alias  = 'X'.
      gs_fcat-outputlen   = 20.
      gs_fcat-just        = 'C'.
    WHEN 'STATUS'.
      gs_fcat-outputlen   = 5.
  ENDCASE.

  APPEND gs_fcat TO gt_fcat.
  CLEAR gs_fcat.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form screen_change
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM screen_change .

  DATA : ls_styl  TYPE lvc_s_styl,
         lv_tabix TYPE sy-tabix.

  LOOP AT gt_body INTO gs_body.

    lv_tabix = sy-tabix.

*-- PK read only
    CLEAR : ls_styl, gs_body-cell_tab.
    ls_styl = VALUE #( fieldname = 'STATUS'
                       style     = cl_gui_alv_grid=>mc_style_disabled ).
    INSERT ls_styl INTO TABLE gs_body-cell_tab.

    ls_styl = VALUE #( fieldname = 'RSV_DATE'
                       style     = cl_gui_alv_grid=>mc_style_disabled ).
    INSERT ls_styl INTO TABLE gs_body-cell_tab.

    ls_styl = VALUE #( fieldname = 'RSV_TIME_FR'
                       style     = cl_gui_alv_grid=>mc_style_disabled ).
    INSERT ls_styl INTO TABLE gs_body-cell_tab.

    ls_styl = VALUE #( fieldname = 'RSV_TIME_TO'
                       style     = cl_gui_alv_grid=>mc_style_disabled ).
    INSERT ls_styl INTO TABLE gs_body-cell_tab.

    MODIFY gt_body FROM gs_body INDEX lv_tabix TRANSPORTING cell_tab.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_object
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_object .

  CREATE OBJECT go_top_container
    EXPORTING
      repid     = sy-cprog
      dynnr     = sy-dynnr
      side      = go_top_container->dock_at_top
      extension = 43.

  CREATE OBJECT go_container
    EXPORTING
      repid     = sy-repid
      dynnr     = sy-dynnr
      side      = go_container->dock_at_left
      extension = 3000.

  CREATE OBJECT go_alv_grid
    EXPORTING
      i_parent = go_container.

*-- Create TOP-Document
  CREATE OBJECT go_dyndoc_id
    EXPORTING
      style = 'ALV_GRID'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form exclude_button
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_UI_FUNCTIONS
*&---------------------------------------------------------------------*
FORM exclude_button  USING pt_ui_functions TYPE ui_functions.

  DATA : ls_ui_functions TYPE ui_func.

  CLEAR : pt_ui_functions.

  ls_ui_functions = cl_gui_alv_grid=>mc_fc_loc_undo.
  APPEND ls_ui_functions TO pt_ui_functions.
  ls_ui_functions = cl_gui_alv_grid=>mc_fc_loc_copy.
  APPEND ls_ui_functions TO pt_ui_functions.
  ls_ui_functions = cl_gui_alv_grid=>mc_fc_loc_copy_row.
  APPEND ls_ui_functions TO pt_ui_functions.
  ls_ui_functions = cl_gui_alv_grid=>mc_fc_loc_cut.
  APPEND ls_ui_functions TO pt_ui_functions.
  ls_ui_functions = cl_gui_alv_grid=>mc_fc_loc_delete_row.
  APPEND ls_ui_functions TO pt_ui_functions.
  ls_ui_functions = cl_gui_alv_grid=>mc_fc_loc_insert_row.
  APPEND ls_ui_functions TO pt_ui_functions.
  ls_ui_functions = cl_gui_alv_grid=>mc_fc_loc_append_row.
  APPEND ls_ui_functions TO pt_ui_functions.
  ls_ui_functions = cl_gui_alv_grid=>mc_fc_loc_paste.
  APPEND ls_ui_functions TO pt_ui_functions.
  ls_ui_functions = cl_gui_alv_grid=>mc_fc_loc_paste_new_row.
  APPEND ls_ui_functions TO pt_ui_functions.
  ls_ui_functions = cl_gui_alv_grid=>mc_fc_refresh.
  APPEND ls_ui_functions TO pt_ui_functions.
  ls_ui_functions = cl_gui_alv_grid=>mc_fc_auf.
  APPEND ls_ui_functions TO pt_ui_functions.
  ls_ui_functions = cl_gui_alv_grid=>mc_fc_average.
  APPEND ls_ui_functions TO pt_ui_functions.
  ls_ui_functions = cl_gui_alv_grid=>mc_fc_print.
  APPEND ls_ui_functions TO pt_ui_functions.
  ls_ui_functions = cl_gui_alv_grid=>mc_fc_graph.
  APPEND ls_ui_functions TO pt_ui_functions.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_alv_listbox
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_alv_listbox .

  CLEAR : gt_drop, gs_drop.
  gs_drop = VALUE #( handle = 1
                     value  = TEXT-l01 ).
  APPEND gs_drop TO gt_drop.

  gs_drop = VALUE #( handle = 1
                     value  = TEXT-l02 ).
  APPEND gs_drop TO gt_drop.

  gs_drop = VALUE #( handle = 1
                     value  = TEXT-l03 ).
  APPEND gs_drop TO gt_drop.

  CALL METHOD go_alv_grid->set_drop_down_table
    EXPORTING
      it_drop_down = gt_drop.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form register_event
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM register_event .

  CALL METHOD go_dyndoc_id->initialize_document
    EXPORTING
      background_color = cl_dd_area=>col_textarea.

  CALL METHOD go_alv_grid->list_processing_events
    EXPORTING
      i_event_name = 'TOP_OF_PAGE'
      i_dyndoc_id  = go_dyndoc_id.

*-- Set display mode when program execute
  CALL METHOD go_alv_grid->set_ready_for_input
    EXPORTING
      i_ready_for_input = 0.

  CALL METHOD go_alv_grid->register_edit_event
    EXPORTING
      i_event_id = cl_gui_alv_grid=>mc_evt_modified.

  CALL METHOD go_alv_grid->register_edit_event
    EXPORTING
      i_event_id = cl_gui_alv_grid=>mc_evt_enter.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_init_value
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_init_value .

  DATA : lv_date  TYPE sy-datum.

*-- Reserve date
  lv_date = sy-datum.
  _last_day lv_date.

  so_resdt = VALUE #( sign    = 'I'
                      option  = 'BT'
                      low     = sy-datum
                      high    = lv_date ).
  APPEND so_resdt.

*-- List box
  CLEAR: gt_value[], gs_vrm_posi[].

  CLEAR gs_vrm_value.
  gs_vrm_value-key  = 'A'.
  gs_vrm_value-text = TEXT-l00.
  APPEND gs_vrm_value TO gs_vrm_posi.

  CLEAR gs_vrm_value.
  gs_vrm_value-key  = 'B'.
  gs_vrm_value-text = TEXT-l01.
  APPEND gs_vrm_value TO gs_vrm_posi.

  CLEAR gs_vrm_value.
  gs_vrm_value-key  = 'C'.
  gs_vrm_value-text = TEXT-l02.
  APPEND gs_vrm_value TO gs_vrm_posi.

  CLEAR gs_vrm_value.
  gs_vrm_value-key  = 'D'.
  gs_vrm_value-text = TEXT-l03.
  APPEND gs_vrm_value TO gs_vrm_posi.

  gs_vrm_name = 'PA_GROUP'.
  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id     = gs_vrm_name
      values = gs_vrm_posi[].

ENDFORM.
*&---------------------------------------------------------------------*
*& Form handle_modify_value
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_MODIFIED
*&      --> ET_GOOD_CELLS
*&---------------------------------------------------------------------*
FORM handle_modify_value  USING pv_modified
                                pt_good_cells TYPE lvc_t_modi.

  DATA : ls_modi_cell TYPE lvc_s_modi.

  CHECK pv_modified IS NOT INITIAL.

  ls_modi_cell = VALUE #( pt_good_cells[ 1 ] ).

  IF ls_modi_cell-fieldname EQ 'GTEXT'.

    CASE ls_modi_cell-value(1).
      WHEN '1'.
        gs_body = VALUE #( team = 'B' ).
      WHEN '2'.
        gs_body = VALUE #( team = 'C' ).
      WHEN '3'.
        gs_body = VALUE #( team = 'D' ).
    ENDCASE.

    MODIFY gt_body FROM gs_body INDEX ls_modi_cell-row_id TRANSPORTING team.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form refresh_table
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM refresh_table .

  gs_stable = VALUE #( col = abap_true
                       row = abap_true ).

  CALL METHOD go_alv_grid->refresh_table_display
    EXPORTING
      is_stable = gs_stable.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form add_toolbar
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_OBJECT
*&      --> E_INTERACTIVE
*&---------------------------------------------------------------------*
FORM add_toolbar  USING po_object TYPE REF TO cl_alv_event_toolbar_set
                        pv_interactive.

  CLEAR pv_interactive.

  _add_toolbar : '3' ''     ''                         ''                '' '',
                 ' ' 'TOGL' icon_toggle_display_change 'Read <-> Change' '' ''.

  IF gv_mode EQ 'E'.
    _add_toolbar : ' ' 'DROW' icon_delete_row   'Delete Rows'  ''    '',
                   ' ' 'INST' icon_insert_row   'Create Rows'  ''    ''.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form handle_user_command
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_UCOMM
*&---------------------------------------------------------------------*
FORM handle_user_command  USING pv_ucomm.

  CASE pv_ucomm.
    WHEN 'TOGL'.
      PERFORM process_row USING 'T'.
    WHEN 'DROW'.
      PERFORM process_row USING 'D'.
    WHEN 'INST'.
      PERFORM process_row USING 'I'.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form process_row
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&---------------------------------------------------------------------*
FORM process_row  USING pv_mode.

  DATA : lt_roid TYPE lvc_t_roid,
         ls_roid TYPE lvc_s_roid,
         ls_styl TYPE lvc_s_styl.

  CASE pv_mode.
    WHEN 'I'.
      CLEAR : gs_body, ls_styl.
      gs_body-new_yn = abap_true.
      ls_styl-fieldname = 'STATUS'.
      ls_styl-style = cl_gui_alv_grid=>mc_style_disabled.
      INSERT ls_styl INTO TABLE gs_body-cell_tab.

      ls_styl-style = cl_gui_alv_grid=>mc_style_enabled.
      INSERT ls_styl INTO TABLE gs_body-cell_tab.

      APPEND gs_body TO gt_body.

      PERFORM refresh_table.

    WHEN 'D'.
      CALL METHOD go_alv_grid->get_selected_rows
        IMPORTING
          et_row_no = lt_roid.

      IF lt_roid IS INITIAL.
        MESSAGE s001 WITH TEXT-e01 DISPLAY LIKE 'E'.
        EXIT.
      ENDIF.

      SORT lt_roid BY row_id DESCENDING.
      LOOP AT lt_roid INTO ls_roid.

        gs_delt = CORRESPONDING #( gt_body[ ls_roid-row_id ] ).
        APPEND gs_delt TO gt_delt.

        DELETE gt_body INDEX ls_roid-row_id.

      ENDLOOP.

      PERFORM refresh_table.

    WHEN 'T'.
      CASE gv_mode.
        WHEN 'E'.
          gv_mode = 'D'.
          CALL METHOD go_alv_grid->set_ready_for_input
            EXPORTING
              i_ready_for_input = 0.
        WHEN 'D'.
          gv_mode = 'E'.
          CALL METHOD go_alv_grid->set_ready_for_input
            EXPORTING
              i_ready_for_input = 1.
      ENDCASE.

  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form data_save
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM data_save .

  DATA : lt_save    TYPE TABLE OF ztmeetroom,
         lv_tabix   TYPE sy-tabix,
         lv_answer,
         lv_flag,
         lv_msg(50).

  CALL METHOD go_alv_grid->check_changed_data.

  IF ( gt_body IS INITIAL ) AND ( gt_delt IS INITIAL ).
    MESSAGE s001 WITH TEXT-e02 DISPLAY LIKE 'E'.
    EXIT.
  ENDIF.

  CLEAR : lv_flag, lv_msg.
  PERFORM check_time CHANGING lv_flag lv_msg.

  IF lv_flag IS NOT INITIAL.
    MESSAGE s001 WITH lv_msg DISPLAY LIKE 'E'.
    EXIT.
  ENDIF.

  _popup_confirm lv_answer.

  IF lv_answer NE '1'.
    EXIT.
  ENDIF.

  lt_save = CORRESPONDING #( gt_body ).

  LOOP AT gt_body INTO gs_body WHERE status EQ space.

    lv_tabix = sy-tabix.

    gs_body-status = icon_led_green.

    MODIFY gt_body FROM gs_body INDEX lv_tabix TRANSPORTING status.

  ENDLOOP.

  MODIFY ztmeetroom FROM TABLE lt_save.

  IF gt_delt IS NOT INITIAL.
    DELETE ztmeetroom FROM TABLE gt_delt.
    CLEAR gt_delt.
  ENDIF.

  COMMIT WORK.

  MESSAGE i102.

  PERFORM screen_change.
  CLEAR gs_body.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form check_time
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LV_FLAG
*&      <-- LV_MSG
*&---------------------------------------------------------------------*
FORM check_time  CHANGING pv_flag pv_msg.

  DATA : lt_check TYPE TABLE OF ztmeetroom,
         ls_check TYPE ztmeetroom,
         lv_tabix TYPE sy-tabix.

  LOOP AT gt_body INTO gs_body WHERE new_yn EQ abap_true.

    lv_tabix = sy-tabix.

    CLEAR ls_check.
    SELECT SINGLE * INTO CORRESPONDING FIELDS OF ls_check
      FROM ztmeetroom
      WHERE rsv_date EQ gs_body-rsv_date
        AND rsv_time_to BETWEEN gs_body-rsv_time_fr
                            AND gs_body-rsv_time_to.

    IF sy-subrc EQ 0.
      gs_body-status = icon_led_red.
      MODIFY gt_body FROM gs_body INDEX lv_tabix TRANSPORTING status.
      MESSAGE s001 WITH TEXT-e02 DISPLAY LIKE 'E'.
      pv_flag = abap_true.
      pv_msg  = '회의시간이 겹치는 항목이 있습니다'.
      EXIT.
    ENDIF.

  ENDLOOP.

  IF pv_flag IS INITIAL.
    LOOP AT gt_body INTO gs_body WHERE status NE space.

      lv_tabix = sy-tabix.

      CLEAR gs_body-status.
      MODIFY gt_body FROM gs_body INDEX lv_tabix
                                  TRANSPORTING status.

    ENDLOOP.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form event_top_of_page
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM event_top_of_page .

  DATA : lr_dd_table TYPE REF TO cl_dd_table_element,
         col_field   TYPE REF TO cl_dd_area,
         col_value   TYPE REF TO cl_dd_area.

  DATA : lv_text  TYPE sdydo_text_element,
         lv_butxt TYPE t001-butxt.

  CALL METHOD go_dyndoc_id->add_table
    EXPORTING
      no_of_columns = 2
      border        = '0'
    IMPORTING
      table         = lr_dd_table.

*-- Set column
  CALL METHOD lr_dd_table->add_column
    IMPORTING
      column = col_field.

  CALL METHOD lr_dd_table->add_column
    IMPORTING
      column = col_value.

**********************************************************************
* Reservate date
**********************************************************************
  CLEAR lv_text.
  IF so_resdt-high IS NOT INITIAL.
    lv_text = so_resdt-low(4) && '.' && so_resdt-low+4(2) && '.' && so_resdt-low+6(2) &&
              '　~　' &&
              so_resdt-high(4) && '.' && so_resdt-high+4(2) && '.' && so_resdt-high+6(2).
  ELSE.
    lv_text = so_resdt-low(4) && '.' && so_resdt-low+4(2) && '.' && so_resdt-low+6(2).
  ENDIF.

  IF so_resdt[] IS INITIAL.
    CLEAR lv_text.
  ENDIF.

  PERFORM add_row USING lr_dd_table col_field col_value TEXT-i01 lv_text.

**********************************************************************
* Team
**********************************************************************
  CLEAR lv_text.
  CASE pa_group.
    WHEN 'A'.
      lv_text = TEXT-l00.
    WHEN 'B'.
      lv_text = TEXT-l01.
    WHEN 'C'.
      lv_text = TEXT-l02.
    WHEN 'D'.
      lv_text = TEXT-l03.
  ENDCASE.

  PERFORM add_row USING lr_dd_table col_field col_value TEXT-i02 lv_text.

  PERFORM set_top_of_page.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form add_row
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LR_DD_TABLE
*&      --> COL_FIELD
*&      --> COL_VALUE
*&      --> TEXT_I01
*&      --> LV_TEXT
*&---------------------------------------------------------------------*
FORM add_row  USING pr_dd_table  TYPE REF TO cl_dd_table_element
                    pv_col_field TYPE REF TO cl_dd_area
                    pv_col_value TYPE REF TO cl_dd_area
                    pv_field
                    pv_text.

  DATA : lv_text TYPE sdydo_text_element.

*-- Field.
  lv_text = pv_field.

  CALL METHOD pv_col_field->add_text
    EXPORTING
      text         = lv_text
      sap_emphasis = cl_dd_document=>strong
      sap_color    = cl_dd_document=>list_heading_inv.

  CALL METHOD pv_col_field->add_gap
    EXPORTING
      width = 3.

*-- Value.
  lv_text = pv_text.

  CALL METHOD pv_col_value->add_text
    EXPORTING
      text         = lv_text
      sap_emphasis = cl_dd_document=>heading
      sap_color    = cl_dd_document=>list_negative_inv.

  CALL METHOD pv_col_value->add_gap
    EXPORTING
      width = 3.

  CALL METHOD pr_dd_table->new_row.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_top_of_page
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_top_of_page .

* Creating html control
  IF go_html_cntrl IS INITIAL.
    CREATE OBJECT go_html_cntrl
      EXPORTING
        parent = go_top_container.
  ENDIF.

  CALL METHOD go_dyndoc_id->merge_document.
  go_dyndoc_id->html_control = go_html_cntrl.

* Display document
  CALL METHOD go_dyndoc_id->display_document
    EXPORTING
      reuse_control      = 'X'
      parent             = go_top_container
    EXCEPTIONS
      html_display_error = 1.

ENDFORM.
