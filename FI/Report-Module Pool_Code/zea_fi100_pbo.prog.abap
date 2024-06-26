*&---------------------------------------------------------------------*
*& Include          ZEA_TR_TEM_PBO
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.
  SET PF-STATUS 'S0100'.
  SET TITLEBAR  'T0100'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module SET_FCAT OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE SET_FCAT OUTPUT.

*-- Filed Catalog 설정

  PERFORM MAKE_FILED_CATALOG.

*-- Tree 값 설정

  PERFORM SET_SORT TABLES GT_SORT.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CREATE_OBJECT OUTPUT
*&---------------------------------------------------------------------*
*&    왼쪽 컨테이너 생성
*&---------------------------------------------------------------------*
MODULE CREATE_OBJECT OUTPUT.

*---- 자산 Container
  IF GCL_CONTAINER IS NOT BOUND.

    PERFORM CREATE_OBJECT_1.
    PERFORM SET_HANDLER_TREE.

  ENDIF.

*&---------------------------------------------------------------------*
*&   오른쪽 컨테이너 생성
*&---------------------------------------------------------------------*

*---- 부채/자본 Container
  IF GCL_CONTAINER_2  IS INITIAL.

*-- CREATE
    PERFORM CREATE_OBJECT_RIGHT.  "Container 생성
    PERFORM CREATE_SPLIT.         "Split     생성
    PERFORM CREATE_TREE.          "Tree     생성

*-- SET FCAT & SORT
    PERFORM SET_FACT_2.
    PERFORM SET_SORT TABLES GT_SORT2.
    PERFORM SET_SORT TABLES GT_SORT3.

*-- DISPLYA
    PERFORM DISPLAY_TREE.         "ALV Tree   Display

    PERFORM SET_HANDLER_TREE2.
    PERFORM SET_HANDLER_TREE3.

  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CLEAR_OK_CODE OUTPUT
*&---------------------------------------------------------------------*
MODULE CLEAR_OK_CODE OUTPUT.
  CLEAR OK_CODE.
ENDMODULE.
