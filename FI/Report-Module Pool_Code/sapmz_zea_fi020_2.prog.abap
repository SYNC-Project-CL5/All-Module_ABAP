
*&---------------------------------------------------------------------*
*& Module Pool      SAPMZ_ZEA_GL_DISPLAY
*&---------------------------------------------------------------------*
*& [FI] 전표조회 프로그램 2024.04.14 [완료] 상세 전표 View_ACA5-17 이세영
*&---------------------------------------------------------------------*
*& [2024.04.18 / 단위 테스트 완료] - [PM] 김건우 : o
*& #원래는 전표상세조회-반제전표 클릭 시, 본 프로그램 call하여
*&  반제전표를 바로바로 트레킹할 수 있도록 하려함. 근데 현재 인클루드 엮여서
*&  오류남. 현재 클레스 정의, 셋,겟 세팅 끝남. 인클루드 프로그램 싹 정리하고
*&  재 세팅 필요함. 왜냐하면 그렇지 않으면 미결 프로그램에서만 반제전표 트레킹 됨.
*&  타 프로그램에서도 트레킹 할 수 있도록 하고싶음.
*&---------------------------------------------------------------------*
PROGRAM SAPMZ_ZEA_FI020_2 MESSAGE-ID ZEA_MSG.

include MZ_ZEA_GL_DISPLAY_2_TOP.  " Global Data
include MZ_ZEA_GL_DISPLAY_2_PB0.  " PBO-Modules
include MZ_ZEA_GL_DISPLAY_2_PAI.  " PAI-Modules
INCLUDE MZ_ZEA_GL_DISPLAY_2_F01.  " FORM-Routines
