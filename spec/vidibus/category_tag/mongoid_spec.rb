require 'spec_helper'

class Movie
  include Mongoid::Document
  include Vidibus::CategoryTag::Mongoid
end

class Western < Movie
  tags_separator ';'
end

describe Vidibus::CategoryTag::Mongoid do
  let(:subject) { Movie.new }

  describe '#tags=' do
    it 'should save a hash as tags with category' do
      subject.tags = {'1' => 'rugby'}
      subject.tags_hash.should eq({'1' => ['rugby']})
    end

    it 'should save tags as array' do
      subject.tags = {'1' => 'us, br'}
      subject.tags_hash.should eq({'1' => ['us', 'br']})
    end

    it 'should save tags separated by semicolon' do
      subject = Western.new
      subject.tags = {'1' => 'us; br'}
      subject.tags_hash.should eq({'1' => ['us', 'br']})
    end

    it 'should not save empty tags' do
      subject.tags = {'1' => ''}
      subject.tags_hash.should eq({})
    end

    it 'should add multiple keys as category' do
      subject.tags = {'1' => 'rugby', '2' => 'us, br'}
      subject.tags_hash.should eq({'1' => ['rugby'], '2' => ['us', 'br']})
    end

    it 'should not add an array as tag' do
      tags = ['1', 'rugby']
      expect { subject.tags = tags }.to raise_error(Vidibus::CategoryTag::Error)
    end

    it 'should not add a string as tag' do
      expect { subject.tags = '1' }.to raise_error(Vidibus::CategoryTag::Error)
    end

    it 'should remove a trailing separator' do
      subject.tags = {'1' => 'rugby,'}
      subject.tags_hash.should eq({'1' => ['rugby']})
    end

    it 'should override tags' do
      subject.tags = {'1' => 'rugby'}
      subject.tags = {'2' => 'us'}
      subject.tags_hash.should eq({'2' => ['us']})
    end
  end

  describe '#tags' do
    it 'should be empty by default' do
      subject.tags.should eq({})
    end

    it 'should be a string' do
      subject.tags_hash = {'1' => ['us', 'br']}
      subject.tags.should eq({'1' => 'us,br'})
    end

    it 'should be separated by semicolon when defined' do
      subject = Western.new
      subject.tags_hash = {'1' => ['us', 'br']}
      subject.tags.should eq({'1' => 'us;br'})
    end
  end

  describe '#tags[]' do
    it 'should add tags to an existing hash' do
      pending 'Second iteration'
    end
  end
end
