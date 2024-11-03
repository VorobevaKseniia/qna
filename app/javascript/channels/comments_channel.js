import consumer from "./consumer";

$(document).on('turbolinks:load', function() {
  document.querySelectorAll('.new-comment').forEach(element => {
    const commentableType = element.dataset.commentableType;
    const commentableId = element.dataset.commentableId;

    if (commentableType && commentableId) {
      consumer.subscriptions.create(
        {
          channel: "CommentsChannel",
          commentable_type: commentableType,
          commentable_id: commentableId
        },
        {
          connected() {
            console.log(`Connected to CommentsChannel for ${commentableType} with ID ${commentableId}`);
          },
          disconnected() {
            console.log(`Disconnected from CommentsChannel for ${commentableType} with ID ${commentableId}`);
          },
          received(data) {
            console.log("Received data:", data);

            if (data.errors) {
              const errorsHtml = data.errors.map(error => `<p>${error}</p>`).join('');
              if (commentableType === "Question") {
                document.querySelector('.question .comment-errors').innerHTML = errorsHtml;
              } else if (commentableType === "Answer") {
                document.querySelector(`#answer-${commentableId} .comment-errors`).innerHTML = errorsHtml;
              }
            } else {
              let commentsContainer;
              if (commentableType === "Question") {
                commentsContainer = document.querySelector(".question .comments");
              } else if (commentableType === "Answer") {
                commentsContainer = document.querySelector(`#answer-${commentableId} .comments`);
              }
              if (commentsContainer) {
                const commentHtml = `<div class="comment"><p>${data.comment.body}</p></div>`;
                commentsContainer.insertAdjacentHTML("beforeend", commentHtml);
                element.querySelector("textarea").value = '';
              }
            }
          }
        }
      );
    } else {
      console.error("Missing commentableType or commentableId for CommentsChannel subscription.");
    }
  });
});
