# -*- coding: utf-8 -*-
require File.expand_path('../spec_scripts_helper', __FILE__)

describe "Dictionary with Array Input" do

  fixtures "simple"
  before(:all) do
    ClientRelease.delete_all
    FactoryGirl.create(:client_release01)
  end

  let(:network){ new_network.tap(&:login!) } # HPが1の人
  let(:request){ network.new_action_request }

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

    it("raw #{input.inspect}") do
      request.execute("AppSeedTestScript", "get_dictionary_with_array_input1", input: input)
      request.send_request
      request.outputs.length.should == 1
      request.outputs.first["result"].should == (raw_expect ? "output for #{raw_expect}" : nil)
    end

    it("string #{input.inspect}") do
      request.execute("AppSeedTestScript", "get_dictionary_with_array_input1", input: input.to_json)
      request.send_request
      request.outputs.length.should == 1
      request.outputs.first["result"].should == (str_expect ? "output for #{str_expect}" : nil)
    end
  end

end
