table 50904 "POI Documents"
{
    Caption = 'Documents';
    //LookupFormID = Form5110523;

    fields
    {
        field(1; Application; Option)
        {
            Caption = 'Application';
            OptionCaption = 'Word,Excel,Hyperlink';
            OptionMembers = Word,Excel,Hyperlink;
        }
        field(2; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = 'Document,Template';
            OptionMembers = Document,Template;
        }
        field(3; "Area"; Option)
        {
            Caption = 'Area';
            OptionCaption = 'Sales,Purchases,,,Contact,Item,Customer,Vendor,Master Batch,Batch,Batch Variant,,,,,,,,Standard';
            OptionMembers = Sales,Purchases,,,Contact,Item,Customer,Vendor,"Master Batch",Batch,"Batch Variant",,,,,,,,Standard;
        }
        field(4; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote/Inquriy,Order/Purchase order,Invoice,Credit Memo,Blanket Order,Return Order,Shipment,Posted Invoice,Posted Credit Memo,Posted Return Receipt,Masterdata,Quote Archived,Order Archived';
            OptionMembers = "Quote/Inquriy","Order/Purchase order",Invoice,"Credit Memo","Blanket Order","Return Order",Shipment,"Posted Invoice","Posted Credit Memo","Posted Return Receipt",Masterdata,"Quote Archived","Order Archived";
        }
        field(5; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(6; "Entry No."; Code[10])
        {
            Caption = 'Entry No.';
            Editable = false;
        }
        field(7; "Document Path / Name"; Text[250])
        {
            Caption = 'Document Path / Name';

            // trigger OnValidate()
            // var
            //     l: Integer;
            // begin
            //     IF NOT DocMSetup.GET(Area) THEN ERROR(Text003Txt, Area);

            //     IF ("Document Path / Name" <> xRec."Document Path / Name") AND (xRec."Document Path / Name" <> '') THEN
            //         IF NOT CONFIRM(Text001Txt, FALSE) THEN
            //             ERROR(Text002Txt);
            //     CASE "Entry Type" OF
            //         "Entry Type"::Document:
            //             BEGIN
            //                 l := STRLEN(DocMSetup."Document Folder");
            //                 IF STRPOS(UPPERCASE("Document Path / Name"), UPPERCASE(DocMSetup."Document Folder")) = 1 THEN
            //                     "Document Path / Name" := DELSTR("Document Path / Name", 1, l);
            //             END;
            //         "Entry Type"::Template:
            //             BEGIN
            //                 l := STRLEN(DocMSetup."Template Folder");
            //                 IF STRPOS(UPPERCASE("Document Path / Name"), UPPERCASE(DocMSetup."Template Folder")) = 1 THEN
            //                     "Document Path / Name" := DELSTR("Document Path / Name", 1, l);
            //             END;
            //     END;
            // end;
        }
        field(8; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(9; "Valid From"; Date)
        {
            Caption = 'Valid From';
        }
        field(10; "Valid To"; Date)
        {
            Caption = 'Valid To';
        }
        field(15; "Created At"; Date)
        {
            Caption = 'Created At';
            Editable = false;
        }
        field(16; "Save Path Documents"; Text[250])
        {
            Caption = 'Save Path Documents';

            trigger OnValidate()
            begin
                TESTFIELD("Entry Type", "Entry Type"::Template);
            end;
        }
        field(17; "Created by"; Code[50])
        {
            Caption = 'Created by';
            Editable = false;
        }
        field(19; Archived; Boolean)
        {
            Caption = 'Archived';
        }
        field(20; "Archived Path / Name Document"; Text[250])
        {
            Caption = 'Archived Path / Name Document';
        }
        field(21; "Archived At"; Date)
        {
            Caption = 'Archived At';
            Editable = false;
        }
        field(22; "Archived By"; Code[10])
        {
            Caption = 'Archived By';
            Editable = false;
        }
        field(23; "Contact No."; Code[20])
        {
            Caption = 'Contact No.';
            TableRelation = Contact;
        }
        field(24; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(25; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
        }
        field(26; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(27; "Last Entry On Template"; Code[10])
        {
            Caption = 'Last Entry On Template';
        }
        field(28; "Use Request Form"; Boolean)
        {
            Caption = 'Use Request Form';
        }
        field(29; "Report No."; Integer)
        {
            Caption = 'Report No.';
        }
        field(31; "Version No."; Integer)
        {
            Caption = 'Version No.';
        }
        field(32; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language.Code;
        }
        field(34; "Master Batch No."; Code[20])
        {
            Caption = 'Master Batch No.';
            TableRelation = "POI Master Batch"."No.";
        }
        field(35; "Batch No."; Code[20])
        {
            Caption = 'Batch No.';
            TableRelation = "POI Batch"."No.";
        }
        field(36; "Batch Variant No."; Code[20])
        {
            Caption = 'Batch Variant No.';
            ///???TableRelation = "Batch Variant".No.;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
        key(Key2; "Area", "Document Type", "Document No.", "Entry No.")
        {
        }
        key(Key3; "Document No.")
        {
        }
        key(Key4; "Document Type", "Document No.", "Master Batch No.", "Entry Type", "Area")
        {
        }
        key(Key5; "Document Type", "Document No.", "Batch No.", "Entry Type", "Area")
        {
        }
        key(Key6; "Document Type", "Document No.", "Batch Variant No.", "Entry Type", "Area")
        {
        }
        key(Key7; "Document Type", "Document No.", "Item No.", "Entry Type", "Area")
        {
        }
        key(Key8; "Document Type", "Document No.", "Vendor No.", "Entry Type", "Area")
        {
        }
        key(Key9; "Document Type", "Document No.", "Customer No.", "Entry Type", "Area")
        {
        }
        key(Key10; "Document Type", "Document No.", "Contact No.", "Entry Type", "Area")
        {
        }
        key(Key11; "Document Type", "Document No.", "Version No.", "Entry Type", "Area")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        // DocManagement.FileDelete(Rec);
    end;

    trigger OnInsert()
    var
        Document2: Record "POI Documents";
        MasterBatch2: Record "POI Master Batch";
        Batch2: Record "POI Batch";
        BatchVariant2: Record "POI Batch Variant";
        SalesHeader2: Record "Sales Header";
        PurchaseHeader2: Record "Purchase Header";
        SalesHeaderArchive2: Record "Sales Header Archive";
        PurchaseHeaderArchive2: Record "Purchase Header Archive";
        SalesShipmentHeader2: Record "Sales Shipment Header";
        SalesInvoiceHeader2: Record "Sales Invoice Header";
        SalesCrMemoHeader2: Record "Sales Cr.Memo Header";
        PurchRcptHeader2: Record "Purch. Rcpt. Header";
        PurchInvHeader2: Record "Purch. Inv. Header";
        PurchCrMemoHdr2: Record "Purch. Cr. Memo Hdr.";
        ReturnReceiptHeader2: Record "Return Receipt Header";
        ReturnShipmentHeader2: Record "Return Shipment Header";
    begin
        IF "Entry No." = '' THEN
            IF Document2.FIND('+') THEN
                "Entry No." := INCSTR(Document2."Entry No.")
            ELSE
                "Entry No." := '1';


        IF "Entry Type" = "Entry Type"::Template THEN
            IF (Application <> Application::Word) AND (Application <> Application::Excel) THEN
                ERROR(SSPText01Txt);

        IF Document2.Area = Document2.Area::"Batch Variant" THEN
            IF "Batch Variant No." <> '' THEN
                IF BatchVariant2.GET("Batch Variant No.") THEN BEGIN
                    IF "Item No." = '' THEN
                        "Item No." := BatchVariant2."Item No.";
                    IF "Master Batch No." = '' THEN
                        "Master Batch No." := BatchVariant2."Master Batch No.";
                    IF "Batch No." = '' THEN
                        "Batch No." := BatchVariant2."Batch No.";
                    IF "Vendor No." = '' THEN
                        "Vendor No." := BatchVariant2."Vendor No.";
                END;

        IF Document2.Area = Document2.Area::Batch THEN
            IF "Batch No." <> '' THEN
                IF Batch2.GET("Batch No.") THEN BEGIN
                    IF "Master Batch No." = '' THEN
                        "Master Batch No." := Batch2."Master Batch No.";
                    IF "Vendor No." = '' THEN
                        "Vendor No." := Batch2."Vendor No.";
                END;

        IF Document2.Area = Document2.Area::"Master Batch" THEN
            IF "Master Batch No." <> '' THEN
                IF MasterBatch2.GET("Master Batch No.") THEN
                    IF "Vendor No." = '' THEN
                        "Vendor No." := MasterBatch2."Vendor No.";

        case Document2."Document Type" of
            Document2."Document Type"::"Quote/Inquriy",
            Document2."Document Type"::"Order/Purchase order",
            Document2."Document Type"::Invoice,
            Document2."Document Type"::"Credit Memo",
            Document2."Document Type"::"Blanket Order",
            Document2."Document Type"::"Return Order":
                IF Document2.Area = Document2.Area::Sales THEN BEGIN
                    IF SalesHeader2.GET(Document2."Document Type", Document2."Document No.") THEN
                        IF "Customer No." = '' THEN
                            "Customer No." := SalesHeader2."Sell-to Customer No.";
                END ELSE
                    IF Document2.Area = Document2.Area::Purchases THEN
                        IF PurchaseHeader2.GET(Document2."Document Type", Document2."Document No.") THEN
                            IF "Vendor No." = '' THEN
                                "Vendor No." := PurchaseHeader2."Buy-from Vendor No.";
            Document2."Document Type"::"Quote Archived":
                IF Document2.Area = Document2.Area::Sales THEN
                    IF SalesHeaderArchive2.GET(SalesHeaderArchive2."Document Type"::Quote, Document2."Document No.") THEN
                        IF "Customer No." = '' THEN
                            "Customer No." := SalesHeaderArchive2."Sell-to Customer No."
                        ELSE
                            IF Document2.Area = Document2.Area::Purchases THEN
                                IF PurchaseHeaderArchive2.GET(PurchaseHeaderArchive2."Document Type"::Quote, Document2."Document No.") THEN
                                    IF "Vendor No." = '' THEN
                                        "Vendor No." := PurchaseHeaderArchive2."Buy-from Vendor No.";
            Document2."Document Type"::"Order Archived":
                IF Document2.Area = Document2.Area::Sales THEN BEGIN
                    IF SalesHeaderArchive2.GET(SalesHeaderArchive2."Document Type"::Quote, Document2."Document No.") THEN
                        IF "Customer No." = '' THEN
                            "Customer No." := SalesHeaderArchive2."Sell-to Customer No.";

                END ELSE
                    IF Document2.Area = Document2.Area::Purchases THEN
                        IF PurchaseHeaderArchive2.GET(PurchaseHeaderArchive2."Document Type"::Order, Document2."Document No.") THEN
                            IF "Vendor No." = '' THEN
                                "Vendor No." := PurchaseHeaderArchive2."Buy-from Vendor No.";

            Document2."Document Type"::Shipment:
                IF Document2.Area = Document2.Area::Sales THEN
                    IF SalesShipmentHeader2.GET(Document2."Document No.") THEN
                        IF "Customer No." = '' THEN
                            "Customer No." := SalesShipmentHeader2."Sell-to Customer No."
                        ELSE
                            IF Document2.Area = Document2.Area::Purchases THEN
                                IF PurchRcptHeader2.GET(Document2."Document No.") THEN
                                    IF "Vendor No." = '' THEN
                                        "Vendor No." := PurchRcptHeader2."Buy-from Vendor No.";
            Document2."Document Type"::"Posted Invoice":
                case Document2.Area of
                    Document2.Area::Sales:
                        IF SalesInvoiceHeader2.GET(Document2."Document No.") THEN
                            IF "Customer No." = '' THEN
                                "Customer No." := SalesInvoiceHeader2."Sell-to Customer No.";
                    Document2.Area::Purchases:
                        IF PurchInvHeader2.GET(Document2."Document No.") THEN
                            IF "Vendor No." = '' THEN
                                "Vendor No." := PurchInvHeader2."Buy-from Vendor No.";
                END;
            Document2."Document Type"::"Posted Credit Memo":
                case Document2.Area of
                    Document2.Area::Sales:
                        IF SalesCrMemoHeader2.GET(Document2."Document No.") THEN
                            IF "Customer No." = '' THEN
                                "Customer No." := SalesCrMemoHeader2."Sell-to Customer No.";
                    Document2.Area::Purchases:
                        IF PurchCrMemoHdr2.GET(Document2."Document No.") THEN
                            IF "Vendor No." = '' THEN
                                "Vendor No." := PurchCrMemoHdr2."Buy-from Vendor No.";
                END;
            Document2."Document Type"::"Posted Return Receipt":
                case Document2.Area of
                    Document2.Area::Sales:
                        IF ReturnReceiptHeader2.GET(Document2."Document No.") THEN
                            IF "Customer No." = '' THEN
                                "Customer No." := ReturnReceiptHeader2."Sell-to Customer No.";
                    Document2.Area::Purchases:
                        IF ReturnShipmentHeader2.GET(Document2."Document No.") THEN
                            IF "Vendor No." = '' THEN
                                "Vendor No." := ReturnShipmentHeader2."Buy-from Vendor No.";
                END;
        END;
        "Created At" := TODAY();
        "Created by" := copystr(USERID(), 1, 50);
    end;

    trigger OnModify()
    begin
        TESTFIELD(Archived, FALSE);

        IF "Entry Type" = "Entry Type"::Template THEN
            IF (Application <> Application::Word) AND (Application <> Application::Excel) THEN
                ERROR(SSPText01Txt);
    end;

    trigger OnRename()
    begin
        ERROR(Text000Txt);
    end;

    var
        //DocMSetup: Record "5110459";
        //Text003Txt: Label 'Keine Dokumenten Setup für %1';
        SSPText01Txt: Label 'You can only create templates for the programms word or excel !';
        Text000Txt: Label 'Rename not allowed';
    //Text001Txt: Label 'Do you want to change the filename?';
    //Text002Txt: Label 'Exit';


    procedure InsertInteractionLogEntry(DocEntryNo: Code[10]; ContactNo: Code[10])
    var
        InteractionLogEntry: Record "Interaction Log Entry";
        Document2: Record "POI Documents";
        EntryNo: Integer;

    begin
        IF InteractionLogEntry.FIND('+') THEN BEGIN
            EntryNo := InteractionLogEntry."Entry No.";
            EntryNo := EntryNo + 1;
            IF Document2.GET(DocEntryNo) THEN
                WITH InteractionLogEntry DO BEGIN
                    RESET();
                    INIT();
                    "Entry No." := EntryNo;
                    "Document No." := Document2."Document No.";
                    CASE Document2."Document Type" OF
                        Document2."Document Type"::"Quote/Inquriy":
                            IF Document2.Area = Document2.Area::Sales THEN
                                "Document Type" := "Document Type"::"Sales Qte."
                            ELSE
                                IF Document2.Area = Document2.Area::Purchases THEN
                                    "Document Type" := "Document Type"::"Purch.Qte.";
                        Document2."Document Type"::"Order/Purchase order":
                            IF Document2.Area = Document2.Area::Sales THEN
                                "Document Type" := "Document Type"::"Sales Ord. Cnfrmn."
                            ELSE
                                IF Document2.Area = Document2.Area::Purchases THEN
                                    "Document Type" := "Document Type"::"Purch. Ord.";
                        Document2."Document Type"::"Blanket Order":
                            IF Document2.Area = Document2.Area::Sales THEN BEGIN
                                "Document Type" := "Document Type"::"Sales Blnkt. Ord";
                                "Document No." := Document2."Document No.";
                            END ELSE
                                IF Document2.Area = Document2.Area::Purchases THEN
                                    "Document Type" := "Document Type"::"Purch. Blnkt. Ord.";

                        Document2."Document Type"::"Return Order":
                            IF Document2.Area = Document2.Area::Sales THEN BEGIN
                                "Document Type" := "Document Type"::"Sales Return Order";
                                "Document No." := Document2."Document No.";
                            END ELSE
                                IF Document2.Area = Document2.Area::Purchases THEN
                                    "Document Type" := "Document Type"::"Purch. Return Ord. Cnfrmn.";
                        Document2."Document Type"::Shipment:
                            IF Document2.Area = Document2.Area::Sales THEN BEGIN
                                "Document Type" := "Document Type"::"Sales Shpt. Note";
                                "Document No." := Document2."Document No.";
                            END ELSE
                                IF Document2.Area = Document2.Area::Purchases THEN
                                    "Document Type" := "Document Type"::"Purch. Rcpt.";
                        Document2."Document Type"::"Posted Invoice":
                            IF Document2.Area = Document2.Area::Sales THEN BEGIN
                                "Document Type" := "Document Type"::"Sales Inv.";
                                "Document No." := Document2."Document No.";
                            END ELSE
                                IF Document2.Area = Document2.Area::Purchases THEN
                                    "Document Type" := "Document Type"::"Purch. Inv.";
                        Document2."Document Type"::"Posted Credit Memo":
                            IF Document2.Area = Document2.Area::Sales THEN BEGIN
                                "Document Type" := "Document Type"::"Sales Cr. Memo";
                                "Document No." := Document2."Document No.";
                            END ELSE
                                IF Document2.Area = Document2.Area::Purchases THEN
                                    "Document Type" := "Document Type"::"Purch. Cr. Memo";
                        Document2."Document Type"::"Posted Return Receipt":
                            IF Document2.Area = Document2.Area::Sales THEN BEGIN
                                "Document Type" := "Document Type"::"Sales Return Receipt";
                                "Document No." := Document2."Document No.";
                            END ELSE
                                IF Document2.Area = Document2.Area::Purchases THEN
                                    "Document Type" := "Document Type"::"Purch. Return Shipment";
                    END;
                    Description := Document2.Description;
                    "Contact No." := ContactNo;
                    "Contact Company No." := ContactNo;
                    Date := TODAY();
                    INSERT(TRUE);
                end;
        end;
    end;
}