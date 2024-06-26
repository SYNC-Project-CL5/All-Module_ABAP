*&---------------------------------------------------------------------*
*& Include          ZEA_TR_TEM_SCR
*&---------------------------------------------------------------------*


                                                    "TEXT-T01 : 회계연도
SELECTION-SCREEN BEGIN OF BLOCK BL1 WITH FRAME TITLE TEXT-T01.
  SELECT-OPTIONS : SO_BUKRS FOR ZEA_BKPF-BUKRS,      "회사코드
                   SO_GJAHR FOR  ZEA_BKPF-GJAHR.     "회계연도
SELECTION-SCREEN END OF BLOCK BL1.
