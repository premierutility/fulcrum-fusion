guard 'rspec', :wait => 60, :all_after_pass => false do
guard :bundler do
  watch('Gemfile')
end

  watch('spec/spec_helper.rb')          { "spec" }
  watch(%r{^spec/support/**/(.+)\.rb$}) { "spec" }
  watch('fulcrum_fusion.rb')            { "spec" }
  watch(%r{^lib/(.+)\.rb$})             { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^lib/form_fields/(.+)\.rb$}) { |m| "spec/form_fields_spec.rb" }
  watch(%r{^spec/.+_spec\.rb$})
end

