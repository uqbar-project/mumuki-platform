class UsersController < ApplicationController
  before_action :set_user, only: :show

  def show
  end

  def index
    @q = params[:q]
    @users = paginated User.by_full_text(@q)
  end
  private

  def set_user
    @user = User.find(params[:id])
  end
end
