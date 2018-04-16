class HomeController < ApplicationController
  layout "homepage"
  def index
  end


  def dummy_rails_admin
    # for debuging purpose
    redirect_to root_path
  end

end
