class DatetimeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    begin
      DateTime.parse(value)
    rescue
      record.errors.add(attribute, :invalid)
    end
  end
end
