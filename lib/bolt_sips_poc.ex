defmodule BoltSipsPoc do
    use Application
    def start(_type, _args) do
        children = [
          {Bolt.Sips, Application.get_env(:bolt_sips, Bolt)},
        ]
        opts = [strategy: :one_for_one, name: BoltSipsPoc.Supervisor]
        Supervisor.start_link(children, opts)
      end

end