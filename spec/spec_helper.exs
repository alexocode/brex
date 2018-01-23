"spec/shared/*_spec.exs"
|> Path.wildcard()
|> Enum.each(&Code.require_file/1)

ESpec.configure fn(config) ->
  config.before fn(tags) ->
    {:shared, hello: :world, tags: tags}
  end

  config.finally fn(_shared) ->
    :ok
  end
end
