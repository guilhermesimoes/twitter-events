class PagesController < ApplicationController
  def welcome
    render :text => "Hello world!"
  end
end
