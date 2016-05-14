# -*- coding: utf-8 -*-

  describe "Chapter 5" do
    describe "hooks, let, subject, implicit subject, shared examples " do
      describe "Before / After / Around hooks" do
        it "#                       before before         before  after   after  after   after" do end
        it "# order that hooks run: suite  context around example example around context suite" do end
        it "config.before/after(:suite) do         # run before/after ALL tests (place this in helper file)" do end
        it "end" do end
        it "config.before/after(:context/:all) do  # run before/after the 'describe' or 'context'" do end
        it "end                                    # alias :all  (old; out of favor)" do end
        it "config.before/after(:example/:each) do # run before/after each test" do end
        it "end                                    # alias :each (old; out of favor)" do end
        it "config.around(:example) do |example|   # #around can be done with #before/#after" do end
        it "· puts 'code to run before'            # note that the code here happens before/after" do end
        it "· example.run                          " do end
        it "· puts 'code to run after'" do end
        it "end" do end
        it "# be sure to use @vars in hooks, not locals" do end
      end
      describe "Let - lazy version of #before to set instance vars" do
        it "let(:car) { Car.new }  # let! version is non-lazy" do end
        it "# essentially does this:" do end
        it "before(:context) do" do end
        it "· def car" do end
        it "·   @car ||= Car.new" do end
        it "· end" do end
        it "end" do end
      end
      describe "Subject - identifies the subject object of the test" do
        it "·    subject  { Car.new }  # 'subject' is a # shortcut! non-lazy" do end
        it "·    ^^^^^^^               # shortcut for" do end
        it "let(:subject) { Car.new }  # let(:subject)" do end
      end
      describe "Subject - implicit" do
        it "describe Car # <= passed a class name, not a string!" do end
        it "· # when describe is passed a class, not a string," do end
        it "· # then an implicit 'let(:subject) { <Class>.new }' happens" do end
        it "end" do end
      end
      describe "Shared Example" do
        it "# Replace a normal 'describe <Class>' with 'shared_examples_for'" do end
        it "spec/shared_examples/a_sortable_object.rb" do end
        it "·   describe SortableClass do" do end
        it "·   ^^^^^^^^ ^^^^^^^^^^^^^" do end
        it ". -- becomes --" do end
        it "·   vvvvvvvvvvvvvvvvvvv  vvvvvvvvvvvvvvvvv" do end
        it "·   shared_examples_for('a sortable object') do" do end
        it "·   ^^^^^^^^^^^^^^^^^^^  ^^^^^^^^^^^^^^^^^" do end
        it "# When using, the use of 'subject' in the shared example" do end
        it "# will use whatever class is in the describe line of the test:" do end
        it "spec/.../product_spec.rb" do end
        it "· describe Product do" do end
        it "·   it_behaves_like 'a sortable object'" do end
        it "·" do end
        it "# can use across controllers to test RESTful APIs, for example:" do end
        it "· it_behaves_like 'a standard index action'" do end
        it "· it_behaves_like 'a standard new action'" do end
        it "· it_behaves_like 'a standard create action'" do end
        it "·" do end
        it "# can take a block too, for when some let(:vars) need to be setup:" do end
        it "·   it_behaves_like 'a sortable object' do" do end
        it "·     let(:collection) { Product.limit(5) }" do end
        it "·   end" do end
        it "# but if just need some of the described class, then use #described_class " do end
        it "·   shared_examples_for('a sortable object') do" do end
        it "·     let(:collection) { described_class().limit(5) }" do end
        it "·   end" do end
      end
    end
  end
