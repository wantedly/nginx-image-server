def handler
  req = Nginx::Request.new
  uri = req.uri # of form .*/small_light[^\/]*/.*
  v = Nginx::Var.new
  threshold = v.small_light_maximum_size

  params, uri_redir = parse_uri(uri)
  # If $small_light_maximum_size is not set, threshold will be
  # nil or "" (an empty string).
  if threshold == nil || threshold == ""
    Nginx.errlogger(Nginx::LOG_NOTICE, "small_light_maximum_size is not defined!") # A magic number "100" is used in the original (Perl) code, but its meaning is unclear. Thus we use LOG_NOTICE.
    Nginx.redirect uri_redir
    Nginx.return Nginx::OK
    return
  end
  threshold = threshold.to_i

  bad_request = false

  params.each do |param|
    key, value = param.split("=")

    if ["cw", "dw", "ch", "dh"].include?(key)
      value = value.to_i
      if value > threshold
        Nginx::errlogger(Nginx::LOG_WARN, "Invalid resize parameter, " + key + ": " + value.to_s)
        bad_request = true
        break
      end
    end
  end

  # Bad Request. It is handled separately in nginx.conf (by using error_page 400).
  if bad_request
    Nginx.send_header Nginx::HTTP_BAD_REQUEST
    return
  end
  
  Nginx.redirect uri_redir
  Nginx.return Nginx::OK
  # Nginx.return Nginx::HTTP_FORBIDDEN
end

handler
