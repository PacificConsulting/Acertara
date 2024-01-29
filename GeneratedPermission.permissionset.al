permissionset 50100 GeneratedPermission
{
    Assignable = true;
    Permissions = tabledata ShipTo_BillTo_Deails = RIMD,
        table ShipTo_BillTo_Deails = X,
        report "BOM Vs Production Cost" = X,
        report "Packing Slip" = X,
        report "Proforma Invoice Report" = X,
        report "Purchase order Report" = X,
        report "Sales Order Report" = X,
        report "Tax Invoice" = X,
        codeunit Events = X,
        page "Pending Production QC Card" = X,
        page "Pending Production QC List" = X,
        page ShipTo_BillTo_Details = X,
        page "user modify" = X;
}