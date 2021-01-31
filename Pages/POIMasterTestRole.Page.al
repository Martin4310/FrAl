page 50003 "POI Master Test Role"
{
    PageType = RoleCenter;
    Caption = 'Master Test Role';

    actions
    {
        area(Processing)
        {
            action("Company")
            {
                RunPageMode = Edit;
                Caption = 'Company List';
                ToolTip = 'Add some tooltip here';
                Image = New;
                RunObject = page "POI Company";
                ApplicationArea = Basic, Suite;
            }
            action("Account Company Setting")
            {
                RunPageMode = Edit;
                Caption = 'Account Company Setting';
                ToolTip = 'Register new AppNameMasterData';
                RunObject = page "POI Account Company Setting";
                Image = DataEntry;
                ApplicationArea = Basic, Suite;
            }
            action("new Vendor/Customer")
            {
                RunPageMode = Edit;
                Caption = 'Create Account';
                RunObject = page "POI Create Account";
                ApplicationArea = All;
                ToolTip = ' ';
            }
            action("Field Permission")
            {
                RunPageMode = Edit;
                Caption = 'Field Permission';
                RunObject = page "POI Field Security";
                ApplicationArea = All;
                ToolTip = ' ';
            }
            action("Customer List")
            {
                RunPageMode = View;
                Caption = 'Customer List';
                RunObject = page "Customer List";
                ApplicationArea = All;
                ToolTip = ' ';
            }
            action("Vendor List")
            {
                RunPageMode = View;
                Caption = 'Vendor List';
                RunObject = page "Vendor List";
                ApplicationArea = All;
                ToolTip = ' ';
            }
            action("Contact List")
            {
                RunPageMode = View;
                Caption = 'Contact List';
                RunObject = page "Contact List";
                ApplicationArea = All;
                ToolTip = ' ';
            }
            action(AllObject)
            {
                RunPageMode = View;
                Caption = 'Object List';
                RunObject = page "POI AllObjects";
                ApplicationArea = All;
                ToolTip = ' ';
            }
            action(AllFields)
            {
                RunPageMode = View;
                Caption = 'Field List';
                RunObject = page "POI AllFields";
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }
    }
}