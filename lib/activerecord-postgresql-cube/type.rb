require "active_record/connection_adapters/postgresql_adapter"

module ActiveRecord
  module ConnectionAdapters
    module PostgreSQL
      module OID
        class Cube < Point
          def type
            :cube
          end

          def cast(value)
            case value
            when ::String
              dimensions = value.scan(/\(([^)]+)\)/).flatten.map { |dimension| dimension.split(/ *, */) }
              cast(dimensions.many? ? dimensions : dimensions[0])
            when ::Array
              value.map { |v| v.is_a?(::Array) ? cast(v) : Float(v) }
            else
              value
            end
          end

          def serialize(value)
            if value.is_a?(::Array)
              values = value.map { |v| v.is_a?(::Array) ? serialize(v) : Float(v) }
              values = values.join(",")
              values = "(#{values})" unless values[0] == "(" && values[-1] == ")"
              values
            else
              super
            end
          end
        end

        class TypeMapInitializer
          module CubeRegistration
            def run(records)
              if cube = records.find { |r| r["typname"] == "cube" }
                register cube["oid"], OID::Cube.new
              end
              super
            end
          end
          prepend CubeRegistration
        end

        ActiveRecord::Type.register(:cube, Cube, adapter: :postgresql)
      end
    end

    class PostgreSQLAdapter
      NATIVE_DATABASE_TYPES[:cube] = { name: "cube" }
    end

    class TableDefinition
      def cube(name, **args)
        column(name, "cube", **args)
      end
    end
  end
end
