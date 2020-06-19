node 'log.4labs.example' {
        include elastic_stack::java8
        include elastic_stack::repo
	include elastic_stack::nginx
        include elastic_stack::elasticsearch
        include elastic_stack::kibana
        include elastic_stack::logstash
}

node 'compliance.4labs.example' {
        include inspec
        include elastic_stack::repo
        include elastic_stack::filebeat

}

node 'default' {
        include elastic_stack::repo
        include elastic_stack::filebeat
}
