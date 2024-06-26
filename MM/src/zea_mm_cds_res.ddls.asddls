@AbapCatalog.sqlViewName: 'ZEAMMCDSRES'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '소스리스트 CDS VIEW 생성'
define view ZEA_MM_CDS_RES as select from zea_mmt040
{
     key matnr as Matnr,
     key info_no as InfoNo,
     useyn as Useyn,
     ernam as Ernam,
     erdat as Erdat,
     erzet as Erzet,
     aenam as Aenam,
     aedat as Aedat,
     aezet as Aezet
}
