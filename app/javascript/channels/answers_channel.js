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
      const answerHtml = `
      <div id="answer-${data.id}" class="answer new">
        <h2 class="relative">${data.body}<span class="badge">new</span></h2>
      </div>
    `;

      document.querySelector(".answers").insertAdjacentHTML("beforeend", answerHtml);
      document.querySelector('.new-answer #answer_body').value = '';
      document.querySelector('.new-answer #answer_files').value = '';
      document.querySelectorAll('.new-answer .nested-fields').forEach(field => field.remove());
      console.log("Received data:", data);
    }
  }
);
