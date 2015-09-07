require 'spec_helper'
require 'kettle/template'

describe Kettle::Template do
  let(:subject) { Kettle::Template.new(name) }

  context 'with mocks' do
    let(:name) { 'spec/spec_helper.rb.erb' }
    let(:content) { '<%= @config %>'}

    it 'should merge the configs and generate the template' do
      left = {'spec/spec_helper.rb' => {'require' => ['some_thing']}}
      right = {'spec/spec_helper.rb' => {'require' => ['some_other_thing']}}
      expect(subject.name).to match 'spec/spec_helper.rb.erb'
      expect(subject.path).to match 'spec/spec_helper.rb'
      expect(subject.render(content, left, right)).not_to be_empty
      expect(subject.instance_variable_get('@config')).not_to be_empty
      expect(subject.instance_variable_get('@all')).not_to be_empty
    end
  end
end
