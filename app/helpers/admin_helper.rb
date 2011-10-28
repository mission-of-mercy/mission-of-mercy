module AdminHelper
  def current_tab(tab)
    "current" if @current_tab == tab
  end
end
