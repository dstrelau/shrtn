Given /^I am on the homepage$/ do
  visit '/'
end

Given /^(\d+) URLs have been shortened$/ do |num|
  num.to_i.times do |i|
    Url.shorten!("http://#{i}.com")
  end
end

Given /^I have shortened "([^\"]*)" as "([^\"]*)"$/ do |url, key|
  Url.create(:key => key, :url => url, :created_at => Time.now)
end

When /^I go to "([^\"]*)"$/ do |url|
  visit '/g'
end

Then /^I should be on "([^\"]*)"$/ do |url|
  # I thought visit() followed redirects. WTF?
  last_response.should be_redirect
  last_response.headers['Location'].should == url
end

When /^I shrtn "([^\"]*)"$/ do |url|
  fill_in('u', :with => url)
  click_button('shrtn')
end

Then /^I should see "([^\"]*)"$/ do |text|
  response_body.should contain(text)
end
