*&---------------------------------------------------------------------*
*& Include          ZEA_SD110_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form DEC_TABLE_DATA
*&---------------------------------------------------------------------*
*FORM DEC_TABLE_DATA .
*
*  " 삭제 플래그 값 없는 것들만 조회하고 배치번호로 정렬
*  SELECT SINGLE *
*    FROM ZEA_MMT190
*    INTO GS_MMT190
*    WHERE MATNR EQ ZEA_SDT050-MATNR
*      AND WERKS EQ ZEA_SDT060-WERKS.
**    WHERE LVORM EQ ''.
*
**  SORT GT_MMT190 BY CHARG.
*
**  READ TABLE GT_MMT190 INTO GS_MMT190
**                       WITH KEY MATNR = ZEA_SDT050-MATNR
**                                WERKS = ZEA_SDT060-WERKS.
*  IF SY-SUBRC EQ 0.
*     IF GS_DISPLAY2-AUQUA > GS_MMT190-CALQTY.
*       MESSAGE E037. " 재고가 부족합니다.
*    ELSE.
*
*    GS_MMT190-CALQTY = GS_MMT190-CALQTY - GS_DISPLAY2-AUQUA.
*
*    UPDATE ZEA_MMT190 SET CALQTY = GS_MMT190-CALQTY
*                    WHERE MATNR = ZEA_SDT050-MATNR
*                      AND WERKS = ZEA_SDT060-WERKS.
*    ENDIF.
*  ENDIF.
*
*  " itab GS_DISPLAY4에도 바로 반영되게 해야할듯.
*
*  GS_DATA4-CALQTY = GS_MMT190-CALQTY.
*  MODIFY GT_DATA4 FROM GS_DATA4 TRANSPORTING CALQTY WHERE WERKS EQ ZEA_SDT060-WERKS
*                                                                AND MATNR EQ GS_DISPLAY2-MATNR.
*
*
*ENDFORM.
**&---------------------------------------------------------------------*
**& Form DEC_BATCH_DATA
**&---------------------------------------------------------------------*
*FORM DEC_BATCH_DATA .
*
*  " 삭제 플래그 값 없는 것들만 조회하고 배치번호로 정렬
*  SELECT *
*    FROM ZEA_MMT070
*    INTO TABLE GT_MMT070
*    WHERE LVORM EQ ''.
*
*  SORT GT_MMT070 BY CHARG.
*
*
*  READ TABLE GT_MMT070 INTO GS_MMT070
*                     WITH KEY MATNR = ZEA_SDT050-MATNR
*                              WERKS = ZEA_SDT060-WERKS.
*  IF SY-SUBRC EQ 0.
*  " 1. 전체 수량 비교 -> IF
*  IF GS_DISPLAY2-AUQUA > GS_MMT190-CALQTY.              " GS_MMT190에 DEC_TABLE_DATA를 통해서 값이 들어가 있음.
*    MESSAGE E037. " 재고가 부족합니다.
*
*    " 2. 필요수량에서 배치의 보유 수량만큼 제거(보유 수량이 같거나 적을 때만 제거)
*    "     배치의 보유수량이 많으면 필요한 만큼만 제거.
*  ELSE.
*
*
*      IF GS_MMT070-REMQTY GT GS_DISPLAY2-AUQUA.
*
*        GS_MMT070-REMQTY = GS_MMT070-REMQTY - GS_DISPLAY2-AUQUA.
*        GS_DISPLAY2-AUQUA = 0.
*
*        UPDATE ZEA_MMT070 SET REMQTY = GS_MMT070-REMQTY
*                        WHERE MATNR = GS_MMT070-MATNR
*                          AND WERKS = GS_MMT070-WERKS
*                          AND CHARG = GS_MMT070-CHARG.
*
*        " 배치번호 제일 빠른거 읽어 와서 WHERE 절에 ?
*
*      ELSEIF GS_MMT070-REMQTY EQ GS_DISPLAY2-AUQUA.
*
*        GS_MMT070-REMQTY = GS_MMT070-REMQTY - GS_DISPLAY2-AUQUA.
*        GS_DISPLAY2-AUQUA = 0.
*
*        UPDATE ZEA_MMT070 SET REMQTY = GS_MMT070-REMQTY
*                              LVORM  = 'X' " 배치번호 제일 빠른것 '만' 삭제
*                          WHERE MATNR = GS_MMT070-MATNR
*                          AND WERKS = GS_MMT070-WERKS
*                          AND CHARG = GS_MMT070-CHARG.
*
*
*
*      ELSEIF GS_MMT070-REMQTY LT GS_DISPLAY2-AUQUA.
*
*
*
*          LOOP AT GT_MMT070 INTO GS_MMT070 WHERE MATNR EQ GS_DISPLAY2-MATNR
*                                             AND WERKS EQ ZEA_SDT060-WERKS.             " LOOP 탈출을 GS_DISPLAY2가 0 이 됐을때 탈출 하게.
*            IF GS_DISPLAY2-AUQUA EQ 0.
*              EXIT.
*            ENDIF.
*            " LOOP를 돌면서 배치번호가 다음으로 넘어가게는 어떻게?
*            " SELECT 를 계속 해줘야하나? LOOP안에 SELECT는 문제가 많은데
*            IF GS_MMT070-REMQTY LT GS_DISPLAY2-AUQUA.
*
*              GS_DISPLAY2-AUQUA = GS_DISPLAY2-AUQUA - GS_MMT070-REMQTY.
*              GS_MMT070-REMQTY = 0.
*
*              UPDATE ZEA_MMT070 SET REMQTY = GS_MMT070-REMQTY
*                                    LVORM  = 'X' " 배치번호 제일 빠른것 '만' 삭제
*                                WHERE MATNR = GS_MMT070-MATNR
*                                AND WERKS = GS_MMT070-WERKS
*                                AND CHARG = GS_MMT070-CHARG
*                                AND LVORM NE 'X'.
*
*            ELSEIF GS_MMT190-CALQTY EQ GS_DISPLAY2-AUQUA.
*
*              GS_MMT070-REMQTY = 0.
*              GS_DISPLAY2-AUQUA = 0.
*
*              UPDATE ZEA_MMT070 SET REMQTY = GS_MMT070-REMQTY
*                                    LVORM  = 'X' " 배치번호 제일 빠른것 '만' 삭제
*                                WHERE MATNR = GS_MMT070-MATNR
*                                AND WERKS = GS_MMT070-WERKS
*                                AND CHARG = GS_MMT070-CHARG
*                                AND LVORM NE 'X'.
*
*              " 3. 필요수량이 0이 아닌경우 2의 과정을 반복
*              "    만약, 필요수량이 0인경우 종료.
*            ELSEIF GS_MMT190-CALQTY GT GS_DISPLAY2-AUQUA.
*              GS_MMT070-REMQTY = GS_MMT070-REMQTY - GS_DISPLAY2-AUQUA.
*              GS_DISPLAY2-AUQUA = 0.
*
*              UPDATE ZEA_MMT070 SET REMQTY = GS_MMT070-REMQTY
*                              WHERE MATNR = GS_MMT070-MATNR
*                                AND WERKS = GS_MMT070-WERKS
*                                AND CHARG = GS_MMT070-CHARG.
*            ENDIF.
*
*          ENDLOOP.
*
*      ELSE.
*      ENDIF.
*
*
*    ENDIF.
*  ELSE.
*
*  ENDIF.
*
*ENDFORM.
