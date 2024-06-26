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
      WINDOW_TITLE            = '업로드 파일을 선택하세요'
      DEFAULT_EXTENSION       = '*.xlsx' " Default Extension
      FILE_FILTER             = '엑셀파일(*.xlsx, *.xls)|*.xlsx;*.xls'  " File Extension Filter String
      INITIAL_DIRECTORY       = 'C:\'
    CHANGING
      FILE_TABLE              = LT_FILE  " Table Holding Selected Files
      RC                      = LV_RC    " Return Code, Number of Files or -1 If Error Occurred
    EXCEPTIONS
      OTHERS                  = 1.

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
      I_END_COL               = 12
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
*
** Inline 선언을 이용해 데이터 검색과 동시에 Internal Table 선언
*  SELECT MTART
*    FROM T134
*    INTO TABLE @DATA(LT_T134)." lt_t134 라는 internal table은 field가 MTART 하나만 존재
*
*  SORT LT_T134 BY MTART. " 정렬

* GT_EXCEL에는 엑셀과 동일한 형태의 데이터가 이미 보관되어 있다.
* 문제는 형태가 너무 동일해서 변수에 값을 전달할 때,
* 변환하는 과정이 필요하다.
  LOOP AT GT_EXCEL INTO GS_EXCEL.

    CLEAR GS_MARA.
    GS_MARA-VENCODE = GS_EXCEL-VENCODE. " 자재코드   문자 <- 문자
    GS_MARA-SAKNR = GS_EXCEL-SAKNR.

    " 위에서 검색된 LT_T134는 현재 사용 중인 모든 자재유형이 저장되어 있다.
    " MTART 필드 기준으로 GS_EXCEL-MTART 가 가진 값이랑 동일한 자재유형이 있는지 검사한다.
    " 만약 동일한 자재유형이 검색되지 않는다면,
    " 현재 사용 중인 자재유형이라고 볼 수 없으므로,
    " 결론을 내리자면, 없는 자재유형을 엑셀로 업로드 하고자 했다고 본다.
*    READ TABLE LT_T134 TRANSPORTING NO FIELDS
*                       WITH KEY MTART = GS_EXCEL-MTART BINARY SEARCH.
*    IF SY-SUBRC NE 0.
*      " 검색 실패
*      MESSAGE '엑셀파일에 존재하지 않는 자재유형이 입력되어 있습니다.'
*         TYPE 'E' DISPLAY LIKE 'I'. " 에러메시지 + 팝업
*    ENDIF.
    GS_MARA-BPVEN = GS_EXCEL-BPVEN. " 자재유형   문자 <- 문자

*    REPLACE ALL OCCURRENCES OF ',' IN GS_EXCEL-LENGT WITH ''. " 길이에 , 가 있으면 제거
*    REPLACE ALL OCCURRENCES OF ',' IN GS_EXCEL-BRGEW WITH ''. " 무게에 , 가 있으면 제거
    GS_MARA-BPCSNR = GS_EXCEL-BPCSNR. " 길이       숫자 <- 문자
    GS_MARA-BPHAED = GS_EXCEL-BPHAED. "무게       숫자 <- 문자

    GS_MARA-BPADRR = GS_EXCEL-BPADRR. "자재단위   문자 <- 문자
    GS_MARA-BPSTAT = GS_EXCEL-BPSTAT. "자재단위   문자 <- 문자
    GS_MARA-ZLSCH = GS_EXCEL-ZLSCH. "자재단위   문자 <- 문자
    GS_MARA-LAND1 = GS_EXCEL-LAND1. "자재단위   문자 <- 문자
*    GS_MARA-ACCNT = GS_EXCEL-ACCNT. "자재단위   문자 <- 문자
*    GS_MARA-BANKS = GS_EXCEL-BANKS. "자재단위   문자 <- 문자

*    REPLACE ALL OCCURRENCES OF '-' IN GS_EXCEL-BEGDA WITH ''.
*    GS_MARA-BEGDA = GS_EXCEL-BEGDA. " 길이 단위  문자 <- 문자
*
**    GS_MARA-DATAB = GS_EXCEL-DATAB. " 시작일     날짜 <- 문자
*
**    GS_MARA-ERDAT = SY-DATUM.       " 현재일자   날짜 <- 날짜
**    GS_MARA-ERZET = SY-UZEIT.       " 현재시간   시간 <- 시간
**    GS_MARA-ERNAM = SY-UNAME.       " 현재사용자 문자 <- 문자
**    APPEND GS_MARA TO GT_MARA.

    INSERT ZEA_LFA1 FROM @GS_MARA.
*    IF SY-SUBRC NE 0.
*      " 이미 데이터가 존재하는 경우에는 특정 필드만 업데이트를 한다.
*      " 이때 기존에 존재하던 데이터의 생성일자, 생성시간, 생성자를 보존하기 위해
*      " 생성일자, 생성시간, 생성자는 업데이트 대상에서 제외시켜야한다.
*      UPDATE YE00_MARA SET MTART = GS_MARA-MTART
*                           MEINS = GS_MARA-MEINS
*                           LENGT = GS_MARA-LENGT
*                           LENGM = GS_MARA-LENGM
*                           BRGEW = GS_MARA-BRGEW
*                           GEWEI = GS_MARA-GEWEI
*                           DATAB = GS_MARA-DATAB
*                           AEDAT = SY-DATUM
*                           AEZET = SY-UZEIT
*                           AENAM = SY-UNAME
*                     WHERE MATNR EQ GS_MARA-MATNR.
*    ENDIF.

*
*    " 자재명에 대한 테이블 레코드 생성
*    CLEAR GS_MAKT.
*    GS_MAKT-MATNR = GS_EXCEL-MATNR. " 자재코드
*    GS_MAKT-SPRAS = SY-LANGU.       " 현재 로그인한 언어코드
*    GS_MAKT-MAKTX = GS_EXCEL-MAKTX. " 자재명
*
*    INSERT YE00_MAKT FROM @GS_MAKT.
*    IF SY-SUBRC NE 0.
*      UPDATE YE00_MAKT SET MAKTX = GS_EXCEL-MAKTX
*                     WHERE MATNR EQ GS_EXCEL-MATNR
*                       AND SPRAS EQ SY-LANGU.
*    ENDIF.

  ENDLOOP.

  MESSAGE '업로드 과정이 완료되었습니다.' TYPE 'S'.

ENDFORM.
