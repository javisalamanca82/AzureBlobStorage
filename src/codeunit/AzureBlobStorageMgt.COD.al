codeunit 50000 "Azure Blob Storage Mgt."
{
    procedure DownloadFile(ContainerName: Text[250]; FileName: Text[250])
    var
        InStr: InStream;
        DialogTxt: Label 'Download File';
    begin
        InitContainerContent(ContainerName);

        ABSContainerContent.SetRange("Full Name", FileName);
        if not ABSContainerContent.FindFirst() then
            Error(ABSContainerContentErr, ContainerName);

        ABSBlobclient.GetBlobAsStream(ABSContainerContent.Name, InStr);

        File.DownloadFromStream(InStr, DialogTxt, '', '', FileName);
    end;

    procedure GetContainerFiles(var AzureBlobStorageFile: Record "Azure Blob Storage File"; ContainerName: Text[250])
    var
        EntryNo: Integer;
    begin
        InitContainerContent(ContainerName);

        if ABSContainerContent.FindSet() then
            repeat
                EntryNo += 1;
                AzureBlobStorageFile.Init();
                AzureBlobStorageFile."Entry No." := EntryNo;
                AzureBlobStorageFile."Container Name" := ContainerName;
                AzureBlobStorageFile."File Name" := ABSContainerContent."Full Name";
                AzureBlobStorageFile.Insert();
            until ABSContainerContent.Next() = 0;
    end;

    procedure GetContainerList(): Text
    var
        StandardText: Record "Standard Text" temporary;
        i: Integer;
    begin
        GetAzureBlobStorageSetup();

        StoregeServiceAuthorizationInterface := StorageServiceAuthorization.CreateSharedKey(AzureBobStorageSetup."Storage Account Key");
        ABSContainerClient.Initialize(AzureBobStorageSetup."Storage Account", StoregeServiceAuthorizationInterface);

        ABSOperationResponse := ABSContainerClient.ListContainers(ABSContainer);

        if not ABSOperationResponse.IsSuccessful() then
            Error(ABSContainerListErr, AzureBobStorageSetup."Storage Account");

        if ABSContainer.FindSet() then begin
            repeat
                i += 1;
                StandardText.Init();
                StandardText.Code := Format(i);
                StandardText.Description := ABSContainer.Name;
                StandardText.Insert();
            until ABSContainer.Next() = 0;
            if Page.RunModal(0, StandardText) = Action::LookupOK then
                exit(StandardText.Description);
        end else
            Error(ABSContainerListErr, AzureBobStorageSetup."Storage Account");
    end;

    procedure UploadFile(FileName: Text; Instr: InStream)
    var
        ContainerErr: Label 'Container %1 cannot be created.';
        UploadErr: Label 'File %1 was not uploaded. Contact your administrator.';
        UploadSuccessLbl: Label 'File %1 was successfully updated in container %2.';
    begin
        GetAzureBlobStorageSetup();

        StoregeServiceAuthorizationInterface := StorageServiceAuthorization.CreateSharedKey(AzureBobStorageSetup."Storage Account Key");
        ABSContainerClient.Initialize(AzureBobStorageSetup."Storage Account", StoregeServiceAuthorizationInterface);

        ABSOperationResponse := ABSContainerClient.CreateContainer(AzureBobStorageSetup."Export Container Name");

        ABSBlobclient.Initialize(AzureBobStorageSetup."Storage Account", AzureBobStorageSetup."Export Container Name", StoregeServiceAuthorizationInterface);
        ABSOperationResponse := ABSBlobclient.PutBlobBlockBlobStream(FileName, Instr);
        if not ABSOperationResponse.IsSuccessful() then
            Error(UploadErr, FileName);

        Message(UploadSuccessLbl, FileName, AzureBobStorageSetup."Export Container Name");
    end;

    #region localprocedures
    local procedure GetAzureBlobStorageSetup()
    begin
        if SetupInitialized then
            exit;

        AzureBobStorageSetup.Get();
        SetupInitialized := true;
    end;

    local procedure InitContainerContent(ContainerName: Text[250])
    begin
        GetAzureBlobStorageSetup();

        StoregeServiceAuthorizationInterface := StorageServiceAuthorization.CreateSharedKey(AzureBobStorageSetup."Storage Account Key");
        ABSBlobclient.Initialize(AzureBobStorageSetup."Storage Account", ContainerName, StoregeServiceAuthorizationInterface);
        ABSOperationResponse := ABSBlobclient.ListBlobs(ABSContainerContent);
        if not ABSOperationResponse.IsSuccessful() then
            Error(ABSContainerContentErr, ContainerName);
    end;
    #endregion

    var
        ABSContainer: Record "ABS Container";
        ABSContainerContent: Record "ABS Container Content";
        AzureBobStorageSetup: Record "Azure Blob Storage Setup";
        ABSBlobclient: Codeunit "ABS Blob Client";
        ABSContainerClient: Codeunit "ABS Container Client";
        ABSOperationResponse: Codeunit "ABS Operation Response";
        StorageServiceAuthorization: Codeunit "Storage Service Authorization";
        StoregeServiceAuthorizationInterface: Interface "Storage Service Authorization";
        SetupInitialized: Boolean;
        ABSContainerListErr: Label 'Error on retrieving container list for storage account %1.';
        ABSContainerContentErr: Label 'Error on retrieveing files from container %1.';
        NoContainersFoundErr: Label 'No containers were found.';
}