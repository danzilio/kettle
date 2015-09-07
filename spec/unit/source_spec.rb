require 'spec_helper'
require 'kettle/source'

describe Kettle::Source do
  let(:subject) { Kettle::Source.new(path, config) }

  describe 'with fixtures' do
    let(:path) { "#{fixture_path}/project/sources/github.com/danzilio/kettle" }

    context 'with an empty config' do
      let(:config) {{}}

      it 'should load the configuration in .kettle.yaml' do
        expect(subject.config).to be_a Hash
        expect(subject.config).not_to be_empty
        expect(subject.config).to include('.travis.yml')
      end
    end

    context 'with configuration' do
      let(:config) {{ '.travis.yml' => {'managed' => true} }}

      it 'should merge the configuration with the dotfile configuration' do
        expect(subject.config['.travis.yml']['managed']).to be false
      end
    end
  end
end
