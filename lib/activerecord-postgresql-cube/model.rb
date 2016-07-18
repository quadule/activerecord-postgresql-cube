require "active_record"

module ActiveRecordPostgreSQLCube
  module Model
    extend ActiveSupport::Concern

    class_methods do
      def by_cube_distance(column_name, cube)
        column = arel_table[column_name]
        cube_values = Arel.sql("'#{ActiveRecord::Type.lookup(:cube).serialize(cube)}'")
        distance_operation = Arel::Nodes::InfixOperation.new("<->", column, cube_values)
        distance_column_name = %{"#{column_name}_distance"}
        distance = Arel::Nodes::As.new(distance_operation, Arel.sql(distance_column_name))
        select_values = all.select_values.presence || [arel_table[Arel.star]]
        select(*select_values, distance).order(distance_column_name)
      end

      private def cube_attributes(column_name, *attributes)
        unless type_for_attribute(column_name.to_s).type == :cube
          raise ArgumentError, "#{column_name} is not a cube column"
        end

        attributes.each_with_index do |name, i|
          define_method "#{name}" do
            self[column_name][i]
          end

          define_method "#{name}=" do |value|
            self[column_name] ||= Array.new(attributes.size, 0)
            self[column_name][i] = value
          end
        end
      end
    end

    def similar_by_cube_distance(column_name)
      similar = self.class.by_cube_distance(column_name, send(column_name))
      similar.where.not(self.class.primary_key => send(self.class.primary_key))
    end
  end
end

ActiveRecord::Base.send :include, ActiveRecordPostgreSQLCube::Model
