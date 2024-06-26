@AbapCatalog.sqlViewName: 'ZEAMMLOC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '저장위치 CDS 뷰'
define view ZEA_MM_LOC as select from zea_mmt060

   
{
    key werks as Werks,
    key scode as Scode,
    stype as Stype,
    sname as Sname,
    sttel as Sttel,
    address as Address,
    telno as Telno,
    ernam as Ernam,
    erdat as Erdat,
    erzet as Erzet,
    aenam as Aenam,
    aedat as Aedat,
    aezet as Aezet
}
