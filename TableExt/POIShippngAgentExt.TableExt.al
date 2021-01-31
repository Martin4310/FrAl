tableextension 50025 "POI Shippng Agent Ext" extends "Shipping Agent"
{
    fields
    {
        field(50000; "POI Blocked"; Boolean)
        {
            Caption = 'Blocked';
            DataClassification = CustomerContent;
        }
        field(50001; "POI Freight Cost Tariff Base"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Freight Cost Tarif Base';
            OptionCaption = 'Collo,Pallet,Weight,Pallet Type,Collo Weight,Pallet Weight,Pallet Type Weight';
            OptionMembers = Collo,Pallet,Weight,"Pallet Type","Collo Weight","Pallet Weight","Pallet Type Weight";
        }
        field(50002; "POI Freight Cost Tariff Level"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Freight Cost Tarif Level';
            OptionCaption = ' ,Location Group,Locations,Departure Region';
            OptionMembers = " ","Location Group",Locations,"Departure Region";
        }
        field(50003; "POI Vendor No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor No.';
            TableRelation = Vendor."No." where("POI Is Shipping Agent" = const(true));
            trigger OnLookup()
            var
                POCard: page "Purchase Order";
            begin
                "POI Vendor No." := POCard.OnlookupVendor('SHIPAGENT');
            end;
        }
        field(5110362; "POI Freight Cost Ref. Weight"; Option)
        {
            Caption = 'Freight Cost Ref. Weight';
            Description = ' ,Net Weight,Gross Weight';
            OptionCaption = ' ,Net Weight,Gross Weight';
            OptionMembers = " ","Net Weight","Gross Weight";
        }
        field(5110391; "POI Freight Tolerance"; Decimal)
        {
            Caption = 'Freight Tolerance';
        }
        field(5110420; "POI Empties Allocation"; Option)
        {
            Caption = 'Empties Allocation';
            Description = 'LVW';
            OptionCaption = 'Without Stock-Keeping Without Invoice,With Stock-Keeping Without Invoice,With Stock-Keeping With Invoice';
            OptionMembers = "Without Stock-Keeping Without Invoice","With Stock-Keeping Without Invoice","With Stock-Keeping With Invoice";

            trigger OnValidate()
            begin
                IF "POI Empties Allocation" <> "POI Empties Allocation"::"Without Stock-Keeping Without Invoice" THEN
                    IF ("POI Empties Calculation" <> "POI Empties Calculation"::"Separat Document") THEN
                        "POI Empties Calculation" := "POI Empties Calculation"::"Separat Document";
            end;
        }
        field(5110421; "POI Empties Calculation"; Option)
        {
            Caption = 'Empties Calculation';
            Description = 'LVW';
            OptionCaption = ' ,Same Document,Separat Document,Combine Document';
            OptionMembers = " ","Same Document","Separat Document","Combine Document";

            trigger OnValidate()
            begin
                IF ("POI Empties Calculation" = "POI Empties Calculation"::"Same Document") THEN
                    ERROR(AGILES_TEXT001Txt, AGILES_TEXT002Txt);
                IF ("POI Empties Calculation" = "POI Empties Calculation"::"Combine Document") THEN
                    ERROR(AGILES_TEXT003Txt);
            end;
        }
        field(5110422; "POI Empties Price Group"; Code[20])
        {
            Caption = 'Empties Price Group';
            Description = 'LVW';
            TableRelation = "POI Empties Price Groups".Code;
        }
        field(5110330; "POI Ship.-Ag. Vendor No."; Code[20])
        {
            Caption = 'Ship.-Ag. Vendor No.';
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                VendorNo_Validate();
            end;
        }
    }
    procedure VendorNo_Validate()
    var
        lrc_Vendor: Record Vendor;
    begin
        // --------------------------------------------------------------------------------------------------------------
        // Funktion zur Validierung der Vendor No.
        // --------------------------------------------------------------------------------------------------------------

        IF "POI Ship.-Ag. Vendor No." <> '' THEN
            // Möchten Sie die Adressdaten aus dem Kreditor übernehmen?
            IF CONFIRM(AGILES_TEXT001Txt) THEN BEGIN
                lrc_Vendor.GET("POI Ship.-Ag. Vendor No.");
                IF Name = '' THEN
                    Name := copystr(lrc_Vendor.Name, 1, 50);
                // "Ship.-Ag. Name" := lrc_Vendor.Name;
                // "Ship.-Ag. Name 2" := lrc_Vendor."Name 2";
                // "Ship.-Ag. Address" := lrc_Vendor.Address;
                // "Ship.-Ag. Address 2" := lrc_Vendor."Address 2";
                // "Ship.-Ag. Post Code" := lrc_Vendor."Post Code";
                // "Ship.-Ag. City" := lrc_Vendor.City;
                // "Ship.-Ag. Country Code" := lrc_Vendor."Country/Region Code";
                // "Ship.-Ag. Primary Contact No." := lrc_Vendor."Primary Contact No.";
                // "Ship.-Ag. Contact" := lrc_Vendor.Contact;
                // "Ship.-Ag. Phone No." := lrc_Vendor."Phone No.";
                // "Ship.-Ag. Fax No." := lrc_Vendor."Fax No.";
                // "Ship.-Ag. E-Mail" := lrc_Vendor."E-Mail";
                // "Ship.-Ag. Language Code" := lrc_Vendor."Language Code";
                // "Ship.-Ag. County" := lrc_Vendor.County;
            END;
    end;

    var
        AGILES_TEXT001Txt: Label 'On shipping agent, this value must be %1 !', Comment = '%1';
        AGILES_TEXT002Txt: Label 'separat document or combine document';
        AGILES_TEXT003Txt: Label 'The selection combine document ist not possible !';
}