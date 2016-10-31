module ControllerMacros
  def login_admin
    before(:each) do
      @user = FactoryGirl.create(:user, admin: true)
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      @request.headers.merge! @user.create_new_auth_token
      sign_in @user
    end
  end

  def login_user
    before(:each) do
      @user = FactoryGirl.create(:user)
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @request.headers.merge! @user.create_new_auth_token
      sign_in @user
    end
  end
end

# include login macro methods
RSpec.configure do |config|
  config.extend ControllerMacros, :type => :controller
end