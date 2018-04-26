class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def show
  end
  #user likes history, trying


  def edit
  end

  def update
    @user.update(user_params)
    redirect_to user_path
  end

  def destroy
    @user.destroy
    redirect_to new_user_registration_path
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :age, :gender, :radius_search)
  end
end

