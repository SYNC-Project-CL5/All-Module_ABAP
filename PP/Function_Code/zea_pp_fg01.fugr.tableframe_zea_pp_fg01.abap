*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZEA_PP_FG01
*   generation date: 2024.04.12 at 10:23:16
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZEA_PP_FG01        .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
