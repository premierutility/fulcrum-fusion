guard :bundler do
  watch('Gemfile')
end

guard :rspec, wait: 5, all_after_pass: false, all_on_start: true do
  watch('spec/spec_helper.rb')          { "spec" }
  watch(%r{^config/*\.rb$})             { "spec" }
  watch(%r{^spec/support/*/(.+)\.rb$})  { "spec" }
  watch(%r{^spec/.+_spec\.rb$})
  watch('fulcrum_fusion.rb')            { "spec" }
  watch(%r{^lib/(.+)\.rb$})             { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^lib/form_fields/(.+)\.rb$}) { |m| "spec/form_fields_spec.rb" }
end

