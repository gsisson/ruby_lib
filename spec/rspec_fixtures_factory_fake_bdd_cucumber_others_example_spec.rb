# -*- coding: utf-8 -*-

  describe "Chapter 10" do
    describe "Fixtures" do
      it "spec/fixtures/customers.yml" do end
      it "· bob:" do end
      it "·   name: Bob Taylor" do end
      it "·   city: Chicago" do end
      it "·   state: IL" do end
      it "·   country: USA" do end
      it "spec/fixtures/orders.yml" do end
      it "· bob_order_1" do end
      it "·   date: 2010-01-01" do end
      it "·   customer: bob" do end
      it "spec/fixtures/orders.yml.erb" do end
      it "· <% 5.times do |n| %>" do end
      it "·   bob_order_<% n %>:" do end
      it "·     date: 2010-01-<% 10+n %>" do end
      it "·     customer: bob" do end
    end
    describe "Factory Girl" do
      it "@bob = build(:bob)         # build new object, but don't save to db" do end
      it "@bob = create(:bob)        # build new object, and save" do end
      it "stub = build_stubbed(:bob) # build new object; stubs out all of the attributes" do end
      it "@larry = build(:customer, name: 'larry')" do end
      it '· clone from :customer    ^^^^           # override attibutes' do end
      it "@bob.location" do end
      it "@bob.orders.last" do end
    end
    describe "Fake Data Generators" do
      it "Faker (stympy/faker)" do end
      it "Forgery (sevenwire/forgery)" do end
    end
    describe "Test Types" do
      it "* Unit Tests" do end
      describe "* Integration Tests (aka: end-to-end/full-stack test [thorough, slow, user-story based])" do
        describe "* BDD / cucumber (Capybara + JS driver: Selenium/Poltergeist)" do
          describe "Behavior Definitions:" do
            describe "features/employee_can_manage_products.feature:" do
              it "Feature: Employee can manage Products" do end
              it "· As an Employee" do end
              it "· I want to view the Product listing page" do end
              it "· So that I can manage Products for sale" do end
              it "·" do end
              it "Background: The Employee is on the Products Page" do end
              it "· Given I am logged in as an Employee" do end
              it "·" do end
              it "Scenario: I can add a New Product" do end
              it "· Given I am on the 'Listing Products' page" do end
              it "· Then I should see 'Listing Products' as title" do end
              it "·  And I should see 'New Product' link" do end
              it "· When I follow 'New Product' link" do end
              it "· Then I should be on the 'New Product' page" do end
              it "· When I fill in 'Title' with 'Lord of the Rings'" do end
              it "·  And I select 'hardback' from 'type'" do end
              it "·  And I press 'Create Product'" do end
              it "· Then I should be on the 'Product Details' page" do end
              it "·  And I should see 'Lord of the Rings'" do end
            end
          end
          describe "Step Definitions:" do
            describe "step_definitions/steps.rb:" do
              it %{Given /I have entered (.*) into the calculator/ do |n|} do end
              it %{· calculator = Calculator.new} do end
              it %{· calculator.push(n.to_i)} do end
              it %{end} do end
              it %{Then(/^I should see "([^"]*)"$/) do |arg1|} do end
              it %{· expect(page).to have_content(arg1)} do end
              it %{end} do end
            end
          end
        end
      end
    end
    describe "Automatic Testing" do
      it "autotest (comes w/ rspec), guard, CI" do end
    end
    describe "Other Tools" do
      it "shoulda-matchers" do end
      it "simplecov" do end
      it "timecop (fixed time, time travel, time freezing/acceleration )" do end
      it "webmock (stubbing and setting expectations on HTTP requests)" do end
      it "vcr (records HTTP requests/responses for later playback)" do end
      it "spork (lauches test server; later makes copies of it rather than slow re-launch)" do end
    end
  end
