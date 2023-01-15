require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /users" do
    it "requires authorization" do
      get users_path
      expect(response).to have_http_status(401)
    end

    let(:user)        { FactoryBot.create(:user) }
    let(:token)       { FactoryBot.create(:access_token,
                                          resource_owner_id: user.id) }

    it "returns users" do
      get users_path, params: {}, headers: { 'Authorization': 'Bearer ' + token.token }
      expect(response).to have_http_status(200)
      body = JSON.parse(response.body)
      expect(body.length).to eq(1)
    end
  end
end
