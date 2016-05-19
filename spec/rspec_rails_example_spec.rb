# -*- coding: utf-8 -*-

  class String
    def invis
      "\u2063#{self[1..-1]}"
    end
  end

describe "Chapter 8 - RSpec with Ruby on Rails" do
  describe "RSpec Rails 3.X doc'n (describes differences between the test types)" do
    it "https://relishapp.com/rspec/rspec-rails/v/3-4/docs" do end
  end
  describe "Discussion of end-to-end testing types (feature, integration, request)" do
    it "http://stackoverflow.com/questions/31204948/rspec-testing-request-specs-feature-specs-integration-specs/31205232#31205232" do end
    it " - type: :feature     (place in spec/features/; use capybara;           [uses feature/scenario])" do end
    it " - type: :integration (place in spec/requests/; use capybara;  or json)" do end
    it " - type: :request     (place in spec/requests/;  NO capybara; use json! [uses describe/it])" do end
  end
  describe "Rails Generators and RSpec" do
    it "creates spec files automatically with 'rails generate' (rspec-rails gem)" do end
    it "or, generate spec files for pre-existing items yourself on demand:" do end
    it "- rails generate       <kind> <item> #create item plus tests" do end
    it "- rails generate rspec:<kind> <item> #create just the tests (for existing item)" do end
    it "                 ^^^^^^".invis do end
    it "'rails generate --help' shows all the 'rspec:' types available" do end
    it "- all have ', type: :<type>' parameter to #describe method call" do end
  end
  describe "RSpec and the database" do
    describe "rspec spec" do
      it "does NOT prepare the db" do end
    end
    describe "rake [spec]" do
      describe "DOES prepare the db (before running the tests)" do
        it "- currently it does the following (could change in future):" do end
        describe "  rake db:test:prepare".invis do
          it "(RAIL_ENV=test rake db:drop db:create db:schema:load)" do end
        end
      end
    end
    describe "Speeding up tests that hit the database:" do
      it "save only when necessary" do end
      it "use test doubles, where it makes sense" do end
      it "stub the save action, where it makes sense" do end
    end
    describe "Transactions" do
      it "examples/tests run in transactions" do end
      it "so, data modified in before(:example) WILL be rolled back at end of each test" do end
      it "                            ^^^^^^^^  ^^^^".invis do end
      it "and data modified by before(:context) will NOT be rolled back" do end
      it "                            ^^^^^^^^       ^^^".invis do end
      it "- Thus, YOU must remove/revert the data in after(:context)" do end
      it "  (or lookat database_cleaner gem to clean up)".invis do end
    end
  end
  describe "Spec Types for Rails " do
    # Useful methods, per rspec file type (or location)" do
    describe "type: :model (or placed in spec/models/)" do
      describe "shoulda-matchers [github.com:thoughtbot/shoulda-matchers]" do
        it "have_many, validate_presense_of, validate_uniqueness_of..." do end
      end
      describe "ActiveRecord test doubles [github.com:rspec/rspec-activemodel-mocks]" do
        it "acts like AR model, but won't hit the db" do end
        it "allows use of mock_model, stub_model, etc" do end
      end
    end
    describe "type: :helper (or placed in spec/helpers/)" do
      it "For testing app/helpers/*.rb modules" do end
      describe "The object 'helper' is available, which:" do
        it "- will have all modules imported for it" do end
        it "- will have rails helper modules imported too" do end
      end
      describe "Helper modules often expect @vars to be set" do
        it "- set them using 'assign(:var, val)' rather than frowned upon '@var = val'" do end
      end
    end
    describe "type: :request (or placed in spec/requsts/)" do
      describe "METHODS available in controller specs:" do
        it "get(), post()" do end
        it "(how are these any differnt from in contoller specs? if at all?)" do end
      end
    end
    describe "type: :controller (or placed in spec/controllers/)" do
      describe "Tasks that a Controller performs (not the spec, the controller):" do
        it "* uses 'request' object and creates a 'response' object" do end
        it "* sets cookie and session values" do end
        it "* calls render or redirect" do end
      end
      describe "Generating REQUESTs -----------------------------------------------------------------" do
        describe "METHODS available in controller specs:" do
          it "get()          post()       put()" do end
          it "patch()        delete()" do end
          it "render_views() # to force rendering (but don't use; do proper view specs instead)" do end
        end
        describe "examples" do
          it "get(:index)" do end
          it "get('/customers/index')" do end
          it "get(:index, :page => 2, :search => 'Smith')" do end
          it "post(:create, :customer => {:fn => 'Joe', :ln => 'Ott', :state => 'MO'})" do end
          it "                           ^^^^^^^^^^^^^hash of form values^^^^^^^^^^^^".invis do end
        end
      end
      describe "Expectations on the RESPONSE object -------------------------------------------------" do
        it "expect(response).to render_template ( template )" do end
        it "expect(response).to redirect_to     ( path     )" do end
        it "expect(response).to have_http_status( :ok      ) # or use 200" do end
        it "  200/:ok                 403/:forbidden  404/:not_found ".invis do end
        it "  301/:moved_permanently  302/:found      500/:internal_server_error  502/:bad_gateway".invis do end
      end
      describe "Note that contoller specs don't actually do any rendering:" do
        it "Instead, render_template() checks what WOULD be rendered" do end
        it "To force rendering, call render_views()" do end
        it "[otherwise, \"expect(response.body).to eq('')\" is always true]" do end
      end
      describe "OBJECTS available in controller specs:" do
        it "controller" do end
        it "request" do end
        it "response" do end
      end
      describe "HASHES available in controller specs:" do
        it "assigns # hash of instance vars assigned in the controller action for the view" do end
        it "session # hash of session values" do end
        it "flash   # hash of flash message values" do end
        it "cookies # hash of cookies (see below)" do end
        describe "notes on assigns hash:" do
          it "get :index" do end
          it "expect(assigns['customers']).to eq(customers)" do end
          it "               ^^^^^^^^^^^ assigns hash must use STRING here, not symbol".invis do end
          it "expect(assigns(:customers )).to eq(customers)" do end
          it "              ^           ^ or use #assigns method; it can take symbol/string".invis do end
        end
        describe "notes on cookies hash:" do
          it "cookies hash is a combined version of request.cookies and response.cookies hashes" do end
          it "- to avoid confusion, use request.cookies or response.cookies explicitly" do end
        end
      end
    end
  end
  describe "View Specs" do
    it "* view specs run in isolation from the controller and request/response cycle" do end
    it "* only the rendering takes place" do end
    it "* the describe string implicitly specifies the controller/action" do end
    describe "Tasks to perform in a view spec:" do
      it "* make instance var assignments with assign()" do end
      it "* render() the template" do end
      it "* set expectations on the 'rendered' object" do end
    end
    describe "OBJECTS available:" do
      it "* view" do end
      it "* rendered" do end
    end
    describe "METHODS available:" do
      it "* assign()" do end
      it "* render()" do end
    end
    describe "example" do
      it "assign(:customers, [Customer.new('Al'),Customer.new('Ben')])" do end
      it "render" do end
      it "expect(rendered).to match(/Ben/)" do end
      it "# test whether partials have been rendered" do end
      it "expect(view).to render_template(:partial => '_customer', :count => 3)" do end
      it "                                                         ^^^^^^ #expect to be called 3 times".invis do end
      it "expect(view).to render_template(:partial => '_pagination', :locals => {:page => 1})" do end
      it "                                                           ^^^^^^^ #vars passed to partial".invis do end
      it "# if describe string does not implicitly specify controller/action" do end
      it "# then use render(:template => 'controller/the_template.html.erb')" do end
      it "# Note that the layout is not rendered unless you specify it:" do end
      it "  render(:template => 'customers/index', :layout => 'layouts/application')".invis do end
      it "# partials can be stubbed to render nothing:" do end
      it "# stub_template(template_file_name => new_template) # new_template is erb text" do end
    end
  end
end
