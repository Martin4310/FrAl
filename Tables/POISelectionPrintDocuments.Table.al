table 50016 "POI Selection Print Documents"
{
    Caption = 'Selection Print Documents';

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,,,Posted Receipt/Shipment,Posted Invoice,,,,,Transfer,,,Freight Order,,,Sales Claim,Purchase Claim';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",,,"Posted Receipt/Shipment","Posted Invoice",,,,,Transfer,,,"Freight Order",,,"Sales Claim","Purchase Claim";
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(3; "Print Doc. ID"; Integer)
        {
            Caption = 'Print Doc. ID';
            DataClassification = CustomerContent;
        }
        field(4; "Print Doc. Code"; Code[20])
        {
            Caption = 'Print Doc. Code';
            DataClassification = CustomerContent;
            TableRelation = "POI Print Documents";
        }
        field(5; "Detail Code"; Code[20])
        {
            Caption = 'Detail Code';
            DataClassification = CustomerContent;
            TableRelation = IF ("Multiple Entry for" = CONST("Shipping Agent")) "Shipping Agent"
            ELSE
            IF ("Multiple Entry for" = CONST(Location)) Location;
        }
        field(6; Source; Option)
        {
            Caption = 'Source';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Purchase,Post. Purch.,,Sales,Post. Sales,,Transfer,,,Packerei,,,Sales Clearance Statement,Customs Clearance,Account Sales,Freight Order,Sales Statement,Sales Claim,Purchase Claim';
            OptionMembers = " ",Purchase,"Post. Purch.",,Sales,"Post. Sales",,Transfer,,,Packerei,,,"Sales Clearance Statement","Customs Clearance","Account Sales","Freight Order","Sales Statement","Sales Claim","Purchase Claim",ReportID;
        }
        field(7; "Posted Document Type"; Option)
        {
            Caption = 'Posted Doc. Type';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Posted Receipt/Shipment,Posted Invoice,Posted Credit Memo,Posted Return Shipment/Receipt';
            OptionMembers = " ","Posted Receipt/Shipment","Posted Invoice","Posted Credit Memo","Posted Return Shipment/Receipt";
        }
        field(10; "Print Document Description"; Text[50])
        {
            Caption = 'Print Document Description';
            DataClassification = CustomerContent;
        }
        field(11; "Sort Order"; Integer)
        {
            Caption = 'Sort Order';
            DataClassification = CustomerContent;
        }
        field(12; Release; Boolean)
        {
            Caption = 'Release';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                lrc_SelectionPrintDoc: Record "POI Selection Print Documents";
                lrc_PrintDoc: Record "POI Print Documents";
            begin

                IF Release = TRUE THEN
                    // Source,"Document Type","Print Doc. Code"
                    IF lrc_PrintDoc.GET("Print Doc. Code") THEN
                        IF (lrc_PrintDoc."Print only this Doc." = TRUE) THEN BEGIN

                            lrc_SelectionPrintDoc.SETRANGE(Source, Source);
                            lrc_SelectionPrintDoc.SETRANGE("Document Type", "Document Type");
                            lrc_SelectionPrintDoc.SETRANGE("Document No.", "Document No.");
                            lrc_SelectionPrintDoc.SETFILTER("Print Doc. Code", '<>%1', "Print Doc. Code");

                            lrc_SelectionPrintDoc.MODIFYALL(Release, FALSE, FALSE);
                        END;
            end;
        }
        field(13; "Kind of Release"; Option)
        {
            Caption = 'Kind of Release';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Preview,Print,Fax,Mail';
            OptionMembers = " ",Preview,Print,Fax,Mail;

            trigger OnValidate()
            begin
                IF "Kind of Release" = "Kind of Release"::" " THEN
                    VALIDATE(Release, FALSE)
                ELSE
                    VALIDATE(Release, TRUE);
            end;
        }
        field(15; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            DataClassification = CustomerContent;
            TableRelation = Language;
        }
        field(18; "Mailing Group Code"; Code[10])
        {
            Caption = 'Mailing Group Code';
            DataClassification = CustomerContent;
            TableRelation = "Mailing Group";
        }
        field(20; Consignee; Option)
        {
            Caption = 'Consignee';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Order Address,,,Delivery Adress,,,Invoice Adress,,,Departure Warehouse,Arrival Warehouse,Shipowning Company,Shipping Agent,,,Customer Clearance,,,Quality Control';
            OptionMembers = " ","Order Address",,,"Delivery Adress",,,"Invoice Adress",,,"Departure Warehouse","Arrival Warehouse","Shipowning Company","Shipping Agent",,,"Customer Clearance",,,"Quality Control",,,FiscalAgent,"QS Departure Location","QS Arrival Location";
        }
        field(21; "Multiple Entry for"; Option)
        {
            Caption = 'Multiple Entry for';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Location,Location Group,Departure Region,,Shipping Agent';
            OptionMembers = " ",Location,"Location Group","Departure Region",,"Shipping Agent";
        }
        field(23; "Report ID"; Integer)
        {
            Caption = 'Report ID';
            DataClassification = CustomerContent;
            TableRelation = Object.ID WHERE(Type = CONST(Report));
        }
        field(25; "Consignee No."; Code[20])
        {
            Caption = 'Consignee No.';
            DataClassification = CustomerContent;
        }
        field(27; "Consignee Contact No."; Code[20])
        {
            Caption = 'Consignee Contact No.';
            DataClassification = CustomerContent;
        }
        field(30; "Released as Print"; Boolean)
        {
            Caption = 'Released as Print';
            DataClassification = CustomerContent;
        }
        field(31; "Nos. Released as Print"; Integer)
        {
            Caption = 'Nos. Released as Print';
            DataClassification = CustomerContent;
        }
        field(32; "Last Date of Print"; DateTime)
        {
            Caption = 'Last Date of Print';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(33; "Released as Fax"; Boolean)
        {
            Caption = 'Released as Fax';
            DataClassification = CustomerContent;
        }
        field(34; "Nos. Released as Fax"; Integer)
        {
            Caption = 'Nos. Released as Fax';
            DataClassification = CustomerContent;
        }
        field(35; "Last Date of Fax"; DateTime)
        {
            Caption = 'Last Date of Fax';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(36; "Released as Mail"; Boolean)
        {
            Caption = 'Released as Mail';
            DataClassification = CustomerContent;
        }
        field(37; "Nos. Released as Mail"; Integer)
        {
            Caption = 'Nos. Released as Mail';
            DataClassification = CustomerContent;
        }
        field(38; "Last Date of Mail"; DateTime)
        {
            Caption = 'Last Date of Mail';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(40; "Print When Sending On Fax"; Boolean)
        {
            Caption = 'Print When Sending On Fax';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                IF "Print When Sending On Fax" <> xRec."Print When Sending On Fax" THEN
                    IF "Print When Sending On Fax" = TRUE THEN
                        VALIDATE("Kind of Release", "Kind of Release"::Fax);
            end;
        }
        field(49; "Consignee Name"; Text[50])
        {
            Caption = 'Consignee Name';
            DataClassification = CustomerContent;
        }
        field(50; "Fax No."; Text[150])
        {
            Caption = 'Fax No.';
            DataClassification = CustomerContent;
        }
        field(52; "E-Mail"; Text[250])
        {
            Caption = 'E-Mail';
            DataClassification = CustomerContent;
            Description = '150 > 250';
        }
        field(60; Subject; Text[150])
        {
            Caption = 'Subject';
            DataClassification = CustomerContent;
        }
        field(80; "Document Subtype Code"; Code[10])
        {
            Caption = 'Document Subtype Code';
            DataClassification = CustomerContent;
            TableRelation = IF (Source = CONST(Purchase),
                                "Document Type" = CONST(Order)) "POI Purch. Doc. Subtype".Code WHERE("Document Type" = CONST(Order))
            ELSE
            IF (Source = CONST(Purchase),
                                         "Document Type" = CONST(Invoice)) "POI Purch. Doc. Subtype".Code WHERE("Document Type" = CONST(Invoice))
            ELSE
            IF (Source = CONST(Purchase),
                                                  "Document Type" = CONST("Credit Memo")) "POI Purch. Doc. Subtype".Code WHERE("Document Type" = CONST("Credit Memo"))
            ELSE
            IF (Source = CONST(Sales),
                                                           "Document Type" = CONST(Order)) "POI Sales Doc. Subtype".Code WHERE("Document Type" = CONST(Order))
            ELSE
            IF (Source = CONST(Sales),
                                                                    "Document Type" = CONST(Invoice)) "POI Sales Doc. Subtype".Code WHERE("Document Type" = CONST(Invoice))
            ELSE
            IF (Source = CONST(Sales),
                                                                             "Document Type" = CONST("Credit Memo")) "POI Sales Doc. Subtype".Code WHERE("Document Type" = CONST("Credit Memo"));
        }
        field(85; "Source Type"; Option)
        {
            Caption = 'Source Type';
            DataClassification = CustomerContent;
            OptionCaption = 'General,Customer,Vendor,Contact,Location,Location Group,Departure Region,Shipping Agent';
            OptionMembers = General,Customer,Vendor,Contact,Location,"Location Group","Departure Region","Shipping Agent";
        }
        field(86; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            DataClassification = CustomerContent;
            TableRelation = IF ("Source Type" = CONST(Customer)) Customer."No."
            ELSE
            IF ("Source Type" = CONST(Vendor)) Vendor."No."
            ELSE
            IF ("Source Type" = CONST(Contact)) Contact."No."
            ELSE
            IF ("Source Type" = CONST(Location)) Location.Code
            ELSE
            IF ("Source Type" = CONST("Location Group")) "POI Location Group".Code
            ELSE
            IF ("Source Type" = CONST("Departure Region")) "POI Departure Region".Code
            ELSE
            IF ("Source Type" = CONST("Shipping Agent")) "Shipping Agent".Code;
        }
        field(100; "Dataport ID"; Integer)
        {
            Description = '001 0817336A';
            DataClassification = CustomerContent;
        }
        field(101; PrintWithRequest; Boolean)
        {
            Caption = 'Ausgabe mit Requestform';
            DataClassification = CustomerContent;
        }
        field(102; "Print Description 1"; Text[250])
        {
            Caption = 'Ausgabe Beschreibung 1';
            DataClassification = CustomerContent;
        }
        field(103; "Print Description 2"; Text[250])
        {
            Caption = 'Ausgabe Beschreibung 2';
            DataClassification = CustomerContent;
        }
        field(104; "Print Report Description"; Text[80])
        {
            DataClassification = CustomerContent;
        }
        field(105; MailID; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(106; "Purchase Order"; Code[20])
        {
            Caption = 'Bestellnummer';
            DataClassification = CustomerContent;
        }
        field(107; "Export To Mooy"; Boolean)
        {
            Caption = 'Export To Mooy';
            DataClassification = CustomerContent;
            Description = 'MOOY';
        }
        field(108; "Previous Exports To Mooy"; Integer)
        {
            Caption = 'Previous Exports To Mooy';
            DataClassification = CustomerContent;
            Description = 'MOOY';
            Editable = false;
        }
        field(109; "Report Name"; Text[120])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup (AllObjWithCaption."Object Caption" WHERE("Object Type" = CONST(Report), "Object ID" = FIELD("Report ID")));
            Editable = false;

        }
    }

    keys
    {
        key(Key1; Source, "Document Type", "Document No.", "Print Doc. Code", "Detail Code")
        {
        }
        key(Key2; "Sort Order")
        {
        }
    }

}

