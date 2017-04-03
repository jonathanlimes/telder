class NotesChannel < ApplicationCable::Channel
  def subscribed
    puts 'NotesChannel: streaming'
    stream_from "notes:#{params[:note_id]}"
  end

  def receive(data)
    puts 'NotesChannel: data received'
    ActionCable.server.broadcast("notes:#{params[:note_id]}", data)
  end
end
