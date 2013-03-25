# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# the compiled file.
#
# WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
# GO AFTER THE REQUIRES BELOW.
#
#= require jquery
#= require jquery_ujs
#= require rails.validations
#= require rails.validations.simple_form
#= require dismissible_helpers
#= require underscore
#= require markdown
#= require hamlcoffee
#= require backbone
#= require backbone/bootstrap
#= require moment
#= require img_svg
#= require jquery.countdown
#= require_tree .

$ ->
  $('.dismissible').dismissible
    success: (helper) ->
      helper.slideUp()
  
  $('form').superLabels({
    opacity:0.5,
    labelTop:12,
    labelLeft:12,
    duration:500,
    fadeDuration:250,
    autoCharLimit:true
  })
