pageextension 50100 "POI Contact Card Ext" extends "Contact Card"
{
    layout
    {
        // Add changes to page layout here
        addlast(General)
        {
            field("POI Company System Filter"; "POI Company System Filter")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = false;
                ToolTip = ' ';
            }
        }
        addafter(General)
        {
            group("POI CreditorType")
            {
                Visible = false;
                Caption = 'Kreditorentyp';
                field("POI Supplier of Goods"; "POI Supplier of Goods")
                {
                    Caption = 'Warenlieferant';
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = ' ';
                }
                field("POI Carrier"; "POI Carrier")
                {
                    Caption = 'Spedition';
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = ' ';
                }
                field("POI Warehouse Company"; "POI Warehouse Keeper")
                {
                    Caption = 'Lagerhalter';
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = ' ';
                }
                field("POI Customs Agent"; "POI Customs Agent")
                {
                    Caption = 'Zollagent';
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = ' ';
                }
                field("POI Tax Representative"; "POI Tax Representative")
                {
                    Caption = 'Fiskalvertreter';
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = ' ';
                }
                field("POI Diverse Vendor"; "POI Diverse Vendor")
                {
                    Caption = 'diverser Kreditor';
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = ' ';
                }
                field("POI Small Vendor"; "POI Small Vendor")
                {
                    Caption = 'Kleinstkreditor';
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = ' ';
                }
                field("POI Shipping Company"; "POI Shipping Company")
                {
                    Caption = 'Reederei';
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = ' ';
                }

            }
            part("POI CompanyAllocation"; "POI Account Company Setting")
            {
                Caption = 'Mandantenzuordnung';
                ApplicationArea = Basic, Suite;
                SubPageLink = "Account No." = FIELD("No."), "Account Type" = Const(Contact), Visible = const(true);
                UpdatePropagation = Both;
            }
        }
        movefirst(General; "No.")
        moveafter("No."; Type)
        moveafter(Type; "Salutation Code")
        addafter("Salutation Code")
        {
            field("First Name"; "First Name")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }
        moveafter("First Name"; Name)
        addafter(Name)
        {
            grid(POIname2grid)
            {
                label(Name2label)
                {
                    Caption = 'Unternehmensname Vorlieferant/Kunde des Lieferanten/Kunden sofern Kontaktadresse dort';
                }
                field("Name 2"; "Name 2")
                {
                    Caption = 'Name 2';
                    ToolTip = ' ';
                    ShowCaption = false;
                }
            }
            field("POI Department"; "POI Department")
            {
                Caption = 'Abteilung';
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }
        moveafter("POI Department"; "Company Name")
        addafter("Company Name")
        {
            field("POI Vendor or Customer"; "POI VendororCustomer")
            {
                caption = 'Kontaktart';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("Group Contact"; "POI Group Contact")
            {
                Caption = 'mandantenübergreifender Kontakt';
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }
        moveafter("Group Contact"; "Privacy Blocked")
        moveafter("Privacy Blocked"; LastDateTimeModified)



        modify("Parental Consent Received")
        {
            Visible = false;
        }
        modify(Minor)
        {
            Visible = false;
        }
        modify("Date of Last Interaction")
        {
            Visible = false;
        }
        modify("Company No.")
        {
            Visible = false;
        }
        modify("Next Task Date")
        {
            Visible = false;
        }
        modify("Salesperson Code")
        {
            Visible = false;
        }
        modify("Search Name")
        {
            Visible = false;
        }
        modify("Exclude from Segment")
        {
            Visible = false;
        }
        modify("Home Page")
        {
            Visible = false;
        }
        modify("Phone No.")
        {
            Caption = 'Telefonnummer (Vorwahl + Tel.)';
        }
        modify("Foreign Trade")
        {
            Visible = false;
        }
        modify("Organizational Level Code")
        {
            Visible = false;
        }
        modify("Profile Questionnaire")
        {
            Visible = false;
        }
        modify("Company Name")
        {
            Visible = false;
        }
        modify(Control41)
        {
            Visible = false;
        }

    }

    actions
    {
        addlast(Navigation)
        {
            action("POI Create Customer/Vendor")
            {
                Caption = 'Create Customer/Vendor';
                ApplicationArea = All;
                ToolTip = ' ';
                trigger OnAction()
                var
                    Contact: Record Contact;
                    MarkSetup: Record "Marketing Setup";
                begin

                    OnAfterCreateContact(Rec);

                    MarkSetup.Get();
                    if "POI VendororCustomer" = "POI VendororCustomer"::Customer then begin
                        Contact.Init();
                        Contact.Name := Name;
                        Contact."POI VendororCustomer" := "POI VendororCustomer"::Customer;
                        Contact.Insert();
                    end;
                end;
            }
            action("POI Generate Account")
            {
                ApplicationArea = all;
                RunObject = Page "POI ContactCreate";
                RunPageMode = Edit;
                ToolTip = ' ';
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
            AccSettingEditable := false;
        end else
            AccSettingEditable := true;
    end;

    trigger OnClosePage()
    var
        AccCompSetting: Record "POI Account Company Setting";
    begin
        AccCompSetting.SetAccCompSetting("No.", AccCompSetting."Account Type"::Contact);
    end;

    [IntegrationEvent(true, false)]
    procedure OnAfterCreateContact(Contact: Record Contact)
    begin

    end;

    var
        AccSettingEditable: Boolean;
}