*&---------------------------------------------------------------------*
*& Include          ZEA_FI_AUTO_POSINT_PL_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form SALARY - 급여(판관비)
*&---------------------------------------------------------------------*
FORM SALARY .
  CLEAR: GV_BELNR_NUMBER.
  CALL FUNCTION 'ZEA_BELNR_NR'
    IMPORTING
      EV_NUMBER = GV_BELNR_NUMBER.

  _MC_HEAD '20240110' '급여'.
  INSERT ZEA_BKPF FROM GS_BKPF.

  _MC_ITEM '1' '40' '612001' '급여'     '20000' '30002' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '40' '613002' '급여'     '21000' '30003' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '3' '40' '613003' '급여'     '22000' '30004' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '4' '40' '613004' '급여'     '23000' '30006' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '5' '40' '613005' '급여'     '24000' '30007' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '6' '40' '613006' '급여'     '25000' '30008' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '7' '40' '615000' '급여'     '26000' '30001' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '8' '40' '616000' '급여'     '27000' '30009' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '9' '40' '515000' '급여(생산부장)' '28000' '30005' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '10' '50' '100020' '당좌예금' '216000' '10002' ''. " 대변
*  INSERT ZEA_BSEG FROM GS_BSEG.


  MESSAGE GV_BELNR_NUMBER && '번 전표가 생성되었습니다. ' TYPE 'S'.
  COMMIT WORK AND WAIT.

  CLEAR: GV_BELNR_NUMBER.
  CALL FUNCTION 'ZEA_BELNR_NR'
    IMPORTING
      EV_NUMBER = GV_BELNR_NUMBER.

  _MC_HEAD '20240210' '급여'.
  INSERT ZEA_BKPF FROM GS_BKPF.

  _MC_ITEM '1' '40' '612001' '급여'     '20000' '30002' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '40' '613002' '급여'     '21000' '30003' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '3' '40' '613003' '급여'     '22000' '30004' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '4' '40' '613004' '급여'     '23000' '30006' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '5' '40' '613005' '급여'     '24000' '30007' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '6' '40' '613006' '급여'     '25000' '30008' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '7' '40' '615000' '급여'     '26000' '30001' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '8' '40' '616000' '급여'     '27000' '30009' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '9' '40' '515000' '급여(생산부장)' '28000' '30005' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '10' '50' '100020' '당좌예금' '216000' '10002' ''. " 대변
*  INSERT ZEA_BSEG FROM GS_BSEG.


  MESSAGE GV_BELNR_NUMBER && '번 전표가 생성되었습니다. ' TYPE 'S'.
  COMMIT WORK AND WAIT.


  CLEAR: GV_BELNR_NUMBER.
  CALL FUNCTION 'ZEA_BELNR_NR'
    IMPORTING
      EV_NUMBER = GV_BELNR_NUMBER.

  _MC_HEAD '20240310' '급여'.
  INSERT ZEA_BKPF FROM GS_BKPF.

  _MC_ITEM '1' '40' '612001' '급여'     '20000' '30002' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '40' '613002' '급여'     '21000' '30003' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '3' '40' '613003' '급여'     '22000' '30004' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '4' '40' '613004' '급여'     '23000' '30006' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '5' '40' '613005' '급여'     '24000' '30007' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '6' '40' '613006' '급여'     '25000' '30008' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '7' '40' '615000' '급여'     '26000' '30001' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '8' '40' '616000' '급여'     '27000' '30009' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '9' '40' '515000' '급여(생산부장)' '28000' '30005' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '10' '50' '100020' '당좌예금' '216000' '10002' ''. " 대변
*  INSERT ZEA_BSEG FROM GS_BSEG.


  MESSAGE GV_BELNR_NUMBER && '번 전표가 생성되었습니다. ' TYPE 'S'.
  COMMIT WORK AND WAIT.


  CLEAR: GV_BELNR_NUMBER.
  CALL FUNCTION 'ZEA_BELNR_NR'
    IMPORTING
      EV_NUMBER = GV_BELNR_NUMBER.

  _MC_HEAD '20240410' '급여'.
  INSERT ZEA_BKPF FROM GS_BKPF.

  _MC_ITEM '1' '40' '612001' '급여'     '20000' '30002' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '40' '613002' '급여'     '21000' '30003' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '3' '40' '613003' '급여'     '22000' '30004' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '4' '40' '613004' '급여'     '23000' '30006' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '5' '40' '613005' '급여'     '24000' '30007' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '6' '40' '613006' '급여'     '25000' '30008' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '7' '40' '615000' '급여'     '26000' '30001' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '8' '40' '616000' '급여'     '27000' '30009' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '9' '40' '515000' '급여(생산부장)' '28000' '30005' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '10' '50' '100020' '당좌예금' '216000' '10002' ''. " 대변
*  INSERT ZEA_BSEG FROM GS_BSEG.


  MESSAGE GV_BELNR_NUMBER && '번 전표가 생성되었습니다. ' TYPE 'S'.
  COMMIT WORK AND WAIT.

  CLEAR: GV_BELNR_NUMBER.
  CALL FUNCTION 'ZEA_BELNR_NR'
    IMPORTING
      EV_NUMBER = GV_BELNR_NUMBER.

  _MC_HEAD '20240510' '급여'.
  INSERT ZEA_BKPF FROM GS_BKPF.

  _MC_ITEM '1' '40' '612001' '급여'     '20000' '30002' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '40' '613002' '급여'     '21000' '30003' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '3' '40' '613003' '급여'     '22000' '30004' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '4' '40' '613004' '급여'     '23000' '30006' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '5' '40' '613005' '급여'     '24000' '30007' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '6' '40' '613006' '급여'     '25000' '30008' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '7' '40' '615000' '급여'     '26000' '30001' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '8' '40' '616000' '급여'     '27000' '30009' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '9' '40' '515000' '급여(생산부장)' '28000' '30005' ''. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '10' '50' '100020' '당좌예금' '216000' '10002' ''. " 대변
*  INSERT ZEA_BSEG FROM GS_BSEG.


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

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '99432' '' '30000000'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '2' '50' '100680' '제품'           '99432' '10002' '30000000'. " 대변
*  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '3' '40' '100020' '당좌예금'       '397728' '10002' ''. " 차변
*  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '410002' '제품국내매출액' '397728' '10002' ''. " 대변
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

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '99432' '' '30000000'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '2' '50' '100680' '제품'           '99432' '10002' '30000000'. " 대변
*  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '3' '40' '100020' '당좌예금'       '397728' '10002' ''. " 차변
*  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '410002' '제품국내매출액' '397728' '10002' ''. " 대변
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

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '99432' '' '30000000'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '2' '50' '100680' '제품'           '99432' '10002' '30000000'. " 대변
*  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '3' '40' '100020' '당좌예금'       '397728' '10002' ''. " 차변
*  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '410002' '제품국내매출액' '397728' '10002' ''. " 대변
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

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '99432' '' '30000000'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '2' '50' '100680' '제품'           '99432' '10002' '30000000'. " 대변
*  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '3' '40' '100020' '당좌예금'       '397728' '10002' ''. " 차변
*  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '410002' '제품국내매출액' '397728' '10002' ''. " 대변
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

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '100440' '' '30000008'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '2' '50' '100690' '제품'           '100440' '10003' '30000008'. " 대변
*  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '3' '40' '100020' '당좌예금'       '401760' '10003' ''. " 차변
*  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '410003' '제품국내매출액' '401760' '10003' ''. " 대변
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

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '100440' '' '30000008'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '2' '50' '100690' '제품'           '100440' '10003' '30000008'. " 대변
*  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '3' '40' '100020' '당좌예금'       '401760' '10003' ''. " 차변
*  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '410003' '제품국내매출액' '401760' '10003' ''. " 대변
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

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '100440' '' '30000008'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '2' '50' '100690' '제품'           '100440' '10003' '30000008'. " 대변
*  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '3' '40' '100020' '당좌예금'       '401760' '10003' ''. " 차변
*  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '410003' '제품국내매출액' '401760' '10003' ''. " 대변
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

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '100440' '' '30000008'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '2' '50' '100690' '제품'           '100440' '10003' '30000008'. " 대변
*  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '3' '40' '100020' '당좌예금'       '401760' '10003' ''. " 차변
*  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '410003' '제품국내매출액' '401760' '10003' ''. " 대변
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

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '93744' '' '30000010'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '2' '50' '100700' '제품'           '93744' '10004' '30000010'. " 대변
*  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '3' '40' '100020' '당좌예금'       '374976' '10004' ''. " 차변
*  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '410004' '제품국내매출액' '374976' '10004' ''. " 대변
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

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '93744' '' '30000010'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '2' '50' '100700' '제품'           '93744' '10004' '30000010'. " 대변
*  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '3' '40' '100020' '당좌예금'       '374976' '10004' '30000010'. " 차변
*  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '410004' '제품국내매출액' '374976' '10004' '30000010'. " 대변
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

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '93744' '' '30000010'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '2' '50' '100700' '제품'           '93744' '10004' '30000010'. " 대변
*  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '3' '40' '100020' '당좌예금'       '374976' '10004' '30000010'. " 차변
*  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '410004' '제품국내매출액' '374976' '10004' '30000010'. " 대변
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

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '93744' '' '30000010'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '2' '50' '100700' '제품'           '93744' '10004' '30000010'. " 대변
*  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '3' '40' '100020' '당좌예금'       '374976' '10004' '30000010'. " 차변
*  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '410004' '제품국내매출액' '374976' '10004' '30000010'. " 대변
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

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '93744' '' '30000010'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '2' '50' '100700' '제품'           '93744' '10005' '30000010'. " 대변
*  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '3' '40' '100020' '당좌예금'       '428544' '10005' '30000011'. " 차변
*  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '410005' '제품국내매출액' '428544' '10005' '30000011'. " 대변
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

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '93744' '' '30000010'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '2' '50' '100700' '제품'           '93744' '10005' '30000010'. " 대변
*  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '3' '40' '100020' '당좌예금'       '428544' '10005' '30000011'. " 차변
*  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '410005' '제품국내매출액' '428544' '10005' '30000011'. " 대변
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

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '93744' '' '30000010'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '2' '50' '100700' '제품'           '93744' '10005' '30000010'. " 대변
*  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '3' '40' '100020' '당좌예금'       '428544' '10005' '30000011'. " 차변
*  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '410005' '제품국내매출액' '428544' '10005' '30000011'. " 대변
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

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '93744' '' '30000010'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '2' '50' '100700' '제품'           '93744' '10005' '30000010'. " 대변
*  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '3' '40' '100020' '당좌예금'       '428544' '10005' '30000011'. " 차변
*  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '410005' '제품국내매출액' '428544' '10005' '30000011'. " 대변
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

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '176768' '' '30000017'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '2' '50' '100720' '제품'           '176768' '10006' '30000017'. " 대변
*  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '3' '40' '100020' '당좌예금'       '707072' '10006' ''. " 차변
*  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '410006' '제품국내매출액' '707072' '10006' ''. " 대변
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

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '176768' '' '30000017'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '2' '50' '100720' '제품' '176768'  '10006' '30000017'. " 대변
*  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '3' '40' '100020' '당좌예금'       '707072' '10006' ''. " 차변
*  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '410006' '제품국내매출액' '707072' '10006' ''. " 대변
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

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '176768' '' '30000017'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '2' '50' '100720' '제품'           '176768' '10006' '30000017'. " 대변
*  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '3' '40' '100020' '당좌예금'       '707072' '10006' ''. " 차변
*  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '410006' '제품국내매출액' '707072' '10006' ''. " 대변
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

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '176768' '' '30000017'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '2' '50' '100720' '제품'           '176768' '10006' '30000017'. " 대변
*  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '3' '40' '100020' '당좌예금'       '707072' '10006' ''. " 차변
*  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '410006' '제품국내매출액' '707072' '10006' ''. " 대변
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

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '93744' '' '30000018'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '2' '50' '100730' '제품' '93744'   '10007'  '30000018'. " 대변
*  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '3' '40' '100020' '당좌예금'       '374976' '10007' ''. " 차변
*  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '410007' '제품국내매출액' '374976' '10007' ''. " 대변
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

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '93744'  '' '30000018'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '2' '50' '100730' '제품' '93744'   '10007'  '30000018'. " 대변
*  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '3' '40' '100020' '당좌예금'       '374976' '10007' ''. " 차변
*  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '410007' '제품국내매출액' '374976' '10007' ''. " 대변
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


  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '93744'  '' '30000018'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '2' '50' '100730' '제품'           '93744'  '10007' '30000018'. " 대변
*  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '3' '40' '100020' '당좌예금'       '374976' '10007' ''. " 차변
*  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '410007' '제품국내매출액' '374976' '10007' ''. " 대변
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

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '93744' '' '30000018'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '2' '50' '100730' '제품'           '93744' '10007' '30000018'. " 대변
*  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '3' '40' '100020' '당좌예금'       '374976' '10007' ''. " 차변
*  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '410007' '제품국내매출액' '374976' '10007' ''. " 대변
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

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '93744'  '' '30000018'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '2' '50' '100730' '제품'           '93744'  '10008' '30000018'. " 대변
*  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '3' '40' '100020' '당좌예금'       '374976' '10008' ''. " 차변
*  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '410008' '제품국내매출액' '374976' '10008' ''. " 대변
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

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '93744'  '' '30000018'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '2' '50' '100730' '제품'           '93744'  '10008' '30000018'. " 대변
*  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '3' '40' '100020' '당좌예금'       '374976' '10008' ''. " 차변
*  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '410008' '제품국내매출액' '374976' '10008' ''. " 대변
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

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '93744'  '' '30000018'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '2' '50' '100730' '제품'           '93744'  '10008' '30000018'. " 대변
*  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '3' '40' '100020' '당좌예금'       '374976' '10008' ''. " 차변
*  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '410008' '제품국내매출액' '374976' '10008' ''. " 대변
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

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '93744'  '' '30000018'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '2' '50' '100730' '제품'           '93744'  '10008' '30000018'. " 대변
*  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '3' '40' '100020' '당좌예금'       '374976' '10008' ''. " 차변
*  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '410008' '제품국내매출액' '374976' '10008' ''. " 대변
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

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '120528' '' '30000023'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '2' '50' '100730' '제품'           '120528'  '10009' '30000023'. " 대변
*  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '3' '40' '100020' '당좌예금'       '482112' '10009' ''. " 차변
*  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '410009' '제품국내매출액' '482112' '10009' ''. " 대변
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

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '120528' '' '30000023'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '2' '50' '100730' '제품'           '120528'  '10009' '30000023'. " 대변
*  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '3' '40' '100020' '당좌예금'       '482112' '10009' ''. " 차변
*  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '410009' '제품국내매출액' '482112' '10009' ''. " 대변
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

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '120528' '' '30000023'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '2' '50' '100730' '제품'           '120528'  '10009' '30000023'. " 대변
*  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '3' '40' '100020' '당좌예금'       '482112' '10009' ''. " 차변
*  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '410009' '제품국내매출액' '482112' '10009' ''. " 대변
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

  _MC_ITEM '1' '40' '510040' '매출원가(제품)' '120528' '' '30000023'. " 차변
  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '2' '50' '100730' '제품'           '120528' '10009' '30000023'. " 대변
*  INSERT ZEA_BSEG FROM GS_BSEG.
*  _MC_ITEM '3' '40' '100020' '당좌예금'       '482112' '10009' ''. " 차변
*  INSERT ZEA_BSEG FROM GS_BSEG.
  _MC_ITEM '2' '50' '410009' '제품국내매출액' '482112' '10009' ''. " 대변
  INSERT ZEA_BSEG FROM GS_BSEG.

  MESSAGE GV_BELNR_NUMBER && '번 전표가 생성되었습니다. ' TYPE 'S'.
  COMMIT WORK AND WAIT.

ENDFORM.
