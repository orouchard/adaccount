class EntriesController < ApplicationController
  before_action :set_journal
  before_action :set_accounts, except: %i[ create destroy ]
  before_action :set_entry, except: %i[ new create ]
  
  def new
  end
  
  def create
    account = Account.find(params[:entry][:account])
    @journal.entries.create!(amount: params[:entry][:amount], flow: params[:entry][:flow], account: account)
    redirect_to check_journal_path(@journal), notice: "Journal was successfully updated."
  end

  def edit
    @entries = @journal.entries
    @entry = Entry.find(params[:id])
  end
  
  def update
    @account = Account.find(params[:entry][:account])
    @entry.update!(amount: params[:entry][:amount], flow: params[:entry][:flow], account: @account)
    redirect_to check_journal_path(@entry.journal)
  end

  def destroy
    @entry.destroy!
  
    respond_to do |format|
      format.html { redirect_to @journal, notice: "Journal was successfully updated." }
      format.json { head :no_content }
    end
  end
  
  private
  
  def set_journal
    @journal = Journal.find(params[:journal_id])
  end
  
  def set_entry
    @entry = Entry.find(params[:id])
  end
  
  def set_accounts
    @accounts = Account.where(active: true).order(:id)
  end
end
