page 50037 "POI Tour"
{
    Caption = 'Tour';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "POI Tour";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Tour Code"; "Tour Code")
                {
                    Caption = 'Tour Nr.';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Description; Description)
                {
                    Caption = 'Beschreibung';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Shipping Agent Code"; "Shipping Agent Code")
                {
                    Caption = 'Spedition';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(StartDate; StartDate)
                {
                    Caption = 'Abfahrtsdatum';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Departure Region"; "Departure Region")
                {
                    Caption = 'Abfahrtsregion';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Transit Region"; "Transit Region")
                {
                    Caption = 'Transit Region';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Arrival Region"; "Arrival Region")
                {
                    Caption = 'Zioelregion';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Second Driver"; "Second Driver")
                {
                    Caption = 'mit zweitem Fahrer';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Logistic Cost"; "Logistic Cost")
                {
                    Caption = 'Transportkosten';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Second Driver Cost"; "Second Driver Cost")
                {
                    Caption = 'Kosten für zweiten Fahrer';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Truck No."; "Truck No.")
                {
                    Caption = 'Kfz-Kennzeichen';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Driver Name"; "Driver Name")
                {
                    Caption = 'Fahrername';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
        }
    }
}