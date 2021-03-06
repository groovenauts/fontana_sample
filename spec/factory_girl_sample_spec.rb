require 'spec_helper'

describe "factory_girl sample" do
  describe "async_action" do

    let(:network){ @network }

    context "working async_action" do

      before do
        ClientRelease.delete_all
        # ClientRelease::DeviceType.delete_all
        FactoryGirl.create(:client_release01)

        Player.delete_all
        AsyncAction.delete_all

        @async_action01 = FactoryGirl.create(:async_action01)
        @player01 = @async_action01.player
        @network = new_network(@player01.player_id).login!
      end
      it "same action_id type" do
        r = network.new_async_action_request
        r.async_status([1]).to_a.should == [{"id" => 1, "status" => "executing" }]
      end
      it "different action_id type" do
        r = network.new_async_action_request
        r.async_status(["1"]).to_a.should == [{"id" => "1", "status" => "not_found" , "message" => "not found for id: \"1\"" }]
      end
    end

    context "executed async_action" do
      before do
        Player.delete_all
        AsyncAction.delete_all
        @async_action02 = create(:async_action02)
        @player01 = @async_action02.player
        @network = new_network(@player01.player_id).login!
      end
      it do
        r = network.new_async_action_request
        r.async_status(["2"]).to_a.should == [{"result"=>1379990870, "id"=>"2"}]
      end

      it "different action_id type" do
        r = network.new_async_action_request
        r.async_status([2]).to_a.should == [{"id" => 2, "status" => "not_found" , "message" => "not found for id: 2" }]
      end
    end

  end

end
