require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdmin
  module Config
    module Actions
      class VerifyTransaction < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :visible? do
          authorized?
        end

        register_instance_option :member do
          true
        end

        register_instance_option :link_icon do
          'fas fa-check'
        end

        register_instance_option :title do
          'Verify'
        end

        register_instance_option :controller do
          Proc.new do
            @object.update_attribute(:is_verified, true)
            if @object.transaction_type == 'top_up'
              @user = User.find_by_id(@object.receiver_id)
            else
              @user = User.find_by_id(@object.sender_id)
            end
            Notification.create(
              user: @user,
              category: 'transaksi',
              title: "Transaksi telah diverifikasi",
              description: "Transaksi #{@object.name} anda telah diverifikasi"
            )
            redirect_to back_or_index
          end
        end
      end
    end
  end
end
