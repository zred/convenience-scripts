# ============================================================================
# SSH Key Generator Script
# Generates an Ed25519 SSH key pair and copies the public key to clipboard
# ============================================================================

# ============================================================================
# 1. Initialize Variables
# ============================================================================
Write-Host "Initializing variables..." -ForegroundColor Green

$UserName = $env:USERNAME
$HostName = $env:COMPUTERNAME
$TimeStamp = $(Get-Date).ToString('yyyyMMddHHmmss')

Write-Host "User: $UserName" -ForegroundColor Cyan
Write-Host "Host: $HostName" -ForegroundColor Cyan
Write-Host "Timestamp: $TimeStamp" -ForegroundColor Cyan

# ============================================================================
# 2. Ensure SSH Directory Exists
# ============================================================================
Write-Host "`nEnsuring .ssh directory exists..." -ForegroundColor Green

$SshDirectoryPath = "$env:USERPROFILE\.ssh"

try {
    $SshKeyPath = $(Resolve-Path $SshDirectoryPath)
    Write-Host "Found existing .ssh directory: $SshKeyPath" -ForegroundColor Yellow
} catch {
    Write-Host "Creating .ssh directory at: $SshDirectoryPath" -ForegroundColor Yellow
    $SshKeyPath = New-Item -ItemType Directory -Path $SshDirectoryPath -Force
}

# ============================================================================
# 3. Set Secure Permissions on SSH Directory
# ============================================================================
Write-Host "`nSecuring .ssh directory permissions..." -ForegroundColor Green

$acl = Get-Acl $SshKeyPath
$acl.SetAccessRuleProtection($true, $false)  # Disable inheritance, remove existing rules
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
    $UserName, 
    "FullControl", 
    "ContainerInherit,ObjectInherit", 
    "None", 
    "Allow"
)
$acl.SetAccessRule($accessRule)
Set-Acl -Path $SshKeyPath -AclObject $acl

Write-Host "Permissions set - only $UserName has access" -ForegroundColor Yellow

# ============================================================================
# 4. Generate SSH Key Pair
# ============================================================================
Write-Host "`nGenerating SSH key pair..." -ForegroundColor Green

$SshKeyFilePath = $(Join-Path $SshKeyPath "id_ed25519_${HostName}_${TimeStamp}")
$SshKeyComment = "$UserName on $HostName at $TimeStamp"

Write-Host "Key file: $SshKeyFilePath" -ForegroundColor Cyan
Write-Host "Comment: $SshKeyComment" -ForegroundColor Cyan

ssh-keygen -t ed25519 -C $SshKeyComment -f $SshKeyFilePath -N '""'

# ============================================================================
# 5. Copy Public Key to Clipboard
# ============================================================================
Write-Host "`nCopying public key to clipboard..." -ForegroundColor Green

$PublicKeyContent = Get-Content "$SshKeyFilePath.pub"
Set-Clipboard -Value $PublicKeyContent

Write-Host "Public key copied to clipboard!" -ForegroundColor Green
Write-Host "`nPublic key content:" -ForegroundColor Cyan
Write-Host $PublicKeyContent -ForegroundColor White

Write-Host "`nSSH key generation complete!" -ForegroundColor Green