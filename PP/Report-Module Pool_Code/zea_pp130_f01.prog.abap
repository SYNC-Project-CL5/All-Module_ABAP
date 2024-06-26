*&---------------------------------------------------------------------*
*& Include          YE00_EX001_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form SELECT_DATA
*&---------------------------------------------------------------------*
FORM SELECT_DATA .

  " Internal Table의 내용을 전부 비워둠
  REFRESH: GT_DISPLAY_090, GT_DISPLAY_010.

  " New Open SQL
  SELECT *
    FROM ZEA_AFRU AS A
*    JOIN ZEA_T001W AS B
*      ON B~WERKS EQ A~WERKS
    LEFT JOIN ZEA_MMT020 AS C
      ON C~MATNR EQ A~MATNR
      AND SPRAS EQ @SY-LANGU
   WHERE A~MATNR IN @SO_MAT
     AND A~AUFNR IN @SO_AUF
     AND A~CHARG IN @SO_CHA
     AND A~TSDAT IN @SO_TSD
    INTO CORRESPONDING FIELDS OF TABLE @GT_DISPLAY_090.

*  " CARRID를 오름차순으로 정렬을 한다.
*  SORT GT_DISPLAY_090 BY AUFNR ASCENDING.
**
*  SELECT FROM ZEA_MMT070 AS A
*  LEFT JOIN ZEA_MMT020 AS B
*    ON B~MATNR EQ A~MATNR
*   AND B~SPRAS EQ @SY-LANGU
*FIELDS *
*  INTO CORRESPONDING FIELDS OF TABLE @GT_DISPLAY_010.
*
*  SORT GT_DISPLAY_010 BY CHARG MATNR.


*   두번째 ALV에 출력될 데이터를 조회
*  REFRESH GT_SPFLI.
****  SELECT * FROM SPFLI WHERE CARRID IN @SO_CAR INTO TABLE @GT_SPFLI.
****  SORT GT_SPFLI BY CARRID ASCENDING
****                   CONNID ASCENDING.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM MAKE_DISPLAY_DATA .

*  REFRESH GT_DISPLAY_090.
*
*  LOOP AT GT_AFRU INTO GS_AFRU.
*
*    CLEAR GS_DISPLAY_090.
*
*    MOVE-CORRESPONDING GS_AFRU TO GS_DISPLAY_090.
*
**신규 필드------------------------------------------------------------*
*
*
**--------------------------------------------------------------------*
*    APPEND GS_DISPLAY_090 TO GT_DISPLAY_090.
*
*  ENDLOOP.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_0100
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT_0100 .

  " 화면 전체를 차지하는 커스텀 컨트롤과 연결되는 커스텀 컨테이너
  CREATE OBJECT GO_CONTAINER
    EXPORTING
      CONTAINER_NAME = 'CCON' " Name of the Screen CustCtrl Name to Link Container To
    EXCEPTIONS
      OTHERS         = 1.

  IF SY-SUBRC NE 0.
    MESSAGE '컨테이너 생성에 실패했습니다.' TYPE 'E'.
  ENDIF.

  CREATE OBJECT GO_SPLIT
    EXPORTING
      PARENT  = GO_CONTAINER       " Parent Container
      ROWS    = 2                  " Number of Rows to be displayed
      COLUMNS = 2                  " Number of Columns to be Displayed
    EXCEPTIONS
      OTHERS  = 1.

  IF SY-SUBRC <> 0.
    MESSAGE '분리 컨테이너 생성에 실패했습니다.' TYPE 'E'.
  ENDIF.

  " CLASSIC 한 메소드 호출 방법
  CALL METHOD GO_SPLIT->GET_CONTAINER
    EXPORTING
      ROW       = 1 " Row
      COLUMN    = 1 " Column
    RECEIVING
      CONTAINER = GO_CON_TOP_L. " Container

  " CLASSIC 한 메소드 호출 방법
  CALL METHOD GO_SPLIT->GET_CONTAINER
    EXPORTING
      ROW       = 1 " Row
      COLUMN    = 2 " Column
    RECEIVING
      CONTAINER = GO_CON_TOP_R. " Container

  CALL METHOD GO_SPLIT->GET_CONTAINER
    EXPORTING
      ROW       = 2 " Row
      COLUMN    = 1 " Column
    RECEIVING
      CONTAINER = GO_CON_BOT_L. " Container

  CALL METHOD GO_SPLIT->GET_CONTAINER
    EXPORTING
      ROW       = 2 " Row
      COLUMN    = 2 " Column
    RECEIVING
      CONTAINER = GO_CON_BOT_R. " Container

  " 신문법 중 하나
  GO_CON_TOP_L = GO_SPLIT->GET_CONTAINER( ROW = 1 COLUMN = 1 ).
  GO_CON_TOP_R = GO_SPLIT->GET_CONTAINER( ROW = 1 COLUMN = 2 ).
  GO_CON_BOT_L = GO_SPLIT->GET_CONTAINER( ROW = 2 COLUMN = 1 ).
  GO_CON_BOT_R = GO_SPLIT->GET_CONTAINER( ROW = 2 COLUMN = 2 ).


  " TOP(L) 컨테이너에 ALV를 생성
  CREATE OBJECT GO_ALV_GRID_TOP_L
    EXPORTING
      I_PARENT = GO_CON_TOP_L " Parent Container
    EXCEPTIONS
      OTHERS   = 1.

  IF SY-SUBRC NE 0.
    MESSAGE 'TOP_L ALV 생성에 실패했습니다.' TYPE 'E'.
  ENDIF.

  " TOP(R) 컨테이너에 ALV를 생성
  CREATE OBJECT GO_ALV_GRID_TOP_R
    EXPORTING
      I_PARENT = GO_CON_TOP_R " Parent Container
    EXCEPTIONS
      OTHERS   = 1.

  IF SY-SUBRC NE 0.
    MESSAGE 'TOP_R ALV 생성에 실패했습니다.' TYPE 'E'.
  ENDIF.

  " BOT(L) 컨테이너에 ALV를 생성
  CREATE OBJECT GO_ALV_GRID_BOT_L
    EXPORTING
      I_PARENT = GO_CON_BOT_L
    EXCEPTIONS
      OTHERS   = 1.
  IF SY-SUBRC NE 0.
    MESSAGE 'BOT_L ALV 생성에 실패했습니다.' TYPE 'E'.
  ENDIF.

  " BOT(R) 컨테이너에 ALV를 생성
  CREATE OBJECT GO_ALV_GRID_BOT_R
    EXPORTING
      I_PARENT = GO_CON_BOT_R
    EXCEPTIONS
      OTHERS   = 1.
  IF SY-SUBRC NE 0.
    MESSAGE 'BOT_R ALV 생성에 실패했습니다.' TYPE 'E'.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_LAYOUT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_LAYOUT_0100 .

  CLEAR GS_LAYOUT.

  GS_LAYOUT-ZEBRA       = 'X'.  " 얼룩처리
  GS_LAYOUT-SEL_MODE    = 'D'.  " 셀단위로 선택
  GS_LAYOUT-CWIDTH_OPT  = 'A'.  " 열넓이 최적화, X: 한번만 A: 항상(적용 시 속도가 느려짐)




ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_0100
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV_0100 .

  CLEAR GS_VARIANT.
  GS_VARIANT-REPORT = SY-REPID.
  GS_VARIANT-HANDLE = 'H'.
  GV_SAVE = 'A'.
  GS_VARIANT-HANDLE = '0001'. " 프로그램 내 ALV 구별자

  GS_LAYOUT-GRID_TITLE = '생산 실적'. " ALV 이름 설정

  CALL METHOD GO_ALV_GRID_TOP_L->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
*     I_STRUCTURE_NAME = 'SCARR'     " Internal Output Table Structure Name
      IS_VARIANT      = GS_VARIANT  " Layout
      I_SAVE          = GV_SAVE     " Save Layout
      IS_LAYOUT       = GS_LAYOUT   " Layout
    CHANGING
      IT_OUTTAB       = GT_DISPLAY_090    " Output Table
      IT_FIELDCATALOG = GT_FIELDCAT_090 " Field Catalog
    EXCEPTIONS
      OTHERS          = 1.

  IF SY-SUBRC <> 0.
    MESSAGE 'ALV에 데이터를 설정하는 과정 중 오류가 발생했습니다.' TYPE 'E'.
  ENDIF.

  CLEAR GS_VARIANT.
  GS_VARIANT-REPORT = SY-REPID.
  GS_VARIANT-HANDLE = 'H'.
  GV_SAVE = 'A'.
  GS_VARIANT-HANDLE = '0004'. " 프로그램 내 ALV 구별자

  GS_LAYOUT-GRID_TITLE = '배치번호'.

  CALL METHOD GO_ALV_GRID_TOP_R->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
*     I_STRUCTURE_NAME = 'SCARR'     " Internal Output Table Structure Name
      IS_VARIANT      = GS_VARIANT  " Layout
      I_SAVE          = GV_SAVE     " Save Layout
      IS_LAYOUT       = GS_LAYOUT   " Layout
    CHANGING
      IT_OUTTAB       = GT_DISPLAY_010    " Output Table
      IT_FIELDCATALOG = GT_FIELDCAT_010 " Field Catalog
    EXCEPTIONS
      OTHERS          = 1.

  IF SY-SUBRC <> 0.
    MESSAGE 'ALV에 데이터를 설정하는 과정 중 오류가 발생했습니다.' TYPE 'E'.
  ENDIF.

  GS_LAYOUT-GRID_TITLE = '생산오더 아이템'.

  CLEAR GS_VARIANT.
  GS_VARIANT-REPORT = SY-REPID.
  GS_VARIANT-HANDLE = 'H'.
  GV_SAVE = 'A'.
  GS_VARIANT-HANDLE = '0002'. " 프로그램 내 ALV 구별자

  CALL METHOD GO_ALV_GRID_BOT_R->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
*     I_STRUCTURE_NAME = 'SPFLI'     " Internal Output Table Structure Name
      IS_VARIANT      = GS_VARIANT  " Layout
      I_SAVE          = GV_SAVE     " Save Layout
      IS_LAYOUT       = GS_LAYOUT   " Layout
    CHANGING
      IT_OUTTAB       = GT_DISPLAY_120    " Output Table
      IT_FIELDCATALOG = GT_FIELDCAT_120   " Field Catalog
    EXCEPTIONS
      OTHERS          = 1.

  IF SY-SUBRC <> 0.
    MESSAGE 'ALV에 데이터를 설정하는 과정 중 오류가 발생했습니다.' TYPE 'E'.
  ENDIF.


  GS_LAYOUT-GRID_TITLE = '생산오더 헤더'.


  CLEAR GS_VARIANT.
  GS_VARIANT-REPORT = SY-REPID.
  GS_VARIANT-HANDLE = 'H'.
  GV_SAVE = 'A'.
  GS_VARIANT-HANDLE = '0003'. " 프로그램 내 ALV 구별자

  CALL METHOD GO_ALV_GRID_BOT_L->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
*     I_STRUCTURE_NAME = 'SPFLI'     " Internal Output Table Structure Name
      IS_VARIANT      = GS_VARIANT  " Layout
      I_SAVE          = GV_SAVE     " Save Layout
      IS_LAYOUT       = GS_LAYOUT   " Layout
    CHANGING
      IT_OUTTAB       = GT_DISPLAY_070    " Output Table
      IT_FIELDCATALOG = GT_FIELDCAT_070   " Field Catalog
    EXCEPTIONS
      OTHERS          = 1.

  IF SY-SUBRC <> 0.
    MESSAGE 'ALV에 데이터를 설정하는 과정 중 오류가 발생했습니다.' TYPE 'E'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_DOUBLE_CLICK
*&---------------------------------------------------------------------*
*& PS: Parameter Structure , 전달되는 변수의 종류가 스트럭쳐 변수다.
*& PO: Parameter Object , 전달되는 변수의 종류가 참조변수 다.
*& PV: Parameter Value , 전달되는 변수의 값이 문자, 정수, 실수, 날짜, 시간 같은 Elementary Type이다.
*& PT: Parameter Table , 전달되는 변수의 종류가 인터널 테이블이다.
*&---------------------------------------------------------------------*
FORM HANDLE_DOUBLE_CLICK  USING PS_ROW    TYPE LVC_S_ROW
                                PS_COLUMN TYPE LVC_S_COL
                                PO_SENDER TYPE REF TO CL_GUI_ALV_GRID.

*GT_DISPLAY_090 : 생산실적
*GT_DISPLAY_070 : 생산오더 헤더
*GT_DISPLAY_120 : 생산오더 아이템
*GT_DISPLAY_010 : 배치 테이블

  CLEAR GS_DISPLAY_090.
  REFRESH: GT_DISPLAY_120, GT_DISPLAY_010.
  READ TABLE GT_DISPLAY_090 INTO GS_DISPLAY_090 INDEX PS_ROW-INDEX.

  REFRESH GT_DISPLAY_070.

* 아래 왼쪽
  SELECT
    FROM ZEA_AUFK AS A
    LEFT JOIN ZEA_MMT020 AS B
      ON B~MATNR EQ A~MATNR
     AND B~SPRAS EQ @SY-LANGU
    FIELDS *
    WHERE A~AUFNR EQ @GS_DISPLAY_090-AUFNR
    INTO CORRESPONDING FIELDS OF TABLE @GT_DISPLAY_070.

  SORT GT_DISPLAY_070 BY AUFNR.


  " 변경된 데이터를 ALV에 출력하기 위해 ALV를 새로고침 한다.
  CALL METHOD GO_ALV_GRID_BOT_L->REFRESH_TABLE_DISPLAY
*    EXPORTING
*      IS_STABLE      =                  " With Stable Rows/Columns
*      I_SOFT_REFRESH =                  " Without Sort, Filter, etc.
    EXCEPTIONS
      FINISHED = 1                " Display was Ended (by Export)
      OTHERS   = 2.

* 아래 우측
  SELECT FROM ZEA_PPT020 AS A
    LEFT JOIN ZEA_MMT020 AS B
      ON B~MATNR EQ A~MATNR
     AND B~SPRAS EQ @SY-LANGU
  FIELDS *
    WHERE A~AUFNR EQ @GS_DISPLAY_090-AUFNR
    INTO CORRESPONDING FIELDS OF TABLE @GT_DISPLAY_120.

  SORT GT_DISPLAY_120 BY AUFNR ORDIDX.
*
*
  " 변경된 데이터를 ALV에 출력하기 위해 ALV를 새로고침 한다.
  CALL METHOD GO_ALV_GRID_BOT_R->REFRESH_TABLE_DISPLAY
*    EXPORTING
*      IS_STABLE      =                  " With Stable Rows/Columns
*      I_SOFT_REFRESH =                  " Without Sort, Filter, etc.
    EXCEPTIONS
      FINISHED = 1                " Display was Ended (by Export)
      OTHERS   = 2.





ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_EVENT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_EVENT_0100 .

* Static Method는 Class 에 존재하므로 Class=>StaticMethod 접근가능
* Instance Method면 Intance ( 객체 )에 존재하므로 Object->InstanceMethod 접근해야 함
  SET HANDLER:
    LCL_EVENT_HANDLER=>ON_HOTSPOT_CLICK FOR GO_ALV_GRID_TOP_L, " TOP ALV에게만 반응
    LCL_EVENT_HANDLER=>ON_HOTSPOT_CLICK2 FOR GO_ALV_GRID_TOP_L. " BOT_L ALV에게만 반응


ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_FIELDCAT_0100 .

*-- 탑(L)
  PERFORM GET_FIELDCAT_090_0100 USING  GT_DISPLAY_090
                                       GT_FIELDCAT_090.

  PERFORM SET_FIELDCAT_090_0100.

*-- 탑(R)
  PERFORM GET_FIELDCAT_010_0100 USING  GT_DISPLAY_010
                                       GT_FIELDCAT_010.

  PERFORM SET_FIELDCAT_010_0100.


*-- 바텀(L)
  PERFORM GET_FIELDCAT_120_0100 USING  GT_DISPLAY_120
                                       GT_FIELDCAT_120.

  PERFORM SET_FIELDCAT_120_0100.


*-- 바텀(R)
  PERFORM GET_FIELDCAT_070_0100 USING  GT_DISPLAY_070
                                       GT_FIELDCAT_070.

  PERFORM SET_FIELDCAT_070_0100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM GET_FIELDCAT_090_0100  USING PT_TAB TYPE STANDARD TABLE
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
*& Form SET_FIELDCAT_090_0100
*&---------------------------------------------------------------------*
FORM SET_FIELDCAT_090_0100 .

  LOOP AT GT_FIELDCAT_090 INTO GS_FIELDCAT_090.

    CASE GS_FIELDCAT_090-FIELDNAME.
      WHEN 'AUFNR'.
        GS_FIELDCAT_090-HOTSPOT = ABAP_ON.
        GS_FIELDCAT_090-JUST = 'C'.
        GS_FIELDCAT_090-KEY = ABAP_ON.

*      WHEN 'WERKS' OR 'VALID_EN' .
*        GS_FIELDCAT_090-JUST = 'C'.
*        GS_FIELDCAT_090-KEY = ABAP_ON.

      WHEN 'MAKTX' OR 'PNAME1'.
        GS_FIELDCAT_090-EMPHASIZE = 'C500'.
        GS_FIELDCAT_090-JUST = 'C'.


      WHEN 'CHARG' OR 'MATNR' OR 'BOMID'.
        GS_FIELDCAT_090-EMPHASIZE = 'C500'.
*        GS_FIELDCAT_090-HOTSPOT = ABAP_ON.
        GS_FIELDCAT_090-JUST = 'C'.

      WHEN 'EMPCODE'
      OR 'TSDAT' OR 'LOEKZ'.
        GS_FIELDCAT_090-JUST = 'C'.

      WHEN 'DEFREASON'.
        GS_FIELDCAT_090-JUST = 'C'.
        GS_FIELDCAT_090-COLTEXT = '불량사유'.

      WHEN 'PDQUAN' OR 'PDBAN' OR 'FNPD'.
        GS_FIELDCAT_090-QFIELDNAME = 'MEINS'.
        GS_FIELDCAT_090-EMPHASIZE = 'C300'.

    ENDCASE.

    MODIFY GT_FIELDCAT_090 FROM GS_FIELDCAT_090.
  ENDLOOP.

ENDFORM.

FORM GET_FIELDCAT_070_0100  USING PT_TAB TYPE STANDARD TABLE
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
*& Form SET_FIELDCAT_090_0100
*&---------------------------------------------------------------------*
FORM SET_FIELDCAT_070_0100 .


  LOOP AT GT_FIELDCAT_070 INTO GS_FIELDCAT_070.

    CASE GS_FIELDCAT_070-FIELDNAME.
      WHEN 'AUFNR'.
*        GS_FIELDCAT_120-HOTSPOT = ABAP_ON.
        GS_FIELDCAT_070-JUST = 'C'.
        GS_FIELDCAT_070-KEY = ABAP_ON.

      WHEN  'WERKS' OR 'PLANID' OR 'MATNR' OR 'MATKX'.
        GS_FIELDCAT_070-EMPHASIZE = 'C500'.
        GS_FIELDCAT_070-JUST = 'C'.

      WHEN 'TOT_QTY'.
        GS_FIELDCAT_070-EMPHASIZE = 'C510'.
        GS_FIELDCAT_070-JUST = 'C'.
        GS_FIELDCAT_070-QFIELDNAME = 'MEINS'.

      WHEN 'APPROVAL' OR 'APPROVER' OR 'REJREASON'.
        GS_FIELDCAT_070-JUST = 'C'.

      WHEN 'LOEKZ'.
        GS_FIELDCAT_070-JUST = 'C'.

    ENDCASE.

    MODIFY GT_FIELDCAT_070 FROM GS_FIELDCAT_070.

  ENDLOOP.


ENDFORM.

FORM GET_FIELDCAT_120_0100  USING PT_TAB TYPE STANDARD TABLE
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
*& Form SET_FIELDCAT_090_0100
*&---------------------------------------------------------------------*
FORM SET_FIELDCAT_120_0100 .

  LOOP AT GT_FIELDCAT_120 INTO GS_FIELDCAT_120.

    CASE GS_FIELDCAT_120-FIELDNAME.
      WHEN 'AUFNR' OR 'ORDIDX'.
*        GS_FIELDCAT_120-HOTSPOT = ABAP_ON.
        GS_FIELDCAT_120-JUST = 'C'.
        GS_FIELDCAT_120-KEY = ABAP_ON.

      WHEN  'WERKS' OR 'BOMID' OR 'MATNR' OR 'MATKX'.
*        GS_FIELDCAT_120-HOTSPOT = ABAP_ON.
        GS_FIELDCAT_120-JUST = 'C'.

      WHEN 'EXPQTY' OR 'REPQTY' OR 'RQTY'.
        GS_FIELDCAT_120-EMPHASIZE = 'C510'.
        GS_FIELDCAT_120-JUST = 'C'.
        GS_FIELDCAT_120-QFIELDNAME = 'UNIT'.

      WHEN 'EXPSDATE' OR 'EXPEDATE' OR 'SDATE' OR 'EDATE'.
        GS_FIELDCAT_120-JUST = 'C'.

      WHEN 'LOEKZ'.
        GS_FIELDCAT_120-JUST = 'C'.

    ENDCASE.

    MODIFY GT_FIELDCAT_120 FROM GS_FIELDCAT_120.

  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH_ALV_0100
*&---------------------------------------------------------------------*
FORM REFRESH_ALV_0100 .

  DATA LS_STABLE TYPE LVC_S_STBL.
  LS_STABLE-ROW = ABAP_ON.
  LS_STABLE-COL = ABAP_ON.

  CALL METHOD GO_ALV_GRID_TOP_L->REFRESH_TABLE_DISPLAY
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

  CALL METHOD GO_ALV_GRID_TOP_R->REFRESH_TABLE_DISPLAY
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

  CALL METHOD GO_ALV_GRID_BOT_L->REFRESH_TABLE_DISPLAY
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

  CALL METHOD GO_ALV_GRID_BOT_R->REFRESH_TABLE_DISPLAY
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
*& Form HANDLE_HOTSPOT_CLICK
*&---------------------------------------------------------------------*
FORM HANDLE_HOTSPOT_CLICK2  USING PS_ROW    TYPE LVC_S_ROW
                                PS_COLUMN TYPE LVC_S_COL
                                PO_SENDER TYPE REF TO CL_GUI_ALV_GRID.

  CLEAR: GS_DISPLAY_090.
  READ TABLE GT_DISPLAY_090 INTO GS_DISPLAY_090 INDEX PS_ROW-INDEX.

  REFRESH GT_DISPLAY_010.



* 위에 우측
  SELECT FROM ZEA_MMT070 AS A
  LEFT JOIN ZEA_MMT020 AS B
    ON B~MATNR EQ A~MATNR
   AND B~SPRAS EQ @SY-LANGU
FIELDS *
  WHERE A~CHARG EQ @GS_DISPLAY_090-CHARG
  INTO CORRESPONDING FIELDS OF TABLE @GT_DISPLAY_010.

  SORT GT_DISPLAY_010 BY CHARG MATNR.


  " 변경된 데이터를 ALV에 출력하기 위해 ALV를 새로고침 한다.
  CALL METHOD GO_ALV_GRID_TOP_R->REFRESH_TABLE_DISPLAY
*    EXPORTING
*      IS_STABLE      =                  " With Stable Rows/Columns
*      I_SOFT_REFRESH =                  " Without Sort, Filter, etc.
    EXCEPTIONS
      FINISHED = 1                " Display was Ended (by Export)
      OTHERS   = 2.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_FIELDCAT_010_0100
*&---------------------------------------------------------------------*

FORM GET_FIELDCAT_010_0100  USING PT_TAB TYPE STANDARD TABLE
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
*& Form SET_FIELDCAT_010_0100
*&---------------------------------------------------------------------*
FORM SET_FIELDCAT_010_0100 .

  LOOP AT GT_FIELDCAT_010 INTO GS_FIELDCAT_010.

    CASE GS_FIELDCAT_010-FIELDNAME.
      WHEN 'MATNR' OR 'WERKS' OR 'CHARG'.
*        GS_FIELDCAT_010-HOTSPOT = ABAP_ON.
        GS_FIELDCAT_010-JUST = 'C'.
        GS_FIELDCAT_010-KEY = ABAP_ON.

      WHEN 'SCODE'.
        GS_FIELDCAT_010-EMPHASIZE = 'C500'.
        GS_FIELDCAT_010-JUST = 'C'.

      WHEN 'CALQTY' OR 'REMQTY'.
*        GS_FIELDCAT_010-EMPHASIZE = 'C500'.
*        GS_FIELDCAT_010-JUST = 'C'.
        GS_FIELDCAT_010-QFIELDNAME = 'MEINS'.
        GS_FIELDCAT_010-EMPHASIZE = 'C300'.

      WHEN 'LVORM'.
        GS_FIELDCAT_010-JUST = 'C'.


    ENDCASE.

    MODIFY GT_FIELDCAT_010 FROM GS_FIELDCAT_010.

  ENDLOOP.

ENDFORM.
