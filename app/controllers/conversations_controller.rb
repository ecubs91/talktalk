class ConversationsController < ApplicationController
   before_filter :authenticate_user!
   before_filter :conversation, only: [:edit, :show, :update, :destroy]
   helper_method :mailbox, :conversation

  def index
    @conversations ||= current_user.mailbox.inbox.all
  end

  def reply
    current_user.reply_to_conversation(conversation, *message_params(:body, :subject))
    redirect_to conversation
  end

  def trash
    conversation.move_to_trash(current_user)
    redirect_to :conversations
  end

  def update
     if params[:reply_all].present?
      last_sender = @conversation.messages.last.sender
      last_receipt = @conversation.receipts_for(last_sender).last
      #logger.debug("form update: #{last_sender.inspect}")
      Rails.logger.debug("form is: #{last_receipt.inspect}")
      @receipt = current_user.reply_to_all(last_receipt, params[:body])

     redirect_to :action => :show
    end
  end

  private
 
  def mailbox
    @mailbox ||= current_user.mailbox
  end
 
  def conversation
    @conversation ||= mailbox.conversations.find(params[:id])
  end
 
  def conversation_params(*keys)
    fetch_params(:conversation, *keys)
  end
 
  def message_params(*keys)
    fetch_params(:message, *keys)
  end
 
  def fetch_params(key, *subkeys)
    params[key].instance_eval do
      case subkeys.size
      when 0 then self
      when 1 then self[subkeys.first]
      else subkeys.map{|k| self[k] }
      end
    end
  end


end