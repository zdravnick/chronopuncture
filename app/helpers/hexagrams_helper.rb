module HexagramsHelper

  def hexagram(hexagram, compared_hexagram: nil)
      # при разнице линий показываем точку

      line_1_point = compared_hexagram.present? ? ((hexagram.line_1.yin_yang != compared_hexagram.line_1.yin_yang) ? hexagram.line_1_point : nil) : hexagram.line_1_point
      line_2_point = compared_hexagram.present? ? ((hexagram.line_2.yin_yang != compared_hexagram.line_2.yin_yang) ? hexagram.line_2_point : nil) : hexagram.line_2_point
      line_3_point = compared_hexagram.present? ? ((hexagram.line_3.yin_yang != compared_hexagram.line_3.yin_yang) ? hexagram.line_3_point : nil) : hexagram.line_3_point
      line_4_point = compared_hexagram.present? ? ((hexagram.line_4.yin_yang != compared_hexagram.line_4.yin_yang) ? hexagram.line_4_point : nil) : hexagram.line_4_point
      line_5_point = compared_hexagram.present? ? ((hexagram.line_5.yin_yang != compared_hexagram.line_5.yin_yang) ? hexagram.line_5_point : nil) : hexagram.line_5_point
      line_6_point = compared_hexagram.present? ? ((hexagram.line_6.yin_yang != compared_hexagram.line_6.yin_yang) ? hexagram.line_6_point : nil) : hexagram.line_6_point
      if hexagram.paired_hexagram && compared_hexagram.present?
        line_1_paired_point = compared_hexagram.present? ? ((hexagram.line_1.yin_yang != compared_hexagram.line_1.yin_yang) ? hexagram.paired_hexagram.line_1_point.name : nil)
          : hexagram.paired_hexagram.line_1_point.name
        line_2_paired_point = compared_hexagram.present? ? ((hexagram.line_2.yin_yang != compared_hexagram.line_2.yin_yang) ? hexagram.paired_hexagram.line_2_point.name : nil)
          : hexagram.paired_hexagram.line_2_point.name
        line_3_paired_point = compared_hexagram.present? ? ((hexagram.line_3.yin_yang != compared_hexagram.line_3.yin_yang) ? hexagram.paired_hexagram.line_3_point.name : nil)
          : hexagram.paired_hexagram.line_3_point.name
        line_4_paired_point = compared_hexagram.present? ? ((hexagram.line_4.yin_yang != compared_hexagram.line_4.yin_yang) ? hexagram.paired_hexagram.line_4_point.name : nil)
          : hexagram.paired_hexagram.line_4_point.name
        line_5_paired_point = compared_hexagram.present? ? ((hexagram.line_5.yin_yang != compared_hexagram.line_5.yin_yang) ? hexagram.paired_hexagram.line_5_point.name : nil)
          : hexagram.paired_hexagram.line_5_point.name
        line_6_paired_point = compared_hexagram.present? ? ((hexagram.line_6.yin_yang != compared_hexagram.line_6.yin_yang) ? hexagram.paired_hexagram.line_6_point.name : nil)
          : hexagram.paired_hexagram.line_6_point.name
      end
      [
        if  hexagram.line_6.yin_yang == 'yin'
          content_tag :div, '', class: "line_yin" do
            content_tag(:div, '', class: "line_yin_part_1") +
            content_tag(:div, "#{line_6_point && line_6_point.name}", class: "line_yin_part_transparent") +
            content_tag(:div, '', class: "line_yin_part_3")
          end
        else
          content_tag(:div, '', class: 'line_yang') do
            content_tag(:div, '', class: "line_yang_part_1") +
            content_tag(:div, "#{line_6_point && line_6_point.name}", class: "line_yang_part_2") +
            content_tag(:div, '', class: "line_yang_part_3")

          end
        end,
        if hexagram.line_5.yin_yang == 'yin'
          content_tag :div, '', class: "line_yin" do
            content_tag(:div, '', class: "line_yin_part_1") +
            content_tag(:div, "#{line_5_point && line_5_point.name}", class: "line_yin_part_transparent") +
            content_tag(:div, '', class: "line_yin_part_3")
          end
        else
          content_tag(:div, '', class: 'line_yang') do
            content_tag(:div, '', class: "line_yang_part_1") +
            content_tag(:div, "#{line_5_point && line_5_point.name}", class: "line_yang_part_2") +
            content_tag(:div, '', class: "line_yang_part_3")
          end
        end,
        if hexagram.line_4.yin_yang == 'yin'
          content_tag :div, '', class: "line_yin" do
            content_tag(:div, '', class: "line_yin_part_1") +
            content_tag(:div, "#{line_4_point && line_4_point.name}", class: "line_yin_part_transparent") +
            content_tag(:div, '', class: "line_yin_part_3")
          end
        else
          content_tag(:div, '', class: 'line_yang') do
            content_tag(:div, '', class: "line_yang_part_1") +
            content_tag(:div, "#{line_4_point && line_4_point.name}", class: "line_yang_part_2") +
            content_tag(:div, '', class: "line_yang_part_3")
          end
        end,
        if hexagram.line_3.yin_yang == 'yin'
          content_tag :div, '', class: "line_yin" do
            content_tag(:div, '', class: "line_yin_part_1") +
            content_tag(:div, "#{line_3_point &&  line_3_point.name}", class: "line_yin_part_transparent") +
            content_tag(:div, '', class: "line_yin_part_3")
          end
        else
          content_tag(:div, '', class: 'line_yang') do
            content_tag(:div, '', class: "line_yang_part_1") +
            content_tag(:div, "#{line_3_point &&  line_3_point.name}", class: "line_yang_part_2") +
            content_tag(:div, '', class: "line_yang_part_3")
          end
        end,
        if hexagram.line_2.yin_yang == 'yin'
          content_tag :div, '', class: "line_yin" do
            content_tag(:div, '', class: "line_yin_part_1") +
            content_tag(:div, "#{line_2_point &&  line_2_point.name}", class: "line_yin_part_transparent") +
            content_tag(:div, '', class: "line_yin_part_3")
          end
        else
          content_tag(:div, '', class: 'line_yang') do
            content_tag(:div, '', class: "line_yang_part_1") +
            content_tag(:div, "#{line_2_point &&  line_2_point.name}", class: "line_yang_part_2") +
            content_tag(:div, '', class: "line_yang_part_3")
          end
        end,
        if hexagram.line_1.yin_yang == 'yin'
          content_tag :div, '', class: "line_yin" do
            content_tag(:div, '', class: "line_yin_part_1") +
            content_tag(:div, "#{line_1_point &&  line_1_point.name}", class: "line_yin_part_transparent") +
            content_tag(:div, '', class: "line_yin_part_3")
          end
        else
          content_tag(:div, '', class: 'line_yang') do
            content_tag(:div, '', class: "line_yang_part_1") +
            content_tag(:div, "#{line_1_point &&  line_1_point.name}", class: "line_yang_part_2") +
            content_tag(:div, '', class: "line_yang_part_3")
          end
        end,
        if hexagram.paired_hexagram && compared_hexagram.present?
          if line_6_paired_point != nil
            content_tag(:div, "#{line_6_paired_point}",
              class: "paired_hexagram_points_line")
          else
            content_tag(:div, "", class: "paired_hexagram_points_line_display_none")
          end
        end,
        if hexagram.paired_hexagram && compared_hexagram.present?
          if line_5_paired_point != nil
            content_tag(:div, "#{line_5_paired_point}",
              class: "paired_hexagram_points_line")
          else
            content_tag(:div, "", class: "paired_hexagram_points_line_display_none")
          end
        end,
        if hexagram.paired_hexagram && compared_hexagram.present?
          if line_4_paired_point != nil
            content_tag(:div, "#{line_4_paired_point}",
              class: "paired_hexagram_points_line")
          else
            content_tag(:div, "", class: "paired_hexagram_points_line_display_none")
          end
        end,
        if hexagram.paired_hexagram && compared_hexagram.present?
          if line_3_paired_point != nil
            content_tag(:div, "#{line_3_paired_point}",
              class: "paired_hexagram_points_line")
          else
            content_tag(:div, "", class: "paired_hexagram_points_line_display_none")
          end
        end,
        if hexagram.paired_hexagram && compared_hexagram.present?
          if line_2_paired_point != nil
            content_tag(:div, "#{line_2_paired_point}",
              class: "paired_hexagram_points_line")
          else
            content_tag(:div, "", class: "paired_hexagram_points_line_display_none")
          end
        end,
        if hexagram.paired_hexagram && compared_hexagram.present?
          if line_1_paired_point != nil
            content_tag(:div, "#{line_1_paired_point}",
              class: "paired_hexagram_points_line")
          else
            content_tag(:div, "", class: "paired_hexagram_points_line_display_none")
          end
        end
      ].join.html_safe
    end

end
