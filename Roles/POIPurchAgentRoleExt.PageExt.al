pageextension 50001 "POI PurchAgentRoleExt" extends "Purchasing Agent Role Center"
{

    actions
    {
        addafter(Items)
        {
            action("POI Create Account")
            {
                Caption = 'Create Account';
                ApplicationArea = All;
                RunObject = page "POI ContactCreate";
                RunPageMode = Edit;
                ToolTip = ' ';
            }
        }
    }
}