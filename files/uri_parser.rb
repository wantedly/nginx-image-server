# Parses a uri and gets options and the redirected uri.
def parse_uri(uri)
  # In the original script, a regexp was used. However, we avoid using it, because mruby doesn't have regexp default.
  uri_sp = uri.split("/")[1..-1]
  if uri_sp[0] == "local" # /local/small_light/...
    uri_sp = uri_sp[1..-1]
  end
  # uri_sp is of form ["small_light(...)", "path", "to", "the", "image"]
  params = uri_sp[0].split("small_light")[1] # It should be "(a=b,c=d,e=f,...)"
  params = params[1..-2] # It should be "a=b,c=d,e=f,..."
  params = params.split(",") # It should be ["a=b","c=d","e=f",...]
  uri_sp = uri_sp[1..-1] # drop "small_light"
  # uri_sp is of form ["path", "to", "the", "image"]

  uri_redir = "/" + uri_sp.join("/") # redirected uri
  [params, uri_redir]
end
