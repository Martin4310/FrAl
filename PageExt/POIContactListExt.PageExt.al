pageextension 50004 "POI Contact List Ext" extends "Contact List"
{
    layout
    {
        addafter("No.")
        {
            field("First Name"; "First Name")
            {
                ApplicationArea = All;
                ToolTip = 'First Name';
            }
        }

        modify("Company Name")
        {
            Visible = true;
        }
        modify("Salesperson Code")
        {
            Visible = false;
        }
        modify("Territory Code")
        {
            Visible = false;
        }
        modify(Control128)
        {
            Visible = false;
        }

    }
    actions
    {
        modify("Open Oppo&rtunities")
        {
            Visible = false;
        }
        modify("Create Opportunity")
        {
            Visible = false;
        }
        modify("Closed Oppo&rtunities")
        {
            Visible = false;
        }
    }


    trigger OnOpenPage()
    var
        POICompany: Record "POI Company";
        POIFunction: Codeunit POIFunction;
        filterstring: Text[50];
    begin
        if uppercase(CompanyName()) <> uppercase(POIFunction.GetBasicCompany()) then begin
            POICompany.Get(CompanyName());
            FilterGroup(2);
            filterstring := StrSubstNo('*%1*', POICompany."Company System ID");
            SetFilter("POI Company System Filter", filterstring);
        end;
    end;
}