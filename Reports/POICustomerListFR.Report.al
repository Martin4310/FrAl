report 50000 "POI Customer List FR"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    RDLCLayout = 'Reports/Report_50000.rdlc';

    dataset
    {
        dataitem(Customer; Customer)
        {
            column(CustNo; "No.")
            {

            }
            column(CustomerName; Name)
            {

            }
            column(Phone_No_; "Phone No.")
            {

            }
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(CustNo; Customer.Name)
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                }
            }
        }
    }
}