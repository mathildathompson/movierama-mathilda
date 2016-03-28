require 'sidekiq/testing'
require 'rails_helper'

RSpec.describe "Email notification worker", type: :unit do

  context "performs async jobs" do
    subject { EmailNotificationWorker }

    before do
      Sidekiq::Worker.clear_all
      Sidekiq::Testing.fake!
    end

    let(:user_id) {"1"}
    let(:movie_id) {"2"}
    let(:another_user_id) {"3"}
    let(:another_movie_id) {"3"}

    it "it should add job to the queue" do
      expect {
        subject.perform_async(user_id, movie_id)
      }.to change(subject.jobs, :size).by(1)
    end

    it "it should remove job from queue once executed" do
      subject.perform_async(user_id, movie_id)
      subject.perform_async(another_user_id, another_movie_id)

      expect(subject.jobs.size).to eq(2)
      subject.drain

      expect(subject.jobs.size).to eq(0)
    end
  end

  context "sends email notifications" do
    subject { EmailNotificationWorker.new }

    before do
      Sidekiq::Testing.inline!
    end

    let(:current_user) { FactoryGirl.build(:user).save }
    let(:user) { FactoryGirl.build(:user).save }
    let(:movie) { FactoryGirl.build(:movie, user: user).save }
    let(:invalid_user_id) { "3"}
    let(:invalid_movie_id) { "2"}

    context "with valid input" do
      it "sends email" do
        subject.perform(current_user.id, movie.id)

        delivered_email = ActionMailer::Base.deliveries.last
        expect(delivered_email.to).to include(user.email)
      end
    end

    context "with invalid user_id input" do
      it "does not send email and logs response to Airbrake" do
        expect(Airbrake).to receive(:notify)
        subject.perform(invalid_user_id, movie.id)

        delivered_emails = ActionMailer::Base.deliveries
        expect(delivered_emails).to be_empty
      end
    end

    context "with invalid movie_id input" do
      it "does not send email and logs response to Airbrake" do
        expect(Airbrake).to receive(:notify)
        subject.perform(current_user.id, invalid_movie_id)

        delivered_emails = ActionMailer::Base.deliveries
        expect(delivered_emails).to be_empty

      end
    end

    after do
      ActionMailer::Base.deliveries.clear
    end
  end
end
