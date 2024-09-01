## Kubernetes cluster deployment on a VMware vSphere platform

This module intended to add worker nodes to existing y Kubernetes cluster inside a tenant on standard VMware vSphere platform.
It is create new set of virtual machines for K8s worker-nodes

All customusation and configuration performing by a dedicated Ansible playbook: https://github.com/werton13/k8s-kubeadm-ansible.git which is created specifically for this project and hardcoded into module as default value.


#### HOW TO USE:

<b>To use this module you have to fill provider block and specify required variables as in the example below:</b>


```hcl
provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
  version = "2.4.0"
}


module "vsphere-k8s-workers" {
  source = "github.com/werton13/tf-vsphere-k8s-workers"

  vsphere_server             = var.vsphere_server
  vsphere_host_ip            = var.vsphere_host_ip
  vsphere_vm_folder          = var.vsphere_vm_folder
  vsphere_user               = var.vsphere_user
  vsphere_password           = var.vsphere_password
  dcname                     = var.dcname
  dcstore_name               = var.dcstore_name
  esxi_host_name             = var.esxi_host_name
  vsphere_clustername        = var.vsphere_clustername
  vm_template_name           = var.vm_template_name
  vnet_name                  = var.vnet_name

  vm_user_name               = var.vm_user_name
  vm_user_password           = var.vm_user_password
  vm_user_displayname        = var.vm_user_displayname
  vm_user_ssh_key            = var.vm_user_ssh_key

  vm_ipv4_gw                 = var.vm_ipv4_gw
  vm_dns_server              = var.vm_dns_server
  
  def_dns  = var.def_dns
  env_dns1 = var.env_dns1
  env_dns2 = var.env_dns2

  vms = var.vms
  add_disks = var.add_disks

}

```
<details>
  <summary><b>Default values</b></summary>

```  
add_disks = {
          disk1 = {
            sizegb = "10"
            bus_num = "1"
            unit_num = "0"
            storage_profile = ""
            bus_type = "paravirtual" 
          }
          disk2 = {
            sizegb = "30"
            bus_num = "1"
            unit_num = "1"
            storage_profile = ""
            bus_type = "paravirtual"  
          }
}

```

</details>