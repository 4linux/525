title 'Testes de Docker'

control 'Docker' do
  impact 'critical'
  title 'Verificando a instalacao do Docker'
  desc 'testes de infraestrutura da 4labs'
  describe package('docker-ce') do
    it { should be_installed}
    its('version') { should cmp > '19' }
  end
  describe package('docker-ce-cli') do
    it { should be_installed}
    its('version') { should cmp > '19' }
  end
  describe package('containerd.io') do
    it { should be_installed}
    its('version') { should cmp > '1.2' }
  end
  describe service('docker') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
end
control 'docker_image' do
  impact 'medium'
  title 'Verifica imagens do docker'
  desc ' Verifica se as imagens necessárias do docker estao presentes'
  describe docker_image('webserver') do
    it { should exist }
    its('repo') { should eq 'webserver' }
    its('tag') { should eq 'latest' }
  end
end
