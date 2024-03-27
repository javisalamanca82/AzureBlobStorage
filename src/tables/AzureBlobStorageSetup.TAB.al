table 50000 "Azure Blob Storage Setup"
{
    Caption = 'Azure Blob Storage Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Storage Account Key"; Text[2024])
        {
            Caption = 'Storage Account Key';
        }
        field(3; "Storage Account"; Text[50])
        {
            Caption = 'Storage Account';
        }
        field(4; "Import Container Name"; Text[50])
        {
            Caption = 'Import Container Name';
        }
        field(5; "Export Container Name"; Text[50])
        {
            Caption = 'Export Container Name';
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
