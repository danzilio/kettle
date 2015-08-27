require 'spec_helper'
require 'kettle/project'

describe Kettle::Project do
  let(:subject) { Kettle::Project.new(project_config) }

  context 'with an empty project_config' do
    let(:project_config) { Hash.new }

    it 'shoud have sane defaults' do
      is_expected.to respond_to(:config)
      expect(subject.config[:root]).to match "#{Dir.pwd}/kettleroot"
    end
  end

  context 'with fixtures' do
    let(:project_config) {{ root: "#{fixture_path}/kettleroot" }}

    it 'should list all of the files relative to the project root' do
      expect(subject.files).not_to include('.')
      expect(subject.files).to include('.travis.yml')
      expect(subject.files).to include('spec/spec_helper.rb')
    end

    it 'should list the templates relative to the project root' do
      expect(subject.templates).to include('Rakefile.erb')
      expect(subject.templates).not_to include('.travis.yml')
      expect(subject.templates).not_to include('spec/spec_helper.rb')
    end

    it 'should list all of the static files relative to the project root' do
      expect(subject.static_files).to include('.travis.yml')
      expect(subject.static_files).to include('spec/spec_helper.rb')
      expect(subject.static_files).not_to include('Rakefile.erb')
    end
  end

end
