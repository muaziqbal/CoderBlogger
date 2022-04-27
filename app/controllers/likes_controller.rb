class LikesController < ApplicationController
  before_action :require_login, only: :create

  def create
    @likeable = find_likeable
    @likeable.likes.create(user: current_user) unless current_user.likes?(@likeable)
    @likeable.try(:subscribe!, current_user)
    respond_to do |format|
      format.json { render(json: @likeable.likes_count, status: :ok) }
    end
  end

  protected
  def find_likeable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        klass = $1.classify.constantize
        if klass == Protip
          return klass.find_by_public_id!(value)
        else
          return klass.find(value)
        end
      end
    end
  end
end
