class SearchService
  attr_reader :by
  def initialize(params={})
    @submitter = User[params[:user_id]]
    @by = params.fetch(:by, 'likers')
  end

  def scope
    @scope ||= @submitter.present? ? Movie.find(user_id: @submitter.id) : Movie.all
  end

  def movies
    {
      'likers' => scope.sort(by: 'Movie:*->liker_count', order: 'DESC'),
      'haters' => scope.sort(by: 'Movie:*->hater_count', order: 'DESC'),
      'date'   => scope.sort(by: 'Movie:*->created_at',  order: 'DESC')
    }[by]
  end
end
