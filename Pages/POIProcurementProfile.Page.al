Page 50081 "POI Procurement Profile"
{
    Description = 'Procurement Rolle';
    PageType = RoleCenter;

    layout
    {
        area(Rolecenter)
        {
            group(Control10)
            {
                ShowCaption = false;
                part(Control1907692008; "My Customers")
                {
                    ApplicationArea = RelationshipMgmt;
                }
            }
            group(Control20)
            {
                part(Control1902476008; "My Vendors")
                {
                    ApplicationArea = RelationshipMgmt;
                    Visible = false;
                }
            }
            group("My User Tasks")
            {
                Caption = 'My User Tasks';
                part("User Tasks"; "User Tasks Activities")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'User Tasks';
                }
            }
            systempart(Control1901377608; MyNotes)
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
    actions
    {
        area(Embedding)
        {
            action(Contacts)
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Kontakte';
                Image = CustomerContact;
                RunObject = Page "Contact List";
                ToolTip = 'View a list of all your contacts.';
            }
            action(Customers)
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Kunden';
                Image = Customer;
                RunObject = Page "Customer List";
                ToolTip = 'View or edit detailed information for the customers that you trade with. From each customer card, you can open related information, such as sales statistics and ongoing orders, and you can define special prices and line discounts that you grant if certain conditions are met.';
            }
            action(Vendors)
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Lieferanten';
                Image = Vendor;
                RunObject = Page "Vendor List";
                ToolTip = 'View or edit detailed information for the vendors that you trade with. From each vendor card, you can open related information, such as sales statistics and ongoing orders, and you can define special prices and line discounts that you grant if certain conditions are met.';
            }
        }
    }
}
