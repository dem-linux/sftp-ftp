param (
    $localPath = "D:\ftp-test\",
    $remotePath = "/"
    
)
try
{
    # Load WinSCP .NET assembly
    Add-Type -Path "C:\Users\Admin\Downloads\WinSCP-5.19.6-Automation\WinSCPnet.dll"  ## https://winscp.net/download/WinSCP-5.19.6-Automation.zip
 
    # Setup session options
    $sessionOptions = New-Object WinSCP.SessionOptions -Property @{
        Protocol = [WinSCP.Protocol]::Sftp # Port 22 Sftp | FTP Port: 21
        HostName = "139.162.149.180" #IP TO FTP/SFTP
        UserName = "username" #USERNAME
        Password = "PASSWORD"  #PASSWORD LEAVE EMPTY IF YOU USE PRIVATE KEY LIKE THIS( Password = "" )
        SshHostKeyFingerprint = "ssh-rsa 3072 XvKDGkQgF3o+tk9fRSMvON0oK29oPX7PUPygZbS2iC8"
        SshPrivateKeyPath= "C:\Users\Admin\private.ppk" #If you youse password make "SshPrivateKeyPath" to a comment or delete the line!
    }
 
    $session = New-Object WinSCP.Session
 
    try
    {
        # Connect
        $session.Open($sessionOptions)
        $transferOptions = New-Object WinSCP.TransferOptions
        $transferOptions.TransferMode = [WinSCP.TransferMode]::Binary
        $transferResult =
            $session.GetFiles("/root/SFTP/*", "D:\ftp-test\", $False, $transferOptions) #Get files from /root/SFTP/ to D:\ftp-test\
            # Use $session.PutFiles(LocalPath, RemotePath) instead If you are wanting to send files to the SFTP/FTP Server.

        # Throw on any error
        $transferResult.Check()
 
        # Print results
        foreach ($transfer in $transferResult.Transfers)
        {
           Write-Host "Download of $($transfer.FileName) to $localPath succeeded"
           $transferResult.Transfers     
        }
    }
    finally
    {
        # Disconnect, clean up (Session.Close to exit the session!)
        $session.Close()        
    }
 
    exit 0
}
catch
{
    Write-Host "Error: $($_.Exception.Message)"
    exit 1
    
}
