*&---------------------------------------------------------------------*
*& Include          YE00_EX007TOP
*&---------------------------------------------------------------------*

*-- Database Table에서 조회 후 출력을 위한 Internal Tables
DATA: BEGIN OF GS_HEADER,
        CARRID    LIKE SCARR-CARRID,
        CARRNAME  LIKE SCARR-CARRNAME,
        CONNID    LIKE SPFLI-CONNID,
        COUNTRYFR LIKE SPFLI-COUNTRYFR,
        CITYFROM  LIKE SPFLI-CITYFROM,
        AIRPFROM  LIKE SPFLI-AIRPFROM,
        COUNTRYTO LIKE SPFLI-COUNTRYTO,
        CITYTO    LIKE SPFLI-CITYTO,
        AIRPTO    LIKE SPFLI-AIRPTO,
      END OF GS_HEADER,
      GT_HEADER LIKE TABLE OF GS_HEADER.

DATA: BEGIN OF GS_DISPLAY,
        CARRID      LIKE SCARR-CARRID,
        CARRNAME    LIKE SCARR-CARRNAME,
        CONNID      LIKE SPFLI-CONNID,
        COUNTRYFR   LIKE SPFLI-COUNTRYFR,
        CITYFROM    LIKE SPFLI-CITYFROM,
        AIRPFROM    LIKE SPFLI-AIRPFROM,
        COUNTRYTO   LIKE SPFLI-COUNTRYTO,
        CITYTO      LIKE SPFLI-CITYTO,
        AIRPTO      LIKE SPFLI-AIRPTO,
        FLDATE      LIKE SFLIGHT-FLDATE,
        PAYMENTSUM  LIKE SFLIGHT-PAYMENTSUM,
        PRICE       LIKE SFLIGHT-PRICE,
        CURRENCY    LIKE SFLIGHT-CURRENCY,
        PLANETYPE   LIKE SFLIGHT-PLANETYPE,
        SEATSMAX_T  LIKE SFLIGHT-SEATSMAX,
        SEATSOCC_T  LIKE SFLIGHT-SEATSOCC,
        SEATSFRE_T  LIKE SFLIGHT-SEATSOCC,
        SEATSMAX    LIKE SFLIGHT-SEATSMAX,
        SEATSOCC    LIKE SFLIGHT-SEATSOCC,
        SEATSMAX_B  LIKE SFLIGHT-SEATSMAX_B,
        SEATSOCC_B  LIKE SFLIGHT-SEATSOCC_B,
        SEATSMAX_F  LIKE SFLIGHT-SEATSMAX_F,
        SEATSOCC_F  LIKE SFLIGHT-SEATSOCC_F,
      END OF GS_DISPLAY,

      GT_DISPLAY LIKE TABLE OF GS_DISPLAY.


*-- SCREEN 관련 변수
CONSTANTS: GC_CUSTOM_CONTAINER_NAME TYPE SCRFNAME VALUE 'CCON'.
DATA: OK_CODE TYPE SY-UCOMM.

DATA: GO_DOCKING_CONTAINER  TYPE REF TO CL_GUI_DOCKING_CONTAINER, " TREE용
      GO_DOCK               TYPE REF TO CL_GUI_DOCKING_CONTAINER, " ALV 세부 데이터용
      GT_DOCK               LIKE TABLE OF GO_DOCK,                " GO_DOCK을 쌓아둘 ITAB
      GO_CUSTOM_CONTAINER   TYPE REF TO CL_GUI_CUSTOM_CONTAINER,

      GO_SIMPLE_TREE        TYPE REF TO CL_GUI_SIMPLE_TREE,
      GO_ALV_GRID           TYPE REF TO CL_GUI_ALV_GRID.

*-- ALV 관련 변수
DATA: GS_LAYOUT             TYPE LVC_S_LAYO,
      GT_FIELDCAT           TYPE LVC_T_FCAT,
      GS_FIELDCAT           LIKE LINE OF GT_FIELDCAT,
      GT_SORT               TYPE LVC_T_SORT,
      GS_SORT               LIKE LINE OF GT_SORT,
      GS_VARIANT            TYPE DISVARIANT,
      GV_SAVE               TYPE C.

*-- TREE 관련 변수
DATA: GT_NODE               TYPE TABLE OF MTREESNODE,
      GS_NODE               LIKE LINE OF GT_NODE,
      GV_NODE_KEY           TYPE N LENGTH 6.

DATA: BEGIN OF GS_NODE_INFO,
        NODE_KEY LIKE MTREESNODE-NODE_KEY,
        CARRID   LIKE SCARR-CARRID,
        CONNID   LIKE SPFLI-CONNID,
        COUNTRYFR LIKE SPFLI-COUNTRYFR,
        CITYFROM LIKE SPFLI-CITYFROM,
      END OF GS_NODE_INFO,

      GT_NODE_INFO LIKE TABLE OF GS_NODE_INFO.
