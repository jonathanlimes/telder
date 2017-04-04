$(document).on('turbolinks:load', function() {
  realtimeTextarea()
})

function realtimeTextarea() {
  console.log('realtimeTextarea is running')
  $('#note-text').on('keyup', function() {
    App.notes.send({ text: $(this).val(), author: current_user_id})
  })
}
