# -*- coding: utf-8 -*-

# このファイルは生成されたファイルです。
#
# このファイルを変更する際には、再度生成され、上書きされる
# かもしれないことを考慮してください。
#

require 'factory_girl'

FactoryGirl.define do

  factory :master_diff_GreetingTemplate_nil_to_2_2, class: Fontana::MasterDiff do
    name           "GreetingTemplate"
    origin_version nil
    version        "2.2"
    clean_required true
    diff_content({
      "added_documents" => [
        { "greeting_cd" => 1, "message" => "おはようございます ^ ^"},
        { "greeting_cd" => 2, "message" => "こんにちはー！"},
        { "greeting_cd" => 3, "message" => "こんばんはー！"},
        { "greeting_cd" => 5, "message" => "いただきます"},
        { "greeting_cd" => 6, "message" => "ごちそうさま"},
      ],
      "updated_documents" => [],
      "deleted_documents" => [],
    })
  end

  factory :master_diff_GreetingTemplate_2_0_to_2_2, class: Fontana::MasterDiff do
    name           "GreetingTemplate"
    origin_version "2.0"
    version        "2.2"
    clean_required false
    diff_content({
      "added_documents" => [
          { "greeting_cd" => 5, "message" => "いただきます"},
          { "greeting_cd" => 6, "message" => "ごちそうさま"},
        ],
      "updated_documents" => [
          { "greeting_cd" => 1, "message" => "おはようございます ^ ^"},
        ],
      "deleted_documents" => [
          { "greeting_cd" => 4},
        ],
    })
  end

end
