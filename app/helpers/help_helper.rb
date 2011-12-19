module HelpHelper
  def help_box(name, &block)
    content_tag(:div, :id => "#{name}-help", :class => "help-box", :style => "display: none;") do
      [
        image_tag( "up.png", :class => "close",
          :title => "Click here to close this help page"),
        capture(&block)
      ].join("\n").html_safe
    end
  end

  def help_icon(name)
    image_tag "help.png", :class => "help", :id => "#{name}-help-icon",
      :title => "Click here for more information",
      :'data-help' => "#{name}-help"
  end
end
