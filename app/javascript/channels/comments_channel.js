import consumer from "./consumer";

$(document).on('turbolinks:load', function() {
  document.querySelectorAll('form.new-comment').forEach(form => {
    const commentableType = form.dataset.commentableType;
    const commentableId = form.dataset.commentableId;

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
            let commentsContainer;
            if (commentableType === "Question") {
              commentsContainer = document.querySelector(".question .comments");
            } else if (commentableType === "Answer") {
              commentsContainer = document.querySelector(`#answer-${commentableId} .comments`);
            }

            if (commentsContainer && data.body) {
              const commentHtml = `<div class="comment"><p>${data.body}</p></div>`;
              commentsContainer.insertAdjacentHTML("beforeend", commentHtml);
              form.querySelector("textarea").value = '';
            } else {
              console.error("Invalid data structure:", data);
            }
          }
        }
      );
    } else {
      console.error("Missing commentableType or commentableId for CommentsChannel subscription.");
    }
  });
});
