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
      end

      it "same action_id type" do
        a = Fontana::Action::AsyncAction.peek(@player01, 1)
        expect(a.action_id).to eq 1
        expect(a.status).to eq :executing
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
      let(:cxt){ Fontana::Action::Context.new("test"){ @player01 } }

      it do
        a = Fontana::Action::AsyncAction.peek(@player01, "2")
        expect(a.action_id).to eq "2"
        expect(a.status).to eq :success
        expect(a.response).to eq({"result"=>1379990870, "id"=>"2"})
      end

      it "different action_id type" do
        expect(cxt.async_call_results({'input_ids' => [2]}.to_json)).to eq [{id: 2, status: :not_found, message: "not found for id: 2" }]
      end
    end

  end

end
