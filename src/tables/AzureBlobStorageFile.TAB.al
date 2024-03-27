table 50001 "Azure Blob Storage File"
{
    Caption = 'Azure Blob Storage File';
    DataClassification = CustomerContent;
    TableType = Temporary;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Container Name"; Text[250])
        {
            Caption = 'Container Name';
        }
        field(3; "File Name"; Text[250])
        {
            Caption = 'File Name';
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
