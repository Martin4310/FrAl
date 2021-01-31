table 5110432 "POI Purch. Ext.Comment"
{
    Caption = 'Purch. Comment';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            Description = 'Header,Line';
            OptionCaption = 'Header,Line';
            OptionMembers = Header,Line;
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(9; "Document Source"; Option)
        {
            Caption = 'Document Source';
            Description = ' ,Header,,,Line';
            OptionCaption = ' ,Header,,,Line';
            OptionMembers = " ",Header,,,Line;
        }
        field(10; "Document Type"; Option)
        {
            Caption = 'Document Type';
            Description = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(11; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = FIELD("Document Type"));
        }
        field(12; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
        }
        field(13; Consignee; Option)
        {
            Caption = 'Consignee';
            Description = ' ,Order Address,,,Delivery Adress,,,Invoice Adress,,,Warehouse,,,Shipping Agent,,,Customer Clearance,,,Quality Control';
            OptionCaption = ' ,Order Address,,,Delivery Adress,,,Invoice Adress,,,Warehouse,,,Shipping Agent,,,Customer Clearance,,,Quality Control';
            OptionMembers = " ","Order Address",,,"Delivery Adress",,,"Invoice Adress",,,Warehouse,,,"Shipping Agent",,,"Customer Clearance",,,"Quality Control";
        }
        field(15; Placement; Option)
        {
            Caption = 'Placement';
            Description = 'Header,Footer,Line';
            OptionCaption = 'Header,Footer,Line';
            OptionMembers = Header,Footer,Line;

            trigger OnValidate()
            var
                lrc_PurchaseComment: Record "POI Purch. Ext.Comment";
            begin
                IF "Entry Type" = "Entry Type"::Header THEN
                    IF "Document Line No." > 0 THEN
                        Placement := Placement::Line
                    ELSE
                        IF Placement = Placement::Line THEN
                            Placement := Placement::Footer;

                IF (Placement <> xRec.Placement) AND
                   ("Entry Type" = "Entry Type"::Header) THEN BEGIN
                    lrc_PurchaseComment.RESET();
                    lrc_PurchaseComment.SETRANGE("Entry No.", "Entry No.");
                    lrc_PurchaseComment.SETRANGE("Entry Type", lrc_PurchaseComment."Entry Type"::Line);
                    IF lrc_PurchaseComment.FIND('-') THEN
                        lrc_PurchaseComment.MODIFYALL(Placement, Placement);
                END;
            end;
        }
        field(16; "No. of Documents"; Integer)
        {
            CalcFormula = Count ("POI Purch. Ext.Comment Doc." WHERE("Purch. Comment Entry No." = FIELD("Entry No."),
                                                                 Print = CONST(true)));
            Caption = 'No. of Documents';
            Editable = false;
            FieldClass = FlowField;
        }
        field(20; Comment; Text[100])
        {
            Caption = 'Comment';
        }
        field(50030; "User-ID"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Document Source", "Document Type", "Document No.", "Document Line No.", "Entry Type", "Entry No.", "Line No.")
        {
        }
        key(Key2; "Entry Type", "Entry No.", "Line No.", "Document Source", "Document Type", "Document No.", "Document Line No.")
        {
        }
        key(Key3; "Entry No.", "Entry Type", "Line No.")
        {
        }
    }

    trigger OnDelete()

    begin
        CASE "Entry Type" OF
            "Entry Type"::Header:
                BEGIN
                    // Bemerkungszeilen löschen
                    lrc_PurchComment.RESET();
                    lrc_PurchComment.SETRANGE("Entry No.", "Entry No.");
                    lrc_PurchComment.SETRANGE("Entry Type", lrc_PurchComment."Entry Type"::Line);
                    IF lrc_PurchComment.FIND('-') THEN
                        lrc_PurchComment.DELETEALL();
                    // Dokumente löschen
                    lrc_PurchaseCommentPrintDoc.RESET();
                    lrc_PurchaseCommentPrintDoc.SETRANGE("Purch. Comment Entry No.", "Entry No.");
                    IF lrc_PurchaseCommentPrintDoc.FIND('-') THEN
                        lrc_PurchaseCommentPrintDoc.DELETEALL();
                END;
            "Entry Type"::Line:
                ;
        END;
    end;

    trigger OnInsert()
    begin
        CASE "Entry Type" OF
            // Kontrolle ob Entry No vorhanden ist ansonsten Vergabe
            "Entry Type"::Header:
                IF "Entry No." = 0 THEN BEGIN
                    lrc_PurchComment.SETCURRENTKEY("Entry No.", "Entry Type", "Line No.");
                    lrc_PurchComment.SETRANGE("Entry Type", lrc_PurchComment."Entry Type"::Header);
                    IF lrc_PurchComment.FINDLAST() THEN
                        "Entry No." := lrc_PurchComment."Entry No." + 1
                    ELSE
                        "Entry No." := 1;

                    "Line No." := 0;
                END;
            // Kontrolle ob Zeilennummer vorhanden ist ansonsten Vergabe
            "Entry Type"::Line:
                BEGIN
                    TESTFIELD("Entry No.");
                    IF "Line No." = 0 THEN BEGIN
                        lrc_PurchComment.SETRANGE("Entry No.", "Entry No.");
                        lrc_PurchComment.SETRANGE("Entry Type", "Entry Type");
                        IF lrc_PurchComment.FIND('+') THEN
                            "Line No." := lrc_PurchComment."Line No." + 10000
                        ELSE
                            "Line No." := 10000;
                    END;

                    // Werte aus Kopfsatz lesen und in Zeilensatz setzen
                    lrc_PurchComment.RESET();
                    lrc_PurchComment.SETRANGE("Entry No.", "Entry No.");
                    lrc_PurchComment.SETRANGE("Entry Type", lrc_PurchComment."Entry Type"::Header);
                    lrc_PurchComment.FINDFIRST();
                    "Document Source" := lrc_PurchComment."Document Source";
                    "Document Type" := lrc_PurchComment."Document Type";
                    "Document No." := lrc_PurchComment."Document No.";
                    "Document Line No." := lrc_PurchComment."Document Line No.";
                    Placement := lrc_PurchComment.Placement;
                END;
        END;
        "User-ID" := copystr(UPPERCASE(USERID()), 1, 20);
    end;

    var
        lrc_PurchaseCommentPrintDoc: Record "POI Purch. Ext.Comment Doc.";
        lrc_PurchComment: Record "POI Purch. Ext.Comment";

}

