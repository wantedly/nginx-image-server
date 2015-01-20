package validator;

use nginx;
use strict;
use warnings;

sub handler {
  my $r = shift;
  my $uri = "/" . ($r->uri =~ /^.*\/small_light[^\/]*\/(.+)$/m)[0];
  my $threshold = $r->variable("small_light_maximum_size");

  unless ($threshold) {
    $r->log_error(100, "small_light_maximum_size is not defined!");
    $r->internal_redirect($uri);

    return OK;
  }

  my $bad_request = 0;
  my @params = $r->uri =~ /([a-zA-Z]+=[0-9a-zA-Z]+),?/g;

  foreach my $param (@params) {
    my ($key, $value) = split("=", $param);

    if (grep(/^${key}$/, ("cw", "dw", "ch", "dh"))) {
      if ($value > $threshold) {
        $r->log_error(100, "Invalid resize parameter, " . $key . ": " . $value);
        $bad_request = 1;
        last;
      }
    }
  }

  if ($bad_request) {
    # to avoid ngx_small_light process and return 400
    $r->send_http_header;

    return HTTP_BAD_REQUEST;
  }

  $r->internal_redirect($uri);

  return OK;
}

1;
__END__
