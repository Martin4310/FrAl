table 50008 "POI Released Print Documents"
{
    Caption = 'Released Print Documents';
    //DrillDownPageId = Form5110527;
    //LookupPageId = Form5110527;

    Permissions = TableData 50008 = rimd;

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,,,Posted Receipt-Shipment,Posted Invoice,,,,,Transfer,,,Freight Order,,,Sales Claim';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",,,"Posted Receipt-Shipment","Posted Invoice",,,,,Transfer,,,"Freight Order",,,"Sales Claim";
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
        field(4; "Print Document Code"; Code[20])
        {
            Caption = 'Print Document Code';
            DataClassification = CustomerContent;
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
            OptionCaption = ' ,Purchase,Post. Purch.,,Sales,Post. Sales,,Transfer,,,Packerei,,,Sales Clearance Statement,Customs Clearance,Account Sales,Freight Order,Sales Statement,Sales Claim';
            OptionMembers = " ",Purchase,"Post. Purch.",,Sales,"Post. Sales",,Transfer,,,Packerei,,,"Sales Clearance Statement","Customs Clearance","Account Sales","Freight Order","Sales Statement","Sales Claim",ReportID;
        }
        field(7; "Posted Doc. Type"; Option)
        {
            Caption = 'Posted Doc. Type';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Posted Shipment,Posted Invoice,Posted Credit Memo,Posted Return Receipt/Shipment';
            OptionMembers = " ","Posted Shipment","Posted Invoice","Posted Credit Memo","Posted Return Receipt/Shipment";
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
        }
        field(13; "Kind of Release"; Option)
        {
            Caption = 'Kind of Release';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Preview,Print,Fax,Mail';
            OptionMembers = " ",Preview,Print,Fax,Mail;
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
        }
        field(49; "Consignee Name"; Text[100])
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
            Description = '100 > 150';
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
        field(90; "Released Date"; Date)
        {
            Caption = 'Released Date';
            DataClassification = CustomerContent;
        }
        field(91; "Released Time"; Time)
        {
            Caption = 'Released Time';
            DataClassification = CustomerContent;
        }
        field(92; "USER ID"; Code[50])
        {
            Caption = 'USER ID';
            DataClassification = CustomerContent;
        }
        field(100; "Entry ID"; Integer)
        {
            Caption = 'Entry ID';
            DataClassification = CustomerContent;
        }
        field(101; "Dataport ID"; Integer)
        {
            Description = '001 0817336A';
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
        field(104; MailID; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(105; "Mailübergabe Outlook bestätigt"; Boolean)
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
        }
        field(109; "Transaction ID"; Integer)
        {
            Caption = 'Transaktion ID';
            DataClassification = CustomerContent;
        }
        field(110; EMailBenachrichtigung; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Entry ID", Source, "Document Type", "Document No.", "Print Document Code", "Detail Code")
        {
        }
        key(Key2; Source, "Document Type", "Document No.", "Print Document Code", "Detail Code")
        {
        }
        key(Key3; "Sort Order")
        {
        }
        key(Key4; "Transaction ID")
        {
        }
        key(Key5; MailID)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        lrc_PrintedDocuments: Record "POI Released Print Documents";
    begin
        IF "Entry ID" = 0 THEN
            IF lrc_PrintedDocuments.FIND('+') THEN
                "Entry ID" := lrc_PrintedDocuments."Entry ID" + 1
            ELSE
                "Entry ID" := 1;

    end;

    procedure GetLastPrintReleased(var rrc_ReleasedPrintDocuments: Record "POI Released Print Documents"): Text[1024]
    var
        ldt_LastReleased: DateTime;
        ltx_LastReleasedDateTime: Text[30];
        ltx_LastReleasedDescription: Text[1024];
        ltx_LastReleasedDescript_Help: Text[1024];
        lin_LastTransactionID: Integer;
        lin_LastTransactionID_Help: Integer;
    begin
        // KHH 002 KHH50019.s
        IF rrc_ReleasedPrintDocuments.FIND('-') THEN
            REPEAT
                CASE rrc_ReleasedPrintDocuments."Kind of Release" OF
                    rrc_ReleasedPrintDocuments."Kind of Release"::Print:
                        ldt_LastReleased := rrc_ReleasedPrintDocuments."Last Date of Print";
                    rrc_ReleasedPrintDocuments."Kind of Release"::Fax:
                        ldt_LastReleased := rrc_ReleasedPrintDocuments."Last Date of Fax";
                    rrc_ReleasedPrintDocuments."Kind of Release"::Mail:
                        ldt_LastReleased := rrc_ReleasedPrintDocuments."Last Date of Mail";
                    ELSE
                        ldt_LastReleased := 0DT;
                        lin_LastTransactionID_Help := rrc_ReleasedPrintDocuments."Transaction ID";
                        IF (lin_LastTransactionID_Help > lin_LastTransactionID) THEN BEGIN
                            lin_LastTransactionID := lin_LastTransactionID_Help;
                            ltx_LastReleasedDateTime := FORMAT(ldt_LastReleased);
                            ltx_LastReleasedDescription := '';
                        END;
                        IF (ldt_LastReleased <> 0DT) AND (lin_LastTransactionID <> 0) then begin
                            ltx_LastReleasedDescript_Help := ' - ' + rrc_ReleasedPrintDocuments."Print Document Code" + ' (' + FORMAT(rrc_ReleasedPrintDocuments."Kind of Release") + ')';
                            IF (STRLEN(ltx_LastReleasedDescription) + STRLEN(ltx_LastReleasedDescript_Help) <= MAXSTRLEN(ltx_LastReleasedDescription)) THEN
                                ltx_LastReleasedDescription += ltx_LastReleasedDescript_Help;
                        end;
                end;
            UNTIL rrc_ReleasedPrintDocuments.NEXT() = 0;


        EXIT(Copystr(ltx_LastReleasedDateTime + ltx_LastReleasedDescription, 1, 1024));
    end;

    procedure GetLastPrintReleased_Details(var rrc_ReleasedPrintDocuments: Record "POI Released Print Documents"; var rrc_ReleasedPrintDocument_Temp: Record "POI Released Print Documents"): Text[1024]
    var
        ldt_LastReleased: DateTime;
        ltx_LastReleasedDateTime: Text[30];
        ltx_LastReleasedDescription: Text[1024];
        ltx_LastReleasedDescript_Help: Text[1024];
        lin_LastTransactionID: Integer;
        lin_LastTransactionID_Help: Integer;
    begin
        // KHH 003 KHH50019.s
        IF rrc_ReleasedPrintDocuments.FIND('-') THEN
            REPEAT

                CASE rrc_ReleasedPrintDocuments."Kind of Release" OF

                    rrc_ReleasedPrintDocuments."Kind of Release"::Print:
                        ldt_LastReleased := rrc_ReleasedPrintDocuments."Last Date of Print";
                    rrc_ReleasedPrintDocuments."Kind of Release"::Fax:
                        ldt_LastReleased := rrc_ReleasedPrintDocuments."Last Date of Fax";
                    rrc_ReleasedPrintDocuments."Kind of Release"::Mail:
                        ldt_LastReleased := rrc_ReleasedPrintDocuments."Last Date of Mail";
                    ELSE
                        ldt_LastReleased := 0DT;
                END;

                lin_LastTransactionID_Help := rrc_ReleasedPrintDocuments."Transaction ID";

                IF (lin_LastTransactionID_Help > lin_LastTransactionID) THEN BEGIN
                    lin_LastTransactionID := lin_LastTransactionID_Help;
                    ltx_LastReleasedDateTime := FORMAT(ldt_LastReleased);
                    ltx_LastReleasedDescription := '';
                END;

                IF (ldt_LastReleased <> 0DT) AND (lin_LastTransactionID <> 0) THEN BEGIN
                    ltx_LastReleasedDescript_Help := ' - ' + rrc_ReleasedPrintDocuments."Print Document Code" + ' (' + FORMAT(rrc_ReleasedPrintDocuments."Kind of Release") + ')';

                    IF (STRLEN(ltx_LastReleasedDescription) + STRLEN(ltx_LastReleasedDescript_Help) <= MAXSTRLEN(ltx_LastReleasedDescription)) THEN
                        ltx_LastReleasedDescription += ltx_LastReleasedDescript_Help;

                    IF rrc_ReleasedPrintDocument_Temp.GET(0,
                                                           rrc_ReleasedPrintDocuments.Source,
                                                           rrc_ReleasedPrintDocuments."Document Type",
                                                           '',
                                                           rrc_ReleasedPrintDocuments."Print Document Code",
                                                           '')
                    THEN BEGIN
                        rrc_ReleasedPrintDocument_Temp."Print Document Description" := FORMAT(rrc_ReleasedPrintDocuments."Kind of Release");
                        rrc_ReleasedPrintDocument_Temp.MODIFY();
                    END;

                END;

            UNTIL rrc_ReleasedPrintDocuments.NEXT() = 0;


        EXIT(Copystr(ltx_LastReleasedDateTime + ltx_LastReleasedDescription, 1, 1024));
    end;
}

