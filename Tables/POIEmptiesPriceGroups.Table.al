table 5110450 "POI Empties Price Groups"
{
    Caption = 'Empties Price Groups';
    // DrillDownFormID = Form5110454;
    // LookupFormID = Form5110454;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(10; Description; Text[30])
        {
            Caption = 'Description';
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
        lrc_RefundCosts: Record "POI Empties/Transport Ref Cost";
    begin
        lrc_RefundCosts.RESET();
        lrc_RefundCosts.SETRANGE("Source Type", lrc_RefundCosts."Source Type"::"Empties Price Group");
        lrc_RefundCosts.SETRANGE("Source No.", Code);
        IF lrc_RefundCosts.FIND('-') THEn
            lrc_RefundCosts.DELETEALL(TRUE);
    end;
}

