page 50000 "Azure Blob Storage Setup"
{
    ApplicationArea = All;
    Caption = 'Azure Blob Storage Setup';
    PageType = Card;
    SourceTable = "Azure Blob Storage Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("Storage Account"; Rec."Storage Account")
                {
                    ToolTip = 'Specifies the value of the Storage Account field.';
                }
                field("Storage Account Key"; Rec."Storage Account Key")
                {
                    ToolTip = 'Specifies the value of the Storage Account Key field.';
                    ExtendedDatatype = Masked;
                }
                field("Import Container Name"; Rec."Import Container Name")
                {
                    ToolTip = 'Specifies the value of the Import Container Name field.';
                }
                field("Export Container Name"; Rec."Export Container Name")
                {
                    ToolTip = 'Specifies the value of the Export Container Name field.';
                }
            }
            group(Audit)
            {
                Caption = 'Audit';

                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.';
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field.';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.';
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(GetContainerList)
            {
                Caption = 'Get Container List';
                ToolTip = 'Returns the list of containers for the Azure Blob Storage Account';

                trigger OnAction()
                begin
                    AzureBlobStoreMgt.GetContainerList();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;

    var
        AzureBlobStoreMgt: Codeunit "Azure Blob Storage Mgt.";
}
