*&---------------------------------------------------------------------*
*& Module Pool      SAPMZ_ZEA_GL_DISPLAY
*&---------------------------------------------------------------------*
*& [FI] 전표조회 프로그램 2024.04.14 [완료] 상세 전표 View_ACA5-17 이세영
*&---------------------------------------------------------------------*
*& [2024.04.18 / 단위 테스트 완료] - [PM] 김건우 : o
*&---------------------------------------------------------------------*
PROGRAM SAPMZ_ZEA_FI020 MESSAGE-ID ZEA_MSG.

include MZ_ZEA_GL_DISPLAY_TOP.  " Global Data
INCLUDE MZ_ZEA_GL_DISPLAY_CLS.  " ALV Events
include MZ_ZEA_GL_DISPLAY_PB0.  " PBO-Modules
include MZ_ZEA_GL_DISPLAY_PAI.  " PAI-Modules
INCLUDE MZ_ZEA_GL_DISPLAY_F01.  " FORM-Routines
