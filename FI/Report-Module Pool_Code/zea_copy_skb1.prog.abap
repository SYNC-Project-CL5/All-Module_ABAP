*&---------------------------------------------------------------------*
*& Report YE00_EX005
*&---------------------------------------------------------------------*
*& [연습] 엑셀 업로드
*&---------------------------------------------------------------------*
REPORT ZEA_COPY_SKB1.

* Include
INCLUDE ZEA_COPY_SKB1_TOP.
*INCLUDE YE00_EX005_COPY_TOP.
*INCLUDE YE00_EX005_TOP. " 전역변수    Global Variable
INCLUDE ZEA_COPY_SKB1_SCR.
*INCLUDE YE00_EX005_COPY_SCR.
*INCLUDE YE00_EX005_SCR. " 선택화면    Selection Screen
INCLUDE ZEA_COPY_SKB1_PBO.
*INCLUDE YE00_EX005_COPY_PBO.
*INCLUDE YE00_EX005_PBO. " 출력전 모듈 Process Before Output
INCLUDE ZEA_COPY_SKB1_PAI.
*INCLUDE YE00_EX005_COPY_PAI.
*INCLUDE YE00_EX005_PAI. " 출력후 모듈 Process After  Input
INCLUDE ZEA_COPY_SKB1_F01.
*INCLUDE YE00_EX005_COPY_F01.
*INCLUDE YE00_EX005_F01. " 내부로직    Subroutine

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
  ENDCASE.

START-OF-SELECTION.

  PERFORM UPLOAD_EXCEL.         " 엑셀파일을 읽어온다.
  PERFORM MOVE_INTERN_TO_ITAB.  " 엑셀파일 내용을 Internal Table로 옮긴다.
  PERFORM MAKE_SAVE_DATA.       " 저장을 위한 데이터를 만든다.
