module Covid
  module Utils
    extend self

    def diff(a, b)
      a.inject({}) do |acc, (k, v)|
        b_value = b[k] || 0
        a_value = v || 0

        acc[k] = { value: v, difference: a_value - b_value }
        acc
      end
    end

    def cumulative_diff(a, b, start)
      a.inject(start) do |acc, (key, value)|
        b_value = b[key] || 0
        a_value = value || 0

        acc[key] ||= {values: [a_value], differences: []}

        new_entries = {values: [b_value], differences: [b_value - a_value]}

        acc[key].merge(new_entries) { |_, old, new| old.concat(new) }
        acc
      end
    end
  end
end
