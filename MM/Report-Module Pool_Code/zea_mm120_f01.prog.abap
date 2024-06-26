*&---------------------------------------------------------------------*
*& Include          YE00_EX005_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form F4_FNAME
*&---------------------------------------------------------------------*
FORM F4_FNAME  CHANGING PV_FNAME LIKE PA_FNAME.

  DATA LT_FILE TYPE FILETABLE.
  DATA LV_RC   TYPE I.

  CALL METHOD CL_GUI_FRONTEND_SERVICES=>FILE_OPEN_DIALOG
    EXPORTING
      WINDOW_TITLE      = '업로드 파일을 선택하세요'
      DEFAULT_EXTENSION = '*.xlsx' " Default Extension
      FILE_FILTER       = '엑셀파일(*.xlsx, *.xls)|*.xlsx;*.xls'  " File Extension Filter String
      INITIAL_DIRECTORY = 'C:\'
    CHANGING
      FILE_TABLE        = LT_FILE  " Table Holding Selected Files
      RC                = LV_RC    " Return Code, Number of Files or -1 If Error Occurred
    EXCEPTIONS
      OTHERS            = 1.

  IF SY-SUBRC EQ 0 AND LV_RC GT 0.
    " 선택한 파일 목록에서 첫번째를 LS_FILE 에 보관한다.
    READ TABLE LT_FILE INTO DATA(LS_FILE) INDEX 1.
    PV_FNAME = LS_FILE-FILENAME.

    MESSAGE '파일이 선택되었습니다.' TYPE 'S'.
  ELSE.
    MESSAGE '파일 선택이 취소되었습니다.' TYPE 'S' DISPLAY LIKE 'W'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form UPLOAD_EXCEL
*&---------------------------------------------------------------------*
FORM UPLOAD_EXCEL .

  REFRESH GT_INTERN.

  DATA LV_FILENAME TYPE RLGRAP-FILENAME.

  " 함수에게 파일명을 전달할 때 타입이 다르면 오류가 발생하므로,
  " 동일한 타입의 변수를 만들고 그 변수에 파일명을 전달하여
  " 오류발생을 방지한다.
  LV_FILENAME = PA_FNAME.

  " LV_FILENAME 에 저장된 파일 경로로 접근해서 해당 파일이 엑셀파일이면
  " 엑셀 파일 내에서 1번째 칸부터 9번째 칸까지 하나의 데이터로 취급한다.
  " 이때 시작하는 라인은 2번째 줄부터 데이터가 계속해서 이어지는 조건에
  " 최종적으로 5000번째 줄까지 내용을 읽어온다.
  CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
    EXPORTING
      FILENAME                = LV_FILENAME
      I_BEGIN_COL             = 1
      I_BEGIN_ROW             = 2
      I_END_COL               = 9
      I_END_ROW               = 5000
    TABLES
      INTERN                  = GT_INTERN
    EXCEPTIONS
      INCONSISTENT_PARAMETERS = 1
      UPLOAD_OLE              = 2
      OTHERS                  = 3.

  CASE SY-SUBRC.
    WHEN 0. " 엑셀 파일의 내용을 주어진 조건에 맞춰서 올바르게 가져왔다.
    WHEN 1. MESSAGE '엑셀 파일 경로 또는 데이터 범위가 잘못되었습니다.' TYPE 'E'.
    WHEN 2. MESSAGE '지정한 경로의 파일이 엑셀파일이 아닙니다.' TYPE 'E'.
    WHEN 3. MESSAGE '알 수 없는 오류가 발생했습니다.' TYPE 'E'.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MOVE_INTERN_TO_ITAB
*&---------------------------------------------------------------------*
FORM MOVE_INTERN_TO_ITAB .

  FIELD-SYMBOLS <FS>.

  REFRESH GT_EXCEL.

  " 18줄을 반복해서 9칸씩 데이터를 GT_EXCEL에 한 줄로 보관한다.
  LOOP AT GT_INTERN INTO DATA(LS_INTERN).
    AT NEW ROW.
      CLEAR GS_EXCEL.
    ENDAT.

    " 열 위치에 따른 스트럭쳐 필드를 <FS>로 연결해놓고,
    " GT_INTERN으로부터 값을 받아서 반복중인 LS_INTERN의 VALUE 필드의 값을
    " <FS>로 전달한다.
    ASSIGN COMPONENT LS_INTERN-COL OF STRUCTURE GS_EXCEL TO <FS>.
    IF SY-SUBRC EQ 0.
      <FS> = LS_INTERN-VALUE.
    ENDIF.

    AT END OF ROW.
      APPEND GS_EXCEL TO GT_EXCEL.
    ENDAT.
  ENDLOOP.


  " 인터널 테이블에 저장된 데이터를 확인목적으로 팝업출력
  CL_DEMO_OUTPUT=>DISPLAY( GT_EXCEL ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_SAVE_DATA
*&---------------------------------------------------------------------*
FORM MAKE_SAVE_DATA .

* Internal Table 초기화
  REFRESH GT_MMT190.

** Inline 선언을 이용해 데이터 검색과 동시에 Internal Table 선언
*  SELECT MATTYPE
*    FROM ZEA_MMT020
*    INTO TABLE @DATA(LT_ZEA_MMT020)." lt_t134 라는 internal table은 field가 MATTYPE 하나만 존재
*
*  SORT LT_ZEA_MMT020 BY MATTYPE. " 정렬

* GT_EXCEL에는 엑셀과 동일한 형태의 데이터가 이미 보관되어 있다.
* 문제는 형태가 너무 동일해서 변수에 값을 전달할 때,
* 변환하는 과정이 필요하다.
  LOOP AT GT_EXCEL INTO GS_EXCEL.

    CLEAR GS_MMT190.
    GS_MMT190-MATNR = GS_EXCEL-MATNR. " 자재코드   문자 <- 문자
    GS_MMT190-WERKS = GS_EXCEL-WERKS. " 플랜트 ID
    GS_MMT190-SCODE = GS_EXCEL-SCODE. " 저장위치 CODE

    REPLACE ALL OCCURRENCES OF ',' IN GS_EXCEL-CALQTY WITH ''. " 수량에 , 가 있으면 제거
    GS_MMT190-CALQTY = GS_EXCEL-CALQTY. " 수량   문자 <- 문자

*    REPLACE ALL OCCURRENCES OF ',' IN GS_EXCEL-LENGT WITH ''. " 길이에 , 가 있으면 제거
    REPLACE ALL OCCURRENCES OF ',' IN GS_EXCEL-CALQTY WITH ''. " 무게에 , 가 있으면 제거
    GS_MMT190-CALQTY = GS_EXCEL-CALQTY.



    REPLACE ALL OCCURRENCES OF ',' IN GS_EXCEL-WEIGHT WITH ''. " 무게에 , 가 있으면 제거
    REPLACE ALL OCCURRENCES OF ',' IN GS_EXCEL-SAFSTK WITH ''. " 무게에 , 가 있으면 제거
*    GS_MARA-LENGT = GS_EXCEL-LENGT. " 길이       숫자 <- 문자
    GS_MMT190-WEIGHT = GS_EXCEL-WEIGHT. " 무게       숫자 <- 문자

    GS_MMT190-MEINS2 = GS_EXCEL-MEINS2. " 개수 단위   문자 <- 문자
    GS_MMT190-MEINS  = GS_EXCEL-MEINS.  " 무게 단위  문자 <- 문자
    GS_MMT190-SAFSTK = GS_EXCEL-SAFSTK. " 안전재고
    GS_MMT190-MEINS3 = GS_EXCEL-MEINS3. " 단위

    GS_MMT190-ERDAT = SY-DATUM.       " 현재일자   날짜 <- 날짜
    GS_MMT190-ERZET = SY-UZEIT.       " 현재시간   시간 <- 시간
    GS_MMT190-ERNAM = SY-UNAME.       " 현재사용자 문자 <- 문자

    APPEND GS_MMT190 TO GT_MMT190.

    INSERT ZEA_MMT190 FROM @GS_MMT190.
    IF SY-SUBRC NE 0.
      " 이미 데이터가 존재하는 경우에는 특정 필드만 업데이트를 한다.
      " 이때 기존에 존재하던 데이터의 생성일자, 생성시간, 생성자를 보존하기 위해
      " 생성일자, 생성시간, 생성자는 업데이트 대상에서 제외시켜야한다.
      UPDATE ZEA_MMT190 SET MATNR   = GS_MMT190-MATNR
                            WERKS   = GS_MMT190-WERKS
                            SCODE   = GS_MMT190-SCODE
                            CALQTY  = GS_MMT190-CALQTY
                            MEINS   = GS_MMT190-MEINS
                            WEIGHT  = GS_MMT190-WEIGHT
                            MEINS2  = GS_MMT190-MEINS2
                            AEDAT   = SY-DATUM
                            AEZET   = SY-UZEIT
                            AENAM   = SY-UNAME
                     WHERE MATNR EQ GS_MMT190-MATNR
                       AND WERKS EQ GS_MMT190-WERKS
                       AND SCODE EQ GS_MMT190-SCODE.
    ENDIF.

  ENDLOOP.

  MESSAGE '업로드 과정이 완료되었습니다.' TYPE 'S'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DOWNLOAD_EXCEL_FILE
*&---------------------------------------------------------------------*
FORM DOWNLOAD_EXCEL_FILE  USING PV_REPID. " 현재 프로그램 이름

  DATA LV_SAVEPATH TYPE STRING.

  "4-1. 저장위치 선택
  PERFORM SET_SAVE_PATH CHANGING LV_SAVEPATH.

  "4-2. Web Repository에서 파일 선택 및 저장
  PERFORM SAVE_TEMPLATE USING PV_REPID LV_SAVEPATH.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_SAVE_PATH
*&---------------------------------------------------------------------*
FORM SET_SAVE_PATH  CHANGING PV_SAVEPATH.


  DATA : LV_FILENAME      TYPE STRING,
         LV_PATH          TYPE STRING,
         LV_SAVE_FILENAME TYPE STRING.

  LV_FILENAME = |{ SY-REPID }_Template_{ SY-DATUM }_{ SY-UZEIT }.xlsx|.

  CL_GUI_FRONTEND_SERVICES=>FILE_SAVE_DIALOG(
    EXPORTING
      DEFAULT_FILE_NAME         = LV_FILENAME
      FILE_FILTER               = '엑셀 파일(*.xlsx)|*.xlsx'
      INITIAL_DIRECTORY         = 'C:\'
    CHANGING
      FILENAME                  = LV_SAVE_FILENAME
      PATH                      = LV_PATH
      FULLPATH                  = PV_SAVEPATH
    EXCEPTIONS
      CNTL_ERROR                = 1                " Control error
      ERROR_NO_GUI              = 2                " No GUI available
      NOT_SUPPORTED_BY_GUI      = 3                " GUI does not support this
      INVALID_DEFAULT_FILE_NAME = 4                " Invalid default file name
      OTHERS                    = 5
  ).

  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY
     NUMBER SY-MSGNO WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SAVE_TEMPLATE
*&---------------------------------------------------------------------*
FORM SAVE_TEMPLATE  USING  PV_REPID
                           PV_SAVEPATH.

  DATA: LS_WWWDATA TYPE WWWDATATAB,
        LV_FILE    TYPE RLGRAP-FILENAME.

  " SMW0에 저장한 Object Name
  SELECT SINGLE *
    FROM WWWDATA
    INTO CORRESPONDING FIELDS OF LS_WWWDATA
    WHERE OBJID = PV_REPID.

  CHECK PV_SAVEPATH IS NOT INITIAL.

  " PV_SAVEPATH의 타입은 STRING이고,
  " 함수에 넘겨주는 변수타입은 RLGRAP-FILENAME이기 때문에
  " 타입 변환을 위해 아래와 같이 값을 전달해준다.
  LV_FILE = PV_SAVEPATH.

*--------------------------------------------------------------------*
* 엑셀파일 다운로드 실행
*--------------------------------------------------------------------*
  CALL FUNCTION 'DOWNLOAD_WEB_OBJECT'
    EXPORTING
      KEY         = LS_WWWDATA      " 엑셀파일 내용
      DESTINATION = LV_FILE.        " 내 컴퓨터에 저장될 위치
*--------------------------------------------------------------------*

  " 다운로드 받은 뒤에 바로 파일을 실행시키고 싶다면 아래 함수를 사용한다.
  " 이때, DOCUMENT 파라미터는 STRING 타입이기 때문에 LV_FILE이 아닌 PV_SAVEPATH를 이용한다.
  IF SY-SUBRC = 0.
    MESSAGE '엑셀 파일 다운로드가 완료되었습니다.' TYPE 'S'.

    CL_GUI_FRONTEND_SERVICES=>EXECUTE(
      EXPORTING
        DOCUMENT               = PV_SAVEPATH " Path+Name to Document
      EXCEPTIONS
        CNTL_ERROR             = 1 " Control error
        ERROR_NO_GUI           = 2 " No GUI available
        BAD_PARAMETER          = 3 " Incorrect parameter combination
        FILE_NOT_FOUND         = 4 " File not found
        PATH_NOT_FOUND         = 5 " Path not found
        FILE_EXTENSION_UNKNOWN = 6 " Could not find application for specified extension
        ERROR_EXECUTE_FAILED   = 7 " Could not execute application or document
        SYNCHRONOUS_FAILED     = 8 " Cannot Call Application Synchronously
        NOT_SUPPORTED_BY_GUI   = 9 " GUI does not support this
        OTHERS                 = 10
    ).

  ENDIF.


ENDFORM.
