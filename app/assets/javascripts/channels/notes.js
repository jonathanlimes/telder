$(document).on('turbolinks:load', function() {
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
      // captures position of cursor
      // replace previous content with new Content
      $('#note-text').val(data.text)
    },
    connected: function () {
      $('#text-label').removeClass("is-dark").addClass("is-primary")
      $('#text-label').text("Connected to Server")
      console.log('Client-side channel connected to server')
    },
    disconnected: function () {
      $('#text-label').removeClass("is-dark").addClass("is-danger")
      $('#text-label').text("Disconnected from Server")
      console.log('Client-side channel disconnected from server')
    },
    rejected: function () {
      console.log('rejected')
    }
  }
)
}
