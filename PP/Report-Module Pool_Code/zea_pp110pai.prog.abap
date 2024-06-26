*&---------------------------------------------------------------------*
*& Include          YE00_EX007PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT_0100  INPUT
*&---------------------------------------------------------------------*
MODULE EXIT_0100 INPUT.

  CASE OK_CODE.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'CANC'.
      LEAVE TO SCREEN 0.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.
  CASE OK_CODE.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'REFRESH'.


      " TREE 관련 Subroutines
      CLEAR   GV_NODE_KEY2.
      REFRESH GT_NODE2.
      REFRESH GT_NODE_INFO2.

      CALL METHOD GO_SIMPLE_TREE2->DELETE_ALL_NODES( ).

      PERFORM SELECT_DATA.
      PERFORM CREATE_NODE_0100_2. " 생산계획 트리 구성을 위한 Subroutines

      SORT GT_NODE_INFO2 BY NODE_KEY.

      CALL METHOD GO_SIMPLE_TREE2->ADD_NODES
        EXPORTING
          TABLE_STRUCTURE_NAME           = 'MTREESNODE'     " Name of Structure of Node Table
          NODE_TABLE                     = GT_NODE2          " Node table
        EXCEPTIONS
          ERROR_IN_NODE_TABLE            = 1                " Node Table Contains Errors
          FAILED                         = 2                " General error
          DP_ERROR                       = 3                " Error in Data Provider
          TABLE_STRUCTURE_NAME_NOT_FOUND = 4                " Unable to Find Structure in Dictionary
          OTHERS                         = 5.
      IF SY-SUBRC <> 0.
        MESSAGE E025. " TREE NODE 생성 중 오류가 발생했습니다.
      ENDIF.

      PERFORM EXPAND_ROOT_NODE_2_0100.


      PERFORM REFRESH_ALV_0100.

    WHEN 'MRP'.
      LEAVE TO TRANSACTION 'ZEAPP070'.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0110  INPUT
*&---------------------------------------------------------------------*
MODULE USER_COMMAND_0110 INPUT.
  CASE OK_CODE.
    WHEN 'SAVE'.
      PERFORM CALC_MPS.  " 생산계획 생성 로직
      CALL SCREEN 0120 STARTING AT 70 2.

  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT_0110  INPUT
*&---------------------------------------------------------------------*
MODULE EXIT_0110 INPUT.

  CASE OK_CODE.
*    WHEN 'EXIT'.
*      LEAVE PROGRAM.
    WHEN 'CANC'.
      CLEAR: ZEA_MMT010,
             ZEA_MMT020,
             ZEA_PLAF,
             ZEA_PPT010.
      LEAVE TO SCREEN 0.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT_0120  INPUT
*&---------------------------------------------------------------------*
MODULE EXIT_0120 INPUT.

  CASE OK_CODE.
    WHEN 'CANC'.
      CLEAR: S0120, ZEA_PPT010-PLANID, ZEA_PPT010-PLANINDEX.
      LEAVE TO SCREEN 0.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0120  INPUT
*&---------------------------------------------------------------------*
MODULE USER_COMMAND_0120 INPUT.

  CASE OK_CODE.
    WHEN 'SAVE'.


      DATA LV_SUBRC TYPE I.
      DATA LV_COUNT TYPE I.
      DATA LV_ANSWER.

      _MC_POPUP_CONFIRM '저장' '생산계획을 생성하시겠습니까?' LV_ANSWER.
      CHECK LV_ANSWER = '1'.

      PERFORM CHCEK_CREATE_NUMBER. " 채번 유무를 검증하기 위한 로직

      " 생성 완료 후, 화면을 잠금. (월 체크박스는 안잠그고 생산계획 수량만 잠금)
      S0120-1MONTH = ABAP_OFF.
      S0120-2MONTH = ABAP_OFF.
      S0120-3MONTH = ABAP_OFF.
      S0120-4MONTH = ABAP_OFF.
      S0120-5MONTH = ABAP_OFF.
      S0120-6MONTH = ABAP_OFF.
      S0120-7MONTH = ABAP_OFF.
      S0120-8MONTH = ABAP_OFF.
      S0120-9MONTH = ABAP_OFF.
      S0120-10MONTH = ABAP_OFF.
      S0120-11MONTH = ABAP_OFF.
      S0120-12MONTH = ABAP_OFF.

    LOOP AT SCREEN.
      CASE SCREEN-NAME.
        WHEN 'S0120-PLANQTY1' OR 'S0120-PLANQTY2' OR 'S0120-PLANQTY3' OR
             'S0120-PLANQTY5' OR 'S0120-PLANQTY6' OR 'S0120-PLANQTY7' OR
             'S0120-PLANQTY8' OR 'S0120-PLANQTY9' OR 'S0120-PLANQTY10' OR
             'S0120-PLANQTY11' OR 'S0120-PLANQTY12' OR 'S0120-PLANQTY4'.
*          'S0120-1MONTH' OR 'S0120-2MONTH' OR 'S0120-3MONTH' OR 'S0120-4MONTH'
*          OR 'S0120-5MONTH' OR 'S0120-6MONTH' OR 'S0120-7MONTH' OR 'S0120-8MONTH'
*          OR 'S0120-9MONTH' OR 'S0120-10MONTH' OR 'S0120-11MONTH' OR 'S0120-12MONTH'.
          SCREEN-INPUT = 0.
      ENDCASE.
      MODIFY SCREEN.
   ENDLOOP.


      " 아래는 노드 리프레쉬와 관련된 함수

      " TREE 관련 Subroutines
      CLEAR   GV_NODE_KEY2.
      REFRESH GT_NODE2.
      REFRESH GT_NODE_INFO2.

      CALL METHOD GO_SIMPLE_TREE2->DELETE_ALL_NODES( ).

      PERFORM SELECT_DATA.
      PERFORM CREATE_NODE_0100_2. " 생산계획 트리 구성을 위한 Subroutines

      SORT GT_NODE_INFO2 BY NODE_KEY.

      CALL METHOD GO_SIMPLE_TREE2->ADD_NODES
        EXPORTING
          TABLE_STRUCTURE_NAME           = 'MTREESNODE'     " Name of Structure of Node Table
          NODE_TABLE                     = GT_NODE2          " Node table
        EXCEPTIONS
          ERROR_IN_NODE_TABLE            = 1                " Node Table Contains Errors
          FAILED                         = 2                " General error
          DP_ERROR                       = 3                " Error in Data Provider
          TABLE_STRUCTURE_NAME_NOT_FOUND = 4                " Unable to Find Structure in Dictionary
          OTHERS                         = 5.
      IF SY-SUBRC <> 0.
        MESSAGE E025. " TREE NODE 생성 중 오류가 발생했습니다.
      ENDIF.

      PERFORM EXPAND_ROOT_NODE_2_0100.


      PERFORM REFRESH_ALV_0100.



  ENDCASE.


ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F4HELP  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE F4HELP INPUT.

  PERFORM MMT020_F4_HELP.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_PDPDAT  INPUT
*&---------------------------------------------------------------------*
MODULE CHECK_PDPDAT INPUT.
  IF ZEA_PLAF-PDPDAT < SY-DATUM(4).
    MESSAGE E000 WITH '올해 이전의 년도는 입력할 수 없습니다.'.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_MATNR  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE CHECK_MATNR INPUT.
  IF ZEA_MMT010-MATNR GE '30000' AND ZEA_MMT010-MATNR LE '39999'.
    MESSAGE E000 WITH '완제품만 입력할 수 있습니다.'.
  ENDIF.
ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  CHECK_INPUT  INPUT
*&---------------------------------------------------------------------*
MODULE CHECK_INPUT INPUT.

  IF ZEA_PLAF-PDPDAT IS INITIAL OR ZEA_MMT010-MATNR IS INITIAL.
    MESSAGE E000 WITH '생산년도 또는 자재코드를 입력해주세요'.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_INPUT2  INPUT
*&---------------------------------------------------------------------*
MODULE CHECK_INPUT2 INPUT.

  IF ZEA_PLAF-PDPDAT < SY-DATUM+0(4).
    MESSAGE E000 WITH '올해 이전의 년도는 입력할 수 없습니다.'.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_S0120_MONTH  INPUT
*&---------------------------------------------------------------------*
MODULE CHECK_S0120_MONTH INPUT.

  CHECK OK_CODE EQ 'SAVE'
    AND S0120-1MONTH  EQ ABAP_OFF
    AND S0120-2MONTH  EQ ABAP_OFF
    AND S0120-3MONTH  EQ ABAP_OFF
    AND S0120-4MONTH  EQ ABAP_OFF
    AND S0120-5MONTH  EQ ABAP_OFF
    AND S0120-6MONTH  EQ ABAP_OFF
    AND S0120-7MONTH  EQ ABAP_OFF
    AND S0120-8MONTH  EQ ABAP_OFF
    AND S0120-9MONTH  EQ ABAP_OFF
    AND S0120-10MONTH EQ ABAP_OFF
    AND S0120-11MONTH EQ ABAP_OFF
    AND S0120-12MONTH EQ ABAP_OFF.

  MESSAGE E000 WITH '체크한 생산계획이 없습니다. 체크박스를 선택해주세요.'.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_INPUT3  INPUT
*&---------------------------------------------------------------------*
MODULE CHECK_INPUT3 INPUT.


  CLEAR ZEA_MMT020-MAKTX.
  SELECT SINGLE A~MATTYPE B~MAKTX
    FROM ZEA_MMT010 AS A
    LEFT JOIN ZEA_MMT020 AS B ON B~MATNR EQ A~MATNR
                             AND B~SPRAS EQ SY-LANGU
    INTO (ZEA_MMT010-MATTYPE, ZEA_MMT020-MAKTX)
   WHERE A~MATNR EQ ZEA_MMT010-MATNR.

  IF SY-SUBRC EQ 0.
    IF ZEA_MMT010-MATTYPE EQ '완제품'.
      " 정 상
    ELSE.
      MESSAGE E000 WITH '완제품만 입력할 수 있습니다.'.
    ENDIF.
  ELSE.
    MESSAGE E000 WITH '해당 자재코드가 존재하지 않습니다.'.
  ENDIF.


*  IF ZEA_MMT010-MATNR LT 30000.
*    MESSAGE E000 WITH '완제품만 입력할 수 있습니다.'.
*  ENDIF.
*
*  IF ZEA_MMT010-MATNR GE 40000.
*    MESSAGE E000 WITH '완제품만 입력할 수 있습니다.'.
*  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_PLANQTY1  INPUT
*&---------------------------------------------------------------------*
MODULE CHECK_PLANQTY1 INPUT.

  IF ZEA_SDT030-SPQTY1 NE 0.
    IF S0120-PLANQTY1 < 0.
      MESSAGE E000 WITH '0보다 작은 값은 입력할 수 없습니다.'.
    ELSEIF ZEA_SDT030-SPQTY1 > 0 AND ZEA_SDT030-SPQTY1 > S0120-PLANQTY1.
      MESSAGE E000  WITH '판매운영계획 수량보다 생산계획 수량이 적습니다.'.
    ENDIF.
  ELSEIF ZEA_SDT030-SPQTY1 EQ 0.
    IF S0120-PLANQTY1 EQ 0.
      MESSAGE W000 WITH '설정한 생산계획 수량은 0입니다. 체크박스를 해제해주세요.'.
    ENDIF.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_PLANQTY2  INPUT
*&---------------------------------------------------------------------*
MODULE CHECK_PLANQTY2 INPUT.

  IF ZEA_SDT030-SPQTY2 NE 0.
    IF S0120-PLANQTY2 < 0.
      MESSAGE E000 WITH '0보다 작은 값은 입력할 수 없습니다.'.
    ELSEIF S0120-PLANQTY2 < ZEA_SDT030-SPQTY2.
      MESSAGE E000  WITH '판매운영계획 수량보다 생산계획 수량이 적습니다.'.
    ENDIF.
  ELSEIF ZEA_SDT030-SPQTY2 EQ 0.
    IF S0120-PLANQTY2 EQ 0.
      MESSAGE W000 WITH '설정한 생산계획 수량은 0입니다. 체크박스를 해제해주세요.'.
    ENDIF.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_PLANQTY3  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE CHECK_PLANQTY3 INPUT.

  IF ZEA_SDT030-SPQTY3 NE 0.
    IF S0120-PLANQTY3 < 0.
      MESSAGE E000 WITH '0보다 작은 값은 입력할 수 없습니다.'.
    ELSEIF S0120-PLANQTY3 < ZEA_SDT030-SPQTY3.
      MESSAGE E000  WITH '판매운영계획 수량보다 생산계획 수량이 적습니다.'.
    ENDIF.
  ELSEIF ZEA_SDT030-SPQTY3 EQ 0.
    IF S0120-PLANQTY3 EQ 0.
      MESSAGE W000 WITH '설정한 생산계획 수량은 0입니다. 체크박스를 해제해주세요.'.
    ENDIF.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_PLANQTY4  INPUT
*&---------------------------------------------------------------------*
MODULE CHECK_PLANQTY4 INPUT.

  IF ZEA_SDT030-SPQTY4 NE 0.
    IF S0120-PLANQTY4 < 0.
      MESSAGE E000 WITH '0보다 작은 값은 입력할 수 없습니다.'.
    ELSEIF S0120-PLANQTY4 < ZEA_SDT030-SPQTY4.
      MESSAGE E000  WITH '판매운영계획 수량보다 생산계획 수량이 적습니다.'.
    ENDIF.
  ELSEIF ZEA_SDT030-SPQTY4 EQ 0.
    IF S0120-PLANQTY4 EQ 0.
      MESSAGE W000 WITH '설정한 생산계획 수량은 0입니다. 체크박스를 해제해주세요.'.
    ENDIF.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_PLANQTY5  INPUT
*&---------------------------------------------------------------------*
MODULE CHECK_PLANQTY5 INPUT.

  IF ZEA_SDT030-SPQTY5 NE 0.
    IF S0120-PLANQTY5 < 0.
      MESSAGE E000 WITH '0보다 작은 값은 입력할 수 없습니다.'.
    ELSEIF S0120-PLANQTY5 < ZEA_SDT030-SPQTY5.
      MESSAGE E000  WITH '판매운영계획 수량보다 생산계획 수량이 적습니다.'.
    ENDIF.
  ELSEIF ZEA_SDT030-SPQTY5 EQ 0.
    IF S0120-PLANQTY5 EQ 0.
      MESSAGE W000 WITH '설정한 생산계획 수량은 0입니다. 체크박스를 해제해주세요.'.
    ENDIF.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_PLANQTY6  INPUT
*&---------------------------------------------------------------------*
MODULE CHECK_PLANQTY6 INPUT.

  IF ZEA_SDT030-SPQTY6 NE 0.
    IF S0120-PLANQTY6 < 0.
      MESSAGE E000 WITH '0보다 작은 값은 입력할 수 없습니다.'.
    ELSEIF S0120-PLANQTY6 < ZEA_SDT030-SPQTY6.
      MESSAGE E000  WITH '판매운영계획 수량보다 생산계획 수량이 적습니다.'.
    ENDIF.
  ELSEIF ZEA_SDT030-SPQTY6 EQ 0.
    IF S0120-PLANQTY6 EQ 0.
      MESSAGE W000 WITH '설정한 생산계획 수량은 0입니다. 체크박스를 해제해주세요.'.
    ENDIF.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_PLANQTY7  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE CHECK_PLANQTY7 INPUT.

  IF ZEA_SDT030-SPQTY7 NE 0.
    IF S0120-PLANQTY7 < 0.
      MESSAGE E000 WITH '0보다 작은 값은 입력할 수 없습니다.'.
    ELSEIF S0120-PLANQTY7 < ZEA_SDT030-SPQTY7.
      MESSAGE E000  WITH '판매운영계획 수량보다 생산계획 수량이 적습니다.'.
    ENDIF.
  ELSEIF ZEA_SDT030-SPQTY7 EQ 0.
    IF S0120-PLANQTY7 EQ 0.
      MESSAGE W000 WITH '설정한 생산계획 수량은 0입니다. 체크박스를 해제해주세요.'.
    ENDIF.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_PLANQTY8  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE CHECK_PLANQTY8 INPUT.

  IF ZEA_SDT030-SPQTY8 NE 0.
    IF S0120-PLANQTY8 < 0.
      MESSAGE E000 WITH '0보다 작은 값은 입력할 수 없습니다.'.
    ELSEIF S0120-PLANQTY8 < ZEA_SDT030-SPQTY8.
      MESSAGE E000  WITH '판매운영계획 수량보다 생산계획 수량이 적습니다.'.
    ENDIF.
  ELSEIF ZEA_SDT030-SPQTY8 EQ 0.
    IF S0120-PLANQTY8 EQ 0.
      MESSAGE W000 WITH '설정한 생산계획 수량은 0입니다. 체크박스를 해제해주세요.'.
    ENDIF.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_PLANQTY9  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE CHECK_PLANQTY9 INPUT.

  IF ZEA_SDT030-SPQTY9 NE 0.
    IF S0120-PLANQTY9 < 0.
      MESSAGE E000 WITH '0보다 작은 값은 입력할 수 없습니다.'.
    ELSEIF S0120-PLANQTY9 < ZEA_SDT030-SPQTY9.
      MESSAGE E000  WITH '판매운영계획 수량보다 생산계획 수량이 적습니다.'.
    ENDIF.
  ELSEIF ZEA_SDT030-SPQTY9 EQ 0.
    IF S0120-PLANQTY9 EQ 0.
      MESSAGE W000 WITH '설정한 생산계획 수량은 0입니다. 체크박스를 해제해주세요.'.
    ENDIF.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_PLANQTY10  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE CHECK_PLANQTY10 INPUT.

  IF ZEA_SDT030-SPQTY10 NE 0.
    IF S0120-PLANQTY10 < 0.
      MESSAGE E000 WITH '0보다 작은 값은 입력할 수 없습니다.'.
    ELSEIF S0120-PLANQTY10 < ZEA_SDT030-SPQTY10.
      MESSAGE E000  WITH '판매운영계획 수량보다 생산계획 수량이 적습니다.'.
    ENDIF.
  ELSEIF ZEA_SDT030-SPQTY10 EQ 0.
    IF S0120-PLANQTY10 EQ 0.
      MESSAGE W000 WITH '설정한 생산계획 수량은 0입니다. 체크박스를 해제해주세요.'.
    ENDIF.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_PLANQTY11  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE CHECK_PLANQTY11 INPUT.

  IF ZEA_SDT030-SPQTY11 NE 0.
    IF S0120-PLANQTY11 < 0.
      MESSAGE E000 WITH '0보다 작은 값은 입력할 수 없습니다.'.
    ELSEIF S0120-PLANQTY11 < ZEA_SDT030-SPQTY11.
      MESSAGE E000  WITH '판매운영계획 수량보다 생산계획 수량이 적습니다.'.
    ENDIF.
  ELSEIF ZEA_SDT030-SPQTY11 EQ 0.
    IF S0120-PLANQTY11 EQ 0.
      MESSAGE W000 WITH '설정한 생산계획 수량은 0입니다. 체크박스를 해제해주세요.'.
    ENDIF.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_PLANQTY12  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE CHECK_PLANQTY12 INPUT.

  IF ZEA_SDT030-SPQTY12 NE 0.
    IF S0120-PLANQTY12 < 0.
      MESSAGE E000 WITH '0보다 작은 값은 입력할 수 없습니다.'.
    ELSEIF S0120-PLANQTY12 < ZEA_SDT030-SPQTY12.
      MESSAGE E000  WITH '판매운영계획 수량보다 생산계획 수량이 적습니다.'.
    ENDIF.
  ELSEIF ZEA_SDT030-SPQTY12 EQ 0.
    IF S0120-PLANQTY12 EQ 0.
      MESSAGE W000 WITH '설정한 생산계획 수량은 0입니다. 체크박스를 해제해주세요.'.
    ENDIF.
  ENDIF.

ENDMODULE.
