tableextension 50055 "POI WorkflowUserGroup" extends "Workflow User Group"
{
    fields
    {
        field(50001; "POI Reminder Period"; DateFormula)
        {
            Caption = 'WF Erinnerungsperiode';
            DataClassification = CustomerContent;
        }
        field(50002; Infochannel; enum "POI Info Channel")
        {
            Caption = 'Nachrichtenkanal';
            DataClassification = CustomerContent;
        }
        field(50003; Webhook; Text[250])
        {
            Caption = 'Teams Webhook';
            DataClassification = CustomerContent;
        }
    }

}