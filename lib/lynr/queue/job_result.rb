module Lynr; class Queue;

  class JobResult

    attr_reader :message

    def initialize(message = "", succeeded = true)
      @message = message
      @succeeded = succeeded
    end

    def success?
      @succeeded
    end

    def to_s
      result = if @succeeded
        'Success'
      else
        "Failure message=#{@message}"
      end
      "#<#{self.class.name}:#{object_id} #{result}>"
    end

  end

end; end;
