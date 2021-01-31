enum 50006 "POI Task Status"
{
    Extensible = true;

    value(0; " ")
    {
    }
    value(1; created)
    {
        Caption = 'Erstellt';
    }
    value(2; open)
    {
        Caption = 'offen';
    }
    value(3; Approved)
    {
        Caption = 'Abgeschlossen';
    }
    //     value(4; Rejected)
    //     {
    // Caption = 'Abgelehnt';
    //     }
}