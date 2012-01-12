require 'timeout'

namespace :image do
  task :update => :environment do
    include ActionDispatch::Routing::UrlFor
    include Rails.application.routes.url_helpers
    $directory_head = APP_CONFIG['image']['directory']
    $command_head = APP_CONFIG['image']['command']
    $timeout = APP_CONFIG['image']['timeout']
    $sleep_interval = APP_CONFIG['image']['sleep_interval']
    while true
      puts 'running'
      gist_queue = Gist.where :image_status => ['wait', 'loading']
      gist_queue.each do |gist|
        begin
          gist.image_status = 'loading'
          gist.save
          gist_simple_url = short_gist_simple_path gist, :only_path => false
          gist_saved_path = $directory_head + "#{gist.key}.jpg"
          command = $command_head + " #{gist_simple_url} #{gist_saved_path}"
          pid = nil
          is_finished = false
          begin
            Timeout.timeout $timeout do
              pid = Process.spawn(command)
              Process.waitpid pid
              gist.image_status = 'finished'
              gist.save
              is_finished = true
            end
          rescue Timeout::Error
            Process.kill('KILL', pid)
            gist.image_status = 'tle'
            gist.save
          end
          if is_finished
            TrimImage::Trimmer.new(gist_saved_path).write          
          end
        rescue Exception => e
          gist.image_status = 'error'
          gist.save
          puts e          
        end
      end
      sleep $sleep_interval
    end
  end
end
