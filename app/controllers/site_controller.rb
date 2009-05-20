class SiteController < ApplicationController

  def index
    @title = "Welcome to Tangkilikan!"
  end

  def about
    @title = "About Tangkilikan"
  end

  def help
    @title = "Tangkilikan Help!"
  end
end
