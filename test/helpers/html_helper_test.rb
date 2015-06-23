require 'test_helper'

#
# == HtmlHelper Test
#
class HtmlHelperTest < ActionView::TestCase
  test 'should return sanitized string' do
    text = '<p>Lorem ipsum dolor sit amet</p>'
    assert_equal sanitize_string(text), 'Lorem ipsum dolor sit amet'
  end

  test 'should return sanitized and truncated string' do
    text = '<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras ut auctor mi, quis euismod diam. Nulla eget velit finibus, scelerisque justo vitae, finibus turpis. Proin consectetur nibh in tellus dapibus, a tristique odio venenatis. Quisque ultrices est nec scelerisque pulvinar. Phasellus viverra sit amet mi in semper. In blandit, ligula eu facilisis convallis, ipsum sapien volutpat sapien, a mattis ante mi vitae ex.</p>'
    assert_equal sanitize_and_truncate(text, 100), 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras ut auctor mi, quis euismod diam....'
  end

  test 'should truncate with a read more link' do
    text = '<p>In quis nisl blandit, commodo massa vitae, congue sapien. Fusce aliquet purus nunc, sit amet ultricies velit euismod non. Duis egestas risus sit amet ante sodales, eget consectetur arcu commodo. Fusce mollis nibh euismod magna ullamcorper, nec euismod metus vestibulum. Donec ornare lorem ante, vel placerat mauris egestas et. Nunc et cursus orci. Sed vitae nisl quis nibh luctus rhoncus. Duis aliquet enim sed ultricies vehicula. Quisque dictum gravida porttitor.</p>'
    assert_equal truncate_read_more(text, '/a-propos', 100), '<p>In quis nisl blandit, commodo massa vitae, congue sapien.... <a href="/a-propos">Lire la suite</a></p>'
  end

  test 'should return success flash html code' do
    flash['success'] = 'Congratulation !'
    result = show_flash
    expected = '<div class="alert-box success" data-alert="" tabindex="0" aria-live="assertive" role="dialogalert">Congratulation !<a href="#" class="close" tabindex="0" aria-label="Close Alert">&times</a></div>'
    assert_equal result, expected
  end

  test 'should concat success and error flash html code' do
    flash['success'] = 'Congratulation !'
    flash['error'] = 'Action error !'
    result = show_flash
    expected = '<div class="alert-box success" data-alert="" tabindex="0" aria-live="assertive" role="dialogalert">Congratulation !<a href="#" class="close" tabindex="0" aria-label="Close Alert">&times</a></div>'
    expected << '<div class="alert-box alert" data-alert="" tabindex="0" aria-live="assertive" role="dialogalert">Action error !<a href="#" class="close" tabindex="0" aria-label="Close Alert">&times</a></div>'
    assert_equal result, expected
  end

  test 'should return success klass' do
    assert_equal klass_by_type('success'), 'success'
    assert_equal klass_by_type('notice'), 'success'
  end

  test 'should return error klass' do
    assert_equal klass_by_type('alert'), 'alert'
    assert_equal klass_by_type('error'), 'alert'
  end
end
