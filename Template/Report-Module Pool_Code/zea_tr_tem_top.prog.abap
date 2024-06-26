*&---------------------------------------------------------------------*
*& Include          ZEA_TR_TEM_TOP
*&---------------------------------------------------------------------*

TABLES : sflight.

*CLASS : cl_gui_column_tree DEFINITION LOAD,
*        cl_gui_cfw         DEFINITION LOAD.

DATA : BEGIN OF gs_data,
         carrid    TYPE spfli-carrid,
         carrname  TYPE scarr-carrname,
         connid    TYPE spfli-connid,
         fldate    TYPE sflight-fldate,
         countryfr TYPE spfli-countryfr,
         countryto TYPE spfli-countryto,
         cityfrom  TYPE spfli-cityfrom,
         cityto    TYPE spfli-cityto,
         price     TYPE sflight-price,
         currency  TYPE sflight-currency,
         planetype TYPE sflight-planetype,
       END OF gs_data,

       gt_data LIKE TABLE OF gs_data,

       BEGIN OF gs_tree,
         level0          TYPE setid,
         level0_text(50),
         level1          TYPE setid,
         level1_text(50),
         level2          TYPE setid,
         level2_text(50),
         countryfr       TYPE spfli-countryfr,
         countryto       TYPE spfli-countryto,
         cityfrom        TYPE spfli-cityfrom,
         cityto          TYPE spfli-cityto,
         price           TYPE sflight-price,
         currency        TYPE sflight-currency,
         planetype       TYPE sflight-planetype,
       END OF gs_tree,

       gt_tree LIKE TABLE OF gs_tree.

* Tree ALV
DATA : gcl_container TYPE REF TO cl_gui_docking_container,
       gcl_tree      TYPE REF TO cl_gui_alv_tree_simple,
*       gcl_tree      TYPE REF TO cl_gui_alv_tree,
       gs_fcat       TYPE lvc_s_fcat,
       gt_fcat       TYPE lvc_t_fcat,
       gs_sort       TYPE lvc_s_sort,
       gt_sort       TYPE lvc_t_sort,
       gs_layout     TYPE lvc_s_layo,
       gs_variant    TYPE disvariant.

DATA : ok_code TYPE sy-ucomm.
