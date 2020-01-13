# -*- mode: ruby -*-
# vi: set ft=ruby  :

machines = {
  "compliance" => {"memory" => "1024", "cpu" => "2", "ip" => "20", "image" => "ubuntu/bionic64"},
  "container" => {"memory" => "1536", "cpu" => "1", "ip" => "30", "image" => "centos/7"},
  "scm" => {"memory" => "256", "cpu" => "1", "ip" => "40", "image" => "debian/buster64"},
  "log" => {"memory" => "2048", "cpu" => "1", "ip" => "50", "image" => "ubuntu/bionic64"},
  "automation" => {"memory" => "1536", "cpu" => "2", "ip" => "10", "image" => "centos/7"}
}

Vagrant.configure("2") do |config|

  config.vm.box_check_update = false
  machines.each do |name, conf|
    config.vm.define "#{name}" do |machine|
      machine.vm.box = "#{conf["image"]}"
      machine.vm.hostname = "#{name}.4labs.example"
      machine.vm.network "private_network", ip: "10.5.25.#{conf["ip"]}"
      machine.vm.provider "virtualbox" do |vb|
        vb.name = "#{name}"
        vb.memory = conf["memory"]
        vb.cpus = conf["cpu"]
        vb.customize ["modifyvm", :id, "--groups", "/525-InfraAgil"]
        if name == "automation" and not File.file?('iscsi525.vdi')
          vb.customize ['createhd', '--filename', 'iscsi525.vdi', '--size', 20 * 1024]
          vb.customize ['storagectl', :id, '--name', 'SATA Controller', '--add', 'sata']
          vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', 'iscsi525.vdi']
        end
      end
        if "#{conf["image"]}" == "ubuntu/bionic64"
          machine.vm.provision "shell", inline: "apt install python -y"
          machine.vm.provision "shell", inline: "echo '#{name}.4labs.example' > /etc/hostname"
          machine.vm.provision "shell", inline: "hostnamectl set-hostname #{name}.4labs.example"
        end
        if "#{conf["image"]}" == "debian/buster64"
          machine.vm.provision "shell", inline: "echo '#{name}.4labs.example' > /etc/hostname"
          machine.vm.provision "shell", inline: "hostnamectl set-hostname #{name}.4labs.example"
        end
    end
  end
  config.vm.provision "shell", path: "script.sh"
end
