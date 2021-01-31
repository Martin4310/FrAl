tableextension 50029 "POI Location Ext" extends Location
{
    fields
    {
        field(50000; "POI Departure Region"; Code[20])
        {
            Caption = 'Departure Region';
            DataClassification = CustomerContent;
            TableRelation = "POI Departure Region".Code where(RegionType = const(Departure));
        }
        field(50001; "POI Arrival Region"; Code[20])
        {
            Caption = 'Arrival Region';
            DataClassification = CustomerContent;
            TableRelation = "POI Departure Region".Code where(RegionType = const(Arrival));
        }
        field(50002; "POI Shipping Agent Code"; Code[20])
        {
            Caption = 'Shipping Agent';
            DataClassification = CustomerContent;
            TableRelation = "Shipping Agent".Code;
        }
        field(5110300; "POI Locat Bin Pallets Required"; Boolean)
        {
            Caption = 'Location Bin Pallets Required';
            Description = 'PAL';
        }
        field(5110310; "POI Location Group Code"; Code[10])
        {
            Caption = 'Location Group Code';
            TableRelation = "POI Location Group";
        }
        field(5110316; "POI Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor WHERE("POI Warehouse Keeper" = CONST(true));
        }
        field(5110320; "POI Status Customs Duty"; Option)
        {
            Caption = 'Status Customs Duty';
            OptionCaption = ' ,Payed,Not Payed';
            OptionMembers = " ",Payed,"Not Payed";
        }
        field(5110323; "POI Quality Control Vendor No."; Code[20])
        {
            Caption = 'Quality Control by Vend. No.';
            TableRelation = Vendor WHERE("POI Is Quality Controller" = CONST(true));
        }
        field(5110342; "POI Level Stock Control"; Option)
        {
            Caption = 'Level Stock Control';
            OptionCaption = 'Location,Location Group,Company';
            OptionMembers = Location,"Location Group",Company;
        }
        field(5110351; "POI Fiscal Agent Code"; Code[10])
        {
            Caption = 'Fiscal Agent Code';
            TableRelation = "POI Fiscal Agent";
        }
        field(5110360; "POI Port of Disch. Code (UDE)"; Code[10])
        {
            Caption = 'Port of Discharge Code (UDE)';
            TableRelation = "Entry/Exit Point";
        }
        field(5110399; "POI Search Name"; Code[30])
        {
            Caption = 'Search Name';
        }
        field(5110400; "POI Blocked"; Option)
        {
            Caption = 'Blocked';
            OptionCaption = ' ,Blocked';
            OptionMembers = " ",Blocked;
        }
    }
}