# coding: utf-8

module ApplicationHelper

  # for preventing unwanted whitespace when you have conditionals in text. solutions from:
  # http://stackoverflow.com/questions/1311428/haml-control-whitespace-around-text
  def one_line(&block)
    haml_concat capture_haml(&block).gsub("\n,", ',').gsub('\\n,', "\n,")
  end

  def profile_link(user)
    link_to user.name, person_path(user.id, user.slugged_name)
  end

  def embed_code(test)
    '<iframe title="Testeroni test" class="testeroni-test" type="text/html" width="640" height="390" src="' + test_url(test.id, test.to_param)+ '" frameborder="1"></iframe>'
  end

  def edit_link(path, size='xs')
    render partial: 'application/edit_link', locals: { path: path, size: size }
  end

  def trash_link(path, confirmation="Are you sure?")
    render partial: 'application/trash_link', locals: { path: path, confirmation: confirmation }
  end

end
