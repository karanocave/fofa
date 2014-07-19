#!/usr/bin/env ruby
#通过数据库的body分析，来提取所有url，通过api提交到fofa（超过90天才更新）
@root_path = File.expand_path(File.dirname(__FILE__))
require @root_path+"/../app/jobs/module/webdb2_class.rb"
require @root_path+"/../app/jobs/module/lrlink.rb"
include Lrlink

@m = WebDb.new(@root_path+"/../config/database.yml")

while true
  puts "="*80
  res= @m.mysql.query("select count(*) as cnt,ip,host,subdomain,domain,title from subdomain where id>(select max(id) from subdomain)-100000 and subdomain!='www' and subdomain!='' GROUP BY ip having cnt>100 order by cnt desc ")
  res.each{|r|
    #puts r
    printf("%-8s%-24s%-20s%-30s%-30s\n", r["cnt"], r["ip"], r["subdomain"], r["domain"], r["title"]) unless is_bullshit_host?(r["host"]) || is_bullshit_ip?(r["ip"])
  }
  sleep 5
end