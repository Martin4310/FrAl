table 5110383 "POI Discount"
{
    Caption = 'Discount';
    // DrillDownFormID = Form5110383;
    // LookupFormID = Form5110383;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(10; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(11; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(12; Comment; Text[50])
        {
            Caption = 'Comment';
        }
        field(15; "Discount Type"; Option)
        {
            Caption = 'Type of Discount';
            Description = 'Warenrechnungsrabatt,Rechnungsrabatt,Artikelrabatt';
            OptionCaption = 'Warenrechnungsrabatt,Rechnungsrabatt,Artikelrabatt';
            OptionMembers = Warenrechnungsrabatt,Rechnungsrabatt,Artikelrabatt;
        }
        field(16; "Sub Typ"; Option)
        {
            Caption = 'Sub Typ';
            Description = ' ,VVE,Self-collector';
            OptionCaption = ' ,VVE,Self-collector';
            OptionMembers = " ",VVE,"Self-collector";
        }
        field(17; "Discount Depend on Weight"; Boolean)
        {
            Caption = 'Discount Depend on Weight';
        }
        field(20; "Payment Timing"; Option)
        {
            Caption = 'Payment Timing';
            Description = 'Rechnung,Monat,Quartal,Halbjahr,Jahr,Rückstellung,Separate Gutschrift';
            OptionCaption = 'Invoice,Month,Quarter,Half Year,Year,Rückstellung,Separate Credit Memo';
            OptionMembers = Invoice,Month,Quarter,"Half Year",Year,"Rückstellung","Separate Credit Memo";
        }
        field(45; "No Posting Sales Accruel"; Boolean)
        {
            Caption = 'No Posting Sales Accruel';
            Description = 'Rückstellungsrabatte werden nicht gebucht';
        }
        field(49; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(50; "VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(51; "VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(60; "General Acc. Disc. discharge"; Boolean)
        {
            Caption = 'General Acc. Disc. discharge';
        }
        field(70; "Discount Source"; Option)
        {
            Caption = 'Discount Source';
            Description = 'Extern,,,,Intern';
            OptionCaption = 'Extern,,,,,,,,,,,Intern';
            OptionMembers = Extern,,,,,,,,,,,Intern;
        }
        field(71; "Discount Based on incl. Refund"; Boolean)
        {
            Caption = 'Discount Based on incl. Refund';
        }
        field(80; "Print Output"; Option)
        {
            Caption = 'Print Output';
            OptionCaption = 'Single Line,Sum per Discount Code/Discount Value';
            OptionMembers = "Single Line","Sum per Discount Code/Discount Value";
        }
        field(90; "Print Description"; Text[50])
        {
            Caption = 'Print Description';
        }
        field(100; "Posting Description"; Text[100])
        {
            Caption = 'Posting Description';
        }
        field(120; "No. of Customer Entries"; Integer)
        {
            BlankNumbers = BlankZero;
            CalcFormula = Count ("POI Customer Discount" WHERE("Discount Code" = FIELD(Code)));
            Caption = 'No. of Customer Entries';
            Editable = false;
            FieldClass = FlowField;
        }
        field(121; "No. of Vendor Entries"; Integer)
        {
            BlankNumbers = BlankZero;
            CalcFormula = Count ("POI Vendor Discount" WHERE("Discount Code" = FIELD(Code)));
            Caption = 'No. of Vendor Entries';
            Editable = false;
            FieldClass = FlowField;
        }
        field(122; "No. of Company Entries"; Integer)
        {
            BlankNumbers = BlankZero;
            CalcFormula = Count ("POI Company Discount" WHERE("Discount Code" = FIELD(Code)));
            Caption = 'No. of Company Entries';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    trigger OnDelete()
    var
        lrc_LanguageTranslation: Record "POI Language Translation";
    begin
        lrc_LanguageTranslation.RESET();
        lrc_LanguageTranslation.SETRANGE("Table ID", DATABASE::"POI Discount");
        lrc_LanguageTranslation.SETRANGE(Code, Code);
        lrc_LanguageTranslation.DELETEALL();
    end;

    procedure TestProposal(ptx_Text: Text[260])
    var
        AgilesText001Txt: Label 'Die Beschreibung könnte in dieser Konstellation  zu lang werden \';
        AgilesText002Txt: Label 'bei voll genutzen Feldern beträgt die Länge %1 Zeichen \', Comment = '%1';
        AgilesText004Txt: Label '%2 \', Comment = '%2';
        AgilesText005Txt: Label ' \';
        AgilesText006Txt: Label 'Da maximal 88 Zeichen möglich sind wird der Text entsprechend gekürzt \';
    begin
        IF ptx_Text = '' THEN
            EXIT;

        // Variablen werden folgendermaßen vorbelegt
        // %1 = Belegart
        // %2 = Ursprungsbelegart
        // %3 = Belegnr.
        // %4 = Prozentsatz
        // %5 = Bemessungsgrundlage


        // ptx_Text := STRSUBSTNO(ptx_Text, //TODO: was ist das ?
        //                        DELCHR(FORMAT('Gutschrift', 20), '>'),
        //                        DELCHR(FORMAT('Rechnung', 20), '>'),
        //                        DELCHR(FORMAT('VK-123456789', 20), '>'),
        //                        DELCHR(FORMAT('99,99', 20), '>'),
        //                        DELCHR(FORMAT('9999,99', 20), '>'));


        IF STRLEN(ptx_Text) > 88 THEN begin
            ErrorLabel := AgilesText001Txt + AgilesText002Txt + AgilesText004Txt + AgilesText005Txt + AgilesText006Txt + COPYSTR(ptx_Text, 1, 88);
            ERROR(ErrorLabel, STRLEN(ptx_Text), ptx_Text);
        end ELSE
            MESSAGE(AgilesText004Txt, ptx_Text);
    end;

    var
        ErrorLabel: text;
}

