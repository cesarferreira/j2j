require 'spec_helper'

describe J2j do
  let(:data) {{ :key => 'value' }}
  let(:till_midnight) { 0 }

  describe '.transforms(data, till_midnight)' do
    it 'returns a hash of the passed data' do
      pending
    end

    it 'stores original and transformed data' do
      pending
    end

    it 'restores the data to its original state after set time' do
      pending
    end
  end

  describe '.get(id)' do
    context 'before midnight (before time expired)' do
      it 'returns transformed data' do
        pending
      end
    end

    context 'past midnight (after time expired)' do
      it 'returns original data' do
        pending
      end
    end
  end

  describe '.midnight(id)' do
    it 'restores the data to its original state' do
      pending
    end
  end
end
