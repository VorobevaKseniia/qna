import consumer from "./consumer"

consumer.subscriptions.create("QuestionsChannel", {
  connected() {
    console.log('Connected to QuestionsChannel');
  },

  disconnected() {
    console.log('Disconnected from QuestionsChannel');
  },

  received(data) {
    $('.questions').append(`<h2><a href="questions/${data.id}">${data.title}</a></h2>`);
  }
});