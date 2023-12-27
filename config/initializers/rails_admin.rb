require Rails.root.join('lib', 'rails_admin_verify_transaction.rb')

RailsAdmin.config do |config|
  config.asset_source = :sprockets

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == CancanCan ==
  # config.authorize_with :cancancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/railsadminteam/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit do
      except ['Transaction']
    end
    delete
    show_in_app
    verify_transaction do
      only ['Transaction']
      title 'Verify'
    end

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.authorize_with do
    authenticate_or_request_with_http_basic('Login required') do |username, password|
      username == ENV["ADMIN_USERNAME"] && password == ENV["ADMIN_PASSWORD"]
    end
  end

  config.model 'ActiveStorage::Attachment' do
    visible false
  end

  config.model 'ActiveStorage::Blob' do
    visible false
  end

  config.model 'ActiveStorage::VariantRecord' do
    visible false
  end

  config.model 'Province' do
    visible false
  end

  config.model 'Regency' do
    visible false
  end

  config.model 'District' do
    visible false
  end

  class RailsAdmin::Config::Fields::Types::Point < RailsAdmin::Config::Fields::Base
    RailsAdmin::Config::Fields::Types::register(self)
  end

  module RailsAdmin
    module Config
      module Actions
        class VerifyTransaction < RailsAdmin::Config::Actions::Base
          RailsAdmin::Config::Actions.register(self)
        end
      end
    end
  end

end
