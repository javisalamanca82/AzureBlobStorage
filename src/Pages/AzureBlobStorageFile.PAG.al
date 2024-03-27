page 50001 "Azure Blob Storage File"
{
    ApplicationArea = All;
    Caption = 'Azure Blob Storage File';
    PageType = List;
    SourceTable = "Azure Blob Storage File";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Container Name"; Rec."Container Name")
                {
                    ToolTip = 'Specifies the value of the Container Name field.';
                }
                field("File Name"; Rec."File Name")
                {
                    ToolTip = 'Specifies the value of the File Name field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(DownloadFile)
            {
                Caption = 'Download File';
                ToolTip = 'Downloads the selected file in the selected folder by the user.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Download;

                trigger OnAction()
                begin
                    AzureBlobStorageMgt.DownloadFile(Rec."Container Name", Rec."File Name");
                end;
            }

            action(UploadFile)
            {
                Caption = 'Upload File';
                ToolTip = 'Uploads the selected file in the selected folder by the user.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Import;

                trigger OnAction()
                var
                    Instr: InStream;
                    FileName: Text;
                    DialogTxt: Label 'File to Import';
                begin
                    File.UploadIntoStream(DialogTxt, '', '', FileName, Instr);
                    AzureBlobStorageMgt.UploadFile(FileName, Instr);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        AzureBlobStorageMgt.GetContainerFiles(Rec, AzureBlobStorageMgt.GetContainerList());
    end;

    var
        AzureBlobStorageMgt: Codeunit "Azure Blob Storage Mgt.";
}
