pageextension 50002 "POI CustomerListExt" extends "Customer List"
{
    PromotedActionCategories = ' ';

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Error('Kreditoren anlegen nur über neue Geschäftspartner');
    end;

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