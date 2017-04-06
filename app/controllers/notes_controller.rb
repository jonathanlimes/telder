class NotesController < ApplicationController
  before_action :set_note, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /notes
  # GET /notes.json
  def index
    @notes = Note.all.order('created_at DESC')
    @note = Note.new
  end

  # GET /notes/1
  # GET /notes/1.json
  def show
  end

  # GET /notes/new
  def new
    @note = Note.new
  end

  # GET /notes/1/edit
  def edit
  end

  # POST /notes
  # POST /notes.json
  def create
    @note = Note.new(note_params)
    current_user.notes << @note

    # SUMMARIZER: Send post request to summarization API with given parameters
    response = Unirest.post "https://textanalysis-text-summarization.p.mashape.com/text-summarizer-text",
    headers:{
      "X-Mashape-Key" => "aosLn4ArKSmshDQj2fLRpXFdIjKep1G9sPcjsnzUapJMEo5TUT",
      "Content-Type" => "application/x-www-form-urlencoded",
      "Accept" => "application/json"
    },
    parameters:{
      "sentnum" => 1,
      "text" => @note.text
    }

    # AUTO TAGGER: Send post request to Google NL API with given parameters
    tag_scraper = Unirest.post "https://language.googleapis.com/v1/documents:analyzeEntities?key=AIzaSyA4A03W32VwKt313lZiEVD4_47P2A9lMeQ",
    headers:{
      "Content-Type" => "application/json"
    },
    parameters: JSON.generate({
        "encodingType": "UTF8",
        "document": {
          "type": "PLAIN_TEXT",
          "content": @note.text}})

    # Set up array and push relevant entities into the array, then remove repeated entities and sort it alphabetically
    tag_arr = []
    tag_scraper.body["entities"].each do |entity|
      if entity["type"] != "OTHER"
        tag_arr.push(entity["name"])
      end
    end
    tag_arr.uniq!
    tag_arr.sort_by!(&:downcase)

    @note.tag_list = tag_arr
    @note.summary = response.body["sentences"].join(" ")
    @note.creator_id = current_user.id
    respond_to do |format|
      if @note.save
        format.html { redirect_to @note, notice: 'Note was successfully created.' }
        format.json { render :show, status: :created, location: @note }
      else
        format.html { render :new }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notes/1
  # PATCH/PUT /notes/1.json
  def update

    # Resend updated text through APIs
    # SUMMARIZER: Send post request to summarization API with given parameters
    response = Unirest.post "https://textanalysis-text-summarization.p.mashape.com/text-summarizer-text",
    headers:{
      "X-Mashape-Key" => "aosLn4ArKSmshDQj2fLRpXFdIjKep1G9sPcjsnzUapJMEo5TUT",
      "Content-Type" => "application/x-www-form-urlencoded",
      "Accept" => "application/json"
    },
    parameters:{
      "sentnum" => 1,
      "text" => @note.text
    }

    # AUTO TAGGER: Send post request to Google NL API with given parameters
    tag_scraper = Unirest.post "https://language.googleapis.com/v1/documents:analyzeEntities?key=AIzaSyA4A03W32VwKt313lZiEVD4_47P2A9lMeQ",
    headers:{
      "Content-Type" => "application/json"
    },
    parameters: JSON.generate({
        "encodingType": "UTF8",
        "document": {
          "type": "PLAIN_TEXT",
          "content": @note.text}})

    # Set up array and push relevant entities into the array, then remove repeated entities and sort it alphabetically
    tag_arr = []
    tag_scraper.body["entities"].each do |entity|
      if entity["type"] != "OTHER"
        tag_arr.push(entity["name"])
      end
    end
    tag_arr.uniq!
    tag_arr.sort_by!(&:downcase)

    @note.tag_list = tag_arr
    @note.summary = response.body["sentences"].join(" ")

    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to @note, notice: 'Note was successfully updated.' }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1
  # DELETE /notes/1.json
  def destroy
    @note.destroy
    respond_to do |format|
      format.html { redirect_to notes_url, notice: 'Note was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def tagged
    if params[:tag].present?
      @notes = Note.tagged_with(params[:tag])
    else
      @notes = Note.postall
    end
  end

  def join
    @note = Note.find(params[:id])
    current_user.notes << @note
    flash[:notice] = "You have been granted access to this note."
    redirect_to note_path(@note)
  end

  def export_email
    ExportNoteMailer.export_note(current_user, Note.find(params[:id])).deliver
    flash[:notice] = "Note has been exported and sent to your email address."
    redirect_to notes_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def note_params
      params.require(:note).permit(:title, :location, :text, :summary, :tag_list)
    end
end
