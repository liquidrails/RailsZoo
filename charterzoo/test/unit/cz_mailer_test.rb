require 'test_helper'

class CzMailerTest < ActionMailer::TestCase
  tests CzMailer
  def test_linkconfirm
    @expected.subject = 'CzMailer#linkconfirm'
    @expected.body    = read_fixture('linkconfirm')
    @expected.date    = Time.now

    assert_equal @expected.encoded, CzMailer.create_linkconfirm(@expected.date).encoded
  end

  def test_postconfirm
    @expected.subject = 'CzMailer#postconfirm'
    @expected.body    = read_fixture('postconfirm')
    @expected.date    = Time.now

    assert_equal @expected.encoded, CzMailer.create_postconfirm(@expected.date).encoded
  end

end
