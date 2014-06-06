# -*- coding: utf-8 -*-
require File.expand_path('../spec_scripts_helper', __FILE__)

describe "master_diffs" do

  before :all do
    Fontana::MasterDiff.delete_all
    FactoryGirl.create :master_diff_GreetingTemplate_nil_to_2_2
    FactoryGirl.create :master_diff_GreetingTemplate_2_0_to_2_2
  end

  before do
    Fontana.version_set.stub(:collection_versions).and_return({"GreetingTemplate" => "2.2"})
  end

  let(:cxt){ Fontana::Action::Context.new("test"){ @player } }

  context "01_basic" do
    context "1.2" do
      it do
        r = cxt.master_diffs("downloaded_versions" => {"GreetingTemplate" => "1.2"})
        r.each{|i| i.delete("created_at")}
        r.each{|i| i.delete("updated_at")}
        expect(r).to eq([{
          "name" => "GreetingTemplate",
          "origin_version" => nil,
          "version" => "2.2",
          "clean_required" => true,
          "diff_content" => {
            "added_documents" => [
              { "greeting_cd" => 1, "message" => "おはようございます ^ ^"},
              { "greeting_cd" => 2, "message" => "こんにちはー！"},
              { "greeting_cd" => 3, "message" => "こんばんはー！"},
              { "greeting_cd" => 5, "message" => "いただきます"},
              { "greeting_cd" => 6, "message" => "ごちそうさま"},
            ],
            "updated_documents" => [],
            "deleted_documents" => [],
          },
        }])
      end
    end

    context "2.0" do
      it do
        r = cxt.master_diffs("downloaded_versions" => {"GreetingTemplate" => "2.0"})
        r.each{|i| i.delete("created_at")}
        r.each{|i| i.delete("updated_at")}
        expect(r).to eq([{
          "name" => "GreetingTemplate",
          "origin_version" => "2.0",
          "version" => "2.2",
          "clean_required" => false,
          "diff_content" => {
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
          }
        }])
      end
    end
  end

end
