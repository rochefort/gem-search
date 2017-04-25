#!/usr/bin/env rake
require "bundler/gem_tasks"
require "rspec/core/rake_task"
ENV["COVERAGE"] = "true"
RSpec::Core::RakeTask.new(:spec)

task default: [:spec]
