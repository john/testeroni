# coding: utf-8

module ApplicationHelper
  
  # for preventing unwanted whitespace when you have conditionals in text. solutions from:
  # http://stackoverflow.com/questions/1311428/haml-control-whitespace-around-text
  def one_line(&block)
    haml_concat capture_haml(&block).gsub("\n,", ',').gsub('\\n,', "\n,")
  end
  
  def profile_link(user)
    link_to(user.display_name, person_with_name_path(user.id, user.slugged_display_name))
  end
  
end
