class Api::V1::CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :update, :destroy, :add_member, :remove_member, :update_member_role]

  # GET /companies
  def index
    @companies = Company.all

    render json: @companies
  end

  # GET /companies/1
  def show
    render json: @company.new_attribute
  end

  # POST /companies
  def create
    @company = Company.new(company_params)
    @company_user = CompanyUser.new(user_id: @current_user.id, role: "owner")
    @company.company_users << @company_user

    if @company.save
      render json: @company.new_attribute, status: :created
    else
      render json: @company.errors.full_messages, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /companies/1
  def update
    if @company.update(company_params)
      render json: @company.new_attribute
    else
      render json: @company.errors, status: :unprocessable_entity
    end
  end

  def add_member
    if @company.add_member(params)
      render json: {message: "Berhasil menambahkan anggota"}, status: :ok
    else
      render json: {message: "Gagal menambahkan anggota"}, status: :bad_request
    end
  end

  def remove_member
    if @company.remove_member(params)
      render json: {message: "Berhasil menghapus anggota"}, status: :ok
    else
      render json: {message: "Gagal menghapus anggota"}, status: :bad_request
    end
  end

  def update_member_role
    if @company.update_member_role(params)
      render json: {message: "Berhasil mengubah role anggota"}, status: :ok
    else
      render json: {message: "Gagal mengubah role anggota"}, status: :bad_request
    end
  end

  # DELETE /companies/1
  def destroy
    @company.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = params[:id].present? ? Company.find(params[:id]) : Company.find_by(name: params[:name])
      if @company.nil?
        return render json: {message: "Company not found"}, status: :not_found
      end
    end

    # Only allow a trusted parameter "white list" through.
    def company_params
      {
        name: params[:name],
        photo_profile: params[:photo_profile],
        category_id: params[:category_id],
        phone_number: params[:phone_number],
        address: params[:address],
        total_employer: params[:total_employer],
        description: params[:description]
      }
    end
end
