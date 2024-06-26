*&---------------------------------------------------------------------*
*& Include          ZMEETROOMC01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Class LCL_EVENT_HANDLER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION FINAL.

  PUBLIC SECTION.
    CLASS-METHODS : modify_value  FOR EVENT data_changed_finished
                                  OF cl_gui_alv_grid
                                  IMPORTING e_modified et_good_cells,
                    edit_toolbar  FOR EVENT toolbar
                                  OF cl_gui_alv_grid
                                  IMPORTING e_object e_interactive,
                    user_command  FOR EVENT user_command
                                  OF cl_gui_alv_grid
                                  IMPORTING e_ucomm,
                    top_of_page   FOR EVENT top_of_page OF cl_gui_alv_grid
                                  IMPORTING e_dyndoc_id.

ENDCLASS.
*&---------------------------------------------------------------------*
*& Class (Implementation) LCL_EVENT_HANDLER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.

  METHOD modify_value.
    PERFORM handle_modify_value USING e_modified et_good_cells.
  ENDMETHOD.

  METHOD edit_toolbar.
    PERFORM add_toolbar USING e_object e_interactive.
  ENDMETHOD.

  METHOD user_command.
    PERFORM handle_user_command USING e_ucomm.
  ENDMETHOD.

  METHOD top_of_page.
    PERFORM event_top_of_page.
  ENDMETHOD.

ENDCLASS.
