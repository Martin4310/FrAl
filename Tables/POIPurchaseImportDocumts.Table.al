table 5110563 "POI Purchase - Import Documts"
{
    Caption = 'Purchase - Import Documents';
    // DrillDownFormID = Form5110499;
    // LookupFormID = Form5110499;

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(10; "Import Doc. Code"; Code[20])
        {
            Caption = 'Import Doc. Code';
            TableRelation = "POI Import Documents";

            trigger OnValidate()
            var
                lrc_ImportDocuments: Record "POI Import Documents";
            begin
                IF "Import Doc. Code" <> '' THEN
                    IF "Import Doc. Code" <> xRec."Import Doc. Code" THEN
                        IF lrc_ImportDocuments.GET("Import Doc. Code") THEN
                            "Import Doc. Description" := lrc_ImportDocuments.Description;
            end;
        }
        field(12; "Import Doc. Description"; Text[30])
        {
            Caption = 'Import Doc. Description';
        }
        field(15; Comment; Text[80])
        {
            Caption = 'Comment';
        }
        field(17; "Expected Receiving Date"; Date)
        {
            Caption = 'Expected Receiving Date';

            trigger OnLookup()
            var
                lcu_GlobalFunctions: Codeunit "POI GlobalFunctionsMgt";
            begin
                IF lcu_GlobalFunctions.SelectDateByCalendar("Expected Receiving Date") THEN
                    VALIDATE("Expected Receiving Date");
            end;
        }
        field(20; Received; Boolean)
        {
            Caption = 'Received';

            trigger OnValidate()
            begin
                IF Received = TRUE THEN BEgin
                    IF "Date of Receiving" = 0D THEN
                        "Date of Receiving" := WORKDATE();
                END ELSE
                    "Date of Receiving" := 0D;
            end;
        }
        field(21; "Date of Receiving"; Date)
        {
            Caption = 'Date of Receiving';

            trigger OnLookup()
            var
                lcu_GlobalFunctions: Codeunit "POI GlobalFunctionsMgt";
            begin
                IF lcu_GlobalFunctions.SelectDateByCalendar("Date of Receiving") THEN
                    VALIDATE("Date of Receiving");
            end;

            trigger OnValidate()
            begin
                IF "Date of Receiving" <> 0D THEN
                    Received := TRUE;
            end;
        }
        field(50; "Due Date before Receiving"; DateFormula)
        {
            Caption = 'Due Date before Receiving';
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Line No.")
        {
        }
    }
}

