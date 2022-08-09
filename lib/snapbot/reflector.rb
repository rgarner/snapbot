# frozen_string_literal: true

require "active_record"
require "snapbot/reflector/relationship"

module Snapbot
  # Reflect models and instances in a way that's useful for generating a diagram
  class Reflector
    def base_activerecord_class
      defined?(ApplicationRecord) ? ApplicationRecord : ActiveRecord::Base
    end

    def models(only_with_records: true)
      @models ||= begin
        Rails.application.eager_load! if defined?(Rails)
        base_activerecord_class.descendants.reject do |c|
          activerecord_ignore?(c) || (only_with_records && c.count.zero?)
        end
      end
    end

    ACTIVERECORD_IGNORE = [
      /^Schema$/,
      /^HABTM_/,
      /^ActiveRecord::InternalMetadata$/,
      /^ActiveRecord::SchemaMigration$/
    ].freeze
    def activerecord_ignore?(klass)
      ACTIVERECORD_IGNORE.any? { |r| klass.name =~ r } || klass.abstract_class
    end

    def instances
      @instances ||= models.each_with_object([]) do |klass, array|
        array << klass.all
      end.flatten
    end

    # A Set of relationships to other identified entities
    def relationships
      @relationships ||= instances.each_with_object(Set.new) do |instance, set|
        add_relationships(instance, set)
      end
    end

    def add_relationships(instance, set)
      reflect_associations(instance).each do |association|
        records = Array(instance.send(association.name)).compact
        records.each do |record|
          set.add(Relationship.new(instance_name(instance), instance_name(record)))
        end
      end
    end

    def reflect_associations(instance)
      (
        instance.class.reflect_on_all_associations(:has_many).reject { |a| a.name == :schemas } +
          instance.class.reflect_on_all_associations(:has_one) +
          instance.class.reflect_on_all_associations(:has_and_belongs_to_many)
      ).flatten
    end

    def attributes(instance)
      instance.attributes.to_h.transform_values { |v| v.is_a?(Hash) ? escape_hash(v) : v }
    end

    private

    def instance_name(instance)
      "#{instance.model_name}##{instance.id}"
    end

    def escape_hash(hash)
      hash.each_with_object([]) do |(key, value), array|
        array << "#{key}: #{value.nil? ? "nil" : value}"
      end.join(", ")
    end
  end
end
