# frozen_string_literal: true

require 'geocoder'
require_relative '../config/geocoder'

module LocationValidator
  @lookup_cache = {}

  class << self
    def validate?(locality, state, postal_code)
      return false if incomplete_address?(locality, state, postal_code)

      key = cache_key(locality, state, postal_code)

      @lookup_cache.fetch(key) do
        @lookup_cache[key] = perform_lookup(locality, state, postal_code)
      end
    end

    private

    def incomplete_address?(locality, state, postal_code)
      [locality, state, postal_code].any?(&:nil?)
    end

    def cache_key(locality, state, postal_code)
      "#{locality},#{state},#{postal_code}"
    end

    def perform_lookup(locality, state, postal_code)
      complete_address = "#{locality}, #{state}, #{postal_code}"
      results = Geocoder.search(complete_address)

      results.any? && results.first.postal_code == postal_code
    rescue StandardError
      false
    end
  end
end
