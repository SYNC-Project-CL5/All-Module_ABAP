*&---------------------------------------------------------------------*
*& Include          ZEA_TR_TEM_F01
*&---------------------------------------------------------------------*

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
     OR SY-UNAME EQ 'ACA5-08'
     OR SY-UNAME EQ 'ACA5-12'
     OR SY-UNAME EQ 'ACA5-15'
     OR SY-UNAME EQ 'ACA5-17'
     OR SY-UNAME EQ 'ACA5-23'.

  CLEAR   gs_data.
  REFRESH gt_data.

  SELECT a~carrname
         b~carrid b~connid b~countryfr b~countryto b~cityfrom b~cityto
         c~fldate c~price  c~currency c~planetype
    INTO CORRESPONDING FIELDS OF TABLE gt_data
    FROM scarr AS a
   INNER JOIN spfli AS b
      ON a~carrid = b~carrid
   INNER JOIN sflight AS c
      ON b~carrid = c~carrid
     AND b~connid = c~connid
   WHERE a~carrid IN so_carr
     AND b~connid IN so_conn.

  IF sy-subrc NE 0.
    MESSAGE s000 WITH 'Data not found'.
    LEAVE LIST-PROCESSING.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_tree_fcat .

  gs_layout-zebra      = 'X'.
  gs_layout-cwidth_opt = 'A'.
  gs_layout-sel_mode   = 'D'.

  PERFORM set_fcat USING :
  'CARRNAME'    ' '   'SCARR'     'CARRNAME',
  'CONNID'      ' '   'SPFLI'     'CONNID',
  'FLDATE'      ' '   'SFLIGHT'   'FLDATE',
  'COUNTRYFR'   ' '   'SPFLI'     'COUNTRYFR',
  'COUNTRYTO'   ' '   'SPFLI'     'COUNTRYTO',
  'CITYFROM'    ' '   'SPFLI'     'CITYFROM',
  'CITYTO'      ' '   'SPFLI'     'CITYTO',
  'PRICE'       ' '   'SFLIGHT'   'PRICE',
  'CURRENCY'    ' '   'SFLIGHT'   'CURRENCY',
  'PLANETYPE'   ' '   'SFLIGHT'   'PLANETYPE'.

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
*&---------------------------------------------------------------------*
FORM set_fcat USING pv_field pv_text pv_ref_table pv_ref_field.

  gs_fcat-fieldname = pv_field.
  gs_fcat-coltext   = pv_text.
  gs_fcat-ref_table = pv_ref_table.
  gs_fcat-ref_field = pv_ref_field.

  CASE pv_field.
    WHEN 'PRICE'.
      gs_fcat-cfieldname = 'CURRENCY'.
      gs_fcat-do_sum     = 'X'.

  ENDCASE.

  APPEND gs_fcat TO gt_fcat.
  CLEAR  gs_fcat.

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

  CREATE OBJECT gcl_container
    EXPORTING
      side      = gcl_container->dock_at_left
      extension = 3000.

*  CREATE OBJECT gcl_tree
*    EXPORTING
*      parent              = gcl_container
*      node_selection_mode = cl_gui_column_tree=>node_sel_mode_multiple
*      item_selection      = 'X'
*      no_html_header      = 'X'
*      no_toolbar          = space.

  CREATE OBJECT gcl_tree
    EXPORTING
      i_parent              = gcl_container
      i_node_selection_mode = cl_gui_column_tree=>node_sel_mode_multiple
      i_item_selection      = 'X'
      i_no_html_header      = 'X'
      i_no_toolbar          = space.

  gs_variant-report = sy-repid.

  CALL METHOD gcl_tree->set_table_for_first_display
    EXPORTING
      i_save          = 'A'
      is_layout       = gs_layout
      is_variant      = gs_variant
    CHANGING
      it_outtab       = gt_data
      it_sort         = gt_sort
      it_fieldcatalog = gt_fcat.

  CALL METHOD gcl_tree->expand_tree
    EXPORTING
      i_level = 1.

  CALL METHOD gcl_tree->column_optimize
    EXPORTING
      i_start_column = gcl_tree->c_hierarchy_column_name
      i_end_column   = gcl_tree->c_hierarchy_column_name.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_sort
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_sort .

  gs_sort-spos = 1.
  gs_sort-fieldname = 'CARRNAME'.
  gs_sort-up        = 'X'.
  gs_sort-subtot    = 'X'.

  APPEND gs_sort TO gt_sort.
  CLEAR  gs_sort.

  gs_sort-spos = 2.
  gs_sort-fieldname = 'CONNID'.
  gs_sort-up        = 'X'.
  gs_sort-subtot    = 'X'.

  APPEND gs_sort TO gt_sort.
  CLEAR  gs_sort.

  gs_sort-spos = 3.
  gs_sort-fieldname = 'FLDATE'.
  gs_sort-up        = 'X'.

  APPEND gs_sort TO gt_sort.
  CLEAR  gs_sort.

ENDFORM.
