*&---------------------------------------------------------------------*
*& Include          ZEA_TR_TEM2_TOP
*&---------------------------------------------------------------------*

CLASS lcl_event_handler DEFINITION DEFERRED.

TABLES : sflight.

DATA : BEGIN OF gs_sflight.
         INCLUDE STRUCTURE sflight.
DATA :   node_key TYPE i,
       END OF gs_sflight,

       gt_sflight LIKE TABLE OF gs_sflight,
       gs_sbook   TYPE sbook,
       gt_sbook   TYPE TABLE OF sbook.

DATA : gs_node   TYPE mtreesnode,
       gt_node   LIKE TABLE OF gs_node,
       OK_CODE TYPE sy-ucomm,
       gt_event  TYPE cntl_simple_events,
       gs_event  LIKE LINE OF gt_event,
       gv_node   TYPE i.

DATA : gcl_container       TYPE REF TO cl_gui_docking_container,
       gcl_splitter        TYPE REF TO cl_gui_splitter_container,
       gcl_handler         TYPE REF TO lcl_event_handler,
       gcl_container_left  TYPE REF TO cl_gui_container,
       gcl_container_right TYPE REF TO cl_gui_container,
       gcl_grid            TYPE REF TO cl_gui_alv_grid,
       gcl_tree            TYPE REF TO cl_gui_simple_tree,
       gs_fcat             TYPE lvc_s_fcat,
       gt_fcat             TYPE lvc_t_fcat,
       gs_layout           TYPE lvc_s_layo,
       gs_varaint          TYPE disvariant,
       gs_stable           TYPE lvc_s_stbl.
