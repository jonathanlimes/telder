class ExportNoteMailer < ApplicationMailer

  def export_note(current_user, note)
    @current_user = current_user
    @note = note
    mail(to: @current_user.email, subject: "Telder: Your exported note")
  end

end
