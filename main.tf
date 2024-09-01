resource "vsphere_virtual_machine" "k8s_workers_vm"  {
  name             = "${var.vms.workers.pref}-0${var.vms.workers.vm_exist + count.index + 1}"
  #"${var.vms.masters.pref}-${var.vms.masters.ip_pool[count.index]}
  hardware_version = var.vm_hardware_version
  enable_disk_uuid = true
  count            = var.vms.workers.vm_count
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  host_system_id   = data.vsphere_host.host.id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus         = var.vms.workers.vm_cpu_count
  memory           = var.vms.workers.vm_ram_size
  guest_id         = "ubuntu64Guest"
  folder           = var.vsphere_vm_folder
  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label = "disk0"
    size  = var.vms.workers.vm_disk_size
    unit_number = 0
    thin_provisioned = true
  }
  disk {
    label = "data_disk1"
    size  = var.add_disks.diskw1.sizegb
    unit_number = 1
    thin_provisioned = true
  }
  disk {
    label = "data_disk2"
    size  = var.add_disks.diskw2.sizegb
    unit_number = 2
    thin_provisioned = true

  }


  cdrom {
    client_device = true
  }
  
  clone {
     template_uuid = data.vsphere_virtual_machine.template_from_ovf.id

  }
 
  vapp {
  properties = {  }
  }

  extra_config = {
     "guestinfo.userdata" = base64encode(data.template_file.cloudinit_worker_node.rendered)
     "guestinfo.userdata.encoding" = "base64"
     "guestinfo.metadata" = base64encode(replace((replace((data.template_file.metadata.rendered), "vm_ip_address",var.vms.workers.ip_pool[count.index])), "os_host_name", "${var.vms.workers.pref}-0${var.vms.workers.vm_exist + count.index + 1}"))
     "guestinfo.metadata.encoding" = "base64"
    
  }  

}
