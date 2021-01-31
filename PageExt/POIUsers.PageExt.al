pageextension 50030 "POI Users" extends "User Card"
{
    layout
    {
        modify("Windows User Name")
        {
            trigger OnAfterValidate()
            begin
                CheckSalesperson();
            end;
        }
    }
    actions
    {
        addafter(AcsSetup)
        {
            action("Create Sales/Purchase Person")
            {
                ApplicationArea = All;
                ToolTip = ' ';
                trigger OnAction()
                begin
                    CheckSalesperson();
                end;
            }
        }
    }

    procedure GetNameFromFullname(Name: Text[80]): Text[80]
    var
        i: Integer;
        NameTemp: Text[80];
        Step: Boolean;
    begin
        NameTemp := Name[1];
        for i := 2 to StrLen((Name)) do begin
            if Name[i] IN ['-', ' '] then
                Step := true;
            IF Step then begin
                NameTemp += copystr(Name, i + 1, 1);
                Step := false;
            end;
        end;
        exit(NameTemp);
    end;

    procedure CheckSalesperson()
    begin
        NewSign := copystr(GetNameFromFullname("Full Name"), 1, 10);
        if not SalesPerson.get(NewSign) then begin
            SalesPerson.Init();
            SalesPerson.Code := NewSign;
            SalesPerson.Name := copystr("Full Name", 1, 50);
            SalesPerson."POI Navision User ID Code" := "User Name";
            SalesPerson.Insert();
        end;
        Commit();
        RunModal(Page::"Salesperson/Purchaser Card", SalesPerson);
        CreateUserSetup(NewSign);
    end;

    procedure CreateUserSetup(SalesCode: code[10])
    begin
        if not UserSetup.Get("User Name") then begin
            UserSetup.Init();
            UserSetup."User ID" := "User Name";
            UserSetup."Salespers./Purch. Code" := SalesCode;
            UserSetup.Insert();
        end;
        Commit();
        RunModal(page::"User Setup", UserSetup);
    end;

    var
        SalesPerson: Record "Salesperson/Purchaser";
        UserSetup: Record "User Setup";
        NewSign: Text[10];
}