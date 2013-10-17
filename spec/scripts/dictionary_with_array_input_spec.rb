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
    ['M01A01DM01',40000100,4]            , "['M01A01DM01',40000100,4]",
    ['M01A01DM01','40000100','5']        , "['M01A01DM01','40000100','5']",
    ['M01A01DM01',    '40000100',    '6'], "['M01A01DM01',    '40000100',    '6']",
  ]

  Hash[*inputs].each do |input, expect|
    it("raw #{input.inspect}") do
      request.execute("AppSeedTestScript", "get_dictionary_with_array_input1", input: input)
      request.send_request
      request.outputs.length.should == 1
      request.outputs.first["result"].should == "output for #{expect}"
    end

    it("string #{input.inspect}") do
      request.execute("AppSeedTestScript", "get_dictionary_with_array_input1", input: input.to_json)
      request.send_request
      request.outputs.length.should == 1
      request.outputs.first["result"].should == "output for #{expect}"
    end
  end

end
