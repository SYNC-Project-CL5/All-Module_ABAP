*&---------------------------------------------------------------------*
*& Include          ZEA_TR_TEM_CLS
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Class 정의
*&---------------------------------------------------------------------*
  CLASS LCL_EVENT_HANDLER DEFINITION.
    PUBLIC SECTION .

      METHODS :
        HANDLE_DOUBLE_CLICK FOR EVENT NODE_DOUBLE_CLICK
        OF CL_GUI_ALV_TREE_SIMPLE IMPORTING  SENDER
                                             INDEX_OUTTAB
                                             GROUPLEVEL
                                             .
    PRIVATE SECTION.

  ENDCLASS.
*&---------------------------------------------------------------------*
*& Class 구현
*&---------------------------------------------------------------------*
  CLASS LCL_EVENT_HANDLER IMPLEMENTATION.

    METHOD HANDLE_DOUBLE_CLICK.

      PERFORM CALL_SAKNR USING INDEX_OUTTAB SENDER GROUPLEVEL .

    ENDMETHOD.
  ENDCLASS.
