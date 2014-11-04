class MyRecordsController < ApplicationController
  before_action :set_my_record, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  # GET /my_records
  # GET /my_records.json
  def index
    @my_records = MyRecord.all
  end

  # GET /my_records/1
  # GET /my_records/1.json
  def show
  end

  # GET /my_records/new
  def new
    @my_record = MyRecord.new
  end

  # GET /my_records/1/edit
  def edit
  end

  # POST /my_records
  # POST /my_records.json
  def create
    # puts("params " + my_record_params[:my_record][:name])

    if params[:my_record][:file_name].present? && params[:my_record][:file_name].content_type.split("/")[0] != "audio" && params[:my_record][:file_name].content_type.split("/")[0] != "video"
      puts("BAD " + params[:my_record][:file_name].content_type.split("/")[0])
    end

    # respond_to do |format|
    #   if params[:my_record][:file_name].present? && params[:my_record][:file_name].content_type.split("/")[0] != "audio"
    #     format.html { redirect_to :new, notice: 'Record BAD' }
    #     format.json { render json: @my_record.errors, status: :unprocessable_entity }
    #   end
    # end

    respond_to do |format|
      if params[:my_record][:file_name].present? && params[:my_record][:file_name].content_type.split("/")[0] != "audio" && params[:my_record][:file_name].content_type.split("/")[0] != "video"
        @my_record = MyRecord.new
        format.html { redirect_to '/my_records/new',  alert: 'Unsupported format.' }
      else
        @my_record = MyRecord.new(my_record_params)
        if @my_record.save
          AudioConverterWorker.perform_async(@my_record.id)
          format.html { redirect_to my_records_url, notice: 'Record was successfully created.' }
          format.json { render :show, status: :created, location: @my_record }
        else
          format.html { render :new }
          format.json { render json: @my_record.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /my_records/1
  # PATCH/PUT /my_records/1.json
  def update
    respond_to do |format|
      if @my_record.update(my_record_params)
        format.html { redirect_to @my_record, notice: 'Record was successfully updated.' }
        format.json { render :show, status: :ok, location: @my_record }
      else
        format.html { render :edit }
        format.json { render json: @my_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /my_records/1
  # DELETE /my_records/1.json
  def destroy
    @my_record.destroy
    respond_to do |format|
      format.html { redirect_to my_records_url, notice: 'Record was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_my_record
      @my_record = MyRecord.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def my_record_params

      if params[:my_record][:name] == ''
        params[:my_record][:name] = params[:my_record][:file_name].original_filename.split(".")[0]
      end

      if params[:my_record][:author] == ''
        params[:my_record][:author] = false
      end

      unic_name = Random.rand(1000...9999).to_s + Date.today.strftime("%d%m%Y%m%s")

      upload(unic_name)

      params[:my_record][:unic_name] = unic_name

      params[:my_record][:size] = params[:my_record][:file_name].size

      params[:my_record][:file_name] = params[:my_record][:file_name].original_filename

      params.require(:my_record).permit(:user_id, :name, :author, :file_name, :unic_name, :size)

    end

    def upload(unic_name)

      ext = params[:my_record][:file_name].original_filename.split(".")[1]

      File.open(Rails.root.join('public', 'uploads', unic_name + "." + ext), 'wb') do |file|
        file.write(params[:my_record][:file_name].read)
      end

    end

end
