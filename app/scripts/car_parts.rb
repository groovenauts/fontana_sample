# -*- coding: utf-8 -*-

require 'net/http'

module CarParts

  def stocks(argh)
    car_cd      = argh[:car_cd]
    category_cd = argh[:category_cd]
    r = []
    if car_cd && category_cd
      parts_in_this_category =
        all(
          name: "CarParts",
          conditions: {
            "car_cd" => car_cd,
            "part_category_cd" => category_cd
          }
        )
    end
    r
  end
end
