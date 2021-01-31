table 5110568 "POI Purch. Post. Price Diff."
{

    Caption = 'Post. Purch. Price Difference';

    fields
    {
        field(1;"Source Document Type";Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(2;"Source Document No.";Code[20])
        {
            Caption = 'Document No.';
        }
        field(3;"Source Document Line No.";Integer)
        {
            Caption = 'Document Line No.';
        }
        field(4;"Document Type";Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Archive Quote,Archive Order,Archive Invoice,Archive Credit Memo,Archive Blanket Order,Archive Return Order,,,,,,,,,,Posted Shipment,Posted Invoice,Posted Credit Memo,Posted Return Shipment';
            OptionMembers = "Archive Quote","Archive Order","Archive Invoice","Archive Credit Memo","Archive Blanket Order","Archive Return Order",,,,,,,,,,"Posted Shipment","Posted Invoice","Posted Credit Memo","Posted Return Shipment";
        }
        field(5;"Document No.";Code[20])
        {
            Caption = 'Document No.';
        }
        field(6;"Document Line No.";Integer)
        {
            Caption = 'Document Line No.';
        }
        field(10;"Master Batch No.";Code[20])
        {
            Caption = 'Master Batch No.';
            TableRelation = "POI Master Batch";
        }
        field(11;"Batch No.";Code[20])
        {
            Caption = 'Batch No.';
            NotBlank = true;
            TableRelation = "POI Batch";
        }
        field(12;"Batch Variant No.";Code[20])
        {
            Caption = 'Batch Variant No.';
            TableRelation = IF (Type=CONST(Item)) "POI Batch Variant"."No." WHERE ("Item No."=FIELD("No."));
        }
        field(13;"Batch Var. Detail ID";Integer)
        {
            Caption = 'Batch Var. Detail ID';
        }
        field(14;"Buy-from Vendor No.";Code[20])
        {
            Caption = 'Buy-from Vendor No.';
            Editable = false;
            TableRelation = Vendor;
        }
        field(15;"Order Address Code";Code[10])
        {
            Caption = 'Order Address Code';
            TableRelation = "Order Address".Code WHERE ("Vendor No."=FIELD("Buy-from Vendor No."));
        }
        field(20;Type;Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,G/L Account,Item,,Fixed Asset,Charge (Item)';
            OptionMembers = " ","G/L Account",Item,,"Fixed Asset","Charge (Item)";
        }
        field(21;"No.";Code[20])
        {
            Caption = 'No.';
        }
        field(22;Description;Text[50])
        {
            Caption = 'Description';
        }
        field(23;"Unit of Measure Code";Code[20])
        {
            Caption = 'Unit of Measure Code';
        }
        field(24;"Net Weight";Decimal)
        {
            Caption = 'Net Weight';
        }
        field(25;Quantity;Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(30;"Price Base (Purch. Price)";Code[10])
        {
            Caption = 'Price Base (Purch. Price)';
            TableRelation = "POI Price Base".Code WHERE ("Purch./Sales Price Calc."=CONST("Purch. Price"),
                                                     Blocked=CONST(false));
        }
        field(31;"Old Purch. Price (Price Base)";Decimal)
        {
            Caption = 'Purch. Price (Price Base)';
        }
        field(32;"New Purch. Price (Price Base)";Decimal)
        {
            Caption = 'New Purch. Price (Price Base)';
        }
        field(33;"Price Difference";Decimal)
        {
            Caption = 'Price Difference';
        }
        field(40;"Old Line Amount";Decimal)
        {
            Caption = 'Old Line Amount';
        }
        field(41;"New Line Amount";Decimal)
        {
            Caption = 'New Line Amount';
            Editable = false;
        }
        field(42;"Line Amount Difference";Decimal)
        {
            Caption = 'Line Amount Difference';
        }
        field(50;Status;Option)
        {
            Caption = 'Status';
            OptionCaption = 'Open,Closed,Posted';
            OptionMembers = Open,Closed,Posted;
        }
        field(51;"Temp. Document Type";Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(52;"Temp. Document No.";Code[20])
        {
            Caption = 'Document No.';
        }
        field(53;"Temp. Document Line No.";Integer)
        {
            Caption = 'Document Line No.';
        }
    }

    keys
    {
        key(Key1;"Document Type","Document No.","Document Line No.")
        {
        }
        key(Key2;"Buy-from Vendor No.","Order Address Code",Status)
        {
        }
        key(Key3;Status)
        {
        }
        key(Key4;"Temp. Document Type","Temp. Document No.","Temp. Document Line No.",Status)
        {
        }
    }
}

