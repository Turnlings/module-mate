module GradesHelper
  def class_badge(mark)
    label, css = case mark
                 when 70.. then ['First Class', 'chip-success']
                 when 60...70 then ['Second Class (2:1)', 'chip-success']
                 when 50...60 then ['Second Class (2:2)', 'chip-success']
                 when 40...50 then ['Third Class', 'chip-success']
                 else %w[Failed chip-danger]
                 end

    content_tag :div, label, class: "hide-on-mobile mx-2 #{css}"
  end
end
