require 'rails_helper'

RSpec.describe SearchService, type: :unit do
  before do
    @submitter =  FactoryGirl.build(:user).save
    @movie = FactoryGirl.build(:movie, user: @submitter).save
    @movie.update_attributes({liker_count: "5", hater_count: "3"})
    @movie.save
    @another_movie =  FactoryGirl.build(:movie).save
    @another_movie.update_attributes({ liker_count: "3", hater_count: "7"})
    @another_movie.save
  end

  describe "#scope" do
    it "returns all movies submitted by user if user_id params present" do
      search_service = SearchService.new({user_id: @submitter.id, type: 'haters'})
      expect(search_service.scope.count).to eq(1)
    end

    it "returns all movies if user_id params is not present" do
      search_service = SearchService.new
      expect(search_service.scope.count).to eq(2)
    end
  end

  describe "#movies" do

    it "returns movies ordered by like in DESC order by default" do
      expect(SearchService.new.movies).to eq([@movie, @another_movie])
    end

    it "returns movies ordered by like in DESC order if search by like" do
      expect(SearchService.new({by: 'likers'}).movies).to eq([@movie, @another_movie])
    end

    it 'returns movies ordered by hate in DESC order if search by hate' do
      expect(SearchService.new({by: 'haters'}).movies).to eq([@another_movie, @movie])
    end

    it 'returns movies ordered by date in DESC order if search by date' do
      expect(SearchService.new({by: 'date'}).movies).to eq([@another_movie, @movie])
    end
  end
end
