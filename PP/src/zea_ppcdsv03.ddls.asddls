@AbapCatalog.sqlViewName: 'ZEAPPCDSV03'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '생산실적 조회'
@OData.publish: true

define view ZEA_PPCDSV03 as select from zea_afru as a
left outer join zea_mmt020 as b on b.matnr = a.matnr
                          and b.spras = $session.system_language
{
    key a.aufnr as Aufnr,
    a.charg as Charg,
    a.matnr as Matnr,
    b.maktx as Maktx,
    a.bomid as Bomid,
    a.empcode as Empcode,
    a.tsdat as Tsdat,
    @Semantics.quantity.unitOfMeasure: 'meins'
    a.pdquan as Pdquan,
    @Semantics.quantity.unitOfMeasure: 'meins'
    a.pdban as Pdban,
    @Semantics.quantity.unitOfMeasure: 'meins'
    a.fnpd as Fnpd,
    a.meins as Meins,
    a.defreason as Defreason,
    a.loekz as Loekz,
    a.ernam as Ernam,
    a.erdat as Erdat,
    a.erzet as Erzet,
    a.aenam as Aenam,
    a.aedat as Aedat,
    a.aezet as Aezet    
}
