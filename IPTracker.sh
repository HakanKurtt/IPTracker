#! /bin/bash
# Comment Line
function sendMail
{
    mail - s "IP" entegre95@gmail.com < mail.txt
}

function IPMovements
{
    echo "Disconnected IPs" > mail.txt
    diff firstIPControl.txt secondIPControl.txt | grep '<' >> mail.txt
    echo "Connected IPs" >> mail.txt
    diff firstIPControl.txt secondIPControl.txt | grep '>' >> mail.txt
    sendMail
}

# cat file1.txt>>file2.txt

function IPControl
{
    nmap -sn 192.168.47.0/24 | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' > $1 # $1 represent file name such as 'firstIpControl.txt','secondIpControl.txt'...
    while read line 
    do
        IPTemp="$line"
        ex -s +"g/$IPTemp/d" -cwq $1
    done < IPLib.txt
}


function firstStart
{
    numberOfFindedLine=$(grep -c '1' firstIPControl.txt)

    if [ "$numberOfFindedLine" != 0 ]
    then
        IPControl $1
        IPMovements
    fi
}

#First Start Check
ls firstIPControl.txt && firstStart secondIPControl.txt{
    IPControl secondIPControl.txt
    IPMovements
    secondIPControl.txt > firstIPControl.txt
} ||{ echo "Creating..."
    > firstIPControl.txt
    IPControl firstIPControl.txt
}

#Checking NMAP
nmap -sn 192.168.47.113 ||{ echo "nmap is not found... installing..." 
    sudo apt-get install nmap
}