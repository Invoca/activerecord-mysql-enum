# frozen_string_literal: true

require 'fixtures/enumeration_test_model'

describe EnumerationTestModel do
  before :each do
    EnumerationTestModel.connection.execute 'DELETE FROM enumeration_test_models'
  end

  it 'test_column_values' do
    columns = EnumerationTestModel.columns_hash
    color_column = columns['color']
    expect(color_column).not_to be_nil
    expect(color_column.limit).to eq([:red, :blue, :green, :yellow])

    severity_column = columns['severity']
    expect(severity_column).not_to be_nil
    expect(severity_column.limit).to eq([:low, :medium, :high, :critical])
    expect(severity_column.default).to eq(:medium)
  end

  it 'test_insert_enum' do
    row = EnumerationTestModel.new
    row.color = :blue
    row.string_field = 'test'
    expect(row.severity).to eq(:medium)
    expect(row.save).to be true

    db_row = EnumerationTestModel.find(row.id)
    expect(db_row).not_to be_nil
    expect(row.color).to eq(:blue)
    expect(row.severity).to eq(:medium)
  end

  # Uses the automatic validates_columns to create automatic validation rules
  # for columns based on the schema information.
  it 'test_bad_value' do
    row = EnumerationTestModel.new
    row.color = :violet
    row.string_field = 'test'

    expect(row.save).to be false
    expect(row.errors).not_to be_empty
    expect(row.errors['color']).to eq(['is not included in the list'])
  end

#   def test_other_types
#     row = EnumerationTestModel.new
#     row.string_field = 'a' * 10
#     assert !row.save
#     assert_equal ['is too long (maximum is 8 characters)'], row.errors['string_field']
#
#     row = EnumerationTestModel.new
#     assert !row.save
#     assert_equal ['can\'t be blank'], row.errors['string_field']
#
#     row = EnumerationTestModel.new
#     row.string_field = 'test'
#     row.int_field = 'aaaa'
#     assert !row.save
#     assert_equal ['is not a number'], row.errors['int_field']
#
#     row = EnumerationTestModel.new
#     row.string_field = 'test'
#     row.int_field = '500'
#     assert row.save
#   end
#
#   def test_view_helper
#     request  = ActionController::TestRequest.new
#     response = ActionController::TestResponse.new
#     request.action = 'test1'
#     body = EnumController.process(request, response).body
#     assert_equal '<select id="test_severity" name="test[severity]"><option value="low">low</option><option value="medium" selected="selected">medium</option><option value="high">high</option><option value="critical">critical</option></select>', body
#   end
#
#   def test_radio_helper
#     request  = ActionController::TestRequest.new
#     response = ActionController::TestResponse.new
#     request.action = 'test2'
#     body = EnumController.process(request, response).body
#     assert_equal '<label>low: <input id="test_severity_low" name="test[severity]" type="radio" value="low" /></label><label>medium: <input checked="checked" id="test_severity_medium" name="test[severity]" type="radio" value="medium" /></label><label>high: <input id="test_severity_high" name="test[severity]" type="radio" value="high" /></label><label>critical: <input id="test_severity_critical" name="test[severity]" type="radio" value="critical" /></label>', body
#   end
#
#
#   # Basic tests
#   def test_create_basic_default
#     assert (object = BasicEnumTestModel.create)
#     assert_nil object.value,
#       "Enum columns without explicit default, default to null if allowed"
#     assert !object.new_record?
#   end
#
#   def test_create_basic_good
#     assert (object = BasicEnumTestModel.create(:value => :good))
#     assert_equal :good, object.value
#     assert !object.new_record?
#     assert (object = BasicEnumTestModel.create(:value => :working))
#     assert_equal :working, object.value
#     assert !object.new_record?
#   end
#
#   def test_create_basic_null
#     assert (object = BasicEnumTestModel.create(:value => nil))
#     assert_nil object.value
#     assert !object.new_record?
#   end
#
#   def test_create_basic_bad
#     assert (object = BasicEnumTestModel.create(:value => :bad))
#     assert object.new_record?
#   end
#
#   # Basic w/ Default
#
#   ######################################################################
#
#   def test_create_basic_wd_default
#     assert (object = BasicDefaultEnumTestModel.create)
#     assert_equal :working, object.value, "Explicit default ignored columns"
#     assert !object.new_record?
#   end
#
#   def test_create_basic_wd_good
#     assert (object = BasicDefaultEnumTestModel.create(:value => :good))
#     assert_equal :good, object.value
#     assert !object.new_record?
#     assert (object = BasicDefaultEnumTestModel.create(:value => :working))
#     assert_equal :working, object.value
#     assert !object.new_record?
#   end
#
#   def test_create_basic_wd_null
#     assert (object = BasicDefaultEnumTestModel.create(:value => nil))
#     assert_nil object.value
#     assert !object.new_record?
#   end
#
#   def test_create_basic_wd_bad
#     assert (object = BasicDefaultEnumTestModel.create(:value => :bad))
#     assert object.new_record?
#   end
#
#
#
#   # Nonnull
#
#   ######################################################################
#
#   def test_create_nonnull_default
#     assert (object = NonnullEnumTestModel.create)
# #    assert_equal :good, object.value,
# #      "Enum columns without explicit default, default to first value if null not allowed"
#     assert object.new_record?
#   end
#
#   def test_create_nonnull_good
#     assert (object = NonnullEnumTestModel.create(:value => :good))
#     assert_equal :good, object.value
#     assert !object.new_record?
#     assert (object = NonnullEnumTestModel.create(:value => :working))
#     assert_equal :working, object.value
#     assert !object.new_record?
#   end
#
#   def test_create_nonnull_null
#     assert (object = NonnullEnumTestModel.create(:value => nil))
#     assert object.new_record?
#   end
#
#   def test_create_nonnull_bad
#     assert (object = NonnullEnumTestModel.create(:value => :bad))
#     assert object.new_record?
#   end
#
#   # Nonnull w/ Default
#
#   ######################################################################
#
#   def test_create_nonnull_wd_default
#     assert (object = NonnullDefaultEnumTestModel.create)
#     assert_equal :working, object.value
#     assert !object.new_record?
#   end
#
#   def test_create_nonnull_wd_good
#     assert (object = NonnullDefaultEnumTestModel.create(:value => :good))
#     assert_equal :good, object.value
#     assert !object.new_record?
#     assert (object = NonnullDefaultEnumTestModel.create(:value => :working))
#     assert_equal :working, object.value
#     assert !object.new_record?
#   end
#
#   def test_create_nonnull_wd_null
#     assert (object = NonnullDefaultEnumTestModel.create(:value => nil))
#     assert object.new_record?
#   end
#
#   def test_create_nonnull_wd_bad
#     assert (object = NonnullDefaultEnumTestModel.create(:value => :bad))
#     assert object.new_record?
#   end
#
#   def test_quoting
#     value = EnumerationTestModel.send(:sanitize_sql, ["value = ? ", :"'" ] )
#     assert_equal "value = '\\'' ", value
#   end
end
