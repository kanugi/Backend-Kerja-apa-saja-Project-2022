class Api::V1::RegionController < ApplicationController
  skip_before_action :authenticate_request

  # Get /api/v1/region/provinces
  def provinces
    provinces = Province.all
    render json: { provinsi: provinces}, status: :ok
  end

  # GET /api/v1/region/regencies?province_code={province_code}
  def regencies
    if params[:province_code].nil?
      return render json: { error: 'province_code is required' }, status: :bad_request
    end
    regencies = Regency.where(province_code: params[:province_code]).
      map do |regency|
        regency.new_attribute
      end
    render json: { kota: regencies }, status: :ok
  end

  # GET /api/v1/region/districts?regency_code={regency_code}
  def districts
    if params[:regency_code].nil?
      return render json: { error: 'regency_code is required' }, status: :bad_request
    end
    districts = District.where(regency_code: params[:regency_code]).
      map do |district|
        district.new_attribute
    end
    render json: { kecamatan: districts }, status: :ok
  end
end
