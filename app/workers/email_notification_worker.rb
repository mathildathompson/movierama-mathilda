# This does some
class EmailNotificationWorker
  include Sidekiq::Worker

  def perform(user_id, movie_id)
    UserMailer.notification_email(user_id, movie_id).deliver
  rescue => e
    handle_error(e)
  end

  private

  def handle_error(error)
    Airbrake.notify(error)
  end
end
