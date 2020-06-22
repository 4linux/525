title 'Testes de SCM'

control 'Gogs' do
  impact 'critical'
  title 'Verificando a instalacao do Gogs'
  desc 'testes de infraestrutura da 4labs'
  describe file('/opt/gogs') do
    it { should be_directory}
  end
  describe service('gogs') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
  describe file('/opt/gogs/custom/conf/app.ini') do
    it { should be_file }
    its('content') { should include 'scm.4labs.example' }
  end
  describe port('80') do
   it { should be_listening }
   its('processes') {should include 'gogs'}
  end
  describe port('2222') do
    it { should be_listening }
    its('processes') {should include 'gogs'}
  end
  describe http('http://scm.4labs.example') do
    its('status') { should cmp 200}
  end
end
