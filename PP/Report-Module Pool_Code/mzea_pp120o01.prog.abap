*&---------------------------------------------------------------------*
*& Include          MZEA_PP110O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.
  SET PF-STATUS 'S0100'.
  SET TITLEBAR 'T0100'.

  " SY-UNAME 현재 사용자
  " SY-DATUM 현재 날짜
  " SY-UZEIT 현재 시간

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CLEAR_OK_CODE OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE CLEAR_OK_CODE OUTPUT.
  CLEAR OK_CODE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ALV_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE INIT_ALV_0100 OUTPUT.

  IF GO_CONTAINER IS INITIAL.
    PERFORM SELECT_DATA.
    PERFORM MAKE_DISPLAY_DATA.

    PERFORM CREATE_OBJECT_0100.
    PERFORM SET_ALV_FIELDCAT_0100.
    PERFORM SET_ALV_LAYOUT_0100.
    PERFORM SET_ALV_EVENT_0100.
    PERFORM DISPLAY_ALV_0100.
  ELSE.
    PERFORM MODIFY_DISPLAY_DATA.
    PERFORM REFRESH_ALV_0100.
  ENDIF.

  IF GO_CONTAINER_1 IS INITIAL.
    PERFORM CREATE_OBJECT_1_0100.
    PERFORM SET_ALV_FIELDCAT_1_0100.
    PERFORM SET_ALV_LAYOUT_1_0100.
    PERFORM SET_ALV_EVENT_1_0100.
    PERFORM DISPLAY_ALV_1_0100.
  ELSE.
    PERFORM REFRESH_ALV_1_0100.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module FILL_DYNNR_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE FILL_DYNNR_0100 OUTPUT.


  CASE  TABSTRIP-ACTIVETAB.
    WHEN 'TAB1'.
      IF GV_COUNT EQ GV_LINES.
        TABSTRIP-ACTIVETAB = 'TAB2'.
        CLEAR GV_COUNT.
      ENDIF.
    WHEN 'TAB2'.
       IF GV_COUNT EQ GV_LINES.
        TABSTRIP-ACTIVETAB = 'TAB3'.
        CLEAR GV_COUNT.
      ENDIF.
    WHEN 'TAB3'.
       IF GV_COUNT EQ GV_LINES.
        TABSTRIP-ACTIVETAB = 'TAB4'.
        CLEAR GV_COUNT.
      ENDIF.
    WHEN 'TAB4'.
       IF GV_COUNT EQ GV_LINES.
        TABSTRIP-ACTIVETAB = 'TAB5'.
        CLEAR GV_COUNT.
      ENDIF.
    WHEN 'TAB5'.
       IF GV_COUNT EQ GV_LINES.
        TABSTRIP-ACTIVETAB = 'TAB6'.
        GV_TAB6 = ABAP_ON.
        CLEAR GV_COUNT.
      ENDIF.
    WHEN 'TAB6'.
       IF GV_COUNT EQ GV_LINES.
        CLEAR GV_COUNT.
      ENDIF.

    WHEN OTHERS.
  ENDCASE.

  CASE TABSTRIP-ACTIVETAB.
    WHEN 'TAB1'. " 첫번째 탭이 눌려있다면
      GV_DYNNR = '0110'. " Tabpage 는 110번 화면을 보여준다.

      IF GV_CHECK EQ ABAP_ON.
        PERFORM SELECT_STEP1.
      ENDIF.

      CLEAR : GT_WWWTAB.
      SELECT SINGLE *
        INTO GT_WWWTAB
        FROM WWWPARAMS
       WHERE RELID  =  'MI'
         AND OBJID  =  'ZEA_PP110_1'.

      CALL FUNCTION 'DP_PUBLISH_WWW_URL'
        EXPORTING
          OBJID    = GT_WWWTAB-OBJID
          LIFETIME = 'T'
        IMPORTING
          URL      = URL
        EXCEPTIONS
          OTHERS   = 1.


      IF SY-SUBRC = 0.
        CALL METHOD PIC1->LOAD_PICTURE_FROM_URL_ASYNC
          EXPORTING
            URL = URL.
      ENDIF.


      PERFORM REFRESH_ALV_1_0100.

    WHEN 'TAB2'. " 두번째 탭이 눌려있다면
      GV_DYNNR = '0120'. " Tabpage 는 120번 화면을 보여준다.
      PERFORM SELECT_STEP2.
*      SELECT *
*        INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY2
*        FROM ZEA_PLPO
*        WHERE RTSTEP EQ 2.

      CLEAR : GT_WWWTAB.
      SELECT SINGLE *
        INTO GT_WWWTAB
        FROM WWWPARAMS
       WHERE RELID  =  'MI'
         AND OBJID  =  'ZEA_PP110_2'.

      CALL FUNCTION 'DP_PUBLISH_WWW_URL'
        EXPORTING
          OBJID    = GT_WWWTAB-OBJID
          LIFETIME = 'T'
        IMPORTING
          URL      = URL
        EXCEPTIONS
          OTHERS   = 1.


      IF SY-SUBRC = 0.
        CALL METHOD PIC1->LOAD_PICTURE_FROM_URL_ASYNC
          EXPORTING
            URL = URL.
      ENDIF.

    WHEN 'TAB3'. " 세번째 탭이 눌려있다면
      GV_DYNNR = '0130'. " Tabpage는 130번 화면을 보여준다.
      PERFORM SELECT_STEP3.
*      SELECT *
*        INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY2
*        FROM ZEA_PLPO
*        WHERE RTSTEP EQ 3.

      CLEAR : GT_WWWTAB.
      SELECT SINGLE *
        INTO GT_WWWTAB
        FROM WWWPARAMS
       WHERE RELID  =  'MI'
         AND OBJID  =  'ZEA_PP110_3'.

      CALL FUNCTION 'DP_PUBLISH_WWW_URL'
        EXPORTING
          OBJID    = GT_WWWTAB-OBJID
          LIFETIME = 'T'
        IMPORTING
          URL      = URL
        EXCEPTIONS
          OTHERS   = 1.


      IF SY-SUBRC = 0.
        CALL METHOD PIC1->LOAD_PICTURE_FROM_URL_ASYNC
          EXPORTING
            URL = URL.
      ENDIF.

    WHEN 'TAB4'. " 네번째 탭이 눌려있다면
      GV_DYNNR = '0140'. " Tabpage 는 140번 화면을 보여준다.
      PERFORM SELECT_STEP4.
*      SELECT *
*        INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY2
*        FROM ZEA_PLPO
*        WHERE RTSTEP EQ 4.

      CLEAR : GT_WWWTAB.
      SELECT SINGLE *
        INTO GT_WWWTAB
        FROM WWWPARAMS
       WHERE RELID  =  'MI'
         AND OBJID  =  'ZEA_PP110_4'.

      CALL FUNCTION 'DP_PUBLISH_WWW_URL'
        EXPORTING
          OBJID    = GT_WWWTAB-OBJID
          LIFETIME = 'T'
        IMPORTING
          URL      = URL
        EXCEPTIONS
          OTHERS   = 1.


      IF SY-SUBRC = 0.
        CALL METHOD PIC1->LOAD_PICTURE_FROM_URL_ASYNC
          EXPORTING
            URL = URL.
      ENDIF.

    WHEN 'TAB5'. " 다번째 탭이 눌려있다면
      GV_DYNNR = '0150'. " Tabpage 는 150번 화면을 보여준다.
      PERFORM SELECT_STEP5.
*      SELECT *
*        INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY2
*        FROM ZEA_PLPO
*        WHERE RTSTEP EQ 5.

      CLEAR : GT_WWWTAB.
      SELECT SINGLE *
        INTO GT_WWWTAB
        FROM WWWPARAMS
       WHERE RELID  =  'MI'
         AND OBJID  =  'ZEA_PP110_5'.

      CALL FUNCTION 'DP_PUBLISH_WWW_URL'
        EXPORTING
          OBJID    = GT_WWWTAB-OBJID
          LIFETIME = 'T'
        IMPORTING
          URL      = URL
        EXCEPTIONS
          OTHERS   = 1.


      IF SY-SUBRC = 0.
        CALL METHOD PIC1->LOAD_PICTURE_FROM_URL_ASYNC
          EXPORTING
            URL = URL.
      ENDIF.

    WHEN 'TAB6'. " 여섯번째 탭이 눌려있다면
      GV_DYNNR = '0160'. " Tabpage는 160번 화면을 보여준다.
      PERFORM SELECT_STEP6.
*      SELECT *
*        INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY2
*        FROM ZEA_PLPO
*        WHERE RTSTEP EQ 6.

      CLEAR : GT_WWWTAB.
      SELECT SINGLE *
        INTO GT_WWWTAB
        FROM WWWPARAMS
       WHERE RELID  =  'MI'
         AND OBJID  =  'ZEA_PP110_6'.

      CALL FUNCTION 'DP_PUBLISH_WWW_URL'
        EXPORTING
          OBJID    = GT_WWWTAB-OBJID
          LIFETIME = 'T'
        IMPORTING
          URL      = URL
        EXCEPTIONS
          OTHERS   = 1.


      IF SY-SUBRC = 0.
        CALL METHOD PIC1->LOAD_PICTURE_FROM_URL_ASYNC
          EXPORTING
            URL = URL.
      ENDIF.

    WHEN OTHERS.


      " 1~3 탭이 아니라면 강제로 첫번째 탭을 선택하고
      " Tabpage는 110번 화면을 보여준다.
      TABSTRIP-ACTIVETAB = 'TAB1'.
      GV_DYNNR = '0110'.

      CLEAR : GT_WWWTAB.
      SELECT SINGLE *
        INTO GT_WWWTAB
        FROM WWWPARAMS
       WHERE RELID  =  'MI'
         AND OBJID  =  'ZEA_PP110_1'.

      CREATE OBJECT CONTAINER1
        EXPORTING
          CONTAINER_NAME = 'PIC1'.


      CREATE OBJECT PIC1
        EXPORTING
          PARENT = CONTAINER1.


** 이미지 크기에 맞게 보임.
      CALL METHOD PIC1->SET_DISPLAY_MODE
        EXPORTING
          DISPLAY_MODE = CL_GUI_PICTURE=>DISPLAY_MODE_NORMAL.

* 컨테이너 영역크기에 맞춰 보여주기
*  CALL METHOD PIC1->SET_DISPLAY_MODE
*    EXPORTING
*      DISPLAY_MODE = CL_GUI_PICTURE=>DISPLAY_MODE_STRETCH.

      CALL FUNCTION 'DP_PUBLISH_WWW_URL'
        EXPORTING
          OBJID    = GT_WWWTAB-OBJID
          LIFETIME = 'T'
        IMPORTING
          URL      = URL
        EXCEPTIONS
          OTHERS   = 1.


      IF SY-SUBRC = 0.
        CALL METHOD PIC1->LOAD_PICTURE_FROM_URL_ASYNC
          EXPORTING
            URL = URL.
      ENDIF.

  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_TIMER_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE INIT_TIMER_0100 OUTPUT.

  IF GO_TIMER IS INITIAL.

*   create timer
    CREATE OBJECT GO_TIMER.
*
**   event handler
*    CREATE OBJECT GO_EVENT.
*    SET HANDLER GO_EVENT->M_TIMER_FINISHED FOR GO_TIMER.

*   set interval in seconds
    MOVE 1  TO GO_TIMER->INTERVAL.

*    GO_TIMER->RUN( ).

  ENDIF.

ENDMODULE.
