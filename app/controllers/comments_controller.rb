class CommentsController < InheritedResources::Base

  private

    def comment_params
      params.require(:comment).permit(:user_id, :blog_id, :reply)
    end
end

