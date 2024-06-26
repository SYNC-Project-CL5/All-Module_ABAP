*&---------------------------------------------------------------------*
*& Report ZEXCEL_DATA_C00
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTESTEC435.

TABLES: SSCRFIELDS.

DATA: OK_CODE TYPE SY-UCOMM.

DATA: GS_LAYOUT TYPE LVC_S_LAYO.

DATA: GO_DOCK TYPE REF TO CL_GUI_DOCKING_CONTAINER,
      GO_ALV  TYPE REF TO CL_GUI_ALV_GRID.

FIELD-SYMBOLS: <FS_ITAB> TYPE STANDARD TABLE.

SELECTION-SCREEN BEGIN OF BLOCK BLK1 WITH FRAME.
  PARAMETERS: PA_TABNM TYPE DD02L-TABNAME,
              PA_FPATH TYPE STRING.
SELECTION-SCREEN END OF BLOCK BLK1.

SELECTION-SCREEN FUNCTION KEY 1.

INITIALIZATION.
  PERFORM SET_BUTTON_TEXT.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR PA_FPATH.
  PERFORM FILE_OPEN_DIALOG.

AT SELECTION-SCREEN ON PA_TABNM.
  PERFORM CHECK_TABLE.

AT SELECTION-SCREEN.
  PERFORM USER_COMMAND.

START-OF-SELECTION.
  PERFORM READ_FROM_FILE.

  IF <FS_ITAB> IS NOT INITIAL.
    CALL SCREEN 100.
  ELSE.
    MESSAGE 'The data does not exist.!' TYPE 'W'.
  ENDIF.

*&---------------------------------------------------------------------*
*& Form check_table
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CHECK_TABLE .
  SELECT COUNT( * )
    FROM DD02L
    WHERE TABNAME = PA_TABNM
      AND TABCLASS = 'TRANSP'.

  IF SY-SUBRC <> 0.
    MESSAGE 'You entered an invalid table name.' TYPE 'E'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form FILE_OPEN_DIALOG
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FILE_OPEN_DIALOG .

  DATA: LT_TABLE TYPE FILETABLE,
        LS_TABLE LIKE LINE OF LT_TABLE.

  DATA: LV_RC TYPE I.

  CALL METHOD CL_GUI_FRONTEND_SERVICES=>FILE_OPEN_DIALOG
    EXPORTING
      WINDOW_TITLE            = 'Selection file'                           " Title Of File Open Dialog
      DEFAULT_EXTENSION       = CL_GUI_FRONTEND_SERVICES=>FILETYPE_EXCEL   " Default Extension
*     DEFAULT_FILENAME        =                  " Default File Name
      FILE_FILTER             = CL_GUI_FRONTEND_SERVICES=>FILETYPE_EXCEL   " File Extension Filter String
    CHANGING
      FILE_TABLE              = LT_TABLE                                   " Table Holding Selected Files
      RC                      = LV_RC                                       " Return Code, Number of Files or -1 If Error Occurred
    EXCEPTIONS
      FILE_OPEN_DIALOG_FAILED = 1                " "Open File" dialog failed
      CNTL_ERROR              = 2                " Control error
      ERROR_NO_GUI            = 3                " No GUI available
      NOT_SUPPORTED_BY_GUI    = 4                " GUI does not support this
      OTHERS                  = 5.
  IF SY-SUBRC <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  READ TABLE LT_TABLE INTO LS_TABLE INDEX 1.
  PA_FPATH = LS_TABLE-FILENAME.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_BUTTON_TEXT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_BUTTON_TEXT .

  SSCRFIELDS-FUNCTXT_01 = ICON_XLS && 'Excel 양식 다운로드'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form USER_COMMAND
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM USER_COMMAND .

  CASE SSCRFIELDS-UCOMM.
    WHEN 'FC01'.
      PERFORM FILE_DOWN.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form file_down
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FILE_DOWN .

  DATA: LV_COL TYPE I,
        LV_LEN TYPE I.

  DATA: BEGIN OF LS_FIELD,
          FIELDNAME TYPE DD03L-FIELDNAME,
          POSITION  TYPE DD03L-POSITION,
          INTLEN    TYPE DD03L-INTLEN,
        END OF LS_FIELD.

  DATA: LT_FIELDS LIKE TABLE OF LS_FIELD.

*       Excel object
  DATA: GO_EXCEL  TYPE OLE2_OBJECT,
*       Work books
        GO_BOOKS  TYPE OLE2_OBJECT,
*       Work Book
        GO_BOOK   TYPE OLE2_OBJECT,
*       cell
        GO_CELL   TYPE OLE2_OBJECT,
*       Font
        GO_FONT   TYPE OLE2_OBJECT,
        GO_COLUMN TYPE OLE2_OBJECT.

* start Excel(OLE OBJECT 생성 & 실행)
  CREATE OBJECT GO_EXCEL 'EXCEL.APPLICATION'.
  PERFORM ERROR_HANDLE USING SY-SUBRC.
*  화면 DISPLAY 설정 (1을 설정하면 DISPLAY)
  SET PROPERTY OF GO_EXCEL  'Visible' = 1.
  PERFORM ERROR_HANDLE USING SY-SUBRC.

* get list of workbooks, initially empty( WORKBOOK 및 WORKBOOK 설정 & OPEN )
  CALL METHOD OF GO_EXCEL 'Workbooks' = GO_BOOKS.
  PERFORM ERROR_HANDLE USING SY-SUBRC.

* add a new workbook
  CALL METHOD OF GO_BOOKS 'Add' = GO_BOOK.
  PERFORM ERROR_HANDLE USING SY-SUBRC.


* get table field name
  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE LT_FIELDS
    FROM DD03L
    WHERE TABNAME = PA_TABNM.

  SORT LT_FIELDS BY POSITION.

* output column headings to active Excel sheet
  LOOP AT LT_FIELDS INTO LS_FIELD.
    LV_COL = LS_FIELD-POSITION.
    LV_LEN = LS_FIELD-INTLEN.

*   Excel Cell 행/열
    CALL METHOD OF GO_EXCEL 'Cells' = GO_CELL
     EXPORTING
       #1 = 1         "행.
       #2 = LV_COL.   "열.

*   Excel 행/열에 데이터 처리.
    SET PROPERTY OF GO_CELL 'Value' = LS_FIELD-FIELDNAME.
    PERFORM ERROR_HANDLE USING SY-SUBRC.

*   Excel Colomn
    CALL METHOD OF GO_EXCEL 'Columns' = GO_COLUMN
      EXPORTING
        #1 = LV_COL.

*   Excel column 길이 최적화
    CALL METHOD OF GO_COLUMN 'Autofit'.

    PERFORM ERROR_HANDLE USING SY-SUBRC.
  ENDLOOP.

  CALL METHOD OF GO_EXCEL 'QUIT'.
* release resources 반드시 FREE 해줄것!
  FREE OBJECT GO_COLUMN.
  FREE OBJECT GO_CELL.
  FREE OBJECT GO_BOOKS.
  FREE OBJECT GO_EXCEL.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form ERROR_HANDLE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> SY_SUBRC
*&---------------------------------------------------------------------*
FORM ERROR_HANDLE  USING    PV_SUBRC TYPE SY-SUBRC.
  IF PV_SUBRC <> 0.
    MESSAGE 'OLE 자동화 에러' TYPE 'W'.
    STOP.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form READ_FROM_FILE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM READ_FROM_FILE .


  CHECK SY-UNAME EQ 'ACA5-03'
   OR SY-UNAME EQ 'ACA5-07'
   OR SY-UNAME EQ 'ACA5-08'
   OR SY-UNAME EQ 'ACA5-10'
   OR SY-UNAME EQ 'ACA5-12'
   OR SY-UNAME EQ 'ACA5-15'
   OR SY-UNAME EQ 'ACA5-17'
   OR SY-UNAME EQ 'ACA5-23'
   OR SY-UNAME EQ 'ACA-05'.

  DATA: LV_FILENAME TYPE RLGRAP-FILENAME,
        LV_COL      TYPE I.

  DATA: LT_INTERN TYPE TABLE OF ALSMEX_TABLINE,
        LS_INTERN LIKE LINE OF LT_INTERN.

  DATA: LT_REF TYPE REF TO DATA,
        LS_REF TYPE REF TO DATA.

  FIELD-SYMBOLS: <FS_COMP> TYPE ANY,
                 <FS_STRU> TYPE ANY.

  CREATE DATA LT_REF TYPE TABLE OF (PA_TABNM).
  CREATE DATA LS_REF TYPE (PA_TABNM).

  ASSIGN LT_REF->* TO <FS_ITAB>.
  ASSIGN LS_REF->* TO <FS_STRU>.

  SELECT COUNT( * ) INTO LV_COL
    FROM DD03L
    WHERE TABNAME = PA_TABNM.

  LV_FILENAME = PA_FPATH.

  CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
    EXPORTING
      FILENAME                = LV_FILENAME
      I_BEGIN_COL             = 1
      I_BEGIN_ROW             = 2
      I_END_COL               = LV_COL
      I_END_ROW               = 65000
    TABLES
      INTERN                  = LT_INTERN
    EXCEPTIONS
      INCONSISTENT_PARAMETERS = 1
      UPLOAD_OLE              = 2
      OTHERS                  = 3.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

*  DATA: LT_DFIES TYPE TABLE OF DFIES.
*
*  CALL FUNCTION 'DDIF_FIELDINFO_GET'
*    EXPORTING
*      TABNAME        = 'ZCARR_E03'                 " Name of the Table (of the Type) for which Information is Required
*    TABLES
*      DFIES_TAB      = LT_DFIES .                " Field List if Necessary
*
*  IF SY-SUBRC <> 0.
**   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  ENDIF.


* 엑셀 데이터 넣기
  LOOP AT LT_INTERN INTO LS_INTERN.
    ASSIGN COMPONENT LS_INTERN-COL OF STRUCTURE <FS_STRU> TO <FS_COMP>.
    <FS_COMP> = LS_INTERN-VALUE.
    AT END OF ROW.
      APPEND <FS_STRU> TO <FS_ITAB>.
    ENDAT.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.
  SET PF-STATUS 'S100'.
  SET TITLEBAR 'T100' WITH PA_TABNM.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CLEAR_OK_CODE OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE CLEAR_OK_CODE OUTPUT.
  CLEAR: OK_CODE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.
  CASE OK_CODE.
    WHEN 'BACK' OR 'CANC'.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'SAVE'.
*     DB Table 데이터 저장 처리.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ALV OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE INIT_ALV OUTPUT.
  IF GO_DOCK IS INITIAL.

    CREATE OBJECT GO_DOCK
      EXPORTING
        REPID                       = SY-REPID
        DYNNR                       = SY-DYNNR
        SIDE                        = CL_GUI_DOCKING_CONTAINER=>DOCK_AT_TOP
        EXTENSION                   = 1500
      EXCEPTIONS
        CNTL_ERROR                  = 1
        CNTL_SYSTEM_ERROR           = 2
        CREATE_ERROR                = 3
        LIFETIME_ERROR              = 4
        LIFETIME_DYNPRO_DYNPRO_LINK = 5
        OTHERS                      = 6.
    IF SY-SUBRC <> 0.
*     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*                WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

    CREATE OBJECT GO_ALV
      EXPORTING
        I_PARENT          = GO_DOCK
      EXCEPTIONS
        ERROR_CNTL_CREATE = 1
        ERROR_CNTL_INIT   = 2
        ERROR_CNTL_LINK   = 3
        ERROR_DP_CREATE   = 4
        OTHERS            = 5.
    IF SY-SUBRC <> 0.
      MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
                 WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

    PERFORM SET_LAYOUT.

    CALL METHOD GO_ALV->SET_TABLE_FOR_FIRST_DISPLAY
      EXPORTING
        I_STRUCTURE_NAME              = PA_TABNM
        IS_LAYOUT                     = GS_LAYOUT
      CHANGING
        IT_OUTTAB                     = <FS_ITAB>
      EXCEPTIONS
        INVALID_PARAMETER_COMBINATION = 1
        PROGRAM_ERROR                 = 2
        TOO_MANY_LINES                = 3
        OTHERS                        = 4.
    IF SY-SUBRC <> 0.
* Implement suitable error handling here
    ENDIF.




  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Form SET_LAYOUT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_LAYOUT .

  DATA: LV_CNT TYPE I.

  LV_CNT = LINES( <FS_ITAB> ).

  GS_LAYOUT-ZEBRA = 'X'.
  GS_LAYOUT-CWIDTH_OPT = 'X'.
  GS_LAYOUT-GRID_TITLE = |Record Counter : | && LV_CNT.

ENDFORM.
