pageextension 50111 "POI OrderAddressPage" extends "Order Address"
{
    layout
    {
        // Add changes to page layout here
        addlast(General)
        {
            field("POI Contact"; "POI Contact")
            {
                ApplicationArea = All;
                ToolTip = ' ';
                trigger OnDrillDown()
                var
                    Contact: Record Contact;

                    Vendor: Record Vendor;
                begin
                    Vendor.Get("Vendor No.");
                    ContBusRel.Reset();
                    ContBusRel.SetCurrentKey("Link to Table", "No.");
                    ContBusRel.SetRange("Link to Table", ContBusRel."Link to Table"::Vendor);
                    ContBusRel.SetRange("No.", "Vendor No.");
                    if ContBusRel.FindFirst() then begin
                        Contact.FilterGroup(2);
                        Contact.SetRange("Company No.", ContBusRel."Contact No.");
                        PAGE.Run(PAGE::"Contact List", Contact);
                        // Contact.Reset();
                        // Contact.SetRange(Type, Contact.Type::Person);
                        // Contact.SetRange("Company No.", ContBusRel."Contact No.");
                        // ContactPg.SetTableView(Contact);
                        // if ContactPg.RunModal() = Action::OK then begin
                        //     ContactPg.GetRecord(Contact);
                        //     "POI Contact" := Contact."No.";
                        // end;
                    end;

                end;
            }
            field("POI Sub-supplier"; "POI Sub-supplier")
            {
                Caption = 'Vorlieferant';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Currency"; "POI Currency")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }

        modify(Name)
        {
            Caption = 'Firmenname';
        }
        modify("Address 2")
        {
            Caption = 'Strassenanschrift';
        }
        modify(Address)
        {
            Caption = 'Adresszusatz';
        }
        modify(Communication)
        {
            Visible = false;
        }
        modify(County)
        {
            Visible = false;
        }
        modify(Contact)
        {
            Visible = false;
        }
    }
    actions
    {
        addlast(Processing)
        {
            action(POINewContact)
            {
                ApplicationArea = All;
                ToolTip = ' ';
                Caption = 'neuer Personenkontakt';
                trigger OnAction()
                var
                    Contact: Record Contact;
                    ContPage: Page "Contact List";
                begin
                    ContBusRel.Reset();
                    ContBusRel.SetCurrentKey("Link to Table", "No.");
                    ContBusRel.SetRange("Link to Table", ContBusRel."Link to Table"::Vendor);
                    ContBusRel.SetRange("No.", "Vendor No.");
                    if ContBusRel.FindFirst() then begin
                        // Contact.Init();
                        // Contact."No." := '';
                        // Contact."Company No." := ContBusRel."Contact No.";
                        // Contact.Type := Contact.Type::Person;
                        // Contact.Insert(true);
                        // AccCompSett."Account Type" := AccCompSett."Account Type"::Contact;
                        // AccCompSett."Account No." := Contact."No.";
                        // AccCompSett."Company Name" := copystr(CompanyName(), 1, 50);
                        // AccCompSett.Insert();
                        // Commit();
                        Contact.FilterGroup(2);
                        Contact.SetRange("Company No.", ContBusRel."Contact No.");
                        //PAGE.Run(PAGE::"Contact List", Contact);
                        //Contact.SetRange("No.", Contact."No.");
                        ContPage.SetTableView(Contact);
                        ContPage.RunModal();
                        // if ContPage.RunModal() = Action::OK then begin
                        //     ContPage.GetRecord(Contact);
                        //     "POI Contact" := Contact."No.";
                        // end;
                    end;
                end;
            }
        }
    }

    var
        ContBusRel: Record "Contact Business Relation";
}