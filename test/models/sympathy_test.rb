require 'test_helper'

class SympathyTest < ActiveSupport::TestCase
  def setup
    @baik = sympathy(:baik)
  end

  test "sympathy baik validation" do
    assert @baik.valid?
  end
end
