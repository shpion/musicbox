class AudioConverterWorker
  include Sidekiq::Worker

  def perform(record_id)

    require 'open3'

    # puts ("Name " + file_uploaded.original_filename)

    record = MyRecord.find(record_id)

    ext = record.file_name.split(".")[1]

    if ext != "mp3"
      command = "soundconverter -b -m audio/mpeg -s .mp3 public/uploads/" + record.unic_name + "." + ext
      stdin, stdout, stderr = Open3.popen3(command)
      output = stdout.read
      stdin.close; stdout.close; stderr.close

      if(output['Queue done'] == "Queue done")
        File.unlink("public/uploads/" + record.unic_name + "." + ext)
        file_size = File.size("public/uploads/" + record.unic_name + ".mp3")
        record.update({:converted => 1, :size => file_size})
      else
        record.update({:converted => 2})
      end
    else
      record.update({:converted => 1})
    end

  end
end