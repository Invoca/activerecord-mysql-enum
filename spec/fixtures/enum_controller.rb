# frozen_string_literal: true

class EnumController < ActionController::Base
  layout false

  def enum_select
    @test = EnumerationTestModel.new
    render :inline => "<%= enum_select('test', 'severity')%>"
  end

end
