*&---------------------------------------------------------------------*
*& Include          ZALV_GRID_DISPLAY_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form MAKE_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM make_fieldcat_0100 .

  LOOP AT gt_fieldcat INTO gs_fieldcat.

    CASE gs_fieldcat-fieldname.
      WHEN 'STATUS'.
        gs_fieldcat-coltext = 'Status'.
        gs_fieldcat-icon    = abap_on.
        gs_fieldcat-key     = abap_off.
        gs_fieldcat-no_out  = abap_on.
      WHEN 'COLOR'.
        gs_fieldcat-no_out  = abap_on.
      WHEN 'LIGHT'.
        gs_fieldcat-no_out  = abap_on.
      WHEN 'MARK'.
        gs_fieldcat-no_out  = abap_on.
      WHEN 'MPTEXT'.
        gs_fieldcat-JUST = 'C'.
        gs_fieldcat-STYLE = CL_GUI_ALV_GRID=>mc_style_button.
    ENDCASE.

    MODIFY gt_fieldcat FROM gs_fieldcat.

  ENDLOOP.

*    CLEAR GS_FIELDCAT.
*    GS_FIELDCAT-FIELDNAME = 'CARRID'.        " 필드 이름
*    GS_FIELDCAT-COLTEXT   = TEXT-F01.        " 출력 되는 컬럼명
*    GS_FIELDCAT-HOTSPOT   = ABAP_ON.         " HOTSPOT 설정
*    GS_FIELDCAT-ICON      = ABAP_ON. " 'X'   " 아이콘 필드
  " 컬럼을 합산처리하도록 옵션을 켬
*    GS_FIELDCAT-DO_SUM    = ABAP_ON. " 'X'.
*    GS_FIELDCAT-NO_OUT    = ABAP_ON. "'X'.   " 컬럼을 숨김 처리
*    GS_FIELDCAT-TECH      = ABAP_ON. "'X'.   " 컬럼을 삭제 처리
  " 컬럼명 위에 마우스를 올렸을 때 텍스트
*    GS_FIELDCAT-TOOLTIP   = TEXT-F03.
  " 가운데 정렬, 'L': 왼쪽 정렬, 'R': 오른쪽 정렬
*    GS_FIELDCAT-JUST      = 'C'
*    GS_FIELDCAT-CFIELDNAME    = CURRENCY         " 통화 단위 참조
*    GS_FIELDCAT-CHECKBOX  = ABAP_ON          " 체크박스
*    GS_FIELDCAT-INTTYPE   = I.               " 내부 타입
*    GS_FIELDCAT-INTLEN    = 20.              " 내부 길이
*    GS_FIELDCAT-EMPHASIZE = 'C500'.          " 열 색상
*    APPEND GS_FIELDCAT TO GT_FIELDCAT.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_LAYOUT_0100
*&---------------------------------------------------------------------*
FORM set_alv_layout_0100 .

  CLEAR gs_layout.
  CLEAR gs_variant.
  CLEAR gv_save.

  gs_variant-report = sy-repid.
*  GS_VARIANT-VARIANT = PA_LAYO.
  gv_save = 'A'.   " '' : Layout 저장불가
  " 'U' : 저장한 사용자만 사용가능
  " 'X' : Layout을 저장하면 모든 사용자가 사용 가능
  " 'A' : Layout을 저장할 때 'U'/'X' 선택 가능

  gs_layout-cwidth_opt = abap_on.
  gs_layout-zebra      = abap_on.
  gs_layout-sel_mode   = 'D'.
*    GS_LAYOUT-SEL_MODE = 'A'.
  " A: 다중 행, 다중 열 선택, 선택 박스 생성
  " (셀 단위, 전체 선택도 가능)
*    GS_LAYOUT-SEL_MODE = 'B'. " B : 단일 행, 다중 열 선택, 기본 값
  " 기본값으로 해도 Ctrl + y로 강제로 드래그 할 수는 있음
*    GS_LAYOUT-SEL_MODE = 'C'. " C : 다중 행, 다중 열 선택, 줄 단위 선택

*  GS_LAYOUT-GRID_TITLE = TEXT-T10.          " ALV TITLE TEXT
*  GS_LAYOUT-INFO_FNAME = 'COLOR'.           " 행 색상
*  GS_LAYOUT-EXCP_FNAME = 'LIGHT'.           " 신호등
*  GS_LAYOUT-EXCP_LED = ABAP_ON.             " 신호등 모양 변경
*  GS_LAYOUT-CTAB_FNAME = 'IT_FIELD_COLORS'. " 셀 별 색상
*  GS_LAYOUT-STYLEFNAME  = 'STYLE'.          " 스타일
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_DATA
*&---------------------------------------------------------------------*
FORM select_data .

  REFRESH gt_data.

  SELECT *
    FROM spfli
    INTO CORRESPONDING FIELDS OF TABLE gt_data.

*  SELECT *
*    FROM SFLIGHT
*    INTO CORRESPONDING FIELDS OF TABLE gt_data2.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM make_display_data .

  REFRESH gt_display.
  REFRESH gt_display2.

  LOOP AT gt_data INTO gs_data.

    CLEAR gs_display.

    MOVE-CORRESPONDING gs_data TO gs_display.

*신규 필드------------------------------------------------------------*

    gs_display-MPTEXT = ICON_DISPLAY_TEXT.
*--------------------------------------------------------------------*
    APPEND gs_display TO gt_display.

  ENDLOOP.

  LOOP AT gt_data2 INTO gs_data2.

    CLEAR gs_display2.

    MOVE-CORRESPONDING gs_data2 TO gs_display2.

*신규 필드------------------------------------------------------------*


*--------------------------------------------------------------------*
    APPEND gs_display2 TO gt_display2.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM display_data .


  CHECK SY-UNAME EQ 'ACA5-03'
   OR SY-UNAME EQ 'ACA5-07'
   OR SY-UNAME EQ 'ACA5-08'
   OR SY-UNAME EQ 'ACA5-10'
   OR SY-UNAME EQ 'ACA5-12'
   OR SY-UNAME EQ 'ACA5-15'
   OR SY-UNAME EQ 'ACA5-17'
   OR SY-UNAME EQ 'ACA5-23'
   OR SY-UNAME EQ 'ACA-05'.

  DESCRIBE TABLE gt_display LINES gv_lines.

  IF gt_display IS INITIAL.
    MESSAGE s013 DISPLAY LIKE 'W'.
  ELSE.
    MESSAGE s006 WITH gv_lines.
  ENDIF.

  CALL SCREEN 0100.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form INIT_DATA
*&---------------------------------------------------------------------*
FORM init_data .

*EX------------------------------------------------------------------*
*  BUTTXT = 'Hide Details'(L04).
*
** Exercise 4에 의해 Tabstrips 생성 및 Tab Title 정의
*  TAB1 = 'Flight connections'(L01).
*  TAB2 = 'Flight date'(L02).
*  TAB3 = 'Flight type'(L03).
*
*  TAB_BLOCK-ACTIVETAB = 'COMM2'.  " 눌려진 제목 부분
*  TAB_BLOCK-DYNNR     = '1200'.   " 출력될 내용 부분
*
** AIRLINE ( SO_CAR ) 에 AA ~ QF 인 데이터이면서 AZ 는 제외하는 조건을
* 초기조건으로 지정해라
*  SO_CAR-SIGN = 'I'.
*  SO_CAR-OPTION = 'BT'.
*  SO_CAR-LOW = 'AA'.
*  SO_CAR-HIGH = 'QF'.
*  APPEND SO_CAR. " 첫번째 조건을 추가
*
*  CLEAR SO_CAR. " Header Line을 초기화
*  SO_CAR-SIGN = 'E'.
*  SO_CAR-OPTION = 'EQ'.
*  SO_CAR-LOW = 'AZ'.
*  APPEND SO_CAR. " 두번째 조건을 추가
*--------------------------------------------------------------------*

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MODIFY_SSCREEN
*&---------------------------------------------------------------------*
FORM modify_sscreen .

*EX------------------------------------------------------------------*
*  IF BUTTXT EQ TEXT-L06.
*    LOOP AT SCREEN.
*      IF SCREEN-GROUP1 EQ 'MOD'.
*        SCREEN-ACTIVE = 0.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*
*  ENDIF.
*--------------------------------------------------------------------*

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SSCR_USER_COMMAND
*&---------------------------------------------------------------------*
FORM sscr_user_command .

*EX------------------------------------------------------------------*
*  CASE SY-UCOMM.
*    WHEN 'CLICK_DETAIL'.
*      IF BUTTXT EQ TEXT-L06.
*        BUTTXT = '추가조건 숨김'(L07).
*      ELSE.
*        BUTTXT = '조회조건 추가'(L06).
*      ENDIF.
*  ENDCASE.
*--------------------------------------------------------------------*

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHECK_INPUT
*&---------------------------------------------------------------------*
FORM check_input .


*EX------------------------------------------------------------------*
*  " 출발에 대한 점검
*  SELECT COUNT(*)
*    FROM SPFLI
*   WHERE COUNTRYFR EQ PA_CTRF
*     AND CITYFROM  IN SO_CITYF.
*
*  IF SY-SUBRC NE 0.
*    MESSAGE E010.
*  ENDIF.
*--------------------------------------------------------------------*

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_0100
*&---------------------------------------------------------------------*
FORM create_object_0100 .



  CREATE OBJECT go_container_1
    EXPORTING
      container_name = 'CCON'
    EXCEPTIONS
      OTHERS         = 1.

  IF sy-subrc NE 0.
    MESSAGE e020. " Custom Container 생성 중 오류가 발생했습니다.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  CREATE OBJECT go_container_2
    EXPORTING
      container_name = 'CCON2'
    EXCEPTIONS
      OTHERS         = 1.

  IF sy-subrc NE 0.
    MESSAGE e020. " Custom Container 생성 중 오류가 발생했습니다.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  CREATE OBJECT go_alv_grid_1
    EXPORTING
      i_parent = go_container_1
    EXCEPTIONS
      OTHERS   = 1.

  IF sy-subrc NE 0.
    MESSAGE e021. " ALV Grid 생성 중 오류가 발생했습니다.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  CREATE OBJECT go_alv_grid_2
    EXPORTING
      i_parent = go_container_2
    EXCEPTIONS
      OTHERS   = 1.

  IF sy-subrc NE 0.
    MESSAGE e021. " ALV Grid 생성 중 오류가 발생했습니다.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.




ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_0100
*&---------------------------------------------------------------------*
FORM display_alv_0100 .

  CALL METHOD go_alv_grid_1->set_table_for_first_display
    EXPORTING
      i_structure_name              = 'SPFLI'
      is_variant                    = gs_variant
      i_save                        = gv_save
      is_layout                     = gs_layout
    CHANGING
      it_outtab                     = gt_display
      it_fieldcatalog               = gt_fieldcat
*     IT_SORT                       =
*     IT_FILTER                     =
    EXCEPTIONS
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      OTHERS                        = 4.

  IF sy-subrc <> 0.
    " ALV Grid 에 데이터를 전달하는 중 오류가 발생했습니다.
    MESSAGE e023.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  CALL METHOD go_alv_grid_2->set_table_for_first_display
    EXPORTING
      i_structure_name              = 'SFLIGHT'
      is_variant                    = gs_variant
      i_save                        = gv_save
      is_layout                     = gs_layout
    CHANGING
      it_outtab                     = gt_display2
*     IT_FIELDCATALOG               = GT_FIELDCAT
*     IT_SORT                       =
*     IT_FILTER                     =
    EXCEPTIONS
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      OTHERS                        = 4.

  IF sy-subrc <> 0.
    " ALV Grid 에 데이터를 전달하는 중 오류가 발생했습니다.
    MESSAGE e023.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM set_alv_fieldcat_0100 .

*     PERFORM GET_FIELDCAT_0100.
  PERFORM get_fieldcat2   USING    gt_display
                          CHANGING gt_fieldcat.
*  PERFORM GET_FIELDCAT2   USING    GT_DISPLAY2
*                          CHANGING GT_FIELDCAT.
  PERFORM make_fieldcat_0100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_EVENT_0100
*&---------------------------------------------------------------------*
FORM set_alv_event_0100 .

  SET HANDLER lcl_event_handler=>on_toolbar FOR go_alv_grid_1.
  SET HANDLER lcl_event_handler=>on_double_click FOR go_alv_grid_1.
  SET HANDLER lcl_event_handler=>on_user_command FOR go_alv_grid_1.
  SET HANDLER lcl_event_handler=>on_hotspot_click FOR go_alv_grid_1.
  SET HANDLER lcl_event_handler=>on_button_click FOR go_alv_grid_1.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH_ALV_0100
*&---------------------------------------------------------------------*
FORM refresh_alv_0100 .

  DATA ls_stable TYPE lvc_s_stbl.
  ls_stable-row = abap_on.
  ls_stable-col = abap_on.

  CALL METHOD go_alv_grid_1->refresh_table_display
    EXPORTING
      is_stable = ls_stable  " With Stable Rows/Columns
*     I_SOFT_REFRESH =           " Without Sort, Filter, etc.
    EXCEPTIONS
      finished  = 1                " Display was Ended (by Export)
      OTHERS    = 2.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CALL METHOD go_alv_grid_2->refresh_table_display
    EXPORTING
      is_stable = ls_stable  " With Stable Rows/Columns
*     I_SOFT_REFRESH =           " Without Sort, Filter, etc.
    EXCEPTIONS
      finished  = 1                " Display was Ended (by Export)
      OTHERS    = 2.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM get_fieldcat_0100 .

  "DATA GT_FIELDCAT TYPE LVC_T_FCAT.
  DATA: lt_fieldcat TYPE kkblo_t_fieldcat.

  REFRESH gt_fieldcat.

  CALL FUNCTION 'K_KKB_FIELDCAT_MERGE'
    EXPORTING
      i_callback_program     = sy-repid
      i_tabname              = 'GS_DISPLAY'
*     I_STRUCNAME            =
      i_inclname             = sy-repid
      i_bypassing_buffer     = abap_on
      i_buffer_active        = abap_off
    CHANGING
      ct_fieldcat            = lt_fieldcat
    EXCEPTIONS
      inconsistent_interface = 1
      OTHERS                 = 2.

  IF sy-subrc EQ 0.
    CALL FUNCTION 'LVC_TRANSFER_FROM_KKBLO'
      EXPORTING
        it_fieldcat_kkblo = lt_fieldcat " KKBLO
      IMPORTING
        et_fieldcat_lvc   = gt_fieldcat " LVC
      EXCEPTIONS
        it_data_missing   = 1
        OTHERS            = 2.

    IF sy-subrc NE 0.
      MESSAGE e022.
    ENDIF.

  ELSE.
    MESSAGE e022. "Field Catalog 생성 및 변환 중 오류가 발생했습니다.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_FIELDCAT2
*&---------------------------------------------------------------------*
FORM get_fieldcat2 USING pt_tab TYPE STANDARD TABLE
                       CHANGING pt_fcat TYPE lvc_t_fcat.

  DATA: lo_dref TYPE REF TO data.

  CREATE DATA lo_dref LIKE pt_tab.
  FIELD-SYMBOLS <lt_tab> TYPE table.
  ASSIGN lo_dref->* TO <lt_tab>.

  TRY.
      CALL METHOD cl_salv_table=>factory
        IMPORTING
          r_salv_table = DATA(lr_table)
        CHANGING
          t_table      = <lt_tab>.

    CATCH cx_salv_msg. " ALV: General Error Class with Message
  ENDTRY.

  pt_fcat = cl_salv_controller_metadata=>get_lvc_fieldcatalog(
              r_columns      = lr_table->get_columns( )
              r_aggregations = lr_table->get_aggregations( )
            ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FILTER
*&---------------------------------------------------------------------*
FORM set_alv_filter .

  " ALV에 Filter 정보를 적용하는 과정
  CALL METHOD go_alv_grid_1->set_filter_criteria
    EXPORTING
      it_filter = gt_filter                " Filter Conditions
    EXCEPTIONS
      OTHERS    = 1.

  IF sy-subrc NE 0.
    MESSAGE e000 WITH '필터 적용에 실패하였습니다'.
  ENDIF.

  " ALV가 새로고침될 때, 현재 라인, 열을 유지할 지
  DATA ls_stable TYPE lvc_s_stbl.
  ls_stable-row = abap_on.
  ls_stable-col = abap_on.

  " 적용된 Filter 기준으로 데이터를 출력
  CALL METHOD go_alv_grid_1->refresh_table_display
    EXPORTING
      is_stable = ls_stable                  " With Stable Rows/Columns
*     I_SOFT_REFRESH =                  " Without Sort, Filter, etc.
    EXCEPTIONS
      OTHERS    = 1.

  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLER_TOOLBAR
*&---------------------------------------------------------------------*
FORM handler_toolbar
  USING po_object TYPE REF TO cl_alv_event_toolbar_set
        po_sender TYPE REF TO cl_gui_alv_grid.

  " Internal Table PO_OBJECT->MT_TOOLBAR 를 위한 작업공간
  " PO_OBJECT->MT_TOOLBAR >>> 클래스의 Attribute ( Public , Instance )
  DATA ls_toolbar LIKE LINE OF po_object->mt_toolbar.

** 구분자 =>> |
*  CLEAR LS_TOOLBAR.
*  LS_TOOLBAR-BUTN_TYPE = 3. " 구분자
*  APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.
*
** 버튼 추가 =>> 예약취소
*  CLEAR LS_TOOLBAR.
*  LS_TOOLBAR-BUTN_TYPE = 0. " 버튼
*  LS_TOOLBAR-FUNCTION = GC_BOOKING_CANCEL.
*  LS_TOOLBAR-TEXT = '예약취소'.
*  APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.
*
** CONSTANTS GC_CHANGE_CLASS TYPE SY-UCOMM VALUE 'CHANGE_CLASS'.
*
** 버튼 추가 =>> 좌석등급변경
*  CLEAR LS_TOOLBAR.
*  LS_TOOLBAR-FUNCTION = GC_CHANGE_CLASS.
*  LS_TOOLBAR-TEXT     = TEXT-L02. " 좌석등급변경
*  APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.
*
** 구분자 =>> |
*  CLEAR LS_TOOLBAR.
*  LS_TOOLBAR-BUTN_TYPE = 3. " 구분자
*  APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.
*
*  DATA LV_TOTAL TYPE I.
*  DATA LV_GREEN TYPE I.
*  DATA LV_YELLOW TYPE I.
*  DATA LV_RED TYPE I.
*
*  LOOP AT GT_DISPLAY INTO GS_DISPLAY.
*    ADD 1 TO LV_TOTAL.
*
*    CASE GS_DISPLAY-LIGHT.
*      WHEN '1'. ADD 1 TO LV_RED.
*      WHEN '2'. ADD 1 TO LV_YELLOW.
*      WHEN '3'. ADD 1 TO LV_GREEN.
*    ENDCASE.
*
*  ENDLOOP.
*
** 버튼 추가 =>> Totals:  #,###
*  CLEAR LS_TOOLBAR.
*  LS_TOOLBAR-FUNCTION = GC_CLEAR_FILTER.
**  DESCRIBE TABLE GT_DISPLAY.
*  DATA LV_LINES TYPE I.
*  LV_LINES = LINES( GT_DISPLAY ).
*  LS_TOOLBAR-TEXT     = TEXT-L03 && ':' && LV_LINES. " Totals
*  APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.
*
** 버튼 추가 =>> 완료된 예약: #,###
*  CLEAR LS_TOOLBAR.
*  LS_TOOLBAR-FUNCTION = GC_GREEN_FILTER.
*  LS_TOOLBAR-TEXT     = TEXT-L04 && ':' && LV_GREEN. " 완료된 예약
*  APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.
*
** 버튼 추가 =>> 완료된 예약: #,###
*  CLEAR LS_TOOLBAR.
*  LS_TOOLBAR-FUNCTION = GC_YELLOW_FILTER.
*  LS_TOOLBAR-TEXT     = TEXT-L05 && ':' && LV_YELLOW. " 예정된 예약
*  APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.
*
** 버튼 추가 =>> 완료된 예약: #,###
*  CLEAR LS_TOOLBAR.
*  LS_TOOLBAR-FUNCTION = GC_RED_FILTER.
*  LS_TOOLBAR-TEXT     = TEXT-L06 && ':' && LV_RED. " 취소된 예약
*  APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_USER_COMMAND
*&---------------------------------------------------------------------*
*&   --> E_UCOMM   ->> PO_UCOMM
*&   --> SENDER    ->> PO_SENDER
*&---------------------------------------------------------------------*
FORM handle_user_command USING pv_ucomm TYPE sy-ucomm
                               po_sender  TYPE REF TO cl_gui_alv_grid.

  CASE po_sender.
    WHEN go_alv_grid_1. "PO_SENDER 가 GO_ALV_GRID 일 때
*      CASE PV_UCOMM.  " 선택한 버튼 (PV_UCOMM은 SY-UCOMM 타입)

*       WHEN GC_BOOKING_CANCEL.
*          " 예약 취소
*          PERFORM BOOKING_CANCEL USING PO_SENDER.

*      ENDCASE.

  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_HOTSPOT_CLICK
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_ROW_ID
*&      --> E_COLUMN_ID
*&      --> SENDER
*&---------------------------------------------------------------------*
FORM handle_hotspot_click USING ps_row_id TYPE lvc_s_row
                                ps_column_id TYPE  lvc_s_col
                                po_sender    TYPE REF TO cl_gui_alv_grid.

* 선택한 행이 인터널테이블에 있는 정상적인 데이터인지 체크
  CHECK ps_row_id-rowtype IS INITIAL.

**   HOTSPOT 옵션이 적용된 필드들 중에서
*    CASE PS_COLUMN_ID-FIELDNAME.
*
*      WHEN 'CLASS'. " 클릭한 필드가 CLASS 필드일 때
*
*        " 좌석 변경
*        PERFORM CHANGE_CLASS USING PO_SENDER.
*
*      WHEN OTHERS.
*
*    ENDCASE.





ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_DOUBLE_CLICK
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_ROW
*&      --> E_COLUMN
*&      --> SENDER
*&---------------------------------------------------------------------*
FORM handle_double_click USING ps_row TYPE lvc_s_row
                               ps_col     TYPE  lvc_s_col
                               po_sender  TYPE REF TO cl_gui_alv_grid.

* 선택한 행이 인터널테이블에 있는 정상적인 데이터인지 체크
  CHECK ps_row-rowtype IS INITIAL.

  READ TABLE gt_display INTO gs_display INDEX ps_row-index.

  SELECT  *
    FROM sflight
    INTO CORRESPONDING FIELDS OF TABLE gt_display2
    WHERE carrid EQ gs_display-carrid
      AND connid EQ gs_display-connid.

  PERFORM refresh_alv_0100.


*  CASE PS_COL-FIELDNAME.
*    WHEN 'CARRID' OR 'CARRNAME'.
*
*      " 항공사ID 또는 항공사명을 더블 클릭하면
*      " TRANSACTION BC402MCAR 를 호출한다
*      IF PS_ROW-ROWTYPE IS INITIAL.
*        READ TABLE GT_DISPLAY INTO GS_DISPLAY INDEX PS_ROW-INDEX..
*        SET PARAMETER ID 'CAR' FIELD GS_DISPLAY-CARRID.
*        CALL TRANSACTION 'BC402MCAR'
*          AND SKIP FIRST SCREEN.
*      ENDIF.
*
*
*  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_BUTTON_CLICK
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ES_ROW_NO
*&      --> ES_COL_ID
*&      --> SENDER
*&---------------------------------------------------------------------*
FORM handle_button_click USING ps_row_no
                                   ps_col_id
                                   po_sender.


**** MAKE DISPLAY_DATA 에서 다음과 같이 버튼 필드를 설정한다.
*FORM MAKE_DISPLAY_DATA .
*
*  DATA LS_STYLE TYPE LVC_S_STYL.  " GS_DISPLAY-STYLE 의 작업공간
*
*  REFRESH GT_DISPLAY.
*
*  " GT_DATA 의 데이터를 GT_DISPLAY 로 옮긴다.
*  " 옮기는 중 추가로 작업할 내용들도 같이 기록한다.
*  LOOP AT GT_DATA INTO GS_DATA.
*
*    CLEAR GS_DISPLAY.
*    MOVE-CORRESPONDING GS_DATA TO GS_DISPLAY. " 동일한 필드명에게 값 전달
*
*    " 내일부터 출발하는 비행기들은 취소가 가능하도록 버튼을 생성함.
*    IF GS_DISPLAY-FLDATE > SY-DATUM.
*      GS_DISPLAY-CANCEL_BTTXT = TEXT-L01. "'일정 취소'(L01).
*
*      " CANCEL_BTTXT 라는 필드는 스타일을 버튼으로 취급하는 정보를
*      " Internal Table 인 GS_DISPLAY-STYLE 에 한 줄 추가한다.
*      CLEAR LS_STYLE.
*      LS_STYLE-FIELDNAME = 'CANCEL_BTTXT'.
*      LS_STYLE-STYLE     = CL_GUI_ALV_GRID=>MC_STYLE_BUTTON.
*      APPEND LS_STYLE TO GS_DISPLAY-STYLE.
*
*    ENDIF.
*
*    " GS_DATA 와 그리고 내일부터 출발하는 비행기들만 CANCLE_BTTXT 필드와
*    " STYLE 필드에 특별한 값들이 저장된 GS_DISPLAY 를 GT_DISPLAY 로 한 줄 추가한다.
*    APPEND GS_DISPLAY TO GT_DISPLAY.
*
*  ENDLOOP.
*
*ENDFORM.
*--------------------------------------------------------------------*
* SET_ALV_LAYOUT_0100에서 다음과 같이 세팅
*GS_LAYOUT-STYLEFNAME  = 'STYLE'.

*--------------------------------------------------------------------*
* 구현 예시)
*  METHOD ON_BUTTON_CLICK. " 위 정의에 대한 구현
*
*    DATA LV_MSG TYPE STRING.
*
*    CASE ES_COL_ID-FIELDNAME.
*      WHEN 'MPTEXT'. " 구매계획내역
*
*        " 현재 선택하신 버튼은 &1 번째 줄의 &2 열 입니다.
*        " &1 = ES_ROW_NO-ROW_ID     = 내가 선택한 버튼의 행 위치
*        " &2 = ES_COL_ID-FIELDNAME  = 내가 선택한 버튼의 열 위치
*        LV_MSG = '현재 선택하신 버튼은 ' && ES_ROW_NO-ROW_ID && '번째 줄의'
*            && ES_COL_ID-FIELDNAME && ' 열 입니다.'.
*
*        LV_MSG = |현재 선택하신 버튼은 { ES_ROW_NO-ROW_ID }| &&
*                 | 번째 줄의 { ES_COL_ID-FIELDNAME } 열 입니다.|.
*
*         LV_MSG = |현재 선택하신 버튼은 { ES_ROW_NO-ROW_ID } 번째 줄의 { ES_COL_ID-FIELDNAME } 열 입니다. |.
*
*        MESSAGE LV_MSG TYPE 'I'.
*
*        DATA LV_ANSWER TYPE C.
*
*        CALL FUNCTION 'POPUP_TO_CONFIRM_STEP_2_BUTTON'
*          EXPORTING
**            DEFAULTOPTION  = 'Y'              " Cursorpositionierung auf Antwort Ja oder Nein
*            TEXTLINE1      =  TEXT-M01 "'예약을 취소하시겠습니까?'
**            TEXTLINE2      = SPACE            " zweite Zeile des Dialogfensters
*            TITEL          = TEXT-T03 " 확인
**            START_COLUMN   = 25               " Startspalte des Dialogfensters
**            START_ROW      = 6                " Startzeile des Dialogfensters
**            CANCEL_DISPLAY = ''              " Abbrechen-Knopf anzeigen
*          IMPORTING
*            ANSWER         = LV_ANSWER.                 " ausgewählte Antwort des Endanwenders
*
**          LV_MSG = |내가 선택한 버튼의 값은 { LV_ANSWER } 이다.|.
**          MESSAGE LV_MSG TYPE 'I'.
*
*          CASE LV_ANSWER.
*            WHEN 'J'. " Yes 예 버튼 눌렀을 때
*
*              " ES_ROW_NO-ROW_ID : 내가 버튼을 누른 행 번호
*              "GT_DISPLAY 에서 내가 누른 버튼이 있는 행을 삭제하겠다.
*              DELETE GT_DISPLAY INDEX ES_ROW_NO-ROW_ID.
*
*              DATA LS_STABLE TYPE LVC_S_STBL.
*              " 행의 스크롤 바 고정, 가로 스크롤바도 고정
*              LS_STABLE-ROW = ABAP_ON. " 현재 행의 위치에 여전히 머무르겠다.
*              LS_STABLE-COL = ABAP_ON. " 현재 열의 위치에 여전히 머무르겠다.
*
*              CALL METHOD GO_ALV_GRID->REFRESH_TABLE_DISPLAY
*                EXPORTING
*                  IS_STABLE      = LS_STABLE
**                  I_SOFT_REFRESH =                  " Without Sort, Filter, etc.
*                EXCEPTIONS
*                  FINISHED       = 1                " Display was Ended (by Export)
*                  OTHERS         = 2.
*
*              IF SY-SUBRC <> 0.
*               MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*                 WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*              ENDIF.
*
*            WHEN OTHERS.
*          ENDCASE.
*
*      WHEN OTHERS.         " 아니면 다른 버튼인지
*
*    ENDCASE.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_DATA_CHANGED
*&---------------------------------------------------------------------*
FORM handle_data_changed
  USING pr_data_changed TYPE REF TO cl_alv_changed_data_protocol
        pr_sender TYPE REF TO cl_gui_alv_grid.


  DATA(lt_mod) = pr_data_changed->mt_mod_cells[].

  IF lt_mod[] IS NOT INITIAL.
    gv_changed = abap_on.
  ENDIF.

ENDFORM.
