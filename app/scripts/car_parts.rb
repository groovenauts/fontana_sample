# -*- coding: utf-8 -*-

require 'net/http'

module CarParts

  def stocks(argh)
    car_cd      = argh[:car_cd]
    category_cd = argh[:category_cd]

    r = []

    if car_cd && category_cd
      parts_in_this_category = all(
                                   name:       'CarPart',
                                   conditions: { 'car_cd' => car_cd, 'part_category_cd' => category_cd }
                               )

      r = parts_in_this_category.map do |p|
        c = count(name: 'Stock', conditions: { "part_cd" => p["part_cd"] })
        n = first(name: 'Part' , conditions: { 'cd'      => p['part_cd'] })[:name]
        "#{n}(#{c})"
      end
    end
    r
  end
end
