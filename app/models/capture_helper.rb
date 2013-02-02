module CaptureHelper
  include ActionView::Helpers::CaptureHelper
  include Haml::Helpers

  def self.helpers
    @helpers ||= Object.new.extend(self).tap do |h|
      h.init_haml_helpers
    end
  end
end