*&---------------------------------------------------------------------*
*& Include          ZALV_GRID_CRUD_PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE EXIT_0100 INPUT.

  CASE OK_CODE.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'CANC'.
      LEAVE TO SCREEN 0.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.

  CALL METHOD GO_ALV_GRID->CHECK_CHANGED_DATA. " 바뀐 데이터 여부 체크

  CASE OK_CODE.
    WHEN 'BACK'.
      CLEAR SY-SUBRC.
      IF ZEA_MMT010-MATGRP IS INITIAL AND ZEA_MMT010-MATTYPE IS INITIAL.
        SY-SUBRC = 4.
      ENDIF.
      LEAVE TO SCREEN 0.

    WHEN 'SAVE'.
      _MC_POPUP_CONFIRM 'SAVE' '저장하시겠습니까?' GV_ANSWER.
      CHECK GV_ANSWER = '1'.

      PERFORM DATA_SAVE.
      PERFORM MAKE_DISPLAY_DATA.
      PERFORM REFRESH_ALV_0100.

    WHEN 'REFRESH'.
      PERFORM REFRESH_ALV_0100.

    WHEN 'INSERT'.

      PERFORM DATA_INSERT.

      PERFORM REFRESH_ALV_0100.

    WHEN 'EDIT'.
      PERFORM EDIT_MODE.


    WHEN 'DELETE'.
      _MC_POPUP_CONFIRM 'DELETE' '정말 삭제하시겠습니까?' GV_ANSWER.
      CHECK GV_ANSWER = '1'.

*      PERFORM DATA_DELETE.
      PERFORM DELETE_DATA.
    WHEN 'BTN_SEARCH'.
*            PERFORM MAKE_DISPLAY_DATA.
      PERFORM SEARCH_MT.

*      PERFORM REFRESH_ALV_0100.

  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT_0110  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE EXIT_0110 INPUT.
  CASE OK_CODE.
    WHEN 'CANC'.
      MESSAGE S000 DISPLAY LIKE 'W' WITH '생성 작업이 취소되었습니다.'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Form DATA_INSERT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DATA_INSERT .

  CALL SCREEN 0110 STARTING AT 50 5.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0110  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE  USER_COMMAND_0110 INPUT.

  DATA: RAD1 TYPE ABAP_BOOL,
        RAD2 TYPE ABAP_BOOL,
        RAD3 TYPE ABAP_BOOL.

  CASE OK_CODE.
    WHEN 'SAVE'.
      CLEAR GS_DISPLAY.
      " 현재 사용자, 날짜, 시간 설정
      ZEA_MMT010-ERNAM = SY-UNAME.
      ZEA_MMT010-ERDAT = SY-DATUM.
      ZEA_MMT010-ERZET = SY-UZEIT.
      MOVE-CORRESPONDING ZEA_MMT010 TO GS_DISPLAY.
      GS_DISPLAY-MAKTX = ZEA_MMT020-MAKTX.
      MOVE-CORRESPONDING GT_DISPLAY TO GT_DATA.


      " 라디오 버튼의 값을 확인하여 zea_mmt010-mattype 설정
      IF RAD1 = ABAP_TRUE.
        CASE ZEA_MMT010-MATGRP.
          WHEN '001'.
            ZEA_MMT010-MATTYPE = '원자재'.
            GS_DISPLAY-MATTYPE = ZEA_MMT010-MATTYPE.
            GS_DISPLAY-STATUS = ICON_LED_YELLOW.
            PERFORM GET_INFO_NUMBERRANGE.
          WHEN OTHERS.
            MESSAGE | 자재그룹이 올바르지 않습니다.| TYPE 'E'.
        ENDCASE.


      ELSEIF RAD2 = ABAP_TRUE.
        CASE ZEA_MMT010-MATGRP.
          WHEN '002'.
            ZEA_MMT010-MATTYPE = '반제품'.
            GS_DISPLAY-MATTYPE = ZEA_MMT010-MATTYPE.
            GS_DISPLAY-STATUS = ICON_LED_GREEN.
            PERFORM GET_INFO_NUMBERRANGE2.
          WHEN OTHERS.
            MESSAGE | 자재그룹이 올바르지 않습니다.| TYPE 'E'.
        ENDCASE.

      ELSEIF RAD3 = ABAP_TRUE.
        CASE ZEA_MMT010-MATGRP.
          WHEN '001'.
            MESSAGE | 자재그룹이 올바르지 않습니다.| TYPE 'E'.
          WHEN '002'.
            MESSAGE | 자재그룹이 올바르지 않습니다.| TYPE 'E'.
          WHEN OTHERS.
            ZEA_MMT010-MATTYPE = '완제품'.
            GS_DISPLAY-MATTYPE = ZEA_MMT010-MATTYPE.
            GS_DISPLAY-STATUS = ICON_BUSINAV_PROC_EXIST.
            PERFORM GET_INFO_NUMBERRANGE3.
        ENDCASE.
      ENDIF.



      DATA LS_MMT010 TYPE ZEA_MMT010.
      DATA LS_MMT020 TYPE ZEA_MMT020.
      DATA LT_MMT020 TYPE TABLE OF ZEA_MMT020.


      LS_MMT010-MATNR    = ZEA_MMT010-MATNR.
      LS_MMT010-MATTYPE  = ZEA_MMT010-MATTYPE.
      LS_MMT010-MATGRP   = ZEA_MMT010-MATGRP.
      LS_MMT010-BSTME    = ZEA_MMT010-BSTME.
      LS_MMT010-MEINS2   = ZEA_MMT010-MEINS2.
      LS_MMT010-WEIGHT   = ZEA_MMT010-WEIGHT.
      LS_MMT010-MEINS1   = ZEA_MMT010-MEINS1.
      LS_MMT010-STPRS    = ZEA_MMT010-STPRS.
      LS_MMT010-WAERS    = ZEA_MMT010-WAERS.
      LS_MMT020-MATNR    = ZEA_MMT010-MATNR.
      LS_MMT020-MAKTX    = ZEA_MMT020-MAKTX.
      LS_MMT020-SPRAS    = SY-LANGU.
      LS_MMT020-ERNAM    = SY-UNAME.
      LS_MMT020-ERDAT    = SY-DATUM.
      LS_MMT020-ERZET    = SY-UZEIT.


      INSERT ZEA_MMT010 FROM LS_MMT010.
      INSERT ZEA_MMT020 FROM LS_MMT020.

      GS_DISPLAY-MATNR = ZEA_MMT010-MATNR.


      IF SY-SUBRC = 0.
        APPEND GS_DISPLAY TO GT_DISPLAY.

        COMMIT WORK AND WAIT.

        MESSAGE S015.  " 데이터 성공적으로 저장되었습니다.
        LEAVE TO SCREEN 0.
      ELSE.
        ROLLBACK WORK. " 데이터 저장 중 오류가 발생했습니다.
        MESSAGE E016.
      ENDIF.


  ENDCASE.

ENDMODULE.
