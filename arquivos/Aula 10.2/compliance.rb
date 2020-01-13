title 'Testes de Compliance'

control 'inspec' do
  impact 'critical'
  title 'Verificando a instalacao do Inspec'
  desc 'testes de infraestrutura da 4labs'
  describe package('inspec') do
    it { should be_installed}
    its('version') { should cmp > '4' }
  end
  describe file('/root/inspec-profiles/') do
    it { should be_directory }
  end
end

control 'puppetserver' do
  impact 'critical'
  title 'Verifica a instalacao do Puppet Server'
  desc ' Verifica se o Puppet Server está instalado, se o servico esta sendo executado e se o arquivo autosign tem o conteúdo correto'
  describe package('puppetserver') do
    it { should be_installed }
    its('version') { should cmp >= '6' }
  end
  describe file('/etc/puppetlabs/puppet/autosign.conf') do
    it { should be_file }
    its('content') { should include '*.4labs.example' }
  end
  describe service('puppetserver') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
end
