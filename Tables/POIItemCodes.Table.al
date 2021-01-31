table 50942 "POI Item Codes"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
        }
        field(2; Code; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
            TableRelation = "POI Special Nos Type"."Special Code" where("Special Type" = const('ITEMNOS'));
            trigger OnValidate()
            begin
                if SpecialNos.Get('ITEMNOS', Code) then
                    Description := SpecialNos.Description
                else
                    Description := '';
            end;
        }
        field(3; Value; Text[100])
        {
            Caption = 'Wert';
            DataClassification = CustomerContent;
        }
        field(4; Description; Text[100])
        {
            Caption = 'Beschreibung';
            DataClassification = CustomerContent;
        }
        field(5; "Source Type"; option)
        {
            OptionCaption = ' ,Debitor,Kreditor';
            OptionMembers = " ",Customer,Vendor;
            DataClassification = CustomerContent;
        }
        field(6; "Source Code"; Code[20])
        {
            Caption = 'Herkunftsnr.';
            DataClassification = CustomerContent;
            TableRelation = IF ("Source Type" = CONST(Customer)) Customer
            ELSE
            IF ("Source Type" = CONST(Vendor)) Vendor;
        }
    }

    keys
    {
        key(PK; "Item No.", Code, "Source Type", "Source Code")
        {
            Clustered = true;
        }
    }
    var
        SpecialNos: Record "POI Special Nos Type";

}