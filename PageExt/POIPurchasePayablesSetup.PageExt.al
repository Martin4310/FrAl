pageextension 50013 "POI Purchase Payables Setup" extends "Purchases & Payables Setup"
{
    layout
    {
        addlast(General)
        {
            field("Default Del. Rem. Date Field"; "Default Del. Rem. Date Field")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }
    }

}