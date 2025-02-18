# frozen_string_literal: true

require 'appraisal/matrix'

appraisal_matrix(activerecord: '6.1') do |activerecord:|
  if activerecord <= Gem::Version.new('7.0')
    gem 'drb'
  end
end
