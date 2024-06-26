*&---------------------------------------------------------------------*
*& Include          ZEA_TR_TEM2_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form set_fcat_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_fcat_layout .

  gs_layout-zebra      = 'X'.
  gs_layout-cwidth_opt = 'A'.
  gs_layout-sel_mode   = 'D'.

  PERFORM set_fcat USING :
  'X'   'CARRID'        ' '   'SBOOK'   'CARRID',
  'X'   'CONNID'        ' '   'SBOOK'   'CONNID',
  'X'   'FLDATE'        ' '   'SBOOK'   'FLDATE',
  'X'   'BOOKID'        ' '   'SBOOK'   'BOOKID',
  ' '   'CUSTOMID'      ' '   'SBOOK'   'CUSTOMID',
  ' '   'CUSTTYPE'      ' '   'SBOOK'   'CUSTTYPE',
  ' '   'LUGGWEIGHT'    ' '   'SBOOK'   'LUGGWEIGHT',
  ' '   'WUNIT'         ' '   'SBOOK'   'WUNIT',
  ' '   'INVOICE'       ' '   'SBOOK'   'INVOICE',
  ' '   'LOCCURAM'      ' '   'SBOOK'   'LOCCURAM',
  ' '   'LOCCURKEY'     ' '   'SBOOK'   'LOCCURKEY',
  ' '   'ORDER_DATE'    ' '   'SBOOK'   'ORDER_DATE'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&---------------------------------------------------------------------*
FORM set_fcat USING pv_key pv_field pv_text pv_ref_table pv_ref_field.

  gs_fcat-key       = pv_key.
  gs_fcat-fieldname = pv_field.
  gs_fcat-coltext   = pv_text.
  gs_fcat-ref_table = pv_ref_table.
  gs_fcat-ref_field = pv_ref_field.

  CASE pv_field.
    WHEN 'LUGGWEIGHT'.
      gs_fcat-qfieldname = 'WUNIT'.

    WHEN 'LOCCURAM'.
      gs_fcat-cfieldname = 'LOCCURKEY'.

    WHEN 'INVOICE'.
      gs_fcat-checkbox = 'X'.

  ENDCASE.

  APPEND gs_fcat TO gt_fcat.
  CLEAR  gs_fcat.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form creat_object
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM creat_object .

  CREATE OBJECT gcl_container
    EXPORTING
      repid     = sy-repid
      dynnr     = sy-dynnr
      extension = 5000
      side      = gcl_container->dock_at_left.

  CREATE OBJECT gcl_splitter
    EXPORTING
      parent  = gcl_container
      rows    = 1
      columns = 2.

  CALL METHOD gcl_splitter->set_column_width
    EXPORTING
      id    = 1
      width = 20.

  CALL METHOD gcl_splitter->get_container
    EXPORTING
      row       = 1
      column    = 1
    RECEIVING
      container = gcl_container_left.

  CALL METHOD gcl_splitter->get_container
    EXPORTING
      row       = 1
      column    = 2
    RECEIVING
      container = gcl_container_right.

  CREATE OBJECT gcl_tree
    EXPORTING
      parent                      = gcl_container_left
      node_selection_mode         = cl_gui_simple_tree=>node_sel_mode_single
    EXCEPTIONS
      lifetime_error              = 1
      cntl_system_error           = 2
      create_error                = 3
      failed                      = 4
      illegal_node_selection_mode = 5.

  gs_event-eventid    = cl_gui_simple_tree=>eventid_node_double_click.
  gs_event-appl_event = 'X'.

  APPEND gs_event TO gt_event.

  CALL METHOD gcl_tree->set_registered_events
    EXPORTING
      events = gt_event.

  IF gcl_handler IS NOT BOUND.
    CREATE OBJECT gcl_handler.
  ENDIF.

  SET HANDLER : gcl_handler->handle_double_click FOR gcl_tree.

  CREATE OBJECT gcl_grid
    EXPORTING
      i_parent = gcl_container_right.

  gs_varaint-report = sy-repid.

  CALL METHOD gcl_grid->set_table_for_first_display
    EXPORTING
      i_save          = 'A'
      i_default       = 'X'
      is_layout       = gs_layout
      is_variant      = gs_varaint
    CHANGING
      it_fieldcatalog = gt_fcat
      it_outtab       = gt_sbook.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_node
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_node .

  DATA : BEGIN OF ls_level1,
           carrid TYPE sflight-carrid,
         END OF ls_level1,

         BEGIN OF ls_level2,
           carrid TYPE sflight-carrid,
           connid TYPE sflight-connid,
         END OF ls_level2,

         BEGIN OF ls_level3,
           carrid TYPE sflight-carrid,
           connid TYPE sflight-connid,
           fldate TYPE sflight-fldate,
         END OF ls_level3,

         lt_level1 LIKE TABLE OF ls_level1,
         lt_level2 LIKE TABLE OF ls_level2,
         lt_level3 LIKE TABLE OF ls_level3.

  CLEAR   : ls_level1, ls_level2, ls_level3.
  REFRESH : lt_level1, lt_level2, lt_level3.

  MOVE-CORRESPONDING gt_sflight TO lt_level1.
  MOVE-CORRESPONDING gt_sflight TO lt_level2.
  MOVE-CORRESPONDING gt_sflight TO lt_level3.

  SORT : lt_level1 BY carrid,
         lt_level2 BY carrid connid,
         lt_level3 BY carrid connid fldate.

  DELETE ADJACENT DUPLICATES FROM : lt_level1 COMPARING carrid,
                                    lt_level2 COMPARING carrid connid,
                                    lt_level3 COMPARING carrid connid fldate.

  LOOP AT lt_level1 INTO ls_level1.

    PERFORM add_node USING ls_level1-carrid
                           ' '
                           'X'
                           ls_level1-carrid
                           ' '.

    READ TABLE lt_level2 INTO ls_level2 WITH KEY carrid = ls_level1-carrid.

    IF sy-subrc NE 0.
      CONTINUE.
    ENDIF.

    LOOP AT lt_level2 INTO ls_level2 FROM sy-tabix WHERE carrid = ls_level1-carrid.

      PERFORM add_node USING ls_level2-connid
                             ls_level1-carrid
                             'X'
                             ls_level2-connid
                             ' '.

      READ TABLE lt_level3 INTO ls_level3 WITH KEY carrid = ls_level2-carrid
                                                   connid = ls_level2-connid.

      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      LOOP AT lt_level3 INTO ls_level3 FROM sy-tabix WHERE carrid = ls_level2-carrid
                                                       AND connid = ls_level2-connid.

        PERFORM add_node USING ls_level3-fldate
                               ls_level2-connid
                               ' '
                               ls_level3-fldate
                               'X'.
      ENDLOOP.

    ENDLOOP.

  ENDLOOP.

  CALL METHOD gcl_tree->add_nodes
    EXPORTING
      table_structure_name           = 'MTREESNODE'
      node_table                     = gt_node
    EXCEPTIONS
      failed                         = 1
      error_in_node_table            = 2
      dp_error                       = 3
      table_structure_name_not_found = 4
      OTHERS                         = 5.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .


  CHECK SY-UNAME EQ 'ACA5-03'
   OR SY-UNAME EQ 'ACA5-07'
   OR SY-UNAME EQ 'ACA5-08'
   OR SY-UNAME EQ 'ACA5-10'
   OR SY-UNAME EQ 'ACA5-12'
   OR SY-UNAME EQ 'ACA5-15'
   OR SY-UNAME EQ 'ACA5-17'
   OR SY-UNAME EQ 'ACA5-23'
   OR SY-UNAME EQ 'ACA-05'.

  CLEAR   gs_sflight.
  REFRESH gt_sflight.

  SELECT carrid connid fldate
    INTO CORRESPONDING FIELDS OF TABLE gt_sflight
    FROM sflight
   WHERE carrid IN so_carr
     AND connid IN so_conn.

  IF sy-subrc NE 0.
    MESSAGE s000 WITH 'No data found'.
    LEAVE LIST-PROCESSING.
  ENDIF.

  LOOP AT gt_sflight INTO gs_sflight.

    gs_sflight-node_key = sy-tabix.

    MODIFY gt_sflight FROM gs_sflight INDEX sy-tabix
    TRANSPORTING node_key.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form add_node
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_LEVEL1_CARRID
*&      --> P_
*&      --> LS_LEVEL1_CARRID
*&---------------------------------------------------------------------*
FORM add_node USING pv_node_key
                     pv_rel_key
                     pv_folder   TYPE as4flag
                     pv_text
                     pv_last.

  DATA : lv_node_key TYPE tv_nodekey,
         lv_rel_key  TYPE tv_nodekey,
         lv_text     TYPE text30.

  lv_node_key = pv_node_key.
  lv_rel_key  = pv_rel_key.
  lv_text     = pv_text.

  gs_node-node_key = lv_node_key.
  gs_node-isfolder = pv_folder.
  gs_node-text     = lv_text.

  IF lv_rel_key IS NOT INITIAL.
    gs_node-relatkey = lv_rel_key.
  ENDIF.

  IF pv_last IS NOT INITIAL.
    gv_node += 1.
    gs_node-node_key  = gv_node.
    gs_node-relatship = cl_gui_simple_tree=>relat_last_child.
  ENDIF.

  APPEND gs_node TO gt_node.
  CLEAR  gs_node.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_sbook
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> NODE_KEY
*&---------------------------------------------------------------------*
FORM get_sbook USING pv_node_key.

  READ TABLE gt_node INTO gs_node WITH KEY node_key = pv_node_key.

  IF sy-subrc NE 0.
    EXIT.
  ELSE.
    IF gs_node-isfolder IS NOT INITIAL.
      EXIT.
    ENDIF.
  ENDIF.

  READ TABLE gt_sflight INTO gs_sflight INDEX pv_node_key.

  IF sy-subrc NE 0.
    EXIT.
  ENDIF.

  REFRESH gt_sbook.

  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE gt_sbook
    FROM sbook
   WHERE carrid = gs_sflight-carrid
     AND connid = gs_sflight-connid
     AND fldate = gs_sflight-fldate.

  IF sy-subrc NE 0.
    EXIT.
  ENDIF.

  PERFORM refresh_grid.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form refresh_grid
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM refresh_grid .

  gs_stable-row = 'X'.
  gs_stable-col = 'X'.

  CALL METHOD gcl_grid->refresh_table_display
    EXPORTING
      is_stable      = gs_stable
      i_soft_refresh = space.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form check_number
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PV_NODE_KEY
*&---------------------------------------------------------------------*
FORM check_number USING pv_node_key pv_check.

  DATA : lv_node TYPE string,
         lv_type TYPE dd01v-datatype.

  lv_node = pv_node_key.

  CALL FUNCTION 'FM_SITWB_NUMERIC_CHECK'
    EXPORTING
      string_in = lv_node
    IMPORTING
      htype     = lv_type.

  IF lv_type NE 'NUMC'.
    pv_check = 'X'.
  ENDIF.

ENDFORM.
