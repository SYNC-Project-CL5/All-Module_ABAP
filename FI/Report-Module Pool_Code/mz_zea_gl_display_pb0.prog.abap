*&---------------------------------------------------------------------*
*& Include          MZ_ZEA_GL_DISPLAY_PB0
*&---------------------------------------------------------------------*
 MODULE CLEAR_OK_CODE OUTPUT.

   CLEAR OK_CODE.

 ENDMODULE.

 MODULE INIT_DATA_0100 OUTPUT.

   GET PARAMETER ID 'ZEA_BELNR' FIELD ZEA_BKPF-BELNR.

   SELECT SINGLE *
     FROM ZEA_BKPF
     INTO CORRESPONDING FIELDS OF ZEA_BKPF
     WHERE BELNR EQ ZEA_BKPF-BELNR.

   SELECT SINGLE D_WAERS
     FROM ZEA_BSEG AS A
     INNER JOIN ZEA_BKPF AS B
     ON A~BELNR EQ B~BELNR
    AND A~BUKRS EQ B~BUKRS
     INTO CORRESPONDING FIELDS OF ZEA_BSEG
     WHERE A~BELNR EQ ZEA_BKPF-BELNR.


*--- Screen 변수 PERIOD 에 값 넣어주기
   DATA lV_MONTH TYPE C LENGTH 2.

   LV_MONTH = ZEA_BKPF-BLDAT+4(2).

   DATA PERIOD TYPE C LENGTH 2.

   PERIOD = LV_MONTH.


*--- Screen 변수 BLART 에 값 넣어주기
   SELECT SINGLE * FROM ZEA_FIT300
     INTO ZEA_FIT300
     WHERE BLART EQ ZEA_BKPF-BLART.


 ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
 MODULE STATUS_0100 OUTPUT.

   SET PF-STATUS 'S0100'.
   SET TITLEBAR 'T0100'.
   MOVE-CORRESPONDING ZEA_BKPF TO ZEA_BKPF.

 ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ALV_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
 MODULE INIT_ALV_0100 OUTPUT.

   IF GO_CONTAINER IS INITIAL.
     PERFORM SELECT_DATA_0100.
     PERFORM CREATE_OBJECT_0100.
     PERFORM SET_ALV_FIELDCAT_0100.
     PERFORM SET_ALV_LAYOUT_0100.
     PERFORM SET_ALV_EVENT_0100.
     PERFORM DISPLAY_ALV_0100.
   ELSE.
     PERFORM REFRESH_ALV_0100.
   ENDIF.

 ENDMODULE.
