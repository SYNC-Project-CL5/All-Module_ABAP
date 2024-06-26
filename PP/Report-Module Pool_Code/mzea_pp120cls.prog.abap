*&---------------------------------------------------------------------*
*& Include          MZEA_PP110CLS
*&---------------------------------------------------------------------*
CLASS LCL_EVENT_HANDLER DEFINITION.

  PUBLIC SECTION.
    "Static Method
    CLASS-METHODS:
      ON_BUTTON_CLICK FOR EVENT BUTTON_CLICK OF CL_GUI_ALV_GRID
        IMPORTING ES_ROW_NO     " LVC_S_ROID (ROW_ID)
                  ES_COL_ID     " LVC_S_COL  (FIELDNAME)
                  SENDER,


      ON_DOUBLE_CLICK FOR EVENT DOUBLE_CLICK OF CL_GUI_ALV_GRID
        IMPORTING E_ROW         " LVC_S_ROW  (ROWTYPE, INDEX)
                  E_COLUMN      " LVC_S_COL  (FIELDNAME)
                  ES_ROW_NO     " LVC_S_ROID (ROW_ID)
                  SENDER,

      ON_TOOLBAR FOR EVENT TOOLBAR OF CL_GUI_ALV_GRID
        IMPORTING E_OBJECT      " MT_TOOLBAR Attribute 보유,
                  " TYPE TTB_BUTTON
                  " LINE TYPE STB_BUTTON
                  E_INTERACTIVE
                  SENDER,

      ON_USER_COMMAND FOR EVENT USER_COMMAND OF CL_GUI_ALV_GRID
        IMPORTING E_UCOMM       " SY-UCOMM
                  SENDER,

      ON_HOTSPOT_CLICK FOR EVENT HOTSPOT_CLICK OF CL_GUI_ALV_GRID
        IMPORTING E_ROW_ID      " LVC_S_ROW  (ROWTYPE, INDEX)
                  E_COLUMN_ID   " LVC_S_COL  (FIELDNAME)
                  ES_ROW_NO     " LVC_S_ROID (ROW_ID)
                  SENDER,

      ON_DATA_CHANGED FOR EVENT DATA_CHANGED OF CL_GUI_ALV_GRID
        IMPORTING ER_DATA_CHANGED
                  SENDER,

      ON_FINISHED FOR EVENT FINISHED OF CL_GUI_TIMER.


ENDCLASS.

CLASS LCL_EVENT_HANDLER IMPLEMENTATION.

  METHOD ON_BUTTON_CLICK.
    PERFORM HANDLE_BUTTON_CLICK USING ES_ROW_NO
                                      ES_COL_ID
                                      SENDER.
  ENDMETHOD.

  METHOD ON_DOUBLE_CLICK.
    PERFORM HANDLE_DOUBLE_CLICK USING E_ROW
                                      E_COLUMN
                                      SENDER.
  ENDMETHOD.

  METHOD ON_TOOLBAR.
    PERFORM HANDLER_TOOLBAR USING E_OBJECT
                                  SENDER.
  ENDMETHOD.

  METHOD ON_USER_COMMAND.
    PERFORM HANDLE_USER_COMMAND USING E_UCOMM
                                      SENDER.
  ENDMETHOD.

  METHOD ON_HOTSPOT_CLICK.
    PERFORM HANDLE_HOTSPOT_CLICK USING E_ROW_ID
                                       E_COLUMN_ID
                                       SENDER.
  ENDMETHOD.

  METHOD ON_DATA_CHANGED.
    PERFORM HANDLE_DATA_CHANGED USING ER_DATA_CHANGED
                                      SENDER.
  ENDMETHOD.

  METHOD ON_FINISHED.
    "배치잡을 돌려서 진행하고 db에있는값으로 리프레쉬 고려
    DATA LV_BOMID TYPE ZEA_STKO-BOMID.

    IF GT_INDEX_ROWS[] IS INITIAL.
      " TEXT-M01: 라인을 선택하세요.
      MESSAGE S000 DISPLAY LIKE 'W' WITH '최소 한 행이상 선택하세요'.

    ELSE.

      DATA LV_SUBRC TYPE I.
*      DATA LV_COUNT TYPE I.
      DATA LV_RAND  TYPE INT2.  " 난수를 위한 변수

      DESCRIBE TABLE GT_INDEX_ROWS LINES GV_LINES.

      LOOP AT GT_INDEX_ROWS INTO GS_INDEX_ROWS WHERE ROWTYPE IS INITIAL.

        CLEAR GS_DISPLAY2.

        READ TABLE GT_DISPLAY2 INTO GS_DISPLAY2 INDEX GS_INDEX_ROWS-INDEX.

        IF GS_DISPLAY2-RTST IS INITIAL.
          GS_DISPLAY2-RTST = SY-UZEIT.
          READ TABLE GT_DISPLAY INTO GS_DISPLAY WITH KEY RTID = GS_DISPLAY2-RTID.
          IF SY-SUBRC EQ 0 AND GS_DISPLAY-RTST IS INITIAL.
            GS_DISPLAY-RTST  = SY-UZEIT.
            MODIFY GT_DISPLAY FROM GS_DISPLAY INDEX SY-TABIX.

            " 자재감소 로직
*           생산오더에 맞는 BOMID 검색
            SELECT SINGLE BOMID
              FROM ZEA_PPT020
              INTO GV_BOMID
              WHERE AUFNR EQ GS_DISPLAY-AUFNR.

            PERFORM CALC_SUB_MAT.

            DATA : BEGIN OF LS_COLLECT,
*               BOMID   TYPE ZEA_STPO-BOMID,
                     MATNR   TYPE ZEA_STPO-MATNR,
                     MAKTX   TYPE ZEA_MMT020-MAKTX,
                     MATTYPE TYPE ZEA_MMT010-MATTYPE,
                     MENGE   TYPE ZEA_STPO-MENGE,
                     MEINS   TYPE ZEA_STPO-MEINS,
                   END OF LS_COLLECT.

            DATA LT_COLLECT LIKE TABLE OF LS_COLLECT.

            LOOP AT GT_STPO INTO GS_STPO.
              MOVE-CORRESPONDING GS_STPO TO LS_COLLECT.
              COLLECT LS_COLLECT INTO LT_COLLECT.
              CLEAR LS_COLLECT.
            ENDLOOP.

            SORT LT_COLLECT BY MATNR.

            IF LT_COLLECT[] IS NOT INITIAL.
              SELECT *
                FROM ZEA_MMT190
                 FOR ALL ENTRIES IN @LT_COLLECT
               WHERE MATNR EQ @LT_COLLECT-MATNR
                 AND WERKS EQ @GS_DISPLAY-WERKS
                INTO TABLE @DATA(LT_MMT190).

              SORT LT_MMT190 BY MATNR.
            ENDIF.

            DATA: LV_WEIGHT TYPE ZEA_MMT190-WEIGHT,
                  LV_CALQTY TYPE ZEA_MMT190-CALQTY.

            DATA: LV_CHECK.

            LOOP AT LT_COLLECT INTO LS_COLLECT.

              SELECT SINGLE BSTME, WEIGHT
                FROM ZEA_MMT010
               WHERE MATNR EQ @LS_COLLECT-MATNR
                INTO @DATA(LS_MMT010).

              " 1EA / 10KG * 100 KG =  10EA
              IF LS_MMT010-WEIGHT EQ 0.
                LV_CALQTY = 0.
              ELSE.
                LV_CALQTY = ( LS_COLLECT-MENGE * LS_MMT010-BSTME )  / LS_MMT010-WEIGHT.
              ENDIF.

              " 재고 데이터 중 현재 LS_COLLECT 의 자재코드 기준으로 점검
              LOOP AT LT_MMT190 INTO DATA(LS_MMT190) WHERE MATNR EQ LS_COLLECT-MATNR.

                IF LS_MMT190-WEIGHT < LS_COLLECT-MENGE.
                  " 해당 창고에 재고무게 부족
                  LS_COLLECT-MENGE = LS_COLLECT-MENGE - LS_MMT190-WEIGHT.
                  LS_MMT190-WEIGHT = 0.
                ELSE.
                  LS_MMT190-WEIGHT = LS_MMT190-WEIGHT - LS_COLLECT-MENGE.
                  LS_COLLECT-MENGE = 0.
                ENDIF.

                IF LS_MMT190-CALQTY < LV_CALQTY.
                  " 재고수량 부족
                  LV_CALQTY = LV_CALQTY - LS_MMT190-CALQTY.
                  LS_MMT190-CALQTY = 0.
                ELSE.
                  LS_MMT190-CALQTY = LS_MMT190-CALQTY - LV_CALQTY.
                  LS_MMT190-CALQTY = TRUNC( LS_MMT190-CALQTY ).
                  LV_CALQTY = 0.
                ENDIF.

                LS_MMT190-AEDAT = SY-DATUM.
                LS_MMT190-AEZET = SY-UZEIT.
                LS_MMT190-AENAM = SY-UNAME.

                MODIFY LT_MMT190 FROM LS_MMT190.
              ENDLOOP.

              IF LS_COLLECT-MENGE > 0 OR LV_CALQTY > 0.
                " 특정 자재의 모든 창고에서 물건을 전부 사용해도 부족한 경우
                " 오류 메시지 및 중단
                ROLLBACK WORK.
                LV_CHECK = 'X'.
                MESSAGE E000 WITH '재고가 부족합니다.'.
                EXIT.
              ELSE.
                UPDATE ZEA_MMT190 FROM TABLE LT_MMT190.
                IF SY-SUBRC NE 0.
                  ROLLBACK WORK.
                  LV_CHECK = 'X'.
                  EXIT.
                ENDIF.

                " 생성오더 생산시작일, 종료일 지정
                UPDATE ZEA_PPT020 SET SDATE    = SY-DATUM
                                      EDATE    = SY-DATUM
                                      AENAM    = SY-UNAME
                                      AEDAT    = SY-DATUM
                                      AEZET    = SY-UZEIT
                                WHERE AUFNR EQ GS_DISPLAY-AUFNR.

                IF SY-SUBRC NE 0.
                  ROLLBACK WORK.
                  LV_CHECK = 'X'.
                  EXIT.
                ENDIF.

              ENDIF.
            ENDLOOP.

*             자재증가 1PACKAGE = 4EA

*            CLEAR LS_MMT190.
*
*            SELECT SINGLE *
*              FROM ZEA_MMT190
*              INTO LS_MMT190
*              WHERE MATNR EQ GS_DISPLAY-MATNR
*                AND WERKS EQ GS_DISPLAY-WERKS.
*
*            IF SY-SUBRC EQ 0.
*              LS_MMT190-CALQTY += GV_TOT_QTY.
*              LS_MMT190-WEIGHT += GV_TOT_QTY * 4.
*
*              LS_MMT190-AEDAT = SY-DATUM.
*              LS_MMT190-AEZET = SY-UZEIT.
*              LS_MMT190-AENAM = SY-UNAME.
*
*              APPEND LS_MMT190 TO LT_MMT190.
*            ENDIF.
*
*
*            UPDATE ZEA_MMT190 FROM TABLE LT_MMT190.
*            IF SY-SUBRC NE 0.
*              ROLLBACK WORK.
*              LV_CHECK = 'X'.
*              EXIT.
*            ENDIF.


            IF LV_CHECK IS INITIAL.
              COMMIT WORK.

              DATA LT_MMT190CP TYPE TABLE OF ZEA_MMT190.
              MOVE-CORRESPONDING LT_MMT190 TO LT_MMT190CP.

              "자재문서 PP 함수
              CALL FUNCTION 'ZEA_MM_PPFG'
                EXPORTING
                  IV_AUFNR = GS_DISPLAY-AUFNR                 " 생산오더 ID
                  IT_ITEM  = LT_MMT190CP                 " 자재문서(재고테이블) 테이블 타입
*                IMPORTING
*                  ES_HEAD  =                  " [MM] 자재문서 Header
*                  ET_ITEM  =                  " 자재문서 ITEM 테이블타입

                .
            ENDIF.


          ENDIF.
        ENDIF.

        CALL FUNCTION 'RANDOM_I2'
          EXPORTING
            RND_MIN   = 20
            RND_MAX   = 40
          IMPORTING
            RND_VALUE = LV_RAND.

        GS_DISPLAY2-RTPERC += LV_RAND.
        IF GS_DISPLAY2-RTPERC >= 60.
          GS_DISPLAY2-RTPERC = 100.

          IF GS_DISPLAY2-RTET IS INITIAL.
            GS_DISPLAY2-RTET = SY-UZEIT.
            READ TABLE GT_DISPLAY INTO GS_DISPLAY WITH KEY RTID = GS_DISPLAY2-RTID.

            IF SY-SUBRC EQ 0.

              IF GV_TAB6 NE ABAP_ON.
                GS_DISPLAY-RTSTEP += 1.
              ELSE.
                GS_DISPLAY-RTET  = SY-UZEIT.
              ENDIF.
              MODIFY GT_DISPLAY FROM GS_DISPLAY INDEX SY-TABIX.
            ENDIF.
            GV_COUNT += 1.
          ENDIF.

        ENDIF.

        MODIFY GT_DISPLAY2 FROM GS_DISPLAY2 INDEX GS_INDEX_ROWS-INDEX.
*       TRANSPORTING RTPERC.

        UPDATE ZEA_PLKO SET RTST   = GS_DISPLAY-RTST
                            RTET   = GS_DISPLAY-RTET
                            RTSTEP = GS_DISPLAY-RTSTEP
                            AENAM  = SY-UNAME
                            AEDAT  = SY-DATUM
                            AEZET  = SY-UZEIT
                      WHERE RTID EQ  GS_DISPLAY-RTID.

        IF SY-SUBRC NE 0.
          ROLLBACK WORK.
          ADD SY-SUBRC TO LV_SUBRC.
        ENDIF.

        UPDATE ZEA_PLPO SET RTPERC =  GS_DISPLAY2-RTPERC
                            RTST   =  GS_DISPLAY2-RTST
                            RTET   =  GS_DISPLAY2-RTET
                            RTSTEP =  GS_DISPLAY2-RTSTEP
                            AENAM  =  SY-UNAME
                            AEDAT  =  SY-DATUM
                            AEZET  =  SY-UZEIT
                      WHERE RTID  EQ  GS_DISPLAY2-RTID
                        AND RTIDX EQ  GS_DISPLAY2-RTIDX.

        IF SY-SUBRC NE 0.
          ROLLBACK WORK.
          ADD SY-SUBRC TO LV_SUBRC.
        ENDIF.

      ENDLOOP.

      PERFORM MODIFY_DISPLAY_DATA.

      PERFORM REFRESH_ALV_0100.
      PERFORM REFRESH_ALV_1_0100.

      IF GV_COUNT EQ GV_LINES.
        IF GV_TAB6 EQ ABAP_ON.
          MESSAGE I000 WITH GV_LINES '건이 공정이 완료되었습니다.'.
          EXIT.
        ENDIF.

        CALL METHOD CL_GUI_CFW=>SET_NEW_OK_CODE
          EXPORTING
            NEW_CODE = 'ENTER'.                 " New OK_CODE
*      EXIT.
      ENDIF.

      GO_TIMER->RUN( ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
