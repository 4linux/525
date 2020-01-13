title 'Testes de Automation'

control 'ansible' do
  impact 'critical'
  title 'Verificando a instalacao do Ansible e arquivos de configuracao'
  desc 'testes de infraestrutura da 4labs'
  describe package('ansible') do
    it { should be_installed}
    its('version') { should cmp > '2.8' }
  end
  describe file('/etc/ansible/ansible.cfg') do
    it { should be_file}
    it { should be_owned_by 'root' }
    its('mode') { should cmp '0644'}
    its('content') { should include 'host_key_checking = False'}
    its('content') { should include 'private_key_file = /root/.ssh/id_rsa'}
  end
  describe file('/etc/ansible/hosts') do
    it { should be_file}
    it { should be_owned_by 'root' }
    its('mode') { should cmp '0644'}
    its('content') { should include 'automation.4labs.example'}
    its('content') { should include 'compliance.4labs.example'}
    its('content') { should include 'container.4labs.example'}
    its('content') { should include 'log.4labs.example'}
    its('content') { should include 'scm.4labs.example'}
 end
end

 control 'rundeck' do
   impact 'critical'
   title 'Verificando a instalacao do rundeck e arquivos de configuracao'
   desc 'testes de infraestrutura da 4labs'
   describe package('rundeck') do
     it { should be_installed}
     its('version') { should cmp > '3.1' }
   end
   describe package('java-1.8.0-openjdk') do
     it { should be_installed}
     its('version') { should cmp > '1.8' }
   end
   describe file('/etc/rundeck/framework.properties') do
     it { should be_file}
     it { should be_owned_by 'rundeck' }
     its('mode') { should cmp '0640'}
     its('content') { should include 'framework.server.name = 4labs'}
     its('content') { should include 'framework.server.hostname = automation.4labs.example'}
     its('content') { should include 'framework.server.port = 4440'}
     its('content') { should include 'framework.server.url = http://automation.4labs.example:4440'}
   end
   describe file('/etc/rundeck/rundeck-config.properties') do
     it { should be_file}
     it { should be_owned_by 'rundeck' }
     its('mode') { should cmp '0640'}
     its('content') { should include 'grails.serverURL=http://automation.4labs.example:4440'}
  end
  describe service('rundeckd') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
  describe port('4440') do
    it { should be_listening }
    its('processes') {should include 'java'}
  end
  describe http('http://automation.4labs.example:4440') do
    its('status') { should cmp 302}
  end
end

control 'iscsi' do
   impact 'critical'
   title 'Verificando o SCSI'
   desc 'testes de infraestrutura da 4labs'
   describe package('scsi-target-utils') do
     it { should be_installed}
     its('version') { should cmp > '1' }
   end
   describe file('/etc/tgt/conf.d/4labs_scsi.conf') do
     it { should be_file}
     it { should be_owned_by 'root' }
     its('mode') { should cmp '0644'}
     its('content') { should include '<target iqn.2019-05.automation.4labs.example:lun>'}
  end
   describe service('tgtd') do
     it { should be_installed }
     it { should be_enabled }
     it { should be_running }
   end
  describe port('3260') do
    it { should be_listening }
    its('processes') {should include 'tgtd'}
  end
end
