# frozen_string_literal: true

require_relative '../../lib/process_csv'
require_relative '../../lib/location_validator'
require 'csv'


RSpec.describe ProcessCsv do
  let(:result) { ProcessCsv.new(file_path).process }

  before do
    allow(LocationValidator).to receive(:validate?).and_return(true)
  end

  describe '#process' do
    context 'with valid CSV rows' do
      let(:file_path) { 'spec/fixtures/valid.csv' }

      it 'processe file and returns valid data' do
        expect(result).not_to be_empty
        expect(result.size).to eq(1)
      end

      it 'exclude rows when email, first name, or last name is blank' do
        allow(LocationValidator).to receive(:validate?).and_return(false)
        expect(result).to be_empty
      end
    end

    context 'with invalid data address' do
      let(:file_path) { 'spec/fixtures/invalid.csv' }

      it 'skips rows with invalid residential or postal addresses' do
        allow(LocationValidator).to receive(:validate?).and_return(false)
        expect(result).to be_empty
      end
    end
  end
end
