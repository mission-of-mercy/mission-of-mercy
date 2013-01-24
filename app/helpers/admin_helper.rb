module AdminHelper
  def current_tab(tab)
    "active" if @current_tab == tab
  end
end
