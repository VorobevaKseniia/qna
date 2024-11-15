$(document).on('turbolinks:load', function(){
  $('#subscription-button').on('click', function() {
    const $button = $(this);
    const subscribed = $button.data('subscribed');
    const questionId = $button.data('question-id');
    const subscriptionId = $button.data('subscription-id');

    const url = subscribed ? `/subscriptions/${subscriptionId}` : `/questions/${questionId}/subscriptions`;
    const method = subscribed ? 'DELETE' : 'POST';

    if (subscribed && !confirm('Are you sure?')) {
      return;
    }

    $.ajax({
      url: url,
      method: method,
      dataType: 'json',
      success: function(response) {
        $button
          .data('subscribed', response.subscribed)
          .data('subscription-id', response.subscribed ? response.subscription_id : null)
          .text(response.subscribed ? 'Unsubscribe' : 'Subscribe');

        showNotification(response.message);
      },
      error: function() {
        showNotification('Something went wrong. Please try again.');
      }
    });
  });

  function showNotification(message) {
    $('.notification-info').html(message).show().delay(3000).hide(0);
  }
});
