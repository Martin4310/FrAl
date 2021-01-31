table 5087930 "POI Freight Ext. Comment"
{

    Caption = 'Freight Order Comment';

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
            OptionCaption = ' ,Header,,,Line';
            OptionMembers = " ",Header,,,Line;
        }
        field(10; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = ' ,Order';
            OptionMembers = " ","Order";
        }
        field(11; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "POI Freight Order Header"."No.";
        }
        field(12; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
        }
        field(13; Consignee; Option)
        {
            Caption = 'Consignee';
            OptionCaption = ' ,Order Address,,,Delivery Adress,,,Invoice Adress,,,Warehouse,,,Shipping Agent,,,Customer Clearance,,,Quality Control';
            OptionMembers = " ","Order Address",,,"Delivery Adress",,,"Invoice Adress",,,Warehouse,,,"Shipping Agent",,,"Customer Clearance",,,"Quality Control";
        }
        field(15; Placement; Option)
        {
            Caption = 'Placement';
            OptionCaption = 'Header,Footer,Line';
            OptionMembers = Header,Footer,Line;

            trigger OnValidate()
            var
                lrc_FreightOrderComment: Record "POI Freight Ext. Comment";
            begin
                IF "Entry Type" = "Entry Type"::Header THEN
                    IF "Document Line No." > 0 THEN
                        Placement := Placement::Line
                    ELSE
                        IF Placement = Placement::Line THEN
                            Placement := Placement::Footer;
                IF (Placement <> xRec.Placement) AND
                   ("Entry Type" = "Entry Type"::Header) THEN BEGIN
                    lrc_FreightOrderComment.RESET();
                    lrc_FreightOrderComment.SETRANGE("Entry No.", "Entry No.");
                    lrc_FreightOrderComment.SETRANGE("Entry Type", lrc_FreightOrderComment."Entry Type"::Line);
                    IF lrc_FreightOrderComment.FIND('-') THEN
                        lrc_FreightOrderComment.MODIFYALL(Placement, Placement);
                END;
            end;
        }
        field(16; "No. of Documents"; Integer)
        {
            CalcFormula = Count ("POI Sales Ext.Comment Doc." WHERE("Sales Comment Entry No." = FIELD("Entry No."),
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
        key(Key1; "Entry No.", "Entry Type", "Line No.")
        {
        }
        key(Key2; "Entry Type", "Entry No.", "Line No.", "Document Source", "Document Type", "Document No.", "Document Line No.")
        {
        }
        key(Key3; "Document Source", "Document Type", "Document No.", "Document Line No.")
        {
        }
    }

    trigger OnDelete()
    var
        lrc_FreightCommentPrintDoc: Record "POI Freight Ext Comment Doc.";
    begin
        CASE "Entry Type" OF
            "Entry Type"::Header:
                BEGIN
                    // Bemerkungszeilen löschen
                    lrc_FreightOrderComment.RESET();
                    lrc_FreightOrderComment.SETRANGE("Entry No.", "Entry No.");
                    lrc_FreightOrderComment.SETRANGE("Entry Type", lrc_FreightOrderComment."Entry Type"::Line);
                    IF lrc_FreightOrderComment.FIND('-') THEN
                        lrc_FreightOrderComment.DELETEALL(TRUE);

                    // Dokumente löschen
                    lrc_FreightCommentPrintDoc.RESET();
                    lrc_FreightCommentPrintDoc.SETRANGE("Freight Comment Entry No.", "Entry No.");
                    IF lrc_FreightCommentPrintDoc.FIND('-') THEN
                        lrc_FreightCommentPrintDoc.DELETEALL(TRUE);

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
                    lrc_FreightOrderComment.SETRANGE("Entry Type", lrc_FreightOrderComment."Entry Type"::Header);
                    IF lrc_FreightOrderComment.FIND('+') THEN
                        "Entry No." := lrc_FreightOrderComment."Entry No." + 1
                    ELSE
                        "Entry No." := 1;
                    "Line No." := 0;
                END;
            // Kontrolle ob Zeilennummer vorhanden ist ansonsten Vergabe
            "Entry Type"::Line:
                BEGIN
                    TESTFIELD("Entry No.");
                    IF "Line No." = 0 THEN BEGIN
                        lrc_FreightOrderComment.SETRANGE("Entry No.", "Entry No.");
                        lrc_FreightOrderComment.SETRANGE("Entry Type", "Entry Type");
                        IF lrc_FreightOrderComment.FIND('+') THEN
                            "Line No." := lrc_FreightOrderComment."Line No." + 10000
                        ELSE
                            "Line No." := 10000;
                    END;

                    // Werte aus Kopfsatz lesen und in Zeilensatz setzen
                    lrc_FreightOrderComment.RESET();
                    lrc_FreightOrderComment.GET("Entry No.", lrc_FreightOrderComment."Entry Type"::Header, 0);

                    "Document Source" := lrc_FreightOrderComment."Document Source";
                    "Document Type" := lrc_FreightOrderComment."Document Type";
                    "Document No." := lrc_FreightOrderComment."Document No.";
                    "Document Line No." := lrc_FreightOrderComment."Document Line No.";
                    Placement := lrc_FreightOrderComment.Placement;

                END;
        END;
        "User-ID" := copystr(UPPERCASE(USERID()), 1, 20);
    end;

    var
        lrc_FreightOrderComment: Record "POI Freight Ext. Comment";
}
