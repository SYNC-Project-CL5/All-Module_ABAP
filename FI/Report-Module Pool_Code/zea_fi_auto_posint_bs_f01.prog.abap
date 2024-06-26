*&---------------------------------------------------------------------*
*& Include          ZEA_FI_AUTO_POSINT_PL_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form BS - 자산, 자본, 부채 생성
*&---------------------------------------------------------------------*
FORM BS.
  CLEAR: GV_BELNR_NUMBER.
  CALL FUNCTION 'ZEA_BELNR_NR'
    IMPORTING
      EV_NUMBER = GV_BELNR_NUMBER.

  _MC_HEAD '20240110' '현금'.
  INSERT ZEA_BKPF FROM GS_BKPF.

  "아이템 "전기키 "계정 " 텍스트 "금액 "BP코드  "자재코드
  _MC_ITEM '1' '40' '100040' ' 당좌예금-우리-포스코-지급어음' '180000' '40001' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '210530' '사채-전환사채'    '180000' ' ' ''. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.


  MESSAGE GV_BELNR_NUMBER && '번 전표가 생성되었습니다. ' TYPE 'S'.
  COMMIT WORK AND WAIT.

  CLEAR: GV_BELNR_NUMBER.
  CALL FUNCTION 'ZEA_BELNR_NR'
    IMPORTING
      EV_NUMBER = GV_BELNR_NUMBER.

  _MC_HEAD '20240210' '급여'.
  INSERT ZEA_BKPF FROM GS_BKPF.

  _MC_ITEM '1' '40' '110160' '투자부동산'     '4000000' '' ''.
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '220000' '장기차입금'     '4000000' '' ''.
  INSERT ZEA_BSEG FROM GS_BSEG.

  MESSAGE GV_BELNR_NUMBER && '번 전표가 생성되었습니다. ' TYPE 'S'.
  COMMIT WORK AND WAIT.


  CLEAR: GV_BELNR_NUMBER.
  CALL FUNCTION 'ZEA_BELNR_NR'
    IMPORTING
      EV_NUMBER = GV_BELNR_NUMBER.

  _MC_HEAD '20240310' '급여'.
  INSERT ZEA_BKPF FROM GS_BKPF.

  _MC_ITEM '1' '50' '310040' '자기주식-보통주'  '4000000' '' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '40' '100020' '당좌예금' '4000000' '' ''. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.


  MESSAGE GV_BELNR_NUMBER && '번 전표가 생성되었습니다. ' TYPE 'S'.
  COMMIT WORK AND WAIT.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form EXPENSE - 영업외 수익/비용
*&---------------------------------------------------------------------*
FORM EXPENSE .

ENDFORM.

*&---------------------------------------------------------------------*
*& Form SALES - 매출원가/매출
*&---------------------------------------------------------------------*
FORM SALES .

*&---------------------------------------------------------------------*
*& 직영점1 - 10002
*&---------------------------------------------------------------------*
  " 전표번호 - 직영점1
  CLEAR: GV_BELNR_NUMBER.
  CALL FUNCTION 'ZEA_BELNR_NR'
    IMPORTING
      EV_NUMBER = GV_BELNR_NUMBER.

  _MC_HEAD '20240131' '제품국내매출액'.
  INSERT ZEA_BKPF FROM GS_BKPF.

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '99432' '10002' '30000000'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '100680' '제품'           '99432' '10002' '30000000'. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '3' '40' '100020' '당좌예금'       '397728' '10002' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '4' '50' '410002' '제품국내매출액' '397728' '10002' ''. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.

  MESSAGE GV_BELNR_NUMBER && '번 전표가 생성되었습니다. ' TYPE 'S'.
  COMMIT WORK AND WAIT.

  " 전표번호 재채번 - 직영점1
  CLEAR: GV_BELNR_NUMBER.
  CALL FUNCTION 'ZEA_BELNR_NR'
    IMPORTING
      EV_NUMBER = GV_BELNR_NUMBER.

  _MC_HEAD '20240229' '제품국내매출액'.
  INSERT ZEA_BKPF FROM GS_BKPF.

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '99432' '10002' '30000000'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '100680' '제품'           '99432' '10002' '30000000'. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '3' '40' '100020' '당좌예금'       '397728' '10002' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '4' '50' '410002' '제품국내매출액' '397728' '10002' ''. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.

  MESSAGE GV_BELNR_NUMBER && '번 전표가 생성되었습니다. ' TYPE 'S'.
  COMMIT WORK AND WAIT.


  " 전표번호 재채번 - 직영점1
  CLEAR: GV_BELNR_NUMBER.
  CALL FUNCTION 'ZEA_BELNR_NR'
    IMPORTING
      EV_NUMBER = GV_BELNR_NUMBER.

  _MC_HEAD '20240331' '제품국내매출액'.
  INSERT ZEA_BKPF FROM GS_BKPF.

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '99432' '10002' '30000000'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '100680' '제품'           '99432' '10002' '30000000'. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '3' '40' '100020' '당좌예금'       '397728' '10002' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '4' '50' '410002' '제품국내매출액' '397728' '10002' ''. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.

  MESSAGE GV_BELNR_NUMBER && '번 전표가 생성되었습니다. ' TYPE 'S'.
  COMMIT WORK AND WAIT.

  " 전표번호 재채번 - 직영점1
  CLEAR: GV_BELNR_NUMBER.
  CALL FUNCTION 'ZEA_BELNR_NR'
    IMPORTING
      EV_NUMBER = GV_BELNR_NUMBER.

  _MC_HEAD '20240430' '제품국내매출액'.
  INSERT ZEA_BKPF FROM GS_BKPF.

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '99432' '10002' '30000000'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '100680' '제품'           '99432' '10002' '30000000'. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '3' '40' '100020' '당좌예금'       '397728' '10002' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '4' '50' '410002' '제품국내매출액' '397728' '10002' ''. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.

  MESSAGE GV_BELNR_NUMBER && '번 전표가 생성되었습니다. ' TYPE 'S'.
  COMMIT WORK AND WAIT.

*&---------------------------------------------------------------------*
*& 직영점2 - 10003
*&---------------------------------------------------------------------*
  " 전표번호
  CLEAR: GV_BELNR_NUMBER.
  CALL FUNCTION 'ZEA_BELNR_NR'
    IMPORTING
      EV_NUMBER = GV_BELNR_NUMBER.

  _MC_HEAD '20240131' '제품국내매출액'.
  INSERT ZEA_BKPF FROM GS_BKPF.

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '100440' '10003' '30000008'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '100690' '제품'           '100440' '10003' '30000008'. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '3' '40' '100020' '당좌예금'       '401760' '10003' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '4' '50' '410002' '제품국내매출액' '401760' '10003' ''. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.

  MESSAGE GV_BELNR_NUMBER && '번 전표가 생성되었습니다. ' TYPE 'S'.
  COMMIT WORK AND WAIT.

  " 전표번호 재채번
  CLEAR: GV_BELNR_NUMBER.
  CALL FUNCTION 'ZEA_BELNR_NR'
    IMPORTING
      EV_NUMBER = GV_BELNR_NUMBER.

  _MC_HEAD '20240229' '제품국내매출액'.
  INSERT ZEA_BKPF FROM GS_BKPF.

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '100440' '10003' '30000008'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '100690' '제품'           '100440' '10003' '30000008'. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '3' '40' '100020' '당좌예금'       '401760' '10003' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '4' '50' '410002' '제품국내매출액' '401760' '10003' ''. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.

  MESSAGE GV_BELNR_NUMBER && '번 전표가 생성되었습니다. ' TYPE 'S'.
  COMMIT WORK AND WAIT.


  " 전표번호 재채번
  CLEAR: GV_BELNR_NUMBER.
  CALL FUNCTION 'ZEA_BELNR_NR'
    IMPORTING
      EV_NUMBER = GV_BELNR_NUMBER.

  _MC_HEAD '20240331' '제품국내매출액'.
  INSERT ZEA_BKPF FROM GS_BKPF.

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '100440' '10003' '30000008'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '100690' '제품'           '100440' '10003' '30000008'. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '3' '40' '100020' '당좌예금'       '401760' '10003' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '4' '50' '410002' '제품국내매출액' '401760' '10003' ''. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.

  MESSAGE GV_BELNR_NUMBER && '번 전표가 생성되었습니다. ' TYPE 'S'.
  COMMIT WORK AND WAIT.

  " 전표번호 재채번
  CLEAR: GV_BELNR_NUMBER.
  CALL FUNCTION 'ZEA_BELNR_NR'
    IMPORTING
      EV_NUMBER = GV_BELNR_NUMBER.

  _MC_HEAD '20240430' '제품국내매출액'.
  INSERT ZEA_BKPF FROM GS_BKPF.

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '100440' '10003' '30000008'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '100690' '제품'           '100440' '10003' '30000008'. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '3' '40' '100020' '당좌예금'       '401760' '10003' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '4' '50' '410002' '제품국내매출액' '401760' '10003' ''. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.

  MESSAGE GV_BELNR_NUMBER && '번 전표가 생성되었습니다. ' TYPE 'S'.
  COMMIT WORK AND WAIT.

*&---------------------------------------------------------------------*
*& 직영점3 - 10004
*&---------------------------------------------------------------------*
  " 전표번호
  CLEAR: GV_BELNR_NUMBER.
  CALL FUNCTION 'ZEA_BELNR_NR'
    IMPORTING
      EV_NUMBER = GV_BELNR_NUMBER.

  _MC_HEAD '20240131' '제품국내매출액'.
  INSERT ZEA_BKPF FROM GS_BKPF.

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '93744' '10004' '30000010'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '100700' '제품'           '93744' '10004' '30000010'. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '3' '40' '100020' '당좌예금'       '374976' '10004' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '4' '50' '410002' '제품국내매출액' '374976' '10004' ''. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.

  MESSAGE GV_BELNR_NUMBER && '번 전표가 생성되었습니다. ' TYPE 'S'.
  COMMIT WORK AND WAIT.

  " 전표번호 재채번
  CLEAR: GV_BELNR_NUMBER.
  CALL FUNCTION 'ZEA_BELNR_NR'
    IMPORTING
      EV_NUMBER = GV_BELNR_NUMBER.

  _MC_HEAD '20240229' '제품국내매출액'.
  INSERT ZEA_BKPF FROM GS_BKPF.

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '93744' '10004' '30000010'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '100700' '제품'           '93744' '10004' '30000010'. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '3' '40' '100020' '당좌예금'       '374976' '10004' '30000010'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '4' '50' '410002' '제품국내매출액' '374976' '10004' '30000010'. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.

  MESSAGE GV_BELNR_NUMBER && '번 전표가 생성되었습니다. ' TYPE 'S'.
  COMMIT WORK AND WAIT.


  " 전표번호 재채번
  CLEAR: GV_BELNR_NUMBER.
  CALL FUNCTION 'ZEA_BELNR_NR'
    IMPORTING
      EV_NUMBER = GV_BELNR_NUMBER.

  _MC_HEAD '20240331' '제품국내매출액'.
  INSERT ZEA_BKPF FROM GS_BKPF.

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '93744' '10004' '30000010'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '100700' '제품'           '93744' '10004' '30000010'. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '3' '40' '100020' '당좌예금'       '374976' '10004' '30000010'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '4' '50' '410002' '제품국내매출액' '374976' '10004' '30000010'. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.

  MESSAGE GV_BELNR_NUMBER && '번 전표가 생성되었습니다. ' TYPE 'S'.
  COMMIT WORK AND WAIT.

  " 전표번호 재채번
  CLEAR: GV_BELNR_NUMBER.
  CALL FUNCTION 'ZEA_BELNR_NR'
    IMPORTING
      EV_NUMBER = GV_BELNR_NUMBER.

  _MC_HEAD '20240430' '제품국내매출액'.
  INSERT ZEA_BKPF FROM GS_BKPF.

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '93744' '10004' '30000010'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '100700' '제품'           '93744' '10004' '30000010'. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '3' '40' '100020' '당좌예금'       '374976' '10004' '30000010'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '4' '50' '410002' '제품국내매출액' '374976' '10004' '30000010'. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.

  MESSAGE GV_BELNR_NUMBER && '번 전표가 생성되었습니다. ' TYPE 'S'.
  COMMIT WORK AND WAIT.

*&---------------------------------------------------------------------*
*& 직영점4 - 10005
*&---------------------------------------------------------------------*
  " 전표번호
  CLEAR: GV_BELNR_NUMBER.
  CALL FUNCTION 'ZEA_BELNR_NR'
    IMPORTING
      EV_NUMBER = GV_BELNR_NUMBER.

  _MC_HEAD '20240131' '제품국내매출액'.
  INSERT ZEA_BKPF FROM GS_BKPF.

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '93744' '10005' '30000010'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '100700' '제품'           '93744' '10005' '30000010'. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '3' '40' '100020' '당좌예금'       '428544' '10005' '30000011'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '4' '50' '410002' '제품국내매출액' '428544' '10005' '30000011'. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.

  MESSAGE GV_BELNR_NUMBER && '번 전표가 생성되었습니다. ' TYPE 'S'.
  COMMIT WORK AND WAIT.

  " 전표번호 재채번
  CLEAR: GV_BELNR_NUMBER.
  CALL FUNCTION 'ZEA_BELNR_NR'
    IMPORTING
      EV_NUMBER = GV_BELNR_NUMBER.

  _MC_HEAD '20240229' '제품국내매출액'.
  INSERT ZEA_BKPF FROM GS_BKPF.

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '93744' '10005' '30000010'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '100700' '제품'           '93744' '10005' '30000010'. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '3' '40' '100020' '당좌예금'       '428544' '10005' '30000011'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '4' '50' '410002' '제품국내매출액' '428544' '10005' '30000011'. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.

  MESSAGE GV_BELNR_NUMBER && '번 전표가 생성되었습니다. ' TYPE 'S'.
  COMMIT WORK AND WAIT.


  " 전표번호 재채번
  CLEAR: GV_BELNR_NUMBER.
  CALL FUNCTION 'ZEA_BELNR_NR'
    IMPORTING
      EV_NUMBER = GV_BELNR_NUMBER.

  _MC_HEAD '20240331' '제품국내매출액'.
  INSERT ZEA_BKPF FROM GS_BKPF.

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '93744' '10005' '30000010'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '100700' '제품'           '93744' '10005' '30000010'. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '3' '40' '100020' '당좌예금'       '428544' '10005' '30000011'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '4' '50' '410002' '제품국내매출액' '428544' '10005' '30000011'. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.

  MESSAGE GV_BELNR_NUMBER && '번 전표가 생성되었습니다. ' TYPE 'S'.
  COMMIT WORK AND WAIT.

  " 전표번호 재채번
  CLEAR: GV_BELNR_NUMBER.
  CALL FUNCTION 'ZEA_BELNR_NR'
    IMPORTING
      EV_NUMBER = GV_BELNR_NUMBER.

  _MC_HEAD '20240430' '제품국내매출액'.
  INSERT ZEA_BKPF FROM GS_BKPF.

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '93744' '10005' '30000010'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '100700' '제품'           '93744' '10005' '30000010'. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '3' '40' '100020' '당좌예금'       '428544' '10005' '30000011'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '4' '50' '410002' '제품국내매출액' '428544' '10005' '30000011'. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.

  MESSAGE GV_BELNR_NUMBER && '번 전표가 생성되었습니다. ' TYPE 'S'.
  COMMIT WORK AND WAIT.


*&---------------------------------------------------------------------*
*& 직영점5 - 10006
*&---------------------------------------------------------------------*
  " 전표번호
  CLEAR: GV_BELNR_NUMBER.
  CALL FUNCTION 'ZEA_BELNR_NR'
    IMPORTING
      EV_NUMBER = GV_BELNR_NUMBER.

  _MC_HEAD '20240131' '제품국내매출액'.
  INSERT ZEA_BKPF FROM GS_BKPF.

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '176768' '10006' '30000017'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '100720' '제품'           '176768' '10006' '30000017'. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '3' '40' '100020' '당좌예금'       '707072' '10006' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '4' '50' '410002' '제품국내매출액' '707072' '10006' ''. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.

  MESSAGE GV_BELNR_NUMBER && '번 전표가 생성되었습니다. ' TYPE 'S'.
  COMMIT WORK AND WAIT.

  " 전표번호 재채번
  CLEAR: GV_BELNR_NUMBER.
  CALL FUNCTION 'ZEA_BELNR_NR'
    IMPORTING
      EV_NUMBER = GV_BELNR_NUMBER.

  _MC_HEAD '20240229' '제품국내매출액'.
  INSERT ZEA_BKPF FROM GS_BKPF.

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '176768' '10006' '30000017'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '100720' '제품' '176768'  '10006' '30000017'. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '3' '40' '100020' '당좌예금'       '707072' '10006' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '4' '50' '410002' '제품국내매출액' '707072' '10006' ''. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.

  MESSAGE GV_BELNR_NUMBER && '번 전표가 생성되었습니다. ' TYPE 'S'.
  COMMIT WORK AND WAIT.


  " 전표번호 재채번
  CLEAR: GV_BELNR_NUMBER.
  CALL FUNCTION 'ZEA_BELNR_NR'
    IMPORTING
      EV_NUMBER = GV_BELNR_NUMBER.

  _MC_HEAD '20240331' '제품국내매출액'.
  INSERT ZEA_BKPF FROM GS_BKPF.

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '176768' '10006' '30000017'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '100720' '제품'           '176768' '10006' '30000017'. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '3' '40' '100020' '당좌예금'       '707072' '10006' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '4' '50' '410002' '제품국내매출액' '707072' '10006' ''. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.

  MESSAGE GV_BELNR_NUMBER && '번 전표가 생성되었습니다. ' TYPE 'S'.
  COMMIT WORK AND WAIT.

  " 전표번호 재채번
  CLEAR: GV_BELNR_NUMBER.
  CALL FUNCTION 'ZEA_BELNR_NR'
    IMPORTING
      EV_NUMBER = GV_BELNR_NUMBER.

  _MC_HEAD '20240430' '제품국내매출액'.
  INSERT ZEA_BKPF FROM GS_BKPF.

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '176768' '10006' '30000017'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '100720' '제품'           '176768' '10006' '30000017'. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '3' '40' '100020' '당좌예금'       '707072' '10006' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '4' '50' '410002' '제품국내매출액' '707072' '10006' ''. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.

  MESSAGE GV_BELNR_NUMBER && '번 전표가 생성되었습니다. ' TYPE 'S'.
  COMMIT WORK AND WAIT.


*&---------------------------------------------------------------------*
*& 직영점6 - 10007
*&---------------------------------------------------------------------*
  " 전표번호
  CLEAR: GV_BELNR_NUMBER.
  CALL FUNCTION 'ZEA_BELNR_NR'
    IMPORTING
      EV_NUMBER = GV_BELNR_NUMBER.

  _MC_HEAD '20240131' '제품국내매출액'.
  INSERT ZEA_BKPF FROM GS_BKPF.

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '93744' '10007' '30000018'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '100730' '제품' '93744'   '10007'  '30000018'. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '3' '40' '100020' '당좌예금'       '374976' '10007' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '4' '50' '410002' '제품국내매출액' '374976' '10007' ''. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.

  MESSAGE GV_BELNR_NUMBER && '번 전표가 생성되었습니다. ' TYPE 'S'.
  COMMIT WORK AND WAIT.

  " 전표번호 재채번
  CLEAR: GV_BELNR_NUMBER.
  CALL FUNCTION 'ZEA_BELNR_NR'
    IMPORTING
      EV_NUMBER = GV_BELNR_NUMBER.

  _MC_HEAD '20240229' '제품국내매출액'.
  INSERT ZEA_BKPF FROM GS_BKPF.

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '93744'  '10007' '30000018'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '100730' '제품' '93744'   '10007'  '30000018'. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '3' '40' '100020' '당좌예금'       '374976' '10007' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '4' '50' '410002' '제품국내매출액' '374976' '10007' ''. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.

  MESSAGE GV_BELNR_NUMBER && '번 전표가 생성되었습니다. ' TYPE 'S'.
  COMMIT WORK AND WAIT.


  " 전표번호 재채번
  CLEAR: GV_BELNR_NUMBER.
  CALL FUNCTION 'ZEA_BELNR_NR'
    IMPORTING
      EV_NUMBER = GV_BELNR_NUMBER.

  _MC_HEAD '20240331' '제품국내매출액'.
  INSERT ZEA_BKPF FROM GS_BKPF.


  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '93744'  '10007' '30000018'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '100730' '제품'           '93744'  '10007' '30000018'. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '3' '40' '100020' '당좌예금'       '374976' '10007' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '4' '50' '410002' '제품국내매출액' '374976' '10007' ''. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.

  MESSAGE GV_BELNR_NUMBER && '번 전표가 생성되었습니다. ' TYPE 'S'.
  COMMIT WORK AND WAIT.

  " 전표번호 재채번
  CLEAR: GV_BELNR_NUMBER.
  CALL FUNCTION 'ZEA_BELNR_NR'
    IMPORTING
      EV_NUMBER = GV_BELNR_NUMBER.

  _MC_HEAD '20240430' '제품국내매출액'.
  INSERT ZEA_BKPF FROM GS_BKPF.

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '93744' '10007' '30000018'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '100730' '제품'           '93744' '10007' '30000018'. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '3' '40' '100020' '당좌예금'       '374976' '10007' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '4' '50' '410002' '제품국내매출액' '374976' '10007' ''. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.

  MESSAGE GV_BELNR_NUMBER && '번 전표가 생성되었습니다. ' TYPE 'S'.
  COMMIT WORK AND WAIT.


*&---------------------------------------------------------------------*
*& 직영점7 - 10008
*&---------------------------------------------------------------------*
  " 전표번호
  CLEAR: GV_BELNR_NUMBER.
  CALL FUNCTION 'ZEA_BELNR_NR'
    IMPORTING
      EV_NUMBER = GV_BELNR_NUMBER.

  _MC_HEAD '20240131' '제품국내매출액'.
  INSERT ZEA_BKPF FROM GS_BKPF.

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '93744'  '10008' '30000018'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '100730' '제품'           '93744'  '10008' '30000018'. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '3' '40' '100020' '당좌예금'       '374976' '10008' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '4' '50' '410002' '제품국내매출액' '374976' '10008' ''. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.

  MESSAGE GV_BELNR_NUMBER && '번 전표가 생성되었습니다. ' TYPE 'S'.
  COMMIT WORK AND WAIT.

  " 전표번호 재채번
  CLEAR: GV_BELNR_NUMBER.
  CALL FUNCTION 'ZEA_BELNR_NR'
    IMPORTING
      EV_NUMBER = GV_BELNR_NUMBER.

  _MC_HEAD '20240229' '제품국내매출액'.
  INSERT ZEA_BKPF FROM GS_BKPF.

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '93744'  '10008' '30000018'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '100730' '제품'           '93744'  '10008' '30000018'. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '3' '40' '100020' '당좌예금'       '374976' '10008' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '4' '50' '410002' '제품국내매출액' '374976' '10008' ''. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.

  MESSAGE GV_BELNR_NUMBER && '번 전표가 생성되었습니다. ' TYPE 'S'.
  COMMIT WORK AND WAIT.


  " 전표번호 재채번
  CLEAR: GV_BELNR_NUMBER.
  CALL FUNCTION 'ZEA_BELNR_NR'
    IMPORTING
      EV_NUMBER = GV_BELNR_NUMBER.

  _MC_HEAD '20240331' '제품국내매출액'.
  INSERT ZEA_BKPF FROM GS_BKPF.

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '93744'  '10008' '30000018'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '100730' '제품'           '93744'  '10008' '30000018'. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '3' '40' '100020' '당좌예금'       '374976' '10008' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '4' '50' '410002' '제품국내매출액' '374976' '10008' ''. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.

  MESSAGE GV_BELNR_NUMBER && '번 전표가 생성되었습니다. ' TYPE 'S'.
  COMMIT WORK AND WAIT.

  " 전표번호 재채번
  CLEAR: GV_BELNR_NUMBER.
  CALL FUNCTION 'ZEA_BELNR_NR'
    IMPORTING
      EV_NUMBER = GV_BELNR_NUMBER.

  _MC_HEAD '20240430' '제품국내매출액'.
  INSERT ZEA_BKPF FROM GS_BKPF.

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '93744'  '10008' '30000018'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '100730' '제품'           '93744'  '10008' '30000018'. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '3' '40' '100020' '당좌예금'       '374976' '10008' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '4' '50' '410002' '제품국내매출액' '374976' '10008' ''. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.

  MESSAGE GV_BELNR_NUMBER && '번 전표가 생성되었습니다. ' TYPE 'S'.
  COMMIT WORK AND WAIT.


*&---------------------------------------------------------------------*
*& 직영점8 - 10009
*&---------------------------------------------------------------------*
  " 전표번호
  CLEAR: GV_BELNR_NUMBER.
  CALL FUNCTION 'ZEA_BELNR_NR'
    IMPORTING
      EV_NUMBER = GV_BELNR_NUMBER.

  _MC_HEAD '20240131' '제품국내매출액'.
  INSERT ZEA_BKPF FROM GS_BKPF.

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '120528' '10009' '30000023'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '100730' '제품'           '120528'  '10009' '30000023'. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '3' '40' '100020' '당좌예금'       '482112' '10009' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '4' '50' '410002' '제품국내매출액' '482112' '10009' ''. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.

  MESSAGE GV_BELNR_NUMBER && '번 전표가 생성되었습니다. ' TYPE 'S'.
  COMMIT WORK AND WAIT.

  " 전표번호 재채번
  CLEAR: GV_BELNR_NUMBER.
  CALL FUNCTION 'ZEA_BELNR_NR'
    IMPORTING
      EV_NUMBER = GV_BELNR_NUMBER.

  _MC_HEAD '20240229' '제품국내매출액'.
  INSERT ZEA_BKPF FROM GS_BKPF.

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '120528' '10009' '30000023'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '100730' '제품'           '120528'  '10009' '30000023'. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '3' '40' '100020' '당좌예금'       '482112' '10009' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '4' '50' '410002' '제품국내매출액' '482112' '10009' ''. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.

  MESSAGE GV_BELNR_NUMBER && '번 전표가 생성되었습니다. ' TYPE 'S'.
  COMMIT WORK AND WAIT.


  " 전표번호 재채번
  CLEAR: GV_BELNR_NUMBER.
  CALL FUNCTION 'ZEA_BELNR_NR'
    IMPORTING
      EV_NUMBER = GV_BELNR_NUMBER.

  _MC_HEAD '20240331' '제품국내매출액'.
  INSERT ZEA_BKPF FROM GS_BKPF.

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '120528' '10009' '30000023'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '100730' '제품'           '120528'  '10009' '30000023'. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '3' '40' '100020' '당좌예금'       '482112' '10009' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '4' '50' '410002' '제품국내매출액' '482112' '10009' ''. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.

  MESSAGE GV_BELNR_NUMBER && '번 전표가 생성되었습니다. ' TYPE 'S'.
  COMMIT WORK AND WAIT.

  " 전표번호 재채번
  CLEAR: GV_BELNR_NUMBER.
  CALL FUNCTION 'ZEA_BELNR_NR'
    IMPORTING
      EV_NUMBER = GV_BELNR_NUMBER.

  _MC_HEAD '20240430' '제품국내매출액'.
  INSERT ZEA_BKPF FROM GS_BKPF.

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '120528' '10009' '30000023'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '100730' '제품'           '120528' '10009' '30000023'. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '3' '40' '100020' '당좌예금'       '482112' '10009' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '4' '50' '410002' '제품국내매출액' '482112' '10009' ''. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.

  MESSAGE GV_BELNR_NUMBER && '번 전표가 생성되었습니다. ' TYPE 'S'.
  COMMIT WORK AND WAIT.

ENDFORM.
