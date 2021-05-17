<powershell>
$cwagent = "https://s3.amazonaws.com/amazoncloudwatch-agent/windows/amd64/latest/AmazonCloudWatchAgent.zip"
$cwdownload = "c:\cwagent"
$cwconfig = "https://s3.amazonaws.com/ec2-downloads-windows/CloudWatchConfig/AWS.EC2.Windows.CloudWatch.json"

mkdir $cwdownload
wget $cwagent -OutFile "$cwdownload\cwagent.zip"
Add-Type -AssemblyName System.IO.Compression.FileSystem

function Unzip
{
    param([string]$zipfile, [string]$outpath)
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}

Unzip "$cwdownload\cwagent.zip" "$cwdownload"
cd "$cwdownload"
.\install.ps1

wget $cwconfig -OutFile "C:\Program Files\Amazon\AmazonCloudWatchAgent\config.json"
cd "C:\Program Files\Amazon\AmazonCloudWatchAgent"
.\amazon-cloudwatch-agent-ctl.ps1 -a fetch-config -m ec2 -c file:config.json -s
</powershell>
