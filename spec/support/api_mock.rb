class ApiMock

  def initialize(*args, &block)
  end

  def method_missing(method, *args, &block)
    STDOUT.puts "any_instance.should_receive(:#{method}).with(#{args.inspect[1..-2]})"
    raise
  end

  class <<self

    def method_missing(method, *args, &block)
      STDOUT.puts "should_receive(:#{method}).with(#{args.inspect[1..-2]})"
      raise
    end
  end
end

RSpec.configure do |c|
  c.before(:each) do
    stub_const("Github", ApiMock)
    stub_const("Lighthouse", ApiMock)
  end
end