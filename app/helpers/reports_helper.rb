module ReportsHelper

  def time_spans
    Reports::ClinicSummary::TIME_SPANS
  end

  def readable_days(number_of_days)
    number_of_days ||= 0

    distance_of_time_in_words_to_now number_of_days.to_i.days.ago
  end

  def days(report)
    existing_dates = Patient.all(
      :select => "patients.created_at::Date as created_at_date",
      :group => "patients.created_at::Date",
      :order => "patients.created_at::Date"
    ).map {|p| p.created_at_date.to_date }

    ["All", *existing_dates]
  end

  def patients_by_county(county)
    conditions = "patients.state = ? AND patient_zipcodes.county "

    if county["county"].blank?
      county["county"] = nil
      conditions << "IS ?"
    else
      conditions << "= ?"
    end

    Patient.all(
      :select => "patients.id",
      :include => [:zipcode],
      :conditions => [conditions, county["state"], county["county"]]
    ).map(&:id)
  end

  def county_filename(county)
    [county["state"], county["county"]].compact.join("_")
  end

  def percent_of_clinic(number_of_patients, total)
    percent = (number_of_patients.to_f / total.to_f) * 100.0
    sprintf('%.2f', percent)
  end

  def bar_graph(name, data_series={}, div_options={}, graph_options={})
    output = ""

    data = data_series.each.with_object([]) do |(key, value), result|
      result << {
        label: key,
        data: bar_graph_data(value.map {|v| v[1] })
      }
    end

    div_options.merge!({ :id => name })
    output << content_tag(:div, "", div_options)
    output << javascript_tag do
      %{
        $(function(){
          var placeholder = jQuery('\##{ name }');
          var data = #{ data.to_json };
          var options = #{ bar_graph_options(data_series.first[1]) };
          var plot = jQuery.plot(placeholder, data, options);
        });
      }.html_safe
    end

    output.html_safe
  end

  def bar_graph_data(original_data)
    original_data.each_with_index.map {|s, i| [ i, s ] }
  end

  def bar_graph_options(original_data)
    {
      :valueLabels => { :show => true },
      :xaxis => {
        :min => -0.6,
        :max => original_data.length - 0.4,
        :ticks => original_data.each_with_index.map {|data, i| [i, data[0]] }
      },
      :yaxis => { :minTickSize => 1, :tickDecimals => 0 },
      :grid => { :tickColor => "#ffffff" },
      series: {
        bars: {
          show: true,
          barWidth: 0.6,
          align: "center"
        },
        stack: true
      }
    }.to_json
  end

end
