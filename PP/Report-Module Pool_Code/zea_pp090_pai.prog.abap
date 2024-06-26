*&---------------------------------------------------------------------*
*& Include          YE00_EX007PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT_0100  INPUT
*&---------------------------------------------------------------------*
MODULE EXIT_0100 INPUT.

  CASE OK_CODE.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'CANC'.
      LEAVE TO SCREEN 0.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.
  CASE OK_CODE.
    WHEN 'REFRESH'.
      PERFORM REFRESH_ALV_0100.
      PERFORM REFRESH_ALV_SPLIT_0100.

    WHEN 'PG_APR'.
      LEAVE TO TRANSACTION 'ZEAPP100'.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
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
      LEAVE TO SCREEN 0.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0110  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0110 INPUT.
*  DATA: LV_YEAR TYPE C LENGTH 4.
*  LV_YEAR = SY-DATUM+0(4).

  CASE OK_CODE.


    WHEN 'SAVE'.

      DATA LV_SUBRC TYPE I.
      DATA LV_COUNT TYPE I.
      DATA LV_ANSWER.

      _MC_POPUP_CONFIRM '저장' '생산오더를 생성하시겠습니까?' LV_ANSWER.
      CHECK LV_ANSWER = '1'.

      DATA: LS_AUFK   TYPE ZEA_AUFK,    " 생산오더 Header
            LS_PPT020 TYPE ZEA_PPT020,  " 생산오더 Item
            lV_AUFNR  TYPE ZEA_AUFK-AUFNR.

      CHECK S0110-1MONTH  EQ ABAP_ON
         OR S0110-2MONTH  EQ ABAP_ON
         OR S0110-3MONTH  EQ ABAP_ON
         OR S0110-4MONTH  EQ ABAP_ON
         OR S0110-5MONTH  EQ ABAP_ON
         OR S0110-6MONTH  EQ ABAP_ON
         OR S0110-7MONTH  EQ ABAP_ON
         OR S0110-8MONTH  EQ ABAP_ON
         OR S0110-9MONTH  EQ ABAP_ON
         OR S0110-10MONTH EQ ABAP_ON
         OR S0110-11MONTH EQ ABAP_ON
         OR S0110-12MONTH EQ ABAP_ON.


      IF S0110-1MONTH EQ ABAP_ON.

        CLEAR LV_COUNT. " 생산오더 ITEM INDEX 를 새로 채번

        CALL FUNCTION 'NUMBER_GET_NEXT'
          EXPORTING
            NR_RANGE_NR = '01'                 " Number range number
            OBJECT      = 'ZEA_AUFNR'                 " Name of number range object
          IMPORTING
            NUMBER      = LV_AUFNR.                 " free number

        REPLACE FIRST OCCURRENCE OF '0000' IN LV_AUFNR WITH 'PROD'.

        LS_AUFK-AUFNR = LV_AUFNR.
        LS_AUFK-WERKS = S0110-WERKS.
        LS_AUFK-MATNR = S0110-MATNR.
        LS_AUFK-PLANID = S0110-PLANID.
        LS_AUFK-TOT_QTY = S0110-EXPQTY1.
        LS_AUFK-MEINS   = S0110-UNIT.
        LS_AUFK-APPROVAL = 'W'.
        LS_AUFK-APPROVER = '조병석'.
        LS_AUFK-ERNAM = SY-UNAME.
        LS_AUFK-ERDAT = SY-DATUM.
        LS_AUFK-ERZET = SY-UZEIT.
        INSERT ZEA_AUFK FROM LS_AUFK.

        IF SY-SUBRC NE 0.
          ROLLBACK WORK.
          ADD SY-SUBRC TO LV_SUBRC.
        ENDIF.

        LS_PPT020-AUFNR = LV_AUFNR.
        SELECT COUNT( * )
          INTO LV_COUNT
          FROM ZEA_PPT020
          WHERE AUFNR EQ LV_AUFNR.

        LS_PPT020-ORDIDX   = ( LV_COUNT + 1 ) * 10.
        LS_PPT020-MATNR    = S0110-MATNR.
        LS_PPT020-BOMID    = S0110-BOMID.
        LS_PPT020-WERKS    = S0110-WERKS.
        LS_PPT020-EXPQTY   = S0110-EXPQTY1.
        LS_PPT020-EXPSDATE = S0110-EXPSDATE1.
        LS_PPT020-EXPEDATE = S0110-EXPEDATE1.
        LS_PPT020-UNIT     = S0110-UNIT.
        LS_PPT020-ERNAM    = SY-UNAME.
        LS_PPT020-ERDAT    = SY-DATUM.
        LS_PPT020-ERZET    = SY-UZEIT.
        INSERT ZEA_PPT020 FROM LS_PPT020.

        IF SY-SUBRC NE 0.
          ROLLBACK WORK.
          ADD SY-SUBRC TO LV_SUBRC.
        ENDIF.

      ENDIF.

      IF S0110-2MONTH EQ ABAP_ON.

        CLEAR LV_COUNT. " 생산오더 ITEM INDEX 를 새로 채번

        CALL FUNCTION 'NUMBER_GET_NEXT'
          EXPORTING
            NR_RANGE_NR = '01'                 " Number range number
            OBJECT      = 'ZEA_AUFNR'                 " Name of number range object
          IMPORTING
            NUMBER      = LV_AUFNR.                 " free number

        REPLACE FIRST OCCURRENCE OF '0000' IN LV_AUFNR WITH 'PROD'.

        LS_AUFK-AUFNR = LV_AUFNR.
        LS_AUFK-WERKS = S0110-WERKS.
        LS_AUFK-MATNR = S0110-MATNR.
        LS_AUFK-PLANID = S0110-PLANID.
        LS_AUFK-TOT_QTY = S0110-EXPQTY2.
        LS_AUFK-MEINS   = S0110-UNIT.
        LS_AUFK-APPROVAL = 'W'.
        LS_AUFK-APPROVER = '조병석'.
        LS_AUFK-ERNAM = SY-UNAME.
        LS_AUFK-ERDAT = SY-DATUM.
        LS_AUFK-ERZET = SY-UZEIT.
        INSERT ZEA_AUFK FROM LS_AUFK.

        IF SY-SUBRC NE 0.
          ROLLBACK WORK.
          ADD SY-SUBRC TO LV_SUBRC.
        ENDIF.

        LS_PPT020-AUFNR = LV_AUFNR.
        SELECT COUNT( * )
          INTO LV_COUNT
          FROM ZEA_PPT020
          WHERE AUFNR EQ LV_AUFNR.

        LS_PPT020-ORDIDX   = ( LV_COUNT + 1 ) * 10.
        LS_PPT020-MATNR    = S0110-MATNR.
        LS_PPT020-WERKS    = S0110-WERKS.
        LS_PPT020-BOMID    = S0110-BOMID.
        LS_PPT020-EXPQTY   = S0110-EXPQTY2.
        LS_PPT020-EXPSDATE = S0110-EXPSDATE2.
        LS_PPT020-EXPEDATE = S0110-EXPEDATE2.
        LS_PPT020-UNIT     = S0110-UNIT.
        LS_PPT020-ERNAM    = SY-UNAME.
        LS_PPT020-ERDAT    = SY-DATUM.
        LS_PPT020-ERZET    = SY-UZEIT.
        INSERT ZEA_PPT020 FROM LS_PPT020.

        IF SY-SUBRC NE 0.
          ROLLBACK WORK.
          ADD SY-SUBRC TO LV_SUBRC.
        ENDIF.

      ENDIF.

      IF S0110-3MONTH EQ ABAP_ON.

        CLEAR LV_COUNT. " 생산오더 ITEM INDEX 를 새로 채번

        CALL FUNCTION 'NUMBER_GET_NEXT'
          EXPORTING
            NR_RANGE_NR = '01'                 " Number range number
            OBJECT      = 'ZEA_AUFNR'                 " Name of number range object
          IMPORTING
            NUMBER      = LV_AUFNR.                 " free number

        REPLACE FIRST OCCURRENCE OF '0000' IN LV_AUFNR WITH 'PROD'.

        LS_AUFK-AUFNR = LV_AUFNR.
        LS_AUFK-WERKS = S0110-WERKS.
        LS_AUFK-MATNR = S0110-MATNR.
        LS_AUFK-PLANID = S0110-PLANID.
        LS_AUFK-TOT_QTY = S0110-EXPQTY3.
        LS_AUFK-MEINS   = S0110-UNIT.
        LS_AUFK-APPROVAL = 'W'.
        LS_AUFK-APPROVER = '조병석'.
        LS_AUFK-ERNAM = SY-UNAME.
        LS_AUFK-ERDAT = SY-DATUM.
        LS_AUFK-ERZET = SY-UZEIT.
        INSERT ZEA_AUFK FROM LS_AUFK.

        IF SY-SUBRC NE 0.
          ROLLBACK WORK.
          ADD SY-SUBRC TO LV_SUBRC.
        ENDIF.

        LS_PPT020-AUFNR = LV_AUFNR.
        SELECT COUNT( * )
          INTO LV_COUNT
          FROM ZEA_PPT020
          WHERE AUFNR EQ LV_AUFNR.

        LS_PPT020-ORDIDX   = ( LV_COUNT + 1 ) * 10.
        LS_PPT020-MATNR    = S0110-MATNR.
        LS_PPT020-WERKS    = S0110-WERKS.
        LS_PPT020-BOMID    = S0110-BOMID.
        LS_PPT020-EXPQTY   = S0110-EXPQTY3.
        LS_PPT020-EXPSDATE = S0110-EXPSDATE3.
        LS_PPT020-EXPEDATE = S0110-EXPEDATE3.
        LS_PPT020-UNIT     = S0110-UNIT.
        LS_PPT020-ERNAM    = SY-UNAME.
        LS_PPT020-ERDAT    = SY-DATUM.
        LS_PPT020-ERZET    = SY-UZEIT.
        INSERT ZEA_PPT020 FROM LS_PPT020.

        IF SY-SUBRC NE 0.
          ROLLBACK WORK.
          ADD SY-SUBRC TO LV_SUBRC.
        ENDIF.

      ENDIF.

      IF S0110-4MONTH EQ ABAP_ON.

        CLEAR LV_COUNT. " 생산오더 ITEM INDEX 를 새로 채번

        CALL FUNCTION 'NUMBER_GET_NEXT'
          EXPORTING
            NR_RANGE_NR = '01'                 " Number range number
            OBJECT      = 'ZEA_AUFNR'                 " Name of number range object
          IMPORTING
            NUMBER      = LV_AUFNR.                 " free number

        REPLACE FIRST OCCURRENCE OF '0000' IN LV_AUFNR WITH 'PROD'.

        LS_AUFK-AUFNR = LV_AUFNR.
        LS_AUFK-WERKS = S0110-WERKS.
        LS_AUFK-MATNR = S0110-MATNR.
        LS_AUFK-PLANID = S0110-PLANID.
        LS_AUFK-TOT_QTY = S0110-EXPQTY4.
        LS_AUFK-MEINS   = S0110-UNIT.
        LS_AUFK-APPROVAL = 'W'.
        LS_AUFK-APPROVER = '조병석'.
        LS_AUFK-ERNAM = SY-UNAME.
        LS_AUFK-ERDAT = SY-DATUM.
        LS_AUFK-ERZET = SY-UZEIT.
        INSERT ZEA_AUFK FROM LS_AUFK.

        IF SY-SUBRC NE 0.
          ROLLBACK WORK.
          ADD SY-SUBRC TO LV_SUBRC.
        ENDIF.

        LS_PPT020-AUFNR = LV_AUFNR.
        SELECT COUNT( * )
          INTO LV_COUNT
          FROM ZEA_PPT020
          WHERE AUFNR EQ LV_AUFNR.

        LS_PPT020-ORDIDX   = ( LV_COUNT + 1 ) * 10.
        LS_PPT020-MATNR    = S0110-MATNR.
        LS_PPT020-WERKS    = S0110-WERKS.
        LS_PPT020-BOMID    = S0110-BOMID.
        LS_PPT020-EXPQTY   = S0110-EXPQTY4.
        LS_PPT020-EXPSDATE = S0110-EXPSDATE4.
        LS_PPT020-EXPEDATE = S0110-EXPEDATE4.
        LS_PPT020-UNIT     = S0110-UNIT.
        LS_PPT020-ERNAM    = SY-UNAME.
        LS_PPT020-ERDAT    = SY-DATUM.
        LS_PPT020-ERZET    = SY-UZEIT.
        INSERT ZEA_PPT020 FROM LS_PPT020.

        IF SY-SUBRC NE 0.
          ROLLBACK WORK.
          ADD SY-SUBRC TO LV_SUBRC.
        ENDIF.

      ENDIF.

      IF S0110-5MONTH EQ ABAP_ON.

        CLEAR LV_COUNT. " 생산오더 ITEM INDEX 를 새로 채번

        CALL FUNCTION 'NUMBER_GET_NEXT'
          EXPORTING
            NR_RANGE_NR = '01'                 " Number range number
            OBJECT      = 'ZEA_AUFNR'                 " Name of number range object
          IMPORTING
            NUMBER      = LV_AUFNR.                 " free number

        REPLACE FIRST OCCURRENCE OF '0000' IN LV_AUFNR WITH 'PROD'.

        LS_AUFK-AUFNR = LV_AUFNR.
        LS_AUFK-WERKS = S0110-WERKS.
        LS_AUFK-MATNR = S0110-MATNR.
        LS_AUFK-PLANID = S0110-PLANID.
        LS_AUFK-TOT_QTY = S0110-EXPQTY5.
        LS_AUFK-MEINS   = S0110-UNIT.
        LS_AUFK-APPROVAL = 'W'.
        LS_AUFK-APPROVER = '조병석'.
        LS_AUFK-ERNAM = SY-UNAME.
        LS_AUFK-ERDAT = SY-DATUM.
        LS_AUFK-ERZET = SY-UZEIT.
        INSERT ZEA_AUFK FROM LS_AUFK.

        IF SY-SUBRC NE 0.
          ROLLBACK WORK.
          ADD SY-SUBRC TO LV_SUBRC.
        ENDIF.

        LS_PPT020-AUFNR = LV_AUFNR.
        SELECT COUNT( * )
          INTO LV_COUNT
          FROM ZEA_PPT020
          WHERE AUFNR EQ LV_AUFNR.

        LS_PPT020-ORDIDX   = ( LV_COUNT + 1 ) * 10.
        LS_PPT020-MATNR    = S0110-MATNR.
        LS_PPT020-WERKS    = S0110-WERKS.
        LS_PPT020-BOMID    = S0110-BOMID.
        LS_PPT020-EXPQTY   = S0110-EXPQTY5.
        LS_PPT020-EXPSDATE = S0110-EXPSDATE5.
        LS_PPT020-EXPEDATE = S0110-EXPEDATE5.
        LS_PPT020-UNIT     = S0110-UNIT.
        LS_PPT020-ERNAM    = SY-UNAME.
        LS_PPT020-ERDAT    = SY-DATUM.
        LS_PPT020-ERZET    = SY-UZEIT.
        INSERT ZEA_PPT020 FROM LS_PPT020.

        IF SY-SUBRC NE 0.
          ROLLBACK WORK.
          ADD SY-SUBRC TO LV_SUBRC.
        ENDIF.

      ENDIF.

      IF S0110-6MONTH EQ ABAP_ON.

        CLEAR LV_COUNT. " 생산오더 ITEM INDEX 를 새로 채번

        CALL FUNCTION 'NUMBER_GET_NEXT'
          EXPORTING
            NR_RANGE_NR = '01'                 " Number range number
            OBJECT      = 'ZEA_AUFNR'                 " Name of number range object
          IMPORTING
            NUMBER      = LV_AUFNR.                 " free number

        REPLACE FIRST OCCURRENCE OF '0000' IN LV_AUFNR WITH 'PROD'.

        LS_AUFK-AUFNR = LV_AUFNR.
        LS_AUFK-WERKS = S0110-WERKS.
        LS_AUFK-MATNR = S0110-MATNR.
        LS_AUFK-PLANID = S0110-PLANID.
        LS_AUFK-TOT_QTY = S0110-EXPQTY6.
        LS_AUFK-MEINS   = S0110-UNIT.
        LS_AUFK-APPROVAL = 'W'.
        LS_AUFK-APPROVER = '조병석'.
        LS_AUFK-ERNAM = SY-UNAME.
        LS_AUFK-ERDAT = SY-DATUM.
        LS_AUFK-ERZET = SY-UZEIT.
        INSERT ZEA_AUFK FROM LS_AUFK.

        IF SY-SUBRC NE 0.
          ROLLBACK WORK.
          ADD SY-SUBRC TO LV_SUBRC.
        ENDIF.

        LS_PPT020-AUFNR = LV_AUFNR.
        SELECT COUNT( * )
          INTO LV_COUNT
          FROM ZEA_PPT020
          WHERE AUFNR EQ LV_AUFNR.

        LS_PPT020-ORDIDX   = ( LV_COUNT + 1 ) * 10.
        LS_PPT020-MATNR    = S0110-MATNR.
        LS_PPT020-WERKS    = S0110-WERKS.
        LS_PPT020-BOMID    = S0110-BOMID.
        LS_PPT020-EXPQTY   = S0110-EXPQTY6.
        LS_PPT020-EXPSDATE = S0110-EXPSDATE6.
        LS_PPT020-EXPEDATE = S0110-EXPEDATE6.
        LS_PPT020-UNIT     = S0110-UNIT.
        LS_PPT020-ERNAM    = SY-UNAME.
        LS_PPT020-ERDAT    = SY-DATUM.
        LS_PPT020-ERZET    = SY-UZEIT.
        INSERT ZEA_PPT020 FROM LS_PPT020.

        IF SY-SUBRC NE 0.
          ROLLBACK WORK.
          ADD SY-SUBRC TO LV_SUBRC.
        ENDIF.

      ENDIF.

      IF S0110-7MONTH EQ ABAP_ON.

        CLEAR LV_COUNT. " 생산오더 ITEM INDEX 를 새로 채번

        CALL FUNCTION 'NUMBER_GET_NEXT'
          EXPORTING
            NR_RANGE_NR = '01'                 " Number range number
            OBJECT      = 'ZEA_AUFNR'                 " Name of number range object
          IMPORTING
            NUMBER      = LV_AUFNR.                 " free number

        REPLACE FIRST OCCURRENCE OF '0000' IN LV_AUFNR WITH 'PROD'.

        LS_AUFK-AUFNR = LV_AUFNR.
        LS_AUFK-WERKS = S0110-WERKS.
        LS_AUFK-MATNR = S0110-MATNR.
        LS_AUFK-PLANID = S0110-PLANID.
        LS_AUFK-TOT_QTY = S0110-EXPQTY7.
        LS_AUFK-MEINS   = S0110-UNIT.
        LS_AUFK-APPROVAL = 'W'.
        LS_AUFK-APPROVER = '조병석'.
        LS_AUFK-ERNAM = SY-UNAME.
        LS_AUFK-ERDAT = SY-DATUM.
        LS_AUFK-ERZET = SY-UZEIT.
        INSERT ZEA_AUFK FROM LS_AUFK.

        IF SY-SUBRC NE 0.
          ROLLBACK WORK.
          ADD SY-SUBRC TO LV_SUBRC.
        ENDIF.

        LS_PPT020-AUFNR = LV_AUFNR.
        SELECT COUNT( * )
          INTO LV_COUNT
          FROM ZEA_PPT020
          WHERE AUFNR EQ LV_AUFNR.

        LS_PPT020-ORDIDX   = ( LV_COUNT + 1 ) * 10.
        LS_PPT020-MATNR    = S0110-MATNR.
        LS_PPT020-WERKS    = S0110-WERKS.
        LS_PPT020-BOMID    = S0110-BOMID.
        LS_PPT020-EXPQTY   = S0110-EXPQTY7.
        LS_PPT020-EXPSDATE = S0110-EXPSDATE7.
        LS_PPT020-EXPEDATE = S0110-EXPEDATE7.
        LS_PPT020-UNIT     = S0110-UNIT.
        LS_PPT020-ERNAM    = SY-UNAME.
        LS_PPT020-ERDAT    = SY-DATUM.
        LS_PPT020-ERZET    = SY-UZEIT.
        INSERT ZEA_PPT020 FROM LS_PPT020.

        IF SY-SUBRC NE 0.
          ROLLBACK WORK.
          ADD SY-SUBRC TO LV_SUBRC.
        ENDIF.

      ENDIF.

      IF S0110-8MONTH EQ ABAP_ON.

        CLEAR LV_COUNT. " 생산오더 ITEM INDEX 를 새로 채번

        CALL FUNCTION 'NUMBER_GET_NEXT'
          EXPORTING
            NR_RANGE_NR = '01'                 " Number range number
            OBJECT      = 'ZEA_AUFNR'                 " Name of number range object
          IMPORTING
            NUMBER      = LV_AUFNR.                 " free number

        REPLACE FIRST OCCURRENCE OF '0000' IN LV_AUFNR WITH 'PROD'.

        LS_AUFK-AUFNR = LV_AUFNR.
        LS_AUFK-WERKS = S0110-WERKS.
        LS_AUFK-MATNR = S0110-MATNR.
        LS_AUFK-PLANID = S0110-PLANID.
        LS_AUFK-TOT_QTY = S0110-EXPQTY8.
        LS_AUFK-MEINS   = S0110-UNIT.
        LS_AUFK-APPROVAL = 'W'.
        LS_AUFK-APPROVER = '조병석'.
        LS_AUFK-ERNAM = SY-UNAME.
        LS_AUFK-ERDAT = SY-DATUM.
        LS_AUFK-ERZET = SY-UZEIT.
        INSERT ZEA_AUFK FROM LS_AUFK.

        IF SY-SUBRC NE 0.
          ROLLBACK WORK.
          ADD SY-SUBRC TO LV_SUBRC.
        ENDIF.

        LS_PPT020-AUFNR = LV_AUFNR.
        SELECT COUNT( * )
          INTO LV_COUNT
          FROM ZEA_PPT020
          WHERE AUFNR EQ LV_AUFNR.

        LS_PPT020-ORDIDX   = ( LV_COUNT + 1 ) * 10.
        LS_PPT020-MATNR    = S0110-MATNR.
        LS_PPT020-WERKS    = S0110-WERKS.
        LS_PPT020-BOMID    = S0110-BOMID.
        LS_PPT020-EXPQTY   = S0110-EXPQTY8.
        LS_PPT020-EXPSDATE = S0110-EXPSDATE8.
        LS_PPT020-EXPEDATE = S0110-EXPEDATE8.
        LS_PPT020-UNIT     = S0110-UNIT.
        LS_PPT020-ERNAM    = SY-UNAME.
        LS_PPT020-ERDAT    = SY-DATUM.
        LS_PPT020-ERZET    = SY-UZEIT.
        INSERT ZEA_PPT020 FROM LS_PPT020.

        IF SY-SUBRC NE 0.
          ROLLBACK WORK.
          ADD SY-SUBRC TO LV_SUBRC.
        ENDIF.

      ENDIF.

      IF S0110-9MONTH EQ ABAP_ON.

        CLEAR LV_COUNT. " 생산오더 ITEM INDEX 를 새로 채번

        CALL FUNCTION 'NUMBER_GET_NEXT'
          EXPORTING
            NR_RANGE_NR = '01'                 " Number range number
            OBJECT      = 'ZEA_AUFNR'                 " Name of number range object
          IMPORTING
            NUMBER      = LV_AUFNR.                 " free number

        REPLACE FIRST OCCURRENCE OF '0000' IN LV_AUFNR WITH 'PROD'.

        LS_AUFK-AUFNR = LV_AUFNR.
        LS_AUFK-WERKS = S0110-WERKS.
        LS_AUFK-MATNR = S0110-MATNR.
        LS_AUFK-PLANID = S0110-PLANID.
        LS_AUFK-TOT_QTY = S0110-EXPQTY9.
        LS_AUFK-MEINS   = S0110-UNIT.
        LS_AUFK-APPROVAL = 'W'.
        LS_AUFK-APPROVER = '조병석'.
        LS_AUFK-ERNAM = SY-UNAME.
        LS_AUFK-ERDAT = SY-DATUM.
        LS_AUFK-ERZET = SY-UZEIT.
        INSERT ZEA_AUFK FROM LS_AUFK.

        IF SY-SUBRC NE 0.
          ROLLBACK WORK.
          ADD SY-SUBRC TO LV_SUBRC.
        ENDIF.

        LS_PPT020-AUFNR = LV_AUFNR.
        SELECT COUNT( * )
          INTO LV_COUNT
          FROM ZEA_PPT020
          WHERE AUFNR EQ LV_AUFNR.

        LS_PPT020-ORDIDX   = ( LV_COUNT + 1 ) * 10.
        LS_PPT020-MATNR    = S0110-MATNR.
        LS_PPT020-WERKS    = S0110-WERKS.
        LS_PPT020-BOMID    = S0110-BOMID.
        LS_PPT020-EXPQTY   = S0110-EXPQTY9.
        LS_PPT020-EXPSDATE = S0110-EXPSDATE9.
        LS_PPT020-EXPEDATE = S0110-EXPEDATE9.
        LS_PPT020-UNIT     = S0110-UNIT.
        LS_PPT020-ERNAM    = SY-UNAME.
        LS_PPT020-ERDAT    = SY-DATUM.
        LS_PPT020-ERZET    = SY-UZEIT.
        INSERT ZEA_PPT020 FROM LS_PPT020.

        IF SY-SUBRC NE 0.
          ROLLBACK WORK.
          ADD SY-SUBRC TO LV_SUBRC.
        ENDIF.

      ENDIF.

      IF S0110-10MONTH EQ ABAP_ON.

        CLEAR LV_COUNT. " 생산오더 ITEM INDEX 를 새로 채번

        CALL FUNCTION 'NUMBER_GET_NEXT'
          EXPORTING
            NR_RANGE_NR = '01'                 " Number range number
            OBJECT      = 'ZEA_AUFNR'                 " Name of number range object
          IMPORTING
            NUMBER      = LV_AUFNR.                 " free number

        REPLACE FIRST OCCURRENCE OF '0000' IN LV_AUFNR WITH 'PROD'.

        LS_AUFK-AUFNR = LV_AUFNR.
        LS_AUFK-WERKS = S0110-WERKS.
        LS_AUFK-MATNR = S0110-MATNR.
        LS_AUFK-PLANID = S0110-PLANID.
        LS_AUFK-TOT_QTY = S0110-EXPQTY1.
        LS_AUFK-MEINS   = S0110-UNIT.
        LS_AUFK-APPROVAL = 'W'.
        LS_AUFK-APPROVER = '조병석'.
        LS_AUFK-ERNAM = SY-UNAME.
        LS_AUFK-ERDAT = SY-DATUM.
        LS_AUFK-ERZET = SY-UZEIT.
        INSERT ZEA_AUFK FROM LS_AUFK.

        IF SY-SUBRC NE 0.
          ROLLBACK WORK.
          ADD SY-SUBRC TO LV_SUBRC.
        ENDIF.

        LS_PPT020-AUFNR = LV_AUFNR.
        SELECT COUNT( * )
          INTO LV_COUNT
          FROM ZEA_PPT020
          WHERE AUFNR EQ LV_AUFNR.

        LS_PPT020-ORDIDX   = ( LV_COUNT + 1 ) * 10.
        LS_PPT020-MATNR    = S0110-MATNR.
        LS_PPT020-WERKS    = S0110-WERKS.
        LS_PPT020-BOMID    = S0110-BOMID.
        LS_PPT020-EXPQTY   = S0110-EXPQTY10.
        LS_PPT020-EXPSDATE = S0110-EXPSDATE10.
        LS_PPT020-EXPEDATE = S0110-EXPEDATE10.
        LS_PPT020-UNIT     = S0110-UNIT.
        LS_PPT020-ERNAM    = SY-UNAME.
        LS_PPT020-ERDAT    = SY-DATUM.
        LS_PPT020-ERZET    = SY-UZEIT.
        INSERT ZEA_PPT020 FROM LS_PPT020.

        IF SY-SUBRC NE 0.
          ROLLBACK WORK.
          ADD SY-SUBRC TO LV_SUBRC.
        ENDIF.

      ENDIF.

      IF S0110-11MONTH EQ ABAP_ON.

        CLEAR LV_COUNT. " 생산오더 ITEM INDEX 를 새로 채번

        CALL FUNCTION 'NUMBER_GET_NEXT'
          EXPORTING
            NR_RANGE_NR = '01'                 " Number range number
            OBJECT      = 'ZEA_AUFNR'                 " Name of number range object
          IMPORTING
            NUMBER      = LV_AUFNR.                 " free number

        REPLACE FIRST OCCURRENCE OF '0000' IN LV_AUFNR WITH 'PROD'.

        LS_AUFK-AUFNR = LV_AUFNR.
        LS_AUFK-WERKS = S0110-WERKS.
        LS_AUFK-MATNR = S0110-MATNR.
        LS_AUFK-PLANID = S0110-PLANID.
        LS_AUFK-TOT_QTY = S0110-EXPQTY11.
        LS_AUFK-MEINS   = S0110-UNIT.
        LS_AUFK-APPROVAL = 'W'.
        LS_AUFK-APPROVER = '조병석'.
        LS_AUFK-ERNAM = SY-UNAME.
        LS_AUFK-ERDAT = SY-DATUM.
        LS_AUFK-ERZET = SY-UZEIT.
        INSERT ZEA_AUFK FROM LS_AUFK.

        IF SY-SUBRC NE 0.
          ROLLBACK WORK.
          ADD SY-SUBRC TO LV_SUBRC.
        ENDIF.

        LS_PPT020-AUFNR = LV_AUFNR.
        SELECT COUNT( * )
          INTO LV_COUNT
          FROM ZEA_PPT020
          WHERE AUFNR EQ LV_AUFNR.

        LS_PPT020-ORDIDX   = ( LV_COUNT + 1 ) * 10.
        LS_PPT020-MATNR    = S0110-MATNR.
        LS_PPT020-WERKS    = S0110-WERKS.
        LS_PPT020-BOMID    = S0110-BOMID.
        LS_PPT020-EXPQTY   = S0110-EXPQTY11.
        LS_PPT020-EXPSDATE = S0110-EXPSDATE11.
        LS_PPT020-EXPEDATE = S0110-EXPEDATE11.
        LS_PPT020-UNIT     = S0110-UNIT.
        LS_PPT020-ERNAM    = SY-UNAME.
        LS_PPT020-ERDAT    = SY-DATUM.
        LS_PPT020-ERZET    = SY-UZEIT.
        INSERT ZEA_PPT020 FROM LS_PPT020.

        IF SY-SUBRC NE 0.
          ROLLBACK WORK.
          ADD SY-SUBRC TO LV_SUBRC.
        ENDIF.

      ENDIF.

      IF S0110-12MONTH EQ ABAP_ON.

        CLEAR LV_COUNT. " 생산오더 ITEM INDEX 를 새로 채번

        CALL FUNCTION 'NUMBER_GET_NEXT'
          EXPORTING
            NR_RANGE_NR = '01'                 " Number range number
            OBJECT      = 'ZEA_AUFNR'                 " Name of number range object
          IMPORTING
            NUMBER      = LV_AUFNR.                 " free number

        REPLACE FIRST OCCURRENCE OF '0000' IN LV_AUFNR WITH 'PROD'.

        LS_AUFK-AUFNR = LV_AUFNR.
        LS_AUFK-WERKS = S0110-WERKS.
        LS_AUFK-MATNR = S0110-MATNR.
        LS_AUFK-PLANID = S0110-PLANID.
        LS_AUFK-TOT_QTY = S0110-EXPQTY12.
        LS_AUFK-MEINS   = S0110-UNIT.
        LS_AUFK-APPROVAL = 'W'.
        LS_AUFK-APPROVER = '조병석'.
        LS_AUFK-ERNAM = SY-UNAME.
        LS_AUFK-ERDAT = SY-DATUM.
        LS_AUFK-ERZET = SY-UZEIT.
        INSERT ZEA_AUFK FROM LS_AUFK.

        IF SY-SUBRC NE 0.
          ROLLBACK WORK.
          ADD SY-SUBRC TO LV_SUBRC.
        ENDIF.

        LS_PPT020-AUFNR = LV_AUFNR.
        SELECT COUNT( * )
          INTO LV_COUNT
          FROM ZEA_PPT020
          WHERE AUFNR EQ LV_AUFNR.

        LS_PPT020-ORDIDX   = ( LV_COUNT + 1 ) * 10.
        LS_PPT020-MATNR    = S0110-MATNR.
        LS_PPT020-WERKS    = S0110-WERKS.
        LS_PPT020-BOMID    = S0110-BOMID.
        LS_PPT020-EXPQTY   = S0110-EXPQTY12.
        LS_PPT020-EXPSDATE = S0110-EXPSDATE12.
        LS_PPT020-EXPEDATE = S0110-EXPEDATE12.
        LS_PPT020-UNIT     = S0110-UNIT.
        LS_PPT020-ERNAM    = SY-UNAME.
        LS_PPT020-ERDAT    = SY-DATUM.
        LS_PPT020-ERZET    = SY-UZEIT.
        INSERT ZEA_PPT020 FROM LS_PPT020.

        IF SY-SUBRC NE 0.
          ROLLBACK WORK.
          ADD SY-SUBRC TO LV_SUBRC.
        ENDIF.

      ENDIF.

      IF LV_SUBRC EQ 0.
        MESSAGE S000 WITH '성공적으로 저장되었습니다.'.
        COMMIT WORK AND WAIT.
      ENDIF.

      SELECT *
        FROM ZEA_AUFK AS A
        JOIN ZEA_MMT020 AS B ON B~MATNR EQ A~MATNR
                            AND B~SPRAS EQ SY-LANGU
        JOIN ZEA_T001W  AS C ON C~WERKS EQ A~WERKS
        INTO CORRESPONDING FIELDS OF TABLE GT_AUFK
        WHERE A~PLANID EQ S0110-PLANID
          AND A~MATNR  EQ S0110-MATNR.

      SELECT *
        FROM ZEA_PPT020 AS A
        JOIN ZEA_AUFK   AS B ON B~AUFNR EQ A~AUFNR
        JOIN ZEA_MMT020 AS C ON C~MATNR EQ A~MATNR
                            AND C~SPRAS EQ SY-LANGU
        JOIN ZEA_T001W  AS D ON D~WERKS EQ A~WERKS
        INTO CORRESPONDING FIELDS OF TABLE GT_PPT020
        WHERE B~PLANID EQ S0110-PLANID
          AND A~MATNR  EQ S0110-MATNR.

      LOOP AT GT_DISPLAY INTO GS_DISPLAY.

        SELECT COUNT( * )
          FROM ZEA_AUFK
          WHERE PLANID EQ GS_DISPLAY-PLANID
            AND MATNR  EQ GS_DISPLAY-MATNR.

        IF SY-SUBRC EQ 0.
          GS_DISPLAY-LIGHT = 3.
        ELSE.
          GS_DISPLAY-LIGHT = 2.
        ENDIF.

        MODIFY GT_DISPLAY FROM GS_DISPLAY.
      ENDLOOP.

      PERFORM REFRESH_ALV_0100.
      PERFORM REFRESH_ALV_SPLIT_0100.

      LEAVE TO SCREEN 0.

  ENDCASE.

ENDMODULE.
