Then /^the "([^"]*)" drop-down should contain the option "([^"]*)"$/ do |dropdown, text|
  expect(page).to have_select(dropdown, :options => [text])
end

# Note: use "0" as team to indicate that this student isn't on a team yet
Given /^the following users exist$/ do |table|
  table.rows.each do |name, email, password, team_passcode, major, sid|
    next if name == "name" # skipping table header
    @team = Team.where(:passcode => team_passcode).first
    if team_passcode != "0"
      @team = Team.create!(:approved => false, :passcode => team_passcode) if @team.nil?
      User.create!(:team => @team, :major => major, :name => name, :email => email, :sid => sid, :password => password)
    else
      User.create!(:team => nil, :major => major, :name => name, :email => email, :sid => sid, :password => password)
    end
  end
end

Given /^the following discussions exist$/ do |table|
  table.rows.each do |number, time, capacity, seats_open|
    next if number == :number # skipping table header
    Discussion.create!(:number => number.to_i, :time => time, :capacity => capacity.to_i)
  end
end

Then /^(?:|I )should not be on (.+)$/ do |page_name|
  current_path = URI.parse(current_url).path
  if current_path.respond_to? :should
    current_path.should_not == path_to(page_name)
  else
    assert_not_equal path_to(page_name), current_path
  end
end
  
Then /^print the page body$/ do
  puts page.body
end


Then /^I should see "([^"]*)" button/ do |name|
  should have_button name
end

Then /^I should not see "([^"]*)" button/ do |name|
  should have_no_button name
end


Given /^the following admins exist$/ do |table|
  table.rows.each do |name, email, password|
    next if name == "name" # skipping table header
    Admin.create!(:name => name, :email => email, :password => password)
  end
end

Then /^I should have downloaded a team information file$/ do
   page.response_headers['Content-Disposition'].should include("team_info.txt")
end

When /^I upload a discussion file$/ do
  attach_file(:discussions, File.join('features', 'test_files', 'discussion_info.txt'))
  click_button "Upload"
end
 
When /^I upload an invalid file$/ do
  attach_file(:discussions, File.join('features', 'test_files', 'bad_file.rb'))
  click_button "Upload"
end