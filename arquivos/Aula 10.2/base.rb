title 'Testes de Base'

control 'puppetagent' do
  impact 'critical'
  title 'Verificando o puppetagent'
  desc 'testes de infraestrutura da 4labs'
  describe package('puppet-agent') do
    it { should be_installed}
    its('version') { should cmp > '6' }
  end
  describe file('/etc/puppetlabs/puppet/puppet.conf') do
    it { should be_file}
    it { should be_owned_by 'root' }
    its('mode') { should cmp '0644'}
    its('content') { should include 'server = compliance.4labs.example'}
  end
  describe service('puppet') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
end

control 'filebeat' do
  impact 'critical'
  title 'Verificando o Filebeat'
  desc 'testes de infraestrutura da 4labs'
  describe package('filebeat') do
    it { should be_installed}
    its('version') { should cmp > '7' }
  end
  describe file('/etc/filebeat/filebeat.yml') do
    it { should be_file}
    it { should be_owned_by 'root' }
    its('mode') { should cmp '0600'}
    its('content') { should include 'hosts: ["log.4labs.example:5443"]'}
  end
  describe service('filebeat') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
end

control 'interface' do
  impact 'critical'
  title 'Verificando a interface de rede'
  desc 'testes de infraestrutura da 4labs'
  IP = [
	  '10.5.25.10',
	  '10.5.25.20',
	  '10.5.25.30',
	  '10.5.25.40',
	  '10.5.25.50',
  ]
  describe interface('lo') do
      its('ipv4_addresses') { should include '127.0.0.1' }
  end
  if os.family == 'debian' && os.release != '10.0'
    describe interface('enp0s8') do
      it { should be_up }
      its('speed') { should eq 1000 }
      its('ipv4_addresses') { should be_in IP }
    end
  elsif os.family == 'redhat' || os.family == 'debian' && os.release == '10.0'
    describe interface('eth1') do
      it { should be_up }
      its('speed') { should eq 1000 }
      its('ipv4_addresses') { should be_in IP }
    end
  end
end
