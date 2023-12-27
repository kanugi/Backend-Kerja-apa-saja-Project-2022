class Api::V1::SkillsController < ApplicationController
    def index
        @skills = params[:search] ?
                    Skill.search(params[:search]) :
                    Skill.all
        render json: @skills, status: :ok
    end

    def me
      return render json: @current_user.skills.map{ |skill| {
        id: skill.id,
        name: skill.name
      }}
    end
    
      def create
        @skill = Skill.find_or_create_by(skill_params)
        if @current_user.skills.include?(@skill)
          return render json: {message: "tidak dapat menambahkan skill yang sama"}, status: :bad_request
        end
        if Skill.assign_skill(@current_user, @skill)
          render json: {message: "Berhasil memperbarui skill pengguna"}, status: :ok
        else
          render json: {message: "gagal memperbarui skill pengguna"}, status: :bad_request
        end
      end

      def destroy
        skill = Skill.find_by_name(params[:name])
        if skill.nil?
          render json: {message: "Skill tidak ditemukan"}, status: :bad_request
        elsif SkillUser.where(skill: skill, user: @current_user).destroy_all
          render json: {message: "Berhasil menghapus skill pengguna"}, status: :ok
        else
          render json: {message: "Gagal menghapus skill pengguna"}, status: :bad_request
        end
      end

      def skill_params
        params.require(:skill).permit(:name)
      end
end
