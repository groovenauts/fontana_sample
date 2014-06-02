require 'spec_helper'

describe "factory_girl sample" do
  describe "async_action" do

    let(:network){ @network }

    context "working async_action" do

      before do
        Fontana::ClientRelease.delete_all
        # Fontana::ClientRelease::DeviceType.delete_all
        FactoryGirl.create(:client_release01)

        Player.delete_all
        Fontana::Action::AsyncAction.delete_all

        @async_action01 = FactoryGirl.create(:async_action01)
        @player01 = @async_action01.player
        # @context = Fontana::Action::Context.new("test"){ @player01 }
      end
      it "same action_id type" do
        a = Fontana::Action::AsyncAction.peek(@player01, 1)
        expect(a.id).to eq 1
        expect(a.status).to eq "executing"
      end
      it "different action_id type" do
        expect(Fontana::Action::AsyncAction.peek(@player01, "1")).to be_nil
      end
    end

    context "executed async_action" do
      before do
        Player.delete_all
        Fontana::Action::AsyncAction.delete_all
        @async_action02 = create(:async_action02)
        @player01 = @async_action02.player
      end
      it do
        a = Fontana::Action::AsyncAction.peek(@player01, "2")
        expect(a.id).to eq "2"
        expect(a.status).to eq "executing"

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
