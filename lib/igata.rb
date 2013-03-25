module Igata
  Months = lambda do
    months = %w{January February March April May June July August September October November December}
    @months = months.map do |month|
      [month, months.index(month) + 1]
    end
  end.call

  Years = lambda do
    current_year = DateTime.current.year
    @years = current_year..current_year + 10
  end.call
end
