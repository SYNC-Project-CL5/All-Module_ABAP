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
    WHEN 'PG_DISMRP'.
      CALL TRANSACTION 'ZEAPP080'.
    WHEN 'REFRESH'.
      PERFORM REFRESH_ALV_0100.
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

  CASE OK_CODE.
    WHEN 'SAVE'.
*      SELECT SINGLE *
*        FROM ZEA_MDKP
*        WHERE PDPDAT EQ GV_YEAR
*          AND PDPMON EQ GV_MONTH.

      DATA LV_ANSWER.

*      IF SY-SUBRC EQ 0.
*        _MC_POPUP_CONFIRM '재생성' '해당년월의 자재소요량 계산결과가 존재합니다. 재생성하시겠습니까?' LV_ANSWER.
*      ENDIF.

      SELECT SINGLE *
        FROM ZEA_MDKP
        WHERE PDPDAT EQ SY-DATUM+0(4)
          AND PDPMON EQ GV_MONTH.

      IF SY-SUBRC EQ 0.
        UPDATE ZEA_MDKP SET LOEKZ  = 'X'
                            AENAM  = SY-UNAME
                            AEDAT  = SY-DATUM
                            AEZET  = SY-UZEIT
                      WHERE PDPDAT EQ SY-DATUM+0(4)
                        AND PDPMON EQ GV_MONTH.
      ENDIF.

      DATA: LT_MDKP TYPE TABLE OF ZEA_MDKP,
            LS_MDKP TYPE ZEA_MDKP,
            LT_MDTB TYPE TABLE OF ZEA_MDTB,
            LS_MDTB TYPE ZEA_MDTB.

      SELECT *
        FROM ZEA_MDKP
        INTO TABLE LT_MDKP
        WHERE LOEKZ EQ 'X'.

      IF SY-SUBRC EQ 0.
        LOOP AT LT_MDKP INTO LS_MDKP.
          UPDATE ZEA_MDTB SET LOEKZ  = 'X'
                              AENAM  = SY-UNAME
                              AEDAT  = SY-DATUM
                              AEZET  = SY-UZEIT
                        WHERE MRPID EQ LS_MDKP-MRPID.
        ENDLOOP.
      ENDIF.

      DATA LV_DATE TYPE C LENGTH 6.
      CONCATENATE SY-DATUM+0(4) GV_MONTH INTO LV_DATE.

      IF S0110-DATEFROM+0(6) NE LV_DATE
        OR S0110-DATETO+0(6) NE LV_DATE.
        MESSAGE I080 DISPLAY LIKE 'W' WITH SY-DATUM+0(4) GV_MONTH.
        EXIT.
      ENDIF.

      DATA: LV_SUBRC TYPE I.

      LOOP AT GT_DISPLAY INTO GS_DISPLAY.
        PERFORM CALC_MRP_STEP1.
      ENDLOOP.

      SORT GT_STPO BY MATNR.

*      DATA : BEGIN OF GS_COLLECT,
**               BOMID   TYPE ZEA_STPO-BOMID,
*               MATNR   TYPE ZEA_STPO-MATNR,
*               MAKTX   TYPE ZEA_MMT020-MAKTX,
*               MATTYPE TYPE ZEA_MMT010-MATTYPE,
*               MENGE   TYPE ZEA_STPO-MENGE,
*               MEINS   TYPE ZEA_STPO-MEINS,
*             END OF GS_COLLECT.
*
*      DATA GT_COLLECT LIKE TABLE OF GS_COLLECT.

*      DATA GT_COLLECT LIKE TABLE OF GS_STPO WITH NON-UNIQUE KEY MAKTX.
*      DATA GS_COLLECT LIKE GS_STPO.

      LOOP AT GT_STPO INTO GS_STPO.
        MOVE-CORRESPONDING GS_STPO TO GS_COLLECT.
        COLLECT GS_COLLECT INTO GT_COLLECT.
        CLEAR GS_COLLECT.
      ENDLOOP.

      CLEAR: GS_ZEA_MDKP, GS_ZEA_MDTB.

      CALL FUNCTION 'NUMBER_GET_NEXT'
        EXPORTING
          NR_RANGE_NR             = '01'             " Number range number
          OBJECT                  = 'ZEA_MRPID'      " Name of number range object
        IMPORTING
          NUMBER                  = GS_ZEA_MDKP-MRPID                 " free number
        EXCEPTIONS
          INTERVAL_NOT_FOUND      = 1                " Interval not found
          NUMBER_RANGE_NOT_INTERN = 2                " Number range is not internal
          OBJECT_NOT_FOUND        = 3                " Object not defined in TNRO
          QUANTITY_IS_0           = 4                " Number of numbers requested must be > 0
          QUANTITY_IS_NOT_1       = 5                " Number of numbers requested must be 1
          INTERVAL_OVERFLOW       = 6                " Interval used up. Change not possible.
          BUFFER_OVERFLOW         = 7                " Buffer is full
          OTHERS                  = 8.
      IF SY-SUBRC <> 0.
        MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
          WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.

      REPLACE FIRST OCCURRENCE OF '000' IN GS_ZEA_MDKP-MRPID WITH 'MRP'.
      GS_ZEA_MDKP-WERKS = GS_NODE_INFO-WERKS.
      GS_ZEA_MDKP-PDPDAT = GS_NODE_INFO-PDPDAT.
      GS_ZEA_MDKP-PDPMON = GV_MONTH.
      GS_ZEA_MDKP-ERNAM  = SY-UNAME.
      GS_ZEA_MDKP-ERDAT  = SY-DATUM.
      GS_ZEA_MDKP-ERZET  = SY-UZEIT.

      INSERT ZEA_MDKP FROM GS_ZEA_MDKP.

      IF SY-SUBRC NE 0.
        ADD SY-SUBRC TO LV_SUBRC.
        MESSAGE S016 DISPLAY LIKE 'E'. "데이터 저장 중 오류가 발생했습니다.
        ROLLBACK WORK.
      ENDIF.

      DATA LV_STOCK TYPE ZEA_MMT190-WEIGHT.

      LOOP AT GT_COLLECT INTO GS_COLLECT.
        CLEAR GS_ZEA_MDTB.
        GS_ZEA_MDTB-MRPID  = GS_ZEA_MDKP-MRPID.
        GS_ZEA_MDTB-MATNR  = GS_COLLECT-MATNR.

        SELECT SINGLE WEIGHT
          FROM ZEA_MMT190
          INTO LV_STOCK
          WHERE MATNR EQ GS_COLLECT-MATNR.

        GS_ZEA_MDTB-STOCK  = TRUNC( LV_STOCK ).

        GS_ZEA_MDTB-USEQTY = GS_COLLECT-MENGE.
        GS_ZEA_MDTB-USEQTY = TRUNC( GS_ZEA_MDTB-USEQTY ).

        CALL FUNCTION 'FIMA_NUMERICAL_VALUE_ROUND'
          EXPORTING
            I_RTYPE         = ' '              " Rounding Type
            I_RUNIT         = '10'                " Rounding Unit
            I_VALUE         = GS_ZEA_MDTB-USEQTY                 " No. of free numbers to be calculated
*            I_ROUNDDECIMALS =
          IMPORTING
            E_VALUE_RND     = GS_ZEA_MDTB-USEQTY
          .

        IF  GS_COLLECT-MENGE GT LV_STOCK.
          GS_ZEA_MDTB-REQQTY = GS_COLLECT-MENGE - LV_STOCK.
          GS_ZEA_MDTB-REQQTY = TRUNC( GS_ZEA_MDTB-REQQTY ).
          CALL FUNCTION 'FIMA_NUMERICAL_VALUE_ROUND'
          EXPORTING
            I_RTYPE         = ' '              " Rounding Type
            I_RUNIT         = '10'                " Rounding Unit
            I_VALUE         = GS_ZEA_MDTB-REQQTY                 " No. of free numbers to be calculated
*            I_ROUNDDECIMALS =
          IMPORTING
            E_VALUE_RND     = GS_ZEA_MDTB-REQQTY
          .
        ELSE.
          GS_ZEA_MDTB-REQQTY = 0.
        ENDIF.
        GS_ZEA_MDTB-MEINS  = GS_COLLECT-MEINS.
        GS_ZEA_MDTB-PLANSDATE = S0110-DATEFROM.
        GS_ZEA_MDTB-PLANEDATE = S0110-DATETO.
        GS_ZEA_MDTB-ERNAM  = SY-UNAME.
        GS_ZEA_MDTB-ERDAT  = SY-DATUM.
        GS_ZEA_MDTB-ERZET  = SY-UZEIT.

        INSERT ZEA_MDTB FROM GS_ZEA_MDTB.

        IF SY-SUBRC NE 0.
          ADD SY-SUBRC TO LV_SUBRC.
          MESSAGE S016 DISPLAY LIKE 'E'. "데이터 저장 중 오류가 발생했습니다.
          ROLLBACK WORK.
        ENDIF.
      ENDLOOP.

      IF LV_SUBRC EQ 0.
        MESSAGE S015. "데이터가 성공적으로 저장되었습니다.
        COMMIT WORK AND WAIT.
      ENDIF.

      _MC_POPUP_CONFIRM '조회' '생성된 MRP 결과를 조회 하시겠습니까?' LV_ANSWER.

      CHECK LV_ANSWER = '1'.

      SUBMIT ZEA_PP080 WITH SO_MRPID = GS_ZEA_MDKP-MRPID
                       WITH SO_PDAT  = GS_ZEA_MDKP-PDPDAT
                       WITH SO_PMON  = GS_ZEA_MDKP-PDPMON.

    WHEN 'REFRESH'.
      PERFORM REFRESH_ALV_0100.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT_0120  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE EXIT_0120 INPUT.

  CASE OK_CODE.
    WHEN 'CANCEL'.
      LEAVE TO SCREEN 0.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0120  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0120 INPUT.

ENDMODULE.
