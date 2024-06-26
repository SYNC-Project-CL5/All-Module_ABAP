*&---------------------------------------------------------------------*
*& Include          YE12_PJ034_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form SELECT_DATA
*&---------------------------------------------------------------------*
FORM SELECT_DATA .

*** 고객 데이터
  SELECT SINGLE *
    FROM ZEA_KNA1
    INTO CORRESPONDING FIELDS OF GS_BPDATA
   WHERE CUSCODE EQ ZEA_KNA1-CUSCODE.

*** 판매오더 HEADER ALV
  SELECT *
    FROM ZEA_SDT040
    INTO CORRESPONDING FIELDS OF TABLE GT_DATA1.
*    WHERE CUSCODE EQ ZEA_KNA1-CUSCODE.
  SORT GT_DATA1 BY VBELN ODDAT ASCENDING.

*CLEAR GS_BPDATA.

*** 판매오더 ITEM ALV
****  SELECT *
****    FROM ZEA_SDT050 AS A
****   LEFT JOIN ZEA_MMT010 AS B ON A~MATNR EQ B~MATNR
****   LEFT JOIN ZEA_MMT020 AS C ON A~MATNR EQ C~MATNR
****                            AND C~SPRAS EQ SY-LANGU
******   LEFT JOIN ZEA_SDT090 AS D ON A~MATNR EQ D~MATNR
******   LEFT JOIN ZEA_MMT190 AS E ON A~MATNR EQ E~MATNR
****    INTO CORRESPONDING FIELDS OF TABLE GT_DATA2.
****
****  SORT GT_DATA2 BY VBELN POSNR DESCENDING.

  REFRESH GT_DISPLAY1.

*--------------------------------------------------------------------*

*  REFRESH GT_DISPLAY1.
*
*  IF ZEA_KNA1-CUSCODE IS INITIAL.
*
*    SELECT *
*      FROM ZEA_SDT040
*      INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY1.
*    SORT GT_DISPLAY1 BY VBELN.
*
*  ELSE.
*
*    SELECT *
*      FROM ZEA_SDT040
*      INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY1
*     WHERE CUSCODE EQ ZEA_KNA1-CUSCODE.
*    SORT GT_DISPLAY1 BY VBELN.
*
*  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_0100
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT_0100 .

  CREATE OBJECT GO_CONTAINER1
    EXPORTING
      CONTAINER_NAME = 'CCON'                " Name of the Screen CustCtrl Name to Link Container To
    EXCEPTIONS
      OTHERS         = 1.
  IF SY-SUBRC <> 0.
    MESSAGE E020. " Custom Container 생성 중 오류가 발생했습니다.
  ENDIF.

  CREATE OBJECT GO_ALV_GRID1
    EXPORTING
      I_PARENT = GO_CONTAINER1
    EXCEPTIONS
      OTHERS   = 1.

  IF SY-SUBRC NE 0.
    MESSAGE E021. " ALV Grid 생성 중 오류가 발생했습니다.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_0100
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV_0100 .

  CALL METHOD GO_ALV_GRID1->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
*     I_STRUCTURE_NAME              = 'ZEA_SDT040'
      IS_VARIANT                    = GS_VARIANT
      I_SAVE                        = GV_SAVE
      IS_LAYOUT                     = GS_LAYOUT
*     IT_TOOLBAR_EXCLUDING          = GT_TOOLBAR[]
    CHANGING
      IT_OUTTAB                     = GT_DISPLAY1
      IT_FIELDCATALOG               = GT_FIELDCAT
*     IT_SORT                       =
*     IT_FILTER                     =
    EXCEPTIONS
      INVALID_PARAMETER_COMBINATION = 1
      PROGRAM_ERROR                 = 2
      TOO_MANY_LINES                = 3
      OTHERS                        = 4.

  IF SY-SUBRC <> 0.
    " ALV Grid 에 데이터를 전달하는 중 오류가 발생했습니다.
    MESSAGE E023.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH_ALV_0100
*&---------------------------------------------------------------------*
FORM REFRESH_ALV_0100 .

  DATA LS_STABLE TYPE LVC_S_STBL.
  LS_STABLE-ROW = ABAP_ON.
  LS_STABLE-COL = ABAP_ON.

  CALL METHOD GO_ALV_GRID1->REFRESH_TABLE_DISPLAY
    EXPORTING
      IS_STABLE = LS_STABLE  " With Stable Rows/Columns
*     I_SOFT_REFRESH =           " Without Sort, Filter, etc.
    EXCEPTIONS
      FINISHED  = 1                " Display was Ended (by Export)
      OTHERS    = 2.

  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
      WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM DISPLAY_DATA .

  CHECK SY-UNAME EQ 'ACA5-03'
   OR SY-UNAME EQ 'ACA5-07'
   OR SY-UNAME EQ 'ACA5-08'
   OR SY-UNAME EQ 'ACA5-10'
   OR SY-UNAME EQ 'ACA5-12'
   OR SY-UNAME EQ 'ACA5-15'
   OR SY-UNAME EQ 'ACA5-17'
   OR SY-UNAME EQ 'ACA5-23'
   OR SY-UNAME EQ 'ACA-05'
   OR SY-UNAME EQ 'ACA9-05'
   OR SY-UNAME EQ 'ACA9-02'.


  CALL SCREEN '0100'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM MAKE_DISPLAY_DATA .

*SELECT SINGLE *
*  FROM ZEA_SDT040
*  INTO CORRESPONDING FIELDS OF GS_DISPLAY1.
** WHERE CUSCODE EQ GS_BPDATA-CUSCODE.
*
*IF ZEA_KNA1-CUSCODE IS INITIAL.
*
*  SELECT *
*    FROM ZEA_SDT040
*    INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY1
*   WHERE CUSCODE EQ ZEA_KNA1-CUSCODE.
*  ELSE.
*ENDIF.

*** ALV1 데이터 채우기

  REFRESH GT_DISPLAY1.

  LOOP AT GT_DATA1 INTO GS_DATA1.

    CLEAR GS_DISPLAY1.

    MOVE-CORRESPONDING GS_DATA1 TO GS_DISPLAY1.

*신규 필드------------------------------------------------------------*

*TOTAMT " 이거 아이템 테이블 전체 합산해서 넣어줘야함.
*STATUS " 상태테이블
*   1. 초록 : 아이템 테이블 작성 완료
*   2. 노랑 : 아이템 테이블 미작성.
*   3. 빨강 : 삭제/취소
*   4. 회색 : 완료된 건.
*IT_FIELD_COLORS " 셀별 색깔


*--------------------------------------------------------------------*
    APPEND GS_DISPLAY1 TO GT_DISPLAY1.

  ENDLOOP.
*--------------------------------------------------------------------*
  " Cell 단위 색상 테이블에 사용할 작업공간
  DATA: LS_CELL_COLOR LIKE LINE OF GS_DISPLAY1-CELL_COLOR.


*  REFRESH GT_DISPLAY.
*
*  LOOP AT GT_DATA INTO GS_DATA.
*    CLEAR GS_DISPLAY.
*    MOVE-CORRESPONDING GS_DATA TO GS_DISPLAY.
*
*    " 오늘과 같거나 이전이면 비행기는 출발
*    IF GS_DISPLAY-FLDATE LE SY-DATUM.
*      " 아이콘은 SE38 에서 SHOWICON 프로그램을 실행하면 확인가능
*      GS_DISPLAY-STATUS = ICON_OKAY.
*    ENDIF.
*
*
*    IF GS_DISPLAY-CANCELLED EQ ABAP_ON.
*      " 취소된 예약건이면 빨간색
*      GS_DISPLAY-LIGHT = '1'.
*    ELSE.
*      " 취소가 안된 예약건이면 초록색
*      GS_DISPLAY-LIGHT = '3'.
*    ENDIF.
*
*
*    " 흡연자일 경우
*    IF GS_DISPLAY-SMOKER EQ ABAP_ON.
*      CLEAR LS_CELL_COLOR.
*
*      " 흡연여부 필드에 주황색 배경(C710)으로 표시한다.
*      LS_CELL_COLOR-FNAME = 'SMOKER'.
*      LS_CELL_COLOR-COLOR-COL = 7.
*      LS_CELL_COLOR-COLOR-INT = 1.
*      LS_CELL_COLOR-COLOR-INV = 0.
*
*      INSERT LS_CELL_COLOR INTO TABLE GS_DISPLAY-CELL_COLOR.
*    ENDIF.
*
*
*    APPEND GS_DISPLAY TO GT_DISPLAY.
*  ENDLOOP.



***** ALV2 데이터 채우기
**
**    SELECT *
**      FROM ZEA_SDT050 AS A
**   LEFT JOIN ZEA_SDT090 AS D ON A~MATNR EQ D~MATNR
**   LEFT JOIN ZEA_MMT190 AS E ON A~MATNR EQ E~MATNR
**      INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY2
**     ORDER BY PRIMARY KEY.
**
**  REFRESH GT_DISPLAY2.
**
**  LOOP AT GT_DATA2 INTO GS_DATA2.
**
**    CLEAR GS_DISPLAY2.
**
**
**    MOVE-CORRESPONDING GS_DATA2 TO GS_DISPLAY2.
**
***신규 필드------------------------------------------------------------*
**
***TOTAMT " 이거 아이템 테이블 전체 합산해서 넣어줘야함.
***STATUS " 상태테이블
***   1. 초록 : 아이템 테이블 작성 완료
***   2. 노랑 : 아이템 테이블 미작성.
***   3. 빨강 : 삭제/취소
***   4. 회색 : 완료된 건.
***IT_FIELD_COLORS " 셀별 색깔
**
**
***--------------------------------------------------------------------*
**    APPEND GS_DISPLAY2 TO GT_DISPLAY2.
**
**  ENDLOOP.
**





ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_DATA_CONDITION
*&---------------------------------------------------------------------*
FORM SELECT_DATA_CONDITION .

  REFRESH GT_DISPLAY1.

  IF ZEA_KNA1-CUSCODE IS INITIAL.
    SELECT *
      FROM ZEA_SDT040
      INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY1.
  ELSE.
    SELECT *
      FROM ZEA_SDT040
      INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY1
     WHERE CUSCODE EQ ZEA_KNA1-CUSCODE.
  ENDIF.

  SORT GT_DISPLAY1 BY VBELN DESCENDING.


  DESCRIBE TABLE GT_DISPLAY1 LINES GV_LINES.
  IF GT_DISPLAY1 IS INITIAL.
    MESSAGE S033 .
*    DISPLAY LIKE 'I'.
  ELSEIF GT_DISPLAY1 IS INITIAL AND ZEA_KNA1-CUSCODE IS NOT INITIAL.
    MESSAGE S013 DISPLAY LIKE 'W'.
  ELSEIF GT_DISPLAY1 IS NOT INITIAL.
    MESSAGE S006 WITH GV_LINES.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Module INIT_DATA_0100 OUTPUT
*&---------------------------------------------------------------------*

MODULE INIT_DATA_0100 OUTPUT.

  CLEAR ZEA_KNA1.
  ZEA_KNA1-CUSCODE  = GS_BPDATA-CUSCODE.
  ZEA_KNA1-SAKNR    = GS_BPDATA-SAKNR.
  ZEA_KNA1-BPCUS    = GS_BPDATA-BPCUS.
  ZEA_KNA1-BPCSNR   = GS_BPDATA-BPCSNR.
  ZEA_KNA1-BPHAED   = GS_BPDATA-BPHAED.
  ZEA_KNA1-BPSTAT   = GS_BPDATA-BPSTAT.
  ZEA_KNA1-ZLSCH    = GS_BPDATA-ZLSCH.
  ZEA_KNA1-LAND1    = GS_BPDATA-LAND1.
  ZEA_KNA1-BPADRR   = GS_BPDATA-BPADRR.

*--------------------------------------------------------------------*
* 여신 신호등

  DATA: LS_KNKK TYPE ZEA_KNKK.

  SELECT SINGLE *
    FROM ZEA_KNKK
    INTO LS_KNKK
   WHERE CUSCODE EQ ZEA_KNA1-CUSCODE.

  CASE LS_KNKK-STATUS_K.
    WHEN 'G'.
      ICON = ICON_GREEN_LIGHT.
    WHEN 'Y'.
      ICON = ICON_YELLOW_LIGHT.
    WHEN 'R'.
      ICON = ICON_RED_LIGHT.
    WHEN OTHERS.
      ICON = ICON_LIGHT_OUT.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_0100_2
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT_0100_2 .

  CREATE OBJECT GO_CONTAINER2
    EXPORTING
      CONTAINER_NAME = 'CCON2'
    EXCEPTIONS
      OTHERS         = 1.

  IF SY-SUBRC <> 0.
    MESSAGE E020.
  ENDIF.

  CREATE OBJECT GO_ALV_GRID2
    EXPORTING
      I_PARENT = GO_CONTAINER2
    EXCEPTIONS
      OTHERS   = 1.

  IF SY-SUBRC NE 0.
    MESSAGE E021.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_0100_2
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV_0100_2 .

  CALL METHOD GO_ALV_GRID2->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
*     I_STRUCTURE_NAME              = 'ZEA_SDT050'                 " Internal Output Table Structure Name
      IS_VARIANT                    = GS_VARIANT2                 " Layout
      I_SAVE                        = GV_SAVE2               " Save Layout
      IS_LAYOUT                     = GS_LAYOUT                " Layout
    CHANGING
      IT_OUTTAB                     = GT_DISPLAY2                 " Output Table
      IT_FIELDCATALOG               = GT_FIELDCAT                 " Field Catalog
*     IT_SORT                       =                  " Sort Criteria
*     IT_FILTER                     =                  " Filter Criteria
    EXCEPTIONS
      INVALID_PARAMETER_COMBINATION = 1                " Wrong Parameter
      PROGRAM_ERROR                 = 2                " Program Errors
      TOO_MANY_LINES                = 3                " Too many Rows in Ready for Input Grid
      OTHERS                        = 4.
  IF SY-SUBRC <> 0.
    " ALV Grid 에 데이터를 전달하는 중 오류가 발생했습니다.
    MESSAGE E023.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_LAYOUT_0100_2
*&---------------------------------------------------------------------*
FORM SET_ALV_LAYOUT_0100_2 .

  CLEAR GS_LAYOUT.
  CLEAR GS_VARIANT.
  CLEAR GV_SAVE.

  GS_VARIANT2-REPORT = SY-REPID.
  GV_SAVE2 = 'A'.   " '' : Layout 저장불가
  " 'U' : 저장한 사용자만 사용가능
  " 'X' : Layout을 저장하면 모든 사용자가 사용 가능
  " 'A' : Layout을 저장할 때 'U'/'X' 선택 가능

*  GS_LAYOUT-CWIDTH_OPT = ABAP_ON.
  GS_LAYOUT-ZEBRA      = ABAP_ON.
  GS_LAYOUT-SEL_MODE   = 'D'.

*  GS_LAYOUT-GRID_TITLE = TEXT-T10.          " ALV TITLE TEXT
  GS_LAYOUT-INFO_FNAME = 'COLOR'.           " 행 색상
*  GS_LAYOUT-EXCP_FNAME = 'LIGHT'.           " 신호등
*  GS_LAYOUT-EXCP_LED = ABAP_ON.             " 신호등 모양 변경
*  GS_LAYOUT-CTAB_FNAME = 'IT_FIELD_COLORS'. " 셀 별 색상
  GS_LAYOUT-STYLEFNAME  = 'STYLE'.          " 스타일

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FIELDCAT_0100_2
*&---------------------------------------------------------------------*
FORM SET_ALV_FIELDCAT_0100_2 .

* 자재명 플랜트명 같은건 C500
* 수량은 C300
* 돈 관련은 노랑색

  REFRESH GT_FIELDCAT.

  CASE ABAP_ON.
    WHEN GS_FIELDCAT-KEY.
      GS_FIELDCAT-EDIT = ABAP_OFF.  " 키필드는 수정 불가능
    WHEN OTHERS.
      GS_FIELDCAT-EDIT = ABAP_ON.   " 이외 필드 수정 가능
  ENDCASE.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-COL_POS   = 0.
  GS_FIELDCAT-FIELDNAME = 'VBELN'.
  GS_FIELDCAT-COLTEXT   = '판매오더번호'.
  GS_FIELDCAT-KEY       = ABAP_ON.
  GS_FIELDCAT-NO_OUT    = ABAP_ON.
  GS_FIELDCAT-REF_TABLE = 'ZEA_SDT050'.
  GS_FIELDCAT-REF_FIELD = 'VBELN'.

*  GS_FIELDCAT-HOTSPOT    = ABAP_ON.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.


  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-COL_POS   = 1.
  GS_FIELDCAT-FIELDNAME = 'POSNR'.
  GS_FIELDCAT-COLTEXT    = TEXT-F01. " 문서 INDEX
  GS_FIELDCAT-KEY       = ABAP_ON.
  GS_FIELDCAT-OUTPUTLEN = 4.
*  GS_FIELDCAT-HOTSPOT    = ABAP_ON.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-COL_POS   = 2.
  GS_FIELDCAT-FIELDNAME = 'MATNR'.
  GS_FIELDCAT-COLTEXT    = TEXT-F02. " 자재코드
  GS_FIELDCAT-OUTPUTLEN = 8.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-COL_POS   = 3.
  GS_FIELDCAT-FIELDNAME = 'MAKTX'.
  GS_FIELDCAT-COLTEXT    = TEXT-F08. " 자재명
  GS_FIELDCAT-EMPHASIZE  = 'C500'.
  GS_FIELDCAT-OUTPUTLEN = 28.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-COL_POS   = 4.
  GS_FIELDCAT-FIELDNAME = 'CALQTY'.
  GS_FIELDCAT-COLTEXT    = TEXT-F09. " 재고 수량
  GS_FIELDCAT-REF_TABLE = 'ZEA_MMT190'.
  GS_FIELDCAT-EMPHASIZE  = 'C300'.
  GS_FIELDCAT-REF_FIELD = 'CALQTY'.
  GS_FIELDCAT-QFIELDNAME = 'MEINS'.
  GS_FIELDCAT-OUTPUTLEN = 7.

  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-COL_POS   = 5.
  GS_FIELDCAT-FIELDNAME = 'AUQUA'.
  GS_FIELDCAT-COLTEXT    = TEXT-F03. " 주문 수량
  GS_FIELDCAT-QFIELDNAME    = 'MEINS'.
  GS_FIELDCAT-EDIT      = ABAP_ON.
  GS_FIELDCAT-REF_TABLE = 'ZEA_SDT050'.
*  GS_FIELDCAT-EMPHASIZE  = 'C300'.
  GS_FIELDCAT-REF_FIELD = 'AUQUA'.
  GS_FIELDCAT-OUTPUTLEN = 7.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.  CLEAR GS_FIELDCAT.

  GS_FIELDCAT-COL_POS   = 6.
  GS_FIELDCAT-FIELDNAME = 'MEINS'.
  GS_FIELDCAT-COLTEXT    = TEXT-F04. " 단위
  GS_FIELDCAT-OUTPUTLEN = 3.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.  CLEAR GS_FIELDCAT.

  GS_FIELDCAT-COL_POS   = 7.
  GS_FIELDCAT-FIELDNAME = 'NETPR'.
  GS_FIELDCAT-COLTEXT    = TEXT-F05. " 판매단가
  GS_FIELDCAT-CFIELDNAME    = 'WAERS'.
  GS_FIELDCAT-REF_TABLE = 'ZEA_SDT050'.
  GS_FIELDCAT-REF_FIELD = 'NETPR'.
  GS_FIELDCAT-OUTPUTLEN = 7.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.  CLEAR GS_FIELDCAT.

  GS_FIELDCAT-COL_POS   = 8.
  GS_FIELDCAT-FIELDNAME = 'AUAMO'.
  GS_FIELDCAT-COLTEXT    = TEXT-F06. " 주문 금액
  GS_FIELDCAT-EMPHASIZE  = 'C311'.
  GS_FIELDCAT-CFIELDNAME    = 'WAERS'.
  GS_FIELDCAT-REF_TABLE = 'ZEA_SDT050'.
  GS_FIELDCAT-REF_FIELD = 'NETPR'.
  GS_FIELDCAT-OUTPUTLEN = 10.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.  CLEAR GS_FIELDCAT.

  GS_FIELDCAT-COL_POS   = 9.
  GS_FIELDCAT-FIELDNAME = 'WAERS'.
  GS_FIELDCAT-COLTEXT    = TEXT-F07. " 통화코드
  GS_FIELDCAT-OUTPUTLEN = 5.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SAVE_HEADER
*&---------------------------------------------------------------------*
FORM MAKE_DATA.

  DATA LV_SUBRC TYPE I.
  DATA LT_SDT040 TYPE TABLE OF ZEA_SDT040.
  DATA LS_SDT040 TYPE ZEA_SDT040.
  DATA LV_YEAR TYPE N LENGTH 4.

***  맨 처음에 입력필드 확인하기
  IF ZEA_SDT040-ODDAT IS INITIAL
  OR ( GS_RBGROUP-RA2 EQ ABAP_ON AND ZEA_SDT040-SADDR IS INITIAL )
  OR ZEA_SDT040-VDATU IS INITIAL.
    MESSAGE I000 DISPLAY LIKE 'E' WITH '값을 입력해주세요.'.
    EXIT.
*    GV_MODE1 = ABAP_OFF.
  ENDIF.

****** 판매오더번호 채번
***  CALL FUNCTION 'NUMBER_GET_NEXT' " 채번 과정
***    EXPORTING
***      NR_RANGE_NR             = '01'             " Number range number
***      OBJECT                  = 'ZEA_VBELN'      " Name of number range object
***    IMPORTING
***      NUMBER                  = ZEA_SDT040-VBELN  " free number
***    EXCEPTIONS
***      INTERVAL_NOT_FOUND      = 1                " Interval not found
***      NUMBER_RANGE_NOT_INTERN = 2                " Number range is not internal
***      OBJECT_NOT_FOUND        = 3                " Object not defined in TNRO
***      QUANTITY_IS_0           = 4                " Number of numbers requested must be > 0
***      QUANTITY_IS_NOT_1       = 5                " Number of numbers requested must be 1
***      INTERVAL_OVERFLOW       = 6                " Interval used up. Change not possible.
***      BUFFER_OVERFLOW         = 7                " Buffer is full
***      OTHERS                  = 8.
***  IF SY-SUBRC <> 0.
***    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
***      WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
***  ENDIF.
***
***  REPLACE FIRST OCCURRENCE OF '00' IN ZEA_SDT040-VBELN  WITH 'SB'.

*** 인터널 테이블에 데이터 넣기
  CLEAR GS_DISPLAY1.
  GS_DISPLAY1-VBELN = ZEA_SDT040-VBELN.
  GS_DISPLAY1-CUSCODE = ZEA_KNA1-CUSCODE. " 고객코드 -> 같은 테이블의 나머지 내용 같이
  IF GS_RBGROUP-RA1 = ABAP_ON.
    GS_DISPLAY1-SADDR = ZEA_KNA1-BPADRR.
  ELSEIF GS_RBGROUP-RA2 = ABAP_ON.
    GS_DISPLAY1-SADDR = ZEA_SDT040-SADDR.
  ENDIF.
  GS_DISPLAY1-VDATU = ZEA_SDT040-VDATU.
*  GS_DISPLAY1-ADATU = ZEA_SDT040-VDATU + 3 ." 예상납기일
  GS_DISPLAY1-ADATU = ZEA_SDT040-VDATU ." 예상납기일
  ZEA_SDT040-ADATU = ZEA_SDT040-VDATU ." 예상납기일
  GS_DISPLAY1-ODDAT = ZEA_SDT040-ODDAT.
*  *  GS_DISPLAY1-TOAMT = ZEA_SDT050-
*  GS_DISPLAY1-WAERS = ZEA_SDT040-WAERS.
  GS_DISPLAY1-WAERS = 'KRW'.
  GS_DISPLAY1-STATUS2 = ZEA_SDT040-STATUS2.
  GS_DISPLAY1-ERDAT = SY-DATUM. " 생성일자를 오늘로
  GS_DISPLAY1-ERZET = SY-UZEIT. " 생성시간을 현재 시간으로
  GS_DISPLAY1-ERNAM = SY-UNAME. " 생성자를 현재 로그인한 사용자ID
  APPEND GS_DISPLAY1 TO GT_DISPLAY1.

  PERFORM REFRESH_ALV_0100.

**  " 생성 관련 정보를 먼저 설정
**  ZEA_SDT040-ERDAT = SY-DATUM. " 생성일자를 오늘로
**  ZEA_SDT040-ERZET = SY-UZEIT. " 생성시간을 현재 시간으로
**  ZEA_SDT040-ERNAM = SY-UNAME. " 생성자를 현재 로그인한 사용자ID
**  ZEA_SDT040-CUSCODE = ZEA_KNA1-CUSCODE. " 고객코드 -> 같은 테이블의 나머지 내용 같이 들어감
**
**  IF GS_RBGROUP-RA1 = ABAP_ON.
**    ZEA_SDT040-SADDR = ZEA_KNA1-BPADRR.
**  ELSEIF GS_RBGROUP-RA2 = ABAP_ON.
**  ENDIF.
**
**  ZEA_SDT040-ADATU = ZEA_SDT040-VDATU + 3 ." 예상납기일
**
**  IF ZEA_SDT040-VBELN IS INITIAL.
**    MESSAGE E000 WITH 'CHECK KEY FIELD.'.
***    EXIT.
**  ELSEIF ZEA_SDT040-CUSCODE IS INITIAL.
**    MESSAGE E000 WITH 'CHECK KEY FIELD.'.
***    EXIT.
**  ENDIF.


*  INSERT ZEA_SDT040.
*
**  IF SY-SUBRC EQ 0.
**    COMMIT WORK AND WAIT.
**    MOVE-CORRESPONDING ZEA_SDT040 TO GS_DISPLAY1.
**    APPEND GS_DISPLAY1 TO GT_DISPLAY1.
**
**    SORT GT_DISPLAY1 BY VBELN.
**    MESSAGE S015.  " 데이터 성공적으로 저장되었습니다.
**    LEAVE TO SCREEN 0.
**  ELSE.
**    ROLLBACK WORK. " 데이터 저장 중 오류가 발생했습니다.
**    MESSAGE E016.
**  ENDIF.
*  IF SY-SUBRC NE 0.
*    LV_SUBRC = 4.
*    ROLLBACK WORK.
*  ENDIF.

*아이템 생성---------------------------------------------------------*

  DATA: LT_SDT050   TYPE TABLE OF ZEA_SDT050,
        LS_SDT050   TYPE ZEA_SDT050,

        LS_DISPLAY2 LIKE LINE OF GT_DATA2,
        LT_DISPLAY2 LIKE TABLE OF GT_DATA2,

        GS_UNIQUE   LIKE LINE OF GT_DATA2,
        GT_UNIQUE   LIKE TABLE OF GT_DATA2,
        LV_INDEX    TYPE SY-TABIX. " POSNR 설정위한 인덱스 변수 선언

  LV_INDEX = 0.

*        GS_PRICE    LIKE LINE OF GT_DATA2.


*** -> 재고테이블 변경전 (플랜트별로 재고나누어져있게 바뀜)
*** 완제품 24종 선택 -> 모든데이터 있는거 아니면 다 안나오는데 .. 맞나
  SELECT *
  FROM ZEA_MMT010 AS A                              " 자재
  LEFT JOIN ZEA_MMT020 AS B ON A~MATNR EQ B~MATNR   " 자재명
                           AND B~SPRAS EQ @SY-LANGU
  LEFT JOIN ZEA_SDT090 AS C ON A~MATNR EQ C~MATNR   " 가격
  LEFT JOIN ZEA_MMT190 AS D ON A~MATNR EQ D~MATNR   " 재고
  INTO CORRESPONDING FIELDS OF TABLE @GT_DATA2
  WHERE MATTYPE EQ '완제품'
    AND D~WERKS EQ '10001' " RDC만
    AND C~LOEKZ NE 'X'. " 삭제된 가격 제외



*  LOOP AT GT_DATA2 INTO GS_DATA2.
*    IF GS_DATA2-VALID_EN >= SY-DATUM AND ( GS_PRICE IS INITIAL OR GS_DATA2-VALID_EN < GS_PRICE-VALID_EN ).
*      GS_PRICE = GS_DATA2.
*    ENDIF.
*  ENDLOOP.


* 2. 가장 최신 날짜의 레코드 찾기
*    루프를 사용하여 각 MATNR에 대해 가장 최신의 VALID_EN 날짜를 가진 레코드를 선택합니다.
  SORT GT_DATA2 BY MATNR VALID_EN ASCENDING.

  LOOP AT GT_DATA2 INTO GS_DATA2.
    ON CHANGE OF GS_DATA2-MATNR.   " 자재별 가격 1개만 뜨도록 설정
      MOVE-CORRESPONDING GS_DATA2 TO GS_DISPLAY2.

      LV_INDEX = LV_INDEX + 1.

      GS_DISPLAY2-VBELN   = ZEA_SDT040-VBELN.
      GS_DISPLAY2-POSNR   = LV_INDEX * 10.
      GS_DISPLAY2-MEINS   = 'PKG'.
      GS_DISPLAY2-WAERS   = 'KRW'.
      GS_DISPLAY2-ERNAM   = SY-UNAME.
      GS_DISPLAY2-ERDAT   = SY-DATUM.
      GS_DISPLAY2-ERZET   = SY-UZEIT.

      APPEND GS_DISPLAY2 TO GT_DISPLAY2.
    ENDON.
  ENDLOOP.

**************  REFRESH GT_DISPLAY2.
**************
**************  LOOP AT GT_DATA2 INTO GS_DATA2.
**************
**************    CLEAR GS_DISPLAY2.
**************    MOVE-CORRESPONDING GS_DATA2 TO  GS_DISPLAY2.    " MATNR MAKTX
**************
**************
**************    GS_DISPLAY2-VBELN   = ZEA_SDT040-VBELN.
**************    GS_DISPLAY2-POSNR   = SY-TABIX * 10.
**************    GS_DISPLAY2-MEINS   = 'PKG'.
**************    GS_DISPLAY2-WAERS   = 'KRW'.
**************    GS_DISPLAY2-ERNAM   = SY-UNAME.
**************    GS_DISPLAY2-ERDAT   = SY-DATUM.
**************    GS_DISPLAY2-ERZET   = SY-UZEIT.
**************    APPEND GS_DISPLAY2 TO GT_DISPLAY2.
**************  ENDLOOP.


*--------------------------------------------------------------------*
****인덱스 생성
*  SELECT MAX( POSNR )
*    FROM ZEA_SDT050
*    INTO ZEA_SDT050-POSNR
*   WHERE VBELN EQ ZEA_SDT040-VBELN.
*
*  ZEA_SDT050-POSNR = ZEA_SDT050-POSNR + 10.
*  ZEA_SDT050-VBELN = ZEA_SDT040-VBELN.
*
*
**** 필드들
*  " 생성 관련 정보를 먼저 설정
*  ZEA_SDT050-ERDAT = SY-DATUM. " 생성일자를 오늘로
*  ZEA_SDT050-ERZET = SY-UZEIT. " 생성시간을 현재 시간으로
*  ZEA_SDT050-ERNAM = SY-UNAME. " 생성자를 현재 로그인한 사용자ID
*
*  MOVE-CORRESPONDING GS_DISPLAY2 TO LS_SDT050.
*
*  LS_SDT050-VBELN = ZEA_SDT040-VBELN.
*  LS_SDT050-POSNR = ZEA_SDT050-POSNR.
****
*  LS_SDT050-ERDAT = SY-DATUM.
*  LS_SDT050-ERNAM = SY-UNAME.
*  LS_SDT050-ERZET = SY-UZEIT.
*

*  INSERT ZEA_SDT050 FROM LS_SDT050.
*
*  IF LV_SUBRC EQ 0.
*    COMMIT WORK AND WAIT.
*    MESSAGE S015. "데이터가 성공적으로 저장되었습니다.
*  ELSE.
*    ROLLBACK WORK. " INSERT UPDATE DELETE 뒤에 DB TABLE
*    MESSAGE S016 DISPLAY LIKE 'E'. "데이터 저장 중 오류가 발생했습니다.
*  ENDIF.

  SORT GT_DISPLAY1 BY VBELN DESCENDING.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_DOUBLE_CLICK
*&---------------------------------------------------------------------*
FORM HANDLE_DOUBLE_CLICK  USING PS_ROW     TYPE LVC_S_ROW
                                PS_COL     TYPE  LVC_S_COL
                                PO_SENDER  TYPE REF TO CL_GUI_ALV_GRID.

  DATA: LV_MSG   TYPE STRING,
        LV_COUNT TYPE I.


  READ TABLE GT_DISPLAY1 INTO GS_DISPLAY1 INDEX PS_ROW-INDEX.

  " 더블클릭한 GO_ALV_GIRD1의 와 관련있는 정보만 취급하기 위해
  " 기존에 갖고 있던 데이터를 전부 지우고, 새롭게 데이터를 조회한다.
  CLEAR GS_BPDATA.

  SELECT COUNT(*)
    FROM ZEA_SDT040
   WHERE VBELN EQ ZEA_SDT040-VBELN.



  IF SY-SUBRC NE 0.
    _MC_POPUP_CONFIRM '오더 생성 취소'
      '저장하지 않은 오더는 삭제됩니다. 저장하겠습니까?' GV_ANSWER.
    CHECK GV_ANSWER = '1'.
    PERFORM SAVE_DATA.
    CHECK GV_ANSWER = '1'.
  ENDIF.



*** 조회모드로 변경한다.
  GV_MODE = GC_MODE_DISPLAY.



*** 고객정보
  SELECT SINGLE *
    FROM ZEA_KNA1
    INTO CORRESPONDING FIELDS OF GS_BPDATA
   WHERE CUSCODE EQ GS_DISPLAY1-CUSCODE.

*** 헤더 정보 가져오기
  CLEAR GS_DATA1.

  SELECT SINGLE *
    FROM ZEA_SDT040
    INTO CORRESPONDING FIELDS OF GS_DATA1
   WHERE VBELN EQ GS_DISPLAY1-VBELN.

  IF SY-SUBRC EQ 0.
    MOVE-CORRESPONDING GS_DATA1 TO ZEA_SDT040.
  ELSE.
    MOVE-CORRESPONDING GS_DISPLAY1 TO ZEA_SDT040.
  ENDIF.


  GV_PRESSEDTAB = 'TAB1'.
  GV_SUBSCREEN = '0110'.
  GO_TAB-%_SCROLLPOSITION  = 'TAB2'.
  " 더블클릭할 때 탭의 포지션이 자꾸 바뀌어서 그거 고정시켜줌.
  " 근데 계속 고정 탭스트립이 바뀔 필요가 없으니까 더블클릭 할때만 작동하게.


  CLEAR GS_RBGROUP.
  IF ZEA_SDT040-SADDR EQ ZEA_KNA1-BPADRR.
    GS_RBGROUP-RA1 = ABAP_ON.
  ELSE.
    GS_RBGROUP-RA2 = ABAP_ON.
  ENDIF.


*** 아이템 정보 가져오기.
  REFRESH GT_DISPLAY2.

  SELECT *
    FROM ZEA_SDT050 AS A LEFT JOIN ZEA_MMT020 AS B
                                ON A~MATNR EQ B~MATNR
    INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY2
   WHERE VBELN EQ GS_DISPLAY1-VBELN.

  IF SY-SUBRC EQ 0.
    SELECT A~MATNR, SUM( A~CALQTY ) AS CALQTY
      FROM ZEA_MMT190 AS A
      JOIN ZEA_SDT050 AS B ON A~MATNR EQ B~MATNR " 재고테이블
     WHERE B~VBELN EQ @GS_DISPLAY1-VBELN
     GROUP BY A~MATNR
      INTO TABLE @DATA(LT_MMT190).

    SORT LT_MMT190 BY MATNR.
  ENDIF.

  SORT GT_DISPLAY2 BY POSNR.

  LOOP AT GT_DISPLAY2 INTO GS_DISPLAY2.
    READ TABLE LT_MMT190 INTO DATA(LS_MMT190)
                         WITH KEY MATNR = GS_DISPLAY2-MATNR
                                  BINARY SEARCH.
    IF SY-SUBRC EQ 0.
      GS_DISPLAY2-CALQTY = LS_MMT190-CALQTY.
      MODIFY GT_DISPLAY2 FROM GS_DISPLAY2 TRANSPORTING CALQTY.
    ENDIF.
  ENDLOOP.


  DESCRIBE TABLE GT_DISPLAY2 LINES GV_LINES.
  IF GT_DISPLAY2 IS INITIAL.
    MESSAGE S013 DISPLAY LIKE 'W'.
  ELSE.
    MESSAGE S006 WITH GV_LINES.
  ENDIF.

  " GT_DATA2 의 데이터가 변경되었으므로,
  " 변경된 데이터를 ALV에 출력하기 위해 ALV를 새로고침 한다.
  CALL METHOD GO_ALV_GRID2->REFRESH_TABLE_DISPLAY
*    EXPORTING
*      IS_STABLE      =                  " With Stable Rows/Columns
*      I_SOFT_REFRESH =                  " Without Sort, Filter, etc.
    EXCEPTIONS
      FINISHED = 1                " Display was Ended (by Export)
      OTHERS   = 2.

  LEAVE SCREEN. " 스크린을 새로고침하는것.
  " NEXT DYNPRO 가 100이기때문에 100으로 돌아감.
  " 화면을 버린다 - 가 이것.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_EVENT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_EVENT_0100 .

  SET HANDLER LCL_EVENT_HANDLER=>ON_DOUBLE_CLICK FOR GO_ALV_GRID1.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_FIELDCAT_0100 .


  PERFORM GET_FIELDCAT2  USING    GT_DISPLAY1
                         CHANGING GT_FIELDCAT.
  PERFORM MAKE_FIELDCAT_0100.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_LAYOUT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_LAYOUT_0100 .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DATA_SAVE
*&---------------------------------------------------------------------*
FORM DATA_SAVE .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CONFIRM_SAVE
*&---------------------------------------------------------------------*
FORM CONFIRM_SAVE .

  LOOP AT GT_DISPLAY2 INTO GS_DISPLAY2.

    IF GS_DISPLAY2-AUQUA > GS_DISPLAY2-CALQTY.
      MESSAGE E040. " 재고수량을 초과하는 구매는 불가합니다.
      LEAVE TO SCREEN 0.
    ELSE.

    ENDIF.

  ENDLOOP.

**--- 저장 메시지 띄우기

  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      TITLEBAR       = '판매오더 저장'
      TEXT_QUESTION  = '저장하시겠습니까?'
      TEXT_BUTTON_1  = '저장'
      ICON_BUTTON_1  = '@2K@'
*     TEXT_BUTTON_2  = '나가기'
*     ICON_BUTTON_2  = 'ICON_EXIT'
      DEFAULT_BUTTON = '1'
*     DISPLAY_CANCEL = 'X'
    IMPORTING
      ANSWER         = GV_ANSWER.

  CASE GV_ANSWER.
    WHEN '1'. " 저장
      PERFORM SAVE_DATA.
*      MESSAGE S000 WITH '저장에 성공했습니다.'.
    WHEN '2'. " 나가기
*        LEAVE PROGRAM.
    WHEN OTHERS.
*        LEAVE PROGRAM.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SAVE_DATA
*&---------------------------------------------------------------------*
FORM SAVE_DATA .

  " GV_ANSWER 가 1일 때만 작동한다.
  " 저장 과정 중 오류가 발생하면 GV_ANSWER 를 E 로 변경한다.

*** 판매오더번호 채번
  CALL FUNCTION 'NUMBER_GET_NEXT' " 채번 과정
    EXPORTING
      NR_RANGE_NR             = '01'             " Number range number
      OBJECT                  = 'ZEA_VBELN'      " Name of number range object
    IMPORTING
      NUMBER                  = ZEA_SDT040-VBELN  " free number
    EXCEPTIONS
      INTERVAL_NOT_FOUND      = 1                " Interval not found
      NUMBER_RANGE_NOT_INTERN = 2                " Number range is not internal
      OBJECT_NOT_FOUND        = 3                " Object not defined in TNRO
      QUANTITY_IS_0           = 4                " Number of numbers requested must be > 0
      QUANTITY_IS_NOT_1       = 5                " Number of numbers requested must be 1
      INTERVAL_OVERFLOW       = 6                " Interval used up. Change not possible.
      BUFFER_OVERFLOW         = 7                " Buffer is full
      OTHERS                  = 8.
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
      WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  REPLACE FIRST OCCURRENCE OF '00' IN ZEA_SDT040-VBELN  WITH 'SB'.

*--------------------------------------------------------------------*

  GO_ALV_GRID2->CHECK_CHANGED_DATA( ).

  DATA: LS_SDT040 TYPE ZEA_SDT040,
        LT_SDT050 TYPE TABLE OF ZEA_SDT050,
        LS_SDT050 TYPE ZEA_SDT050.

  DATA: LS_DISPLAY1 LIKE GS_DISPLAY1,
        LV_INDEX    TYPE SY-TABIX. " POSNR 설정위한 인덱스 변수 선언

  LV_INDEX = 0.


***-- 아이템 데이터 저장
  LS_DISPLAY1-TOAMT = 0.
*  LS_DISPLAY1-VBELN = ZEA_SDT040-VBELN. " 판매오더 번호

  LOOP AT GT_DISPLAY2 INTO GS_DISPLAY2.
    GS_DISPLAY2-VBELN = ZEA_SDT040-VBELN.
    GS_DISPLAY2-AUAMO = GS_DISPLAY2-AUQUA * GS_DISPLAY2-NETPR. " 주문금액
    GS_DISPLAY2-WAERS = 'KRW'. "주문 통화
    MODIFY GT_DISPLAY2 FROM GS_DISPLAY2.

    IF GS_DISPLAY2-AUQUA <> 0. " 구매수량이 0이 아닌건만 저장
      CLEAR GS_DISPLAY2-POSNR.

      LV_INDEX = LV_INDEX + 1. " POSNR(인덱스 필드 저장)
      GS_DISPLAY2-POSNR   = LV_INDEX * 10.

      LS_DISPLAY1-TOAMT = LS_DISPLAY1-TOAMT + GS_DISPLAY2-AUAMO.
*     화면에 TOAMT 새로 업데이트하게.
      ZEA_SDT040-TOAMT = LS_DISPLAY1-TOAMT.
      ZEA_SDT040-WAERS = 'KRW'.

      MOVE-CORRESPONDING GS_DISPLAY2 TO LS_SDT050.
      APPEND LS_SDT050 TO LT_SDT050.
    ENDIF.
  ENDLOOP.

  INSERT ZEA_SDT050 FROM TABLE LT_SDT050.
  IF SY-SUBRC NE 0.
    ROLLBACK WORK.
    MESSAGE S000 DISPLAY LIKE 'E' WITH '데이터 저장 중 오류가 발생했습니다.'.
    GV_ANSWER = 'E'.
    EXIT.   " SAVE_DATA 를 중단한다.
  ENDIF.


***-- 헤더 데이터 저장
  MOVE-CORRESPONDING ZEA_SDT040 TO LS_SDT040.
  LS_SDT040-VBELN = ZEA_SDT040-VBELN.
  LS_SDT040-ERDAT = SY-DATUM.
  LS_SDT040-ERZET = SY-UZEIT.
  LS_SDT040-ERNAM = SY-UNAME.
*  ZEA_SDT040-ADATU = ZEA_SDT040-VDATU . " 예상납기일

  " 라디오 버튼을 회사주소로 선택한 경우 직접입력된 값이 아닌 회사주소로 헤더에 저장한다.
  IF GS_RBGROUP-RA1 EQ ABAP_ON.
    LS_SDT040-SADDR = ZEA_KNA1-BPADRR.
  ENDIF.
  MOVE-CORRESPONDING ZEA_KNA1 TO LS_SDT040. " 새로 생성

  INSERT ZEA_SDT040 FROM LS_SDT040.





  IF SY-SUBRC EQ 0.
    COMMIT WORK AND WAIT.
    MESSAGE S000 WITH '주문이 정상적으로 저장되었습니다.'.

    MODIFY GT_DISPLAY1 FROM LS_DISPLAY1
                       TRANSPORTING TOAMT
                       WHERE VBELN EQ ZEA_SDT040-VBELN.

    REFRESH GT_DISPLAY1.

    SELECT *
      FROM ZEA_SDT040
      INTO CORRESPONDING FIELDS OF TABLE GT_DISPLAY1
     WHERE CUSCODE EQ ZEA_KNA1-CUSCODE.
    SORT GT_DISPLAY1 BY VBELN DESCENDING.

GV_MODE = GC_MODE_SAVED. " 아이템 수정 못하게.

    PERFORM REFRESH_ALV_0100.
  ELSE.
    ROLLBACK WORK.
    MESSAGE S000 DISPLAY LIKE 'E' WITH '데이터 저장 중 오류가 발생했습니다.'.
    GV_ANSWER = 'E'.
    EXIT.   " SAVE_DATA 를 중단한다.
  ENDIF.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH_ALV_0100_2
*&---------------------------------------------------------------------*
FORM REFRESH_ALV_0100_2 .

  DATA LS_STABLE TYPE LVC_S_STBL.
  LS_STABLE-ROW = ABAP_ON.
  LS_STABLE-COL = ABAP_ON.

  CALL METHOD GO_ALV_GRID2->REFRESH_TABLE_DISPLAY
    EXPORTING
      IS_STABLE = LS_STABLE  " With Stable Rows/Columns
*     I_SOFT_REFRESH =           " Without Sort, Filter, etc.
    EXCEPTIONS
      FINISHED  = 1                " Display was Ended (by Export)
      OTHERS    = 2.

  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
      WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_EVENT_0100_2
*&---------------------------------------------------------------------*
FORM SET_ALV_EVENT_0100_2 .

*  CALL METHOD GO_ALV_GRID2->SET_READY_FOR_INPUT
*    EXPORTING
*      I_READY_FOR_INPUT = 1.

  CALL METHOD GO_ALV_GRID2->REGISTER_EDIT_EVENT  " EDIT 이벤트 등록
    EXPORTING
      I_EVENT_ID = CL_GUI_ALV_GRID=>MC_EVT_MODIFIED " Event ID
    EXCEPTIONS
      ERROR      = 1                " Error
      OTHERS     = 2.

SET HANDLER LCL_EVENT_HANDLER=>ON_TOOLBAR FOR GO_ALV_GRID2.

  SET HANDLER LCL_EVENT_HANDLER=>ON_USER_COMMAND FOR GO_ALV_GRID2.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form MODIFY_SCREEN_DISPLAY
*&---------------------------------------------------------------------*
FORM MODIFY_SCREEN_DISPLAY .

  CHECK GO_ALV_GRID2 IS BOUND
    AND GO_ALV_GRID2->IS_READY_FOR_INPUT( ) EQ 1.

  GO_ALV_GRID2->SET_READY_FOR_INPUT( 0 ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MODIFY_SCREEN_CREATE_0100
*&---------------------------------------------------------------------*
FORM MODIFY_SCREEN_CREATE_0100.

  LOOP AT SCREEN.
    IF SCREEN-NAME EQ 'TAB1'.
      SCREEN-ACTIVE = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MODIFY_SCREEN_CREATE_ITEM_0100
*&---------------------------------------------------------------------*
FORM MODIFY_SCREEN_CREATE_ITEM_0100 .

  IF GO_ALV_GRID2 IS BOUND AND GO_ALV_GRID2->IS_READY_FOR_INPUT( ) EQ 0.
    GO_ALV_GRID2->SET_READY_FOR_INPUT( 1 ).
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_FIELDCAT2
*&---------------------------------------------------------------------*
FORM GET_FIELDCAT2  USING    PT_TAB  TYPE STANDARD TABLE
                    CHANGING PT_FCAT TYPE LVC_T_FCAT.

  DATA: LO_DREF TYPE REF TO DATA.

  CREATE DATA LO_DREF LIKE PT_TAB.
  FIELD-SYMBOLS <LT_TAB> TYPE TABLE.
  ASSIGN LO_DREF->* TO <LT_TAB>.

  TRY.
      CALL METHOD CL_SALV_TABLE=>FACTORY
        IMPORTING
          R_SALV_TABLE = DATA(LR_TABLE)
        CHANGING
          T_TABLE      = <LT_TAB>.

    CATCH CX_SALV_MSG. " ALV: General Error Class with Message
  ENDTRY.

  PT_FCAT = CL_SALV_CONTROLLER_METADATA=>GET_LVC_FIELDCATALOG(
              R_COLUMNS      = LR_TABLE->GET_COLUMNS( )
              R_AGGREGATIONS = LR_TABLE->GET_AGGREGATIONS( )
            ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM MAKE_FIELDCAT_0100 .

  LOOP AT GT_FIELDCAT INTO GS_FIELDCAT.



    CASE GS_FIELDCAT-FIELDNAME.
      WHEN 'VBELN'.
        GS_FIELDCAT-KEY   = ABAP_ON.
        GS_FIELDCAT-OUTPUTLEN = 8.

      WHEN 'SADDR'.
*        GS_FIELDCAT-NO_OUT  = ABAP_ON.
        GS_FIELDCAT-OUTPUTLEN = 25.

      WHEN 'ODDAT'.
        GS_FIELDCAT-COL_POS   = 3.


    ENDCASE.


    MODIFY GT_FIELDCAT FROM GS_FIELDCAT.
  ENDLOOP.

*        VBELN   TYPE ZEA_SDT040-VBELN,
*        CUSCODE TYPE ZEA_SDT040-CUSCODE,
*        SADDR   TYPE ZEA_SDT040-SADDR,
*        VDATU   TYPE ZEA_SDT040-VDATU,
*        ADATU   TYPE ZEA_SDT040-ADATU,
*        ODDAT   TYPE ZEA_SDT040-ODDAT,
*        TOAMT   TYPE ZEA_SDT040-TOAMT,
*        WAERS   TYPE ZEA_SDT040-WAERS,
*        STATUS2  TYPE ZEA_SDT040-STATUS,
*        ERNAM   TYPE ZEA_SDT040-ERNAM,
*        ERDAT   TYPE ZEA_SDT040-ERDAT,
*        ERZET   TYPE ZEA_SDT040-ERZET,
*        AENAM   TYPE ZEA_SDT040-AENAM,
*        AEDAT   TYPE ZEA_SDT040-AEDAT,
*        AEZET   TYPE ZEA_SDT040-AEZET,

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MODIFY_SCREEN_SAVED_0100
*&---------------------------------------------------------------------*
FORM MODIFY_SCREEN_SAVED_0100 .

    IF GO_ALV_GRID2 IS BOUND AND GO_ALV_GRID2->IS_READY_FOR_INPUT( ) EQ 0.
    GO_ALV_GRID2->SET_READY_FOR_INPUT( 0 ).
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_BUTTON_CLICK
*&---------------------------------------------------------------------*
FORM HANDLE_BUTTON_CLICK  USING    P_ES_ROW_NO
                                   P_ES_COL_ID
                                   P_SENDER.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLER_TOOLBAR
*&---------------------------------------------------------------------*
FORM HANDLER_TOOLBAR  USING PO_OBJECT TYPE REF TO CL_ALV_EVENT_TOOLBAR_SET
                            PO_SENDER TYPE REF TO CL_GUI_ALV_GRID.


  " Internal Table PO_OBJECT->MT_TOOLBAR 를 위한 작업공간
  " PO_OBJECT->MT_TOOLBAR >>> 클래스의 Attribute ( Public , Instance )
  DATA LS_TOOLBAR LIKE LINE OF PO_OBJECT->MT_TOOLBAR.

 CASE PO_SENDER.
    WHEN GO_ALV_GRID2.

      DATA LV_GASO TYPE I.
      DATA LV_ELEC TYPE I.

      DESCRIBE TABLE GT_DISPLAY2.

      LOOP AT GT_DISPLAY2 INTO GS_DISPLAY2.

        IF GS_DISPLAY2-MATNR BETWEEN 30000000 AND 30000005 .
          ADD 1 TO LV_GASO.
        ELSEIF GS_DISPLAY2-MATNR BETWEEN 30000012 AND 30000017.
            ADD 1 TO LV_GASO.
        ELSE.
            ADD 1 TO LV_ELEC.
        ENDIF.

      ENDLOOP.

* 구분자 =>> |
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-BUTN_TYPE = 3. " 구분자
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 전체조회
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-FUNCTION = GC_NO_FILTER.
      LS_TOOLBAR-TEXT = | 전체조회 : { SY-TFILL } |.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 가솔린
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-FUNCTION = GC_GASOLINE.
      LS_TOOLBAR-ICON = ICON_CAR.
*      LS_TOOLBAR-TEXT = | 가솔린 : { LV_GREEN }  |.
      LS_TOOLBAR-TEXT = | 가솔린 : { LV_GASO }  |.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

* 버튼 추가 =>> 전기차
      CLEAR LS_TOOLBAR.
      LS_TOOLBAR-FUNCTION = GC_ELECTRIC.
      LS_TOOLBAR-ICON = ICON_CAR.
*      LS_TOOLBAR-TEXT = | 전기차 : { LV_YELLOW }  |.
      LS_TOOLBAR-TEXT = | 전기차 : { LV_ELEC }  |.
      APPEND LS_TOOLBAR TO PO_OBJECT->MT_TOOLBAR.

  ENDCASE.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_USER_COMMAND
*&---------------------------------------------------------------------*
FORM HANDLE_USER_COMMAND  USING PV_UCOMM TYPE SY-UCOMM
                                PO_SENDER  TYPE REF TO CL_GUI_ALV_GRID.
  CASE PO_SENDER.
    WHEN GO_ALV_GRID2. "PO_SENDER 가 GO_ALV_GRID 일 때
      CASE PV_UCOMM.  " 선택한 버튼 (PV_UCOMM은 SY-UCOMM 타입)

        WHEN GC_NO_FILTER.
          PERFORM NO_FILTER.

        WHEN GC_GASOLINE.
          PERFORM GASOLINE_FILTER.

        WHEN GC_ELECTRIC.
          PERFORM ELECTRIC_FILTER.

      ENDCASE.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form NO_FILTER
*&---------------------------------------------------------------------*
FORM NO_FILTER .

    REFRESH GT_FILTER.

  PERFORM SET_ALV_FILTER.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FILTER
*&---------------------------------------------------------------------*
FORM SET_ALV_FILTER .

  " ALV에 Filter 정보를 적용하는 과정
  CALL METHOD GO_ALV_GRID2->SET_FILTER_CRITERIA
    EXPORTING
      IT_FILTER = GT_FILTER                " Filter Conditions
    EXCEPTIONS
      OTHERS    = 1.

  IF SY-SUBRC NE 0.
    MESSAGE E000 WITH '필터 적용에 실패하였습니다'.
  ENDIF.

  " ALV가 새로고침될 때, 현재 라인, 열을 유지할 지
  DATA LS_STABLE TYPE LVC_S_STBL.
  LS_STABLE-ROW = ABAP_ON.
  LS_STABLE-COL = ABAP_ON.

  " 적용된 Filter 기준으로 데이터를 출력
  CALL METHOD GO_ALV_GRID2->REFRESH_TABLE_DISPLAY
    EXPORTING
      IS_STABLE = LS_STABLE                  " With Stable Rows/Columns
*     I_SOFT_REFRESH =                  " Without Sort, Filter, etc.
    EXCEPTIONS
      OTHERS    = 1.

  IF SY-SUBRC NE 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
      WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GASOLINE_FILTER
*&---------------------------------------------------------------------*
FORM GASOLINE_FILTER .

  REFRESH GT_FILTER.

  CLEAR GS_FILTER.
  GS_FILTER-FIELDNAME = 'MATNR'.
  GS_FILTER-SIGN      = 'I'.
  GS_FILTER-OPTION    = 'BT'.
  GS_FILTER-LOW       = '30000000'.
  GS_FILTER-HIGH       = '30000005'.
  APPEND GS_FILTER TO GT_FILTER.

  CLEAR GS_FILTER.
  GS_FILTER-FIELDNAME = 'MATNR'.
  GS_FILTER-SIGN      = 'I'.
  GS_FILTER-OPTION    = 'BT'.
  GS_FILTER-LOW       = '30000012'.
  GS_FILTER-HIGH       = '30000017'.
  APPEND GS_FILTER TO GT_FILTER.

  PERFORM SET_ALV_FILTER.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form ELECTRIC_FILTER
*&---------------------------------------------------------------------*
FORM ELECTRIC_FILTER .

  REFRESH GT_FILTER.

  CLEAR GS_FILTER.
  GS_FILTER-FIELDNAME = 'MATNR'.
  GS_FILTER-SIGN      = 'I'.
  GS_FILTER-OPTION    = 'BT'.
  GS_FILTER-LOW       = '30000006'.
  GS_FILTER-HIGH       = '30000011'.
  APPEND GS_FILTER TO GT_FILTER.

  CLEAR GS_FILTER.
  GS_FILTER-FIELDNAME = 'MATNR'.
  GS_FILTER-SIGN      = 'I'.
  GS_FILTER-OPTION    = 'BT'.
  GS_FILTER-LOW       = '30000018'.
  GS_FILTER-HIGH      = '30000023'.
  APPEND GS_FILTER TO GT_FILTER.

  PERFORM SET_ALV_FILTER.
ENDFORM.
