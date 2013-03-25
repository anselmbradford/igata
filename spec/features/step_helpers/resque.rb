def run_resque
  Thread.new do
    begin
      sleep 2
      worker = Resque::Worker.new('*')
      job    = worker.reserve
      worker.perform(job)
    ensure
      ActiveRecord::Base.connection.close
    end
  end
end
