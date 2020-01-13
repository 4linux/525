title 'Testes de LOG'

control 'nginx' do
  impact 'medium'
  title 'Verificando a instalacao do NGINX e configuração'
  desc 'testes de infraestrutura da 4labs'
  describe package('nginx') do
    it { should be_installed}
    its('version') { should cmp > '1.1' }
  end
  describe file('/etc/nginx/sites-enabled/default') do
    it { should be_file}
    it { should be_owned_by 'root' }
    its('mode') { should cmp '0644'}
    its('link_path') { should eq '/etc/nginx/sites-available/default'}
    its('content') { should include 'listen 80'}
    its('content') { should include 'server_name log.4labs.example'}
    its('content') { should include 'proxy_pass http://localhost:5601'}
  end
  describe service('nginx') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
  describe port('80') do
    it { should be_listening }
    its('processes') {should include 'nginx'}
  end
  describe http('http://log.4labs.example') do
    its('status') { should cmp 302}
  end
end

control 'ELKB' do
  impact 'critical'
  title 'Verificando a instalacao do Elastic Stack'
  desc 'testes de infraestrutura da 4labs'
  describe package('openjdk-8-jre-headless') do
    it { should be_installed}
    its('version') { should cmp > '8' }
  end
  describe package('elasticsearch') do
    it { should be_installed}
    its('version') { should cmp > '7' }
  end
  describe package('kibana') do
    it { should be_installed}
    its('version') { should cmp > '7' }
  end
  describe package('logstash') do
    it { should be_installed}
    its('version') { should cmp > '1:7' }
  end
    describe service('elasticsearch') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
    describe service('kibana') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
    describe service('logstash') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
end

control 'elkb-files' do
  impact 'critical'
  title 'Verificando arquivos de configuracao do Elastic Stack'
  desc 'testes de infraestrutura da 4labs'
  describe file('/etc/elasticsearch/elasticsearch.yml') do
    it { should be_file}
    its('content') { should include 'http.port: 9200'}
  end
  describe file('/etc/kibana/kibana.yml') do
    it { should be_file}
    its('content') { should include 'server.port: 5601'}
  end
  describe file('/etc/logstash/conf.d/filebeat-input.conf') do
    it { should be_file}
    its('content') { should include 'port => 5443'}
    its('content') { should include 'type => syslog'}
  end
  describe file('/etc/logstash/conf.d/syslog-filter.conf') do
    it { should be_file}
    its('content') { should include 'if [type] == "syslog"'}
  end
  describe file('/etc/logstash/conf.d/output-elasticsearch.conf') do
    it { should be_file}
    its('content') { should include 'hosts => "localhost:9200"'}
  end
end

control 'elkb-ports' do
  impact 'critical'
  title 'Verificando portas do Elastic Stack'
  desc 'testes de infraestrutura da 4labs'
  describe port('5443') do
    it { should be_listening }
    its('processes') {should include 'java'}
  end
  describe port('5601') do
    it { should be_listening }
    its('processes') {should include 'node'}
  end
  describe port('9200') do
    it { should be_listening }
    its('processes') {should include 'java'}
  end
 describe port('9300') do
    it { should be_listening }
    its('processes') {should include 'java'}
  end
  describe port('9600') do
    it { should be_listening }
    its('processes') {should include 'java'}
  end
end

control 'iscsi' do
  impact 'critical'
  title 'Verificando portas do Elastic Stack'
  desc 'testes de infraestrutura da 4labs'
  describe package('open-iscsi') do
    it { should be_installed}
    its('version') { should cmp > '2' }
  end
  describe service('open-iscsi') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
  describe mount('/log') do
    it { should be_mounted }
    its('device') { should eq '/dev/sdc1'}
    its('type') { should eq 'ext4'}
    its('options') {should include 'rw'}
  end
  describe mount('/bkp') do
    it { should be_mounted }
    its('device') { should eq '/dev/sdc2'}
    its('type') { should eq 'ext3'}
    its('options') {should include 'rw'}
  end
end
