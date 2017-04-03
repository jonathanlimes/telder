$(document).on('turbolinks:load', function() {
  realtimeTextarea()
})

function realtimeTextarea() {
  console.log('realtimeTextarea is running')
  $('#note-text').keyup(function() {
    App.notes.send({ text: $(this).val()})
  })
}
