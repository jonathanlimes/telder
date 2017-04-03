class TextareaChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'textarea'
  end
end
