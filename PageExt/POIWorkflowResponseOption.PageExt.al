pageextension 50012 "POI Workflow Response Option" extends "Workflow Response Options"
{
    layout
    {
        addafter(Control5)
        {
            field("POI My New Response Option"; "POI My New Response Option")
            {
                ApplicationArea = All;
                ToolTip = ' ';
                Visible = "Response Option Group" = 'GROUP 50000';
            }
        }
    }
}