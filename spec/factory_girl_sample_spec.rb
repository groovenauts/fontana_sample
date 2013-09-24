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
      it do
        r = network.new_async_action_request
        r.instance_variable_set(:@ids, [1.to_s])
        r.async_status.should == [{id: 1, status: "executing" }]
      end
    end

    context "executed async_action" do
      before do
        Player.delete_all
        AsyncAction.delete_all
        @async_action01 = create(:async_action02)
        @player01 = @async_action01.player
        @network = new_network(@player01.player_id).login!
      end
      it do
        r = network.new_async_action_request
        r.instance_variable_set(:@ids, [2])
        r.async_status.should == [{"result"=>1379990870, "id"=>2}]
      end
    end

  end

end
