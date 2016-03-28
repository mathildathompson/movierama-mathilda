require 'sidekiq/testing'
require 'rails_helper'

RSpec.describe "User Mailer", type: :unit do
  before do
    @current_user =  FactoryGirl.build(:user).save
    @user = FactoryGirl.build(:user).save
    @movie = FactoryGirl.build(:movie, user: @user).save
    @movie.likers.add(@current_user)
    @movie.save
    @movie.likers.add(@current_user)
  end

  let(:mail) { UserMailer.notification_email(@current_user.id, @movie.id) }

  it 'renders the subject' do
    expect(mail.subject).to eql('Movierama notification')
  end

  it 'renders the receiver email' do
    expect(mail.to).to eql([@user.email])
  end

  it 'renders the sender email' do
    expect(mail.from).to eql(['noreply@movierama.com'])
  end

  it 'assigns @type' do
    expect(mail.body.encoded).to match('likes')
  end

  it 'assigns @current_user name' do
    expect(mail.body.encoded).to match(@current_user.name)
  end

  it 'assigns @movie title'do
    expect(mail.body.encoded).to match(@movie.title)
  end

end
