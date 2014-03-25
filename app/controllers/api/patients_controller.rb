class Api::PatientsController < ApiController
  before_filter :find_patient

  def chart
    pdf = PatientChart.new(@patient)
    send_data pdf.render, filename: "chart_#{@patient.id}.pdf",
                          type: "application/pdf",
                          disposition: "inline"
  end

  def update
    @patient.update_attributes(params.require(:patient).permit(:chart_printed))

    render text: "Patient Updated"
  end

  private

  def find_patient
    @patient = Patient.find(params[:id])
  end
end
