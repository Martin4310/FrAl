page 50019 "POI Certificates Restrictions"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "POI Certificates Restrictions";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Certificate Typ Code"; "Certificate Typ Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Country of Origin Code"; "Country of Origin Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Internal ID"; "Internal ID")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Producer No."; "Producer No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Product Group Code"; "Product Group Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Product Group Description"; "Product Group Description")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Trademark Code"; "Trademark Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Vendor No."; "Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
        }
        area(Factboxes)
        {

        }
    }
}