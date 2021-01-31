tableextension 50019 "POI Bank Account" extends "Bank Account"
{
    fields
    {

        modify("SWIFT Code")
        {
            trigger OnAfterValidate()
            begin
                if StrLen("SWIFT Code") <> 11 then
                    Error(SwiftLengthTxt);
            end;
        }
    }
    var
        SwiftLengthTxt: Label 'SWIFT Code muss 11 Zeichen haben.';
}