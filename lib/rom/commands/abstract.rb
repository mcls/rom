module ROM
  module Commands
    class Abstract
      include Options

      option :type, allow: [:create, :update, :delete]
      option :result, reader: true, allow: [:one, :many]
      option :target
      option :validator, reader: true
      option :input, reader: true

      attr_reader :relation

      # @api private
      def initialize(relation, options = {})
        super
        @relation = relation
        @result ||= :many
        @validator ||= proc {}
        @input ||= Hash
      end

      # Call the command and return one or many tuples
      #
      # @api public
      def call(*args)
        tuples = execute(*args)

        if result == :one
          tuples.first
        else
          tuples
        end
      end

      # Target relation on which the command will operate
      #
      # By default this is set to the relation that's passed to the constructor.
      # Specialized commands like Delete may set the target to a different
      # relation.
      #
      # @return [Relation]
      #
      # @api public
      def target
        relation
      end

      # Assert that tuple count in the target relation corresponds to :result
      # setting
      #
      # @raises TupleCountMismatchError
      #
      # @api private
      def assert_tuple_count
        if result == :one && tuple_count > 1
          raise TupleCountMismatchError, "#{inspect} expects one tuple"
        end
      end

      # Return number of tuples in the target relation
      #
      # This should be overridden by repositories when `#count` is not available
      # in the relation objects
      #
      # @return [Fixnum]
      #
      # @api private
      def tuple_count
        target.count
      end
    end
  end
end
