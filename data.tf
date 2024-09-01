data "vsphere_datacenter" "datacenter" {
  name = "${var.dcname}"
}

data "vsphere_datastore" "datastore" {
  name          = "${var.dcstore_name}"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_clustername
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_resource_pool" "default" {
  name          = format("%s%s", data.vsphere_compute_cluster.cluster.name, "/Resources")
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_host" "host" {
  name          = var.esxi_host_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = var.vnet_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_virtual_machine" "template_from_ovf" {
  name          = var.vm_template_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}


data "template_file" "cloudinit_worker_node" {
#  template = file("./templates/userdata.yaml") 
  template = file("${path.module}/templates/userdata_w.yaml")
    vars = {
  
      vsphere_server      = var.vsphere_server
      vsphere_host_ip     = var.vsphere_host_ip
      vsphere_user        = var.vsphere_user
      vsphere_password    = var.vsphere_password
      dcname              = var.dcname
      dcstore_name        = var.dcstore_name
      esxi_host_name      = var.esxi_host_name
      vsphere_clustername = var.vsphere_clustername
  
      vm_user_name        = var.vm_user_name
      vm_user_password    = var.vm_user_password
      vm_user_displayname = var.vm_user_displayname     
      vm_user_ssh_key     = var.vm_user_ssh_key
      vm_user_ssh_pk      = var.vm_user_ssh_pk
  
      ansible_repo_url    = var.ansible_repo_url
      ansible_repo_name   = var.ansible_repo_name
      ansible_playbook    = var.ansible_playbook
      
      os_admin_username   = var.os_admin_username
      os_nic1_name        = var.os_nic1_name
  
      k8s_ver             = var.k8s_ver
      k8s_version_short   = var.k8s_version_short
      calico_version      = var.calico_version
      vsphere_csi_driver_version = var.vsphere_csi_driver_version
      k8s_controlPlane_Endpoint = var.k8s_controlPlane_Endpoint
      k8s_service_subnet  = var.k8s_service_subnet
      k8s_pod_subnet      = var.k8s_pod_subnet
      calico_network_cidr_blocksize = var.calico_network_cidr_blocksize
      k8s_cluster_id      = var.k8s_cluster_id
      sc_storage_policy_name = var.sc_storage_policy_name
      sc_name             = var.sc_name

      master_pref = "${var.vms.masters.pref}"
      worker_pref = "${var.vms.workers.pref}"

      workers_count       = var.vms.workers.vm_count
      masters_count       = var.vms.masters.vm_count
      wrk_exist           = var.vms.workers.vm_exist
  
      master0_ip          = "${split("/", var.vms.masters.ip_pool[0])[0]}"
  
      hosts_entry0        = "${var.vsphere_host_ip}  ${var.vsphere_server}"
      #hosts_entry1        = "${split("/", var.vms.dvm.ip_pool[0])[0]}  ${var.vms.dvm.pref}"
    }
}
data "template_file" "metadata" {
#  template = file("./templates/userdata.yaml") 
  template = file("${path.module}/templates/metadata.yaml")
    vars = {
      ipv4_gateway = var.vm_ipv4_gw
      dns_server   = var.vm_dns_server
  }
  
}

