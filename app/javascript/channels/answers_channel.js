import consumer from "./consumer";

consumer.subscriptions.create(
  { channel: "AnswersChannel", question_id: gon.question_id },
  {
    connected() {
      console.log("Connected to AnswersChannel");
    },

    disconnected() {
      console.log("Disconnected from AnswersChannel");
    },

    received(data) {
      if (data.errors) {
        const errorsHtml = data.errors.map(error => `<p>${error}</p>`).join('');
        document.querySelector('.answer-errors').innerHTML = errorsHtml;
      } else {
        const isAuthor = gon.current_user && gon.current_user.id === data.answer.user_id;
        const isLoggedIn = !!gon.current_user;

        const generateVotingHtml = (answer, isLoggedIn, likes, dislikes, rating) => {
          if (isLoggedIn) {
            return `
          <button 
            class="vote-button upvote" 
            data-votable-id="${answer.id}" 
            data-votable-type="Answer" 
            data-value="1" 
            data-remote="true" 
            data-method="post">
            ▲
            <span id="likes-${answer.id}">${likes}</span>
          </button>
          <span id="rating-${answer.id}">${rating}</span>
          <button 
            class="vote-button downvote" 
            data-votable-id="${answer.id}" 
            data-votable-type="Answer" 
            data-value="-1" 
            data-remote="true" 
            data-method="post">
            ▼
            <span id="dislikes-${answer.id}">${dislikes}</span>
          </button>
        `;
          } else {
            return `
          <div class="rating">
            <button class="vote-button" onclick="showLoginAlert()">▲</button>
            <span>${likes}</span>
            <span>${rating}</span>
            <button class="vote-button" onclick="showLoginAlert()">▼</button>
            <span>${dislikes}</span>
          </div>
        `;
          }
        };

        const generateFilesHtml = (files) => {
          if (!files || files.length === 0) return "";
          return files.map(file => `<a href="${file.url}">${file.filename}</a>`).join("");
        };

        const generateLinksHtml = (links) => {
          if (!links || links.length === 0) return "";
          return `
        <p>Links:</p>
        <ul>
          ${links.map(link => `<li><a href="${link.url}">${link.name}</a></li>`).join("")}
        </ul>
      `;
        };

        const answerHtml = `
      <div id="answer-${data.answer.id}" class="answer">
        <div class="rating-answer-row">
          <div class="rating">
            ${generateVotingHtml(data.answer, isLoggedIn, data.likes, data.dislikes, data.rating)}
          </div>
          <div class="answer-body">
            <h2>${data.answer.body}</h2>
            ${data.answer.best ? "<p>Best answer</p>" : ""}
          </div>
        </div>
        
        ${isAuthor
          ? `
          <a href="#" class="edit-answer-link" data-answer-id="${data.answer.id}">Edit</a> |
          <a href="/answers/${data.answer.id}" data-confirm="Are you sure?" data-remote="true" rel="nofollow" data-method="delete">Delete answer</a>
          `
          : ""}
        
        <div class="files">${generateFilesHtml(data.files)}</div>
        <div class="links">${generateLinksHtml(data.links)}</div>
      </div>
    `;
        document.querySelector(".answers").insertAdjacentHTML("beforebegin", 'Your answer successfully created.');
        document.querySelector(".answers").insertAdjacentHTML("beforeend", answerHtml);
        document.querySelector('.new-answer #answer_body').value = '';
        document.querySelector('.new-answer #answer_files').value = '';
        document.querySelectorAll('.new-answer .nested-fields').forEach(field => field.remove());
        console.log("Received data:", data);
      }
    }
  }
);
