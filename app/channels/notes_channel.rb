class NotesChannel < ApplicationCable::Channel
  def subscribed
    puts "Server-side NotesChannel: User has connected/subscribed"
    stream_from "notes:#{params[:note_id]}"
    ActionCable.server.broadcast("notes:#{params[:note_id]}", active_editors: ActionCable.server.connections.length)
  end

  def unsubscribed
    puts "Server-side NotesChannel: User has disconnected/unsubscribed"
    ActionCable.server.broadcast("notes:#{params[:note_id]}", active_editors: ActionCable.server.connections.length)
  end

  def receive(data)
    ActionCable.server.broadcast("notes:#{params[:note_id]}", data)
  end
end
