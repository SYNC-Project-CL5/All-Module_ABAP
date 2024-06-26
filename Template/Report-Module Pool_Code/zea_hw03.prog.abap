*&---------------------------------------------------------------------*
*& Report ZMEETROOM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE ZEA_HW03TOP.
*INCLUDE zmeetroomtop                            .    " Global Data

INCLUDE ZEA_HW03S01.
*INCLUDE zmeetrooms01                            .  " Selection screen
INCLUDE ZEA_HW03C01.
*INCLUDE zmeetroomc01                            .  " ALV Events
INCLUDE ZEA_HW03O01.
*INCLUDE zmeetroomo01                            .  " PBO-Modules
INCLUDE ZEA_HW03I01.
*INCLUDE zmeetroomi01                            .  " PAI-Modules
INCLUDE ZEA_HW03F01.
*INCLUDE zmeetroomf01                            .  " FORM-Routines


**********************************************************************
* INITIALIZATION
**********************************************************************
INITIALIZATION.
  PERFORM set_init_value.

**********************************************************************
* START-OF-SELECTION
**********************************************************************
START-OF-SELECTION.

  PERFORM get_base_data.
  PERFORM screen_change.

  CALL SCREEN 100.
