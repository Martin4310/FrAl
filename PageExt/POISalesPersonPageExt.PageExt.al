pageextension 50003 "POI SalesPersonPageExt" extends "Salesperson/Purchaser Card"
{
    layout
    {

        addafter("Privacy Blocked")
        {
            field("POI Navision User ID Code"; "POI Navision User ID Code")
            {
                Caption = 'Benutzer Name';
                ApplicationArea = All;
                ToolTip = ' ';
                Importance = Additional;
                ShowMandatory = true;
            }
        }
        addafter(General)
        {
            group(Typemuss)
            {
                Visible = TypeVisible;
                ShowCaption = false;
                field(TypeText; TypeVisibleTxt)
                {
                    Caption = ' ';
                    ToolTip = ' ';
                    Editable = false;
                    StyleExpr = 'Attention';
                }
            }
            group("POI Data")
            {
                Caption = 'Typangabe';
                field("Is Salesperson"; "POI Is Salesperson")
                {
                    caption = 'Verkäufer';
                    ApplicationArea = All;
                    ToolTip = ' ';
                    trigger OnValidate()
                    begin
                        GetTypeVisible();
                        CurrPage.Update();
                    end;
                }
                field("Is Purchaser"; "POI Is Purchaser")
                {
                    Caption = 'Einkäufer';
                    ApplicationArea = All;
                    ToolTip = ' ';
                    trigger OnValidate()
                    begin
                        GetTypeVisible();
                        CurrPage.Update();
                    end;
                }
                field("Is Person in Charge"; "POI Is Person in Charge")
                {
                    Caption = 'Sachbearbeiter';
                    ApplicationArea = All;
                    ToolTip = ' ';
                    trigger OnValidate()
                    begin
                        GetTypeVisible();
                        CurrPage.Update();
                    end;
                }
                field("Is Sales Agent Person"; "POI Is Sales Agent Person")
                {
                    Caption = 'Handelsvertreter';
                    ApplicationArea = All;
                    ToolTip = ' ';
                    Importance = Additional;
                    trigger OnValidate()
                    begin
                        GetTypeVisible();
                        CurrPage.Update();
                    end;
                }
            }
            group(Company)
            {
                Caption = 'Mandantenzuordnung';

                part("POI Account Company Setting"; "POI Account Company Setting")
                {
                    Caption = ' ';
                    ApplicationArea = All;
                    ToolTip = ' ';
                    SubPageLink = "Account Type" = const(Salesperson), "Account No." = field(Code);
                }
            }
            group(Function)
            {
                Caption = 'Funktionen in der Abteilung';
                part("POI Deptm Function SalesPerson"; "POI Deptm Function SalesPerson")
                {
                    Caption = ' ';
                    ApplicationArea = All;
                    ToolTip = ' ';
                    SubPageLink = "Salesperson Code" = field(Code), "Department Code" = field("POI Department");
                }
            }
        }
        addafter(Name)
        {
            field("POI Department"; "POI Department")
            {
                ApplicationArea = All;
                ToolTip = ' ';
                ShowMandatory = true;
                StyleExpr = DepColor;
                trigger OnValidate()
                begin
                    GetDepColor();
                    CurrPage.Update();
                end;
            }
        }


        modify(Name)
        {
            ShowMandatory = true;
            Caption = 'Vorname + Nachname';
        }
        modify("Job Title")
        {
            Visible = false;
        }
        modify(Invoicing)
        {
            Visible = false;
        }
        modify("Commission %")
        {
            Importance = Additional;
            Visible = false;
        }
        modify("Phone No.")
        {
            ShowMandatory = true;
        }
        modify("E-Mail")
        {
            ShowMandatory = true;
        }
    }

    // trigger OnOpenPage()
    // begin
    //     TypeVisible := true;
    // end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        CheckMandatoryfields();
    end;

    trigger OnAfterGetRecord()
    begin
        GetTypeVisible();
        GetDepColor();
    end;

    procedure CheckMandatoryfields(): Text[250]
    var
        VortextTxt: label 'Folgende Felder müssen gefüllt sein. ';
        ErrorLabel: Text;
    //OptEnum: enum "POI Department";
    begin
        MandTxt := '';
        if not "POI Is Person in Charge" and not "POI Is Purchaser" and not "POI Is Salesperson" then
            MandTxt += 'Type /';
        //if not (OptEnum.Ordinals.Contains("POI Department".AsInteger())) then
        if "POI Department" = "POI Department"::"*" then
            MandTxt += 'Abteilung /';
        if "E-Mail" = '' then
            MandTxt += 'E-Mail /';
        if "Phone No." = '' then
            MandTxt += 'Telefonnr. /';
        if Name = '' then
            MandTxt += 'Name';
        if MandTxt <> '' then begin
            ErrorLabel := VortextTxt + MandTxt;
            Error(ErrorLabel);
        end;
    end;

    procedure GetTypeVisible()
    begin
        TypeVisible := not "POI Is Person in Charge" and not "POI Is Purchaser" and not "POI Is Sales Agent Person" and not "POI Is Salesperson";
    end;

    procedure GetDepColor()
    begin
        if "POI Department" = "POI Department"::"*" then
            DepColor := 'Attention'
        else
            DepColor := 'Standard';
    end;

    var
        MandTxt: Text[250];
        TypeVisibleTxt: label 'Mindestens ein Typ muss angegeben sein.';
        TypeVisible: Boolean;
        DepColor: Text[10];

}