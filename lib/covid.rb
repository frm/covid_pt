require_relative "covid/report"
require_relative "covid/utils"
require_relative "covid/printer"
require "sort_alphabetical"

module Covid
  extend self

  def at(date)
    Covid::Report.new(date).generate.merge({type: "report"})
  end

  def compare(from:, to:)
    report_1 = Covid::Report.new(from).generate
    report_2 = Covid::Report.new(to).generate

    {
      overall: Utils.diff(report_2[:overall], report_1[:overall]),
      regional: Utils.diff(report_2[:regional], report_1[:regional]),
      dates: {
        from: report_1[:date],
        to: report_2[:date]
      },
      type: "comparison"
    }
  end

  def range(from:, to:)
    dates = (from..to).to_a
    reports = (from..to).map { |d| Covid::Report.new(d).generate }

    i = 0
    acc = {overall: {}, regional: {}, dates: dates, type: "range"}

    while i < reports.length - 1 do
      report_1 = reports[i]
      report_2 = reports[i + 1]

      acc[:overall] = Utils.cumulative_diff(
        report_1[:overall],
        report_2[:overall],
        acc[:overall]
      )

      acc[:regional] = Utils.cumulative_diff(
        report_1[:regional],
        report_2[:regional],
        acc[:regional]
      )

      i += 1
    end

    acc
  end
end
