require 'eventmachine'
require 'empipelines'
require File.join(File.dirname(__FILE__), 'test_stages')

module TestStages
  describe 'Consumption of events from a file' do
    let(:monitoring) { TestStages::MockMonitoring.new }
    let(:processed) { [] }
    let(:timeout) { 0.1 }

    include EmRunner

    it 'consumes all events from the file' do
      with_em_timeout(timeout) do
        pipeline = EmPipelines::Pipeline.new(EM, {:processed => processed}, monitoring)

        file_name = File.join(File.dirname(__FILE__), 'events.dat')
        source = EmPipelines::IOEventSource.new(EM, file_name)

        stages = [PassthroughStage, PassthroughStage, PassthroughStage]
        event_pipeline = EmPipelines::EventPipeline.new(source, pipeline.for(stages), monitoring)

        source.on_finished do |s|
          EM.stop
        end

        event_pipeline.start!
      end
    end
  end
end
