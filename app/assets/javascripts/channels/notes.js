$(document).on('turbolinks:load', function () {
  connectRealTime()
})

function connectRealTime () {
  console.log('connectRealTime function is running')
  App.notes = App.cable.subscriptions.create({
    channel: 'NotesChannel',
    note_id: current_note_id },

    {
      received: function (data) {
        console.log('received input')
        // capture last known position of cursor
        var lastCursorPosition = $('#note-text').caret()
        console.log(lastCursorPosition)
        // replace previous content with new Content
        $('#note-text').val(data.text)
        // return cursor position to last known position
        $('#note-text').caret(lastCursorPosition, 1)
        console.log('restored last cursor position')
      },
      connected: function () {
        $('#text-label').addClass('is-primary')
        $('#text-label').text('Connected to Server')
        console.log('Client-side channel connected to server')
      },
      disconnected: function () {
        $('#text-label').addClass('is-danger')
        $('#text-label').text('Disconnected from Server')
        console.log('Client-side channel disconnected from server')
      },
      rejected: function () {
        console.log('rejected')
      }
    }
)
}
