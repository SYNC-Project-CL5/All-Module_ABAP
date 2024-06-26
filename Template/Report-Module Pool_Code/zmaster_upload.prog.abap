*&---------------------------------------------------------------------*
*& Report ZMASTER_UPLOAD
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZMASTER_UPLOAD.

TYPE-POOLS truxs.

SELECTION-SCREEN: BEGIN OF BLOCK a WITH FRAME TITLE text-001.

PARAMETER:  p_table LIKE dd02l-tabname,
            p_file LIKE rlgrap-filename. " DEFAULT 'c:tempzcvaa.csv'.

SELECTION-SCREEN: END OF BLOCK a.

DATA: it_tab TYPE REF TO data.
DATA: gt_table TYPE REF TO cl_salv_table.

CREATE DATA it_tab TYPE TABLE OF (p_table).

FIELD-SYMBOLS: <fs_tab> TYPE STANDARD TABLE.

ASSIGN it_tab->* TO <fs_tab>.

DATA: it_type   TYPE truxs_t_text_data.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      field_name    = 'P_FILE'
    IMPORTING
      file_name     = p_file.

START-OF-SELECTION.


  CHECK SY-UNAME EQ 'ACA5-03'
   OR SY-UNAME EQ 'ACA5-07'
   OR SY-UNAME EQ 'ACA5-08'
   OR SY-UNAME EQ 'ACA5-10'
   OR SY-UNAME EQ 'ACA5-12'
   OR SY-UNAME EQ 'ACA5-15'
   OR SY-UNAME EQ 'ACA5-17'
   OR SY-UNAME EQ 'ACA5-23'
   OR SY-UNAME EQ 'ACA-05'.

* uploading the data in the file into internal table
  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
*     I_FIELD_SEPERATOR    =
*     I_LINE_HEADER        = 'X'
      i_tab_raw_data       = it_type
      i_filename           = p_file
    TABLES
      i_tab_converted_data = <fs_tab>
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc NE  0.
    MESSAGE ID sy-msgid
            TYPE sy-msgty
            NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

END-OF-SELECTION.

MODIFY (p_table) FROM TABLE <fs_tab>.
DESCRIBE TABLE <fs_tab> LINES DATA(dcr).

WRITE: dcr, 'lines got updated in table', p_table.
