
require 'factory_girl'

FactoryGirl.define do

  factory :async_action01, class: AsyncAction do
    player01
    action_id "1"
    request_url "http://localhost:3000/api/1.0.0/async_actions.json?auth_token=CzyWmCg3vjpxeYuHL8dr"
    request {"id"=>1, "action"=>"server_time"},
    # response {"result"=>1379990870, "id"=>1}
    attempts 0
  end

  factory :async_action02, class: AsyncAction do
    player01
    action_id "2"
    request_url "http://localhost:3000/api/1.0.0/async_actions.json?auth_token=CzyWmCg3vjpxeYuHL8dr"
    request {"id"=>2, "action"=>"server_time"},
    response {"result"=>1379990870, "id"=>2}
    attempts 0
  end
end
