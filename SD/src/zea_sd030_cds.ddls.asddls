@AbapCatalog.sqlViewName: 'ZEA_SD030_ORDER'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[SD] 판매오더 CDS VIEW 생성'
define view ZEA_SD030_CDS as select from zea_sdt040 as A

inner join zea_sdt050 as B

on A.vbeln = B.vbeln

{
    A.vbeln,
    B.posnr,
    A.cuscode,
    A.saddr,
    A.vdatu,
    A.adatu,
    A.oddat,
    A.toamt,
    A.waers,
    B.matnr,
    B.auqua,
    B.meins,
    B.netpr,
    B.auamo
    
}

where A.loekz <> 'X' // 취소는 제외
