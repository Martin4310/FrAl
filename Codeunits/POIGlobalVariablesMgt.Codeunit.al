codeunit 5110358 "POI Global Variables Mgt."
{
    var
        // gbn_DirectCall: Boolean;
        // gbn_SalesShipment: Boolean;
        // gbn_SalesInvoice: Boolean;
        // gbn_PurchaseReceive: Boolean;
        // gbn_PurchaseInvoice: Boolean;
        // gco_LocationCode: Code[10];
        gco_IS_CustumerNo: Code[20];
        gdt_IS_OrderDate: Date;
        gdt_IS_ShipmentDate: Date;
        gdc_IS_PromisedDeliveryDate: Date;
        gco_IS_SearchDescription: Code[50];
        gco_IS_ProductGroup: Code[20];
        gco_IS_ItemNo2Filter: Code[20];
        gco_IS_ItemNoFilter: Code[20];
        gbn_IS_Activ: Boolean;
        gop_IS_Source: Option Purchase,Sales,Transfer;
    // gin_TableNo: Integer;
    // gva_GlobalVariant: Variant;
    // gbn_ModActivateFromSync: Boolean;
    // gin_ModActivateFromSyncTableNo: Integer;
    // gbn_ValActivateFromSync: Boolean;
    // gin_ValActivateFromSyncTableNo: Integer;
    // gin_ValActivateFromSyncFieldNo: Integer;
    // gin_ScannerAction: Integer;
    // gin_ScannerActionStep: Integer;
    // gbn_DirectChange: Boolean;

    procedure ItemSearchSetGlobalValues(vco_CustumerNo: Code[20]; vdt_OrderDate: Date; vdt_ShipmentDate: Date; vdc_PromisedDeliveryDate: Date; vco_SearchDescription: Code[50]; vco_ProductGroup: Code[20]; vco_ItemNo2Filter: Code[20]; vco_ItemNoFilter: Code[20]; vbn_Activ: Boolean; vop_Source: Option Purchase,Sales,Transfer)
    begin
        // ------------------------------------------------------------------------------------------
        // Funktion zur Übergabe von Variablen für die Artikelsuche
        // ------------------------------------------------------------------------------------------

        gco_IS_CustumerNo := vco_CustumerNo;
        gdt_IS_OrderDate := vdt_OrderDate;
        gdt_IS_ShipmentDate := vdt_ShipmentDate;
        gdc_IS_PromisedDeliveryDate := vdc_PromisedDeliveryDate;
        gco_IS_SearchDescription := vco_SearchDescription;
        gco_IS_ProductGroup := vco_ProductGroup;
        gco_IS_ItemNo2Filter := vco_ItemNo2Filter;
        gco_IS_ItemNoFilter := vco_ItemNoFilter;
        gbn_IS_Activ := vbn_Activ;
        gop_IS_Source := vop_Source;
    end;

    procedure SetDirectCall(vbn_DirectCall: Boolean)
    begin
        // ------------------------------------------------------------------------------------------
        // Funktion zum Setzen einer Variablen ob es sich um einen direkten Aufruf handelt
        // ------------------------------------------------------------------------------------------

        gbn_DirectCall := vbn_DirectCall;
    end;

    procedure SetGlobalVariant(vin_TableNo: Integer; vva_Variant: Variant)
    begin
        gin_TableNo := vin_TableNo;
        gva_GlobalVariant := vva_Variant;
    end;

    var
        gbn_DirectCall: Boolean;
        gin_TableNo: Integer;
        gva_GlobalVariant: Variant;
}