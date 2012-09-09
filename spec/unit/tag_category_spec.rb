require 'spec_helper'

describe TagCategory do
  describe 'validation' do
    it 'should pass with valid attributes' do
      Factory(:tag_category).should be_valid
    end
  end

  describe '#callname' do
    it 'sould be set from label before validation, unless provided' do
      category = Factory.build(:tag_category, :label => 'Rating', :callname => nil)
      category.valid?
      category.callname.should eq('rating')
    end

    it 'sould not be set from label unless a label is available' do
      category = Factory.build(:tag_category, :label => nil, :callname => nil)
      category.valid?
      category.callname.should be_nil
    end
  end

  describe '#context' do
    before do
      @first = Factory(:tag_category, :context => ['realm:100', 'model:movie'])
      @second = Factory(:tag_category, :context => ['realm:100', 'model:photo'])
      @third = Factory(:tag_category)
    end

    it 'should use a filter to find one record' do
      TagCategory.context({:model => 'movie'}).map(&:id).should eq([@first.id])
    end

    it 'should use a filter to find several records' do
      TagCategory.context({:realm => 100}).map(&:id).should eq([@first.id, @second.id])
    end

    it 'should use a more complex filter to find one record' do
      filter = {:realm => 100, :model => 'photo'}
      TagCategory.context(filter).map(&:id).should eq([@second.id])
    end

    it 'should find nothing' do
      TagCategory.context({:foo => 'bar'}).count.should eq(0)
    end

    it 'should find all records' do
      TagCategory.context({}).count.should eq(3)
    end
  end

  describe '#tags' do
    it 'should be an empty array by default' do
      TagCategory.new.tags.should eq([])
    end

    it 'should be made unique before validation' do
      category = Factory.build(:tag_category, :tags => %w[tag1 tag2 tag1])
      category.valid?
      category.tags.should eq(%w[tag1 tag2])
    end
  end

  describe '#context' do
    it 'should be an empty array by default' do
      TagCategory.new.context.should eq([])
    end
  end

  describe '.sort!' do
    before do
      @first = Factory(:tag_category, :context => ['realm:100', 'model:movie'])
      @second = Factory(:tag_category, :context => ['realm:100', 'model:movie'])
      @third = Factory(:tag_category, :context => ['realm:101', 'model:movie'])
      @fourth = Factory(:tag_category, :context => ['realm:101', 'model:movie'])
    end

    it 'should put items in order' do
      order = [@third.uuid, @second.uuid, @first.uuid, @fourth.uuid]
      TagCategory.sort!(order)
      TagCategory.sorted.map {|t| t.uuid}.should eq(order)
    end

    it 'should remove items not in list' do
      order = [@third.uuid, @first.uuid, @fourth.uuid]
      TagCategory.sort!(order)
      TagCategory.sorted.map {|t| t.uuid}.should eq(order)
    end

    it 'should accept order with prefix' do
      order = [@third.uuid, @second.uuid, @first.uuid, @fourth.uuid]
      TagCategory.sort!(order.map {|o| "prefix-#{o}"})
      TagCategory.sorted.map {|t| t.uuid}.should eq(order)
    end

    context 'in context' do
      let(:context) do
        {:realm => 100, :model => 'movie'}
      end

      it 'should put items in order' do
        order = [@second.uuid, @first.uuid]
        TagCategory.in_context(context).sort!(order)
        TagCategory.in_context(context).sorted.map {|t| t.uuid}.should eq(order)
      end

      it 'should remove items not in list' do
        order = [@second.uuid]
        TagCategory.in_context(context).sort!(order)
        TagCategory.in_context(context).sorted.map {|t| t.uuid}.should eq(order)
      end

      it 'should not touch items not in context' do
        order = [@third.uuid, @second.uuid]
        TagCategory.in_context(context).sort!(order)
        TagCategory.in_context(context).sorted.map {|t| t.uuid}.should eq([@second.uuid])
        TagCategory.in_context(:realm => 101, :model => 'movie').count.should eq(2)
      end
    end
  end
end
