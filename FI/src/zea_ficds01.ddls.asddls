@AbapCatalog.sqlViewName: 'ZEAFICDS01'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] 전표조회'
@OData.publish: true
define view ZEA_FICDS01 
  as select from zea_bkpf as A 
  association [1..*] to zea_bseg as _Bseg
  
  
    on $projection.Belnr  = _Bseg.belnr
               and A.bukrs  = _Bseg.bukrs
               
{
    key A.bukrs as Bukrs,
    key A.belnr as Belnr,
    A.gjahr as Gjahr,
    A.blart as Blart,
    A.bldat as Bldat,
    A.budat as Budat,
    A.bltxt as Bltxt,
    A.xblnr as Xblnr,
    A.ernam as Ernam,
    A.erdat as Erdat,
    A.erzet as Erzet,
    A.aenam as Aenam,
    A.aedat as Aedat,
    A.aezet as Aezet,
    
    _Bseg // Make association public
}
