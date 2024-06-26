*&---------------------------------------------------------------------*
*& Include          ZEA_TR_TEM2_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form set_fcat_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_FCAT_LAYOUT .

  GS_LAYOUT-ZEBRA      = 'X'.
  GS_LAYOUT-CWIDTH_OPT = 'A'.
  GS_LAYOUT-SEL_MODE   = 'D'.

  PERFORM SET_FCAT USING :
  'X'   'PLANID'    ' '   'ZEA_PPT010'   'PLANID',
  ' '   'PLANQTY1'  ' '   'ZEA_PPT010'   'PLANQTY1',
  ' '   'PLANQTY2'  ' '   'ZEA_PPT010'   'PLANQTY2',
  ' '   'PLANQTY3'  ' '   'ZEA_PPT010'   'PLANQTY3',
  ' '   'PLANQTY4'  ' '   'ZEA_PPT010'   'PLANQTY4',
  ' '   'PLANQTY5'  ' '   'ZEA_PPT010'   'PLANQTY5',
  ' '   'PLANQTY6'  ' '   'ZEA_PPT010'   'PLANQTY6',
  ' '   'PLANQTY7'  ' '   'ZEA_PPT010'   'PLANQTY7',
  ' '   'PLANQTY8'  ' '   'ZEA_PPT010'   'PLANQTY8',
  ' '   'PLANQTY9'  ' '   'ZEA_PPT010'   'PLANQTY9',
  ' '   'PLANQTY10' ' '   'ZEA_PPT010'   'PLANQTY10',
  ' '   'PLANQTY11' ' '   'ZEA_PPT010'   'PLANQTY11',
  ' '   'PLANQTY12' ' '   'ZEA_PPT010'   'PLANQTY12',
  ' '   'MEINS'     ' '   'ZEA_PPT010'   'MEINS',
  ' '   'LOEKZ'     ' '   'ZEA_PPT010'   'LOEKZ'.

*****  PERFORM SET_ALV_FIELDCAT_0100. " ALV 출력 필드 자동구성 하고싶으면 이 함수 해제 해주면 됨

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&---------------------------------------------------------------------*
FORM SET_FCAT USING PV_KEY PV_FIELD PV_TEXT PV_REF_TABLE PV_REF_FIELD.

  GS_FCAT-KEY       = PV_KEY.
  GS_FCAT-FIELDNAME = PV_FIELD.
  GS_FCAT-COLTEXT   = PV_TEXT.
  GS_FCAT-REF_TABLE = PV_REF_TABLE.
  GS_FCAT-REF_FIELD = PV_REF_FIELD.

  CASE PV_FIELD.
    WHEN 'PLANQTY1'.
      GS_FCAT-QFIELDNAME = 'MEINS'.

    WHEN 'PLANQTY2'.
      GS_FCAT-QFIELDNAME = 'MEINS'.

    WHEN 'PLANQTY3'.
      GS_FCAT-QFIELDNAME = 'MEINS'.

    WHEN 'PLANQTY4'.
      GS_FCAT-QFIELDNAME = 'MEINS'.

    WHEN 'PLANQTY5'.
      GS_FCAT-QFIELDNAME = 'MEINS'.

    WHEN 'PLANQTY6'.
      GS_FCAT-QFIELDNAME = 'MEINS'.

    WHEN 'PLANQTY7'.
      GS_FCAT-QFIELDNAME = 'MEINS'.

    WHEN 'PLANQTY8'.
      GS_FCAT-QFIELDNAME = 'MEINS'.

    WHEN 'PLANQTY9'.
      GS_FCAT-QFIELDNAME = 'MEINS'.

    WHEN 'PLANQTY10'.
      GS_FCAT-QFIELDNAME = 'MEINS'.

    WHEN 'PLANQTY11'.
      GS_FCAT-QFIELDNAME = 'MEINS'.

    WHEN 'PLANQTY12'.
      GS_FCAT-QFIELDNAME = 'MEINS'.

    WHEN 'LOEKZ'.
      GS_FCAT-CHECKBOX = 'X'.

  ENDCASE.

  APPEND GS_FCAT TO GT_FCAT.
  CLEAR  GS_FCAT.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form creat_object
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CREAT_OBJECT .

  CREATE OBJECT GCL_CONTAINER
    EXPORTING
      REPID     = SY-REPID
      DYNNR     = SY-DYNNR
      EXTENSION = 5000
      SIDE      = GCL_CONTAINER->DOCK_AT_LEFT.

  CREATE OBJECT GCL_SPLITTER
    EXPORTING
      PARENT  = GCL_CONTAINER
      ROWS    = 1
      COLUMNS = 2.

  CALL METHOD GCL_SPLITTER->SET_COLUMN_WIDTH
    EXPORTING
      ID    = 1
      WIDTH = 20.

  CALL METHOD GCL_SPLITTER->GET_CONTAINER
    EXPORTING
      ROW       = 1
      COLUMN    = 1
    RECEIVING
      CONTAINER = GCL_CONTAINER_LEFT.

  CALL METHOD GCL_SPLITTER->GET_CONTAINER
    EXPORTING
      ROW       = 1
      COLUMN    = 2
    RECEIVING
      CONTAINER = GCL_CONTAINER_RIGHT.

  CREATE OBJECT GCL_TREE
    EXPORTING
      PARENT                      = GCL_CONTAINER_LEFT
      NODE_SELECTION_MODE         = CL_GUI_SIMPLE_TREE=>NODE_SEL_MODE_SINGLE
    EXCEPTIONS
      LIFETIME_ERROR              = 1
      CNTL_SYSTEM_ERROR           = 2
      CREATE_ERROR                = 3
      FAILED                      = 4
      ILLEGAL_NODE_SELECTION_MODE = 5.

  GS_EVENT-EVENTID    = CL_GUI_SIMPLE_TREE=>EVENTID_NODE_DOUBLE_CLICK.
  GS_EVENT-APPL_EVENT = 'X'.

  APPEND GS_EVENT TO GT_EVENT.

  CALL METHOD GCL_TREE->SET_REGISTERED_EVENTS
    EXPORTING
      EVENTS = GT_EVENT.

  IF GCL_HANDLER IS NOT BOUND.
    CREATE OBJECT GCL_HANDLER.
  ENDIF.

  SET HANDLER : GCL_HANDLER->HANDLE_DOUBLE_CLICK FOR GCL_TREE.

  CREATE OBJECT GCL_GRID
    EXPORTING
      I_PARENT = GCL_CONTAINER_RIGHT.

  GS_VARAINT-REPORT = SY-REPID.

  CALL METHOD GCL_GRID->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
      I_SAVE          = 'A'
      I_DEFAULT       = 'X'
      IS_LAYOUT       = GS_LAYOUT
      IS_VARIANT      = GS_VARAINT
    CHANGING
      IT_FIELDCATALOG = GT_FCAT
      IT_OUTTAB       = GT_ZEA_PPT010.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_node
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CREATE_NODE .

  DATA : BEGIN OF LS_LEVEL1,
           BUKRS TYPE ZEA_T001W-BUKRS,
         END OF LS_LEVEL1,

         BEGIN OF LS_LEVEL2,
           BUKRS TYPE ZEA_T001W-BUKRS,
           WERKS TYPE ZEA_T001W-WERKS,
         END OF LS_LEVEL2,

         BEGIN OF LS_LEVEL3,
           BUKRS TYPE ZEA_T001W-BUKRS,
           WERKS TYPE ZEA_T001W-WERKS,
           MATNR TYPE ZEA_PPT010-MATNR,
         END OF LS_LEVEL3,

         LT_LEVEL1 LIKE TABLE OF LS_LEVEL1,
         LT_LEVEL2 LIKE TABLE OF LS_LEVEL2,
         LT_LEVEL3 LIKE TABLE OF LS_LEVEL3.

  CLEAR   : LS_LEVEL1, LS_LEVEL2, LS_LEVEL3.
  REFRESH : LT_LEVEL1, LT_LEVEL2, LT_LEVEL3.

  MOVE-CORRESPONDING GT_ZEA_T001W TO LT_LEVEL1.
  MOVE-CORRESPONDING GT_ZEA_T001W TO LT_LEVEL2.
  MOVE-CORRESPONDING GT_ZEA_T001W TO LT_LEVEL3.

  SORT : LT_LEVEL1 BY BUKRS,
         LT_LEVEL2 BY BUKRS WERKS,
         LT_LEVEL3 BY BUKRS WERKS MATNR.

  DELETE ADJACENT DUPLICATES FROM : LT_LEVEL1 COMPARING BUKRS,
                                    LT_LEVEL2 COMPARING BUKRS WERKS,
                                    LT_LEVEL3 COMPARING BUKRS WERKS MATNR.

  LOOP AT LT_LEVEL1 INTO LS_LEVEL1.

    PERFORM ADD_NODE USING LS_LEVEL1-BUKRS
                           ' '
                           'X'
                           LS_LEVEL1-BUKRS
                           ' '.

    READ TABLE LT_LEVEL2 INTO LS_LEVEL2 WITH KEY BUKRS = LS_LEVEL1-BUKRS.

    IF SY-SUBRC NE 0.
      CONTINUE.
    ENDIF.

    LOOP AT LT_LEVEL2 INTO LS_LEVEL2 FROM SY-TABIX WHERE BUKRS = LS_LEVEL1-BUKRS.

      PERFORM ADD_NODE USING LS_LEVEL2-WERKS
                             LS_LEVEL1-BUKRS
                             'X'
                             LS_LEVEL2-WERKS
                             ' '.

      READ TABLE LT_LEVEL3 INTO LS_LEVEL3 WITH KEY BUKRS = LS_LEVEL2-BUKRS
                                                   WERKS = LS_LEVEL2-WERKS.

      IF SY-SUBRC NE 0.
        CONTINUE.
      ENDIF.

      LOOP AT LT_LEVEL3 INTO LS_LEVEL3 FROM SY-TABIX WHERE BUKRS = LS_LEVEL2-BUKRS
                                                       AND WERKS = LS_LEVEL2-WERKS.

        PERFORM ADD_NODE USING LS_LEVEL3-MATNR
                               LS_LEVEL2-WERKS
                               ' '
                               LS_LEVEL3-MATNR
                               'X'.
      ENDLOOP.

    ENDLOOP.

  ENDLOOP.

  CALL METHOD GCL_TREE->ADD_NODES
    EXPORTING
      TABLE_STRUCTURE_NAME           = 'MTREESNODE'
      NODE_TABLE                     = GT_NODE
    EXCEPTIONS
      FAILED                         = 1
      ERROR_IN_NODE_TABLE            = 2
      DP_ERROR                       = 3
      TABLE_STRUCTURE_NAME_NOT_FOUND = 4
      OTHERS                         = 5.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM GET_DATA .


  CHECK SY-UNAME EQ 'ACA5-03'
   OR SY-UNAME EQ 'ACA5-07'
   OR SY-UNAME EQ 'ACA5-08'
   OR SY-UNAME EQ 'ACA5-10'
   OR SY-UNAME EQ 'ACA5-12'
   OR SY-UNAME EQ 'ACA5-15'
   OR SY-UNAME EQ 'ACA5-17'
   OR SY-UNAME EQ 'ACA5-23'
   OR SY-UNAME EQ 'ACA-05'.

  CLEAR   GS_ZEA_T001W.
  REFRESH GT_ZEA_T001W.

  SELECT A~BUKRS A~WERKS B~MATNR
    INTO CORRESPONDING FIELDS OF TABLE GT_ZEA_T001W
    FROM ZEA_T001W AS A
    INNER JOIN ZEA_PPT010 AS B
    ON B~WERKS EQ A~WERKS.
*    B~MATNR EQ A~MATNR

  IF SY-SUBRC NE 0.
    MESSAGE S000 WITH 'No data found'.
    LEAVE LIST-PROCESSING.
  ENDIF.

  LOOP AT GT_ZEA_T001W INTO GS_ZEA_T001W.

    GS_ZEA_T001W-NODE_KEY = SY-TABIX.

    MODIFY GT_ZEA_T001W FROM GS_ZEA_T001W INDEX SY-TABIX
    TRANSPORTING NODE_KEY.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form add_node
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_LEVEL1_CARRID
*&      --> P_
*&      --> LS_LEVEL1_CARRID
*&---------------------------------------------------------------------*
FORM ADD_NODE USING PV_NODE_KEY
                     PV_REL_KEY
                     PV_FOLDER   TYPE AS4FLAG
                     PV_TEXT
                     PV_LAST.

  DATA : LV_NODE_KEY TYPE TV_NODEKEY,
         LV_REL_KEY  TYPE TV_NODEKEY,
         LV_TEXT     TYPE TEXT30.

  LV_NODE_KEY = PV_NODE_KEY.
  LV_REL_KEY  = PV_REL_KEY.
  LV_TEXT     = PV_TEXT.

  GS_NODE-NODE_KEY = LV_NODE_KEY.
  GS_NODE-ISFOLDER = PV_FOLDER.
  GS_NODE-TEXT     = LV_TEXT.

  IF LV_REL_KEY IS NOT INITIAL.
    GS_NODE-RELATKEY = LV_REL_KEY.
  ENDIF.

  IF PV_LAST IS NOT INITIAL.
    GV_NODE += 1.
    GS_NODE-NODE_KEY  = GV_NODE.
    GS_NODE-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
  ENDIF.

  APPEND GS_NODE TO GT_NODE.
  CLEAR  GS_NODE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_sbook
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> NODE_KEY
*&---------------------------------------------------------------------*
FORM GET_SBOOK USING PV_NODE_KEY.

  READ TABLE GT_NODE INTO GS_NODE WITH KEY NODE_KEY = PV_NODE_KEY.

  IF SY-SUBRC NE 0.
    EXIT.
  ELSE.
    IF GS_NODE-ISFOLDER IS NOT INITIAL.
      EXIT.
    ENDIF.
  ENDIF.

  READ TABLE GT_ZEA_T001W INTO GS_ZEA_T001W INDEX PV_NODE_KEY.

  IF SY-SUBRC NE 0.
    EXIT.
  ENDIF.

  REFRESH GT_ZEA_PPT010.

*  SELECT *
*    INTO CORRESPONDING FIELDS OF TABLE GT_ZEA_PPT010
*    FROM ZEA_PPT010.
**   WHERE WERKS = GS_ZEA_PPT010-WERKS
**     AND MATNR = GS_ZEA_PPT010-MATNR.

  SELECT A~PLANQTY1 A~PLANQTY2 A~PLANQTY3 A~PLANQTY4
         A~PLANQTY5 A~PLANQTY6 A~PLANQTY7 A~PLANQTY8
         A~PLANQTY9 A~PLANQTY10 A~PLANQTY11 A~PLANQTY12
    INTO CORRESPONDING FIELDS OF TABLE GT_ZEA_PPT010
    FROM ZEA_PPT010 AS A
    INNER JOIN ZEA_T001W AS B
    ON B~WERKS EQ A~WERKS
    WHERE B~BUKRS = GS_ZEA_T001W-BUKRS
    AND B~WERKS = GS_ZEA_T001W-WERKS
    AND A~MATNR = GS_ZEA_T001W-MATNR.



  IF SY-SUBRC NE 0.
    EXIT.
  ENDIF.

  PERFORM REFRESH_GRID.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form refresh_grid
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM REFRESH_GRID .

  GS_STABLE-ROW = 'X'.
  GS_STABLE-COL = 'X'.

  CALL METHOD GCL_GRID->REFRESH_TABLE_DISPLAY
    EXPORTING
      IS_STABLE      = GS_STABLE
      I_SOFT_REFRESH = SPACE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form check_number
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PV_NODE_KEY
*&---------------------------------------------------------------------*
FORM CHECK_NUMBER USING PV_NODE_KEY PV_CHECK.

  DATA : LV_NODE TYPE STRING,
         LV_TYPE TYPE DD01V-DATATYPE.

  LV_NODE = PV_NODE_KEY.

  CALL FUNCTION 'FM_SITWB_NUMERIC_CHECK'
    EXPORTING
      STRING_IN = LV_NODE
    IMPORTING
      HTYPE     = LV_TYPE.

  IF LV_TYPE NE 'NUMC'.
    PV_CHECK = 'X'.
  ENDIF.

ENDFORM.

**** 자동으로 필드 구성하고 싶으면 아래 서브 루틴 사용하면 됨 ****
****&---------------------------------------------------------------------*
****& Form SET_ALV_FIELDCAT_0100
****&---------------------------------------------------------------------*
****& text
****&---------------------------------------------------------------------*
****& -->  p1        text
****& <--  p2        text
****&---------------------------------------------------------------------*
***FORM SET_ALV_FIELDCAT_0100 .
***
***  PERFORM GET_FIELDCAT2   USING    GT_ZEA_PPT010
***                          CHANGING GT_FCAT.
***
***ENDFORM.
****&---------------------------------------------------------------------*
****& Form GET_FIELDCAT2
****&---------------------------------------------------------------------*
****& text
****&---------------------------------------------------------------------*
****&      --> GT_ZEA_PPT010
****&      <-- GT_FCAT
****&---------------------------------------------------------------------*
***FORM GET_FIELDCAT2  USING PT_TAB TYPE STANDARD TABLE
***                       CHANGING PT_FCAT TYPE LVC_T_FCAT.
***
***  DATA: LO_DREF TYPE REF TO DATA.
***
***  CREATE DATA LO_DREF LIKE PT_TAB.
***  FIELD-SYMBOLS <LT_TAB> TYPE TABLE.
***  ASSIGN LO_DREF->* TO <LT_TAB>.
***
***  TRY.
***      CALL METHOD CL_SALV_TABLE=>FACTORY
***        IMPORTING
***          R_SALV_TABLE = DATA(LR_TABLE)
***        CHANGING
***          T_TABLE      = <LT_TAB>.
***
***    CATCH CX_SALV_MSG. " ALV: General Error Class with Message
***  ENDTRY.
***
***  PT_FCAT = CL_SALV_CONTROLLER_METADATA=>GET_LVC_FIELDCATALOG(
***              R_COLUMNS      = LR_TABLE->GET_COLUMNS( )
***              R_AGGREGATIONS = LR_TABLE->GET_AGGREGATIONS( )
***            ).
***
***
***
***ENDFORM.
