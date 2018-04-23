class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update, :destroy]


  def show
  end




 # PRIVATE METHODS

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :age, :gender, :)
  end

end
