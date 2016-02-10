require 'rspec'
require_relative '../lib/grep'

exam =[3,2,1,0,-1]
order=[1,2,3,4,5]

describe Grep, "#fgrepf" do
  context "valid input" do
    it "should return correct subset of 'exam', in order found in 'order'" do
      matches, misses = Grep.fgrepf(exam,order)
      expect(matches).to eq([1,2,3])
      expect(misses).to  eq([0,-1])
    end
    it "does not crash with empty arrays" do
      exam =[]
      order=[]
      matches, misses = Grep.fgrepf(exam,order)
      expect(matches).to eq([])
      expect(misses).to  eq([])
    end
    it "results in empty results, given empty inputs" do
      exam =[]
      order=[1,2,3]
      matches, misses = Grep.fgrepf(exam,order)
      expect(matches).to eq([])
      expect(misses).to  eq([])
    end
    it "results in empty results, given empty 'exam'" do
      exam =[]
      order=[1,2,3]
      matches, misses = Grep.fgrepf(exam,order)
      expect(matches).to eq([])
      expect(misses).to  eq([])
    end
    it "results in empty matches, full misses, given empty 'order'" do
      exam =[1,2,3]
      order=[]
      matches, misses = Grep.fgrepf(exam,order)
      expect(matches).to eq([])
      expect(misses).to  eq(exam)
    end
    it "returns empty results if 'order' is nil" do
      matches, misses = Grep.fgrepf([],nil)
      expect(matches).to eq([])
      expect(misses).to  eq([])
    end
  end
  context "error cases" do
    it "throws exception when exam list is non-array type" do
      expect {
        Grep.fgrepf(1,order)
      }.to raise_error(ArgumentError)
    end
  end
end
