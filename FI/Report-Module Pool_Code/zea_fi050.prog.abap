*&---------------------------------------------------------------------*
*& Report ZEA_FI050
*&---------------------------------------------------------------------*
*& [FI] 환율 importing 프로그램 2024.04.13 [시작] - ACA5-08 김예리
*& [FI] 환율 importing 프로그램 2024.04.20 [완료] - ACA5-08 김예리
*&---------------------------------------------------------------------*
*& [2024.04.22 / 단위 테스트 완료] - [PM] 김건우 : o
*&---------------------------------------------------------------------*
REPORT ZEA_FI050 MESSAGE-ID ZEA_MSG.

*&---------------------------------------------------------------------*
PARAMETERS: P_URL    TYPE STRING LOWER CASE,              " URL
            P_DEST   TYPE RFCDISPLAY-RFCDEST LOWER CASE,  " RFC 목적지
            P_AUTH   TYPE STRING LOWER CASE,              " Authorization
            P_METHOD TYPE STRING ,              " HTTP METHOD
*            P_METHOD TYPE STRING OBLIGATORY,              " HTTP METHOD
            P_JSON   TYPE STRING LOWER CASE.              " Request Body JSON

DATA: LO_HTTP_CLIENT TYPE REF TO IF_HTTP_CLIENT,
      LO_REST_CLIENT TYPE REF TO CL_REST_HTTP_CLIENT,
      LO_REQUEST     TYPE REF TO IF_REST_ENTITY,
      LO_RESPONSE    TYPE REF TO IF_REST_ENTITY.
DATA: LO_EXCEPTION   TYPE REF TO CX_ROOT.
DATA: LV_STATUS_CODE TYPE  I,
      LV_STATUS_TEXT TYPE  STRING.

DATA: LT_RESPONSE_HEADER TYPE TIHTTPNVP.

TYPES: BEGIN OF TS_JSON,
         BKPR            TYPE STRING,
         CUR_NM          TYPE STRING,
         CUR_UNIT        TYPE STRING,
         DEAL_BAS_R      TYPE STRING,
         KFTC_BKPR       TYPE STRING,
         KFTC_DEAL_BAS_R TYPE STRING,
         RESULT          TYPE I,
         TEN_DD_EFEE_R   TYPE STRING,
         TTB             TYPE STRING,
         TTS             TYPE STRING,
         YY_EFEE_R       TYPE STRING,
       END OF TS_JSON.

TYPES: BEGIN OF TS_JSON_NUM,
         BKPR_NUM        TYPE P,
         CUR_NM          TYPE STRING,
         CUR_UNIT        TYPE STRING,
         DEAL_BAS_R      TYPE STRING,
         KFTC_BKPR       TYPE STRING,
         KFTC_DEAL_BAS_R TYPE STRING,
         RESULT          TYPE I,
         TEN_DD_EFEE_R   TYPE STRING,
         TTB             TYPE STRING,
         TTS             TYPE STRING,
         YY_EFEE_R       TYPE STRING,
       END OF TS_JSON_NUM.

DATA: GS_JSON TYPE TS_JSON,
      GT_JSON TYPE TABLE OF TS_JSON.

DATA: GS_JSON_NUM TYPE TS_JSON_NUM,
      GT_JSON_NUM TYPE TABLE OF TS_JSON_NUM.

DATA: GS_TCURR TYPE ZEA_TCURR,
      GT_TCURR TYPE TABLE OF ZEA_TCURR.

* -- 형변환
DATA: GV_STRING TYPE TS_JSON-BKPR. " VALUE '19,050'.
DATA: GV_NUM TYPE P.

DATA: GV_NEW_STRING TYPE STRING.

GV_NEW_STRING = REPLACE( VAL = GV_STRING
                          SUB = ','
                          WITH = '').

CALL FUNCTION 'MOVE_CHAR_TO_NUM'
  EXPORTING
    CHR             = GV_NEW_STRING
  IMPORTING
    NUM             = GV_NUM
  EXCEPTIONS
    CONVT_NO_NUMBER = 1
    CONVT_OVERFLOW  = 2
    OTHERS          = 3.
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.

*WRITE GV_NUM.


* -- 형변환
**DATA: GV_STRING TYPE STRING VALUE '19,050'.
**DATA: GV_NUM TYPE P.
**
**DATA: GV_NEW_STRING TYPE STRING.
**
**GV_NEW_STRING = REPLACE( val = GV_STRING
**                          sub = ','
**                          with = '').
**
**CALL FUNCTION 'MOVE_CHAR_TO_NUM'
**  EXPORTING
**    CHR             = GV_NEW_STRING
**  IMPORTING
**    NUM             = GV_NUM
**  EXCEPTIONS
**    CONVT_NO_NUMBER = 1
**    CONVT_OVERFLOW  = 2
**    OTHERS          = 3.
**IF SY-SUBRC <> 0.
*** Implement suitable error handling here
**ENDIF.
**
**WRITE GV_NUM.

*&---------------------------------------------------------------------*
* #1. HTTP Client
IF P_URL IS NOT INITIAL.
  "URL로 직접 호출
  CALL METHOD CL_HTTP_CLIENT=>CREATE_BY_URL
    EXPORTING
      URL                = P_URL
    IMPORTING
      CLIENT             = LO_HTTP_CLIENT
    EXCEPTIONS
      ARGUMENT_NOT_FOUND = 1
      PLUGIN_NOT_ACTIVE  = 2
      INTERNAL_ERROR     = 3
      PSE_NOT_FOUND      = 4
      PSE_NOT_DISTRIB    = 5
      PSE_ERRORS         = 6
      OTHERS             = 7.

  LO_HTTP_CLIENT->SEND(
*      EXPORTING
*        TIMEOUT                    = CO_TIMEOUT_DEFAULT " Timeout of Answer Waiting Time
*      EXCEPTIONS
*        HTTP_COMMUNICATION_FAILURE = 1                  " Communication Error
*        HTTP_INVALID_STATE         = 2                  " Invalid state
*        HTTP_PROCESSING_FAILED     = 3                  " Error when processing method
*        HTTP_INVALID_TIMEOUT       = 4                  " Invalid Time Entry
*        OTHERS                     = 5
  ).
  IF SY-SUBRC <> 0.
*     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*       WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  LO_HTTP_CLIENT->RECEIVE(
    EXCEPTIONS
      HTTP_COMMUNICATION_FAILURE = 1                " Communication Error
      HTTP_INVALID_STATE         = 2                " Invalid state
      HTTP_PROCESSING_FAILED     = 3                " Error when processing method
      OTHERS                     = 4
  ).
  IF SY-SUBRC <> 0.
*     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*       WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  DATA(LO_RECIVED_DATA) = LO_HTTP_CLIENT->RESPONSE->GET_DATA(
*      EXPORTING
*        OFFSET             = 0                                        " Offset into binary data
*        LENGTH             = -1                                       " Length of binary data
*        VIRUS_SCAN_PROFILE = '/SIHTTP/HTTP_UPLOAD'                    " Virus Scan Profile
*        VSCAN_SCAN_ALWAYS  = IF_HTTP_ENTITY=>CO_CONTENT_CHECK_PROFILE " Virus Scan Always (A = Always, N = Never, space = Internal)
*      RECEIVING
*        DATA               =                                          " Binary data
  ).


ELSEIF P_DEST IS NOT INITIAL.
  "RFC 목적지로 호출
  CALL METHOD CL_HTTP_CLIENT=>CREATE_BY_DESTINATION
    EXPORTING
      DESTINATION              = P_DEST
    IMPORTING
      CLIENT                   = LO_HTTP_CLIENT
    EXCEPTIONS
      ARGUMENT_NOT_FOUND       = 1
      DESTINATION_NOT_FOUND    = 2
      DESTINATION_NO_AUTHORITY = 3
      PLUGIN_NOT_ACTIVE        = 4
      INTERNAL_ERROR           = 5
      OTHERS                   = 6.
ELSE.
  EXIT.
ENDIF.
IF SY-SUBRC <> 0.
  LV_STATUS_CODE = 500.
  MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4 INTO LV_STATUS_TEXT.
  WRITE:/ LV_STATUS_CODE, LV_STATUS_TEXT.
  EXIT.
ENDIF.

* #1. REST Client 생성
TRY.
    CREATE OBJECT LO_REST_CLIENT
      EXPORTING
        IO_HTTP_CLIENT = LO_HTTP_CLIENT.
  CATCH CX_ROOT INTO LO_EXCEPTION.
    LV_STATUS_CODE = 500.
    LV_STATUS_TEXT = LO_EXCEPTION->GET_TEXT( ).
    WRITE:/ LV_STATUS_CODE, LV_STATUS_TEXT.
    EXIT.
ENDTRY.

IF LO_HTTP_CLIENT IS NOT BOUND OR LO_REST_CLIENT IS NOT BOUND.
  EXIT.
ENDIF.

* #2. Request 생성
*  LO_REQUEST = LO_REST_CLIENT->IF_REST_CLIENT~CREATE_REQUEST_ENTITY( ).
"Content type 설정 (application/json)
*  LO_REQUEST->SET_CONTENT_TYPE( IV_MEDIA_TYPE = IF_REST_MEDIA_TYPE=>GC_APPL_JSON ).   "content-type : application/json

"Accept type 설정 (application/json)
*  LO_REST_CLIENT->IF_REST_CLIENT~SET_REQUEST_HEADER( IV_NAME  = 'Accept' IV_VALUE = IF_REST_MEDIA_TYPE=>GC_APPL_JSON ).
"Authorization 설정
IF P_AUTH IS NOT INITIAL.
  LO_REST_CLIENT->IF_REST_CLIENT~SET_REQUEST_HEADER( IV_NAME  = 'Authorization' IV_VALUE = P_AUTH ).
ENDIF.
"Request Body
IF P_JSON IS NOT INITIAL.
  LO_REQUEST->SET_STRING_DATA( P_JSON ).
ENDIF.

* #3. HTTP Call
TRY.
    CASE P_METHOD.
      WHEN 'POST'.
        LO_REST_CLIENT->IF_REST_RESOURCE~POST( LO_REQUEST ).
      WHEN 'PUT'.
        LO_REST_CLIENT->IF_REST_RESOURCE~PUT( LO_REQUEST ).
      WHEN 'GET'.
        LO_REST_CLIENT->IF_REST_RESOURCE~GET( ).
      WHEN 'DELETE'.
        LO_REST_CLIENT->IF_REST_RESOURCE~DELETE( ).
    ENDCASE.
  CATCH CX_ROOT INTO LO_EXCEPTION.
    LV_STATUS_CODE = 500.
    LV_STATUS_TEXT = LO_EXCEPTION->GET_TEXT( ).
    WRITE:/ LV_STATUS_CODE, LV_STATUS_TEXT.
    EXIT.
ENDTRY.

* #4. Response
LO_RESPONSE = LO_REST_CLIENT->IF_REST_CLIENT~GET_RESPONSE_ENTITY( ).
"Response Body JSON
DATA(LV_RESPONSE_JSON) = LO_RESPONSE->GET_STRING_DATA( ).
"Response Body Content-type
LO_RESPONSE->GET_CONTENT_TYPE( IMPORTING EV_MEDIA_TYPE = DATA(LV_RESPONSE_CTYPE) ).
"Response Content Length
DATA(LV_RESPONSE_LENGTH) = LO_RESPONSE->GET_CONTENT_LENGTH( ).
"Status code, Status text
LV_STATUS_CODE = LO_REST_CLIENT->IF_REST_CLIENT~GET_STATUS(  ).
LV_STATUS_TEXT = LO_RESPONSE->GET_HEADER_FIELD( '~status_reason' ).
"Response Headers
LT_RESPONSE_HEADER = LO_RESPONSE->GET_HEADER_FIELDS( ).
"HTTP Close
LO_HTTP_CLIENT->CLOSE( ).

WRITE:/ LV_STATUS_CODE, LV_STATUS_TEXT.
WRITE:/ LV_RESPONSE_CTYPE, LV_RESPONSE_LENGTH.
WRITE:/ LV_RESPONSE_JSON.
*EXIT.
*&---------------------------------------------------------------------*

DATA(JSON) = LV_RESPONSE_JSON.
***/UI2/CL_JSON=>DESERIALIZE(
***  EXPORTING JSON = CONV #( JSON )
***  CHANGING DATA = GS_JSON
***).

/UI2/CL_JSON=>DESERIALIZE(
  EXPORTING JSON = CONV #( JSON )
  CHANGING DATA = GT_JSON
).

LOOP AT GT_JSON INTO GS_JSON.

  GV_NEW_STRING = REPLACE( VAL = GS_JSON-BKPR
                           SUB = ','
                           WITH = '').

  CALL FUNCTION 'MOVE_CHAR_TO_NUM'
    EXPORTING
      CHR             = GV_NEW_STRING
    IMPORTING
      NUM             = GV_NUM " Type : P
    EXCEPTIONS
      CONVT_NO_NUMBER = 1
      CONVT_OVERFLOW  = 2
      OTHERS          = 3.

  IF SY-SUBRC EQ 0.
*    GS_JSON-BKPR = GV_NUM. " <= 단순히 값을 전달, Type 이 변환되지는 않는다.
    MOVE-CORRESPONDING GS_JSON TO GS_JSON_NUM.

    GS_JSON_NUM-BKPR_NUM = GV_NUM.

    APPEND GS_JSON_NUM TO GT_JSON_NUM.
*    MODIFY GT_JSON_NUM FROM GS_JSON.
    WRITE : GS_JSON_NUM-BKPR_NUM. " < == CHAR
  ENDIF.


ENDLOOP.

CLEAR GS_TCURR.
REFRESH GT_TCURR.

* -- 테스트 완료
**LOOP AT GT_JSON_NUM INTO GS_JSON_NUM.
**  GS_TCURR-UKURS = GS_JSON_NUM-BKPR_NUM. " 환율
**  GS_TCURR-GDATU = '20240408'.     " 효력시작일
**  GS_TCURR-FCURR = 'KRW'.
**  GS_TCURR-TCURR = GS_JSON_NUM-CUR_UNIT.
**
**  APPEND GS_TCURR TO GT_TCURR.
**ENDLOOP.

LOOP AT GT_JSON_NUM INTO GS_JSON_NUM.
  GS_TCURR-UKURS = GS_JSON_NUM-BKPR_NUM. " 환율
  GS_TCURR-GDATU = SY-DATUM.     " 효력시작일 ( 당일 오후 12시 이후 실행되어야 함 )
  GS_TCURR-FCURR = 'KRW'.
  GS_TCURR-TCURR = GS_JSON_NUM-CUR_UNIT.

  APPEND GS_TCURR TO GT_TCURR.
ENDLOOP.


MODIFY ZEA_TCURR FROM TABLE GT_TCURR.

MESSAGE S000 WITH '데이터가 저장되었습니다'.

EXIT.


*&---------------------------------------------------------------------*
INITIALIZATION.
*P_URL = 'http://localhost:3000'. " sap 서버에서 local 로 접근 불가
* -- 프로그램을 실행하는 당일의 환율을 가져온다.
*  P_URL = 'https://www.koreaexim.go.kr/site/program/financial/exchangeJSON?authkey=IGG8ScoO0MmV3fsMb5AMdsI7KiSKA9hf&data=AP01'.
*  P_URL = 'https://www.koreaexim.go.kr/site/program/financial/exchangeJSON?authkey=IGG8ScoO0MmV3fsMb5AMdsI7KiSKA9hf&searchdate=20240408&data=AP01'.
*P_URL = 'https://www.koreaexim.go.kr/site/program/financial/exchangeJSON?searchdate=20240408&data=AP01'.
*  P_METHOD = 'GET'.
*P_AUTH = 'IGG8ScoO0MmV3fsMb5AMdsI7KiSKA9hf'.
