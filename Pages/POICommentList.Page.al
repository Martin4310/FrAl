page 50073 "POI Comment List"
{
    Caption = 'Bemerkungen';
    PageType = ListPart;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Comment Line";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Table Name"; "Table Name")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Comment; Comment)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Date; Date)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
        }
    }
    procedure Vendorfilter(VendorNo: code[20])
    var
        Vendor: Record Vendor;
    begin
        Vendor.Get(VendorNo);
        if Vendor."POI Is Customer" <> '' then begin
            SetFilter("No.", '%1|%2', Vendor."No.", Vendor."POI Is Customer");
            SetFilter("Table Name", '%1|%2', "Table Name"::Customer, "Table Name"::Vendor);
        end else begin
            SetRange("No.", VendorNo);
            SetRange("Table Name", "Table Name"::Vendor);
        end;
        CurrPage.Update();
    end;
}