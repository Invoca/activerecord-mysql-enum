# frozen_string_literal: true

class EnumTestController < ActionController::Base
  layout false

  def enum_select
    @test = EnumerationTestModel.new
    render :inline => "<%= enum_select('test', 'severity')%>"
  end
end
