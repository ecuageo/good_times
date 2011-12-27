class QueryResult
  include Enumerable

  attr_reader :total_rows, :offset, :rows

  def initialize(results)
    results.each do |key, value|
      instance_variable_set("@#{key.to_s}", value)
    end
  end

  def each(&block)
    @rows.each {|row| block.call(row)}
  end
end
