require 'spec_helper'

describe "factory_girl sample" do
  describe "async_action" do
    let(:network){ new_network }

    context "working async_action" do
      before do
        Player.delete_all
        AsyncAction.delete_all
        @player01 = create(:player01)
        @async_action01 = create(:async_action01)
      end
      it do
        r = network.new_async_action_request
        r.instance_variable_set(:@ids, [1])
        r.async_status.should == [{id: 1, status: "executing" }]
      end
    end

    context "executed async_action" do
      before do
        Player.delete_all
        AsyncAction.delete_all
        @player01 = create(:player01)
        @async_action01 = create(:async_action02)
      end
      it do
        r = network.new_async_action_request
        r.instance_variable_set(:@ids, [2])
        r.async_status.should == [{"result"=>1379990870, "id"=>2}]
      end
    end

  end

end
