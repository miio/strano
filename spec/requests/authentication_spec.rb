require 'spec_helper'

describe "Authentication" do

  context "on successful sign in" do
    use_vcr_cassette
    
    before(:each) do
      Github.oauth_token = 'b25b94f3a2f36b79903259c36e79b3ed5acfca9e'
      OmniAuth.config.mock_auth[:github] = { :credentials => { :token => "65r6w5er1w6er5w65ef1" },
                                             :extra => {
                                               :raw_info => {
                                                 :email => "test@test.com" } } }
    end
    
    it "should create a new User record" do
      get "/users/auth/github"
      follow_redirect!
      User.should have(1).record
    end

    context "when user record already exists" do
      it "should use the existing record" do
        user = FactoryGirl.create(:user)
        OmniAuth.config.mock_auth[:github][:extra][:raw_info][:email] = user.email
    
        get "/users/auth/github"
        follow_redirect!
        User.should have(1).record
      end
    end
  end

  context "on unsuccessful sign in" do
    it "does something" do
      OmniAuth.config.mock_auth[:github] = :invalid_credentials
  
      get "/users/auth/github"
      follow_redirect!
      response.should redirect_to('/sign_in')
    end
  end

end
