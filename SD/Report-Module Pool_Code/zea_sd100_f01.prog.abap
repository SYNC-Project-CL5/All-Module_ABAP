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
FORM GET_DATA .

  CHECK SY-UNAME EQ 'ACA5-03'
     OR SY-UNAME EQ 'ACA5-08'
     OR SY-UNAME EQ 'ACA5-12'
     OR SY-UNAME EQ 'ACA5-15'
     OR SY-UNAME EQ 'ACA5-17'
     OR SY-UNAME EQ 'ACA5-23'.

  CLEAR   GS_DATA.
  REFRESH GT_DATA.

*  SELECT *
*    INTO CORRESPONDING FIELDS OF TABLE GT_DATA
*    FROM ZEA_SDT030 AS A
*    LEFT JOIN ZEA_T001W AS B ON A~WERKS EQ B~WERKS
*    LEFT JOIN ZEA_MMT020 AS C ON A~MATNR EQ C~MATNR
*                             AND C~SPRAS EQ SY-LANGU.


  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE GT_DATA
    FROM ZEA_SDT030 AS A
    LEFT JOIN ZEA_SDT020 AS B ON A~SAPNR EQ B~SAPNR
    LEFT JOIN ZEA_T001W AS C ON A~WERKS EQ C~WERKS
    LEFT JOIN ZEA_MMT020 AS D ON A~MATNR EQ D~MATNR
                             AND D~SPRAS EQ SY-LANGU.

*  SELECT *
*INTO CORRESPONDING FIELDS OF TABLE GT_DATA
*FROM ZEA_SDT030 AS A
*LEFT JOIN ZEA_T001W AS B ON A~WERKS EQ B~WERKS
*LEFT JOIN ZEA_MMT020 AS C ON A~MATNR EQ C~MATNR
*                         AND C~SPRAS EQ SY-LANGU.

  IF SY-SUBRC NE 0.
    MESSAGE S000 WITH 'Data not found'.
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
FORM SET_TREE_FCAT .

  GS_LAYOUT-ZEBRA      = 'X'.
  GS_LAYOUT-CWIDTH_OPT = 'A'.
  GS_LAYOUT-SEL_MODE   = 'D'.

  PERFORM SET_FCAT USING :

  'SAPNR'    ' '   'ZEA_SDT030'     'SAPNR',
  'SP_YEAR'    ' '   'ZEA_SDT030'     'SP_YEAR',
  'WERKS'    ' '   'ZEA_SDT030'     'WERKS',
  'PNAME1'      ' '   'ZEA_T001W'     'PNAME1',
  'MATNR'      ' '   'ZEA_SDT030'   'MATNR',
  'MAKTX'      ' '   'ZEA_MMT020'   'MAKTX',
  'SAPQU'   ' '   'ZEA_SDT030'     'SAPQU',
  'MEINS'   ' '   'ZEA_SDT030'     'MEINS',
*  'TOTREV'   ' '   'ZEA_SDT020'     'TOTREV',
  'NETPR'    ' '   'ZEA_SDT030'     'NETPR',
  'WAERS'      ' '   'ZEA_SDT030'     'WAERS',
  'SPQTY1'      ' '   'ZEA_SDT030'     'SPQTY1',
  'SPQTY2'      ' '   'ZEA_SDT030'     'SPQTY2',
  'SPQTY3'      ' '   'ZEA_SDT030'     'SPQTY3',
  'SPQTY4'      ' '   'ZEA_SDT030'     'SPQTY4',
  'SPQTY5'      ' '   'ZEA_SDT030'     'SPQTY5',
  'SPQTY6'      ' '   'ZEA_SDT030'     'SPQTY6',
  'SPQTY7'      ' '   'ZEA_SDT030'     'SPQTY7',
  'SPQTY8'      ' '   'ZEA_SDT030'     'SPQTY8',
  'SPQTY9'      ' '   'ZEA_SDT030'     'SPQTY9',
  'SPQTY10'      ' '   'ZEA_SDT030'     'SPQTY10',
  'SPQTY11'      ' '   'ZEA_SDT030'     'SPQTY11',
  'SPQTY12'      ' '   'ZEA_SDT030'     'SPQTY12'.

*  WERKS   TYPE ZEA_SDT030-WERKS,
*  PNAME1  TYPE ZEA_T001W-PNAME1, " 플랜트명 새로 추가.
*  MATNR   TYPE ZEA_SDT030-MATNR,
*  SAPQU   TYPE ZEA_SDT030-SAPQU,
*  MEINS   TYPE ZEA_SDT030-MEINS,
*  NETPR   TYPE ZEA_SDT030-NETPR,
*  WAERS   TYPE ZEA_SDT030-WAERS,
*  SPQTY1  TYPE ZEA_SDT030-SPQTY1,


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
FORM SET_FCAT USING PV_FIELD PV_TEXT PV_REF_TABLE PV_REF_FIELD.

  GS_FCAT-FIELDNAME = PV_FIELD.
  GS_FCAT-COLTEXT   = PV_TEXT.
  GS_FCAT-REF_TABLE = PV_REF_TABLE.
  GS_FCAT-REF_FIELD = PV_REF_FIELD.

  CASE PV_FIELD.
    WHEN 'SAPQU'.
      GS_FCAT-QFIELDNAME = 'MEINS'.
      GS_FCAT-DO_SUM     = 'X'.
    WHEN 'SP_YEAR'.
      GS_FCAT-NO_OUT     = 'X'.
    WHEN 'NETPR'.
      GS_FCAT-CFIELDNAME = 'WAERS'.
*      GS_FCAT-DO_SUM     = 'X'.
    WHEN 'PNAME1'.
      GS_FCAT-NO_OUT     = 'X'.
    WHEN 'MAKTX'.
      GS_FCAT-NO_OUT     = 'X'.
    WHEN 'SPQTY1'.
      GS_FCAT-CFIELDNAME = 'WAERS'.
    WHEN 'SPQTY2'.
      GS_FCAT-CFIELDNAME = 'WAERS'.
    WHEN 'SPQTY3'.
      GS_FCAT-CFIELDNAME = 'WAERS'.
    WHEN 'SPQTY4'.
      GS_FCAT-CFIELDNAME = 'WAERS'.
    WHEN 'SPQTY5'.
      GS_FCAT-CFIELDNAME = 'WAERS'.
    WHEN 'SPQTY6'.
      GS_FCAT-CFIELDNAME = 'WAERS'.
    WHEN 'SPQTY7'.
      GS_FCAT-CFIELDNAME = 'WAERS'.
    WHEN 'SPQTY8'.
      GS_FCAT-CFIELDNAME = 'WAERS'.
    WHEN 'SPQTY9'.
      GS_FCAT-CFIELDNAME = 'WAERS'.
    WHEN 'SPQTY10'.
      GS_FCAT-CFIELDNAME = 'WAERS'.
    WHEN 'SPQTY11'.
      GS_FCAT-CFIELDNAME = 'WAERS'.
    WHEN 'SPQTY12'.
      GS_FCAT-CFIELDNAME = 'WAERS'.


  ENDCASE.

  APPEND GS_FCAT TO GT_FCAT.
  CLEAR  GS_FCAT.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_object
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT .

  CREATE OBJECT GCL_CONTAINER
    EXPORTING
      SIDE      = GCL_CONTAINER->DOCK_AT_LEFT
      EXTENSION = 3000.

*  CREATE OBJECT gcl_tree
*    EXPORTING
*      parent              = gcl_container
*      node_selection_mode = cl_gui_column_tree=>node_sel_mode_multiple
*      item_selection      = 'X'
*      no_html_header      = 'X'
*      no_toolbar          = space.

  CREATE OBJECT GCL_TREE
    EXPORTING
      I_PARENT              = GCL_CONTAINER
      I_NODE_SELECTION_MODE = CL_GUI_COLUMN_TREE=>NODE_SEL_MODE_MULTIPLE
      I_ITEM_SELECTION      = 'X'
      I_NO_HTML_HEADER      = 'X'
      I_NO_TOOLBAR          = SPACE.

  GS_VARIANT-REPORT = SY-REPID.

  CALL METHOD GCL_TREE->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
      I_SAVE          = 'A'
      IS_LAYOUT       = GS_LAYOUT
      IS_VARIANT      = GS_VARIANT
    CHANGING
      IT_OUTTAB       = GT_DATA
      IT_SORT         = GT_SORT
      IT_FIELDCATALOG = GT_FCAT.

  CALL METHOD GCL_TREE->EXPAND_TREE
    EXPORTING
      I_LEVEL = 1.

  CALL METHOD GCL_TREE->COLUMN_OPTIMIZE
    EXPORTING
      I_START_COLUMN = GCL_TREE->C_HIERARCHY_COLUMN_NAME
      I_END_COLUMN   = GCL_TREE->C_HIERARCHY_COLUMN_NAME.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_sort
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_SORT .

  GS_SORT-SPOS = 1.
  GS_SORT-FIELDNAME = 'SP_YEAR'.
  GS_SORT-UP        = 'X'.
  GS_SORT-SUBTOT    = 'X'.
  APPEND GS_SORT TO GT_SORT.

  CLEAR  GS_SORT.
  GS_SORT-SPOS = 2.
*  GS_SORT-FIELDNAME = 'WERKS'.
  GS_SORT-FIELDNAME = 'PNAME1'.
  GS_SORT-UP        = 'X'.
  GS_SORT-SUBTOT    = 'X'.
  APPEND GS_SORT TO GT_SORT.

  CLEAR  GS_SORT.
  GS_SORT-SPOS = 3.
*  GS_SORT-FIELDNAME = 'MATNR'.
  GS_SORT-FIELDNAME = 'MAKTX'.
  GS_SORT-UP        = 'X'.
  APPEND GS_SORT TO GT_SORT.

  CLEAR  GS_SORT.
  GS_SORT-FIELDNAME = 'SPQTY1'.
*  GS_SORT-UP        = 'X'.
  GS_SORT-SUBTOT    = 'X'.

ENDFORM.
