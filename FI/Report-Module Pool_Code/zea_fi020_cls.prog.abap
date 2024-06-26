*&---------------------------------------------------------------------*
*& Include          ZALV_GRID_DISPLAY_CLS
*&---------------------------------------------------------------------*

CLASS LCL_EVENT_HANDLER DEFINITION. " 정의

  PUBLIC SECTION.
    "Static Method
    CLASS-METHODS:
      on_button_click FOR EVENT button_click OF cl_gui_alv_grid
        IMPORTING es_row_no     " LVC_S_ROID (ROW_ID)
                  es_col_id     " LVC_S_COL  (FIELDNAME)
                  sender,


      on_double_click FOR EVENT double_click OF cl_gui_alv_grid
        IMPORTING e_row         " LVC_S_ROW  (ROWTYPE, INDEX)
                  e_column      " LVC_S_COL  (FIELDNAME)
                  es_row_no     " LVC_S_ROID (ROW_ID)
                  sender,

      on_toolbar FOR EVENT toolbar OF cl_gui_alv_grid
        IMPORTING e_object      " MT_TOOLBAR Attribute 보유,
                  " TYPE TTB_BUTTON
                  " LINE TYPE STB_BUTTON
                  e_interactive
                  sender,

      on_user_command FOR EVENT user_command OF cl_gui_alv_grid
        IMPORTING e_ucomm       " SY-UCOMM
                  sender,

      on_hotspot_click FOR EVENT hotspot_click OF cl_gui_alv_grid
        IMPORTING e_row_id      " LVC_S_ROW  (ROWTYPE, INDEX)
                  e_column_id   " LVC_S_COL  (FIELDNAME)
                  es_row_no     " LVC_S_ROID (ROW_ID)
                  sender,

      on_data_changed FOR EVENT data_changed OF cl_gui_alv_grid
        IMPORTING er_data_changed
                  sender.


ENDCLASS.

CLASS lcl_event_handler IMPLEMENTATION.

*  METHOD ON_BUTTON_CLICK.
*    PERFORM HANDLE_BUTTON_CLICK USING ES_ROW_NO
*                                      ES_COL_ID
*                                      SENDER.
*  ENDMETHOD.

  METHOD on_button_click. " 위 정의에 대한 구현

    DATA lv_msg TYPE string.

    CASE es_col_id-fieldname.
      WHEN 'MPTEXT'. " 구매계획 내역

**      " 현재 선택하신 버튼은 &1 번째 줄의 &2 열 입니다.
**      " &1 = ES_ROW_NO-ROW_ID = 내가 선택한 버튼의 행 위치
**      " &2 = ES_COL_ID-FIELDNAME = 내가 선택한 버튼의 열 위치
**      LV_MSG = '현재 선택하신 버튼은' && ES_ROW_NO-ROW_ID && '번째 줄의'
**      && ES_COL_ID-FIELDNAME && '열 입니다.'.
**
***      LV_MSG = |현재 선택하신 버튼은 {  } 번째 줄의 { ES_COL_ID-FIELDNAME } 열 입니다.|.
*        DATA lv_answer TYPE c.

        CALL FUNCTION 'TERM_CONTROL_EDIT'
          EXPORTING
            titel          = '구매계획 내역'
            langu          = 'e'                 " ABAP System Field: Language Key of Text Environment
          TABLES
            textlines      = int_text
          EXCEPTIONS
            user_cancelled = 1
            OTHERS         = 2.
        IF sy-subrc <> 0.
*         MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*           WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        ENDIF.

*        MOVE-CORRESPONDING gt_display TO gt_data.
*
*        LOOP AT gt_data INTO gs_data.
*          IF gs_data-carrid IS INITIAL.
*            MESSAGE e000 WITH 'CHECK KEY FIELD.'.
*          ELSEIF gs_data-connid IS INITIAL.
*            MESSAGE e000 WITH 'CHECK KEY FIELD.'.
*          ENDIF.
*        ENDLOOP.
*
*        MODIFY zpfli_e03 FROM TABLE gt_data.
*
*        IF sy-subrc EQ 0.
*          COMMIT WORK AND WAIT.
*          MESSAGE s015.
*        ELSE.
*          ROLLBACK WORK.
*          MESSAGE s016 DISPLAY LIKE 'E'.
*        ENDIF.




*        CALL FUNCTION 'POPUP_TO_CONFIRM_STEP_2_BUTTON'
*          EXPORTING
**           DEFAULTOPTION  = 'Y'              " Cursorpositionierung auf Antwort Ja oder Nein
*            textline1      = TEXT-m01         " 예약을 취소하시겠습니까? : 버튼
**           TEXTLINE2      = SPACE            " zweite Zeile des Dialogfensters
*            titel          = TEXT-t03         " 확인 : 바 타이틀
**           START_COLUMN   = 25               " Startspalte des Dialogfensters
**           START_ROW      = 6                " Startzeile des Dialogfensters
*            cancel_display = 'X'              " Abbrechen-Knopf anzeigen
*          IMPORTING
*            answer         = lv_answer.      " ausgewählte Antwort des Endanwenders

*      LV_MSG = '내가 선택한 버튼의 값은' && LV_ANSWER && ' 이다.'.
*
*      MESSAGE LV_MSG TYPE 'I'.
      WHEN OTHERS.
    ENDCASE.
  ENDMETHOD.

  METHOD on_double_click.
    PERFORM handle_double_click USING e_row
                                      e_column
                                      sender.
  ENDMETHOD.

  METHOD on_toolbar.
    PERFORM handler_toolbar USING e_object
                                  sender.
  ENDMETHOD.

  METHOD on_user_command.
    PERFORM handle_user_command USING e_ucomm
                                      sender.
  ENDMETHOD.

  METHOD on_hotspot_click.
    PERFORM handle_hotspot_click USING e_row_id
                                       e_column_id
                                       sender.
  ENDMETHOD.

  METHOD on_data_changed.
    PERFORM handle_data_changed USING er_data_changed
                                      sender.
  ENDMETHOD.

ENDCLASS.
