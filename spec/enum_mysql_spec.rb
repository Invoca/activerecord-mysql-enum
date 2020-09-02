# frozen_string_literal: true

require 'fixtures/enumeration_test_model'
# require 'fixtures/enum_test_controller'

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

  it 'test_other_types' do
    row = EnumerationTestModel.new
    row.string_field = 'a' * 10
    expect(row.save).to be false
    expect(row.errors['string_field']).to eq(['is too long (maximum is 8 characters)'])

    row = EnumerationTestModel.new
    expect(row.save).to be false
    expect(row.errors['string_field']).to eq(['can\'t be blank'])

    row = EnumerationTestModel.new
    row.string_field = 'test'
    row.int_field = 'aaaa'
    expect(row.save).to be false
    expect(row.errors['int_field']).to eq(['is not a number'])

    row = EnumerationTestModel.new
    row.string_field = 'test'
    row.int_field = '500'
    expect(row.save).to be true
  end

  # it 'test_view_helper' do
  #   request  = ActionController::TestRequest.new
  #   response = ActionController::TestResponse.new
  #   request.action = 'test1'
  #   body = EnumTestController.process(request, response).body
  #   expect(body).to eq('<select id="test_severity" name="test[severity]"><option value="low">low</option><option value="medium" selected="selected">medium</option><option value="high">high</option><option value="critical">critical</option></select>')
  # end
  #
  # it 'test_radio_helper' do
  #   request  = ActionController::TestRequest.new
  #   response = ActionController::TestResponse.new
  #   request.action = 'test2'
  #   body = EnumTestController.process(request, response).body
  #   expect(body).to eq('<label>low: <input id="test_severity_low" name="test[severity]" type="radio" value="low" /></label><label>medium: <input checked="checked" id="test_severity_medium" name="test[severity]" type="radio" value="medium" /></label><label>high: <input id="test_severity_high" name="test[severity]" type="radio" value="high" /></label><label>critical: <input id="test_severity_critical" name="test[severity]" type="radio" value="critical" /></label>')
  # end


  # Basic tests
  it 'test_create_basic_default' do
    object = BasicEnumTestModel.create
    expect(object).to be_truthy
    expect(object.value).to be_nil
    expect(object.new_record?).to be false
  end

  it 'test_create_basic_good' do
    object = BasicEnumTestModel.create(:value => :good)
    expect(object).to be_truthy
    expect(object.value).to eq(:good)
    expect(object.new_record?).to be false
    
    object = BasicEnumTestModel.create(:value => :working)
    expect(object).to be_truthy
    expect(object.value).to eq(:working)
    expect(object.new_record?).to be false
  end

  it 'test_create_basic_null' do
    object = BasicEnumTestModel.create(:value => nil)
    expect(object).to be_truthy
    expect(object.value).to be_nil
    expect(object.new_record?).to be false
  end

  it 'test_create_basic_bad' do
    object = BasicEnumTestModel.create(:value => :bad)
    expect(object).to be_truthy
    expect(object.new_record?).to be true
  end

  # Basic w/ Default

  ######################################################################

  it 'test_create_basic_wd_default' do
    object = BasicDefaultEnumTestModel.create
		expect(object).to be_truthy
    expect(object.value).to eq(:working)
    expect(object.new_record?).to be false
  end

  it 'test_create_basic_wd_good' do
    object = BasicDefaultEnumTestModel.create(:value => :good)
		expect(object).to be_truthy
    expect(object.value).to eq(:good)
    expect(object.new_record?).to be false
    
    object = BasicDefaultEnumTestModel.create(:value => :working)
		expect(object).to be_truthy
    expect(object.value).to eq(:working)
    expect(object.new_record?).to be false
  end

  it 'test_create_basic_wd_null' do
    object = BasicDefaultEnumTestModel.create(:value => nil)
		expect(object).to be_truthy
    expect(object.value).to be nil
    expect(object.new_record?).to be false
  end

  it 'test_create_basic_wd_bad' do
    object = BasicDefaultEnumTestModel.create(:value => :bad)
		expect(object).to be_truthy
    expect(object.new_record?).to be true
  end



  # Nonnull

  ######################################################################

  it 'test_create_nonnull_default' do
    object = NonnullEnumTestModel.create
		expect(object).to be_truthy
    expect(object.value).to be nil # Enum columns without explicit value don't default to first value if null not allowed
    expect(object.new_record?).to be true
  end

  it 'test_create_nonnull_good' do
    object = NonnullEnumTestModel.create(:value => :good)
		expect(object).to be_truthy
    expect(object.value).to eq(:good)
    expect(object.new_record?).to be false

    object = NonnullEnumTestModel.create(:value => :working)
		expect(object).to be_truthy
    expect(object.value).to eq(:working)
    expect(object.new_record?).to be false
  end

  it 'test_create_nonnull_null' do
    object = NonnullEnumTestModel.create(:value => nil)
		expect(object).to be_truthy
    expect(object.new_record?).to be true
  end

  it 'test_create_nonnull_bad' do
    object = NonnullEnumTestModel.create(:value => :bad)
		expect(object).to be_truthy
    expect(object.new_record?).to be true
  end

  # Nonnull w/ Default

  ######################################################################

  it 'test_create_nonnull_wd_default' do
    object = NonnullDefaultEnumTestModel.create
		expect(object).to be_truthy
    expect(object.value).to eq(:working)
    expect(object.new_record?).to be false
  end

  it 'test_create_nonnull_wd_good' do
    object = NonnullDefaultEnumTestModel.create(:value => :good)
		expect(object).to be_truthy
    expect(object.value).to eq(:good)
    expect(object.new_record?).to be false

    object = NonnullDefaultEnumTestModel.create(:value => :working)
		expect(object).to be_truthy
    expect(object.value).to eq(:working)
    expect(object.new_record?).to be false
  end

  it 'test_create_nonnull_wd_null' do
    object = NonnullDefaultEnumTestModel.create(:value => nil)
		expect(object).to be_truthy
    expect(object.new_record?).to be true
  end

  it 'test_create_nonnull_wd_bad' do
    object = NonnullDefaultEnumTestModel.create(:value => :bad)
		expect(object).to be_truthy
    expect(object.new_record?).to be true
  end

  it 'test_quoting' do
    value = EnumerationTestModel.send(:sanitize_sql, ["value = ? ", :"'" ] )
    expect(value).to eq("value = '\\'' ")
  end
end
