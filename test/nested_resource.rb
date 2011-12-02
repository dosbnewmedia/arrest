require 'test/unit'
load 'test/models.rb'

class NestedResourcesTest < Test::Unit::TestCase

  def setup
     Arrest::Source.source = nil
     #Arrest::Source.debug = true
  end

  def test_instance_test
    n = ANestedClass.new({:name => "foo"})
    assert_equal "foo", n.name
  end

  def test_from_hash
    input = {
      :parent_name => 'parent',
      :bool => false,
      :nested_object => { 
        :name => 'iamnested',
        :bool => true
      }
    }

    actual = WithNested.new(input)
    assert_equal 'parent', actual.parent_name
    assert_equal false, actual.bool
    assert actual.respond_to? :nested_object, "The parent object should have an accessor for the nested object"
    assert_equal 'iamnested', actual.nested_object.name
    assert_equal true, actual.nested_object.bool
  end

  def test_to_hash
    input = {
      :parent_name => 'parent',
      :bool => false,
      :nested_object => { 
        :name => 'iamnested',
        :bool => true
      }
    }

    actual = WithNested.new(input)

    # we expect camel cased keys
    expected = {
      'parentName' => 'parent',
      'bool' => false,
      'nestedObject' => { 
        'name' => 'iamnested',
        'bool' => true
      }
    }

    assert_equal_hashes expected, actual.to_hash

  end

  def assert_equal_hashes expected, actual
    assert_equal_hashes_ expected, actual, ''
  end

  def assert_equal_hashes_ expected, actual, prefix
    more_expected_keys = (expected.keys - actual.keys).map{|k| prefix + k.to_s }
    assert more_expected_keys.empty?, "Actual misses keys: #{more_expected_keys}"
    more_actual_keys = (actual.keys - expected.keys).map{|k| prefix + k.to_s }
    assert more_expected_keys.empty?, "Actual has more keys: #{more_actual_keys}"

    expected.each_pair do |ek, ev|
      av = actual[ek]
      if ev != nil && ev.is_a?(Hash)
        assert_equal_hashes_ ev, av, "#{prefix}."
      end
      assert_equal ev, av
    end
  end


end
