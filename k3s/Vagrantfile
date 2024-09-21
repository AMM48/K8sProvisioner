base_ip = "192.168.8"
gateway = "#{base_ip}.1"
num_of_masters = 1
num_of_workers = 2
netmask = "255.255.255.0"
def get_bridge_adapter()
  return %x{powershell -Command "Get-NetRoute -DestinationPrefix 0.0.0.0/0 | Get-NetAdapter | Select-Object -ExpandProperty InterfaceDescription"}.chomp
end
Vagrant.configure("2") do |config|
  bridged_interface = get_bridge_adapter()
  config.vm.box = "debian/bookworm64"
 (1..num_of_masters).each do |i|
  config.vm.define "controlplane#{i}" do |masters|
    host_id = 1 + i
    ip_address = "#{base_ip}.#{host_id}"
    masters.disksize.size = "50GB"
    masters.vm.network "public_network", bridge: bridged_interface, auto_config: false
    masters.vm.hostname = "controlplane#{i}"
    masters.vm.provider "virtualbox" do |vbox|
      vbox.name = "ControlPlane#{i}"
      vbox.memory = 4096
      vbox.cpus = 4
      vbox.default_nic_type = "82540EM"
      vbox.customize ["modifyvm", :id,"--nicpromisc2", "allow-all"]
    end
    masters.vm.provision "shell", privileged: false, path: "./scripts/network-setup.sh", args: [ip_address, netmask, gateway]
    masters.vm.provision "shell", privileged: false, path: "./scripts/dependency-install.sh"
    masters.vm.provision "shell", privileged: false, path: "./scripts/k3s-install.sh", args: [ip_address]
    masters.vm.provision "shell", privileged: false, path: "./scripts/helm-install.sh"
    masters.vm.provision "shell", privileged: false, path: "./scripts/kubeseal-client-install.sh"

  end
 (1..num_of_workers).each do |i|
  config.vm.define "worker#{i}" do |workers|
    host_id = 10 + i
    ip_address = "#{base_ip}.#{host_id}"
    workers.disksize.size = "50GB"
    workers.vm.network "public_network", bridge: bridged_interface, auto_config: false
    workers.vm.hostname = "worker#{i}"
    workers.vm.provider "virtualbox" do |vbox|
      vbox.name = "Worker#{i}"
      vbox.memory = 2048
      vbox.cpus = 2
      vbox.default_nic_type = "82540EM"
      vbox.customize ["modifyvm", :id,"--nicpromisc2", "allow-all"]
    end
    workers.vm.provision "shell", privileged: false, path: "./scripts/network-setup.sh", args: [ip_address, netmask, gateway]
    workers.vm.provision "shell", privileged: false, path: "./scripts/dependency-install.sh"
    workers.vm.provision "shell", privileged: false, path: "./scripts/k3s-join.sh", args: [ip_address]
   end
  end
 end
end
