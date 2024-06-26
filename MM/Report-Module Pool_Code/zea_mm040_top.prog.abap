*&---------------------------------------------------------------------*
*& Include          ZEA_MM040_TOP
*&---------------------------------------------------------------------*
*&--------------------------------------------------------------------*
*&
*& TABLES
*&--------------------------------------------------------------------*
TABLES : ZEA_MMT030.

*&--------------------------------------------------------------------*
*&
*& INTERNAL TABLE
*&--------------------------------------------------------------------*
DATA : BEGIN OF GT_MMT030 OCCURS 0.
DATA : ICON LIKE ICON-ID.
       INCLUDE STRUCTURE ZEA_MMT030.
DATA : MAKTX  LIKE ZEA_MMT020-MAKTX.
DATA : PNAME1 LIKE ZEA_T001W-PNAME1.
DATA : END OF GT_MMT030.

" 자재명
DATA : GT_MMT020 LIKE TABLE OF ZEA_MMT020.
DATA : GS_MMT020 LIKE LINE  OF GT_MMT020.

" 플랜트명
DATA : GT_T001W  LIKE TABLE OF ZEA_T001W.
DATA : GS_T001W  LIKE LINE  OF GT_T001W.

*&--------------------------------------------------------------------*
*&
*& SCREEN VARIABLE
*&--------------------------------------------------------------------*
DATA: OK_CODE TYPE SY-UCOMM.

DATA: BEGIN OF GT_EXCLUDE OCCURS 0,"
        STATUS_NAME(30),
      END OF GT_EXCLUDE.

*&--------------------------------------------------------------------*
*&
*& ALV VARIABLE
*&--------------------------------------------------------------------*
*-----Custom Container-----*
DATA: GO_CONTAINER TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      GO_ALV_GRID  TYPE REF TO CL_GUI_ALV_GRID.

*-----Other Objects-----*
DATA: GS_LAYOUT    TYPE LVC_S_LAYO,
      GT_FIELDCAT  TYPE LVC_T_FCAT,
      GS_VARIANT   TYPE DISVARIANT,
      GV_SAVE      TYPE C.

*&--------------------------------------------------------------------*
*&
*& FLAG
*&--------------------------------------------------------------------*
DATA: GV_MODE(1)."D: 조회, C:수정
