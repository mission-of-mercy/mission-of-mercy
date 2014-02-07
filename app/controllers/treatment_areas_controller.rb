class TreatmentAreasController < CheckoutController
  before_filter :authenticate_user!

  # TODO Clean this up
  def change
    destination = request.referer.
      gsub(/treatment_areas\/\d+/,
           "treatment_areas/#{params[:treatment_area_id]}")

    redirect_to destination
  end
end
