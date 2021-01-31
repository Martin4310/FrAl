table 5125034 "POI Time Calculation Method"
{

    Caption = 'Time Calculation Method';
    DataCaptionFields = "Code", Description;
    //LookupFormID = Form5125049;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(3; "Date Calculation"; DateFormula)
        {
            Caption = 'Date Calculation';

            trigger OnValidate()
            begin
                IF "Date Calculation" <> "0DF" THEN
                    TESTFIELD("Time Surplus (in minutes)", 0);
            end;
        }
        field(4; "Fixed Time of Day"; Time)
        {
            Caption = 'Fixed Time of Day';

            trigger OnValidate()
            begin
                IF "Fixed Time of Day" <> 0T THEN BEGIN
                    TESTFIELD("Time Surplus (in minutes)", 0);
                    TESTFIELD("Starting Time", 0T);
                    TESTFIELD("Ending Time", 0T);
                END;
            end;
        }
        field(5; "Time Surplus (in minutes)"; Integer)
        {
            Caption = 'Time Surplus (in minutes)';
            MinValue = 0;

            trigger OnValidate()
            begin
                IF "Time Surplus (in minutes)" <> 0 THEN
                    TESTFIELD("Fixed Time of Day", 0T);
            end;
        }
        field(6; Cyclic; Boolean)
        {
            Caption = 'Cyclic';

            trigger OnValidate()
            begin
                IF NOT Cyclic THEN
                    IF "Date Calculation" <> "0DF" THEN
                        "Time Surplus (in minutes)" := 0;
            end;
        }
        field(7; "Starting Date"; Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                IF ("Starting Date" <> 0D) AND ("Ending Date" <> 0D) THEN
                    IF "Starting Date" > "Ending Date" THEN
                        FIELDERROR("Ending Date");
            end;
        }
        field(8; "Ending Date"; Date)
        {
            Caption = 'Ending Date';

            trigger OnValidate()
            begin
                IF "Ending Date" <> 0D THEN
                    IF "Ending Date" < "Starting Date" THEN
                        FIELDERROR("Starting Date");
            end;
        }
        field(9; "Starting Time"; Time)
        {
            Caption = 'Starting Time';

            trigger OnValidate()
            begin
                IF ("Starting Time" <> 0T) AND ("Ending Time" <> 0T) THEN
                    IF "Starting Time" > "Ending Time" THEN
                        MESSAGE(Text001Txt, FIELDCAPTION("Starting Time"), FIELDCAPTION("Ending Time"));
            end;
        }
        field(10; "Ending Time"; Time)
        {
            Caption = 'Ending Time';

            trigger OnValidate()
            begin
                IF "Ending Time" <> 0T THEN
                    IF "Ending Time" < "Starting Time" THEN
                        MESSAGE(Text001Txt, FIELDCAPTION("Starting Time"), FIELDCAPTION("Ending Time"));
            end;
        }
        field(30; "Run on Mondays"; Boolean)
        {
            Caption = 'Run on Mondays';
            InitValue = true;
        }
        field(31; "Run on Tuesdays"; Boolean)
        {
            Caption = 'Run on Tuesdays';
            InitValue = true;
        }
        field(32; "Run on Wednesdays"; Boolean)
        {
            Caption = 'Run on Wednesdays';
            InitValue = true;
        }
        field(33; "Run on Thursdays"; Boolean)
        {
            Caption = 'Run on Thursdays';
            InitValue = true;
        }
        field(34; "Run on Fridays"; Boolean)
        {
            Caption = 'Run on Fridays';
            InitValue = true;
        }
        field(35; "Run on Saturdays"; Boolean)
        {
            Caption = 'Run on Saturdays';
        }
        field(36; "Run on Sundays"; Boolean)
        {
            Caption = 'Run on Sundays';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
        key(Key2; "Fixed Time of Day")
        {
        }
    }
    var
        "0DF": DateFormula;
        Text001Txt: Label '%1 is later than %2, job runs past midnight.', Comment = '%1 %2';
}

