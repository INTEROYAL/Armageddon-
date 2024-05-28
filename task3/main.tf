terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  credentials = file("gcp-cli-testing-b4eced71061d.json")
  project     = "gcp-cli-testing"
}

#Reminders, make sure machine size is medium, make sure image is debian 11 preferably (projects/debian-cloud/global/images/family/debian-11)
# ______________________________________________________________________TEST VERIFICATION PROCEDURE__________________________________________________________________________________________________________
# 1) Obtain Ip Addresses Example: 
# asia_instance_url = "http://192.168.202.2"
# europe_instance_url = "http://10.210.1.2"
# us_central_instance_url = "http://34.123.195.253"
# us_west_instance_url = "http://35.203.156.140"

#2) Testing
#3) Test access to Europe Gaming headquarters from americas us-central & us-west using (curl -v http://10.210.1.2) 
#test a) US Central (curl -v http://10.210.1.2)
#test b) US West    (curl -v http://10.210.1.2)
#Europe Config) Europe Must first be configured for RDP 3389 (sudo apt update  > sudo apt install xrdp > sudo systemctl start xrdp >  sudo systemctl enable xrdp > sudo systemctl status xrdp)
#Check Europe listening port (sudo netstat -tuln | grep 3389)
#test d) Asia RDP 3389 testing    telnet 10.210.1.2 3389  or nc -zv 10.210.1.2 3389        >  ('^]' (status , quit)  
#test unknown machine for access (arminstancetesting1)