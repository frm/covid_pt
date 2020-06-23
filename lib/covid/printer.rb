module Covid
  module Printer
    extend self

    def pp(report)
      case report[:type]
      when "report"
        pp_report(report)
      when "comparison"
        pp_comparison(report)
      when "range"
        "Not implemented yed"
      else
        "Error: unknown report type"
      end
    end

    def md(report)
      case report[:type]
      when "report"
        md_report(report)
      when "comparison"
        md_comparison(report)
      when "range"
        "Not implemented yed"
      else
        "Error: unknown report type"
      end
    end

    private

    def pp_report(report)
      sorted_municipalities =
        report[:regional].
        sort_alphabetical_by(&:first).
        map { |m| "#{m.first}: #{m.last}" }.
        join("\n")

      overall = report[:overall]

      <<~TXT
      ###############################################
      #                                             #
      ### Relatório de Situação Nacional COVID-19 ###
      #                                             #
      ###############################################

      Data: #{report[:date]}

      ### Situação Nacional

      Total de casos suspeitos: #{overall[:total_suspect_cases]}
      Total de casos confirmados: #{overall[:total_confirmed_cases]}
      Total de casos não confirmados: #{overall[:total_unconfirmed_cases]}
      Aguardam resultado laboratorial: #{overall[:awaiting_lab_results]}
      Casos recuperados: #{overall[:total_recovered_cases]}
      Óbitos: #{overall[:total_deaths]}
      Total sob vigília: #{overall[:total_under_suspicion]}

      ### Situação Regional

      Total de Casos ARS Norte: #{overall[:cases_in_north]}
      Total de Casos ARS Centro: #{overall[:cases_in_centre]}
      Total de Casos ARS LVT: #{overall[:cases_in_lisbon]}
      Total de Casos ARS Alentejo: #{overall[:cases_in_alentejo]}
      Total de Casos ARS Algarve: #{overall[:cases_in_algarve]}
      Total de Casos ARS Açores: #{overall[:cases_in_azores]}
      Total de Casos ARS Madeira: #{overall[:cases_in_madeira]}

      Total de Óbitos ARS Norte: #{overall[:deaths_in_north]}
      Total de Óbitos ARS Centro: #{overall[:deaths_in_centre]}
      Total de Óbitos ARS LVT: #{overall[:deaths_in_lisbon]}
      Total de Óbitos ARS Alentejo: #{overall[:deaths_in_alentejo]}
      Total de Óbitos ARS Algarve: #{overall[:deaths_in_algarve]}
      Total de Óbitos ARS Açores: #{overall[:deaths_in_azores]}
      Total de Óbitos ARS Madeira: #{overall[:deaths_in_madeira]}

      ### Situação Municipal

      #{sorted_municipalities}
      TXT
    end

    def pp_comparison(report)
      sorted_municipalities =
        report[:regional].
        sort_alphabetical_by(&:first).
        map { |m| "#{m.first}: #{variation_to_string(m.last)}" }.
        join("\n")

      overall = report[:overall]
      regional = report[:regional]

      <<~TXT
      ###############################################
      #                                             #
      ### Relatório de Situação Nacional COVID-19 ###
      #                                             #
      ###############################################

      Data: #{report[:dates][:from]} - #{report[:dates][:to]}

      ### Situação Nacional

      Total de casos suspeitos: #{variation_to_string(overall[:total_suspect_cases])}
      Total de casos confirmados: #{variation_to_string(overall[:total_confirmed_cases])}
      Total de casos não confirmados: #{variation_to_string(overall[:total_unconfirmed_cases])}
      Aguardam resultado laboratorial: #{variation_to_string(overall[:awaiting_lab_results])}
      Casos recuperados: #{variation_to_string(overall[:total_recovered_cases])}
      Óbitos: #{variation_to_string(overall[:total_deaths])}
      Total sob vigília: #{variation_to_string(overall[:total_under_suspicion])}

      ### Situação Regional

      Total de Casos ARS Norte: #{variation_to_string(overall[:cases_in_north])}
      Total de Casos ARS Centro: #{variation_to_string(overall[:cases_in_centre])}
      Total de Casos ARS LVT: #{variation_to_string(overall[:cases_in_lisbon])}
      Total de Casos ARS Alentejo: #{variation_to_string(overall[:cases_in_alentejo])}
      Total de Casos ARS Algarve: #{variation_to_string(overall[:cases_in_algarve])}
      Total de Casos ARS Açores: #{variation_to_string(overall[:cases_in_azores])}
      Total de Casos ARS Madeira: #{variation_to_string(overall[:cases_in_madeira])}

      Total de Óbitos ARS Norte: #{variation_to_string(overall[:deaths_in_north])}
      Total de Óbitos ARS Centro: #{variation_to_string(overall[:deaths_in_centre])}
      Total de Óbitos ARS LVT: #{variation_to_string(overall[:deaths_in_lisbon])}
      Total de Óbitos ARS Alentejo: #{variation_to_string(overall[:deaths_in_alentejo])}
      Total de Óbitos ARS Algarve: #{variation_to_string(overall[:deaths_in_algarve])}
      Total de Óbitos ARS Açores: #{variation_to_string(overall[:deaths_in_azores])}
      Total de Óbitos ARS Madeira: #{variation_to_string(overall[:deaths_in_madeira])}

      ### Situacao Municipal

      #{sorted_municipalities}
      TXT
    end

    def md_report(report)
      sorted_municipalities =
        report[:regional].
        sort_alphabetical_by(&:first).
        map { |m| "- **#{m.first}:** #{variation_to_string(m.last)}" }.
        join("\n")

      <<~MD
      # Relatório de Situação Nacional COVID-19

      Data: #{report[:date]}

      ## Situação Nacional

      - **Total de casos suspeitos:** #{variation_to_string(report[:overall][:total_suspect_cases])}
      - **Total de casos confirmados:** #{variation_to_string(report[:overall][:total_confirmed_cases])}
      - **Total de casos não confirmados:** #{variation_to_string(report[:overall][:total_unconfirmed_cases])}
      - **Aguardam resultado laboratorial:** #{variation_to_string(report[:overall][:awaiting_lab_results])}
      - **Casos recuperados:** #{variation_to_string(report[:overall][:total_recovered_cases])}
      - **Óbitos:** #{variation_to_string(report[:overall][:total_deaths])}
      - **Total sob vigília:** #{variation_to_string(report[:overall][:total_under_suspicion])}

      ### Situação Regional

      - **Total de Casos ARS Norte**: #{overall[:cases_in_north]}
      - **Total de Casos ARS Centro**: #{overall[:cases_in_centre]}
      - **Total de Casos ARS LVT**: #{overall[:cases_in_lisbon]}
      - **Total de Casos ARS Alentejo**: #{overall[:cases_in_alentejo]}
      - **Total de Casos ARS Algarve**: #{overall[:cases_in_algarve]}
      - **Total de Casos ARS Açores**: #{overall[:cases_in_azores]}
      - **Total de Casos ARS Madeira**: #{overall[:cases_in_madeira]}

      - **Total de Óbitos ARS Norte**: #{overall[:deaths_in_north]}
      - **Total de Óbitos ARS Centro**: #{overall[:deaths_in_centre]}
      - **Total de Óbitos ARS LVT**: #{overall[:deaths_in_lisbon]}
      - **Total de Óbitos ARS Alentejo**: #{overall[:deaths_in_alentejo]}
      - **Total de Óbitos ARS Algarve**: #{overall[:deaths_in_algarve]}
      - **Total de Óbitos ARS Açores**: #{overall[:deaths_in_azores]}
      - **Total de Óbitos ARS Madeira**: #{overall[:deaths_in_madeira]}

      ## Situação Municipal

      #{sorted_municipalities}
      MD
    end

    def variation_to_string(variation)
      "#{variation[:value]} (#{diff_to_string(variation[:difference])})"
    end

    def diff_to_string(number)
      if number.negative?
        number.to_s
      else
        "+#{number}"
      end
    end
  end
end
