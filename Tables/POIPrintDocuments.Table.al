table 50002 "POI Print Documents"
{
    Caption = 'Print Document';

    fields
    {
        field(1; "Document Source"; Option)
        {
            Caption = 'Document Source';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Purchase,Posted Purchase,,Sales,Posted Sales,,Transfer,Posted Transfer,,Reminder,Posted Reminder,,,,,,,,,,,,,,,Recipe,,Packing,Posted Paking,,Purchase Claim Notify,,,Sales Claim Notify,,,Sales Statement,,,Account Sales,,,Freight Order,Posted Freight Order,,Advanced Payment,,,Customer Clearance';
            OptionMembers = " ",Purchase,"Posted Purchase",,Sales,"Posted Sales",,Transfer,"Posted Transfer",,Reminder,"Posted Reminder",,,,,,,,,,,,,,,Recipe,,Packing,"Posted Paking",,"Purchase Claim Notify",,,"Sales Claim Notify",,,"Sales Statement",,,"Account Sales",,,"Freight Order","Posted Freight Order",,"Advanced Payment",,,"Customer Clearance";
        }
        field(2; "Document Type"; Option)
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,,,,,Posted Receipt/Shipment,Posted Invoice,Posted Return Shipment/Receipt,Posted Credit Memo,,,,,Posted Transfer Shipment,Posted Transfer Receipt';
            OptionMembers = " ",Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",,,,,"Posted Receipt/Shipment","Posted Invoice","Posted Return Shipment/Receipt","Posted Credit Memo",,,,,"Posted Transfer Shipment","Posted Transfer Receipt";
        }
        field(4; "Code"; Code[10])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(9; "Not Activ"; Boolean)
        {
            Caption = 'Not Activ';
            DataClassification = CustomerContent;
        }
        field(10; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(11; "Sort Order"; Integer)
        {
            Caption = 'Sort Order';
            DataClassification = CustomerContent;
        }
        field(12; "Mailing Group Code"; Code[10])
        {
            Caption = 'Mailing Group Code';
            DataClassification = CustomerContent;
            TableRelation = "Mailing Group";
        }
        field(13; Consignee; Option)
        {
            Caption = 'Consignee';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Order Address,,,Delivery Adress,,,Invoice Adress,,,Departure Warehouse,Arrival Warehouse,Shipowning Company,Shipping Agent,,,Customer Clearance,,,Quality Control';
            OptionMembers = " ","Order Address",,,"Delivery Adress",,,"Invoice Adress",,,"Departure Warehouse","Arrival Warehouse","Shipowning Company","Shipping Agent",,,"Customer Clearance",,,"Quality Control",,,FiscalAgent,"QS Departure Location","QS Arrival Location";
        }
        field(15; "Multiple Entry for"; Option)
        {
            Caption = 'Multiple Entry for';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Location,Location Group,Departure Region,,Shipping Agent';
            OptionMembers = " ",Location,"Location Group","Departure Region",,"Shipping Agent";
        }
        field(17; "Posted Document Type"; Option)
        {
            Caption = 'Posted Document Type';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Posted Receipt/Shipment,Posted Invoice,Posted Credit Memo,Posted Return Shipment/Receipt';
            OptionMembers = " ","Posted Receipt/Shipment","Posted Invoice","Posted Credit Memo","Posted Return Shipment/Receipt";

            trigger OnValidate()
            begin
                IF "Posted Document Type" <> "Posted Document Type"::" " THEN
                    "Document Type" := "Document Type"::" ";
            end;
        }
        field(20; "Report ID"; Integer)
        {
            Caption = 'Report ID';
            DataClassification = CustomerContent;
            TableRelation = Object.ID WHERE(Type = CONST(Report));

            trigger OnValidate()
            begin
                CALCFIELDS("Report Name");
            end;
        }
        field(21; "Report Name"; Text[80])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup (AllObjWithCaption."Object Caption" WHERE("Object Type" = CONST(Report), "Object ID" = FIELD("Report ID")));
            Caption = 'Report Name';
            Editable = false;
        }
        field(30; "Mark Typ"; Option)
        {
            Caption = 'Mark Typ';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Customer/Vendor,Location,Shipping Agent';
            OptionMembers = " ","Customer/Vendor",Location,"Shipping Agent";
        }
        field(40; "Print When Sending On Fax"; Boolean)
        {
            Caption = 'Print When Sending On Fax';
            DataClassification = CustomerContent;
        }
        field(41; "Print only this Doc."; Boolean)
        {
            Caption = 'Print only this Document';
            DataClassification = CustomerContent;
        }
        field(50; "Dataport ID"; Integer)
        {
            Caption = 'Dataport ID';
            DataClassification = CustomerContent;
        }
        field(51; PrintWithRequest; Boolean)
        {
            Caption = 'Ausgabe mit Requestform';
            DataClassification = CustomerContent;
        }
        field(52; "Print Report Description"; Text[80])
        {
            Caption = 'Print Report Description';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
        key(Key2; "Sort Order")
        {
        }
        key(Key3; "Document Source", "Document Type", "Code")
        {
        }
    }


    // trigger OnDelete()
    // var
    //     lrc_PrintComDocuments: Record "5110748";
    //     lrc_PrintDocumentDetail: Record "5110498";
    //     lrc_PrintDocumentContactDetail: Record "5110615";
    // begin
    //     lrc_PrintComDocuments.SETRANGE("Print Comment Code", Code);
    //     IF lrc_PrintComDocuments.FINDFIRST() THEN
    //         // Löschung nicht möglich, da noch Texte dem Druckbeleg zugeordnet sind!
    //         ERROR(ADF_GT_TEXT001Txt);

    //     lrc_PrintDocumentDetail.Reset();
    //     lrc_PrintDocumentDetail.SETRANGE(Source, "Document Source");
    //     lrc_PrintDocumentDetail.SETRANGE("Document Type", "Document Type");
    //     lrc_PrintDocumentDetail.SETRANGE("Print Document Code", Code);
    //     IF lrc_PrintDocumentDetail.FIND('-') THEN
    //         lrc_PrintDocumentDetail.DELETEALL(TRUE);

    //     lrc_PrintDocumentContactDetail.Reset();
    //     lrc_PrintDocumentContactDetail.SETRANGE(Source, "Document Source");
    //     lrc_PrintDocumentContactDetail.SETRANGE("Document Type", "Document Type");
    //     lrc_PrintDocumentContactDetail.SETRANGE("Print Document Code", Code);
    //     IF lrc_PrintDocumentContactDetail.FIND('-') THEN
    //         lrc_PrintDocumentContactDetail.DELETEALL(TRUE);
    // end;

    // var
    //     ADF_GT_TEXT001Txt: Label 'Löschung nicht möglich, da noch Texte dem Druckbeleg zugeordnet sind!';
}

