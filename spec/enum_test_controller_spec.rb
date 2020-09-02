# frozen_string_literal: true

# require 'fixtures/enumeration_test_model'
# require 'fixtures/enum_controller'
#
# Rspec.describe ActiveRecord::Enum::EnumController do
#
#   before do
#     EnumerationTestModel.connection.execute 'DELETE FROM enumerations'
#
#     Rails.application.routes.draw do
#       match '/enum_select' => "enum#enum_select"
#     end
#   end
#
#   it "should render enum_select" do
#     get :enum_select
#     assert_response :success
#     assert_equal '<select id="test_severity" name="test[severity]"><option value="low">low</option>
# <option value="medium" selected="selected">medium</option>
# <option value="high">high</option>
# <option value="critical">critical</option></select>', @response.body
#   end
#
# end