@AbapCatalog.sqlViewName: 'ZEASKA1CDS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] SKA1 CDS VIEW'
define view ZEA_SKA1CDS as select from zea_ska1
{
    
 key bpcode as Bpcode,
 key bprole as Bprole,
 bpname as Bpname,
 bpcsnr as Bpcsnr,
 bphaed as Bphaed,
 bpadrr as Bpadrr,
 bpstat as Bpstat,
 zlsch as Zlsch,
 email as Email,
 land1 as Land1       
    
}
