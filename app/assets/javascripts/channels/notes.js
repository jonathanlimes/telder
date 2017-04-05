$(document).on('turbolinks:load', function () {
  connectRealTime()
})

function connectRealTime () {
  console.log('connectRealTime function is running')

  if (!current_note_id) {
    return
  }

  App.notes = App.cable.subscriptions.create({
    channel: 'NotesChannel',
    note_id: current_note_id },

    {
      received: function (data) {
        console.log(data.active_editors)
        if (data.active_editors) {
          $('#active-editors').text('Active Editors: ' + data.active_editors)
          return
        }
        console.log('received input')
        // capture last known position of cursor
        var lastCursorPosition = $('#note-text').caret()
        console.log(lastCursorPosition)
        // replace previous content with new Content
        // if you are the sender don't show it
        if (data.author !== current_user_id) {
          $('#note-text').val(data.text)
          // return cursor position to last known position
          $('#note-text').caret(lastCursorPosition)
          console.log('restored last cursor position')
        }
      },
      connected: function () {
        $('#text-label').attr('class', 'tag is-primary')
        $('#text-label').text('Connected to Server')
        console.log('Client-side channel connected to server')
      },
      disconnected: function () {
        $('#text-label').attr('class', 'tag is-danger')
        $('#text-label').text('Disconnected from Server')
        console.log('Client-side channel disconnected from server')
      },
      rejected: function () {
        console.log('rejected')
      }
    }
)
}
