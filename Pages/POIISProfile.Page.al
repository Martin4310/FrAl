Page 50082 "POI ISProfile"
{
    Description = 'IS Rolle';
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
            action(testmail)
            {
                Caption = 'Mailtest';
                ApplicationArea = All;
                ToolTip = ' ';
                RunObject = Page "POI Function Test";
            }

            // action(QM)
            // {
            //     ApplicationArea = All;
            //     Caption = 'Qualitätsmanagement';
            //     Image = QualificationOverview;
            //     RunObject = Page "POI Quality Management List";
            //     ToolTip = ' ';
            // }
        }
    }
    var

        SMTPMail: Codeunit "SMTP Mail";
}
