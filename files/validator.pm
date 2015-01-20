package validator;

use nginx;
use strict;
use warnings;

sub handler {
  my $r = shift;
  my $uri = "/" . ($r->uri =~ /^\/small_light[^\/]*\/(.+)$/m)[0];
  my $threshold = $r->variable("small_light_maximum_size");

  $r->log_error(100, $uri);

  unless ($threshold) {
    $r->log_error(100, "no threshold!");
    $r->internal_redirect($uri);

    return OK;
  }

  my $bad_request = 0;
  my @params = $r->uri =~ /([a-zA-Z]+=[0-9a-zA-Z]+),?/g;

  foreach my $param (@params) {
    my ($key, $value) = split("=", $param);

    if (grep(/^${key}$/, ("cw", "dw", "ch", "dh"))) {
      if ($value > $threshold) {
        $r->log_error(100, "oversize!");
        $bad_request = 1;
        last;
      }
    }
  }

  if ($bad_request) {
    $r->log_error(100, "bad request!");
    return HTTP_BAD_REQUEST;
  }

  $r->internal_redirect($uri);

  return OK;
}

1;
__END__
