set :output, "/home/deploy/mom/current/log/cron_log.log"

every 15.minutes do
  db_config  = YAML.load_file("#{Dir.pwd}/config/database.yml")["production"]
  mom_config = YAML.load_file("#{Dir.pwd}/config/mom.yml")
  
  command %{PGPASSWORD=#{db_config["password"]} pg_dump -i -h #{db_config["host"]} -U #{db_config["username"]} -F c -f "#{mom_config["dexis_path"]}backup/`date \\+\\%m_\\%d_\\%Y_\\%H_\\%M`.backup" #{db_config["database"]}}
end