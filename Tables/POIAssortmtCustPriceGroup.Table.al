table 5110341 "POI Assortmt-Cust. Price Group"
{
    Caption = 'Assortment - Cust. Price Group';

    fields
    {
        field(1; "Assortment Code"; Code[10])
        {
            Caption = 'Assortment Code';
            TableRelation = "POI Assortment";
        }
        field(2; "Customer Price Group Code"; Code[10])
        {
            Caption = 'Customer Price Group Code';
            TableRelation = "Customer Price Group";
        }
        field(10; "Sort Order"; Integer)
        {
            Caption = 'Sort Order';
        }
        field(20; "Show Purch. Price"; Option)
        {
            Caption = 'Show Purch. Price';
            OptionCaption = ' ,Direct Unit Price last Invoice,Direct Unit Price last Order,MEK-Price,Unit Price last Order';
            OptionMembers = " ","Direct Unit Price last Invoice","Direct Unit Price last Order","MEK-Price","Unit Price last Order";
        }
    }

    keys
    {
        key(Key1; "Assortment Code", "Customer Price Group Code")
        {
        }
        key(Key2; "Sort Order")
        {
        }
    }
}

