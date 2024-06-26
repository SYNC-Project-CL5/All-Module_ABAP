@AbapCatalog.sqlViewName: 'ZEA_SD040CDS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '판매오더 헤더/아이템 CDS View'
define view ZEA_SD040_CDS 

as select from zea_sdt050 as b
inner join zea_sdt040 as c
    on b.vbeln = c.vbeln
{
    key c.vbeln as Vbeln,
//    key b.vbeln as Vbeln,
    key b.posnr as Posnr,
    c.cuscode as Cuscode,
    c.saddr as Saddr,
    c.vdatu as Vdatu,
    c.adatu as Adatu,
    c.oddat as Oddat,
    @Semantics.amount.currencyCode: 'Waers'
    c.toamt as Toamt,   // 총 주문금액
    @Semantics.currencyCode: true
    c.waers as Waers,
    
    b.matnr as Matnr,
    @Semantics.quantity.unitOfMeasure: 'Meins'
    b.auqua as Auqua,   // 수량
    @Semantics.unitOfMeasure: true
    b.meins as Meins,
    @Semantics.amount.currencyCode: 'Waers'
    b.netpr as Netpr,   // 판매단가
    @Semantics.amount.currencyCode: 'Waers'
    b.auamo as Auamo    // 주문금액
}
