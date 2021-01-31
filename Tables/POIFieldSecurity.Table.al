table 50001 "POI Field Security"
{
    DataPerCompany = false;
    fields
    {
        field(1; "TableID"; integer)
        {
            Caption = 'TableID';
            DataClassification = CustomerContent;
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(TableData));
        }
        field(2; "FieldID"; integer)
        {
            Caption = 'FieldID';
            DataClassification = CustomerContent;
            //TableRelation = Field."No." where(TableNo = field(TableID));
        }
        field(3; "Accesstype"; Option)
        {
            Caption = 'Accesstype';
            DataClassification = CustomerContent;
            OptionMembers = " ",Read,Write;
            OptionCaption = ' ,Read,Write';
        }
        field(4; "User Group"; Code[20])

        {
            Caption = 'User Group';
            DataClassification = CustomerContent;
            TableRelation = "User Group".Code;
        }
    }
    keys
    {
        key(key1; TableID, FieldID, "User Group") { }
    }

}