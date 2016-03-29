require 'rails_helper'

RSpec.describe MoviesController, :type => :controller do
  let(:token) { SecureRandom.hex }
  let(:user) { User.create(token: token) }

  before do
    session[:token] = token
    Ability.new(user)
  end

  describe "GET index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST create" do
    it "returns http redirect" do
      post :create, {title: 'test', description: 'test description', date: '1988-11-11'}
      expect(response).to have_http_status(:redirect)
      expect(Movie.all.count.to_i).to eq(1)
    end
  end

end
