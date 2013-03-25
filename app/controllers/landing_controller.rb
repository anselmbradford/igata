class LandingController < ApplicationController
  def show
    @templates = Template.all
  end
end
