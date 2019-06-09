class WelcomeController < ApplicationController

  def index
    #flash[:notice] = "Good morning! : )"
    #flash[:alert] = "Time to go bed. zZ "
    flash[:warning] = "This is a warning message! "
  end

end
