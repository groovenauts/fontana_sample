# -*- coding: utf-8 -*-
require File.expand_path('../spec_scripts_helper', __FILE__)

describe "Dictionary with Array Input" do

  let(:network){ new_network("1000007").tap(&:login!) } # HPが1の人
  let(:request){ network.new_action_request }

  inputs = [
    []
    [null]
    [0]
    [1]
    [1000]
    ["0"]
    ["1"]
    ["1000"]
    [null, null]
    [0, 0]
    [1, 1]
    [1000, 1000]
    ["0", "0"]
    ["1", "1"]
    ["1000", "1000"]
  ]

  inputs.each do |input|
    it(input.inspect) do
      request.execute("AppSeedTestScript", "get_dictionary_with_array_input1", input: input)
      request.send_request
      request.outputs.length.should == 1
      request.outputs.first["result"].should == "output for #{input.inspect}"
    end
  end

end

