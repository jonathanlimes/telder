class NotesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notes:#{params[:note_id]}"
  end

  def receive(data)
    ActionCable.server.broadcast("notes:#{params[:note_id]}", data)
  end
end
