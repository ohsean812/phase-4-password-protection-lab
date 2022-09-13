class UsersController < ApplicationController

    before_action :authorize, only: [:show]

    def create
        # create a new user
        # save their hashed password in the database
        user = User.create(user_params)
        # save the user's ID in the session hash
        if user.valid?
            session[:user_id] = user.id
        # return the user object in the JSON response
            render json: user, status: :created
        else
            render json: { error: user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def show
        # if the user is authenticated, return the user object in the JSON response
        user = User.find_by(id: session[:user_id])
        render json: user
    end


    private

    def user_params
        params.permit(:username, :password, :password_confirmation)
    end

    def authorize
        return render json: { error: "Not authorized" }, status: :unauthorized unless session.include? :user_id
    end

end
