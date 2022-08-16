input{
    file{
        path => "/usr/share/logstash/custom-config/apache-logs-small"
        start_position => "beginning"
        discover_interval => "10"
        # sincedb_path => "/dev/null"
        stat_interval => "1 second"
    }
}

filter
{
  grok {
    match => {
      "message" => '%{IPORHOST:clientip} %{USER:ident} %{USER:auth} \[%{HTTPDATE:timestamp}\] "%{WORD:verb} %{DATA:request} HTTP/%{NUMBER:httpversion}" %{NUMBER:response:int} (?:-|%{NUMBER:bytes:int}) %{QS:referrer} %{QS:agent}'
    }
  }

  date {
    match => [ "timestamp", "dd/MMM/yyyy:HH:mm:ss Z" ]
    locale => en
  }

  geoip {
    source => "clientip"
  }

  useragent {
    source => "agent"
    target => "useragent"
  }
}



output{

  file{
    path => '/usr/share/logstash/custom-config/pipeline-output.txt'
    file_mode => 0666
    flush_interval => 0
    # codec => line { format => "On %{date} from %{useragent} at %{geoip} with details %{message}"}    
  }

  elasticsearch {
    index => "apache_elastic_example"
    hosts => ["http://elasticsearch:9200"]
    template => "/usr/share/logstash/custom-config/apache_logs_schema.json"
    template_name => "apache_logs_es_mappings"
    template_overwrite => true
  }

}

# output{
#     file{
#         path => '/usr/share/logstash/custom-config/pipeline-output.txt'
#         file_mode => 0666
#         flush_interval => 0
#         codec => line { format => "On %{date} from %{useragent} at %{geoip} with details %{message}"}
#         
#     }
# }