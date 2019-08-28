load 'uri_parser.rb'

class TestParseUri < Test::Unit::TestCase
  def test_parse_uri_local
    assert_equal([["dh=500", "da=l", "ds=s"], "/images/example.jpg"],
                 parse_uri("/local/small_light(dh=500,da=l,ds=s)/images/example.jpg"))
  end
  def test_parse_uri
    assert_equal([["dh=500", "da=l", "ds=s"], "/images/example.jpg"],
                 parse_uri("/small_light(dh=500,da=l,ds=s)/images/example.jpg"))
  end
end
