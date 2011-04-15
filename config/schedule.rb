require "futils"
require "yaml"

set :output, "#{Dir.pwd}/log/cron_log.log"

every 15.minutes do
  db_config  = YAML.load_file("#{Dir.pwd}/config/database.yml")
  mom_config = YAML.load_file("#{Dir.pwd}/config/mom.yml")
  
  command %{pg_dump -i -h #{db_config["host"]} -U #{db_config["username"]} -p #{db_config["password"]} -F c -f "#{mom_config["dexis_path"]}/backup/Time.now.to_i.backup" #{db_config["database"]}}
end