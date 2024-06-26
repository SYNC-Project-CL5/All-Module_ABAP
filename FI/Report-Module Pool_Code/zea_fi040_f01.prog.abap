*&---------------------------------------------------------------------*
*& Include          YE00_EX001_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form SELECT_DATA
*&---------------------------------------------------------------------*
FORM SELECT_DATA .

  " BPCODE에 GL코드가 1개이상 매핑된 경우
  SELECT C~INDI_CD      " 차/대변 구분자
         A~BUDAT        " 전기일자
         SUM( B~DMBTR ) " 통화금액 합계
         B~BPCODE
    FROM ZEA_BKPF AS A
    JOIN ZEA_BSEG AS B ON B~BUKRS EQ A~BUKRS
                      AND B~BELNR EQ A~BELNR
    JOIN ZEA_TBSL AS C ON C~BSCHL EQ B~BSCHL
    JOIN ZEA_SKB1 AS D ON D~BUKRS EQ A~BUKRS
                      AND D~SAKNR EQ B~SAKNR
    INTO TABLE GT_DATA
   WHERE B~SAKNR IN SO_SAKNR  " G/L코드
     AND A~BUKRS EQ PA_BUKRS  " 회사코드
     AND A~GJAHR EQ PA_GJAHR  " 회계연도
     AND B~BPCODE EQ D~BPCODE
   GROUP BY C~INDI_CD A~BUDAT B~BPCODE " <== GROUP BY는 위 SELECT LIST 순서대로 적어줘야함.
    ORDER BY A~BUDAT.


  " BPCODE에 매핑된 GL코드가 없는 경우
  IF GT_DATA[] IS INITIAL.
    CLEAR: GT_DATA[].
    SELECT C~INDI_CD      " 차/대변 구분자
         A~BUDAT        " 전기일자
         SUM( B~DMBTR ) " 통화금액 합계
    FROM ZEA_BKPF AS A
    JOIN ZEA_BSEG AS B ON B~BUKRS EQ A~BUKRS
                      AND B~BELNR EQ A~BELNR
    JOIN ZEA_TBSL AS C ON C~BSCHL EQ B~BSCHL
    INTO TABLE GT_DATA
   WHERE B~SAKNR IN SO_SAKNR  " G/L코드
     AND A~BUKRS EQ PA_BUKRS  " 회사코드
     AND A~GJAHR EQ PA_GJAHR  " 회계연도
   GROUP BY C~INDI_CD A~BUDAT B~BPCODE " <== GROUP BY는 위 SELECT LIST 순서대로 적어줘야함.
    ORDER BY A~BUDAT.
  ENDIF.

*  SELECT *
*    FROM ZEA_BKPF AS A
*    JOIN ZEA_BSEG AS B ON B~BUKRS EQ A~BUKRS
*                      AND B~BELNR EQ A~BELNR
*    JOIN ZEA_TBSL AS C ON C~BSCHL EQ B~BSCHL
*    JOIN ZEA_SKB1 AS D ON D~BUKRS EQ A~BUKRS
*                      AND D~SAKNR EQ B~SAKNR
*    INTO CORRESPONDING FIELDS OF TABLE GT_ALL
*    WHERE B~SAKNR  IN SO_SAKNR  " G/L코드
*     AND A~BUKRS   EQ PA_BUKRS  " 회사코드
*     AND A~GJAHR   EQ PA_GJAHR  " 회계연도
*     AND A~BUDAT   LIKE LV_COND                             " '202403%'
*     AND C~INDI_CD EQ LV_INDI  " 차변/대변 (S/H)
*     AND D~BPCODE  EQ B~BPCODE.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form MODIFY_DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM MODIFY_DISPLAY_DATA .
* -- 차/대변 합계 및 합계 차액 구하기

  REFRESH GT_DISP.

  DO 12 TIMES. " 월 데이터 넣음
    CLEAR GS_DISP.
    GS_DISP-MONTH = SY-INDEX.
    APPEND GS_DISP TO GT_DISP.
  ENDDO.


  LOOP AT GT_DATA INTO GS_DATA.
    CLEAR GS_DISP.
    GS_DISP-MONTH = GS_DATA-BUDAT+4(2).

    CASE GS_DATA-INDI_CD.
      WHEN 'S'.
*        GS_DISP-DMBTR_S = ( GS_DATA-DMBTR ) * 100.
        GS_DISP-DMBTR_S = GS_DATA-DMBTR .
      WHEN 'H'.
*        GS_DISP-DMBTR_H = ( GS_DATA-DMBTR ) * 100.
        GS_DISP-DMBTR_H =  GS_DATA-DMBTR .
    ENDCASE.

    COLLECT GS_DISP INTO GT_DISP.
  ENDLOOP.

  LOOP AT GT_DISP INTO GS_DISP.
    GS_DISP-DMBTR_DIF = GS_DISP-DMBTR_S - GS_DISP-DMBTR_H.
    MODIFY GT_DISP FROM GS_DISP.
  ENDLOOP.


**
**  DATA: LT_STRINGS TYPE STANDARD TABLE OF STRING,
**        LS_STRING  TYPE STRING.
**
**  APPEND '01' TO LT_STRINGS.
**  APPEND '02' TO LT_STRINGS.
**  APPEND '03' TO LT_STRINGS.
**  APPEND '04' TO LT_STRINGS.
**  APPEND '05' TO LT_STRINGS.
**  APPEND '06' TO LT_STRINGS.
**  APPEND '07' TO LT_STRINGS.
**  APPEND '08' TO LT_STRINGS.
**  APPEND '09' TO LT_STRINGS.
**  APPEND '10' TO LT_STRINGS.
**  APPEND '11' TO LT_STRINGS.
**  APPEND '12' TO LT_STRINGS.
**
**
**  LOOP AT LT_STRINGS INTO LS_STRING.
**
**    CLEAR GS_DISP.
**    GS_DISP-MONTH = LS_STRING.
**    LOOP AT GT_DATA INTO GS_DATA.
**      CASE GS_DATA-BUDAT+4(2).
**        WHEN LS_STRING.
**
**          CASE GS_DATA-INDI_CD.
**            WHEN 'S'. " 차변
**              ADD GS_DATA-DMBTR TO GS_DISP-DMBTR_S.
**
**            WHEN 'H'. " 대변
**              " 차변 - 대변 ( + : 차변 , - : 대변 )
**              GS_DISP-DMBTR_H = GS_DISP-DMBTR_H + GS_DATA-DMBTR.
**
**          ENDCASE.
**      ENDCASE.
**    ENDLOOP.
**
**    " 차변 - 대변
**    GS_DISP-DMBTR_DIF = GS_DISP-DMBTR_S - GS_DISP-DMBTR_H.
**    APPEND GS_DISP TO GT_DISP.
**
**  ENDLOOP.
***

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM DISPLAY_DATA .


  " [] 는 인터널 테이블에 담겨있는 내용을 의미, 즉 쌓여있는 데이터
  IF GT_DISP[] IS INITIAL. " => 한 줄도 없는지 검사
    MESSAGE E013. " E013: 해당 조건의 데이터가 존재하지 않습니다.
  ELSE.
    CALL SCREEN 0100.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_0100
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT_0100 .

  CREATE OBJECT GO_CONTAINER
    EXPORTING
      CONTAINER_NAME = 'CCON'
    EXCEPTIONS
      OTHERS         = 1.
  IF SY-SUBRC <> 0.

  ENDIF.

  CREATE OBJECT GO_SPLIT
    EXPORTING
      PARENT  = GO_CONTAINER                   " Parent Container
      ROWS    = 1                   " Number of Rows to be displayed
      COLUMNS = 2                  " Number of Columns to be Displayed
    EXCEPTIONS
      OTHERS  = 1.
  IF SY-SUBRC <> 0.
    MESSAGE E120. " 분리 컨테이너 생성에 실패했습니다.
  ENDIF.

  " CLASSIC 한 메소드 호출방법 (방법 1)
  " RECEIVING 파라미터는 항상 CALL BY VALUE로만 전달이 가능하다.
  " 값은 '=' 를 이용해서 한 개만 전달하기 때문에.
  CALL METHOD GO_SPLIT->GET_CONTAINER
    EXPORTING
      ROW       = 1
      COLUMN    = 1 " 1번째 칸
    RECEIVING " 값을 왼쪽으로 전달
      CONTAINER = GO_CON_LEFT.
*
  " 신문법 중 하나 (방법 2)
  GO_CON_RIGHT = GO_SPLIT->GET_CONTAINER( ROW = 1 COLUMN = 2 ). " 2번째 칸

* ALV 생성
  " TOP 에 ALV 생성
  CREATE OBJECT GO_ALV_GRID_LEFT
    EXPORTING
      I_PARENT = GO_CON_LEFT
    EXCEPTIONS
      OTHERS   = 1.
  IF SY-SUBRC <> 0.
    MESSAGE E020.
  ENDIF.

  CALL METHOD GO_SPLIT->SET_COLUMN_WIDTH
    EXPORTING
      ID    = 1                " Column ID
      WIDTH = 30                 " NPlWidth
*    IMPORTING
*     RESULT            =                  " Result Code
*    EXCEPTIONS
*     CNTL_ERROR        = 1                " See CL_GUI_CONTROL
*     CNTL_SYSTEM_ERROR = 2                " See CL_GUI_CONTROL
*     OTHERS            = 3
    .
  IF SY-SUBRC <> 0.
  ENDIF.

  CREATE OBJECT GO_ALV_GRID_RIGHT
    EXPORTING
      I_PARENT = GO_CON_RIGHT
    EXCEPTIONS
      OTHERS   = 1.
  IF SY-SUBRC <> 0.
    MESSAGE E020.
  ENDIF.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_LAYOUT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_LAYOUT_0100 .

  CLEAR GS_LAYOUT.

  GS_LAYOUT-ZEBRA       = 'X'.  " 얼룩처리
  GS_LAYOUT-SEL_MODE    = 'D'.  " 셀단위로 선택
  GS_LAYOUT-CWIDTH_OPT  = 'X'.  " 열넓이 최적화
*  GS_LAYOUT-CWIDTH_OPT  = 'A'.  " ALV가 REFRESH 될때마다 열 넓이를 최적화

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_0100
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV_0100 .

  CLEAR GS_VARIANT.
  GS_VARIANT-REPORT = SY-REPID. " 현재 프로그램 이름을 전달.
  GV_SAVE = 'A'. " 개인용/공용 모두 생성 가능하도록 설정

  CALL METHOD GO_ALV_GRID_LEFT->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
*     I_STRUCTURE_NAME = 'ZEA_BSEG'     " Internal Output Table Structure Name
      IS_VARIANT      = GS_VARIANT  " Layout
      I_SAVE          = GV_SAVE     " Save Layout
      IS_LAYOUT       = GS_LAYOUT   " Layout
    CHANGING
      IT_OUTTAB       = GT_DISP     " Output Table
      IT_FIELDCATALOG = GT_FIELDCAT           " Field Catalog
    EXCEPTIONS
      OTHERS          = 1.

  IF SY-SUBRC <> 0.
    MESSAGE E021. " ALV Grid 생성 중 오류가 발생했습니다.
  ENDIF.

  GS_VARIANT-HANDLE = 'AVL2'. " 동일한 프로그램 내에서 Variant 를 구별하기 위한 값

  CALL METHOD GO_ALV_GRID_RIGHT->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
      I_STRUCTURE_NAME = 'ZEA_BSEG'     " Internal Output Table Structure Name
      IS_VARIANT       = GS_VARIANT  " Layout
      I_SAVE           = GV_SAVE     " Save Layout
      IS_LAYOUT        = GS_LAYOUT   " Layout
    CHANGING
      IT_OUTTAB        = GT_ALL     " Output Table
      IT_FIELDCATALOG  = GT_FIELDCAT_ALL " Field Catalog
    EXCEPTIONS
      OTHERS           = 1.

  IF SY-SUBRC <> 0.
    MESSAGE E021. " ALV Grid 생성 중 오류가 발생했습니다.
  ENDIF.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_DOUBLE_CLICK
*&---------------------------------------------------------------------*
*& PS : Parameter Structure, 전달되는 변수의 종류가 스트럭처 변수다.
*& PO : Parameter Object, 전달되는 변수의 종류가 참조변수 다.
*& PV : Parameter Value, 전달되는 변수의 값이 문자, 정수, 실수, 날짜, 시간 같은 Elementary Type 이다.
*& PT : Parameter Table, 전달되는 변수의 종류가 Internal Table이다.
*&---------------------------------------------------------------------*
FORM HANDLE_DOUBLE_CLICK  USING    PS_COLUMN TYPE LVC_S_COL
                                   PS_ROW    TYPE LVC_S_ROW
                                   PO_SENDER TYPE REF TO CL_GUI_ALV_GRID.


  CASE PO_SENDER.
    WHEN GO_ALV_GRID_LEFT.

* --  선택한 행이 인터널테이블에 있는 정상적인 데이터인지 체크
      IF PS_ROW-ROWTYPE IS NOT INITIAL.
        MESSAGE E121. " 월 별 데이터를 선택해주세요.
      ENDIF.

      CHECK PS_ROW-ROWTYPE IS INITIAL.

      DATA LV_COND TYPE STRING.
      DATA LV_MON  TYPE NUMC2.
      DATA LV_INDI TYPE C.

      " PS_ROW-INDEX = INDEX로 월별을 알 수 있다.
      READ TABLE GT_DISP INTO GS_DISP INDEX PS_ROW-INDEX.


      LV_MON  = PS_ROW-INDEX. " 1 => 01 2 => 02
      LV_COND = |{ PA_GJAHR }{ LV_MON }%|.                  " 202402%
      LV_COND = PA_GJAHR && LV_MON && '%'.
      CONCATENATE PA_GJAHR
                  LV_MON
                  '%'
             INTO LV_COND.


      CASE PS_COLUMN-FIELDNAME. " 필드명으로 차변/대변 구분
        WHEN 'DMBTR_S'. " 차변이면, S만 실행
          LV_INDI = 'S'.
        WHEN 'DMBTR_H'. " 대변이면, H 만 실행
          LV_INDI = 'H'.
      ENDCASE.


      SELECT *
        FROM ZEA_BKPF AS A
        JOIN ZEA_BSEG AS B ON B~BUKRS EQ A~BUKRS
                          AND B~BELNR EQ A~BELNR
        JOIN ZEA_TBSL AS C ON C~BSCHL EQ B~BSCHL
        JOIN ZEA_SKB1 AS D ON D~BUKRS EQ A~BUKRS
                          AND D~SAKNR EQ B~SAKNR
        INTO CORRESPONDING FIELDS OF TABLE GT_ALL
        WHERE B~SAKNR  IN SO_SAKNR  " G/L코드
         AND A~BUKRS   EQ PA_BUKRS  " 회사코드
         AND A~GJAHR   EQ PA_GJAHR  " 회계연도
         AND A~BUDAT   LIKE LV_COND                         " '202403%'
         AND C~INDI_CD EQ LV_INDI  " 차변/대변 (S/H)
         AND D~BPCODE  EQ B~BPCODE.


      IF GT_ALL[] IS INITIAL.
        SELECT *
          FROM ZEA_BKPF AS A
          JOIN ZEA_BSEG AS B ON B~BUKRS EQ A~BUKRS
                            AND B~BELNR EQ A~BELNR
          JOIN ZEA_TBSL AS C ON C~BSCHL EQ B~BSCHL
          INTO CORRESPONDING FIELDS OF TABLE GT_ALL
          WHERE B~SAKNR  IN SO_SAKNR  " G/L코드
           AND A~BUKRS   EQ PA_BUKRS  " 회사코드
           AND A~GJAHR   EQ PA_GJAHR  " 회계연도
           AND A~BUDAT   LIKE LV_COND                       " '202403%'
           AND C~INDI_CD EQ LV_INDI.  " 차변/대변 (S/H)
      ENDIF.

      DESCRIBE TABLE GT_ALL.
      MESSAGE S006 WITH SY-TFILL. " & 건의 데이터가 검색되었습니다.

      PERFORM REFRESH_ALV_0100.

    WHEN GO_ALV_GRID_RIGHT.
      CLEAR: GS_ALL.
      READ TABLE GT_ALL INTO GS_ALL INDEX PS_ROW-INDEX.

      SET PARAMETER ID 'ZEA_BELNR' FIELD GS_ALL-BELNR.
      CALL TRANSACTION 'ZEA_FI020'.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_EVENT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_EVENT_0100 .

  IF GO_HANDLER IS INITIAL.
    CREATE OBJECT GO_HANDLER.
  ENDIF.
  SET HANDLER:
  " 더블클릭 이벤트 구현
  GO_HANDLER->ON_DOUBLE_CLICK FOR GO_ALV_GRID_LEFT, " LEFT ALV
  GO_HANDLER->ON_HOTSPOT_CLICK FOR GO_ALV_GRID_LEFT," LEFT ALV
  GO_HANDLER->ON_DOUBLE_CLICK FOR GO_ALV_GRID_RIGHT," LEFT ALV
  GO_HANDLER->ON_HOTSPOT_CLICK FOR GO_ALV_GRID_RIGHT. " Right ALV
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_AVL_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM SET_AVL_FIELDCAT_0100 .


  REFRESH GT_FIELDCAT.
  REFRESH GT_FIELDCAT_ALL.

* -- ALV1 : DISP
  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'MONTH'. " 월별
  GS_FIELDCAT-COL_POS   = 1.
  GS_FIELDCAT-COLTEXT   = '기간'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'DMBTR_S'. " 월별 차변 합계금액
  GS_FIELDCAT-COL_POS   = 2.
  GS_FIELDCAT-COLTEXT   = '차변'.
  GS_FIELDCAT-REF_TABLE = 'ZEA_BSEG'.
  GS_FIELDCAT-REF_FIELD = 'DMBTR'.
  GS_FIELDCAT-EMPHASIZE = 'C300'.
  GS_FIELDCAT-CFIELDNAME = 'DMBTR_S'.
  GS_FIELDCAT-CURRENCY  = 'KRW'.
  GS_FIELDCAT-HOTSPOT   = ABAP_ON.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'DMBTR_H'. " 월별 대변 합계금액
  GS_FIELDCAT-COL_POS   = 3.
  GS_FIELDCAT-COLTEXT   = '대변'.
  GS_FIELDCAT-REF_TABLE = 'ZEA_BSEG'.
  GS_FIELDCAT-REF_FIELD = 'DMBTR'.
  GS_FIELDCAT-EMPHASIZE = 'C500'.
  GS_FIELDCAT-CFIELDNAME = 'DMBTR_H'.
  GS_FIELDCAT-CURRENCY  = 'KRW'.
  GS_FIELDCAT-HOTSPOT   = ABAP_ON.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'DMBTR_DIF'.
  GS_FIELDCAT-COL_POS   = 4.
  GS_FIELDCAT-COLTEXT   = '잔액'.
  GS_FIELDCAT-REF_TABLE = 'ZEA_BSEG'.
  GS_FIELDCAT-REF_FIELD = 'DMBTR'.
  GS_FIELDCAT-EMPHASIZE = 'C601'.
  GS_FIELDCAT-CFIELDNAME = 'DMBTR_DIF'.
  GS_FIELDCAT-CURRENCY  = 'KRW'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

* -- ALV2 에 추가하는 필드 --
*  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
*    EXPORTING
*      I_STRUCTURE_NAME = 'ZEA_BSEG'
*    CHANGING
*      CT_FIELDCAT      = GT_FIELDCAT_ALL  " Field Catalog with Field Descriptions
*    EXCEPTIONS
*      OTHERS           = 1.
*  IF SY-SUBRC <> 0.
*
*  ENDIF.

  CLEAR GS_FIELDCAT_ALL.
  GS_FIELDCAT_ALL-FIELDNAME = 'BSCHL'.
  GS_FIELDCAT_ALL-COLTEXT   = 'DC'.
  GS_FIELDCAT_ALL-REF_TABLE = 'ZEA_BSEG'.
  GS_FIELDCAT_ALL-REF_FIELD = 'BSCHL'.
  GS_FIELDCAT_ALL-KEY       = ABAP_ON.
  APPEND GS_FIELDCAT_ALL TO GT_FIELDCAT_ALL.


  CLEAR GS_FIELDCAT_ALL.
  GS_FIELDCAT_ALL-FIELDNAME = 'BELNR'.
  GS_FIELDCAT_ALL-HOTSPOT   = ABAP_ON.
  GS_FIELDCAT_ALL-REF_TABLE = 'ZEA_BSEG'.
  GS_FIELDCAT_ALL-REF_FIELD = 'BELNR'.
  GS_FIELDCAT_ALL-KEY       = ABAP_ON.
  APPEND GS_FIELDCAT_ALL TO GT_FIELDCAT_ALL.

  CLEAR GS_FIELDCAT_ALL.
  GS_FIELDCAT_ALL-FIELDNAME = 'BLART'.
  GS_FIELDCAT_ALL-REF_TABLE = 'ZEA_BKPF'.
  GS_FIELDCAT_ALL-REF_FIELD = 'BLART'.
  APPEND GS_FIELDCAT_ALL TO GT_FIELDCAT_ALL.

  CLEAR GS_FIELDCAT_ALL.
  GS_FIELDCAT_ALL-FIELDNAME = 'BLDAT'.
  GS_FIELDCAT_ALL-REF_TABLE = 'ZEA_BKPF'.
  GS_FIELDCAT_ALL-REF_FIELD = 'BUDAT'.
  APPEND GS_FIELDCAT_ALL TO GT_FIELDCAT_ALL.

  CLEAR GS_FIELDCAT_ALL.
  GS_FIELDCAT_ALL-FIELDNAME = 'BUDAT'.
  GS_FIELDCAT_ALL-REF_TABLE = 'ZEA_BKPF'.
  GS_FIELDCAT_ALL-REF_FIELD = 'BUDAT'.
  APPEND GS_FIELDCAT_ALL TO GT_FIELDCAT_ALL.

  CLEAR GS_FIELDCAT_ALL.
  GS_FIELDCAT_ALL-FIELDNAME = 'BLTXT'.
  GS_FIELDCAT_ALL-REF_TABLE = 'ZEA_BKPF'.
  GS_FIELDCAT_ALL-REF_FIELD = 'BLTXT'.
  APPEND GS_FIELDCAT_ALL TO GT_FIELDCAT_ALL.


  CLEAR GS_FIELDCAT_ALL.
  GS_FIELDCAT_ALL-FIELDNAME = 'DMBTR'.
  GS_FIELDCAT_ALL-REF_TABLE = 'ZEA_BSEG'.
  GS_FIELDCAT_ALL-REF_FIELD = 'DMBTR'.
  GS_FIELDCAT_ALL-EMPHASIZE = 'C311'.
  GS_FIELDCAT_ALL-CFIELDNAME = 'DMBTR'.
  GS_FIELDCAT_ALL-CURRENCY  = 'KRW'.
  APPEND GS_FIELDCAT_ALL TO GT_FIELDCAT_ALL.

  CLEAR GS_FIELDCAT_ALL.
  GS_FIELDCAT_ALL-FIELDNAME = 'D_WAERS'.
  GS_FIELDCAT_ALL-REF_TABLE = 'ZEA_BSEG'.
  GS_FIELDCAT_ALL-REF_FIELD = 'D_WAERS'.
  GS_FIELDCAT_ALL-EMPHASIZE = 'C311'.
  APPEND GS_FIELDCAT_ALL TO GT_FIELDCAT_ALL.

  CLEAR GS_FIELDCAT_ALL.
  GS_FIELDCAT_ALL-FIELDNAME = 'WRBTR'.
  GS_FIELDCAT_ALL-REF_TABLE = 'ZEA_BSEG'.
  GS_FIELDCAT_ALL-REF_FIELD = 'WRBTR'.
  GS_FIELDCAT_ALL-EMPHASIZE = 'C311'.
  GS_FIELDCAT_ALL-CFIELDNAME = 'WRBTR'.
  GS_FIELDCAT_ALL-CURRENCY  = 'KRW'.
  APPEND GS_FIELDCAT_ALL TO GT_FIELDCAT_ALL.

  CLEAR GS_FIELDCAT_ALL.
  GS_FIELDCAT_ALL-FIELDNAME = 'W_WAERS'.
  GS_FIELDCAT_ALL-REF_TABLE = 'ZEA_BSEG'.
  GS_FIELDCAT_ALL-REF_FIELD = 'W_WAERS'.
  GS_FIELDCAT_ALL-EMPHASIZE = 'C311'.
  APPEND GS_FIELDCAT_ALL TO GT_FIELDCAT_ALL.


*    GS_FIELDCAT-FIELDNAME = 'CARRID'.        " 필드 이름
*    GS_FIELDCAT-COLTEXT   = TEXT-F01.        " 출력 되는 컬럼명
*    GS_FIELDCAT-HOTSPOT   = ABAP_ON.         " HOTSPOT 설정
*    GS_FIELDCAT-ICON      = ABAP_ON. " 'X'   " 아이콘 필드
  " 컬럼을 합산처리하도록 옵션을 켬
*    GS_FIELDCAT-DO_SUM    = ABAP_ON. " 'X'.
*    GS_FIELDCAT-NO_OUT    = ABAP_ON. "'X'.   " 컬럼을 숨김 처리
*    GS_FIELDCAT-TECH      = ABAP_ON. "'X'.   " 컬럼을 삭제 처리
  " 컬럼명 위에 마우스를 올렸을 때 텍스트
*    GS_FIELDCAT-TOOLTIP   = TEXT-F03.
  " 가운데 정렬, 'L': 왼쪽 정렬, 'R': 오른쪽 정렬
*    GS_FIELDCAT-JUST      = 'C'
*    GS_FIELDCAT-CFIELDNAME    = CURRENCY     " 통화 단위 참조
*    GS_FIELDCAT-CHECKBOX  = ABAP_ON          " 체크박스
*    GS_FIELDCAT-INTTYPE   = I.               " 내부 타입
*    GS_FIELDCAT-INTLEN    = 20.              " 내부 길이
*    GS_FIELDCAT-EMPHASIZE = 'C500'.          " 열 색상
*    APPEND GS_FIELDCAT TO GT_FIELDCAT.




ENDFORM.
*&---------------------------------------------------------------------*
*& Form SUM_DATA
*&---------------------------------------------------------------------*
FORM SUM_DATA .
  CASE GS_DATA-INDI_CD.
    WHEN 'S'. " 차변
      ADD GS_DATA-DMBTR TO GS_DISP-DMBTR_S.

    WHEN 'H'. " 대변
      GS_DISP-DMBTR_H = GS_DISP-DMBTR_H + GS_DATA-DMBTR.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH_ALV_0100
*&---------------------------------------------------------------------*
FORM REFRESH_ALV_0100 .

  GS_STABLE = VALUE #( COL = ABAP_TRUE
                       ROW = ABAP_TRUE ).

  CALL METHOD GO_ALV_GRID_RIGHT->REFRESH_TABLE_DISPLAY
    EXPORTING
      IS_STABLE = GS_STABLE.

ENDFORM.
