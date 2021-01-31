codeunit 50003 "POI Test USTID"
{
    procedure TestID(CustNo: Code[20])
    var
        Customer: Record Customer;
        VatValidation: DotNet "POI MyValidation";
        VATTrue: Boolean;
        CountryCode: Text[10];

    begin
        Customer.Get(CustNo);
        CountryCode := 'DE';
        VatValidation.checkVat(CountryCode, Customer."VAT Registration No.", VATTrue, Customer.Name, Customer.Address);
        IF VATTrue then
            Message('VAT ID ist gültig');
    end;
}