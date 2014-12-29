module ApplicationHelper

  def css_namespaces
    %Q{class="#{controller_name} #{action_name}"}.html_safe
  end
end
