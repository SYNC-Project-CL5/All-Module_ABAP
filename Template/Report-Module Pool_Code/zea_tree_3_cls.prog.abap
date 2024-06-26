*&---------------------------------------------------------------------*
*& Include          ZEA_TR_TEM_CLS
*&---------------------------------------------------------------------*
** 트리 이벤트
  CLASS LCL_TREE_EVENT_RECEIVER DEFINITION.
*    PUBLIC SECTION .
*      DATA TREE_OBJECT TYPE REF TO CL_TREE_CONTROL_BASE.
*
*      METHODS CONSTRUCTOR IMPORTING I_TREE_OBJECT TYPE REF TO CL_TREE_CONTROL_BASE.
*      METHODS: HANDLE_NODE_DOUBLE_CLICK FOR EVENT NODE_DOUBLE_CLICK OF CL_TREE_CONTROL_BASE IMPORTING NODE_KEY,
*               HANDLE_ITEM_DOUBLE_CLICK FOR EVENT ITEM_DOUBLE_CLICK OF CL_ITEM_TREE_CONTROL IMPORTING NODE_KEY
*                                                                                                      ITEM_NAME.
*  ENDCLASS.
*  CLASS LCL_TREE_EVENT_RECEIVER IMPLEMENTATION.
*    METHOD CONSTRUCTOR.
*      CALL METHOD SUPER->CONSTRUCTOR.
*      TREE_OBJECT = I_TREE_OBJECT.
*    ENDMETHOD.
*
*    METHOD HANDLE_NODE_DOUBLE_CLICK.
*      IF GT_NODES[ NODE_KEY = NODE_KEY ]-ISFOLDER EQ 'X'. "현재 노드가 폴더면 펼치기
*        TREE_OBJECT->EXPAND_NODE(
*          EXPORTING
*            NODE_KEY            = NODE_KEY
**            LEVEL_COUNT         =
**            EXPAND_SUBTREE      =
*          EXCEPTIONS
*            FAILED              = 1
*            ILLEGAL_LEVEL_COUNT = 2
*            CNTL_SYSTEM_ERROR   = 3
*            NODE_NOT_FOUND      = 4
*            CANNOT_EXPAND_LEAF  = 5
*            others              = 6
*               ).
*        IF SY-SUBRC <> 0.
**         Implement suitable error handling here
*        ENDIF.
*
*      ELSE.
**        MESSAGE I000(0K) WITH NODE_KEY.
*      ENDIF.
*
*    ENDMETHOD.
*    METHOD HANDLE_ITEM_DOUBLE_CLICK.
**      MESSAGE I000(0K) WITH NODE_KEY ITEM_NAME.
*    ENDMETHOD.
  ENDCLASS.
