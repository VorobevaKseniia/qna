$(document).on('turbolinks:load', function() {
  $('form.new-comment').on('ajax:error', function(e) {
    let errors = e.detail[0];
    let commentableType = $(this).data('commentable-type');
    let commentableId = $(this).data('commentable-id');
    let errorsContainer;

    if (commentableType === 'Question') {
      errorsContainer = $('.question .comment-errors');
    } else {
      errorsContainer = $(`#answer-${commentableId} .comment-errors`);
    }
    errorsContainer.empty();

    $.each(errors, function(index, value) {
      errorsContainer.append('<p>' + value + '</p>');
    });
  });

  $('form.new-comment').on('ajax:success', function() {
    $('.comment-errors').empty();
  });
});
