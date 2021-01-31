table 5110549 "POI Sales Freight Costs"
{
    Caption = 'Sales Freight Costs';

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Shipment,Posted Invoice,Posted Credit Memo,Posted Return Receipt';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Shipment,"Posted Invoice","Posted Credit Memo","Posted Return Receipt";
        }
        field(2; "Doc. No."; Code[20])
        {
            Caption = 'Doc. No.';
        }
        field(3; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(4; "Shipping Agent Code"; Code[10])
        {
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";
        }
        field(5; Type; Option)
        {
            Caption = 'Type';
            Description = 'Spediteur,Lager+Spediteur,Lager,Sped.+AbgReg.+Frachteinheit,Leer1,Leer2,Sped.+AbgReg';
            OptionCaption = 'Spediteur,Lager+Spediteur,Lager,Sped.+AbgReg.+Frachteinheit,Leer1,Leer2,Sped.+AbgReg';
            OptionMembers = Spediteur,"Lager+Spediteur",Lager,"Sped.+AbgReg.+Frachteinheit",Leer1,Leer2,"Sped.+AbgReg";
        }
        field(6; "Location Group Code"; Code[10])
        {
            Caption = 'Physical Location Code';
            TableRelation = "POI Location Group";
        }
        field(7; "Departure Region Code"; Code[20])
        {
            Caption = 'Departure Region Code';
            TableRelation = "POI Departure Region" where(RegionType = const(Departure));
        }
        field(8; "Freight Unit Code"; Code[10])
        {
            Caption = 'Freight Unit Code';
            TableRelation = "Unit of Measure" WHERE("POI Is Freight Unit of Measure" = CONST(true));
        }
        field(9; "Arrival Region Code"; Code[20])
        {
            Caption = 'Arrival Region Code';
            TableRelation = "POI Departure Region" where(RegionType = const(Arrival));
        }
        field(10; "Means of Transport Type"; Option)
        {
            Caption = 'Means of Transport Tyoe';
            Description = '  ,LKW,Bahn,Schiff,Flugzeug';
            OptionCaption = ' ,Truck,Train,Ship,Airplane';
            OptionMembers = " ",Truck,Train,Ship,Airplane;
        }
        field(11; "Means of Transport Code"; Code[20])
        {
            Caption = 'Means of Transport Code';
            TableRelation = "POI Means of Transport".Code WHERE(Type = FIELD("Means of Transport Type"));
            ValidateTableRelation = false;
        }
        field(14; "Shipment Date"; Date)
        {
            Caption = 'Shipment Date';
        }
        field(17; "Freight Cost Manual Entered"; Boolean)
        {
            Caption = 'Freight Cost Manual Entered';
        }
        field(18; "Freight Cost Tariff Base"; Option)
        {
            Caption = 'Freight Cost Tariff Base';
            OptionCaption = 'Collo,Pallet,Weight,Pallet Type,Collo Weight,Pallet Weight,Pallet Type Weight,,,,,,,,From Position';
            OptionMembers = Collo,Pallet,Weight,"Pallet Type","Collo Weight","Pallet Weight","Pallet Type Weight",,,,,,,,"From Position";

            trigger OnValidate()
            begin
                VALIDATE("Freight Costs Amount (LCY)");
            end;
        }
        field(19; "Freight Costs Amount (LCY)"; Decimal)
        {
            Caption = 'Freight Costs Amount (LCY)';

            trigger OnValidate()
            var
                lcu_FreightManagement: Codeunit "POI Freight Management";
            begin
                IF "Freight Cost Tariff Base" <> "Freight Cost Tariff Base"::"Collo Weight" THEN
                    IF (Type = Type::"Sped.+AbgReg.+Frachteinheit") THEN
                        lcu_FreightManagement.SalesFreightAllocPerLine(Rec)
                    ELSE
                        // Eingabe Frachtkostenbetrag unzulässig für Satzart %1!
                        ERROR(AGILES_TEXT001Txt, Type);
            end;
        }
        field(20; "Freight Cost Amount"; Decimal)
        {
            Caption = 'Freight Cost Amount';
        }
        field(21; "Freight Cost Amt. in Sales"; Decimal)
        {
            BlankNumbers = BlankZero;
            CalcFormula = Sum ("Sales Line"."POI Freight Costs Amount (LCY)" WHERE("Document Type" = FIELD("Document Type"),
                                                                               "Document No." = FIELD("Doc. No."),
                                                                               "Shipping Agent Code" = FIELD("Shipping Agent Code"),
                                                                               "Shipment No." = FILTER('')));
            Caption = 'Freight Cost Amt. in Sales';
            Description = 'Kalk, In der Auftragswährung';
            Editable = false;
            FieldClass = FlowField;
        }
        field(22; "Freight Cost Price (LCY)"; Decimal)
        {
            Caption = 'Freight Cost Price (LCY)';
        }
        field(23; "Cargo Rate"; Boolean)
        {
            Caption = 'Cargo Rate';
        }
        field(27; "Qty. of Freight Units (SDF)"; Decimal)
        {
            BlankNumbers = BlankZero;
            CalcFormula = Sum ("Sales Line"."POI Quantity (TU)" WHERE("Document Type" = FIELD("Document Type"),
                                                                  "Document No." = FIELD("Doc. No."),
                                                                  Type = CONST(Item),
                                                                  "Shipping Agent Code" = FIELD("Shipping Agent Code"),
                                                                  "POI Departure Region Code" = FIELD("Departure Region Code"),
                                                                  "POI Freight Unit of Meas (FU)" = FIELD("Freight Unit Code")));
            Caption = 'Qty. of Freight Units (SDF)';
            Description = 'Shipping Agent/Departure/Frachteinheit';
            Editable = false;
            FieldClass = FlowField;
        }
        field(30; "Qty. of Colli (SD)"; Decimal)
        {
            BlankNumbers = BlankZero;
            CalcFormula = Sum ("Sales Line".Quantity WHERE("Document Type" = FIELD("Document Type"),
                                                           "Document No." = FIELD("Doc. No."),
                                                           Type = CONST(Item),
                                                           "Shipping Agent Code" = FIELD("Shipping Agent Code"),
                                                           "POI Departure Region Code" = FIELD("Departure Region Code")));
            Caption = 'Qty. of Colli (SD)';
            DecimalPlaces = 0 : 5;
            Description = 'Shipping Agent/Departure';
            Editable = false;
            FieldClass = FlowField;
        }
        field(31; "Qty. of Pallets (SD)"; Decimal)
        {
            BlankNumbers = BlankZero;
            CalcFormula = Sum ("Sales Line"."POI Quantity (TU)" WHERE("Document Type" = FIELD("Document Type"),
                                                                  "Document No." = FIELD("Doc. No."),
                                                                  Type = CONST(Item),
                                                                  "Shipping Agent Code" = FIELD("Shipping Agent Code"),
                                                                  "POI Departure Region Code" = FIELD("Departure Region Code")));
            Caption = 'Qty. of Pallets (SD)';
            DecimalPlaces = 0 : 5;
            Description = 'Shipping Agent/Departure';
            Editable = false;
            FieldClass = FlowField;
        }
        field(32; "Gross Weight (SD)"; Decimal)
        {
            CalcFormula = Sum ("Sales Line"."POI Total Gross Weight" WHERE("Document Type" = FIELD("Document Type"),
                                                                       "Document No." = FIELD("Doc. No."),
                                                                       Type = CONST(Item),
                                                                       "Shipping Agent Code" = FIELD("Shipping Agent Code"),
                                                                       "POI Departure Region Code" = FIELD("Departure Region Code")));
            Caption = 'Gross Weight (SD)';
            Description = 'Shipping Agent/Departure';
            Editable = false;
            FieldClass = FlowField;
        }
        field(33; "Net Weight (SD)"; Decimal)
        {
            CalcFormula = Sum ("Sales Line"."POI Total Net Weight" WHERE("Document Type" = FIELD("Document Type"),
                                                                     "Document No." = FIELD("Doc. No."),
                                                                     Type = CONST(Item),
                                                                     "Shipping Agent Code" = FIELD("Shipping Agent Code"),
                                                                     "POI Departure Region Code" = FIELD("Departure Region Code")));
            Caption = 'Net Weight (SD)';
            Description = 'Shipping Agent/Departure';
            Editable = false;
            FieldClass = FlowField;
        }
        field(35; "Gross Weight (SDF)"; Decimal)
        {
            CalcFormula = Sum ("Sales Line"."POI Total Gross Weight" WHERE("Document Type" = FIELD("Document Type"),
                                                                       "Document No." = FIELD("Doc. No."),
                                                                       Type = CONST(Item),
                                                                       "Shipping Agent Code" = FIELD("Shipping Agent Code"),
                                                                       "POI Departure Region Code" = FIELD("Departure Region Code"),
                                                                       "POI Freight Unit of Meas (FU)" = FIELD("Freight Unit Code")));
            Caption = 'Gross Weight (SDF)';
            Description = 'Shipping Agent/Departure/Frachteinheit';
            Editable = false;
            FieldClass = FlowField;
        }
        field(36; "Net Weight (SDF)"; Decimal)
        {
            CalcFormula = Sum ("Sales Line"."POI Total Net Weight" WHERE("Document Type" = FIELD("Document Type"),
                                                                     "Document No." = FIELD("Doc. No."),
                                                                     Type = CONST(Item),
                                                                     "Shipping Agent Code" = FIELD("Shipping Agent Code"),
                                                                     "POI Departure Region Code" = FIELD("Departure Region Code"),
                                                                     "POI Freight Unit of Meas (FU)" = FIELD("Freight Unit Code")));
            Caption = 'Net Weight (SDF)';
            Description = 'Shipping Agent/Departure/Frachteinheit';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50; "Shipping Agent Name"; Text[50])
        {
            CalcFormula = Lookup ("Shipping Agent".Name WHERE(Code = FIELD("Shipping Agent Code")));
            Caption = 'Shipping Agent Name';
            Description = 'Kalk';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Document Type", "Doc. No.", Type, "Location Code", "Location Group Code", "Departure Region Code", "Shipping Agent Code", "Freight Unit Code")
        {
        }
    }

    trigger OnInsert()
    begin
        IF (Type = Type::Spediteur) OR (Type = Type::"Sped.+AbgReg.+Frachteinheit") THEN
            "Location Code" := ''
        ELSE
            TESTFIELD("Location Code");
    end;

    trigger OnModify()
    begin
        IF Type = Type::Spediteur THEN
            IF "Location Code" <> '' THEN
                // Lagerortcode für Satzart Spediteur nicht zulässig!
                ERROR(AGILES_TEXT002Txt);
    end;

    trigger OnRename()
    begin
        ERROR('Umbenennung nicht zulässig!');
    end;

    var
        AGILES_TEXT001Txt: Label 'Eingabe Frachtkostenbetrag unzulässig für Satzart %1!', Comment = '%1';
        AGILES_TEXT002Txt: Label 'Lagerortcode für Satzart Spediteur nicht zulässig!';
}

