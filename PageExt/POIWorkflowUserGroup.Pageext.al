pageextension 50031 "POI Workflow User Group" extends "Workflow User Group"
{
    layout
    {
        addafter(Description)
        {
            field("POI Reminder Period"; "POI Reminder Period")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field(Infochannel; Infochannel)
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field(Webhook; Webhook)
            {
                ApplicationArea = All;
                ToolTip = ' ';
                Editable = Infochannel = Infochannel::Teams;
            }
        }
    }

    actions
    {
    }
}