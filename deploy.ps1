# Langkah 1: Generate aplikasi Nuxt
Write-Host "Generating Nuxt application..."
npm run generate

# Langkah 2: Menghapus file dan direktori di FTP kecuali yang disebutkan
Write-Host "Connecting to FTP and cleaning up files..."
$ftpServer = "ftp.kaderpintar.id:21"
$ftpUsername = "kaderpintarid@kaderpintar.id"
$ftpPassword = "kaderpintar.id"
$ftpPath = "/"

# Buat FTP Web Request untuk menghapus file dan direktori
function Remove-FtpFiles {
    param (
        [string]$ftpServer,
        [string]$ftpUsername,
        [string]$ftpPassword,
        [string]$ftpPath
    )
    $ftpRequest = [System.Net.FtpWebRequest]::Create("ftp://$ftpServer$ftpPath")
    $ftpRequest.Credentials = New-Object System.Net.NetworkCredential($ftpUsername, $ftpPassword)
    $ftpRequest.Method = [System.Net.WebRequestMethods+Ftp]::ListDirectoryDetails

    $response = $ftpRequest.GetResponse()
    $stream = $response.GetResponseStream()
    $reader = New-Object System.IO.StreamReader($stream)

    while (!$reader.EndOfStream) {
        $line = $reader.ReadLine()
        $fileName = $line.Split()[-1]

        # Jangan hapus file atau direktori yang dikecualikan
        if ($fileName -notin @(".well-known", "cgi-bin", "ftpquota", ".htaccess")) {
            Write-Host "Deleting $fileName..."
            $deleteRequest = [System.Net.FtpWebRequest]::Create("ftp://$ftpServer$ftpPath/$fileName")
            $deleteRequest.Credentials = New-Object System.Net.NetworkCredential($ftpUsername, $ftpPassword)
            $deleteRequest.Method = [System.Net.WebRequestMethods+Ftp]::DeleteFile
            $deleteRequest.GetResponse() | Out-Null
        }
    }

    $reader.Close()
    $response.Close()
}

Remove-FtpFiles -ftpServer $ftpServer -ftpUsername $ftpUsername -ftpPassword $ftpPassword -ftpPath $ftpPath

# Langkah 3: Upload file ke FTP
Write-Host "Uploading files to FTP..."
$localPath = "$PWD\.output\public\*"
$webClient = New-Object System.Net.WebClient
$webClient.Credentials = New-Object System.Net.NetworkCredential($ftpUsername, $ftpPassword)

Get-ChildItem -Path $localPath -Recurse | ForEach-Object {
    $relativePath = $_.FullName.Substring($PWD.Length + 1)
    $ftpFilePath = "$ftpPath/$relativePath".Replace("\", "/")

    if ($_.PSIsContainer) {
        # Buat direktori di FTP
        try {
            $makeDirRequest = [System.Net.FtpWebRequest]::Create("ftp://$ftpServer$ftpFilePath")
            $makeDirRequest.Credentials = New-Object System.Net.NetworkCredential($ftpUsername, $ftpPassword)
            $makeDirRequest.Method = [System.Net.WebRequestMethods+Ftp]::MakeDirectory
            $makeDirRequest.GetResponse() | Out-Null
        } catch {
            Write-Host "Directory already exists: $ftpFilePath"
        }
    } else {
        # Upload file ke FTP
        $uri = "ftp://$ftpServer$ftpFilePath"
        $webClient.UploadFile($uri, $_.FullName)
        Write-Host "Uploaded $relativePath"
    }
}

Write-Host "Deployment completed successfully!"