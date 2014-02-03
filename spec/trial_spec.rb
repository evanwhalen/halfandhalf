require 'spec_helper'

describe HalfAndHalf::Trial do

  describe 'token' do

    it 'should return token containing experiment, variant and number' do
      trial = HalfAndHalf::Trial.new(
        experiment: HalfAndHalf::Experiment.new(name: :ab),
        variant: HalfAndHalf::Variant.new(result: 'a', name: 'a'),
        number: 2
      )
      trial.token.should == 'ab.a.2'
    end
  end

  describe 'call' do

    it 'should call variant' do
      variant = HalfAndHalf::Control.new
      trial = HalfAndHalf::Trial.new(variant: variant)
      variant.should_receive(:call).with('foo')
      trial.call('foo')
    end
  end
end