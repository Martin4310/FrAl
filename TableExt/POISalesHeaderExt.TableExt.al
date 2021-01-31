tableextension 50040 "POI Sales Header Ext" extends "Sales Header"
{
    fields
    {
        field(5110306; "POI Person in Charge Code"; Code[10])
        {
            Caption = 'Person in Charge Code';
            TableRelation = "Salesperson/Purchaser"; // WHERE ("inactive NAV User"=FILTER(false));

            trigger OnLookup()
            var
                lr_SalesPurch: Record "Salesperson/Purchaser";
            begin
                lr_SalesPurch.FILTERGROUP(2);
                lr_SalesPurch.SETRANGE("POI Is Person in Charge", TRUE);
                lr_SalesPurch.FILTERGROUP(0);
                IF Page.RUNMODAL(0, lr_SalesPurch) = ACTION::LookupOK THEN
                    VALIDATE("POI Person in Charge Code", lr_SalesPurch.Code);
            end;

            trigger OnValidate()
            var
                lr_SalesPurch: Record "Salesperson/Purchaser";
            begin
                IF lr_SalesPurch.GET("POI Person in Charge Code") THEN;
            end;
        }
        field(5110307; "POI Kind of Settlement"; Option)
        {
            Caption = 'Kind of Settlement';
            Description = 'Fix Price,Commission';
            OptionCaption = 'Fix Price,Commission';
            OptionMembers = "Fix Price",Commission;
        }
        field(5110310; "POI Sales Doc. Subtype Code"; Code[10])
        {
            Caption = 'Sales Doc. Subtype Code';
            Description = 'DST';
            TableRelation = "POI Sales Doc. Subtype".Code WHERE("Document Type" = FIELD("Document Type"));
        }
        field(5110311; "Waste Disposal Duty"; Option)
        {
            Caption = 'Waste Disposal Duty';
            Description = 'DSD';
            OptionCaption = ' ,DSD Duty,ARA Duty';
            OptionMembers = " ","DSD Duty","ARA Duty";

            trigger OnValidate()
            begin
                UpdateSalesLines(copystr(FIELDCAPTION("Waste Disposal Duty"), 1, 100), FALSE);
            end;
        }
        field(5110330; "POI Sales Claim Notify No."; Code[20])
        {
            Caption = 'Sales Claim Notify No.';
            Description = 'VKR';
            TableRelation = "POI Sales Claim Notify Header";
        }
        field(5110355; "POI Status Customs Duty"; Option)
        {
            Caption = 'Status Customs Duty';
            Description = ' ,Payed,Not Payed';
            OptionCaption = ' ,Payed,Not Payed';
            OptionMembers = " ",Payed,"Not Payed";

            trigger OnValidate()
            var
                lrc_ShipmentMethod: Record "Shipment Method";
            begin
                // Kontrolle ob Wert mit Lieferbedingung übereinstimmt
                IF lrc_ShipmentMethod.GET("Shipment Method Code") THEN BEGIN
                    IF (lrc_ShipmentMethod."POI Duty Paid" = TRUE) AND ("POI Status Customs Duty" = "POI Status Customs Duty"::"Not Payed") THEN
                        // Lieferbedingung abweichend!
                        ERROR(AGILES_TEXT011Txt);
                    IF (lrc_ShipmentMethod."POI Duty Paid" = FALSE) AND ("POI Status Customs Duty" = "POI Status Customs Duty"::Payed) THEN
                        // Lieferbedingung abweichend!
                        ERROR(AGILES_TEXT011Txt);
                END;
                // Werte auf alle Zeilen übertragen
                UpdateSalesLines(copystr(FIELDCAPTION("POI Status Customs Duty"), 1, 100), FALSE);
            end;
        }
        field(5110365; "POI Means of Transport Type"; Option)
        {
            Caption = 'Means of Transport Type';
            Description = ' ,Truck,Train,Ship,Airplane';
            OptionCaption = ' ,Truck,Train,Ship,Airplane';
            OptionMembers = " ",Truck,Train,Ship,Airplane;
        }
        field(5110366; "Means of Transport Code"; Code[20])
        {
            Caption = 'Means of Transport Code';
            TableRelation = "POI Means of Transport".Code WHERE(Type = FIELD("POI Means of Transport Type"));
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                lrc_MeansofTransport: Record "POI Means of Transport";
            begin
                IF lrc_MeansofTransport.GET("POI Means of Transport Type", "Means of Transport Code") THEN
                    IF lrc_MeansofTransport."Means of Transport Info" <> '' THEN
                        VALIDATE("POI Means of Transport Info", lrc_MeansofTransport."Means of Transport Info");
            end;
        }
        field(5110367; "POI Means of Transport Info"; Code[30])
        {
            Caption = 'Means of Transport Info';
            TableRelation = "POI Means of Transport Info".Code;
            ValidateTableRelation = false;
        }
        field(5110368; "POI Arrival Region Code"; Code[20])
        {
            Caption = 'Arrival Region Code';
            TableRelation = "POI departure Region" where(RegionType = const(Arrival));
        }
        field(5110370; "POI Location Reference No."; Code[20])
        {
            Caption = 'Location Reference No.';
        }
        field(5110371; "POI Freight Calculation"; Option)
        {
            Caption = 'Freight Calculation';
            Description = 'Standard,Manual in Line';
            OptionCaption = 'Standard,Manual in Line';
            OptionMembers = Standard,"Manual in Line";

            trigger OnValidate()
            var
                lcu_FreightManagement: Codeunit "POI Freight Management";
            begin
                IF "POI Freight Calculation" <> xRec."POI Freight Calculation" THEN
                    lcu_FreightManagement.SalesFreightCostsPerOrder(Rec);
            end;
        }
        field(5110392; "POI Shipment Time From"; Time)
        {
            Caption = 'Shipment Time From';
        }
        field(5110594; "POI Assortment Version No."; Code[20])
        {
            Caption = 'Assortment Version No.';
            TableRelation = "POI Assortment Version";
        }
    }
    var
        AGILES_TEXT011Txt: Label 'Shipment Method not the same!';
}