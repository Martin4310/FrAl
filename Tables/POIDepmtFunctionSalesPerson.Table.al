table 50952 "POI Depmt Function SalesPerson"
{
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(1; "Department Code"; Enum "POI Department")
        {
            Caption = 'Department';
            DataClassification = CustomerContent;
        }
        Field(2; "Function Code"; Code[20])
        {
            Caption = 'Funktionscode';
            DataClassification = CustomerContent;
            TableRelation = "POI Department Function"."Function Code" where("Department Code" = field("Department Code"));
        }
        field(3; "Salesperson Code"; Code[20])
        {
            Caption = 'Verkäufer/Einkäufer';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(key1; "Department Code", "Function Code", "Salesperson Code")
        {
            Clustered = true;
        }
    }

}