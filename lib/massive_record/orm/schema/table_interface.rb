module MassiveRecord
  module ORM
    module Schema
      module TableInterface
        extend ActiveSupport::Concern

        included do
          class_attribute :column_families, :instance_writer => false
          self.column_families = nil
        end


        module ClassMethods
          def column_family(name, &block)
            self.column_families = ColumnFamilies.new if column_families.nil?
            column_families.family_or_new(name).instance_eval(&block)
          end

          def known_attribute_names
            column_families.present? ? column_families.attribute_names : []
          end

          def attributes_schema
            column_families.present? ? column_families.to_hash : {}
          end

          def default_attributes_from_schema
            defaults = {}
            attributes_schema.each { |attribute_name, field| defaults[attribute_name] = field.default }
            defaults
          end

          def autoloaded_column_family_names
            column_families.present? ? column_families.families_with_auto_loading_fields.collect(&:name) : []
          end
        end


        def attributes_schema
          self.class.attributes_schema
        end
      end
    end
  end
end
