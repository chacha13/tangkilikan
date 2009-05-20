# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  # Return a link for use in layout navigation.
require 'string'

  # Return a link for use in site navigation.
def nav_link(text, controller, action="index")
    link_to_unless_current text, :id => nil,
                                 :action => action,
                                 :controller => controller
end 
# Return true if some user is logged in, false otherwise.
  def logged_in?
    not session[:user_id].nil?
  end
  
  def text_field_for(form, field,
        size=HTML_TEXT_FIELD_SIZE,
        maxlength=DB_STRING_MAX_LENGTH)
    label = content_tag("label", "#{field.humanize}:", :for => field)
    form_field = form.text_field field, :size => size, :maxlength => maxlength
    content_tag("div", "#{label} #{form_field}", :class => "form_row")
  end
  # Return true if results should be paginated.
def paginated?
@pages and @pages.length > 1
end
end
