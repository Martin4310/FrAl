table 5110425 "POI Cust./Vend. Ext.Comment"
{
    Caption = 'Cust./Vend. Comment';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
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
        field(10; Source; Option)
        {
            Caption = 'Source';
            Description = 'Vendor,Customer,,Customer Chain';
            OptionCaption = 'Vendor,Customer,,Customer Chain';
            OptionMembers = Vendor,Customer,,"Customer Chain";
        }
        field(11; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            Description = 'Debitorennr., Kreditorennr.';
            TableRelation = IF (Source = CONST(Customer)) Customer."No."
            ELSE
            IF (Source = CONST(Vendor)) Vendor."No."
            ELSE
            IF (Source = CONST("Customer Chain")) "POI Company Chain".Code;
        }
        field(12; "Source Sub. No."; Code[10])
        {
            Caption = 'Source Sub. No.';
            Description = 'Lieferanschrift, Abholadresse';
            TableRelation = IF (Source = CONST(Customer)) "Ship-to Address".Code WHERE("Customer No." = FIELD("Source No."))
            ELSE
            IF (Source = CONST(Vendor)) "Order Address".Code WHERE("Vendor No." = FIELD("Source No."));
        }
        field(15; Placement; Option)
        {
            Caption = 'Placement';
            Description = 'Header,Footer,Line';
            OptionCaption = 'Header,Footer,Line';
            OptionMembers = Header,Footer,Line;

            trigger OnValidate()
            var
                lrc_CustVendComment: Record "POI Cust./Vend. Ext.Comment";
            begin
                IF (Placement <> xRec.Placement) AND
                   ("Entry Type" = "Entry Type"::Header) THEN BEGIN
                    lrc_CustVendComment.RESET();
                    lrc_CustVendComment.SETRANGE("Entry No.", "Entry No.");
                    lrc_CustVendComment.SETRANGE("Entry Type", lrc_CustVendComment."Entry Type"::Line);
                    IF lrc_CustVendComment.FIND('-') THEN
                        lrc_CustVendComment.MODIFYALL(Placement, Placement);
                END;
            end;
        }
        field(16; "No. of Documents"; Integer)
        {
            CalcFormula = Count ("POI Cust./Vend. Ext.Comm. Doc." WHERE("Cust./Vend. Comment Entry No." = FIELD("Entry No."),
                                                                      Print = CONST(true)));
            Caption = 'No. of Documents';
            Editable = false;
            FieldClass = FlowField;
        }
        field(20; Comment; Text[100])
        {
            Caption = 'Comment';
        }
        field(30; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(31; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(50030; "User-ID"; Code[50])
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.", "Entry Type", "Line No.")
        {
        }
        key(Key2; Source, "Source No.")
        {
        }
    }

    trigger OnDelete()
    var
        lrc_CustVendCommentPrintDoc: Record "POI Cust./Vend. Ext.Comm. Doc.";
    begin
        CASE "Entry Type" OF
            "Entry Type"::Header:
                BEGIN
                    // Bemerkungszeilen löschen
                    lrc_CustVendComment.SETRANGE("Entry No.", "Entry No.");
                    lrc_CustVendComment.SETRANGE("Entry Type", lrc_CustVendComment."Entry Type"::Line);
                    lrc_CustVendComment.DELETEALL();
                    // Dokumente löschen
                    lrc_CustVendCommentPrintDoc.SETRANGE("Cust./Vend. Comment Entry No.", "Entry No.");
                    lrc_CustVendCommentPrintDoc.DELETEALL();
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
                    lrc_CustVendComment.SETRANGE("Entry Type", lrc_CustVendComment."Entry Type"::Header);
                    IF lrc_CustVendComment.FIND('+') THEN
                        "Entry No." := lrc_CustVendComment."Entry No." + 1
                    ELSE
                        "Entry No." := 1;
                    "Line No." := 0;
                END;

            // Kontrolle ob Zeilennummer vorhanden ist ansonsten Vergabe
            "Entry Type"::Line:
                BEGIN
                    TESTFIELD("Entry No.");
                    IF "Line No." = 0 THEN BEGIN
                        lrc_CustVendComment.SETRANGE("Entry No.", "Entry No.");
                        lrc_CustVendComment.SETRANGE("Entry Type", "Entry Type");
                        IF lrc_CustVendComment.FIND('+') THEN
                            "Line No." := lrc_CustVendComment."Line No." + 10000
                        ELSE
                            "Line No." := 10000;
                    END;

                    // Werte aus Kopfsatz lesen und in Zeilensatz setzen
                    lrc_CustVendComment.RESET();
                    lrc_CustVendComment.GET("Entry No.", lrc_CustVendComment."Entry Type"::Header, 0);

                    "Document Source" := lrc_CustVendComment."Document Source";
                    Source := lrc_CustVendComment.Source;
                    "Source No." := lrc_CustVendComment."Source No.";
                    "Source Sub. No." := lrc_CustVendComment."Source Sub. No.";
                    Placement := lrc_CustVendComment.Placement;
                END;
        END;
        "User-ID" := copystr(UPPERCASE(USERID()), 1, 50);
    end;

    var
        lrc_CustVendComment: Record "POI Cust./Vend. Ext.Comment";
}

