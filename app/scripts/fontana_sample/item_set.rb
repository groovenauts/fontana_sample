# -*- coding: utf-8 -*-
module FontanaSample
  module ItemSet
    class << self

      # 引数objをアイテム用の汎用的なHashに変換します
      # @param [Hash|Array|String] obj
      # @return [Hash] キーがアイテムコード、値が数量を意味するHash
      def to_hash(obj)
        case obj
        when Hash then obj
        when Array then obj.each_with_object({}){ |i, r| r[i.to_s] = 1 }
        else {obj.to_s => 1}
        end
      end
    end
  end
end
