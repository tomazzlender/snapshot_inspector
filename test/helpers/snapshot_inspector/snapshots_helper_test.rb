require "test_helper"

class SnapshotInspector::SnapshotsHelperTest < ActiveSupport::TestCase
  include SnapshotInspector::SnapshotsHelper

  test "#remove_traces_of_javascript" do
    html = '<!DOCTYPE html><html><head><title>Example</title><link href="path/to/file.js"/></head><body><script type="text/javascript">alert("hello");</script></body></html>'
    expected = "<!DOCTYPE html>\n<html>\n<head>\n<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">\n<title>Example</title>\n</head>\n<body></body>\n</html>\n"
    assert_equal expected, remove_traces_of_javascript(html)
  end
end
