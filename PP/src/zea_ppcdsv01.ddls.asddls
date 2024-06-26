@AbapCatalog.sqlViewName: 'ZEAPPCDSV01'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[PP] 생산계획 CDS View'
@OData.publish: true
define view ZEA_PPCDSV01 
    as select from zea_plaf as a    // 생산계획 Header
    association [0..*] to zea_ppt010 as _ProductionPlan // 생산계획 Item
     
    on $projection.Planid = _ProductionPlan.planid
{
    key a.planid as Planid,
        a.werks as Werks,
//        a.sapnr as Sapnr,
        a.pdpdat as Pdpdat,
        a.pdpli as Pdpli,
        a.loekz as Loekz,
//        a.ernam as Ernam,
//        a.erdat as Erdat,
//        a.erzet as Erzet,
//        a.aenam as Aenam,
//        a.aedat as Aedat,
//        a.aezet as Aezet,
    
    
    _ProductionPlan // Make association public
}
