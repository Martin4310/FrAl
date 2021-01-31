tableextension 50015 "POI Comment Line Ext" extends "Comment Line"
{
    fields
    {
        modify(Code)
        {
            trigger OnBeforeValidate()
            begin
                if not POIFunction.CheckPermission(97, FieldNo(Code), 2) then
                    ERROR(ERR_NoPermissionTxt);
            end;
        }
        modify(Comment)
        {
            trigger OnBeforeValidate()
            begin
                if not POIFunction.CheckPermission(97, FieldNo(Comment), 2) then
                    ERROR(ERR_NoPermissionTxt);
            end;
        }
        modify(Date)
        {
            trigger OnBeforeValidate()
            begin
                if not POIFunction.CheckPermission(97, FieldNo(Date), 2) then
                    ERROR(ERR_NoPermissionTxt);
            end;
        }
    }
    trigger OnAfterModify()
    begin
        if ("Table Name" = "Table Name"::Customer) or ("Table Name" = "Table Name"::Vendor) then begin
            SynchCommentToGroupAccountAndDebKred();
            SynchCommentGroupmembers();
        end;
    end;

    trigger OnAfterInsert()
    begin
        if ("Table Name" = "Table Name"::Customer) or ("Table Name" = "Table Name"::Vendor) then begin
            SynchCommentToGroupAccountAndDebKred();
            SynchCommentGroupmembers();
        end;
    end;

    trigger OnAfterDelete()
    begin
        if ("Table Name" = "Table Name"::Customer) or ("Table Name" = "Table Name"::Vendor) then begin
            SynchCommentToGroupAccountAndDebKred();
            SynchCommentGroupmembers();
        end;
    end;

    procedure SynchCommentToGroupAccountAndDebKred()
    var
        Synch: Codeunit "POI Account Synchronisation";
    begin
        case "Table Name" of
            "Table Name"::Customer:
                begin
                    Customer.Get("No.");
                    Synch.SynchCommentFromAccountToAccont(Customer."No.", 0, Customer."No.", 0, false);
                    if Customer."POI Is Vendor" <> '' then
                        Synch.SynchCommentFromAccountToAccont(Customer."No.", 0, Customer."POI Is Vendor", 1, true);
                    if Customer."POI Customer Group Code" <> '' then
                        Synch.SynchCommentFromAccountToAccont(Customer."No.", 0, Customer."POI Group Customer", 0, true);
                end;
            "Table Name"::Vendor:
                begin
                    Vendor.Get("No.");
                    Synch.SynchCommentFromAccountToAccont(Vendor."No.", 1, Vendor."No.", 1, false);
                    if Vendor."POI Is Customer" <> '' then
                        Synch.SynchCommentFromAccountToAccont(Vendor."No.", 1, Vendor."POI Is Customer", 0, true);
                    if Vendor."POI Vendor Group Code" <> '' then
                        Synch.SynchCommentFromAccountToAccont(Vendor."No.", 1, Vendor."POI Vendor Group Code", 1, true);
                end;
        end;
    end;

    procedure SynchCommentGroupmembers()
    var
        Synch: Codeunit "POI Account Synchronisation";
    begin
        case "Table Name" of
            "Table Name"::Vendor:
                begin
                    Vendor.SetRange("POI Vendor Group Code", "No.");
                    if Vendor.FindSet() then
                        repeat
                            Synch.SynchCommentFromAccountToAccont("No.", 1, Vendor."No.", 1, true);
                        until Vendor.Next() = 0;
                end;
            "Table Name"::Customer:
                begin
                    Customer.SetRange("POI Customer Group Code", "No.");
                    if Customer.FindSet() then
                        repeat
                            Synch.SynchCommentFromAccountToAccont("No.", 0, Customer."No.", 0, true);
                        until Customer.Next() = 0;
                end;
        end;
    end;

    var
        Customer: Record Customer;
        Vendor: Record Vendor;
        POIFunction: Codeunit POIFunction;
        ERR_NoPermissionTxt: Label 'Keine Berechtigung für Änderungen';
}