module TrigramsHelper

  def actual_point_stimulated
   actual_point = Point.find_by(name: 'R.3').name
  end

  def actual_point_sedated
   actual_point = Point.find_by(name: 'Vb.43').name
  end

  def trigram(trigram)
    [
      if  Line.find_by(id: trigram.line_3_id).yin_yang == 'yin'
        content_tag :div, '', class: "line_yin" do
          content_tag(:div, '', class: "line_yin_part_1") +
          content_tag(:div, "#{trigram.line_1.point&.name}", class: "line_yin_part_transparent") +
          content_tag(:div, '', class: "line_yin_part_3")
        end
      else
        content_tag(:div, '', class: 'line_yang') do
          content_tag(:div, '', class: "line_yang_part_1") +
          content_tag(:div, '', class: "line_yang_part_2") +
          content_tag(:div, '', class: "line_yang_part_3")
        end
      end,
      if  Line.find_by(id: trigram.line_2_id).yin_yang == 'yin'
        content_tag :div, '', class: "line_yin" do
          content_tag(:div, '', class: "line_yin_part_1") +
          content_tag(:div, "#{trigram.line_2.point&.name}", class: "line_yin_part_transparent") +
          content_tag(:div, '', class: "line_yin_part_3")
        end
      else
        content_tag(:div, '', class: 'line_yang') do
          content_tag(:div, '', class: "line_yang_part_1") +
          content_tag(:div,
            if actual_point_sedated
               "#{actual_point_sedated}"
            else
              'none'
            end,
            class: "line_yang_part_2") +
          content_tag(:div, '', class: "line_yang_part_3")
        end
      end,
      if  Line.find_by(id: trigram.line_1_id).yin_yang == 'yin'
        content_tag :div, '', class: "line_yin" do
          content_tag(:div, '', class: "line_yin_part_1") +
          content_tag(:div, "#{trigram.line_1.point&.name}", class: "line_yin_part_transparent") +
          content_tag(:div, '', class: "line_yin_part_3")
        end
      else
        content_tag(:div, '', class: 'line_yang') do
          content_tag(:div, '', class: "line_yang_part_1") +
          content_tag(:div, '', class: "line_yang_part_2") +
          content_tag(:div, '', class: "line_yang_part_3")
        end
      end
    ].join.html_safe
  end

end