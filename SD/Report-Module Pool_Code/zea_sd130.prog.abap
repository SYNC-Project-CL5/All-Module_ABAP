*&---------------------------------------------------------------------*
*& Report YE00_EX005
*&---------------------------------------------------------------------*
*& [SD] 판매운영계획 아이템 엑셀 업로드
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEA_SD130.

* Include
INCLUDE ZEA_SD130_TOP.
*INCLUDE ZEA_SD130_PR_TOP.

INCLUDE ZEA_SD130_SCR.
*INCLUDE ZEA_SD130_PR_SCR.

INCLUDE ZEA_SD130_PBO.
*INCLUDE ZEA_SD130_PR_PBO.

INCLUDE ZEA_SD130_PAI.
*INCLUDE ZEA_SD130_PR_PAI.

INCLUDE ZEA_SD130_F01.
*INCLUDE ZEA_SD130_PR_F01.


* ABAP Event
INITIALIZATION.
  " Selection Screen 에서 앱툴바에 버튼을 추가할 때 아이콘을 다루고 싶을 때 사용
  DATA LS_DYNTXT TYPE SMP_DYNTXT.
  LS_DYNTXT-ICON_ID = ICON_XXL. " Icon 은 se38에서 showicon 프로그램을 실행해서 찾을 수 있다.
  LS_DYNTXT-ICON_TEXT = 'BOM ITEM 엑셀 양식 다운로드'.
  SSCRFIELDS-FUNCTXT_01 = LS_DYNTXT.

AT SELECTION-SCREEN OUTPUT.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR PA_FNAME.
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
  PERFORM MAKE_SAVE_DATA.       " 저장을 위한 데이터로 만든다.
