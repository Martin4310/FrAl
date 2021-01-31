table 5110567 "POI Purch. Price Difference"
{
    Caption = 'Purch. Price Difference';

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(3; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
        }
        field(10; "Master Batch No."; Code[20])
        {
            Caption = 'Master Batch No.';
            TableRelation = "POI Master Batch";
        }
        field(11; "Batch No."; Code[20])
        {
            Caption = 'Batch No.';
            NotBlank = true;
            TableRelation = "POI Batch";
        }
        field(12; "Batch Variant No."; Code[20])
        {
            Caption = 'Batch Variant No.';
            TableRelation = IF (Type = CONST(Item)) "POI Batch Variant"."No." WHERE("Item No." = FIELD("No."));
        }
        field(13; "Batch Var. Detail ID"; Integer)
        {
            Caption = 'Batch Var. Detail ID';
        }
        field(14; "Buy-from Vendor No."; Code[20])
        {
            Caption = 'Buy-from Vendor No.';
            Editable = false;
            TableRelation = Vendor;
        }
        field(15; "Order Address Code"; Code[10])
        {
            Caption = 'Order Address Code';
            TableRelation = "Order Address".Code WHERE("Vendor No." = FIELD("Buy-from Vendor No."));
        }
        field(20; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,G/L Account,Item,,Fixed Asset,Charge (Item)';
            OptionMembers = " ","G/L Account",Item,,"Fixed Asset","Charge (Item)";
        }
        field(21; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(22; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(23; "Unit of Measure Code"; Code[20])
        {
            Caption = 'Unit of Measure Code';
        }
        field(24; "Net Weight"; Decimal)
        {
            Caption = 'Net Weight';
        }
        field(25; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(30; "Price Base (Purch. Price)"; Code[10])
        {
            Caption = 'Price Base (Purch. Price)';
            TableRelation = "POI Price Base".Code WHERE("Purch./Sales Price Calc." = CONST("Purch. Price"),
                                                     Blocked = CONST(false));
        }
        field(31; "Old Purch. Price (Price Base)"; Decimal)
        {
            Caption = 'Purch. Price (Price Base)';
        }
        field(32; "New Purch. Price (Price Base)"; Decimal)
        {
            Caption = 'New Purch. Price (Price Base)';

            trigger OnValidate()
            var
                lrc_PurchaseLine: Record "Purchase Line";
                lrc_PurchaseLineTemp: Record "Purchase Line" temporary;
            begin
                // Neuen Zeilenbetrag ausrechnen
                lrc_PurchaseLine.GET("Document Type", "Document No.", "Document Line No.");
                lrc_PurchaseLineTemp := lrc_PurchaseLine;
                lrc_PurchaseLineTemp.VALIDATE("POI Purch. Price (Price Base)", "New Purch. Price (Price Base)");
                "New Line Amount" := lrc_PurchaseLineTemp."Line Amount";

                // Betragsdifferenz berechnen
                "Line Amount Difference" := "New Line Amount" - "Old Line Amount";

                // Preisdifferenz berechnen
                "Price Difference" := "New Purch. Price (Price Base)" - "Old Purch. Price (Price Base)";
            end;
        }
        field(33; "Price Difference"; Decimal)
        {
            Caption = 'Price Difference';
        }
        field(40; "Old Line Amount"; Decimal)
        {
            Caption = 'Old Line Amount';
        }
        field(41; "New Line Amount"; Decimal)
        {
            Caption = 'New Line Amount';
            Editable = false;
        }
        field(42; "Line Amount Difference"; Decimal)
        {
            Caption = 'Line Amount Difference';
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Document Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        lrc_PurchaseHeader: Record "Purchase Header";
        lrc_PurchaseLine: Record "Purchase Line";
    begin
        lrc_PurchaseHeader.GET("Document Type", "Document No.");
        lrc_PurchaseLine.GET("Document Type", "Document No.", "Document Line No.");

        // Initwerte belegen
        "Order Address Code" := lrc_PurchaseHeader."Order Address Code";
        "Master Batch No." := lrc_PurchaseLine."POI Master Batch No.";
        "Batch No." := lrc_PurchaseLine."POI Batch No.";
        "Batch Variant No." := lrc_PurchaseLine."POI Batch Variant No.";
        "Batch Var. Detail ID" := lrc_PurchaseLine."POI Batch Var. Detail ID";
        "Buy-from Vendor No." := lrc_PurchaseLine."Buy-from Vendor No.";
        Type := lrc_PurchaseLine.Type;
        "No." := lrc_PurchaseLine."No.";
        Description := lrc_PurchaseLine.Description;
        "Unit of Measure Code" := lrc_PurchaseLine."Unit of Measure Code";
        "Net Weight" := lrc_PurchaseLine."Net Weight";
        "Price Base (Purch. Price)" := lrc_PurchaseLine."POI Price Base (Purch. Price)";
        "Old Purch. Price (Price Base)" := lrc_PurchaseLine."POI Purch. Price (Price Base)";
        "Old Line Amount" := lrc_PurchaseLine."Line Amount";
        Quantity := lrc_PurchaseLine.Quantity;
    end;
}

