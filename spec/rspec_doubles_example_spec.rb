# -*- coding: utf-8 -*-

  describe "Chapter 6" do
    describe "DOUBLES - full doubles" do
      describe "stub method to respond to a message" do
        it "dbl = double('Chant')" do end
        it "allow(dbl).to receive(:hey!)     # the double will allow #hey! to be called" do end
        it "·             ^^^^^^^^" do end
        it "expect(dbl).to respond_to(:hey!) # prove that #hey! is now a callable method" do end
        it "·              ^^^^^^^^^^" do
            dbl = double("Chant")
            allow(dbl).to receive(:hey!)     # the double will allow #hey! to be called
            expect(dbl).to respond_to(:hey!) # prove that #hey! is now a callable method
        end
      end
      describe "stub a response to a method call; also insist it be called" do
        it "dbl = double('Chant')" do end
        it "allow(dbl).to receive(:hey!) { 'Ho!' }         # alternative A" do end
        it "·                            ^^     ^^" do end
        it "allow(dbl).to receive(:hey!).and_return('Ho!') # alternative B" do end
        it "·                            ^^^^^^^^^^" do end
        it "expect(dbl.hey!).to eq('Ho!')                  # prove it returns 'Ho! " do end
        it "expect(dbl).to receive(:hey!).and_return('Ho!')" do end
        it "^^^^^^                        ^^^^^^^^^^       # unlike #allow, we now #expect it to be called" do end
        it "dbl.hey!" do end
        it "·   ^^^^                                       # we call it" do
            dbl = double("Chant")
            allow(dbl).to receive(:hey!) { "Ho!" }         # alternative A ( block  )
            allow(dbl).to receive(:hey!).and_return('Ho!') # alternative B ( method )
            expect(dbl.hey!).to eq("Ho!")                  # prove it returns 'Ho! " do
            expect(dbl).to receive(:hey!).and_return('Ho!')
            dbl.hey!
        end
      end
      describe "stub #ordered method calls" do
        it "dbl = double('Multi-step Process')" do end
        it "expect(dbl).to receive(:step_1).ordered" do end
        it "·                               ^^^^^^^" do end
        it "expect(dbl).to receive(:step_2).ordered" do end
        it "·                               ^^^^^^^" do end
        it "dbl.step_1" do end
        it "dbl.step_2" do
            dbl = double('Multi-step Process')
            expect(dbl).to receive(:step_1).ordered
            expect(dbl).to receive(:step_2).ordered
            dbl.step_1
            dbl.step_2
        end
      end
      describe "stub multiple methods with hash syntax" do
        it "dbl = double('Person')" do end
        # Note this uses #receive_messages, not #receive
        it "allow(dbl).to receive_messages(:full_name => 'Mary Smith', :initials => 'MTS')" do end
        it "·             ^^^^^^^^^^^^^^^^" do end
        it "expect(dbl.full_name).to eq('Mary Smith')" do end
        it "expect(dbl.initials).to eq('MTS')" do
            dbl = double('Person')
            # Note this uses #receive_messages, not #receive
            allow(dbl).to receive_messages(:full_name => 'Mary Smith', :initials => 'MTS')
            expect(dbl.full_name).to eq('Mary Smith')
            expect(dbl.initials).to eq('MTS')
        end
      end
      describe "stub with a hash argument to #double" do
        it "dbl = double('Person', :full_name => 'Mary Smith', :initials => 'MTS')" do end
        it "·     ^^^^^^           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^" do end
        it "expect(dbl.full_name).to eq('Mary Smith')" do end
        it "expect(dbl.initials).to eq('MTS')" do
            dbl = double('Person', :full_name => 'Mary Smith', :initials => 'MTS')
            expect(dbl.full_name).to eq('Mary Smith')
            expect(dbl.initials).to eq('MTS')
        end
      end
      describe "allows stubbing MULTIPLE RESPONSES with #and_return" do
        it "die = double('Die')" do end
        it "allow(die).to receive(:roll).and_return(1,6)" do end
        it "·                                       ^^^" do end
        it "expect(die.roll).to eq(1)" do end
        it "·                      ^" do end
        it "expect(die.roll).to eq(6)" do end
        it "·                      ^" do end
        it "expect(die.roll).to eq(6) # continues returning last value" do end
        it "·                      ^" do
          die = double('Die')
          allow(die).to receive(:roll).and_return(1,6)
          expect(die.roll).to eq(1)
          expect(die.roll).to eq(6)
          expect(die.roll).to eq(6)  # continues returning last value
        end
      end
    end
    describe "DOUBLES - partial doubles" do
      describe "stub INSTANCE methods on classes" do
        it "time = Time.new(2010, 1, 1, 12, 0, 0)" do end
        it "^^^^" do end
        it "allow(time).to receive(:year).and_return(1975)" do end
        it "·     ^^^^     ^^^^^^^        ^^^^^^^^^^" do end
        it "expect(time.to_s).to eq('2010-01-01 12:00:00 -0800')" do end
        it "expect(time.year).to eq(1975)" do
            time = Time.new(2010, 1, 1, 12, 0, 0)
            allow(time).to receive(:year).and_return(1975)
            expect(time.to_s).to eq('2010-01-01 12:00:00 -0800')
            expect(time.year).to eq(1975)
        end
      end
      describe "stub CLASS methods on classes" do
        it "fixed = Time.new(2010, 1, 1, 12, 0, 0)" do end
        it "^^^^^" do end
        it "allow(Time).to receive(:now).and_return(fixed)" do end
        it "·     ^^^^     ^^^^^^^ ^^^^  ^^^^^^^^^^ ^^^^^" do end
        it "expect(Time.now).to eq(fixed)" do end
        it "·      ^^^^^^^^        ^^^^^" do end
        it "expect(Time.now.to_s).to eq('2010-01-01 12:00:00 -0800')" do end
        it "·      ^^^^^^^^^^^^^         ^^^^ ^^ ^^ ^^" do end
        it "expect(Time.now.year).to eq(2010)" do end
        it "·      ^^^^^^^^^^^^^        ^^^^" do
            fixed = Time.new(2010, 1, 1, 12, 0, 0)
            allow(Time).to receive(:now).and_return(fixed)
            expect(Time.now).to eq(fixed)
            expect(Time.now.to_s).to eq('2010-01-01 12:00:00 -0800')
            expect(Time.now.year).to eq(2010)
        end
      end
      describe "stub database calls with mock objects" do
        it "class Customer" do end
        it "· attr_accessor :name" do end
        it "· def self.find ... end" do end
        it "· def self.all ... end" do end
        it "end" do end
        it "c1 = double('First Customer')" do end
        it "^^" do end
        it "c2 = double('Second Customer', :name => 'Mary')" do end
        it "^^" do end
        it "allow(c1).to receive(:name).and_return('Bob')" do end
        it "·     ^^" do end
        it "allow(Customer).to receive(:all).and_return([c1,c2])" do end
        it "·     ^^^^^^^^             ^^^^             ^^^^^^^" do end
        it "allow(Customer).to receive(:find).and_return(c1)" do end
        it "·     ^^^^^^^^             ^^^^^             ^^" do end
        it "expect(customer.find.name).to eq('Bob')" do end
        it "·      ^^^^^^^^ ^^^^              ^^^" do end
        it "expect(Customer.all[0].name).to eq('Bob')" do end
        it "·      ^^^^^^^^ ^^^                 ^^^" do end
        it "expect(Customer.all[1].name).to eq('Mary')" do end
        it "·      ^^^^^^^^ ^^^                 ^^^^" do
            class Customer
              attr_accessor :name
              def self.find
                # database lookup, returns one object
              end
              def self.all
                # database lookup, returns array of objects
              end
            end
            c1 = double('First Customer')
            c2 = double('Second Customer', :name => 'Mary')
            allow(c1).to receive(:name).and_return('Bob')
            allow(Customer).to receive(:all).and_return([c1,c2])
            allow(Customer).to receive(:find).and_return(c1)
            expect(Customer.find.name).to eq('Bob')
            expect(Customer.all[0].name).to eq('Bob')
          end
        end
      end
    end
