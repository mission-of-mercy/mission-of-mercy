# Copyright (c) 2005 Thomas Fuchs
#
# Contributors : 
# - Nicolas Cavigneaux
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

module ActionView
  module Helpers
    module SliderHelper

      # Creates a slider control out of an element.
      def slider_element(element_id, options={})
        prepare = "Element.cleanWhitespace('#{element_id}');"
        
        [:change, :slide].each do |k|
          if options.include?(k)
            name = 'on' + k.to_s.capitalize
            options[name] = "function(value){#{options[k]}}"
            options.delete k
           end
        end
        
        [:spans, :axis].each do |k|
          options[k] = array_or_string_for_javascript(options[k]) if options[k]
        end
        
        options[:sliderValue] = array_or_numeric_for_javascript(options[:sliderValue]) if options[:sliderValue]
        
        options[:range] = "$R(#{options[:range].min},#{options[:range].max})" if options[:range]
        options[:values] = "$R(#{options[:values].min},#{options[:values].max})" if options[:values]
        
        slider = ''
        
        if options[:hidden_fields] == true
          slider = if options[:handles].kind_of?(Array)
            hidden_fields = options[:handles].collect { |h| hidden_field_tag(h.to_s + "_value") }
            hidden_fields.join("\n")
          elsif !options[:handles].nil?
            hidden_field_tag(options[:handles].to_s + "_value")
          end
          
          options.delete(:hidden_fields)
        end
        
        handle = array_or_string_for_javascript(options[:handles]) || "$('#{element_id}').firstChild"
        options.delete :handles
                
        slider += javascript_tag("#{prepare} #{element_id} = new Control.Slider(#{handle},'#{element_id}', #{options_for_javascript(options)})")
      end
      
      # Creates a simple slider control and associates it with a hidden text field
      def slider_field(object, method, options={})
        options.merge!({ 
          :change => "$('#{object}_#{method}').value = value",
          :hidden_fields => false
        })
        if slider_value = instance_variable_get("@#{object}").send(method)
          options.merge!({ :sliderValue  => slider_value })
        end
        hidden_field(object, method) <<        
        content_tag('div',content_tag('div', ''), 
          :class => 'slider', :id => "#{object}_#{method}_slider") << 
        slider_element("#{object}_#{method}_slider", options).html_safe
      end
      
      def slider_stylesheet
        content_tag("style", <<-EOT
          div.slider {
            width: 150px;
            height: 5px;
            margin-top:5px;
            margin-bottom:5px;
            background: #ddd;
            position: relative;
          }
          div.slider div {
            position:absolute;
            width:8px;
            height:15px;
            margin-top:-5px;
            background: #999;
            border:1px outset white;
          }
        EOT
        )
      end

      private
        def options_for_javascript(options)
          '{' + options.map {|k, v| "#{k}:#{v}"}.sort.join(', ') + '}'
        end

        def array_or_string_for_javascript(option)
          if option.kind_of?(Array)
            "['" + option.join("','") + "']"
          elsif !option.nil?
            "'#{option}'"
          end
        end
        
        def array_or_numeric_for_javascript(option)
          if option.kind_of?(Array)
            "[" + option.join(',') + "]"
          elsif !option.nil?
            option.to_s
          end
        end

    end
  end
end