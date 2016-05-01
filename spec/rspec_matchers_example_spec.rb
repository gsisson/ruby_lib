  class O
    attr_accessor :count
    def initialize; @count = 0; end
    def increment; @count += 1; end
    def visible?
      true
    end
    def has_order?
      true
    end
  end
  hits = customer = this_object = O.new

  describe "LOOSE equality with #eq (uses #==)" do
    it "expect('a').to eq('a')" do
        expect('a').to eq('a')
    end
    it "expect('a').to be == 'a' # synonym for #eq with no parens, rarely used" do
        expect('a').to be == 'a'
    end
    it 'expect( 1 ).to eq(1.0)   # different types, but "close enough"' do
        expect( 1 ).to eq(1.0)
    end
  end
  describe "VALUE equality with #eql (uses #eql?)" do
    it "expect('a').to     eql('a') # value equality" do
        expect('a').to     eql('a')
    end
    it "expect( 1 ).not_to eql(1.0) # 1 and 1.0 are not 'value equal'" do
        expect( 1 ).not_to eql(1.0)
    end
  end
  describe 'IDENTITY equality with #equal (uses #equal?)' do
    it "a = b = 'x'" do
        expect(true).to be(true)
    end
    it "expect( a ).to     equal( b ) # same object" do
        a = b = 'x'
        expect( a ).to     equal( b )
    end
    it "expect( a ).to        be( b ) # 'be()' is a synonym for 'equal()'" do
        a = b = 'x'
        expect( a ).to        be( b )
    end
    it "expect('z').not_to equal('z') # same value, but different objects" do
        expect('z').not_to equal('z')
    end
  end
  describe "TRUTHINESS/boolean matchers" do
    it "expect(1 < 2).to     be(true)   # DO NOT use 'be_true'  (old usage and confusingly meant truthy!)" do
        expect(1 < 2).to     be(true)
    end
    it "expect(1 > 2).to     be(false)  # DO NOT use 'be_false' (old usage and confusingly meant falsey!)" do
        expect(1 > 2).to     be(false)
    end
    it "expect('foo').not_to be(true)   # a string is not 'true'  (but is 'truthy')" do
        expect('foo').not_to be(true)
    end
    it "expect( nil ).not_to be(false)  #      nil is not 'false' (but is 'falsey')" do
        expect( nil ).not_to be(false)
    end
    it "expect(  0  ).not_to be(false)  #        0 is not 'false' (nor    'falsey')" do
        expect(  0  ).not_to be(false)
    end
    it "expect( true).to     be_truthy  #       true is 'truthy'" do
        expect( true).to     be_truthy
    end
    it "expect(false).to     be_falsey  #      false is 'falsey'" do
        expect(false).to     be_falsey
    end
    it "expect( nil ).to     be_falsey  #        nil is 'falsey'" do
        expect( nil ).to     be_falsey
    end
    it "expect('foo').to     be_truthy  #   a string is 'truthy'" do
        expect('foo').to     be_truthy
    end
    it "expect(  0  ).not_to be_falsey  # an integer is 'truthy'" do
        expect(  0  ).not_to be_falsey
    end
  end
  describe "NIL-ness matcherers (uses #nil?)" do
    it "expect( nil ).to be_nil   # be_nil  is fine" do
        expect( nil ).to be_nil
    end
    it "expect( nil ).to be(nil)  # be(nil) is also fine" do
        expect( nil ).to be(nil)
    end
  end
  describe 'NUMERIC COMPARISON matchers' do
    it "expect(10).to be >   9 #  also: >=, <, <=" do
        expect(10).to be >   9
    end
  end
  describe 'NUMERIC RANGE matchers' do
    it "expect(   10).to     be_between(5, 10).inclusive" do
        expect(   10).to     be_between(5, 10).inclusive
    end
    it "expect(   10).not_to be_between(5, 10).exclusive" do
        expect(   10).not_to be_between(5, 10).exclusive
    end
    it "expect(   10).to     be_within(1).of(11)        " do
        expect(   10).to     be_within(1).of(11)
    end
    it "expect(5..10).to     cover(9)                   # sortof an inversion of between/within" do
        expect(5..10).to     cover(9)
    end
  end
  describe 'COLLECTION matchers' do
    it "expect( [1,2,3] ).to     include(3)           " do
        expect( [1,2,3] ).to     include(3)
    end
    it "expect( [1,2,3] ).to     include(1,3)         " do
        expect( [1,2,3] ).to     include(1,3)
    end
    it "expect( [1,2,3] ).to     start_with(1)        " do
        expect( [1,2,3] ).to     start_with(1)
    end
    it "expect( [1,2,3] ).to     end_with(3)          " do
        expect( [1,2,3] ).to     end_with(3)
    end
    it "expect( [1,2,3] ).to     match_array([3,2,1])   # must have all items, but order not important" do
        expect( [1,2,3] ).to     match_array([3,2,1])
    end
    it "expect( [1,2,3] ).not_to match_array([1,2])     # must have all items, but order not important" do
        expect( [1,2,3] ).not_to match_array([1,2])
    end
    it "expect( [1,2,3] ).to     contain_exactly(3,2,1) # similar to match_array(); uses individual args" do
        expect( [1,2,3] ).to     contain_exactly(3,2,1)
    end
    it "expect( [1,2,3] ).not_to contain_exactly(1,2)   # similar to match_array(); uses individual args" do
        expect( [1,2,3] ).not_to contain_exactly(1,2)
    end
  end
  describe "STRING matchers" do
    it "expect('some string').to    include('ring')" do
        expect('some string').to    include('ring')
    end
    it "expect('some string').to    include('so', 'ring')" do
        expect('some string').to    include('so', 'ring')
    end
    it "expect('some string').to start_with('so')" do
        expect('some string').to start_with('so')
    end
    it "expect('some string').to   end_with('ring')" do
        expect('some string').to   end_with('ring')
    end
  end
  describe "HASH matchers" do
    it "expect( {:a => 1, :b => 2, :c => 3} ).not_to include(  'a' )" do
        expect( {:a => 1, :b => 2, :c => 3} ).not_to include(  'a' )
    end
    it "expect( {:a => 1, :b => 2, :c => 3} ).to     include(  :a  )" do
        expect( {:a => 1, :b => 2, :c => 3} ).to     include(  :a  )
    end
    it "expect( {:a => 1, :b => 2, :c => 3} ).to     include(  :a => 1  )" do
        expect( {:a => 1, :b => 2, :c => 3} ).to     include(  :a => 1  )
    end
    it "expect( {:a => 1, :b => 2, :c => 3} ).to     include(  :a => 1, :c => 3  )" do
        expect( {:a => 1, :b => 2, :c => 3} ).to     include(  :a => 1, :c => 3  )
    end
    it "expect( {:a => 1, :b => 2, :c => 3} ).to     include( {:a => 1, :c => 3} )" do
        expect( {:a => 1, :b => 2, :c => 3} ).to     include( {:a => 1, :c => 3} )
    end
  end
  describe 'REGEX matchers' do
    it "expect( '53 orders taken' ).to match( /\d{2}(.+)order(.+)taken/ )" do
        expect( '53 orders taken' ).to match( /\d{2}(.+)order(.+)taken/ )
    end
  end
  describe 'OBJECT matchers' do
    it "expect('hi').to  be_instance_of(String)    # exact object type matcher " do
        expect('hi').to  be_instance_of(String)   
    end
    it "expect('hi').to  be_an_instance_of(String) #   alias" do
        expect('hi').to  be_an_instance_of(String)
    end
    it "expect('hi').to  be_a(String)              # is-a object type matcher" do
        expect('hi').to  be_a(String)             
    end
    it "expect('hi').to  be_a_kind_of(String)      #   alias" do
        expect('hi').to  be_a_kind_of(String)     
    end
    it "expect('hi').to  be_kind_of(String)        #   alias" do
        expect('hi').to  be_kind_of(String)       
    end
    it "expect([1,2]).to be_an(Array)              #   alias" do
        expect([1,2]).to be_an(Array)             
    end
  end
  describe "RESPOND_TO message matchers" do
    it "expect('hi').to     respond_to(:length)" do
        expect('hi').to     respond_to(:length)
    end
    it "expect('hi').not_to respond_to(:sort)  " do
        expect('hi').not_to respond_to(:sort)
    end
  end
  describe "HAVE_ATTRIBUTES matcher will match if class has 'attr_accessor'" do
    it "expect(car).to have_attributes(:make => 'Dodge', :year => 2010, :color => 'green')" do
      class Car
        attr_accessor :make, :year, :color
      end
      car = Car.new
      car.make = 'Dodge';   car.year = 2010;   car.color = 'green'
      expect(car).to have_attributes(:color => 'green')
      expect(car).to have_attributes(:make => 'Dodge', :year => 2010, :color => 'green')
    end
  end
  describe "SATISFY matcher will match pretty much anything" do
    it "expect(10).to satisfy do |value|" do end
    it "__(value >= 5) && (value % 2 == 0)" do end
    it "end" do
      expect(10).to satisfy do |value|
        (value >= 5) && (value % 2 == 0)
      end
    end
  end
  describe "PREDICATE matchers (return true/false)" do
    describe "these 'be_*' matchers map to #*? ( drops 'be_', adds '?' ) - take no args" do
      it "expect( []).to be_empty                     # built-in method [].empty?" do
          expect( []).to be_empty
      end
      it  "expect( 1 ).to be_integer                   # built-in method 1.integer?" do
           expect( 1 ).to be_integer
      end
      it  "expect( 0 ).to be_zero                      # built-in method 0.zero?" do
           expect( 0 ).to be_zero
      end
      it  "expect( 1 ).to be_nonzero                   # built-in method 1.nonzero?" do
           expect( 1 ).to be_nonzero
      end
      it  "expect( 1 ).to be_odd                       # built-in method 1.odd?" do
           expect( 1 ).to be_odd
      end
      it  "expect( 2 ).to be_even                      # built-in method 1.even?" do
           expect( 2 ).to be_even
      end
      it  "expect(nil).to be_nil                       # built-in method nil.nil?" do
           expect(nil).to be_nil
      end
      it  "expect(this_object).to          be_visible  #   custom method: this_object.visible?" do
           expect(this_object).to          be_visible
      end
      it  "expect(this_object.visible?).to be true     #                  exactly the same" do
           expect(this_object.visible?).to be true
      end
    end
    describe "these 'have_*' matchers map to '#has_*?' - args optional" do
      it "expect( {:a => 1, :b => 2} ).to have_key(:a)  # Hash#has_key?" do
          expect( {:a => 1, :b => 2} ).to have_key(:a)
      end
      it "expect( {:a => 1, :b => 2} ).to have_value(2) # Hash#has_value?" do
          expect( {:a => 1, :b => 2} ).to have_value(2)
      end
      it "expect(customer).to have_order         # predicate matcher # custom method: customer.has_order?" do
          expect(customer).to have_order
      end
      it "expect(customer.has_order?).to be true # predicate matcher #                 exactly the same" do
          expect(customer.has_order?).to be true
      end
    end
  end
  describe "OBSERVATIONAL matchers - take a block (  'expect {}', instead of 'expect()' )" do
    it "=> they match when events change object attributes (calls test before block, then after block)" do end
    it "expect {     array << 1 }.to change(array, :empty?).from(true).to(false) # calls array.empty?()" do
        array = []
        expect {     array << 1 }.to change(array, :empty?).from(true).to(false) 
    end
    it "expect { hits.increment }.to change(hits,  :count) .from(0)   .to(1)     # calls hits.count()" do
        expect { hits.increment }.to change(hits,  :count) .from(0)   .to(1)
    end
  end
  x = 10
  describe "OBSERVATIONAL matchers - in these, there are two blocks; change() also takes a block" do
    it "=> they match when events cause 2nd block expression to have changed" do end
    it "=> must have a value before the block" do end
    it "=> must change the value inside the block" do end
    it "x = 10" do end
    it "expect { x += 1 }.to change {x}.from(10).to(11)" do
        expect { x += 1 }.to change {x}.from(10).to(11)     
    end
    it "expect { x += 1 }.to change {x}.by(1)" do
        expect { x += 1 }.to change {x}.by(1)               
    end
    it "expect { x += 1 }.to change {x}.by_at_least(1)" do
        expect { x += 1 }.to change {x}.by_at_least(1)      
    end
    it "expect { x += 1 }.to change {x}.by_at_most(1)" do
        expect { x += 1 }.to change {x}.by_at_most(1)       
    end
    it "expect { x += 1 }.to change { x % 2 }.from(0).to(1)" do
        expect { x += 1 }.to change { x % 2 }.from(0).to(1) 
    end
  end
  describe "OBSERVATIONAL matchers - for exceptions" do
    RSpec::Expectations.configuration.warn_about_potential_false_positives = false
    it "RSpec::Expectations.configuration.warn_about_potential_false_positives = false" do end
    it "expect { raise StandardError }.to raise_error                              # match on exception" do
        expect { raise StandardError }.to raise_error
    end
    it "expect { raise StandardError }.to raise_exception                          # match on exception" do
        expect { raise StandardError }.to raise_exception
    end
    it "expect { 1 / 0 }.to               raise_error(ZeroDivisionError)           # match on type of exception" do
        expect { 1 / 0 }.to               raise_error(ZeroDivisionError)
    end
    it "expect { 1 / 0 }.to               raise_error.with_message('divided by 0') # match on exception message" do
        expect { 1 / 0 }.to               raise_error.with_message('divided by 0')
    end
    it "expect { 1 / 0 }.to               raise_error.with_message(/divided/)      # match on exception msg regex" do
        expect { 1 / 0 }.to               raise_error.with_message(/divided/)
    end
    it "expect { 1 / 1 }.not_to           raise_error" do
        expect { 1 / 1 }.not_to           raise_error
    end
  end
  describe "OBSERVATIONAL matchers - output to stdout / stderr " do
    it "expect { print('howdy') }.to output.to_stdout          # stdout written" do
        expect { print('howdy') }.to output.to_stdout
    end
    it "expect { print('howdy') }.to output('howdy').to_stdout # stdout written" do
        expect { print('howdy') }.to output('howdy').to_stdout
    end
    it "expect { print('howdy') }.to output(/wd/).to_stdout    # stdout written" do
        expect { print('howdy') }.to output(/wd/).to_stdout
    end
    it "expect {  warn('issue') }.to output(/issue/).to_stderr # stderr written" do
        expect {  warn('issue') }.to output(/issue/).to_stderr
    end
  end
  
  describe "COMPOUND expectations (and, or, &, |)" do
        array=[1,2,3,4]    
    it "array=[1,2,3,4]                               " do end
    it "expect(array).to start_with(1).and end_with(4)" do
        expect(array).to start_with(1).and end_with(4)
    end
    it ".                              ^^^            " do end
    it "expect(array).to start_with(1)  &  include(2)   " do
        expect(array).to start_with(1)  &  include(2)
    end
    it ".                              ^^^             " do end
    it "expect(2).to eq(1) |  eq(2) " do
        expect(2).to eq(1) |  eq(2)
    end
    it ".                 ^^^ " do end
    it "expect(2).to eq(1).or eq(2) " do
        expect(2).to eq(1).or eq(2)
    end
    it ".                  ^^ " do end
  end
  
  describe "COMPOSING matchers, that accept matchers as args (rspec3)" do
    describe "all" do
      it "array = [1,2,3]" do end
      it "expect(array).to all( be < 5 ) # each element must meet the expectation" do
        array = [1,2,3]
        expect(array).to all( be < 5 ) # each element must meet the expectation
      end
    end
    describe "from to" do
      it "string = 'hello'" do end
      it "expect { string = 'goodbye' }.to change { string }." do end
      it "__from( match(/ll/) ).to( match(/oo/) )" do
        # will match by sending matchers as arguments to matchers"
        string = "hello"
        expect { string = "goodbye" }.to change { string }.
          from( match(/ll/) ).to( match(/oo/) )
      end
    end
    describe "include" do
      it "hash = {:a => 1, :b => 2, :c => 3}" do end
      hash = {:a => 1, :b => 2, :c => 3}
      it "expect(hash).to include(:a => be_odd, :b => be_even, :c => be_odd)" do
          expect(hash).to include(:a => be_odd, :b => be_even, :c => be_odd)
      end
      it "expect(hash).to include(:a => be > 0, :b => be_within(2).of(4))" do
          expect(hash).to include(:a => be > 0, :b => be_within(2).of(4))
      end
    end
    
    describe "aliases to make matchers read better with noun-based phrases (not verb-based)" do
      it "start_with        => a_string_starting_with" do end
      it "end_with          => a_string_ending_with" do end
      it "match             => a_string_matching" do end
      it "be < 2            => a_value < 2" do end
      it "be_within         => a_value_within" do end
      it "contain_exactly   => a_collection_containing_exactly" do end
      it "be_an_instance_of => an_instance_of" do end
      describe "example" do
        it "fruits = ['apple', 'banana', 'cherry']" do end
        it "expect(fruits).to start_with( a_string_starting_with('a') ) & " do end
        it "__include( a_string_matching(/a.a.a/) ) & " do end
        it "__end_with( a_string_ending_with('y') )" do
            fruits = ['apple', 'banana', 'cherry']
            expect(fruits).to start_with( a_string_starting_with('a') ) & 
              include( a_string_matching(/a.a.a/) ) & 
              end_with( a_string_ending_with('y') )
        end
      end
    end
  end
