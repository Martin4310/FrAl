table 50003 "POI Print Doc. Source Detail"
{
    Caption = 'Print Document Source Detail';

    fields
    {
        field(1; Source; Option)
        {
            Caption = 'Source';
            DataClassification = CustomerContent;
            Description = ' ,Purchase,Post. Purch.,,Sales,Post. Sales,,Transfer,,,Packerei,,,Sales Clearance Statement,Customs Clearance,Account Sales,Freight Order,Sales Statement,Reminder';
            OptionCaption = ' ,Purchase,Post. Purch.,,Sales,Post. Sales,,Transfer,,,Packerei,,,Sales Clearance Statement,Customs Clearance,Account Sales,Freight Order,Sales Statement,Reminder,Special Conditions';
            OptionMembers = " ",Purchase,"Post. Purch.",,Sales,"Post. Sales",,Transfer,,,Packerei,,,"Sales Clearance Statement","Customs Clearance","Account Sales","Freight Order","Sales Statement",Reminder,"Special Conditions";
        }
        field(2; "Document Type"; Option)
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
            Description = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,,,Transfer,,,Sales Clearance,Customs Clearance,Claim,Recipe,Sort Order,Packing Order,Account Sale,Substitution Order,,Komissionierschein,Reminder';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,,,Transfer,,,Sales Clearance,Customs Clearance,Claim,Recipe,Sort Order,Packing Order,Account Sale,Substitution Order,,Komissionierschein,Reminder';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",,,Transfer,,,"Sales Clearance","Customs Clearance",Claim,Recipe,"Sort Order","Packing Order","Account Sale","Substitution Order",,Komissionierschein,Reminder;
        }
        field(4; "Print Document Code"; Code[20])
        {
            Caption = 'Print Document Code';
            DataClassification = CustomerContent;
        }
        field(7; "Document Subtype Code"; Code[10])
        {
            Caption = 'Document Subtype Code';
            DataClassification = CustomerContent;
            // TableRelation = IF (Source = CONST(Purchase),
            //                     "Document Type" = CONST(Order)) "Purch. Doc. Subtype".Code WHERE("Document Type" = CONST(Order))
            // ELSE
            // IF (Source = CONST(Purchase),
            //                              "Document Type" = CONST(Invoice)) "Purch. Doc. Subtype".Code WHERE("Document Type" = CONST(Invoice))
            // ELSE
            // IF (Source = CONST(Purchase),
            //                                       "Document Type" = CONST("Credit Memo")) "Purch. Doc. Subtype".Code WHERE("Document Type" = CONST("Credit Memo"))
            // ELSE
            // IF (Source = CONST(Sales),
            //                                                "Document Type" = CONST(Order)) "Sales Doc. Subtype".Code WHERE("Document Type" = CONST(Order))
            // ELSE
            // IF (Source = CONST(Sales),
            //                                                         "Document Type" = CONST(Invoice)) "Sales Doc. Subtype".Code WHERE("Document Type" = CONST(Invoice))
            // ELSE
            // IF (Source = CONST(Sales),
            //                                                                  "Document Type" = CONST("Credit Memo")) "Sales Doc. Subtype".Code WHERE("Document Type" = CONST("Credit Memo"));
        }
        field(35; "Report ID"; Integer)
        {
            Caption = 'Report ID';
            DataClassification = CustomerContent;
            TableRelation = Object.ID WHERE(Type = CONST(Report));

            trigger OnValidate()
            begin
                CALCFIELDS("Report Name");
            end;
        }
        field(36; "Report Name"; Text[80])
        {
            CalcFormula = Lookup (AllObjWithCaption."Object Caption" WHERE("Object Type" = CONST(Report), "Object ID" = FIELD("Report ID")));
            Caption = 'Report Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(40; "Source Type"; Option)
        {
            Caption = 'Source Type';
            DataClassification = CustomerContent;
            Description = 'General,Customer,Vendor,Contact,Location,Location Group,Departure Region,Shipping Agent';
            OptionCaption = 'General,Customer,Vendor,Contact,Location,Location Group,Departure Region,Shipping Agent';
            OptionMembers = General,Customer,Vendor,Contact,Location,"Location Group","Departure Region","Shipping Agent";
        }
        field(41; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            DataClassification = CustomerContent;
            // TableRelation = IF ("Source Type" = CONST(Customer)) Customer."No."
            // ELSE
            // IF ("Source Type" = CONST(Vendor)) Vendor."No."
            // ELSE
            // IF ("Source Type" = CONST(Contact)) Contact."No."
            // ELSE
            // IF ("Source Type" = CONST(Location)) Location.Code
            // ELSE
            // IF ("Source Type" = CONST("Location Group")) "Location Group".Code
            // ELSE
            // IF ("Source Type" = CONST("Departure Region")) "Departure Region".Code
            // ELSE
            // IF ("Source Type" = CONST("Shipping Agent")) "Shipping Agent".Code;
        }
        field(50; Release; Boolean)
        {
            Caption = 'Release';
            DataClassification = CustomerContent;
        }
        field(51; "Kind of Release"; Option)
        {
            Caption = 'Kind of Release';
            DataClassification = CustomerContent;
            Description = ' ,Preview,Print,Fax,Mail';
            OptionCaption = ' ,Preview,Print,Fax,Mail';
            OptionMembers = " ",Preview,Print,Fax,Mail;
        }
        field(23; Linenumber; Integer)
        {
            BlankZero = true;
            Caption = 'Zeilennummer';
            DataClassification = CustomerContent;
        }
        field(8; "Filter Location Code"; Code[10])
        {
            Caption = 'Location Code';
            DataClassification = CustomerContent;
            TableRelation = Location;
            ValidateTableRelation = false;
        }
        field(9; "Filter Shipping Agent Code"; Code[10])
        {
            Caption = 'Shipping Agent Code';
            DataClassification = CustomerContent;
            TableRelation = "Shipping Agent";
            ValidateTableRelation = false;
        }
        field(10; "Filter Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            DataClassification = CustomerContent;
            TableRelation = IF ("Source Type" = CONST(Customer)) "Ship-to Address".Code WHERE("Customer No." = FIELD("Source No."));
            ValidateTableRelation = false;
        }
        field(11; "Filter Customer Group Code"; Code[10])
        {
            Caption = 'Customer Group Code';
            DataClassification = CustomerContent;
            //TableRelation = "Customer Group";
            //ValidateTableRelation = false;
        }
        field(12; "Filter Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            DataClassification = CustomerContent;
            TableRelation = Vendor;
            ValidateTableRelation = false;
        }
        field(13; "Filter Vendor Group Code"; Code[10])
        {
            Caption = 'Vendor Group Code';
            DataClassification = CustomerContent;
            //TableRelation = "Vendor Group";
            //ValidateTableRelation = false;
        }
        field(14; "Filter Item Category Code"; Code[10])
        {
            Caption = 'Item Category Code';
            DataClassification = CustomerContent;
            TableRelation = "Item Category";
            ValidateTableRelation = false;
        }
        field(15; "Filter Item Attribute 6"; Code[20])
        {
            CaptionClass = '5110310,1,6';
            Caption = 'Proper Name Code';
            DataClassification = CustomerContent;
            Description = 'EIA';
            //TableRelation = "Proper Name";
            //ValidateTableRelation = false;
        }
        field(16; "Print Certification Typ"; Code[10])
        {
            Caption = 'Certification Typ Code';
            DataClassification = CustomerContent;
            //TableRelation = "Certificate Typs";
        }
        field(17; "Print text module"; Code[10])
        {
            Caption = 'Ausgabe Textbaustein';
            DataClassification = CustomerContent;
            TableRelation = "Standard Text";
        }
        field(18; "Print vendor data"; Boolean)
        {
            Caption = 'Ausgabe Kreditor Daten';
            DataClassification = CustomerContent;
        }
        field(19; "Print purchase data"; Boolean)
        {
            Caption = 'Ausgabe Einkaufsdaten';
            DataClassification = CustomerContent;
        }
        field(20; "Print Attachment 1"; Text[250])
        {
            Caption = 'Ausgabe Anlage 1';
            DataClassification = CustomerContent;
        }
        field(21; "Print Attachment 2"; Text[250])
        {
            Caption = 'Ausgabe Anlage 2';
            DataClassification = CustomerContent;
        }
        field(22; Aktiv; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; Source, "Document Type", "Print Document Code", "Document Subtype Code", "Source Type", "Source No.", "Report ID", Linenumber)
        {
        }
        key(Key2; "Source Type", "Source No.", "Report ID")
        {
        }
    }

    fieldgroups
    {
    }
}

