class HomeController < ApplicationController
  def index
  end

  # def dashboard
  # end
  def dummy_rails_admin
    # for debuging purpose
    redirect_to root_path
  end

end
