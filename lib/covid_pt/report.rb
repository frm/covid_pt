require "rest-client"
require "pdf-reader"
require "nokogiri"

module CovidPT
  class Report
    MUNICIPALITY_EDGE_CASES = {
      "Monsaraz" => "Reguengos de Monsaraz",
      "Graciosa" => "Santa Cruz da Graciosa",
      "Penaguião" => "Santa Marta de Penaguião",
      "António" => "Vila Real de Santo António",
    }.freeze

    def initialize(date)
      @date = Date.parse(date)
    rescue ArgumentError => e
      puts e.message
      puts "Argument: #{date}"
    end

    def generate
      return @report if @report

      @report = {
        overall: overall_report,
        regional: regional_report,
        date: @date
      }

      cleanup

      @report
    end

    private

    attr_reader :date, :pdf

    def overall_report
      numbers_in_pdf = first_page.text.scan(/\d+/)

      # numbers_in_pdf[0] is the 19 from COVID-19
      # numbers_in_pdf[9] is the 1 from "1 de janeiro 2020"
      # numbers_in_pdf[11] is the 2020 from "1 de janeiro 2020"
      {
        cases_in_north: numbers_in_pdf[1].to_i,
        deaths_in_north: numbers_in_pdf[2].to_i,
        cases_in_azores: numbers_in_pdf[3].to_i,
        deaths_in_azores: numbers_in_pdf[4].to_i,
        cases_in_centre: numbers_in_pdf[5].to_i,
        deaths_in_centre: numbers_in_pdf[6].to_i,
        cases_in_madeira: numbers_in_pdf[7].to_i,
        deaths_in_madeira: numbers_in_pdf[8].to_i,
        total_suspect_cases: numbers_in_pdf[10].to_i,
        cases_in_lisbon: numbers_in_pdf[12].to_i,
        deaths_in_lisbon: numbers_in_pdf[13].to_i,
        total_confirmed_cases: numbers_in_pdf[14].to_i,
        total_unconfirmed_cases: numbers_in_pdf[15].to_i,
        cases_in_alentejo: numbers_in_pdf[16].to_i,
        deaths_in_alentejo: numbers_in_pdf[17].to_i,
        awaiting_lab_results: numbers_in_pdf[18].to_i,
        cases_in_algarve: numbers_in_pdf[19].to_i,
        deaths_in_algarve: numbers_in_pdf[20].to_i,
        total_recovered_cases: numbers_in_pdf[21].to_i,
        total_deaths: numbers_in_pdf[22].to_i,
        total_under_suspicion: numbers_in_pdf[23].to_i,
      }
    end

    def regional_report
      municipalities =
        third_page.
          text.
          sub(/\A.+(Abrantes)/m, "\\1").
          sub(/(Vouzela\s+\d+).*\z/m, "\\1").
          gsub(/(\d)\s+/, "\\1\n").
          gsub(/\*/, "").
          split("\n").
          map { |s| s.split(/\s{2,}/).reject(&:empty?) }.
          reject { |m| m.length < 2 }.
          map { |m| m.last(2) }.
          map { |m| [m.first, m.last.to_i] }.
          to_h

      handle_municipality_edge_cases(municipalities)
    end

    def handle_municipality_edge_cases(municipalities)
      MUNICIPALITY_EDGE_CASES.map do |k, v|
        municipalities[v] = municipalities.delete(k)
      end

      municipalities
    end

    def first_page
      pdf.pages.first
    end

    def third_page
      pdf.pages[2]
    end

    def pdf
      @_pdf ||= PDF::Reader.new(download_pdf)
    end

    def download_pdf
      response = RestClient.get(pdf_url)

      File.write(filename, response.body)

      filename
    end

    def filename
      formatted_date = date.strftime("%Y%m%d")

      "#{day_identifier}_DGS_boletim_#{formatted_date}.pdf"
    end

    def pdf_url
      return @_pdf_url if @_pdf_url

      response = RestClient.get("https://covid19.min-saude.pt/relatorio-de-situacao/")
      doc = Nokogiri::HTML(response.body)

      li = doc.css("#content_easy > div.single_content > ul", "li").children.select do |li|
        li.content.match(/#{@date.strftime("%d/%m/%Y")}/)
      end.first

      @_pdf_url = li.css("a").first.attr("href")
    end


    # Calculate the numerical identifier of the report
    # based on the 01/06/2020 report, which was #91
    def day_identifier
      day_baseline = Date.parse("2020-06-01")
      number_baseline = 91

      baseline_shift = date.mjd - day_baseline.mjd

      number_baseline + baseline_shift
    end

    def cleanup
      File.delete(filename)
    end
  end
end
