*&---------------------------------------------------------------------*
*& Report ZEA_FI_SEND_EMAIL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEA_FI_SEND_EMAIL MESSAGE-ID ZEA_MSG.


  DATA: BCS_EXCEPTION        TYPE REF TO CX_BCS,
        ERRORTEXT            TYPE STRING,
        CL_SEND_REQUEST      TYPE REF TO CL_BCS,
        CL_DOCUMENT          TYPE REF TO CL_DOCUMENT_BCS,
        CL_RECIPIENT         TYPE REF TO IF_RECIPIENT_BCS,
        T_ATTACHMENT_HEADER  TYPE SOLI_TAB,
        WA_ATTACHMENT_HEADER LIKE LINE OF T_ATTACHMENT_HEADER,
        ATTACHMENT_SUBJECT   TYPE SOOD-OBJDES,

        SOOD_BYTECOUNT       TYPE SOOD-OBJLEN,
        MAIL_TITLE           TYPE SO_OBJ_DES,
        T_MAILTEXT           TYPE SOLI_TAB,
        WA_MAILTEXT          LIKE LINE OF T_MAILTEXT,
        SEND_TO              TYPE ADR6-SMTP_ADDR,
        SENT                 TYPE ABAP_BOOL.

  WA_MAILTEXT = '안녕하세요. 감자입니다.'.
  APPEND WA_MAILTEXT TO T_MAILTEXT.
  CLEAR WA_MAILTEXT.


  WA_MAILTEXT = '감사합니다.'.
  APPEND WA_MAILTEXT TO T_MAILTEXT.
  CLEAR WA_MAILTEXT.


  MAIL_TITLE = '이세영 Test 메일 '.

  TRY.
      CL_SEND_REQUEST = CL_BCS=>CREATE_PERSISTENT( ).

      CL_DOCUMENT = CL_DOCUMENT_BCS=>CREATE_DOCUMENT( I_TYPE    = 'RAW' "#EC NOTEXT
                                                      I_TEXT    = T_MAILTEXT    " 메일 글 넣기
                                                      I_SUBJECT = MAIL_TITLE ). " 메일 타이틀 넣기

      CL_SEND_REQUEST->SET_DOCUMENT( CL_DOCUMENT ).


      "------------------첨부파일-------------------------------

*      " XLSX
*      ATTACHMENT_SUBJECT  = 'fill_template.xlsx'.  " 파일 명
*
*      CONCATENATE '&SO_FILENAME=' ATTACHMENT_SUBJECT INTO WA_ATTACHMENT_HEADER.
*      APPEND WA_ATTACHMENT_HEADER TO T_ATTACHMENT_HEADER.
*      CLEAR:
*        WA_ATTACHMENT_HEADER.
*
*      SOOD_BYTECOUNT = LV_REC_BYTECOUNT.
*
*
*      CL_DOCUMENT->ADD_ATTACHMENT(  I_ATTACHMENT_TYPE    = 'XLS' "#EC NOTEXT
*                                    I_ATTACHMENT_SUBJECT = ATTACHMENT_SUBJECT
*                                    I_ATTACHMENT_SIZE    = SOOD_BYTECOUNT
*                                    I_ATT_CONTENT_HEX    = LT_ROWREC
*                                    I_ATTACHMENT_HEADER  = T_ATTACHMENT_HEADER ).
*
*
*
*      " PDF
*      ATTACHMENT_SUBJECT  = 'fill_template.PDF'.
*
*      CONCATENATE '&SO_FILENAME=' ATTACHMENT_SUBJECT INTO WA_ATTACHMENT_HEADER.
*      APPEND WA_ATTACHMENT_HEADER TO T_ATTACHMENT_HEADER.
*      CLEAR:
*        WA_ATTACHMENT_HEADER.
*
** Attachment
*      SOOD_BYTECOUNT = LV_PDF_BYTECOUNT.  "
*
*      CL_DOCUMENT->ADD_ATTACHMENT(  I_ATTACHMENT_TYPE    = 'PDF' "#EC NOTEXT
*                                    I_ATTACHMENT_SUBJECT = ATTACHMENT_SUBJECT
*                                    I_ATTACHMENT_SIZE    = SOOD_BYTECOUNT
*                                    I_ATT_CONTENT_HEX    = LT_ROWPDF
*                                    I_ATTACHMENT_HEADER  = T_ATTACHMENT_HEADER ).


      "---------------------------------------------------------


      " --------------------수신사 TO 넣기 ----------------------

      SEND_TO = 'lsy8496@naver.com'.

      "--------------------------------------------------------

      CL_RECIPIENT = CL_CAM_ADDRESS_BCS=>CREATE_INTERNET_ADDRESS( SEND_TO ).
      CL_SEND_REQUEST->ADD_RECIPIENT( CL_RECIPIENT ).

      SENT = CL_SEND_REQUEST->SEND( I_WITH_ERROR_SCREEN = 'X' ).

      COMMIT WORK.

      IF SENT = ABAP_TRUE.

        " 성공메시지
   MESSAGE S001 WITH send_to '로 발송 되었습니다.' .

      ELSE.

        " 에러메시지

      ENDIF.

    CATCH CX_BCS INTO BCS_EXCEPTION.
      ERRORTEXT = BCS_EXCEPTION->IF_MESSAGE~GET_TEXT( ).
      MESSAGE ERRORTEXT TYPE 'I'.

  ENDTRY.
