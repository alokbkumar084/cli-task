# frozen_string_literal: true

require 'geocoder'
require_relative '../../lib/location_validator'

RSpec.describe LocationValidator do
  let(:valid_locality) { 'ALVIE' }
  let(:valid_state) { 'NSW' }
  let(:valid_postcode) { '3249' }
  let(:invalid_locality) { nil }
  let(:invalid_state) { nil }
  let(:invalid_postcode) { nil }

  before do
    allow(Geocoder).to receive(:search).and_return([])
  end

  describe '.validate?' do
    context 'when incomplete address' do
      it 'returns false if locality is blank/empty' do
        result = LocationValidator.validate?(invalid_locality, valid_state, valid_postcode)
        expect(result).to be false
      end

      it 'returns false if state is blank/empty' do
        result = LocationValidator.validate?(valid_locality, invalid_state, valid_postcode)
        expect(result).to be false
      end

      it 'returns false if postcode is blank/empty' do
        result = LocationValidator.validate?(valid_locality, valid_state, invalid_postcode)
        expect(result).to be false
      end
    end

    context 'when complete and valid address' do
      before do
        allow(Geocoder).to receive(:search).and_return([double(postal_code: valid_postcode)])
      end

      it 'lookup_cache the result' do
        LocationValidator.validate?(valid_locality, valid_state, valid_postcode)
        expect(LocationValidator.instance_variable_get(:@lookup_cache)).to have_key("#{valid_locality},#{valid_state},#{valid_postcode}")
      end
    end
  end
end
