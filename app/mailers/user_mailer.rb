class UserMailer < ActionMailer::Base
  default from: "noreply@movierama.com"

  def notification_email(user_id, movie_id)
    @current_user = User[user_id]
    @movie = Movie[movie_id]
    @type = notification_type

    mail(to: movie_submitter_email, subject: 'Movierama notification')
  end

  private

  def movie_submitter_email
    @movie.user.email
  end

  def notification_type
    (@movie.likers.include? @current_user) ? 'likes' : 'hates'
  end
end
