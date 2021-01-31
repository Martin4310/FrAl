tableextension 50024 "POI Order Address Ext" extends "Order Address"
{
    fields
    {
        field(50101; "POI Sub-supplier"; Boolean)
        {
            Caption = 'Sub-supplier';
            DataClassification = CustomerContent;
        }
        field(50000; "POI Currency"; Code[10])
        {
            Caption = 'Währung';
            DataClassification = CustomerContent;
        }
        field(50001; "POI Contact"; Code[20])
        {
            Caption = 'Kontakt';
            DataClassification = CustomerContent;
        }
        // modify(Name)
        // {
        //     trigger OnAfterValidate()
        //     begin
        //         if Name <> xRec.Address then
        //             SynchOrderAddressField(FieldNo(Name), "Vendor No.", Code, Name);
        //     end;
        // }
        // modify(Address)
        // {
        //     trigger OnAfterValidate()
        //     begin
        //         if Address <> xRec.Address then
        //             SynchOrderAddressField(FieldNo(Address), "Vendor No.", Code, Address);
        //     end;
        // }
    }
    trigger OnInsert()
    begin
        POICompany.Reset();
        POICompany.SetRange("Synch Masterdata", true);
        POICompany.SetFilter(Mandant, '<>%1', CompanyName());
        if POICompany.FindSet() then
            repeat
                OrderAddress.ChangeCompany(POICompany.Mandant);
                OrderAddress := Rec;
                OrderAddress.Insert();
            until POICompany.Next() = 0;
    end;

    trigger OnBeforeDelete()
    begin
        POICompany.Reset();
        POICompany.SetRange("Synch Masterdata", true);
        POICompany.SetFilter(Mandant, '<>%1', CompanyName());
        if POICompany.FindSet() then
            repeat
                OrderAddress.ChangeCompany();
                if OrderAddress.Get("Vendor No.", Code) then
                    OrderAddress.Delete();
            until POICompany.Next() = 0;
    end;

    procedure SynchOrderAddressField(FieldID: Integer; AccountNo: Code[20]; CodeID: code[10]; NewValue: Variant)
    begin
        POICompany.Reset();
        POICompany.SetRange("Synch Masterdata", true);
        POICompany.SetFilter(Mandant, '<>%1', CompanyName());
        if POICompany.FindSet() then
            repeat
                OrderAddress.ChangeCompany(CompanyName());
                if OrderAddress.Get(AccountNo, CodeID) then begin
                    case FieldID of
                        3:
                            OrderAddress.Name := NewValue;
                        4:
                            OrderAddress."Name 2" := NewValue;
                        5:
                            OrderAddress.Address := NewValue;
                        6:
                            OrderAddress."Address 2" := NewValue;
                        7:
                            OrderAddress.City := NewValue;
                        9:
                            OrderAddress."Phone No." := NewValue;
                        91:
                            OrderAddress."Post Code" := NewValue;
                    end;
                    OrderAddress.Modify();
                end;
            until POICompany.Next() = 0;
    end;

    var
        POICompany: Record "POI Company";
        OrderAddress: Record "Order Address";

}