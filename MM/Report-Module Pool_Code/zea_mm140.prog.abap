*&---------------------------------------------------------------------*
*& Report ZEA_MM140
*&---------------------------------------------------------------------*
*& [MM] 인포 레코드 Excel 업로드
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEA_MM140.

* Include
INCLUDE ZEA_MM140_TOP.
INCLUDE ZEA_MM140_SCR.
INCLUDE ZEA_MM140_PBO.
INCLUDE ZEA_MM140_PAI.
INCLUDE ZEA_MM140_F01.


* ABAP Event
INITIALIZATION.
  " Selection screen에서 앱툴바에 버튼을 추가할 때 아이콘을 다루고 싶을 때 사용
  DATA LS_DYNTXT TYPE SMP_DYNTXT.
  LS_DYNTXT-ICON_ID = ICON_XXL. " Icon은 se38에서 showicon 프로그램을 실행해서 찾을 수 있다.
  LS_DYNTXT-ICON_TEXT = '엑셀 템플릿 다운로드'.
  SSCRFIELDS-FUNCTXT_01 = LS_DYNTXT.
*  SSCRFIELDS-FUNCTXT_01 = '엑셀 템플릿 다운로드'.

AT SELECTION-SCREEN OUTPUT.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR PA_FNAME.
**  MESSAGE 'Possible Entry 버튼을 누르셨네요.' TYPE 'I'.
**  PA_FNAME = 'TEST.XLSX'.
  PERFORM F4_FNAME CHANGING PA_FNAME.


AT SELECTION-SCREEN.
  " Selection Screen의 앱툴바에 추가된 버튼은
  " FC01 부터 FC05 까지 사전에 정의가 되어 있다. ( 외어야 한다. )
  CASE SSCRFIELDS-UCOMM.
    WHEN 'FC01'.
      MESSAGE '엑셀파일을 다운로드 합니다.' TYPE 'I'.
      PERFORM DOWNLOAD_EXCEL_FILE USING SY-REPID.
  ENDCASE.

START-OF-SELECTION.

  PERFORM UPLOAD_EXCEL.         " 엑셀파일을 읽어온다.
  PERFORM MOVE_INTERN_TO_ITAB.  " 엑셀파일 내용을 Internal Table로 옮긴다.
  PERFORM MAKE_SAVE_DATA.       " 저장을 위한 데이터를 만든다.
