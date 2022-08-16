input{
    file{
        path => "/usr/share/logstash/bsr-config/tmp.txt"
        start_position => "beginning"
        discover_interval => "10"
        delimiter => '\n'
        sincedb_path => "/dev/null"
        stat_interval => "1 second"
    }
}

filter
{

}

output{
    stdout{ codec => json }
}