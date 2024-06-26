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
      I_END_COL               = 20
      I_END_ROW               = 200
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

  " 18줄을 반복해서 9칸씩 데이터를 GT_EXCEL에 보관한다.
  LOOP AT GT_INTERN INTO DATA(LS_INTERN).
    AT NEW ROW.
      CLEAR GS_EXCEL.
    ENDAT.

    " 열 위치에 따른 스트럭쳐 필드를 <FS>로 연결해놓고,
    " GT_INTERN 으로부터 값을 받아서 반복중인 LS_INTERN의 VALUE 필드의 값을
    " <FS>로 전달한다.
    ASSIGN COMPONENT LS_INTERN-COL OF STRUCTURE GS_EXCEL TO <FS>.
    IF SY-SUBRC EQ 0.
      <FS> = LS_INTERN-VALUE.
    ENDIF.

    AT END OF ROW.
      APPEND GS_EXCEL TO GT_EXCEL.
    ENDAT.

  ENDLOOP.

  " 인터널 테이블에 저장된 데이터를 확인목적으로 팝업으로 출력
  CL_DEMO_OUTPUT=>DISPLAY( GT_EXCEL ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_SAVE_DATA
*&---------------------------------------------------------------------*
FORM MAKE_SAVE_DATA .

* Internal Table 초기화
  REFRESH GT_SDT010.


* GT_EXCEL 에는 엑셀과 동일한 형태의 데이터가 이미 보관되어 있다.
* 문제는 형태가 너무 동일해서 변수에 값을 전달할 때,
* 변환하는 과정이 필요하다.
  LOOP AT GT_EXCEL INTO GS_EXCEL.

    CLEAR GS_SDT010.
    GS_SDT010-SV_YEAR = GS_EXCEL-SV_YEAR.
    GS_SDT010-WERKS = GS_EXCEL-WERKS.
    GS_SDT010-MATNR = GS_EXCEL-MATNR.

    REPLACE ALL OCCURRENCES OF ',' IN GS_EXCEL-SAVQU WITH ''.
    GS_SDT010-SAVQU = GS_EXCEL-SAVQU.
    GS_SDT010-MEINS = GS_EXCEL-MEINS.
    GS_SDT010-TOTSAL = GS_EXCEL-TOTSAL.
    GS_SDT010-NETPR = GS_EXCEL-NETPR.
    GS_SDT010-WAERS = GS_EXCEL-WAERS.
    REPLACE ALL OCCURRENCES OF ',' IN GS_EXCEL-SVQTY1 WITH ''.
    GS_SDT010-SVQTY1 = GS_EXCEL-SVQTY1.
    REPLACE ALL OCCURRENCES OF ',' IN GS_EXCEL-SVQTY2 WITH ''.
    GS_SDT010-SVQTY2 = GS_EXCEL-SVQTY2.
    REPLACE ALL OCCURRENCES OF ',' IN GS_EXCEL-SVQTY3 WITH ''.
    GS_SDT010-SVQTY3 = GS_EXCEL-SVQTY3.
    REPLACE ALL OCCURRENCES OF ',' IN GS_EXCEL-SVQTY4 WITH ''.
    GS_SDT010-SVQTY4 = GS_EXCEL-SVQTY4.
    REPLACE ALL OCCURRENCES OF ',' IN GS_EXCEL-SVQTY5 WITH ''.
    GS_SDT010-SVQTY5 = GS_EXCEL-SVQTY5.
    REPLACE ALL OCCURRENCES OF ',' IN GS_EXCEL-SVQTY6 WITH ''.
    GS_SDT010-SVQTY6 = GS_EXCEL-SVQTY6.
    REPLACE ALL OCCURRENCES OF ',' IN GS_EXCEL-SVQTY7 WITH ''.
    GS_SDT010-SVQTY7 = GS_EXCEL-SVQTY7.
    REPLACE ALL OCCURRENCES OF ',' IN GS_EXCEL-SVQTY8 WITH ''.
    GS_SDT010-SVQTY8 = GS_EXCEL-SVQTY8.
    REPLACE ALL OCCURRENCES OF ',' IN GS_EXCEL-SVQTY9 WITH ''.
    GS_SDT010-SVQTY9 = GS_EXCEL-SVQTY9.
    REPLACE ALL OCCURRENCES OF ',' IN GS_EXCEL-SVQTY10 WITH ''.
    GS_SDT010-SVQTY10 = GS_EXCEL-SVQTY10.
    REPLACE ALL OCCURRENCES OF ',' IN GS_EXCEL-SVQTY11 WITH ''.
    GS_SDT010-SVQTY11 = GS_EXCEL-SVQTY11.
    REPLACE ALL OCCURRENCES OF ',' IN GS_EXCEL-SVQTY12 WITH ''.
    GS_SDT010-SVQTY12 = GS_EXCEL-SVQTY12.

    GS_SDT010-ERDAT = SY-DATUM.
    GS_SDT010-ERZET = SY-UZEIT.
    GS_SDT010-ERNAM = SY-UNAME.
    APPEND GS_SDT010 TO GT_SDT010.

  ENDLOOP.

  INSERT ZEA_SDT010 FROM TABLE @GT_SDT010.
  " 이미 데이터가 존재하는 경우에는 특정필드만 업데이트를 한다.
  " 이때 기존에 존재하던 데이터의 생성일자, 생성시간, 생성자를 보존하기 위해
  " 생성일자, 생성시간, 생성자는 업데이트 대상에서 제외시켜야한다.
  IF SY-SUBRC NE 0.
    UPDATE ZEA_SDT010 SET
                          SV_YEAR    = GS_SDT010-SV_YEAR
                          WERKS      = GS_SDT010-WERKS
                          MATNR      = GS_SDT010-MATNR
                          SAVQU      = GS_SDT010-SAVQU
                          MEINS      = GS_SDT010-MEINS
                          TOTSAL     = GS_SDT010-TOTSAL
                          NETPR      = GS_SDT010-NETPR
                          WAERS      = GS_SDT010-WAERS
                          SVQTY1     = GS_SDT010-SVQTY1
                          SVQTY2     = GS_SDT010-SVQTY2
                          SVQTY3     = GS_SDT010-SVQTY3
                          SVQTY4     = GS_SDT010-SVQTY4
                          SVQTY5     = GS_SDT010-SVQTY5
                          SVQTY6     = GS_SDT010-SVQTY6
                          SVQTY7     = GS_SDT010-SVQTY7
                          SVQTY8     = GS_SDT010-SVQTY8
                          SVQTY9     = GS_SDT010-SVQTY9
                          SVQTY10    = GS_SDT010-SVQTY10
                          SVQTY11    = GS_SDT010-SVQTY11
                          SVQTY12    = GS_SDT010-SVQTY12
                          LOEKZ      = GS_SDT010-LOEKZ

                          ERDAT     = SY-DATUM
                          ERZET     = SY-UZEIT
                          ERNAM     = SY-UNAME
                          WHERE SV_YEAR  EQ GS_SDT010-SV_YEAR
                            AND WERKS    EQ GS_SDT010-WERKS
                            AND MATNR    EQ GS_SDT010-MATNR.

  ENDIF.

  MESSAGE '업로드 과정이 완료되었습니다.' TYPE 'S'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DOWNLOAD_EXCEL_FILE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> SY_REPID
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

  DATA: LS_WWWDATA  TYPE WWWDATATAB,
        LV_FILE     TYPE RLGRAP-FILENAME.

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
       KEY          = LS_WWWDATA      " 엑셀파일 내용
       DESTINATION  = LV_FILE.        " 내 컴퓨터에 저장될 위치
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
