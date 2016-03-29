require 'rails_helper'

RSpec.describe VotesController, :type => :controller do
  let(:token) { SecureRandom.hex }
  let(:user) { User.create(token: token) }
  let(:movie) { Movie.create }

  before do
    session[:token] = token
    Ability.new(user)
  end

  describe "POST create" do
    it "returns http redirect" do
      expect(Movie[movie.id].liker_count.to_i).to eq(0)
      post :create, movie_id: movie.id, t: 'like'
      expect(response).to have_http_status(:redirect)
      expect(Movie[movie.id].liker_count.to_i).to eq(1)
    end
  end

  describe "DELETE destroy" do
    before do
      post :create, movie_id: movie.id, t: 'like'
    end
    it "returns http redirect" do
      delete :destroy, movie_id: movie.id
      expect(response).to have_http_status(:redirect)
      expect(Movie[movie.id].liker_count.to_i).to be(0)
    end
  end

end
