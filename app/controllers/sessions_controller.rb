class SessionsController < ApplicationController
	def new

	end

	def create
		user = User.find_by(email: params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
			session[:user_id] = user.id
			flash[:success] = "Successfuly logged in"
			redirect_to user_path(user)
		else
			flash.now[:danger] = "There was something wrong with your email or password"
			render "new", status: :unprocessable_entity
		end
	end

	def destroy
		session[:user_id] = nil
		flash[:success] = "You have logged out"
		redirect_to root_path
	end

end