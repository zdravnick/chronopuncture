module ApplicationHelper

  def change_theme_link(theme, name)
    if theme == cookies.signed[:color_mode_cookie]
      return
    else
      link_to name, color_mode_helper_path(color_mode_param: theme),
       'data-turbolinks-track': 'reload'
    end
  end

end
