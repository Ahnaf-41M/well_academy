require 'rails_helper'

RSpec.describe "Payments", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/payments/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/payments/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/payments/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/payments/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/payments/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
