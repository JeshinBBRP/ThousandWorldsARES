require_relative "../../plugin_test_loader"

module AresMUSH
  module Who
    describe Who do
      before do
        @cmd = double
        @client_monitor = double(ClientMonitor)
        @client = double(Client).as_null_object
        Global.stub(:client_monitor) { @client_monitor }
      end

      describe :initialize do
        it "should read the templates" do
          TemplateRenderer.should_receive(:create_from_file) do |file|
            file.end_with?("header.lq").should be_true
          end

          TemplateRenderer.should_receive(:create_from_file) do |file|
            file.end_with?("character.lq").should be_true
          end

          TemplateRenderer.should_receive(:create_from_file) do |file|
            file.end_with?("footer.lq").should be_true
          end
          WhoCmd.new
        end
        
        it "should initialize the renderer" do
          TemplateRenderer.should_receive(:create_from_file) { 1 }
          TemplateRenderer.should_receive(:create_from_file) { 2 }
          TemplateRenderer.should_receive(:create_from_file) { 3 }
          WhoRenderer.should_receive(:new).with(1, 2, 3)
          WhoCmd.new
        end
      end
      
      describe :want_command do
        before do
          @who = WhoCmd.new
        end
        
        it "should want the who command" do
          @cmd.stub(:root_is?).with("who") { true }
          @who.want_command?(@cmd).should be_true
        end

        it "should not want another command" do
          @cmd.stub(:root_is?).with("who") { false }
          @who.want_command?(@cmd).should be_false
        end        
      end

      describe :on_command do        
        before do
          @client1 = double("Client1")
          @client2 = double("Client2")
          
          # Stub some people logged in
          @client_monitor.stub(:clients) { [@client1, @client2] }
          @client1.stub(:logged_in?) { true }
          @client2.stub(:logged_in?) { false }
          
          @renderer = double
          WhoRenderer.stub(:new) { @renderer }
          @who = WhoCmd.new
        end

        it "should call the renderer with the logged in chars" do
          @client_monitor.should_receive(:clients) { [@client1, @client2] }
          @client1.should_receive(:logged_in?) { false }
          @client2.should_receive(:logged_in?) { true }
          @renderer.should_receive(:render).with([@client2]) { "" }
          @who.on_command(@client, @cmd)
        end
        
        it "should emit the results of the render methods" do
          @renderer.stub(:render) { "ABC" }
          @client.should_receive(:emit).with("ABC")
          @who.on_command(@client, @cmd)
        end
      end
    end
  end
end