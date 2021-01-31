tableextension 50010 "POI Purchase Comment Ext" extends "Purch. Comment Line"
{
    fields
    {
        field(50000; "POI checked"; Boolean)
        {
            Caption = 'checked';
            DataClassification = CustomerContent;
        }
        field(50010; "POI Document date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = CustomerContent;
        }
        field(50011; "POI Quantity Pricebasis"; Decimal)
        {
            Caption = 'Quantity Pricebasis';
            DataClassification = CustomerContent;
        }
        field(50020; "POI Checked by"; Code[20])
        {
            Caption = 'Checked by';
            DataClassification = CustomerContent;
        }
        field(50021; "POI Check Date"; Date)
        {
            Caption = 'Check Date';
            DataClassification = CustomerContent;
        }
        field(50030; "POI User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50035; "POI external Inv. No."; Code[20])
        {
            Caption = 'external Invoice No.';
            DataClassification = CustomerContent;
        }
    }
    trigger OnInsert()
    begin
        "POI User ID" := copystr(UserId(), StrPos(UserId(), '\') + 1, StrLen(UserId()));
    end;

    trigger OnModify()
    begin
        "POI User ID" := copystr(UserId(), StrPos(UserId(), '\') + 1, StrLen(UserId()));
    end;

}