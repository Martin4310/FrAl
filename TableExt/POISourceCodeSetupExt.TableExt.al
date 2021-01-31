tableextension 50054 "POI Source Code Setup Ext" extends "Source Code Setup"
{
    fields
    {
        field(5125000; "Export to Archive"; Code[10])
        {
            Caption = 'Export to Archive';
            Description = 'E4N';
            TableRelation = "Source Code";
        }
        field(5125001; "Import from Archive"; Code[10])
        {
            Caption = 'Import from Archive';
            Description = 'E4N';
            TableRelation = "Source Code";
        }
        field(5125002; "Archive Journal"; Code[10])
        {
            Caption = 'Archive Journal';
            Description = 'E4N';
            TableRelation = "Source Code";
        }
    }

}