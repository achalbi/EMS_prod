# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rubyzip}
  s.version = "1.1.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Alexander Simonov"]
  s.date = %q{2014-05-30}
  s.email = ["alex@simonov.me"]
  s.homepage = %q{http://github.com/rubyzip/rubyzip}
  s.licenses = ["BSD 2-Clause"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")
  s.rubygems_version = %q{1.7.2}
  s.summary = %q{rubyzip is a ruby module for reading and writing zip files}

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
