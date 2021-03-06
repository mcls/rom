module ROM
  module Commands
    class Evaluator
      include Concord.new(:registry)

      # Evaluate a block by executing it or passing +self+ depending on block arity
      def evaluate(&block)
        if block.arity > 0
          yield self
        else
          instance_exec(&block)
        end
      end

      private

      # Call a command when method is matching command name
      #
      # TODO: this will be replaced by explicit definition of methods for all
      #       registered commands
      #
      # @api public
      def method_missing(name, *args, &block)
        command = registry[name]

        if args.size > 1
          command.new(*args, &block)
        else
          command.call(*args, &block)
        end
      end
    end
  end
end
