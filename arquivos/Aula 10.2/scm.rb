title 'Testes do Wordpress'

control 'Wordpress' do
  impact 'critical'
  title 'Verificando a instalacao do Wordpress'
  desc 'testes de infraestrutura da 4labs'
  describe file('/var/www/wordpress') do
    it { should be_directory}
  end
  describe service('apache2') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
  describe file('/var/www/wordpress/wp-config.php') do
    it { should be_file }
    its('content') { should include 'wordpress' }
  end
  describe file('/var/www/wordpress/wp-config.php') do
    it { should be_file }
    its('content') { should include 'wordpressuser' }
  end
  describe file('/var/www/wordpress/wp-config.php') do
    it { should be_file }
    its('content') { should include '4linux' }
  end
  describe file('/var/www/wordpress/wp-config.php') do
    it { should be_file }
    its('content') { should include '10.5.25.101' }
  end
  describe port('80') do
    it { should be_listening }
    its('processes') {should include 'www-data'}
  end
  describe http('http://scm.4labs.example') do
    its('status') { should cmp 200}
  end
end
