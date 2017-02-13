defmodule Mix.Tasks.OpenDb do
  use Mix.Task

  @shortdoc "Open a connection to the MIX_ENV database"
  def run(_) do
    db_config = Application.get_env(:limpet, Limpet.Repo)
    cmd = "PGPASSWORD=#{db_config[:password]};psql -h#{db_config[:hostname]} #{db_config[:database]} #{db_config[:username]}"
    Mix.shell.info(cmd)
  end
end
