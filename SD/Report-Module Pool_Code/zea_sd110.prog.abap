*&---------------------------------------------------------------------*
*& Report ZEA_SD110
*&---------------------------------------------------------------------*
*& [SD] 출고 데이터 배치잡 프로그램 [완료] - ACA5-12 박지영
*&---------------------------------------------------------------------*
REPORT ZEA_SD110 MESSAGE-ID ZEA_MSG.

* [개요]
* 출하/운송 관리 Header 테이블에서 데이터를 수정해서 UPDATE 해주기.

* [순서]
* -출고되는 건
*    (1. DB에서 상태플래그가 초록색인 것에 대해 데이터를 가져온다.) ??
*    2. 오늘(SY-DATUM) 과 비교하여 일치하는것에 대한 값을 SELECT한다.
*    3. 해당 값을 수정하여 인터널 테이블에 넣어준다.
*       (출고일 / 배송도착예정일 / 배송상태 / 상태플래그2 )
*    4. DB에 데이터를 UPDATE 해준다.
*    5. 대금청구생성 프로그램에서 해당 데이터들 반영.
* -출고완료된 건
*    1. 오늘(SY-DATUM) EQ 배송도착예정일(출고일+3) 인 건들에 대한
*       데이터를 가져온다.
*    2. 해당 값을 수정하여 인터널 테이블에 넣어준다.
*       ( 배송상태 / 상태플래그2 )
*    3. DB에 데이터를 UPDATE 해준다.

INCLUDE ZEA_SD110_TOP.
*INCLUDE ZEA_SD110_SCR.
*INCLUDE ZEA_SD110_CLS.
INCLUDE ZEA_SD110_PBO.
INCLUDE ZEA_SD110_PAI.
INCLUDE ZEA_SD110_F01.


*--------------------------------------------------------------------*
* 출고되는 건
*--------------------------------------------------------------------*

DATA: LT_SDT060 TYPE TABLE OF ZEA_SDT060,
      LS_SDT060 TYPE ZEA_SDT060,
      LV_DADAT  TYPE I,
      LV_DATUM  TYPE SY-DATUM.


DATA: IS_HEAD TYPE ZEA_MMT090,   " 출고문서 FI 함수 MM 함수
      IT_ITEM TYPE ZEA_MMY100.



START-OF-SELECTION.
*-- 2. 오늘(SY-DATUM) 과 비교하여 일치하는것에 대한 값을 SELECT한다.
REFRESH GT_DATA.

SELECT *
  FROM ZEA_SDT060
  INTO CORRESPONDING FIELDS OF TABLE GT_DATA
 WHERE RQDAT EQ SY-DATUM.


*--3. 해당 값을 수정하여 인터널 테이블에 넣어준다.
*     (출고일 / 배송도착예정일 / 배송상태 / 상태플래그2 )

LOOP AT GT_DATA INTO GS_DATA.

  GS_DATA-RETSU = '출고 완료'.
  GS_DATA-REDAT = SY-DATUM.
  GS_DATA-DADAT = GS_DATA-REDAT + 3.
  GS_DATA-DESTU = '배송중'.
  GS_DATA-STATUS2 = 'I'.


*  CALL FUNCTION 'ZEA_MM_SDFG'
*    EXPORTING
*      IV_SBELNR = GS_DATA-SBELNR   "출고 문서 번호
*    IMPORTING
*      ES_HEAD   = IS_HEAD             " [MM] 자재문서 Header
*      ET_ITEM   = IT_ITEM.             " 자재문서 ITEM 테이블타입
*
*  CALL FUNCTION 'ZEA_FI_WL'
*    EXPORTING
*      IS_HEAD = IS_HEAD    " [MM] 자재문서 Header
*      IT_ITEM = IT_ITEM.    " 자재문서 ITEM 테이블타입


  MODIFY GT_DATA FROM GS_DATA.
  MOVE-CORRESPONDING GS_DATA TO LS_SDT060.
  UPDATE ZEA_SDT060 FROM LS_SDT060.

ENDLOOP.

IF SY-SUBRC EQ 0.
  COMMIT WORK AND WAIT. "저장성공
*  PERFORM DEC_TABLE_DATA.
*  PERFORM DEC_BATCH_DATA.
ELSE.
  ROLLBACK WORK. "저장실패
ENDIF.



*--------------------------------------------------------------------*
* 출고완료된 건
*--------------------------------------------------------------------*


*-- 1. 오늘(SY-DATUM) EQ 배송도착예정일(출고일+3) 인 건들에 대한
*       데이터를 가져온다.
REFRESH GT_DATA.

SELECT *
  FROM ZEA_SDT060
  INTO CORRESPONDING FIELDS OF TABLE GT_DATA
 WHERE DADAT EQ SY-DATUM.


*-- 2. 해당 값을 수정하여 인터널 테이블에 넣어준다.
*      ( 배송상태 / 상태플래그2 )

LOOP AT GT_DATA INTO GS_DATA.

  GS_DATA-DESTU = '배송완료'.
  GS_DATA-STATUS2 = 'O'.

  MODIFY GT_DATA FROM GS_DATA.
  MOVE-CORRESPONDING GS_DATA TO LS_SDT060.
  UPDATE ZEA_SDT060 FROM LS_SDT060.

ENDLOOP.

IF SY-SUBRC EQ 0.
  COMMIT WORK AND WAIT. "저장성공
ELSE.
  ROLLBACK WORK. "저장실패
ENDIF.
