require 'ansi'

module AresMUSH
  class ClientMonitor
    def initialize(config_reader, dispatcher)
      @clients = []
      @client_id = 0
      @config_reader = config_reader
      @dispatcher = dispatcher
    end

    attr_reader :clients, :client_id
    
    def tell_all(msg)
      @clients.each do |c|
        c.emit msg
      end
    end

    def connection_established(connection)
      @client_id = @client_id + 1   
      client = Client.new(@client_id, self, @config_reader, connection)       
      connection.client = client
      client.connected
      @clients << client
      
      # TODO - raise system event
      tell_all "Client #{client.id} connected"
    end

    def connection_closed(client)
      @clients.delete client
      
      # TODO - raise system event
      tell_all "Client #{client.id} disconnected"
    end
    
    def handle_client_input(client, input)
      @dispatcher.dispatch(client, input)
    end
  end
end