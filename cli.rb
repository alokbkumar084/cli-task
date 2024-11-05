#!/usr/bin/env ruby
# frozen_string_literal: true

require 'pry'
require './lib/process_csv'

class CLI
  attr_reader :file_path, :temp_file

  def initialize
    @temp_file = false
  end
  
  def interpret_arguments
    case 
    when ARGV.include?('--help')
      display_help
      return
  
    when ARGV.any?
      @file_path = ARGV.shift
  
    when $stdin.tty?
      puts 'No input provided. Please specify a file or pipe input.'
      exit 1
  
    else
      @temp_file = true
      @file_path = 'tmp/temporary_input.csv'
      File.write(@file_path, $stdin.read)
    end
  end

  def display_help
    puts <<~Guide
      Usage:
        ./cli < input.csv # Reads input.csv from STDIN and outputs to STDOUT

        ./cli input.csv > output.csv # Reads input.csv and outputs to output.csv

        ./cli --help # Shows this help information
    Guide
  end

  def process
    ProcessCsv.new(file_path).process if file_path
  ensure
    File.delete(file_path) if temp_file && File.exist?(file_path)
  end
end

CLI.new.tap do |interface|
  interface.interpret_arguments
  puts interface.process
end
