require 'spec_helper'
require 'kettle/project'

describe Kettle::Project do
  let(:subject) { Kettle::Project.new(config) }

  context 'with an empty project_config' do
    let(:config) { Hash.new }

    it 'shoud have sane defaults' do
      is_expected.to respond_to(:config)
      expect(subject.config[:root]).to match Dir.pwd
      expect(subject.managed_sources).to be_empty
      expect(subject.managed_sources).to be_a Array
      expect(subject.managed_sources).to be_empty
    end

    # it 'should raise an error when no kettleroot is present' do
    #   expect { subject.kettleroot }.to raise_error /Kettleroot doesn't exist/
    # end
  end

  context 'with fixtures' do
    let(:config) {{ root: "#{fixture_path}/project" }}

    it 'should list all of the files relative to the project root' do
      expect(subject.file_list).not_to include('.')
      expect(subject.file_list).to include('.travis.yml')
      expect(subject.file_list).to include('spec/spec_helper.rb')
      expect(subject.directory_list).to contain_exactly('spec')
    end

    it 'should load the managed sources' do
      expect(subject.managed_sources).to be_a Array
      subject.managed_sources.each do |ms|
        expect(ms).to be_a Kettle::Source
        expect(ms.config).to include(:repo)
      end
    end

    it 'should list the templates relative to the project root' do
      expect(subject.template_list).to include('Rakefile.erb')
      expect(subject.template_list).not_to include('.travis.yml')
      expect(subject.template_list).not_to include('spec/spec_helper.rb')
    end

    it 'should list all of the static files relative to the project root' do
      expect(subject.static_file_list).to include('.travis.yml')
      expect(subject.static_file_list).to include('spec/spec_helper.rb')
      expect(subject.static_file_list).not_to include('Rakefile.erb')
    end
  end

end
