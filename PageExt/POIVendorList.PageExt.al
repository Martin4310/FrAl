pageextension 50005 "POI VendorList" extends "Vendor List"
{


    PromotedActionCategories = 'Port';

    actions
    {
        addfirst("Ven&dor")
        {
            action(createAccount)
            {
                Caption = 'Kreditor anlegen';
                ApplicationArea = All;
                ToolTip = 'Anlage von Kreditor oder Debitor';
                RunObject = Page "POI Create Account";
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
            }
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