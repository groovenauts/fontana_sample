# -*- coding: utf-8 -*-
require File.expand_path('../spec_scripts_helper', __FILE__)

describe "Dictionary with Array Input" do

  fixtures "simple"
  before(:all) do
    Fontana::Cache::Redis.instance.flushdb
    Fontana::ClientRelease.delete_all
    FactoryGirl.create(:client_release01)
    Player.delete_all
    @player = FactoryGirl.create :player01
    DictionaryWithArrayInput1.app_seed_collection.create
  end

  let(:cxt){ Fontana::Action::Context.new("test"){ @player } }

  inputs = [
    []                                   , '[]',
    [nil]                                , '[null]',
    [0]                                  , '[0]',
    [1]                                  , '[1]',
    [1000]                               , '[1000]',
    ["0"]                                , '["0"]',
    ["1"]                                , '["1"]',
    ["1000"]                             , '["1000"]',
    [nil, nil]                           , '[null, null]',
    [0, 0]                               , '[0, 0]',
    [1, 1]                               , '[1, 1]',
    [1000, 1000]                         , '[1000, 1000]',
    ["0", "0"]                           , '["0", "0"]',
    ["1", "1"]                           , '["1", "1"]',
    ["1000", "1000"]                     , '["1000", "1000"]',
    ["M01A01DM01",40000100,1]            , '["M01A01DM01",40000100,1]',
    ["M01A01DM01","40000100","2"]        , '["M01A01DM01","40000100","2"]',
    ["M01A01DM01",  "40000100",  "3"]    , '["M01A01DM01",  "40000100",  "3"]',

    # シングルクォーテーションはJSONで文字列として認識されないので、文字列として登録されていまいます。
    ['M01A01DM01',40000100,4]            , nil,
    ['M01A01DM01','40000100','5']        , nil,
    ['M01A01DM01',    '40000100',    '6'], nil,
    "['M01A01DM01',40000100,4]"            , ["['M01A01DM01',40000100,4]"            , nil],
    "['M01A01DM01','40000100','5']"        , ["['M01A01DM01','40000100','5']"        , nil],
    "['M01A01DM01',    '40000100',    '6']", ["['M01A01DM01',    '40000100',    '6']", nil],
  ]

  Hash[*inputs].each do |input, expect|
    raw_expect, str_expect = *(expect.is_a?(Array) ? expect : [expect, expect])

    if raw_expect
      it("raw #{input.inspect}") do
        r = cxt.execute("name" => "AppSeedTestScript", "key" => "get_dictionary_with_array_input1", "args" => {input: input})
        expect(r).to eq "output for #{raw_expect}"
      end
    else
      it("raw #{input.inspect} causes action error 1018") do
        expect{
          cxt.execute("name" => "AppSeedTestScript", "key" => "get_dictionary_with_array_input1", "args" => {input: input})
        }.to raise_error(Fontana::Action::Errors::ActionsError, /\A1018:/)
      end
    end

    if str_expect
      it("string #{input.inspect}") do
        r = cxt.execute("name" => "AppSeedTestScript", "key" => "get_dictionary_with_array_input1", "args" => {input: input.to_json} )
        expect(r).to eq (str_expect ? "output for #{str_expect}" : nil)
      end
    else
      it("string #{input.inspect} causes action error 1018") do
        expect{
          cxt.execute("name" => "AppSeedTestScript", "key" => "get_dictionary_with_array_input1", "args" => {input: input.to_json} )
        }.to raise_error(Fontana::Action::Errors::ActionsError, /\A1018:/)
      end
    end
  end

end
