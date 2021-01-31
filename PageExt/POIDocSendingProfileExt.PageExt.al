pageextension 50025 "POI Doc. Sending Profile Ext" extends "Document Sending Profile"
{
    layout
    {
        modify(Printer)
        {
            Caption = 'per Post';
        }
        modify(Disk)
        {
            Visible = false;
        }
    }
    actions
    {
    }
}