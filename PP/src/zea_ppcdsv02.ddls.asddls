@AbapCatalog.sqlViewName: 'ZEAPPCDSV02'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[PP] 생산오더 CDS View'
@OData.publish: true
define view ZEA_PPCDSV02 as select from zea_aufk as A

inner join zea_ppt020 as B
on B.aufnr = A.aufnr
inner join zea_mmt020 as C
on C.matnr = A.matnr

{
    key A.aufnr as Aufnr,
    A.werks as Werks,
    B.matnr as Matnr,
    C.maktx as Maktx,
//    B.bomid as Bomid,
    B.expqty as Expqty,
    B.expsdate as Expsdate,
    B.expedate as Expedate,
    B.sdate as Sdate,
    B.edate as Edate,
    B.ispdate as Ispdate,
    B.repqty as Repqty,
    B.rqty as Rqty,
    B.unit as Unit
//    A.approval as Approval,
//    A.approver as Approver
}
