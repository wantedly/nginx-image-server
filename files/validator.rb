def handler
  req = Nginx::Request.new
  uri = req.uri # of form .*/small_light[^\/]*/.*
  # In the original script, a regexp was used. However, we avoid using it, because mruby doesn't have regexp default.
  uri_sp = uri.split("/")[1..-1]
  if uri_sp[0] == "local" # /local/small_light/...
    uri_sp = uri_sp[1..-1]
  end
  # uri_sp is of form ["small_light(...)", "path", "to", "the", "image"]
  params = uri_sp[0].split("small_light")
  uri_sp = uri_sp[1..-1] # drop "small_light"
  # uri_sp is of form ["path", "to", "the", "image"]
  
  
  uri_redir = "/" + uri_sp.join("/") # redirected uri
  v = Nginx::Var.new
  threshold = v.small_light_maximum_size
  puts "requested uri = #{uri}\n"
  puts "redirected uri = #{uri_redir}\n"
  puts "threshold = #{threshold}\n"
  puts "threshold.class = #{threshold.class}\n"
  
  if threshold == "" # TODO not sure it's working
    Nginx.errlogger(Nginx::LOG_NOTICE, "small_light_maximum_size is not defined!") # TODO the magic number "100" is used in the original code, but its meaning is unclear, so we use LOG_NOTICE.
    puts "threshold is empty\n\n"
    Nginx.redirect uri_redir
    Nginx.return Nginx::OK
    return
  end

  bad_request = false

#  This snippet is from validator.pm, and not working.
#
#  for param in (@params) {
#    key, value = param;
#
#    if (grep(/^${key}$/, ("cw", "dw", "ch", "dh"))) {
#      if ($value > $threshold) {
#        $r->log_error(100, "Invalid resize parameter, " . $key . ": " . $value);
#        $bad_request = 1;
#        last;
#      }
#    }
#  }

  
  if bad_request
    Nginx.return Nginx::BAD_REQUEST
  end
  
  Nginx.redirect uri_redir
  Nginx.return Nginx::OK
  # Nginx.return Nginx::HTTP_FORBIDDEN
end

handler
