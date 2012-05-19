class AutocompleteController < ApplicationController

  def zip
    zip = Patient::Zipcode.find_by_zip(params[:zip])

    if zip
      zip = {
        :found => true,
        :zip   => zip.zip,
        :state => zip.state,
        :city  => zip.city
      }
    else
      zip = { :found => false }
    end

    respond_to do |format|
      format.json { render :json => zip.to_json }
    end
  end

  def city
    cities = Patient::Zipcode.where("city ILIKE ?", "#{params[:term]}%").
      select("DISTINCT city").map(&:city)

    respond_to do |format|
      format.json { render :json => cities.to_json }
    end
  end

  def race
    races = Patient.where("race ILIKE ?", "#{params[:term]}%").
      select("DISTINCT race").map(&:race)

    respond_to do |format|
      format.json { render :json => races.to_json }
    end
  end

  def heard_about_clinic
    heard_about_clinic = Survey.where("heard_about_clinic ILIKE ?", "#{params[:term]}%").
      select("DISTINCT heard_about_clinic").map(&:heard_about_clinic)

    respond_to do |format|
      format.json { render :json => heard_about_clinic.to_json }
    end
  end
end
