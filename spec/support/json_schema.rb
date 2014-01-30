require "json_schema_spec"

RSpec.configure do |c|
  c.include JsonSchemaSpec

  def parse_body(body)
    body = JSON.parse(body, symbolize_names: true)
    change_ids(body)
  end

  def change_ids(hash_or_array)
    if hash_or_array.is_a?(Array)
      hash_or_array.each do |value|
        change_ids(value)
      end
    elsif hash_or_array.is_a?(Hash)
      hash_or_array.each do |key, value|
        if value.is_a?(Hash)
          change_ids(value)
        elsif key == :id
          hash_or_array[key] = 123
        end
      end
    end
  end
end