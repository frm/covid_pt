module Covid
  module Printer
    extend self

    def pp(report)
      sorted_municipalities =
        report[:regional].
        sort_alphabetical_by(&:first).
        map { |m| "#{m.first}: #{m.last}" }.
        join("\n")

      <<~TXT
      ###############################################
      #                                             #
      ### Relatório de Situação Nacional COVID-19 ###
      #                                             #
      ###############################################

      Data: #{report[:date]}

      ### Situação Nacional

      Total de casos suspeitos: #{report[:overall][:total_suspect_cases]}
      Total de casos confirmados: #{report[:overall][:total_confirmed_cases]}
      Total de casos não confirmados: #{report[:overall][:total_unconfirmed_cases]}
      Aguardam resultado laboratorial: #{report[:overall][:awaiting_lab_results]}
      Casos recuperados: #{report[:overall][:total_recovered_cases]}
      Óbitos: #{report[:overall][:total_deaths]}
      Total sob vigília: #{report[:overall][:total_under_suspicion]}

      ### Situacao Municipal

      #{sorted_municipalities}
      TXT
    end

    def md(report)
      sorted_municipalities =
        report[:regional].
        sort_alphabetical_by(&:first).
        map { |m| "- **#{m.first}:** #{m.last}" }.
        join("\n")

      <<~MD
      # Relatório de Situação Nacional COVID-19

      Data: #{report[:date]}

      ## Situação Nacional

      - **Total de casos suspeitos:** #{report[:overall][:total_suspect_cases]}
      - **Total de casos confirmados:** #{report[:overall][:total_confirmed_cases]}
      - **Total de casos não confirmados:** #{report[:overall][:total_unconfirmed_cases]}
      - **Aguardam resultado laboratorial:** #{report[:overall][:awaiting_lab_results]}
      - **Casos recuperados:** #{report[:overall][:total_recovered_cases]}
      - **Óbitos:** #{report[:overall][:total_deaths]}
      - **Total sob vigília:** #{report[:overall][:total_under_suspicion]}

      ## Situação Municipal

      #{sorted_municipalities}
      MD
    end
  end
end
