table 5110322 "POI Company Chain"
{
    Caption = 'Company Chain';
    DrillDownPageID = 5110399;
    LookupPageID = 5110399;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(10; Name; Text[30])
        {
            Caption = 'Name';
        }
        field(11; "Name 2"; Text[30])
        {
            Caption = 'Name 2';
        }
        field(20; "Customer No. Headoffice"; Code[20])
        {
            Caption = 'Customer No. Headoffice';
            TableRelation = Customer;
        }
        field(21; "Vendor No. Headoffice"; Code[20])
        {
            Caption = 'Vendor No. Headoffice';
            TableRelation = Vendor;
        }
        field(50; "Empties Allocation"; Option)
        {
            Caption = 'Empties Allocation';
            Description = 'LVW';
            OptionCaption = 'Without Stock-Keeping Without Invoice,With Stock-Keeping Without Invoice,With Stock-Keeping With Invoice';
            OptionMembers = "Without Stock-Keeping Without Invoice","With Stock-Keeping Without Invoice","With Stock-Keeping With Invoice";
        }
        field(51; "Empties Calculation"; Option)
        {
            Caption = 'Empties Calculation';
            Description = 'LVW';
            OptionCaption = ' ,Same Document,Separat Document,Combine Document';
            OptionMembers = " ","Same Document","Separat Document","Combine Document";
        }
        field(52; "Empties Price Group"; Code[20])
        {
            Caption = 'Empties Price Group';
            Description = 'LVW';
            TableRelation = "POI Empties Price Groups".Code;
        }
        field(53; "Observe Reduced Refund Costs"; Boolean)
        {
            Caption = 'Observe Reduced Refund Costs';
            Description = 'LVW';
        }
        field(50000; "Print EurepGAP"; Boolean)
        {
            Caption = 'Print EurepGAP';
            Description = 'CCB01 jw 11.01.2006';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    trigger OnDelete()
    var
        lrc_VendCustShipAgentEmpties: Record "POI V/C Ship.AgentEmpties";
        lrc_RefundCosts: Record "POI Empties/Transport Ref Cost";
        lrc_LabelCrossReference: Record "POI Label Cross Reference";
        lrc_TourDeliveryTimes: Record "POI Tour Delivery Times";
    begin
        lrc_VendCustShipAgentEmpties.RESET();
        lrc_VendCustShipAgentEmpties.SETRANGE(Source, lrc_VendCustShipAgentEmpties.Source::"Company Chain");
        lrc_VendCustShipAgentEmpties.SETRANGE("Source No.", Code);
        IF lrc_VendCustShipAgentEmpties.FIND('-') THEN
            lrc_VendCustShipAgentEmpties.DELETEALL(TRUE);


        lrc_RefundCosts.RESET();
        lrc_RefundCosts.SETRANGE("Source Type", lrc_RefundCosts."Source Type"::"Company Chain");
        lrc_RefundCosts.SETRANGE("Source No.", Code);
        IF lrc_RefundCosts.FIND('-') THEN
            lrc_RefundCosts.DELETEALL(TRUE);


        lrc_LabelCrossReference.RESET();
        lrc_LabelCrossReference.SETCURRENTKEY("Cross-Reference Type", "Cross-Reference Type No.");
        lrc_LabelCrossReference.SETRANGE("Cross-Reference Type", lrc_LabelCrossReference."Cross-Reference Type"::"Company Chain");
        lrc_LabelCrossReference.SETRANGE("Cross-Reference Type No.", Code);
        IF lrc_LabelCrossReference.FIND('-') THEN
            lrc_LabelCrossReference.DELETEALL(TRUE);

        lrc_TourDeliveryTimes.RESET();
        lrc_TourDeliveryTimes.SETRANGE(Source, lrc_TourDeliveryTimes.Source::Vendor);
        lrc_TourDeliveryTimes.SETRANGE("Source No.", Code);
        IF lrc_TourDeliveryTimes.FIND('-') THEN
            lrc_TourDeliveryTimes.DELETEALL(TRUE);

    end;
}

