*&---------------------------------------------------------------------*
*& Include SAPMZEA_MM060                - Module Pool     SAPMZEA_MM060
*&---------------------------------------------------------------------*
PROGRAM ZEA_MM060.

*&--------------------------------------------------------------------*
*&
*& TABLES
*&--------------------------------------------------------------------*
TABLES: ZEA_MDKP.  "[PP] MRP 결과 Header
TABLES: ZEA_MDTB.  "[PP] MRP 결과 Item
TABLES: ZEA_MMT130."[MM] 구매요청 테이블

*&--------------------------------------------------------------------*
*&
*& SCREEN VARIABLE
*&--------------------------------------------------------------------*
DATA : OK_CODE LIKE SY-UCOMM.

*&--------------------------------------------------------------------*
*&
*& ALV VARIABLE
*&--------------------------------------------------------------------*

*-----100-----*
DATA : GO_CONTAINER TYPE REF TO CL_GUI_CUSTOM_CONTAINER.
DATA : GO_SPLITTER  TYPE REF TO CL_GUI_SPLITTER_CONTAINER.
DATA : GO_ALV_CON1 TYPE REF TO CL_GUI_CONTAINER.
DATA : GO_GRID1    TYPE REF TO CL_GUI_ALV_GRID.

DATA : GT_FCAT1 TYPE LVC_T_FCAT.
DATA : GS_LAYO1 TYPE LVC_S_LAYO.
DATA : GT_SORT1 TYPE LVC_T_SORT.

*-----200-----*
DATA : GO_CON2  TYPE REF TO CL_GUI_CUSTOM_CONTAINER.
DATA : GO_GRID2 TYPE REF TO CL_GUI_ALV_GRID.
DATA : GT_FCAT2 TYPE LVC_T_FCAT.
DATA : GS_LAYO2 TYPE LVC_S_LAYO.
DATA : GT_SORT2 TYPE LVC_T_SORT.

*&--------------------------------------------------------------------*
*&
*& INTERNAL TABLE
*&--------------------------------------------------------------------*
DATA: BEGIN OF GT_DISP1 OCCURS 0.
DATA:  ICON   LIKE ICON-ID.
       INCLUDE STRUCTURE ZEA_MMT130.
DATA: END OF GT_DISP1.

DATA: BEGIN OF GT_DISP2 OCCURS 0.
DATA:   ICON  LIKE ICON-ID.
DATA:   WERKS LIKE ZEA_MDKP-WERKS.
        INCLUDE STRUCTURE ZEA_MDTB.
DATA:   SELECTED TYPE C.
DATA : END OF GT_DISP2.

DATA : GR_BANFN   LIKE RANGE OF ZEA_MMT130-BANFN   WITH HEADER LINE."PR
DATA : GR_INFO_NO LIKE RANGE OF ZEA_MMT130-INFO_NO WITH HEADER LINE.
DATA : GR_MRPID   LIKE RANGE OF ZEA_MMT130-MRPID   WITH HEADER LINE.
DATA : GR_WERKS   LIKE RANGE OF ZEA_MMT130-WERKS   WITH HEADER LINE.
DATA : GR_LGORT   LIKE RANGE OF ZEA_MMT130-LGORT   WITH HEADER LINE.
DATA : GR_MATNR   LIKE RANGE OF ZEA_MMT130-MATNR   WITH HEADER LINE.

DATA : GR_PPMRP   LIKE RANGE OF ZEA_MDKP-MRPID     WITH HEADER LINE."MRP
DATA : GR_PPWER   LIKE RANGE OF ZEA_MDKP-WERKS     WITH HEADER LINE.

*&--------------------------------------------------------------------*
*&
*& LOCAL CLASS
*&--------------------------------------------------------------------*
CLASS LCL_EVENT_RECEIVER DEFINITION.
  PUBLIC SECTION.

  METHODS:
        HANDLE_USER_COMMAND
        FOR EVENT USER_COMMAND   OF CL_GUI_ALV_GRID
        IMPORTING E_UCOMM,

        HANDLE_TOOLBAR
        FOR EVENT TOOLBAR        OF CL_GUI_ALV_GRID
        IMPORTING E_OBJECT
                  E_INTERACTIVE,

        HANDLE_USER_COMMAND2
        FOR EVENT USER_COMMAND   OF CL_GUI_ALV_GRID
        IMPORTING E_UCOMM,

        HANDLE_TOOLBAR2
        FOR EVENT TOOLBAR        OF CL_GUI_ALV_GRID
        IMPORTING E_OBJECT
                  E_INTERACTIVE.

ENDCLASS.
CLASS LCL_EVENT_RECEIVER IMPLEMENTATION.
  METHOD HANDLE_TOOLBAR.
    PERFORM HANDLE_TOOLBAR USING E_OBJECT
                                 E_INTERACTIVE.
  ENDMETHOD.
  METHOD HANDLE_USER_COMMAND.
    PERFORM HANDLE_USER_COMMAND USING E_UCOMM.
  ENDMETHOD.

  METHOD HANDLE_TOOLBAR2.
    PERFORM HANDLE_TOOLBAR2 USING E_OBJECT
                                  E_INTERACTIVE.
  ENDMETHOD.
  METHOD HANDLE_USER_COMMAND2.
    PERFORM HANDLE_USER_COMMAND2 USING E_UCOMM.
  ENDMETHOD.
ENDCLASS.
DATA : LCL_EVENT_RECEIVER TYPE REF TO LCL_EVENT_RECEIVER.
